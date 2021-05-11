from flask import Flask
from flask_restful import Resource, Api, reqparse
from flask_ngrok import run_with_ngrok
import pyrebase
import urllib
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import keras
import re
import nltk
from nltk.corpus import stopwords
import string
import json
from time import time
import pickle
from keras.applications.vgg16 import VGG16
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input, decode_predictions
from keras.preprocessing import image
from keras.preprocessing.image import load_img
from tensorflow.keras.models import Model, load_model
from keras.preprocessing.sequence import pad_sequences
from keras.utils.np_utils import to_categorical
from tensorflow.keras.layers import Input, Dense, Dropout, Embedding, LSTM
from tensorflow.keras.layers import add
import cv2
import os
import matplotlib.pyplot as plt
import collections
from PIL import Image
app = Flask(__name__)
api = Api(app)
run_with_ngrok(app)
user_post_arguments = reqparse.RequestParser()
user_post_arguments.add_argument("uid",type = str,required=True)
user_post_arguments.add_argument("imgId",type=str,required=True)
config={
    "apiKey": "AIzaSyB95PTXJko74n-FKk5G1tcFSqXuGmqPh3I",
    "authDomain": "project-capty.firebaseapp.com",
    "projectId": "project-capty",
    "storageBucket": "project-capty.appspot.com",
    "messagingSenderId": "238787309344",
    "appId": "1:238787309344:web:65e1cdcb520b7c10dd3145",
    "measurementId": "G-688Z0WJJ1H",
    "databaseURL":"project-capty.appspot.com"
    }  
firebase = pyrebase.initialize_app(config)
storage = firebase.storage()

#put all your func here above the Class
def readTextFile(path):
    with open(path) as f:
        captions = f.read()
    return captions

captions  = readTextFile("FlaskApiCaptydatacaptions.txt")
captions = captions.split('\n')[:-1]

descriptions = {}

for x in captions:
    first = x.split(',')[0]
    second = (x.split(',')[1:])
    img_name = first.split('.')[0]
    #print(second)
    
    #if image id present or not
    if descriptions.get(img_name) is None:
        descriptions[img_name] = []
        
    #if list already exists
    for x in second:
        descriptions[img_name].append(x)
        
def clean_text(sentence):
    sentence = sentence.lower()
    sentence = re.sub("[^a-z]+", " ", sentence)
    sentence = sentence.split()
    
    sentence = [s for s in sentence if len(s)>1]
    sentence = " ".join(sentence)
    return sentence

#clean_text("I am Gaurav Poosarla and am 19 years old")

for key, caption_list in descriptions.items():
        for i in range(len(caption_list)):
            caption_list[i] = clean_text(caption_list[i])
            
descriptions = None
with open("FlaskApiCaptydescriptions_1.txt",'r') as f:
    descriptions = f.read()
json_acceptable_string = descriptions.replace("'", "\"")   
descriptions = json.loads(json_acceptable_string)
    
vocab = set()
for key in descriptions.keys():
    [vocab.update(sentence.split()) for sentence in descriptions[key]]
    
total_words = []

for key in descriptions.keys():
    [total_words.append(i) for des in descriptions[key] for i in des.split()]
    
counter = collections.Counter(total_words)
freq_cnt = dict(counter)

sorted_freq_cnt = sorted(freq_cnt.items(),reverse=True,key=lambda x:x[1])

threshold = 10
sorted_freq_cnt  = [x for x in sorted_freq_cnt if x[1]>threshold]
total_words = [x[0] for x in sorted_freq_cnt]

model = ResNet50(weights="imagenet",input_shape=(224,224,3))

model_new = Model(model.input,model.layers[-2].output)

def preprocess_img(img):
    img = image.load_img(img,target_size=(224,224))
    img = image.img_to_array(img)
    img = np.expand_dims(img,axis=0)
    #print(img.shape)
    # Normalisation
    img = preprocess_input(img)
    return img

def encode_image(img):
    img = preprocess_img(img)
    #print(img.shape)
    feature_vector = model_new.predict(img)
    
    feature_vector = feature_vector.reshape((-1,))
    #print(feature_vector.shape)
    return feature_vector

word_to_idx = {}
idx_to_word = {}

for i,word in enumerate(total_words):
    word_to_idx[word] = i+1
    idx_to_word[i+1] = word


# Two special words
idx_to_word[1846] = 'startseq'
word_to_idx['startseq'] = 1846

idx_to_word[1847] = 'endseq'
word_to_idx['endseq'] = 1847

vocab_size = len(word_to_idx) + 1
max_len = 35


f = open("FlaskApiCaptyglove.6B.50d.txt",encoding='utf8')

embedding_index = {}

for line in f:
    values = line.split()
    
    word = values[0]
    word_embedding = np.array(values[1:],dtype='float')
    embedding_index[word] = word_embedding

f.close()


def get_embedding_matrix():
    emb_dim = 50
    matrix = np.zeros((vocab_size,emb_dim))
    for word,idx in word_to_idx.items():
        embedding_vector = embedding_index.get(word)
        
        if embedding_vector is not None:
            matrix[idx] = embedding_vector
    return matrix

model = load_model("FlaskApiCaptymodel_weightsmodel_9.h5")

def predict_caption(photo):
    
    in_text = "startseq"
    for i in range(max_len+4):
        sequence = [word_to_idx[w] for w in in_text.split() if w in word_to_idx]
        sequence = pad_sequences([sequence],maxlen=max_len,padding='post')
        
        ypred = model.predict([photo,sequence])
        ypred = ypred.argmax() #WOrd with max prob always - Greedy Sampling
        word = idx_to_word[ypred]
        in_text += (' ' + word)
        
        if word == "endseq":
            break
    
    final_caption = in_text.split()[1:-1]
    final_caption = ' '.join(final_caption)
    return final_caption

      
class ImageToText(Resource):
  def post(self):
      args = user_post_arguments.parse_args()
      url = storage.child(str(args["uid"])+'/'+str(args["imgId"])).get_url(None)
      urllib.request.urlretrieve(url,str(args["imgId"]))
      img = Image.open(str(args["imgId"]))
      img = cv2.imread(str(args["imgId"]))
      #print(img.shape)
      img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
      #inp = load_img(image,target_size=(256,256))
      #inp = img_to_array(image)
      #img = load_img('/data/test.jpg')
      photo_2048 = encode_image(str(args["imgId"]))
      photo_2048 = photo_2048.reshape((1,2048))
      #print(photo_2048.shape)
      plt.imshow(img)
      plt.axis("off")
      caption = predict_caption(photo_2048)
      os.remove(str(args["imgId"]))
      return {"res":caption}     
  
   
api.add_resource(ImageToText, '/getData')    
if __name__ == "__main__":
  app.run()



#to run use python app.py in terminal
#to pass req use add reqbin as an extension in browser
#after adding reqbin as extension open reqbin.com
#paste the url shown in terminal in reqbin
# req type = POST
#in content tab of req bin paste{"uid":"Kree3G4eLlgCf62A9hWl46wPtWu1","imgId":"7720478.jpg"} including brackets.




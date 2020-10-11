#!/usr/bin/env python
# encoding: utf-8
import json
from flask import Flask, request, jsonify, abort, make_response
import time
import logging
#Create the word frequency table
from nltk.corpus import stopwords
from nltk.tokenize import * #sent_tokenize
from nltk.stem import PorterStemmerv

app = Flask(__name__)

logging.basicConfig(level=logging.DEBUG)


summarized_lessons = [
    {
        'id': 1,
        'title': u'Lesson 1',
        'result': u'Sunset is the time of day when our sky meets the outer space solar winds. There are blue, pink, and purple swirls, spinning and twisting, like clouds of balloons caught in a whirlwind. The sun moves slowly to hide behind the line of horizon, while the moon races to take its place in prominence atop the night sky.'
    },
    {
        'id': 2,
        'title': u'Lesson 2',
        'result': u'People slow to a crawl, entranced, fully forgetting the deeds that must still be done. There is a coolness, a calmness, when the sun does set.'
    }
  
]


@app.route('/')
def index():
    return jsonify({'hello': 'world'})

# curl -i http://localhost:5000/summarizer/api/v1.0/lessons
@app.route('/summarizer/api/v1.0/lessons', methods=['GET'])
def get_lessons():

    # REMOVE THIS: Wait for 1 seconds
    time.sleep(1)

    return jsonify({'lessons': summarized_lessons})

# curl -i http://localhost:5000/summarizer/api/v1.0/lessons/2
@app.route('/summarizer/api/v1.0/lessons/<int:lesson_id>', methods=['GET'])
def get_lesson(lesson_id):
    lesson = [lesson for lesson in summarized_lessons if lesson['id'] == lesson_id]
    if len(lesson) == 0:
        abort(404)
    
    # REMOVE THIS: Wait for 1 seconds
    time.sleep(1)

    return jsonify({'lesson': lesson[0]})

# curl -i -H "Content-Type: application/json" -X POST -d "{\"transcript\":\"Read a book\"}" http://localhost:5000/summarizer/api/v1.0/summarize
@app.route('/summarizer/api/v1.0/summarize', methods=['POST'])
def post_lesson():
    if not request.json or not 'transcript' in request.json:
        abort(400)
    
    #TODO: call function for summary
    text= "This course is a high-level overview of artificial intelligence (AI) for people with little or no knowledge of computer science and statistics. In it we’ll cover the essential concepts of AI and show you how to apply custom AI solutions with free, easy to use tools, all in your browser.The course will show you some some simple but powerful ways that data scientists make predictions about objects, people, and the future. Later, we’ll cover exciting, complex topics you may have heard of, such as neural networks, computer vision, deep learning, and unsupervised learning.In this lesson we’ll introduce you to some key concepts and get you trying out some AI tools.AI is the study of how to make computers perform tasks that humans consider difficult through the creation of intelligent agents. The study of AI began in the 1950s, and it has improved dramatically over time with better statistical methods and greater computing power.AI is now used for all sorts of things, such as intelligent opponents in video games, accurate medical diagnosis, speech commands on mobile phones, and keeping email inboxes clear of spam. People who use AI often want it to perform repetitive tasks that take a lot of time for a person to do, or to solve problems which seem almost impossible to solve with a calculator."
    ft =create_frequency_table(text)
    #split the text into a set of sentences: tokenize the sentences    
    sentences = sent_tokenize(text)
    ss = score_sentences(sentences, ft)
    threshold = find_average_score(ss)
    summarization = generate_summary(sentences, ss, threshold)

    # REMOVE THIS: Wait for 1 seconds
    time.sleep(1)



    return jsonify({'lessons': summarization}), 200


    
@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)



def create_frequency_table(text_string):
    stopWords = set(stopwords.words("english"))
    words = word_tokenize(text_string)
    ps = PorterStemmer()

    freqTable = {}
    for word in words:
        word = ps.stem(word)
        if word in stopWords:
            continue
        if word in freqTable:
            freqTable[word] += 1
        else:
            freqTable[word] = 1
    return freqTable





#score a sentence by its words, adding the frequency of every non-stop word in a sentence
# to save memory, only take 1st 10 characters in each sentence
def score_sentences(sentences, freqTable):
    sentenceValue = {}
    for sentence in sentences:
        word_count_in_sentence = (len(word_tokenize(sentence)))
        for wordValue in freqTable:
            if wordValue in sentence.lower():
                if sentence[:10] in sentenceValue:
                    sentenceValue[sentence[:10]] += freqTable[wordValue]
                else:
                    sentenceValue[sentence[:10]] = freqTable[wordValue]

        sentenceValue[sentence[:10]] = sentenceValue[sentence[:10]] // word_count_in_sentence

    return sentenceValue

# take the average score of the sentences as a threshold
def find_average_score(sentenceValue):
    sumValues = 0
    for entry in sentenceValue:
        sumValues += sentenceValue[entry]
    # Average value of a sentence from original text
    average = int(sumValues / len(sentenceValue))
    return average


def generate_summary(sentences, sentenceValue, threshold):
    sentence_count = 0
    summary = ''
    for sentence in sentences:
        if sentence[:10] in sentenceValue and sentenceValue[sentence[:10]] > (threshold):
            summary += " " + sentence
            sentence_count += 1
    return summary



if __name__ == '__main__':
    app.run(debug=True)



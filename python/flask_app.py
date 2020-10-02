#!/usr/bin/env python
# encoding: utf-8
import json
from flask import Flask, request, jsonify, abort, make_response
import time
import logging

app = Flask(__name__)

logging.basicConfig(level=logging.DEBUG)

tasks = [
    {
        'id': 1,
        'title': u'Buy groceries',
        'description': u'Milk, Cheese, Pizza, Fruit, Tylenol', 
        'done': False
    },
    {
        'id': 2,
        'title': u'Learn Python',
        'description': u'Need to find a good Python tutorial on the web', 
        'done': False
    }
]

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

    # REMOVE THIS: Wait for 1 seconds
    time.sleep(1)

    return jsonify({'lessons': summarized_lessons}), 201


    
@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug=True)
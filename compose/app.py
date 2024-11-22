import time

import redis
from flask import Flask, request

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

@app.route('/', methods=['GET'])
def hello():
    msg = cache.get('post')
    if msg == None:
        cache.set('post','no post yet')
        msg = cache.get('post')

    return f'{msg}\n'

@app.route('/', methods=['POST'])
def hook():
    msg = request.get_data()
    cache.set('post', msg)

    return "200"

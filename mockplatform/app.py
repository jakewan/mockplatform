import argparse
from asyncio import sleep
import os

from sanic import Sanic
from sanic import response

app = Sanic(name='PlatformsApp')


def send_bytes(count):
    async def _inner(response):
        chunk = bytes(os.urandom(count))
        await response.write(chunk)
    return _inner


@app.route('/')
async def index(request):
    return response.text('hello')


@app.route('/bytes/<count:int>')
async def random_bytes(request, count):
    assert count >= 0
    return response.stream(
        send_bytes(count),
        content_type='application/octet-stream'
    )


@app.route('/bytes/<count:int>/delay/<delay:int>')
async def random_bytes_with_delay(request, count, delay):
    assert count >= 0
    assert delay >= 0
    await sleep(delay)
    return response.stream(
        send_bytes(count),
        content_type='application/octet-stream'
    )


def run():
    parser = argparse.ArgumentParser()
    parser.add_argument('--forwarded-secret', required=True)
    args = parser.parse_args()
    app.config.FORWARDED_SECRET = args.forwarded_secret
    app.run(host='127.0.0.1', port=8000)

import argparse
import os

from sanic import Sanic
from sanic import response

app = Sanic(name='PlatformsApp')
chunk = None


def make_chunk():
    return bytes(os.urandom(1555000))


@app.route('/')
async def index(request):
    return response.text('hello')


@app.route('/measurements/chunk')
async def chunk_file(request):
    async def _inner(response):
        await response.write(chunk)

    return response.stream(
        _inner,
        content_type='application/octet-stream'
    )


def run():
    parser = argparse.ArgumentParser()
    parser.add_argument('--forwarded-secret', required=True)
    args = parser.parse_args()
    global chunk
    chunk = make_chunk()
    app.config.FORWARDED_SECRET = args.forwarded_secret
    app.run(host='127.0.0.1', port=8000)

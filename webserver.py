#!/usr/bin/env python3
import os
import socket
import sys
from subprocess import call
from tempfile import TemporaryDirectory

from flask import Flask, request, send_file

app = Flask(__name__)

@app.route('/', methods=['POST'])
def handle_file():
    assert 'file' in request.files
    with TemporaryDirectory() as temp_dir:
        file = request.files['file']
        file_path_in = os.path.join(temp_dir, file.filename)
        # TODO: should throw an explicit error
        assert file_path_in.endswith('.pdf')
        file.save(file_path_in)
        file_path_out = file_path_in + ".txt"
        call(["/usr/bin/pdftotext", file_path_in, file_path_out])
        r = send_file(file_path_out)
        return r


if __name__ == "__main__":
    ip = socket.gethostbyname(socket.gethostname())
    print("start listening:", ip, file=sys.stderr)
    app.run(host='0.0.0.0', port=80)

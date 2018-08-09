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
    with TemporaryDirectory() as temp_dir:
        if 'file' in request.files:
            file = request.files['file']
            file_path_in = os.path.join(temp_dir, file.filename)
            # TODO: should throw an explicit error
            assert file_path_in.endswith('.pdf')
            file.save(file_path_in)
        else:
            file_path_in = os.path.join(temp_dir, "unnamed.pdf")
            data = request.stream.read()
            with open(file_path_in, 'wb') as f:
                f.write(data)
            sys.stdout.flush()
        file_path_out = file_path_in + ".txt"
        call(["/usr/bin/pdftotext", file_path_in, file_path_out])
        with open(file_path_out, 'r') as f:
            r = f.read()
        return r.rstrip("\f")


if __name__ == "__main__":
    host = "0.0.0.0"
    port = 8080
    ip = socket.gethostbyname(socket.gethostname())
    print("start listening:", ip, host + ":" + str(port), file=sys.stderr)
    app.run(host=host, port=port)

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

        if len(request.files) != 1:
            return "You must upload one PDF file for processing", 400

        files_dict = request.files.to_dict()

        for key in files_dict:
            file = files_dict[key]
            file_path_in = os.path.join(temp_dir, file.filename)

            if not file_path_in.lower().endswith('.pdf'):
                return "Only .PDF files are allowed", 400

            file.save(file_path_in)

        file_path_out = file_path_in + ".txt"

        cmd = ["/usr/bin/pdftotext"]

        params = request.args.get('params')

        if params:
            cmd.append(params)

        cmd.extend([file_path_in, file_path_out])

        call(cmd)

        return send_file(file_path_out)


if __name__ == "__main__":
    host = "0.0.0.0"
    port = 8888
    ip = socket.gethostbyname(socket.gethostname())
    print("start listening:", ip, host + ":" + str(port), file=sys.stderr)
    app.run(host=host, port=port)

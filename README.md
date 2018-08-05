[![Build Status](https://travis-ci.com/sdenel/pdftotext-docker-rest.svg?branch=master)](https://travis-ci.com/sdenel/pdftotext-docker-rest)

pdftotext. As a webservice, containerized! The image is based on Alpine.

## Usage

```bash
docker run -d -p8080:80 sdenel/pdftotext-docker-rest:latest
```
Then, to test it:
```bash
wget http://www.xmlpdf.com/manualfiles/hello-world.pdf
curl -F "file=@hello-world.pdf;" http://localhost:8080/
```

# Contributions welcomed!
Still to do: allow usage of pdttotext options.

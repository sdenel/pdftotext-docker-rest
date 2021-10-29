[![Build Status](https://travis-ci.com/sdenel/pdftotext-docker-rest.svg?branch=master)](https://travis-ci.com/sdenel/pdftotext-docker-rest)

pdftotext. As a webservice, containerized! The image is based on Alpine. See also image on Docker Hub: [sdenel/pdftotext-docker-rest](https://hub.docker.com/repository/docker/sdenel/pdftotext-docker-rest)

## Usage

```bash
docker run -d -p8888:8888 ghcr.io/sdenel/pdftotext-docker-rest:latest
```
Example of usage:
```bash
wget http://www.xmlpdf.com/manualfiles/hello-world.pdf
curl -F "file=@hello-world.pdf;" http://localhost:8888/
```

# Contributions welcomed!
* Still to do: allow usage of pdttotext options.

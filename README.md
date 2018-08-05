[![Build Status](https://travis-ci.com/sdenel/pdftotext-docker-rest.svg?branch=master)](https://travis-ci.com/sdenel/pdftotext-docker-rest)

pdftotext. As a webservice, containerized!

## Usage

```bash
docker run -d --name pdf2htmlex sdenel/pdftotext-docker-rest

wget http://www.xmlpdf.com/manualfiles/hello-world.pdf
PDFTOTEXT_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' pdf2htmlex`
curl -F "file=@hello-world.pdf;" http://$PDFTOTEXT_IP/ > hello-world.html
```

# Contributions welcomed!
Still to do: allow usage of pdttotext options.

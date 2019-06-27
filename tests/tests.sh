#!/usr/bin/env sh
set -e

pycodestyle --first webserver.py

docker build . -t pdftotext-docker-rest
docker run -d --name pdftotext-docker-rest pdftotext-docker-rest
sleep 5

curl http://www.xmlpdf.com/manualfiles/hello-world.pdf -o tests/hello-world.pdf
PDFTOTEXT_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' pdftotext-docker-rest`

#
# Simple text
#
curl -v -F "file=@tests/hello-world.pdf;" http://$PDFTOTEXT_IP:8888/ > tests/hello-world.tmp.txt
if [ "`cat tests/hello-world.tmp.txt`" != "`cat tests/hello-world-expected.txt`" ]
then
  echo -e "\n\e[91mStep 1: hello-world.txt != hello-world-expected.txt\e[39m"
  exit 1
fi
rm tests/hello-world.tmp.txt

#
# PDF provided in binary (application/octet-stream), not as a file
#
curl -v --header "Content-Type:application/octet-stream" --data-binary "@tests/hello-world.pdf" http://$PDFTOTEXT_IP:8888/ > tests/hello-world.tmp.txt
if [ "`cat tests/hello-world.tmp.txt`" != "`cat tests/hello-world-expected.txt`" ]
then
  echo -e "\n\e[91mStep 2: hello-world.txt != hello-world-expected.txt\e[39m"
  exit 1
fi
rm tests/hello-world.tmp.txt

#
# PDF with accents
#
curl -v -F "file=@tests/accents.pdf;" http://$PDFTOTEXT_IP:8888/ > tests/accents.tmp.txt
if [ "`cat tests/accents.tmp.txt`" != "`cat tests/accents-expected.txt`" ]
then
  echo -e "\n\e[91mStep 1: accents.txt != accents-expected.txt\e[39m"
  exit 1
fi
rm tests/accents.tmp.txt

docker rm -f pdftotext-docker-rest

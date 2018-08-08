#!/usr/bin/env sh
set -e

pycodestyle --first webserver.py

docker build . -t pdftotext-docker-rest
docker run -d --name pdftotext-docker-rest pdftotext-docker-rest
sleep 5

wget http://www.xmlpdf.com/manualfiles/hello-world.pdf
PDFTOTEXT_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' pdftotext-docker-rest`

curl -v -F "file=@hello-world.pdf;" http://$PDFTOTEXT_IP:8080/ > hello-world.txt
echo -n "hello world\n\n\f" > hello-world-expected.txt
if [ "`cat hello-world.txt`" != "`cat hello-world-expected.txt`" ]
then
  echo -e "\n\e[91mStep 1: hello-world.txt != hello-world-expected.txt\e[39m"
  exit 1
fi
rm hello-world.txt

curl -v --header "Content-Type:application/octet-stream" --data-binary "@hello-world.pdf" http://$PDFTOTEXT_IP:8080/ > hello-world.txt
echo -n "hello world\n\n\f" > hello-world-expected.txt
if [ "`cat hello-world.txt`" != "`cat hello-world-expected.txt`" ]
then
  echo -e "\n\e[91mStep 2: hello-world.txt != hello-world-expected.txt\e[39m"
  exit 1
fi


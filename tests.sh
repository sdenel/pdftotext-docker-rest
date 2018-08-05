#!/usr/bin/env sh
set -e

pycodestyle --first webserver.py

docker build . -t pdftotext-docker-rest
docker run -d --name pdftotext-docker-rest pdftotext-docker-rest
sleep 5

wget http://www.xmlpdf.com/manualfiles/hello-world.pdf
PDFTOTEXT_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' pdftotext-docker-rest`
curl -F "file=@hello-world.pdf;" http://$PDFTOTEXT_IP/ > hello-world.txt

echo -n "hello world\n\n\f" > hello-world-expected.txt
if [ "`cat hello-world.txt`" != "`cat hello-world-expected.txt`" ]
then
  echo -e "\n\e[91mhello-world.txt != hello-world-expected.txt\e[39m"
  exit 1
fi

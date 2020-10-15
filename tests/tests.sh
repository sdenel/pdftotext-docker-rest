#!/usr/bin/env sh
set -e

pycodestyle --first webserver.py --max-line-length=120

docker build . -t pdftotext-docker-rest
docker run -d --name pdftotext-docker-rest pdftotext-docker-rest
sleep 5

curl http://www.xmlpdf.com/manualfiles/hello-world.pdf -o tests/hello-world.pdf
PDFTOTEXT_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' pdftotext-docker-rest`

echo "#"
echo "# Simple text"
echo "#"
curl -v -s -f -F "file=@tests/hello-world.pdf;" http://$PDFTOTEXT_IP:8888/ | tee tests/hello-world.tmp.txt
if [ "`cat tests/hello-world.tmp.txt`" != "`cat tests/hello-world-expected.txt`" ]
then
  echo -e "\n\e[91mStep 1: hello-world.tmp.txt != hello-world-expected.txt\e[39m"
  exit 1
fi
rm tests/hello-world.tmp.txt
echo "ok\n"

echo "#"
echo "# PDF provided in binary (application/octet-stream), not as a file"
echo "#"
curl -v -s -f --header "Content-Type:application/octet-stream" --data-binary "@tests/hello-world.pdf" http://$PDFTOTEXT_IP:8888/ | tee tests/hello-world.tmp.txt
if [ "`cat tests/hello-world.tmp.txt`" != "`cat tests/hello-world-expected.txt`" ]
then
  echo -e "\n\e[91mStep 2: hello-world.txt != hello-world-expected.txt\e[39m"
  exit 1
fi
rm tests/hello-world.tmp.txt
echo "ok\n"

echo "#"
echo "# PDF with accents"
echo "#"
curl -v -s -F "file=@tests/accents.pdf;" http://$PDFTOTEXT_IP:8888/ | tee tests/accents.tmp.txt
if [ "`cat tests/accents.tmp.txt`" != "`cat tests/accents-expected.txt`" ]
then
  echo -e "\n\e[91mStep 1: accents.txt != accents-expected.txt\e[39m"
  exit 1
fi
rm tests/accents.tmp.txt
echo "ok\n"


docker rm -f pdftotext-docker-rest

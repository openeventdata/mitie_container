FROM ubuntu:14.04

MAINTAINER Casey Hilland <chilland@caerusassociates.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y git build-essential wget tar cmake python-setuptools
RUN easy_install pip

ADD . /src

RUN cd src; git clone https://github.com/mit-nlp/MITIE.git
RUN cd src/MITIE; make MITIE-models
RUN cd src/MITIE/mitielib; mkdir build
RUN cd src/MITIE/mitielib/build; cmake ..
RUN cd src/MITIE/mitielib/build; cmake --build . --config Release --target install

RUN cd /src; pip install -r requirements.txt

EXPOSE 5001

CMD ["python", "/src/mitie_api.py"]

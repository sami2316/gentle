FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y \
		gcc g++ gfortran \
		sox \
		libc++-dev \
		libstdc++-6-dev zlib1g-dev \
		automake autoconf libtool \
		git subversion \
		libatlas3-base \
		ffmpeg \
		python3.7 python3-dev python3-pip \
		python2.7 python-dev python-pip \
		wget unzip && \
	apt-get clean

WORKDIR /gentle/ext
ADD ext /gentle/ext
RUN export MAKEFLAGS=' -j8'
RUN ./install_kaldi.sh
RUN make depend && make && rm -rf kaldi *.o

ADD . /gentle
WORKDIR /gentle
RUN python3.7 setup.py develop
RUN ./install_models.sh

EXPOSE 8765

VOLUME /gentle/webdata

CMD python3.7 serve.py
#CMD ["/bin/bash"]

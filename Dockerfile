FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -y netbase python
ADD https://raw.github.com/pypa/pip/master/contrib/get-pip.py /get-pip.py    
RUN python /get-pip.py
# Use source tarball while devpi>=2.0.5 is not released
ADD https://bitbucket.org/hpk42/devpi/get/03016ba5c5c8.tar.gz /devpi.tar.gz
RUN tar zxf /devpi.tar.gz
RUN cd /hpk42-devpi-* && pip install ./common/ ./server/ ./client/ ./web/ .
VOLUME /mnt
EXPOSE 3141
ADD run.sh /
CMD ["/run.sh"]

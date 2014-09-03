FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -y netbase python
ADD https://raw.github.com/pypa/pip/master/contrib/get-pip.py /get-pip.py    
RUN python /get-pip.py
# Use fork while hpk42/devpi#110 is not resolved
RUN pip install -U https://bitbucket.org/dangra/devpi/get/default.tar.gz
RUN pip install requests==2.3.0
VOLUME /mnt
EXPOSE 3141
ADD run.sh /
CMD ["/run.sh"]

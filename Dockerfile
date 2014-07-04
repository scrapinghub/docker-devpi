FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -y netbase python
ADD https://raw.github.com/pypa/pip/master/contrib/get-pip.py /get-pip.py    
RUN python /get-pip.py
RUN pip install -U devpi==1.2.1 devpi-server==1.2.2
VOLUME /mnt
EXPOSE 3141
ADD run.sh /
ENTRYPOINT ["/run.sh"]

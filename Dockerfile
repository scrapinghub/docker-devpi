FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -y netbase python \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/*
ADD ["https://raw.github.com/pypa/pip/master/contrib/get-pip.py", "/"]
RUN python /get-pip.py \
	&& pip install "devpi-server>=2.0.6,<2.1dev" "devpi-client>=2.0.2,<2.1dev" \
	"requests>=2.4.0,<2.5"
VOLUME /mnt
EXPOSE 3141
ADD run.sh /
CMD ["/run.sh"]

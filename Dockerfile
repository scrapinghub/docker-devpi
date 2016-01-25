FROM python:3
RUN pip install "devpi-server>=2.5,<2.6dev" "devpi-client>=2.3,<=2.4dev"
VOLUME /mnt
EXPOSE 3141
ADD run.sh /
CMD ["/run.sh"]

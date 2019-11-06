FROM debian:buster

ENV LANG C.UTF-8

RUN mkdir /gef && useradd -ms /bin/bash --home-dir /gef gef

RUN apt update && \
  apt install sudo procps python python3-pip python3-dev gdb git make gcc g++ wget cmake pkg-config binutils -y

RUN wget -q -O /gef/update-trinity.sh https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh && \
  sed -i 's/sudo make install install3/sudo make install3/g' /gef/update-trinity.sh

RUN chmod a+rx /gef/update-trinity.sh && /gef/update-trinity.sh

RUN wget -q -O /gef/.gdbinit-gef.py https://github.com/hugsy/gef/raw/master/gef.py
RUN wget -q -O /gef/simple.c https://github.com/hugsy/gef-docker/raw/master/simple.c
RUN gcc -O0 -ggdb -o /gef/simple /gef/simple.c

RUN apt remove -y --purge wget git make gcc g++ cmake pkg-config && \
  apt autoremove -y --purge && apt autoclean -y

RUN chown gef:gef -R /gef

USER gef

RUN echo 'source /gef/.gdbinit-gef.py' > /gef/.gdbinit

ENTRYPOINT [ "gdb", "-q", "/gef/simple" ]
FROM debian:buster

ENV LANG C.UTF-8

RUN mkdir /gef /pwn && useradd -ms /bin/bash --home-dir /gef gef

RUN apt update && \
  apt install procps python python3-pip python3-dev gdb git make gcc g++ wget cmake pkg-config binutils -y

RUN wget -q -O /gef/update-trinity.sh https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh && \
  sed -i 's/sudo make install install3/make install3/g' /gef/update-trinity.sh && \
  sed -i 's/sudo //g' /gef/update-trinity.sh

RUN chmod a+rx /gef/update-trinity.sh && /gef/update-trinity.sh && rm -f /gef/update-trinity.sh

RUN wget -q -O /gef/.gdbinit-gef.py https://github.com/hugsy/gef/raw/master/gef.py

RUN wget -q -O /pwn/simple-stack-bof.c https://raw.githubusercontent.com/hugsy/gef-docker/master/pwn/simple-stack-bof.c
RUN wget -q -O /pwn/simple-heap-bof.c https://raw.githubusercontent.com/hugsy/gef-docker/master/pwn/simple-heap-bof.c
RUN bash -c 'for i in /pwn/*.c; do gcc -O0 -ggdb -o ${i/.c/} ${i}; done'

RUN apt remove -y --purge wget git make gcc g++ cmake pkg-config && \
  apt autoremove -y --purge && apt autoclean -y && \
  rm -fr -- /var/lib/apt/lists/*

RUN pip3 install ropper

RUN chown gef:gef -R /gef
RUN chown gef:gef -R /pwn

USER gef

COPY gef-demo-intro.py /gef/
COPY tips /gef/

RUN echo 'source /gef/.gdbinit-gef.py' > /gef/.gdbinit
RUN echo 'source /gef/gef-demo-intro.py' >> /gef/.gdbinit

ENTRYPOINT [ "/usr/bin/gdb", "-q", "/pwn/simple-stack-bof" ]

FROM debian:latest

ENV LANG C.UTF-8

RUN mkdir /gef /pwn && useradd -ms /bin/bash --home-dir /gef gef

RUN apt-get update && \
  apt-get install procps python3 python3-pip python3-dev gdb gdb-multiarch git make file gcc wget binutils -y

RUN bash -c 'for i in simple-stack-bof simple-heap-bof; do wget -q -O /pwn/${i}.c https://raw.githubusercontent.com/hugsy/gef-docker/master/pwn/${i}.c; done'
RUN bash -c 'for i in /pwn/*.c; do gcc -O0 -ggdb -o ${i/.c/} ${i}; done'

RUN chown gef:gef -R /gef
RUN chown gef:gef -R /pwn

USER gef

RUN bash -c "$(wget -q https://github.com/hugsy/gef/raw/main/scripts/gef.sh -O -)"
RUN bash -c "$(wget -q https://github.com/hugsy/gef/raw/main/scripts/gef-extras.sh -O -)"

COPY gef-demo-intro.py /gef/
COPY tips /gef/

RUN echo 'source /gef/gef-demo-intro.py' >> /gef/.gdbinit

ENTRYPOINT [ "/usr/bin/gdb", "-q", "/pwn/simple-stack-bof" ]

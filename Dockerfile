FROM debian:buster

ENV LANG C.UTF-8

RUN mkdir /gef && useradd -ms /bin/bash --home-dir /gef gef

RUN apt update && \
  apt install procps python python3-pip python3-dev gdb git make gcc g++ wget cmake pkg-config binutils -y && \
  apt install autoconf bison flex libprotobuf-dev libnl-route-3-dev libtool protobuf-compiler -y

RUN wget -q -O /gef/update-trinity.sh https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh && \
  sed -i 's/sudo make install install3/make install3/g' /gef/update-trinity.sh && \
  sed -i 's/sudo //g' /gef/update-trinity.sh 

RUN chmod a+rx /gef/update-trinity.sh && /gef/update-trinity.sh && rm -f /gef/update-trinity.sh

RUN wget -q -O /gef/.gdbinit-gef.py https://github.com/hugsy/gef/raw/master/gef.py
RUN wget -q -O /gef/simple.c https://raw.githubusercontent.com/hugsy/gef-docker/master/simple.c
RUN gcc -O0 -ggdb -o /gef/simple /gef/simple.c 
RUN git clone https://github.com/google/nsjail /tmp/nsjail
RUN cd /tmp/nsjail && make && mv /tmp/nsjail/nsjail /gef/nsjail && rm -rf -- /tmp/nsjail

RUN apt remove -y --purge wget git make gcc g++ cmake pkg-config && \
  apt autoremove -y --purge && apt autoclean -y && \
  rm -fr -- /var/lib/apt/lists/* 

RUN pip3 install ropper

RUN chown gef:gef -R /gef

USER gef

RUN echo 'source /gef/.gdbinit-gef.py' > /gef/.gdbinit

ENTRYPOINT [ "/gef/nsjail", "-Mo", "--cgroup_pids_max", "3", "--cwd", "/gef", "--time_limit", "300", "--user", "99999", "--group", "99999", "-R" "/lib", "-R", "/lib64", "-R", "/usr/lib", "-R", "/usr/bin/gdb", "-R", "/usr/share", "-R", "/bin", "--keep_caps", "--", "/usr/bin/gdb", "-q", "/gef/simple" ]

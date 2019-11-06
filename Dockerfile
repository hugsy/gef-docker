FROM debian:buster

RUN mkdir /gef && useradd -ms /bin/bash --home-dir /gef gef

RUN apt update && \
  apt install sudo python3-pip python3-dev gdb git make gcc g++ wget cmake pkg-config binutils -y

RUN wget -q -O /gef/update-trinity.sh https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh && \
  sed -i 's/sudo make install install3/sudo make install3/g' /gef/update-trinity.sh

RUN chmod a+rx /gef/update-trinity.sh && /gef/update-trinity.sh

RUN apt remove -y --purge sudo git make gcc g++ wget cmake pkg-config && \
  apt autoremove -y --purge && apt autoclean -y

USER gef
RUN wget -q -O- https://github.com/hugsy/gef/raw/dev/scripts/gef.sh | sh

ENTRYPOINT [ "gdb-multiarch", "-q", "/bin/ls" ]

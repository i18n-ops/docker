WORKDIR /
SHELL ["/bin/bash", "-c"]


RUN apt-get update 

ADD sh/env.sh sh/
ADD sh/soft.sh sh/
ADD sh/misei.sh sh/

RUN /sh/soft.sh

COPY _/root /root

ADD sh/zinit.sh sh/
SHELL ["/bin/zsh", "-c"]
RUN /sh/zinit.sh

COPY _ .
COPY boot .

ADD sh/end.sh sh/
RUN /sh/end.sh

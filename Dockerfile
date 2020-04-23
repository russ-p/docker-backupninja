FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Minsk

RUN apt-get update && apt-get -qq -y upgrade && \
    apt-get -qq -y --no-install-recommends install \
        backupninja \
        rsync \
        openssh-client \
        mysql-client \
        rdiff-backup \
        bzip2 \
        git-core \
        ssmtp  \
        tzdata \
        cron && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata && \
    apt-get -qq -y autoremove &&\
    apt-get -qq -y autoclean &&\
    apt-get -qq -y clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    chfn -f 'Backupninja in Docker' root &&\
    sed -i "s|logfile =.*|logfile = /proc/self/fd/1|i" /etc/backupninja.conf &&\
    sed -i "s|reportspace =.*|reportspace = yes|i"     /etc/backupninja.conf

ADD backupninja /usr/share/backupninja
COPY ["docker_entrypoint.sh","/"]

VOLUME ["/backup"]
ENTRYPOINT ["/docker_entrypoint.sh"]
CMD ["help"]
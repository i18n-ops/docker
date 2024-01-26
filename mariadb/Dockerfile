FROM mariadb
RUN apt-get update && \
    apt-get -y install mariadb-plugin-rocksdb &&\
    rm -rf /var/cache/apt/lists/*
ADD db.cnf /etc/mysql/conf.d/

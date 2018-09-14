FROM gw000/keras:1.2.1-py3

ARG LIBRESSL_VERSION=2.2.7
ARG CURL_VERSION=7.54.0
ARG CURL_VERSION_URL=7_54_0

COPY requirements.txt requirements.txt
RUN apt-get update && \
    apt-get install -y wget && \
    pip3 install -r requirements.txt && \
    wget -q http://www.receita.fazenda.gov.br/acrfb/ACSecretariadaReceitaFederaldoBrasilv3.crt && \
    wget -q http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz && \
    tar -xzvf libressl-${LIBRESSL_VERSION}.tar.gz && \
    cd libressl-${LIBRESSL_VERSION} && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf libressl-${LIBRESSL_VERSION}* && \
    wget -q https://github.com/curl/curl/releases/download/curl-${CURL_VERSION_URL}/curl-${CURL_VERSION}.tar.gz && \
    tar -xzvf curl-${CURL_VERSION}.tar.gz && \
    cd curl-${CURL_VERSION} && \
    ./configure --with-ssl && \
    make && \
    make install && \
    cd .. && \
    rm -rf curl-${CURL_VERSION}* && \
    ln -s /usr/local/lib/libcurl.so.4 /usr/lib/x86_64-linux-gnu/libcurl.so.4 && \
    apt-get remove -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /cnpj
COPY captcha_receita.h5 captcha_receita.h5
COPY consulta_cnpj.py consulta_cnpj.py

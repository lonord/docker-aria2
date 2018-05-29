FROM ubuntu:16.04
LABEL maintainer="Loy B. <lonord.b@gmail.com>"
ENV ARIA2_VERSION 1.34.0
COPY aria2.conf /aria2/aria2.conf
RUN apt-get update \
	&& apt-get install -y --no-install-recommends libssl-dev libexpat1-dev libssh2-1-dev libc-ares-dev zlib1g-dev libsqlite3-dev pkg-config libcppunit-dev autoconf automake autotools-dev autopoint libtool g++ git openssl ca-certificates \
	&& git clone --branch release-$ARIA2_VERSION https://github.com/aria2/aria2.git aria2_repo \
	&& cd aria2_repo \
	&& autoreconf -i \
	&& ./configure --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt' --without-gnutls --with-openssl ARIA2_STATIC=yes \
	&& make \
	&& make install \
	&& mkdir /download \
	&& cd / \
	&& touch /aria2/aria2.session \
	&& rm -rf /aria2_repo \
	&& apt-get purge -y --auto-remove libssl-dev libexpat1-dev libssh2-1-dev libc-ares-dev zlib1g-dev libsqlite3-dev pkg-config libcppunit-dev autoconf automake autotools-dev autopoint libtool g++ git -y \
	&& rm -rf /var/lib/apt/lists/*
CMD [ "aria2c", "--conf-path=/aria2/aria2.conf", "--input-file=/aria2/aria2.session", "--save-session=/aria2/aria2.session" ]
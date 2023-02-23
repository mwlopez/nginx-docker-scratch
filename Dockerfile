FROM  ubuntu:22.04 as build

#Define build argument for version
ARG VERSION=1.23.3

RUN apt update && \
    apt-get install -y build-essential \
        libpcre3        \
        libpcre3-dev    \
        zlib1g          \
        zlib1g-dev      \
        libssl-dev      \
        libgd-dev       \
        libxml2         \
        libxml2-dev     \
        uuid-dev        \
        wget            \
        gnupg

RUN echo $VERSION

RUN set -x                                                                          && \
     cd /tmp                                                                        && \
     wget -q http://nginx.org/download/nginx-${VERSION}.tar.gz                      && \
     wget -q http://nginx.org/download/nginx-${VERSION}.tar.gz.asc                  && \
     tar -xvf nginx-${VERSION}.tar.gz  

WORKDIR /tmp/nginx-${VERSION}

RUN ./configure --with-ld-opt="-static" --with-http_sub_module                      && \
    make install                                                                    && \
    strip /usr/local/nginx/sbin/nginx

RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log                             && \
    ln -sf /dev/stderr /usr/local/nginx/logs/error.log


FROM scratch

LABEL maintainer="Marcelo Lopez <marcelo.lopez@aeolabs.io>"

COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /usr/local/nginx /usr/local/nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/local/nginx/html/

#Change default stop signal from SIGTERM to SIGQUIT
STOPSIGNAL SIGQUIT

# Expose port
EXPOSE 80/tcp

# Define entrypoint and default parameters 
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]
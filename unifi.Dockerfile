FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends openjdk-17-jre-headless wget  \
    binutils curl logrotate && \
    wget -O /tmp/unifi.deb -c -L "https://dl.ui.com/unifi/8.0.7/unifi_sysvinit_all.deb" && \
    dpkg -i --ignore-depends=mongodb-org-server /tmp/unifi.deb && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    mkdir -p /usr/lib/unifi/data /default

COPY assets/unifi_entrypoint.sh /entrypoint.sh

WORKDIR /usr/lib/unifi
EXPOSE 8080 8443 8843 8880

ENTRYPOINT /entrypoint.sh
FROM jenkins:alpine

USER root

RUN apk add --no-cache \
    ca-certificates \
    curl \
    openssl

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.13.0
ENV DOCKER_SHA256 fc194bb95640b1396283e5b23b5ff9d1b69a5e418b5b3d774f303a7642162ad6

RUN set -x \
  && curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
  && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
  && tar -xzvf docker.tgz \
  && mv docker/* /usr/local/bin/ \
  && rmdir docker \
  && rm docker.tgz \
  && docker -v

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
RUN apk add --no-cache \
    btrfs-progs \
    e2fsprogs \
    e2fsprogs-extra \
    iptables \
    xfsprogs \
    xz

# TODO aufs-tools

# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x \
  && addgroup -S dockremap \
  && adduser -S -G dockremap dockremap \
  && echo 'dockremap:165536:65536' >> /etc/subuid \
  && echo 'dockremap:165536:65536' >> /etc/subgid

ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034

RUN wget "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind \
  && chmod +x /usr/local/bin/dind

COPY entrypoint.sh /usr/local/bin/

VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT ["entrypoint.sh"]
CMD []

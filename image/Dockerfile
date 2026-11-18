FROM debian:trixie-slim

LABEL org.opencontainers.image.authors="project@cryrc.it"

COPY . /container
RUN /container/build.sh

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

ENTRYPOINT ["/container/tool/run"]

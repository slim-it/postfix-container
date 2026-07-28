FROM ubuntu:resolute

ARG POSTFIX_VERSION
LABEL org.opencontainers.image.title="postfix container"
LABEL org.opencontainers.image.description="Postfix with MySQL map support from the Ubuntu packages"
LABEL org.opencontainers.image.source="https://github.com/slim-it/postfix-container"
# Not org.opencontainers.image.version: CI overwrites that annotation
# with the tag.
LABEL nl.slim-it.postfix.version="${POSTFIX_VERSION}"

# postfix-mysql provides the dynamicmaps plugin for `mysql:` lookup tables,
# which every recipient class is resolved through; it is versioned with the
# postfix package it plugs into. libsasl2-modules carries the PLAIN and LOGIN
# client mechanisms: without them Postfix cannot authenticate to a relay host
# at all, and reports only "no mechanism available".
RUN test -n "${POSTFIX_VERSION}" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      ca-certificates \
      libsasl2-modules \
      postfix=${POSTFIX_VERSION} \
      postfix-mysql=${POSTFIX_VERSION} \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/sbin/postfix", "start-fg"]

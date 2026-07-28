FROM ubuntu:resolute

ARG POSTFIX_VERSION
LABEL org.opencontainers.image.title="postfix container"
LABEL org.opencontainers.image.description="Postfix with MySQL map support from the Ubuntu packages"
LABEL org.opencontainers.image.source="https://github.com/slim-it/postfix-container"
# The tag drops the packaging revision, and CI overwrites the standard
# image.version annotation with the tag, so this is where the exact packaged
# version a given image contains is recorded.
LABEL nl.slim-it.postfix.version="${POSTFIX_VERSION}"

# postfix-mysql provides the dynamicmaps plugin for `mysql:` lookup tables,
# which every recipient class is resolved through; it is versioned with the
# postfix package it plugs into.
RUN test -n "${POSTFIX_VERSION}" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      ca-certificates \
      postfix=${POSTFIX_VERSION} \
      postfix-mysql=${POSTFIX_VERSION} \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/sbin/postfix", "start-fg"]

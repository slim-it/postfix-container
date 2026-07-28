# postfix-container

Minimal Postfix image built from the Ubuntu packages.

It exists for one reason: every recipient class the mail stack resolves —
aliases, virtual domains and mailboxes, relay domains, the transport map —
is a `mysql:` lookup table, and that map type comes from the separate
`postfix-mysql` plugin package. No upstream Postfix image ships it.

`VERSION` is the single source of truth for the packaged Postfix version (the
full apt version string). CI reads it for the Docker build argument and
derives the release tag from it: the packaging revision is dropped, so the tag
is the upstream version and orders as a plain version.

The image carries no configuration. `main.cf`, `master.cf` and the map
definitions are mounted in by the consuming manifests, and the queue lives on
a volume at `/var/spool/postfix`.

## Image

CI publishes:

```text
ghcr.io/slim-it/postfix-container:<release-version>
ghcr.io/slim-it/postfix-container:latest
ghcr.io/slim-it/postfix-container:sha-<git-sha>
```

## Build locally

```sh
docker build --build-arg POSTFIX_VERSION="$(cat VERSION)" -t ghcr.io/slim-it/postfix-container:local .
```

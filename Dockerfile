FROM alpine:3.11

RUN apk add --no-cache \
  bash

COPY --from=jpillora/chisel /app/chisel /usr/bin
COPY layers/ /

ENTRYPOINT [ "/entrypoint.sh" ]
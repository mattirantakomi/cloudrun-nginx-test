FROM alpine:3.11

RUN apk add --no-cache \
  bash

COPY --from=jpillora/chisel /app/chisel /usr/bin
COPY layers/ /
COPY --from=jpillora/chisel /app/chisel /usr/bin

ENTRYPOINT [ "/entrypoint.sh" ]
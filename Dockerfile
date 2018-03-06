ARG DKR_IMAGE
ARG MIX_ENV

FROM $DKR_IMAGE

COPY _build/$MIX_ENV/rel/rico_ping /opt/rico_ping

RUN /opt/rico_ping/bin/rico_ping console

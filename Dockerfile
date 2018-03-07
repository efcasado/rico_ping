ARG DKR_IMAGE

FROM $DKR_IMAGE

ARG MIX_ENV

COPY ./_build/${MIX_ENV}/rel/rico_ping /opt/rico_ping

ENTRYPOINT [ "/opt/rico_ping/bin/rico_ping", "console" ]

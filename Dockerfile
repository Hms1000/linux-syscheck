FROM bash:latest AS builder
WORKDIR /build
COPY syscheck.sh .
RUN chmod +x syscheck.sh

FROM koalaman/shellcheck:latest AS checker
WORKDIR /checker
COPY --from=builder /build/syscheck.sh .
RUN shellcheck syscheck.sh

FROM bash:latest AS tester
WORKDIR /test
COPY --from=checker /checker/syscheck.sh .
RUN bash -n syscheck.sh

FROM bash:latest AS final
WORKDIR /app
COPY --from=tester /test/syscheck.sh .
ENTRYPOINT [ "bash", "syscheck.sh" ]

ARG DATABASE_TYPE
ARG DATABASE_URL
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD
ARG KEYCLOAK_VERSION
ARG KEYCLOAK_HOSTNAME
ARG KEYCLOAK_HTTP_ENABLED
ARG KEYCLOAK_PROXY

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} as builder

ENV KC_HEALTH_ENABLED true
ENV KC_METRICS_ENABLED true
ENV KC_FEATURES token-exchange
ENV KC_DB $DATABASE_TYPE

RUN curl -sL https://github.com/wadahiro/keycloak-discord/releases/download/v0.4.0/keycloak-discord-0.4.0.jar -o /opt/keycloak/providers/keycloak-discord-0.4.0.jar 
RUN curl -sL https://github.com/aerogear/keycloak-metrics-spi/releases/download/2.5.3/keycloak-metrics-spi-2.5.3.jar -o /opt/keycloak/providers/keycloak-metrics-spi-2.5.3.jar
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak /opt/keycloak
WORKDIR /opt/keycloak

ENV KC_DB_URL $DATABASE_URL
ENV KC_DB_USERNAME $DATABASE_USERNAME
ENV KC_DB_PASSWORD $DATABASE_PASSWORD

ENV KC_HOSTNAME $KEYCLOAK_HOSTNAME
ENV KC_HTTP_ENABLED $KEYCLOAK_HTTP_ENABLED
ENV KC_PROXY $KEYCLOAK_PROXY

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
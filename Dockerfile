# Stage 1: Builder stage for optimized build
FROM quay.io/keycloak/keycloak:latest AS builder

# Set build-time configurations (REQUIRED)
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres
ENV KC_DB_USERNAME=$DB_USER
ENV KC_DB_PASSWORD=$DB_PASSWORD

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

# Stage 2: Runtime image
FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Runtime environment variables (use defaults or override via workflow)
ENV KC_HOSTNAME=localhost

# Stage 1: Builder stage to prepare Keycloak with customizations
FROM quay.io/keycloak/keycloak:latest AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure database vendor (example: Postgres)
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# (Optional) Generate a self-signed certificate for HTTPS (for demo purposes)
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 \
    -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore

# Build Keycloak with the above settings
RUN /opt/keycloak/bin/kc.sh build

# Stage 2: Final image
FROM quay.io/keycloak/keycloak:latest

# Copy the built Keycloak from the builder stage
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Set environment variables for database connection and hostname
ENV KC_DB=postgres
ENV KC_DB_URL=<DBURL>            # Replace with your database URL
ENV KC_DB_USERNAME=<DBUSERNAME>  # Replace with your database username
ENV KC_DB_PASSWORD=<DBPASSWORD>  # Replace with your database password
ENV KC_HOSTNAME=localhost

# Set the entrypoint to start Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

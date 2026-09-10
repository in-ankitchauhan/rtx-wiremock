FROM wiremock/wiremock:3.13.0

COPY wiremock/mappings /home/wiremock/mappings

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh", "--port", "8080", "--global-response-templating", "--disable-banner"]

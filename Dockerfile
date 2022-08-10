FROM huginn/huginn

COPY ./ /huginn_anomaly_agent
WORKDIR /huginn_anomaly_agent

USER 0
RUN bundle install && \
  chown -R 1001:1001 /app && \
  chown -R 1001:1001 /huginn_anomaly_agent && \
  git config --global --add safe.directory /app
USER 1001

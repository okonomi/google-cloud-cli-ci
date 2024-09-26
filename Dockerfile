FROM alpine:3.20.3

ARG GCLOUD_CLI_VERSION=494.0.0
ARG INSTALL_COMPONENTS=beta

ENV PATH=/google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_PYTHON=/usr/bin/python3

RUN if [ "$(uname -m)" = "x86_64" ]; then echo -n "x86_64" > /tmp/arch; else echo -n "arm" > /tmp/arch; fi;
RUN ARCH="$(cat /tmp/arch)" && apk add --no-cache \
      bash \
      curl \
      py3-crcmod \
      python3 \
  && curl -o google-cloud-cli.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_CLI_VERSION}-linux-${ARCH}.tar.gz \
  && tar -xf google-cloud-cli.tar.gz \
  && rm google-cloud-cli.tar.gz \
  && ./google-cloud-sdk/install.sh --bash-completion=false \
  && gcloud config set core/disable_usage_reporting true \
  && gcloud config set component_manager/disable_update_check true \
  && gcloud components remove bq --quiet \
  && gcloud components install $INSTALL_COMPONENTS --quiet \
  && rm -rf $(find ./google-cloud-sdk/ -regex ".*/__pycache__") \
  && rm -rf ./google-cloud-sdk/.install/.backup

RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

CMD ["/bin/bash"]

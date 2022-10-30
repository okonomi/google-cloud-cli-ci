FROM alpine:3.16

ARG CLOUD_SDK_VERSION=407.0.0

ENV PATH /google-cloud-sdk/bin:$PATH

RUN if [ "$(uname -m)" = "x86_64" ]; then echo -n "x86_64" > /tmp/arch; else echo -n "arm" > /tmp/arch; fi;
RUN ARCH="$(cat /tmp/arch)" && apk add --no-cache \
      bash \
      py3-crcmod \
      python3 \
  && wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz \
  && tar -xf google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz \
  && rm google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz \
  && ./google-cloud-sdk/install.sh --bash-completion=false --additional-components beta \
  && gcloud config set core/disable_usage_reporting true \
  && gcloud config set component_manager/disable_update_check true \
  && rm -rf $(find ./google-cloud-sdk/ -regex ".*/__pycache__") \
  && rm -rf ./google-cloud-sdk/.install/.backup \
  && rm /google-cloud-sdk/bin/anthoscli

RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

CMD ["/bin/bash"]

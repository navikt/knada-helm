FROM ruby:2.7

ENV MUSTACHE_VERSION="1.1"
ENV YQ_VERSION="3.3.2"

RUN gem install mustache -v "$MUSTACHE_VERSION"

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/ && \
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/ && \
    helm repo update && \
    helm pull jupyterhub/jupyterhub && \
    helm pull stable/airflow

RUN curl -Ls https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 > /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

COPY ./decrypt.sh /usr/local/bundle/bin/decrypt
COPY ./entrypoint.sh /usr/local/bundle/bin/entrypoint

ENTRYPOINT ["entrypoint"]

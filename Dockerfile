# Container image that runs your code
FROM alpine:3.10

#install all dependencies
ENV KUSTOMIZE_VER 5.3.0
RUN apk add --update --no-cache bash
RUN apk add git curl --update --no-cache bash
RUN curl -L --silent https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_amd64.tar.gz -o ./kustomize.tar.gz
RUN tar -xf kustomize.tar.gz -C /usr/bin/ && chmod +x /usr/bin/kustomize
                    
RUN wget https://github.com/cli/cli/releases/download/v1.0.0/gh_1.0.0_linux_386.tar.gz -O ghcli.tar.gz
RUN tar --strip-components=1 -xf ghcli.tar.gz

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

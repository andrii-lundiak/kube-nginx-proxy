# In scope of task HZN-2866 change at least to FROM nginx:1.16.1 to be the same as in Horizon Frontend, BUT ONLY after verifcation of NGINX API changes between those versions.
# And later try :latest or :1.22.0 or :1.23.0 => http://nginx.org/en/download.html
FROM nginx:1.14.2 

LABEL maintainer="Andrii Lundiak <andrii.lundiak@soprasteria.com>"

# 0.2.x were `kylemcc` last versions | DockerHub: kylemcc
# 0.3.x were `khaliqgant` versions | DockerHub: khaliqgant
# 0.4.x may be `andrii-lundiak` (GitHub) | DockerHub: andriilundiak
# 0.5.x may be assumed `avinor-ps` (GitHub) | DockerHub: avinorps or avinor
LABEL version="0.4.6"


# Install available package updates, wget, and install/updates certificates
RUN apt-get update \
  && apt-get install -y -q --no-install-recommends ca-certificates wget \
  && apt-get upgrade -y \
  && apt-get clean \
  && rm -r /var/lib/apt/lists/*

# Run nginx in foreground
# increase the hash bucket size to support more/longer server names
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
  && sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf \
  && rm -f /etc/nginx/conf.d/default.conf

# install kubectl, forego and kube-gen
ENV KUBE_GEN_VERSION 0.3.0

ADD https://storage.googleapis.com/kubernetes-release/release/v1.8.15/bin/linux/amd64/kubectl /usr/local/bin/
RUN chmod +x /usr/local/bin/kubectl

# https://github.com/ddollar/forego/issues/127#issuecomment-1235315871
RUN wget https://github.com/jpillora/forego/releases/download/v1.0.4/forego_1.0.4_linux_amd64.gz \
  && gzip -d -N forego_1.0.4_linux_amd64.gz \
  && mv forego /usr/local/bin \ 
  && chmod +x /usr/local/bin/forego

RUN wget https://github.com/kylemcc/kube-gen/releases/download/$KUBE_GEN_VERSION/kube-gen-linux-amd64-$KUBE_GEN_VERSION.tar.gz \
  && tar -C /usr/local/bin -xvzf kube-gen-linux-amd64-$KUBE_GEN_VERSION.tar.gz \
  && rm kube-gen-linux-amd64-$KUBE_GEN_VERSION.tar.gz \
  && chmod +x /usr/local/bin/kube-gen

COPY . /app/
WORKDIR /app/

ENTRYPOINT ["forego", "start", "-r"]

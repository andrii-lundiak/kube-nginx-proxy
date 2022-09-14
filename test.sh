#!/bin/bash

KUBE_GEN_VERSION=0.3.0

mkdir aka_bin

wget https://storage.googleapis.com/kubernetes-release/release/v1.8.15/bin/linux/amd64/kubectl \
  && cp kubectl ./aka_bin \
  && rm kubectl \
  && chmod +x ./aka_bin/kubectl

wget https://github.com/jpillora/forego/releases/download/v1.0.4/forego_1.0.4_linux_amd64.gz \
  && gzip -d -N forego_1.0.4_linux_amd64.gz \
  && mv forego ./aka_bin/ \
  && chmod +x ./aka_bin/forego

wget https://github.com/kylemcc/kube-gen/releases/download/$KUBE_GEN_VERSION/kube-gen-linux-amd64-$KUBE_GEN_VERSION.tar.gz \
  && tar -C ./aka_bin/ -xvzf kube-gen-linux-amd64-$KUBE_GEN_VERSION.tar.gz \
  && rm kube-gen-linux-amd64-$KUBE_GEN_VERSION.tar.gz \
  && chmod +x ./aka_bin/kube-gen

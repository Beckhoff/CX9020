FROM ubuntu:18.04
COPY ./ /root/CX9020/
WORKDIR /root/CX9020/
RUN apt-get update && \
    apt-get -yq install gpg sudo && \
    tools/10_prepare_host_ubuntu1804.sh && \
    git config --global user.name 'root' && \
    git config --global user.email 'root@CX9020' && \
    tools/prepare_uboot.sh v2019.10 && \
    tools/prepare_kernel.sh v4.19-rt

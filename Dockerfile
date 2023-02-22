from debian:11
RUN apt-get update && apt-get install -y sudo gpg
COPY tools/10_prepare_host_debian11.sh /prepare.sh
RUN /prepare.sh
RUN git config --global user.name "gitlab-runner"
RUN git config --global user.email "gitlab-runner@example.com"

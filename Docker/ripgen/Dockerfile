#
# NOTE: THIS DOCKERFILE IS AUTO-GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

#FROM buildpack-deps:scm
FROM alpine:3.20

ENV PATH="/root/.local/bin:$PATH"
WORKDIR /

# Install
RUN  apk add rustup build-base \ 
	&& rustup-init -y \ 
	&& . /root/.cargo/env \ 
	&& cargo install ripgen \ 
	&& export PATH=/root/.cargo/bin:$PATH

CMD ["sh"]

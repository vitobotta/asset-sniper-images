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
RUN  apk upgrade --no-cache \ 
	&& apk add bind-tools

CMD ["sh"]

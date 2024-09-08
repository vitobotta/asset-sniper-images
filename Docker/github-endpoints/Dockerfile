#
# NOTE: THIS DOCKERFILE IS AUTO-GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM golang:1.23-alpine

ENV PATH="/root/go/bin:$PATH"
ENV CGO_ENABLED=1

# Install
RUN  apk upgrade --no-cache \ 
	&& apk add --no-cache bind-tools build-base ca-certificates \ 
	&& go install -v github.com/gwen001/github-endpoints@latest

CMD ["sh"]

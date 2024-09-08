#
# NOTE: THIS DOCKERFILE IS AUTO-GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM golang:1.23-alpine

ENV PATH="/root/go/bin:$PATH"
ENV CGO_ENABLED=1

# Install
RUN  apk -U upgrade --no-cache \ 
	&& apk add --no-cache bind-tools build-base ca-certificates chromium \ 
	&& go install github.com/projectdiscovery/katana/cmd/katana@latest

CMD ["sh"]

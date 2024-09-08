#
# NOTE: THIS DOCKERFILE IS AUTO-GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM golang:1.23-alpine

ENV PATH="/root/go/bin:$PATH"
ENV CGO_ENABLED=1

# Install
RUN  apk --no-cache --virtual .build-deps add git build-base \ 
	&& git clone --filter="blob:none" https://github.com/blechschmidt/massdns \ 
	&& cd massdns \ 
	&& make \ 
	&& apk del .build-deps \ 
	&& cp bin/massdns /usr/local/bin/ \ 
	&& go install -v github.com/d3mondev/puredns/v2@latest

CMD ["sh"]

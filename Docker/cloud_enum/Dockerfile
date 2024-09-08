#
# NOTE: THIS DOCKERFILE IS AUTO-GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM python:3.12-alpine

ENV PYTHONUNBUFFERED=1
ENV LC_ALL=C.UTF-8
ENV PATH="/root/.local/bin:$PATH"

# Install
RUN  apk add git \ 
	&& git clone --filter="blob:none" https://github.com/initstring/cloud_enum \ 
	&& cd cloud_enum \ 
	&& pip3 install -r requirements.txt || true \ 
	&& pip3 install . || true

CMD ["sh"]

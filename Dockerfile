# Build image
# Use slim python 3 + Magics image as base
FROM eduardrosert/magics:version-4.2.0 as build

# Install tools
RUN set -ex \
    && apt-get update \
    && apt-get install --yes --no-install-suggests --no-install-recommends \
        git

# Get Skinnywms
ARG SKINNYWMS_VERSION=0.2.1
RUN set -eux \
    && mkdir -p /app/ \
    && cd /app \
    && git clone https://github.com/ecmwf/skinnywms.git \
    && cd skinnywms \
    && git checkout ${SKINNYWMS_VERSION}

# slim the image:
# - delete git repo information
RUN set -eux \
    && rm -r /app/skinnywms/.git

# slim the image:
# - delete example data
#RUN set -eux \
#    && rm -r /app/skinnywms/skinnywms/testdata

# Run-time image
FROM eduardrosert/magics

RUN set -eux \
    && mkdir -p /app/

COPY --from=build /app/skinnywms /app/skinnywms

# Install Python run-time dependencies.
COPY requirements.txt /root/
RUN set -ex \
    && pip install -r /root/requirements.txt

# demo application will listen at http://0.0.0.0:5000
EXPOSE 5000/tcp

# start demo
# add option --path <directory with grib files>
# to look for grib files in specific directory
CMD python /app/skinnywms/demo.py --host='0.0.0.0' --port=5000

# METADATA
# Build-time metadata as defined at http://label-schema.org
# --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
ARG BUILD_DATE
# --build-arg VCS_REF=`git rev-parse --short HEAD`, e.g. 'c30d602'
ARG VCS_REF
# --build-arg VCS_URL=`git config --get remote.origin.url`, e.g. 'https://github.com/eduardrosert/docker-skinnywms'
ARG VCS_URL
# --build-arg VERSION=`git tag`, e.g. '0.2.1'
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.name="Skinny WMS" \
        org.label-schema.description="The Skinny WMS is a small WMS server that will help you to visualise your NetCDF and Grib Data." \
        org.label-schema.url="https://confluence.ecmwf.int/display/MAGP/Skinny+WMS" \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.vcs-url=$VCS_URL \
        org.label-schema.vendor="ECMWF - European Centre for Medium-Range Weather Forecasts" \
        org.label-schema.version=$VERSION \
        org.label-schema.schema-version="1.0"
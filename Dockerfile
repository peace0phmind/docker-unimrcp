# Use an official centos runtime as a parent image

FROM centos:7

LABEL maintainer="peace0phmind@gmail.com"

ARG UNIMRCP_VERSION=1.6.0

COPY ./unimrcp-deps-${UNIMRCP_VERSION}.tar.gz unimrcp-deps-${UNIMRCP_VERSION}.tar.gz
COPY ./unimrcp-${UNIMRCP_VERSION}.tar.gz unimrcp-${UNIMRCP_VERSION}.tar.gz

RUN yum group install -y "Development Tools" \
    # build unimrcp deps
    && tar -zxf unimrcp-deps-${UNIMRCP_VERSION}.tar.gz \
    && (cd unimrcp-deps-${UNIMRCP_VERSION} \
    && cat build-dep-libs.sh | sed 's/sudo make install/make install/' > build.sh && chmod +x build.sh \
    && ./build.sh -s) \
    # build unimrcp
    && tar -zxf unimrcp-${UNIMRCP_VERSION}.tar.gz \
    && (cd unimrcp-${UNIMRCP_VERSION} && ./configure && make && make install) \
    && rm -rf unimrcp-deps-${UNIMRCP_VERSION} && rm -f unimrcp-deps-${UNIMRCP_VERSION}.tar.gz \
    && rm -rf unimrcp-${UNIMRCP_VERSION} && rm -f unimrcp-${UNIMRCP_VERSION}.tar.gz

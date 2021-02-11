FROM public.ecr.aws/amazonlinux/amazonlinux:2

MAINTAINER Caltech IMSS ADS <imss-ads-staff@caltech.edu>

USER root

ENV LC_ALL=en_US.UTF-8 PYTHONUNBUFFERED=1
# Check https://pypy.org/download.html for new stable releases of pypy3-3.7
ENV PYPY3_VERSION 3.7-v7.3.3

#install packages
RUN yum install -y amazon-linux-extras && \
    amazon-linux-extras enable epel && \
    yum install -y epel-release && \
    yum clean metadata && \
    yum update -y && \
    yum install -y \
        gcc \
        glibc-locale-source \
        glibc-langpack-en \
        git \
        make \
        libffi-devel \
        pkgconfig \
        zlib-devel \
        bzip2-devel \
        sqlite-devel \
        ncurses-devel \
        # PyPy needs openssl >= 1.1
        openssl11 \
        openssl11-libs \
        openssl11-devel \
        expat-devel \
        tk-devel \
        gdbm-devel \
        python-cffi \
        xz-devel \
        # interestingly we bootstrap our compiled pypy below with this older pypy from yum
        # https://pypy.readthedocs.io/en/latest/build.html
        # the pypy rpm comes from EPEL
        pypy \
        # Useful unix utilities that don't come with the base Amazon 2 image.
        tar \
        wget \
        bzip2 \
        which \
        vim \
        less \
        file \
    && yum -y clean all && \
    # Set up the UTF-8 locale so that shelling into the container won't spam you with locale errors.
    localedef -i en_US -f UTF-8 en_US.UTF-8

# Build and install our pypy-3.6
# See: https://pypy.readthedocs.io/en/latest/build.html
WORKDIR /usr/src
RUN wget --no-check-certificate -c https://downloads.python.org/pypy/pypy${PYPY3_VERSION}-src.tar.bz2 && \
    tar jxf pypy${PYPY3_VERSION}-src.tar.bz2 && \
    cd pypy${PYPY3_VERSION}-src/pypy/goal && \
    pypy ../../rpython/bin/rpython --opt=jit
RUN cd pypy${PYPY3_VERSION}-src/pypy/goal && \
    PYTHONPATH=../.. ./pypy3-c ../../lib_pypy/pypy_tools/build_cffi_imports.py && \
    cd ../tool/release && \
    ./package.py --archive-name=pypy${PYPY3_VERSION}-amazon2
RUN mv /tmp/usession-release-pypy${PYPY3_VERSION}*-current/build/pypy${PYPY3_VERSION}-amazon2 /opt/pypy && \
    /opt/pypy/bin/pypy3 -m ensurepip

ENV PATH /opt/pypy/bin:$PATH

CMD ["/bin/bash"]

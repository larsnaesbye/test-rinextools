FROM debian:stable-slim as builder

ARG TEQC_URL=https://www.unavco.org/software/data-processing/teqc/development/teqc_CentOSLx86_64s.zip
ARG GFZRNX_URL=http://semisys.gfz-potsdam.de/semisys/software/gfzrnx/1.13/gfzrnx_lx
ARG HATANAKA_URL=https://terras.gsi.go.jp/ja/crx2rnx/RNXCMP_4.1.0_Linux_x86_64bit.tar.gz
ARG BNC_URL=https://igs.bkg.bund.de/root_ftp/NTRIP/software/bnc-2.13-r9795-debian11.zip

ARG RTKLIB_EXPLORER_URL=https://github.com/rtklibexplorer/RTKLIB.git
ARG RTKLIB_EXPLORER_TAG=b34c

WORKDIR /tmp
COPY external .

RUN apt-get update && apt-get install -y \
        bash \
        libfontconfig \
        libfontconfig1-dev \
        build-essential  \
        gcc \
        git \
        wget \
        gfortran \
        unzip \
        curl  \ 
        bzip2  && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://igs.bkg.bund.de/root_ftp/NTRIP/software/bnc-2.12.18-debian8-64bit-static.zip -O bnc.zip && \
    unzip bnc.zip -d /usr/local/bin && \
    unzip teqc_CentOSLx86_64s.zip -d /usr/local/bin && rm -rf teqc_CentOSLx86_64s.zip && \
    cp gfzrnx_2.0-8219_lx64 /usr/local/bin/gfzrnx_lx && chmod ugo+x /usr/local/bin/gfzrnx_lx && \
    cp anubis-3.3-lin-static-64b /usr/local/bin/anubis && chmod ugo+x /usr/local/bin/anubis && \
    tar xvfz RNXCMP_4.1.0_Linux_x86_64bit.tar.gz && mv RNXCMP_*/bin/* /usr/local/bin && rm -rf RNXCMP_* && \ 
    unzip rtklib-${RTKLIB_EXPLORER_TAG}.zip && \
    (cd RTKLIB-${RTKLIB_EXPLORER_TAG}/lib/iers/gcc/; make -j 16)  && \
    (cd RTKLIB-${RTKLIB_EXPLORER_TAG}/app/consapp/convbin/gcc/; make -j 16; make install)  && \
    (cd RTKLIB-${RTKLIB_EXPLORER_TAG}/app/consapp/rnx2rtkp/gcc/; make -j 16; cp rnx2rtkp /usr/local/bin/rnx2rtkp_e)  && \
    (cd RTKLIB-${RTKLIB_EXPLORER_TAG}/app/consapp/pos2kml/gcc/; make -j 16; make install) && \
    (cd RTKLIB-${RTKLIB_EXPLORER_TAG}/app/consapp/rtkrcv/gcc/; make -j 16; make install) && \
    (cd RTKLIB-${RTKLIB_EXPLORER_TAG}/app/consapp/str2str/gcc/; make -j 16; make install) && \
    rm -rf RTKLIB-${RTKLIB_EXPLORER_TAG}
    
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN  /root/.cargo/bin/cargo install rinex-cli

FROM debian:11-slim as debian

RUN apt-get update && apt-get install -y csh gfortran && \
     rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY --from=builder /root/.cargo/bin/rinex-cli /usr/local/bin/

FROM python:3.9-slim-bullseye as python

RUN apt-get update && apt-get install -y csh gfortran && \
     rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY --from=builder /root/.cargo/bin/rinex-cli /usr/local/bin/

ENTRYPOINT ["/bin/bash"] 


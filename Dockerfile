FROM continuumio/miniconda3

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git gcc g++ clang make cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN conda install --yes numpy scipy pandas mkl mkl-devel && \
	conda install --yes -c conda-forge msgpack-c boost-cpp nlohmann_json

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

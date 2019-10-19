FROM continuumio/miniconda3

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl unzip tar git gcc g++ clang make cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN conda install --yes numpy scipy pandas mkl mkl-devel && \
	conda install --yes -c conda-forge msgpack-c boost-cpp nlohmann_json

RUN cd /opt && \
	git clone https://github.com/Microsoft/vcpkg.git && \
	cd vcpkg && \
	./bootstrap-vcpkg.sh

RUN ./vcpkg install eigen3 nlohmann_json msgpack catch2

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

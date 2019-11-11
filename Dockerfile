FROM continuumio/miniconda3

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl unzip tar git gcc g++ clang make cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN conda install --yes numpy scipy pandas mkl mkl-devel && \
	conda install --yes -c conda-forge msgpack-c boost-cpp nlohmann_json && \
	conda clean --all --yes


RUN cd /opt && \
	git clone https://github.com/Microsoft/vcpkg.git && \
	cd vcpkg && \
	./bootstrap-vcpkg.sh

RUN ./opt/vcpkg/vcpkg install eigen3 nlohmann-json msgpack catch2

ENV VCPKG_ROOT /opt/vcpkg
ENV MKL_INCLUDE /opt/conda/include
ENV MKL_LIB /opt/conda/lib

CMD [ "/bin/bash" ]

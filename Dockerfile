FROM ubuntu:rolling

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl unzip tar git gcc g++ clang make cmake gdb nano ninja-build && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
	. /opt/conda/etc/profile.d/conda.sh && \
	conda activate base && \
	conda install --yes python=3.8 && \
	conda update --yes --all && \
	conda install --yes numpy scipy pandas mkl mkl-devel && \
	conda install --yes -c conda-forge twine msgpack-c boost-cpp nlohmann_json cython numba pytest black flake8 msgpack-python && \
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

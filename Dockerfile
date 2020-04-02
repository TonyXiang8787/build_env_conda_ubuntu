FROM ubuntu:rolling

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing

RUN apt-get install -y locate wget bzip2 ca-certificates curl unzip tar git gcc g++ clang make cmake gdb nano ninja-build && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
	. /opt/conda/etc/profile.d/conda.sh && \
	conda activate base && \
	conda update --yes conda && \
	conda update --yes --all && \
	# build environment
	conda create --yes -n build_env python=3.8 && \
	conda activate build_env && \
	conda install --yes numpy scipy pandas mkl mkl-devel && \
	conda install --yes -c conda-forge twine msgpack-c boost-cpp nlohmann_json cython numba pytest black flake8 msgpack-python && \
	conda clean --all --yes && \
	# test environment
    conda create --yes -n test_env python=3.8 && \
	conda activate test_env && \
	pip install pytest && \
	conda clean --all --yes

# vcpkg
RUN cd /opt && \
	git clone https://github.com/Microsoft/vcpkg.git && \
	cd vcpkg && \
	./bootstrap-vcpkg.sh && \
	./vcpkg install eigen3 nlohmann-json msgpack catch2

ENV VCPKG_ROOT /opt/vcpkg
ENV MKL_INCLUDE /opt/conda/envs/build_env/include
ENV MKL_LIB /opt/conda/envs/build_env/lib

CMD [ "/bin/bash" ]

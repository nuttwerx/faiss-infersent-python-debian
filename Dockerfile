FROM infersent-python-debian:latest
MAINTAINER Nofel Tiani <nofel.tiani@gmail.com>

RUN git clone https://github.com/facebookresearch/faiss.git

RUN apt-get update && apt-get upgrade -y
# We'll use this to install the faiss package later on
RUN python3 -m pip install --user --upgrade setuptools wheel
# Some dependecies for faiss
RUN python3 -m pip install numpy
# Used to compile the c++ libraries
RUN apt-get install swig libopenblas-dev liblapack-dev -y

# faiss installation, more info on the faiss readme github page
WORKDIR ./faiss
RUN ./configure && make && make install
RUN make py

# Create the faiss package to install it
WORKDIR ./python
RUN python3 setup.py sdist bdist_wheel
WORKDIR ./dist
RUN pip install faiss-0.1-py3-none-any.whl

WORKDIR /
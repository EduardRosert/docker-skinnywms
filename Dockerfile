FROM continuumio/miniconda3

#update conda
RUN conda update conda -y

# add conda-forge channel
RUN conda config --add channels conda-forge

# Fix for Magics installation which is a dependency of skinnywms
# install dependency for Magics that is not installed (cannot be installed?) by conda
# see conda installation error: OSError: libGL.so.1: cannot open shared object file: No such file or directory
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx

# install skinnywms using conda, this will also install Magics
RUN conda install -c conda-forge skinnywms -y

# use local demo.py with fix for application listening on 
# every ip host address (0.0.0.0) instead of only on loopback 
# interface '127.0.0.1' by default
COPY ./demo.py /

# demo application will listen at http://0.0.0.0:5000
EXPOSE 5000/tcp

# start demo
CMD python ./demo.py --host='0.0.0.0' --port=5000 --path ./
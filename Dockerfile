FROM ubuntu:16.04
MAINTAINER prprhyt

#install essential
WORKDIR /root/
RUN sed -i -E 's%http://(archive|security).ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g' /etc/apt/sources.list
RUN apt-get update && apt-get install -yq git build-essential cmake ninja-build python3
RUN git clone https://github.com/llvm-mirror/llvm llvm
WORKDIR /root/llvm/tools/
RUN git checkout -b llvm-bolt f137ed238db11440f03083b1c88b7ffc0f4af65e
RUN git clone https://github.com/facebookincubator/BOLT llvm-bolt

# patch
WORKDIR /root/llvm/
RUN patch -p 1 < tools/llvm-bolt/llvm.patch
WORKDIR /root/

#build llvm-bolt
RUN mkdir build
WORKDIR /root/build/
RUN cmake -G Ninja -DLLVM_PARALLEL_LINK_JOBS=1 -DLLVM_USE_SPLIT_DWARF=ON ../llvm
RUN ninja



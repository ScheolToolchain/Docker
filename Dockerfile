FROM swift:5.6.2-focal
# Generic stuff to bootstrap ourself
RUN apt update
RUN apt install python3 zsh lsb-release wget software-properties-common vim emacs
# Bash sux
RUN chsh -s $(which zsh)
# Install LLVM
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x ./llvm.sh
RUN ./llvm.sh
RUN rm ./llvm.sh
RUN apt-get install clang-format clang-tidy clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm python3-clang
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 50
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 50
# Install Rust, required for xwin so we can download MSVC SDK
RUN apt install rust-all
# Install MSVC SDKs
RUN cargo install xwin --locked
ARG PATH=$PATH:/root/.cargo/bin/
ARG XWIN_ACCEPT_LICENSE=1
RUN xwin splat --output /xwin
# Clone macOS SDKs

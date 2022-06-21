ARG VERSION=5.6.2-focal
FROM swift:$VERSION
# Generic stuff to bootstrap ourself
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt -fy install python3 zsh lsb-release wget software-properties-common vim emacs cmake ninja-build
# Bash sux
RUN chsh -s $(which zsh)
# Install Rust, required for xwin so we can download MSVC SDK
RUN apt install -fy rust-all
# Install MSVC SDKs
RUN cargo install xwin --locked
ARG PATH=$PATH:/root/.cargo/bin/
ARG XWIN_ACCEPT_LICENSE=1
RUN xwin splat --output /Windows/
# Clone macOS SDKs
ADD macOS/ /macOS
# Configure vcpkg
RUN apt-get install -fy curl zip unzip tar
RUN git clone https://github.com/microsoft/vcpkg.git
RUN vcpkg/bootstrap-vcpkg.sh
# Clone CMake Toolchain wrappers
ADD CMake /CMakeToolchains


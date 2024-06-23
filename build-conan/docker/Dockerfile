FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -yq gcc g++ make cmake pipx python3.8-venv pkg-config ninja-build
ENV PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin
RUN pipx install conan && pipx install meson

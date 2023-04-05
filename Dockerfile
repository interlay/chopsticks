FROM node:18

RUN apt update && apt install -y tini && \
  apt-get autoremove -y && apt-get clean && \
  find /var/lib/apt/lists/ -type f -not -name lock -delete && \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR /app
COPY . .
RUN . "$HOME/.cargo/env" && \
    cargo --help && \
    yarn --silent && \
    yarn build-wasm

ENTRYPOINT [ "tini", "--", "yarn", "start", "xcm" ]

FROM node:18
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR /app
COPY . .
RUN . "$HOME/.cargo/env" && \
    cargo --help && \
    yarn && \
    yarn build-wasm

RUN apt update && apt install -y tini && \
  apt-get autoremove -y && apt-get clean && \
  find /var/lib/apt/lists/ -type f -not -name lock -delete

ENTRYPOINT [ "tini", "yarn", "start", "xcm" ]
#yarn start xcm --relaychain=configs/kusama.yml --parachain=configs/kintsugi.yml --parachain=configs/statemine.yml --parachain=configs/karura.yml --parachain=configs/parallel-heiko.yml --parachain=configs/bifrost.yml

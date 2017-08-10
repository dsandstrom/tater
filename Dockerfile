FROM centos:6
MAINTAINER Darrell Sandstrom

RUN yum update -y && yum clean all
RUN yum install -y wget && yum clean all

# Install dependencies
RUN yum install -y gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git && yum clean all

# Install Erlang
ENV ERLANG_VERSION 20.0
RUN wget http://erlang.org/download/otp_src_${ERLANG_VERSION}.tar.gz
RUN tar zxvf otp_src_${ERLANG_VERSION}.tar.gz
RUN cd otp_src_${ERLANG_VERSION} && ./otp_build autoconf && ./configure && make && make install

# Set the locale (en_US.UTF-8)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Build Elixir
ENV ELIXIR_VERSION 1.5.1
WORKDIR /home
RUN git clone https://github.com/elixir-lang/elixir.git
WORKDIR /home/elixir
RUN git checkout refs/tags/v${ELIXIR_VERSION}
RUN make clean install
RUN export PATH="$PATH:/home/elixir/bin"

# Install Hex
RUN mix local.hex --force

# Install Rebar
RUN mix local.rebar --force

# Install Node.js
RUN curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
RUN yum -y install nodejs

# Build Phoenix app
RUN mkdir /home/src
COPY . /home/src
RUN rm -rf /home/src/_build
RUN rm -rf /home/src/.git
RUN rm -rf /home/src/deps
RUN rm -rf /home/src/node_modules
WORKDIR /home/src

ENV MIX_ENV prod
RUN mix deps.get --only ${MIX_ENV}
RUN npm install
RUN npm run deploy
RUN MIX_ENV=${MIX_ENV} mix phoenix.digest
RUN MIX_ENV=${MIX_ENV} mix release --env=${MIX_ENV}

WORKDIR /home

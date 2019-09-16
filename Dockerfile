FROM starefossen/ruby-node:2-10-alpine
# update and upgrade packages
RUN apk update && apk upgrade && apk add --update alpine-sdk
# Install git
RUN apk add --update git openssh
# Install Firebase CLI
RUN yarn global add firebase-tools
# Install Bundler
RUN gem install bundler
# Install Jekyll
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle check || bundle install --jobs=4 --retry=3
# Tidy up
RUN apk del py-pip \
    && apk del py-setuptools \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*
# Add CLI to PATH
ENV PATH "$PATH:/root/.local/bin"
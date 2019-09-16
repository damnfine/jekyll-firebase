FROM node:10 AS nodejs

FROM ruby:2

ENV LANG C.UTF-8

ENV NODE_MAJOR 10

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

COPY --from=nodejs /usr/local/bin/node /usr/local/bin/
COPY --from=nodejs /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=nodejs /opt/ /opt/

RUN ln -sf /usr/local/bin/node /usr/local/bin/nodejs \
  && ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
  && ln -sf ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
  && ln -sf /opt/yarn*/bin/yarn /usr/local/bin/yarn \
  && ln -sf /opt/yarn*/bin/yarnpkg /usr/local/bin/yarnpkg

# update and upgrade packages
RUN apt-get update -yq && apt-get upgrade -yq
# Install git
RUN apt-get install -yq bash git openssh-server
# Install Firebase CLI
RUN yarn global add firebase-tools@7.3
# Install Bundler
RUN gem install bundler
# Install Jekyll
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle check || bundle install --jobs=4 --retry=3
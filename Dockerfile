FROM starefossen/ruby-node:2-10
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
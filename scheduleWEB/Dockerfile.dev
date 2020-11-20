FROM ruby:2.6.5

# 必要パッケージ管理ツールをインストール
RUN apt-get update -qq && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn && \
curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
apt-get install -y sqlite3 libsqlite3-dev nodejs && \
yarn add bootstrap@4.3.1 jquery popper.js && \
yarn add github:nathanvda/cocoon#c24ba53

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3030

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

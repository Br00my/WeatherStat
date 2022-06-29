FROM ruby:2.6.6

ENV RAILS_ENV=development

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn nodejs postgresql-client

COPY . /myapp
WORKDIR /myapp
COPY config/database.yml.example config/database.yml
RUN gem install bundler
RUN bundle install

COPY entrypoint.sh /myapp
RUN chmod +x /myapp/entrypoint.sh
ENTRYPOINT ["/myapp/entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]

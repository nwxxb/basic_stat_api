FROM ruby:3.1.2

WORKDIR /code

COPY . /code

RUN bundle install

EXPOSE 3000

# default command, you can overwrite it in compose file
CMD ["bundle", "exec", "shotgun", "--host=0.0.0.0", "--port=3000", "./config.ru"]

FROM ruby:3.1.2

RUN apt update -y
RUN apt install libgs-dev -y
ADD https://gr-framework.org/downloads/gr-latest-Debian-x86_64.tar.gz /gr.tar.gz 
RUN tar -xvf /gr.tar.gz
ENV GRDIR="/gr"

WORKDIR /code

COPY . /code

# install GR framework for plotting

RUN bundle install

EXPOSE 3000

# default command, you can overwrite it in compose file
CMD ["bundle", "exec", "shotgun", "--host=0.0.0.0", "--port=3000", "./config.ru"]

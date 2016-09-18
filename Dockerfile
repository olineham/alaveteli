FROM ruby:2.3.1
MAINTAINER caleb.tutty@nzherald.co.nz

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive
ENV RAILS_ENV production

# Update
RUN apt-get update \
 && apt-get -y install \
      build-essential \
      ca-certificates \
      catdoc \
      elinks \
      gettext \
      ghostscript \
      git \
      gnuplot-nox \
      imagemagick \
      libicu-dev \
      libmagic-dev \
      libmagickcore-dev \
      libmagickwand-dev \
      libpq-dev \
      libxml2-dev \
      libxslt1-dev \
      links \
      lockfile-progs \
      mutt \
      pdftk \
      poppler-utils \
      postgresql-client \
      postgresql-client \
      sqlite3 \
      supervisor \
      tnef \
      unrtf \
      unzip \
      uuid-dev \
      wkhtmltopdf \
      wv \
      xapian-tools \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/alaveteli
WORKDIR /opt/alaveteli

# First just the Gemfiles so that other project changes rebuild from warm cache
ADD Gemfile /opt/alaveteli/Gemfile
ADD Gemfile.lock /opt/alaveteli/Gemfile.lock

RUN bundle install --without development debug test --deployment --retry=10 --clean

# Rest of app
ADD . /opt/alaveteli

# Add yaml configuration which take environment variables
RUN cp script/docker/database.yml config/database.yml \
 && cp script/docker/general.yml config/general.yml \
 && mkdir -p cache

CMD ./script/docker/setup.sh

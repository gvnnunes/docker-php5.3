FROM  debian:squeeze

WORKDIR /root

# Atualizando repositorios

RUN echo "deb http://archive.debian.org/debian squeeze main" > /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian squeeze-lts main" >> /etc/apt/sources.list \
    && echo 'Acquire::Check-Valid-Until "0";' > /etc/apt/apt.conf.d/00-ignore-check-valid-until \
    && echo 'APT::Get::AllowUnauthenticated "1";' > /etc/apt/apt.conf.d/00-allow-unauthenticated
   
# Timezone
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes locales

RUN sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# pt_BR ISO-8859-1/pt_BR ISO-8859-1/' /etc/locale.gen && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_US ISO-8859-1/en_US ISO-8859-1/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=pt_BR.UTF-8

ENV LANG pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Instalando php e configurando php.ini

RUN apt-get update && apt-get install -y php5 php5-cli php5-mysql php5-pgsql php5-gd php5-mcrypt php5-curl php-pear libsybdb5 freetds-common php5-sybase wget ca-certificates libsybdb5

RUN echo "mssql.textlimit = 20971520" >> /etc/php5/cli/php.ini && \
    echo "mssql.textsize = 20971520" >> /etc/php5/cli/php.ini && \
    echo "date.timezone = America/Sao_Paulo" >> /etc/php5/cli/php.ini

# Instalando e configurando o apache

RUN apt-get update && apt-get install -y apache2

COPY default.conf /etc/apache2/sites-available/default

RUN a2enmod rewrite

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

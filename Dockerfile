FROM ruby:3.2

# Instala dependencias necesarias
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Establece el directorio de trabajo
WORKDIR /app

# Copia archivos de dependencias y las instala
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia el resto de la app
COPY . .

# Exponer el puerto Sinatra
EXPOSE 4567

# Usar rackup como servidor (desde Bundler)
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "4567"]

# Gemas

<div class="main-list">

* gem cli
* bundler
</div>
----
# gem cli

<div class="main-list">

* gemas

</div>
----
## Introducción

* Una gema es un formato simple para publicar y compartir código Ruby.
* Cada gema tiene un nombre, versión y plataforma.

----
## CLI

* **Instalar una gema:** `gem install rake`
* **Buscar una gema:** `gem search sinatra`
* **Listar gemas instaladas:** `gem list`
----
# bundler

<div class="main-list">

* gemas

</div>
----
## Introducción

* Mantiene un entorno consistente para las aplicaciones ruby
* Asegura que la aplicación que lo use tenga las dependencias necesarias
  para que se ejecute sin errores.
* Bundler es una gema: `gem install bundler`

<div class="fragment small">

Bundler es análogo a [composer para PHP](https://getcomposer.org/),
[Pipenv para Python](https://pipenv.pypa.io/en/stable/), [maven para java](https://maven.apache.org/),
[npm](https://www.npmjs.com/) o [yarn](https://yarnpkg.com/) para Javascript.
**El manejo de dependencias debe realizarse según el [segundo factor de 12-factor
apps](https://12factor.net/dependencies)**.
</div>
----
## Ejemplo de uso

Definimos las dependencias en el archivo `Gemfile`

```ruby
source 'https://rubygems.org'

gem 'sinatra'
```

<div class="small fragment">

Luego instalamos las dependencias con **`bundle install`** o simplemente **`bundle`**.
</div>

----
## Comandos

```bash
# Instalar dependencias:
bundle install

# Actualizar dependencias a sus últimas versiones:
bundle update

# Ejecutar un script en el contexto del bundle actual:
bundle exec

# Ver las gemas instaladas en el bundle actual:
bundle list

# Ver donde está ubicada una gema:
bundle show NOMBRE_GEMA
```

----
## Gemfile

* Se escribe con una DSL propia de bundler.
* Puede incluir cualquier código ruby.
* La sentencia **`gem`** indica una dependencia y acepta los siguientes
parámetros:
  * **versión:** `'>= 1.1.0'`, `'~> 3.1.2'`
  * **github:** `github: 'sinatra/sinatra'`
  * **path:** para una gema local

----
## Ejemplo

```ruby
source 'https://rubygems.org'
gem 'sinatra', github: 'sinatra/sinatra'
gem 'activerecord', '~> 3.1.0'
```

----
## Uso de gemas

Con declarar las dependencias en el `Gemfile` no basta, hay que invocar a
bundler desde el código.

<div class="container">

<div class="col">

```ruby
require 'bundler'
Bundler.require


```
<div class="small">
Bundler requiere todas las dependencias.
</div>
</div>

<div class="col">

```ruby
require 'bundler'
Bundler.setup
require 'sinatra'
```
<div class="small">
Bundler configura  pero los require deben ser explícitos.
</div>
</div>
</div>
----
<!-- .slide: data-auto-animate -->
## Gemfile

Es posible definir la fuente de donde obtener las gemas:

```ruby
source 'https://rubygems.org'
```

<div class="small fragment">

Incluso es posible hacerlo por gema o grupo de gemas
</div>

----
<!-- .slide: data-auto-animate -->
## Gemfile

Es posible también indicar cómo sea **require una gema**:

```ruby
gem "redis", :require => ["redis/connection/hiredis", "redis"]
gem "webmock", :require => false
```

----
<!-- .slide: data-auto-animate -->
## Gemfile

Y por supuesto es posible definir la Versión de una gema: 

```ruby
gem 'rails', '5.0.0'
gem 'rack',  '>=1.0'
gem 'thin',  '~>1.1'
```

----
<!-- .slide: data-auto-animate -->
## Gemfile

* También es posible establecer tag, branch o ref de un repo git.
* Grupos de gemas con el fin de poder requerir o instalarlas en forma modular.
* Plataforma para la cual aplican determinadas gemas.

----
## Ejemplo

```ruby
source 'https://rubygems.org'

gem 'thin',  '~>1.1'

gem 'rspec', :require => 'spec'

gem 'my_gem', '1.0', :source => 'https://gems.example.com'

gem 'mysql2', platform: :ruby
gem 'jdbc-mysql', platform: :jruby
gem 'activerecord-jdbc-adapter', platform: :jruby

source 'https://gems.example.com' do
  gem 'another_gem', '1.2.1'
end

gem 'nokogiri', 
  :git => 'https://github.com/tenderlove/nokogiri.git', 
  :branch => '1.4'

gem 'extracted_library', :path => './vendor/extracted_library'

gem 'wirble', :group => :development
gem 'debugger', :group => [:development, :test]
group :test do
  gem 'rspec'
end
```
<div class="small">

[Ver ejemplo de Redmine](https://github.com/redmine/redmine/blob/master/Gemfile)
</div>

<img src="static/rails.svg" height="180px" />

<div class="main-list">

* introducción
* un proyecto rails
* gemas
* configuraciones
* ruteo
</div>
---
FILE: rails/introduccion.md
---
FILE: rails/proyecto.md
---
FILE: rails/gemas.md
---
FILE: rails/configuraciones.md
---
FILE: rails/ruteo.md
---
## MVC en rails
![MVC en rails](images/16/06-mvc-rails.png)

---
## MVC en rails
* En la base del stack está el navegador: el requerimiento fluye subiendo por
  las capas hasta llegar al **router** que despachará al controlador apropiado
* Existe un único `config/routes.rb` y múltiples controladores, modelos y vistas
* El controlador, al recibir el flujo, obtendrá datos de algún **modelo**
* Con los datos listos, el controlador renderizará la respuesta combinando los
  datos del modelo con una componente de **vista** que provea layout y markup

---
## MVC en rails
* Los archivos del model, controller y view serán código ruby
* Cada archivo tendrá una estructura y sintaxis específica basada en cómo se ha
  definido por el mismo framework
* Cada model, view y controller que creemos *heradará* comportamiento de
  superclases que son parte del farmework, minimizando lo que debemos codificar

---
## Models en Rails
* En la mayor parte de las aplicaciones rails, un modelo obtiene datos de una base de datos
* Sin embargo, en otros casos se obtienen de conexiones a otros servidores
* Ejemplos:
  * El model **User** podría obtener el nombre y email desde una base de datos
    local
  * El mismo modelo, podría además obtener los tweets recientes de Twitter para
    este mismo usuario, o la ciudad en la que vive desde Facebook
---
## Controllers en Rails
* Un controlador podría obtener datos de más de un modelo si fuera necesario
* Generalmente un controlador posee más de una **acción**.
  Por ejemplo, un controlador para User podría tener acciones para listar los
usuarios, agregar o eliminar un usuario de la lista
* El archivo `config/routes.rb` macheará el requermiento web a una acción del
  controlador
* En Rails se trata de limitar las acciones en un controlador a las siete
  acciones siguientes: `index`, `show`, `new`, `create`, `edit`, `update` y
`destroy`
  * Un controlador que implementa estas acciones se dice que es **RESTful**

---
## Views en Rails
* Una vista combina código ruby con markup HTML. 
* Generalmente tendremos una vista asociada a cada acción de un controlador
  * Una vista para **index** debería mostrar una lista de usuarios
  * La vista **show** proveerá detalles del perfil de un usuario
---
## Views en Rails
* Las vistas tendrán una sintaxis muy similar a HTML convencional, pero con
  algunos datos que se extraen de variables ruby o estructuras de control como
loops que permitirán crear tablas.
  * Siguiendo el principio de Separation of Concerns, es considerada una buena práctica limitar el
uso de código ruby en las vistas a sólo utilizarlo para imprimir valores de
variables.
  * Cualquier otra cosa será responsabilidad del modelo
* No todas las acciones tendrán una vista: por ejemplo la acción **destroy**
  usualmente redirige al **index**, y **create** redirige o al **show** o al
**new**
---
## Home dinámica
*Planificamos nuestro trabajo definiendo un User story*

**Birthday countdown**

* As a visitor to the website
  * I want to see the owner's name
  * I want to see the owner's birthdate
  * I want to see how many days until the 
  *   owner's next birthday
  * In order to send birthday greetings

---
## La elección de nombres
* Mucho en el arte de la programación radica en elegir nombres correctos para
  nuestras creaciones
* Necesitamos un modelo que represente el site owner. 
  * Elegiremos el nombre más obvio: **Owner** y cremos el archivo
`app/models/owner.rb`
* El nombre del controlador abre otro debate
  * Nos podríamos tentar por *Home controller* o *Welcome controller*
  * Si bien son nombres aceptables, si consideramos el **User Story** el nombre
    **Visitors controller** es más adecuado porque **visitor** es el actor
  * Creamos entonces `app/controllers/visitors_controller.rb`

---
## Convenciones de nombres
* En rails es importante como se llaman los archivos y clases definidas en
  ellos.
* Esto se debe al principio CoC
* Esto evita configuraciones innecesarias
* Al escribir código
  * `class Visitor < ActiveRecord::Base` *los nombres de las clases de modelo
    son en singular y en mayúscula*
  * `class VisitorsController < ApplicationController` *los nombres de
    controladores son la combinación de un nombre de modelo en plural con
    __Controller__ en camel case*
---
## Convenciones de nombres
* Los archivos:
  * Los archivos de modelo coinciden con el nombre del modelo , pero en
    minúscula: `app/models/visitor.rb`
  * Los archvios de controlador coinciden con la clase, pero usando snake case:
  `app/controllers/visitors_controller.rb`
  * La carpeta de las vistas coinciden con el nombre de la clase del modelo,
    pero en plural y en minúscula: `app/views/visitors`

---
## Routing
Crearemos primero el ruteo antes de implementar el model y controller

### Editamos config/routes.rb

```ruby
Rails.application.routes.draw do
  root to: 'visitors#new'
end
```

* Los detalles de la sintaxis de este archivo puede 
  entenderse bien leyendo [Routing from outside in](http://guides.rubyonrails.org/routing.html)
* Modificando `config/routes.rb` no requiere reiniciar

---
## Probamos http://localhost:3000

Esperamos obtener un error

![Error sin better errors](images/16/07-no-better-errors.png)

El error es claro: **uninitialized constant VisitorsController** indicando que
Rails busca la clase y no puede encontrarla

<small>
Podemos mejorar el error agregando la gema `better_errors` al `Gemfile`
</small>

---
## El modelo

* La mayoría de los modelos rails obtienen datos desde una base de datos
* Cuando se utiliza una base de datos, es posible usar el comando: `rails
  generate model` para crear un modelo que hereda de **ActiveRecord**
y conoce como conectarse con la base de datos
* Para este ejemplo no necesitamos una base de datos
	* Nuestra clase simplemente definirá los métodos necesarios

---
## Implementamos el Modelo

```ruby
class Owner
  def name
    'Foobar Kadigan'
  end

  def birthdate
    Date.new(1990, 12, 22)
  end

  def countdown
    today = Date.today
    birthday = Date.new(today.year, 
            birthdate.month, 
            birthdate.day)
    if birthday > today
      countdown = (birthday - today).to_i
    else
      countdown = (birthday.next_year - today).to_i
    end
  end

end
```

---
## La Vista
* Como ya mencionamos en las convenciones de nombres, las vistas van en
  `app/views/`
* En una aplicación convencional, un controlador puede renderizar múltiples
  vistas, por lo tanto se crea un directorio para cada controlador
  * En nuestro caso creamos `mkdir app/views/visitors`

**Creamos entonces `app/views/visitors/new.html.erb`**

```html
<h3>Home</h3>
<p>Welcome to the home of <%= @owner.name %>.</p>
<p>I was born on <%= @owner.birthdate %>.</p>
<p>Only <%= @owner.countdown %> days until my birthday!</p>
```

---
## La Vista
* Con lo anterior tenemos únicamente la vista **new** para el controlador
  visitor
* La extensión es **erb** porque usamos el motor ERB para armar nuestros
  templates
* En el ejemplo, y por defecto en rails, se utiliza ERB, pero es posible utilizar gemas que
  proveen [Haml](http://railsapps.github.io/rails-haml.html) o [Slim](http://slim-lang.com/) como motores de templating. 
  * Si usaramos por ejemplo haml, la vista sería **new.html.haml**
* En la vista, podemos ver que el markup de ERB utiliza los tags `<%=` y
  `%>`
---
## La Vista
* El acceso a los datos del modelo **Owner** se hace a través de `@owner`
  * Esto se entenderá mejor cuando creemos el controlador

**Podríamos preguntarnos por qué usar:**

```erb
<%= @owner.countdown %>
```

en vez de

```erb
<%= (Date.new(today.year, @owner.birthdate.month, @owner.birthdate.day) - Date.today).to_i %>
```

<small>
  Podríamos hacerlo, pero violaríamos SoC
</small>

---
## El controlador

* Será el *pegamento* entre el modelo Owner y la vista
  **VisitorsController#new**
  * Cuando hagamos referencia a una acción en un controlador, usaremos la
    notación *VisitorsController#new* uniendo el nombre de la clase del
controlador con el de la acción (que es un método). En este contexto, el
caracter **#** es una convención usada en la documentación 
  * El nombre de la clase será `VisitorsController` pero el nombre del archivo
    **visitors_controller.rb**

---
## Escribimos el controlador
Creamos `app/controllers/visitors_controller.rb`

```ruby
class VisitorsController < ApplicationController
  def new
    @owner = Owner.new
  end
end
```

**¿Qué hace?**

* Al ser subclase de ApplicationController hereda todo el comportamiento
  definido por la API de rails
* Solo implementa el método `new`
  * Creamos una variable de instancia `@owner` dado que en la vista
    correspondiente estará disponible. 

---
## Relación controlador y vista

* Ya creamos una vista llamada `app/views/visitors/new.html.erb`
* El controlador es muy simple dado que el comportamiento oculto que invoca la
  vista *new* es heredado de la API de rails.
  * Podemos hacer explícita esta relación

**Indicando qué vista usar en el controlador**

```ruby
class VisitorsController < ApplicationController
  def new
    @owner = Owner.new
    render 'visitors/new'
  end
end
```
---
## Scaffolding
* La mejor forma de entender la arquitectura MVC de rails es examinando cada una
  de las partes como hemos hecho hasta aquí
* Si se lee la guía de rails: [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html) veremos que se utiliza mucho el comando `rails generate scaffold` que permite crear MVC en una única operación
	* Esta operación es muy usada para desarrollar módulos simples en rails
---
## Resolviendo problemas

* Veremos algunas técnicas que ayudan a resolver problemas
  * Rails console
  * Rails logger
  * Stack trace
  * Raising exceptions

---
## Rails console
* IRB solamente evalúa expresiones que son definidas por la API de ruby
* IRB no conoce las clases de rails
* Rails console carga toda la aplicación rails en una consola IRB

```bash
$ bundle exec rails console
Loading development environment (Rails X.Y.Z)
irb(main):001:0> 
```

<small>
*Notamos que se cargó el ambiente de development*
</small>

---
## Rails console
Inspeccionamos el modelo

```bash
irb(main):001:0> owner = Owner.new
=> #<Owner:0x007f7eccd77e48>

irb(main):002:0> owner.name
=> "Foobar Kadigan"
```
---
## Rails logger
* Las aplicaciones rails envían información de diagnóstico a un *archivo de log*
* Dependiendo del ambiente en el que corre la aplicación, el log será:
	* **log/development.log**
	* **log/production.log**
* En el ambiente de desarrollo, todo log escrito en el archivo es además enviado
  a la consola de donde se corre el comando `rails server`
* Además de los logs por defecto de rails, podemos usar nosotros **logger**

---
## Rails logger
Modificamos `app/controllers/visitors_controller.rb`

```ruby
class VisitorsController < ApplicationController
  def new
    Rails.logger.debug 'DEBUG: entering new method'
    @owner = Owner.new
    Rails.logger.debug "DEBUG: Owner name is #{@owner.name}"
  end
end
```

Ahora la salida en la consola será

```bash
Started GET "/" for 127.0.0.1 at ...
Processing by VisitorsController#new as HTML
DEBUG: entering new method
DEBUG: Owner name is Foobar Kadigan
Rendered visitors/new.html.erb within layouts/application (0.2ms)
Completed 200 OK in 8ms (Views: 4.6ms | ActiveRecord: 0.0ms)
```

---
## Rails logger
* Podemos usar **Rails.logger** en nuestros modelos
* En los controladores, es posible usar el método **logger** directamente
* Es posible usar:
  * `logger.debug`
  * `logger.info`
  * `logger.warn`
  * `logger.error`
  * `logger.fatal`
* En el ambiente de desarrollo todos los logs se mostrarán
* En el ambiente de producción no se visualizarán los logs enviados a
  `logger.debug`

---
## El Stack Trace

* Si bien el logger es muy útil, hay casos en donde el programa se colgará y la
  consola mostrará un *stack trace*
* Provocamos un error agregando en el controlador un error

**Generamos el error**

```ruby
class VisitorsController < ApplicationController
  def new
    Rails.logger.debug 'DEBUG: entering new method'
    @owner = Owner.new
    Rails.logger.debug 'DEBUG: Owner name is ' + @owner.name
    DISASTER
  end
end
```

<small>En vez de DISASTER, podría haberse usado `console` proporcionado por
**web-console**</small>
---
## Al ingresar a la página veremos
![error stack trace](images/16/08-stacktrace.png)

---
## El Stack Trace

La captura muestra el error así porque usamos la gema **web-console**

### En la consola veremos
```bash
Started GET "/" for 127.0.0.1 at 2013-12-08 20:09:18 -0300
Processing by VisitorsController#new as HTML
DEBUG: entering new method
DEBUG: Owner name is Foobar Kadigan
Completed 500 Internal Server Error in 2ms

NameError - uninitialized constant VisitorsController::DISASTER:
  activesupport (4.0.1) lib/active_support/dependencies.rb:501:in `load_missing_constant'
  ...
```

---
## El Stack Trace
* No hay que sentirse abrumado por la cantidad de información
* Muchas veces la explicación del problema está en la primer línea
* Otras veces tenemos que avanzar sobre la pila leyendo cuidadosamente el
  problema

---
## Lanzando excepciones
* El ejemplo del stack trace hace uso de una directiva desconocida por rails
* Una solución más elegante sería lanzar una excepción

```ruby
class VisitorsController < ApplicationController
def new
  Rails.logger.debug 'DEBUG: entering new method'
    @owner = Owner.new
    Rails.logger.debug ".."
    raise 'Deliberate Failure'
  end
end
```

### Más recursos...
[RailsGuide: Debugging Rails Applications](http://guides.rubyonrails.org/debugging_rails_applications.html)
---
## Referencias
* [Learn Ruby on Rails](http://learn-rails.com/learn-ruby-on-rails.html)
* [Rails Guides](http://guides.rubyonrails.org/)
* [Rails Documentation](http://api.rubyonrails.org/)
* [Rails Beginner Cheat Sheet](http://pragtob.github.io/rails-beginner-cheatsheet/index.html)
* [Railscasts](http://railscasts.com/)
* [Uso de concerns: como poner a dieta los modelos regordetes](http://37signals.com/svn/posts/3372-put-chubby-models-on-a-diet-with-concerns)
***

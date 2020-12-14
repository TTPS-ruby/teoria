# resolviendo problemas

<div class="main-list">

* rails

</div>
----
## Introducción

Veremos algunas técnicas que ayudan a resolver problemas
* Rails console
* Rails logger
* Causando errores

----
## Rails console

* IRB solamente evalúa expresiones que son definidas por la API de ruby
* IRB no conoce las clases de rails
* Rails console carga toda la aplicación rails en una consola IRB

```bash
bundle exec rails console
```

> Notamos que se cargó el ambiente de development

----
<!-- .slide: data-auto-animate -->
## Rails logger
* Las aplicaciones rails envían información de diagnóstico a un **archivo de log**.
* Dependiendo del ambiente en el que corre la aplicación, el log será:
	* **`log/development.log`**
	* **`log/production.log`**
* En el ambiente de desarrollo, todo log escrito en el archivo es además enviado
  a la consola de donde se corre el comando `rails server`.
* Además de los logs por defecto de rails es posible usar el objeto **logger**.

----
<!-- .slide: data-auto-animate -->
## Rails logger

Para usar este objeto mostramos un ejemplo:

```ruby
class VisitorsController < ApplicationController
  def new
    Rails.logger.debug 'DEBUG: entering new method'
    @owner = Owner.new
    Rails.logger.debug "DEBUG: Owner name is #{@owner.name}"
  end
end
```
----
<!-- .slide: data-auto-animate -->
## Rails logger

<div class="small">

* Podemos usar **`Rails.logger`** en modelos.
* En los controladores, es posible usar el método **`logger`** directamente
* Es posible usar:
  * `logger.debug`
  * `logger.info`
  * `logger.warn`
  * `logger.error`
  * `logger.fatal`
* Generalmente en el ambiente de **desarrollo _todos los logs se mostrarán_**,
  mientras que en  **producción _no se visualizarán los logs enviados a
  `logger.debug`_**.
</div>

----
<!-- .slide: data-auto-animate -->

## Causando errores

* Si bien **logger** es muy útil, hay casos en donde el programa abortará ante
  una excepción en la que se mostrará el **stack trace**.
* Es común provocar un error para evaluar el contexto de un controlador.

<div class="small">

**Generamos un error**

<pre><code class="ruby hljs" data-trim data-line-numbers="4">
class VisitorsController < ApplicationController
  def new
    @owner = Owner.new
    DISASTER
  end
end
</code></pre>

> Notar que el manejador en modo desarrollo deja una consola

</div>

----

## Más recursos...

[RailsGuide: Debugging Rails Applications](http://guides.rubyonrails.org/debugging_rails_applications.html)

# ruteo

<div class="main-list">

* rails

</div>
----
## Páginas estáticas y ruteo
* Una aplicación rails puede servir páginas estáticas como cualquier web server.
* Estas páginas no contienen código ruby: _esto hace que se sirvan de forma más
  rápida y usando menos recursos_.
* Empezar por crear páginas estáticas nos ayudará a entender el ruteo en rails.

<div class="small fragment">

Es importante diferenciar un **application server** de un **web server**.
</div>

----
## Agregamos la home page

* Nos aseguramos tener iniciado el server rails: **`bundle exec rails s`**
* Ingresamos a [http://localhost:3000/](http://localhost:3000/)
* Veremos la página de información por defecto de rails.

Creamos el archivo **`public/index.html`**

```html
<h1> Hello World </h1>
```

> Actualizamos la página y...rails observará los cambios de la carpeta
> `public/`. Si no se especifica ningún archivo en la URL, se asume **index.html**

----
## Error de ruteo

¿Qué sucede si accedemos a [/about.html](http://localhost:3000/about.html)?

![routing error](static/rails-routing-error.png)
<!--.element: class="fragment" -->

----

## Solucionamos el error

Agregamos **`public/about.html`**:

```html

<h1> About </h1>

```

> Si volvemos a probar, ahora todo debería funcionar bien.
<!-- .element: class="fragment" -->

----
## Ruteo dinámico

* El principio de *CoC* gobierna el ruteo en rails.
* Si un navegador solicita **index.html** entonces Rails servirá la página desde
  el directorio **`public/`**.
  * No se necesita configuración para ello

<div class="fragment" >

* ¿Si queremos cambiar este comportamiento?
  * Haremos que la home page sea ahora el about
  * Debemos **_eliminar_** **`public/index.html`**
</div>

----
## Editamos config/routes.rb

```ruby
Rails.application.routes.draw do
  root to: redirect('/about.html')
end
```

> Indicamos que al acceder a la raíz del proyecto redirija a `about.html`. El
> concepto de redirect utiliza mensajes [HTTP 301](https://httpstatuses.com/)
<!-- .element: class="fragment"-->

----
## Una reflexión

* No es obvio el por qué las páginas se sirven de **`public/`**.
* Si se desconoce esta convención, podemos rompernos la cabeza buscando donde se
  mapea que http://localhost:3000 sirva **`public/index.html`**
* La razón es que el application server de rails generalmente se utiliza detrás
  de un web server por cuestiones de eficiencia.
----
## Request & response


* Debemos considerar que la WEB no es más que navegadores que solicitan páginas
  a un servidor.
* Los navegadores realizan **requerimientos** (request).
* Los servidores **responden** (response) a estos requerimientos, enviando, por ejemplo, un
  HTML.
* La simplicidad de HTTP hace que no haya más que los requerimientos de un
  navegador y las respuestas de un servidor.

----
## El ciclo request / response

![request repsonse](static/rails-request-response.png)

----
<!-- .slide: data-auto-animate -->
## El ciclo desde el navegador

<div class="small">

* Es aconsejable usar el navegador para observar las peticiones HTTP.
* Antes de investigar algo, es conveniente utilizar el **modo incógnito**: que
  se accede usando **Shift+Ctrl+N** (**Shift+Ctrl+P** en Firefox).
  * Alternativamente puede limpiarse la caché del navegador para así limpiar
    cualquier solicitud previamente cacheada por el navegador.
* Abrimos la vista *Developer Tools* usando **Shift+Ctrl+I**:
  * Seleccionamos el tab **Network**.
  * Realizamos el requerimiento [http://localhost:3000/about.html](http://localhost:3000/about.html).
  * Visualizaremos los archivos recibidos desde el servidor: sólo uno
    **about.html**.

> Notar cuando no es "fresco" el requerimiento
<!-- .element: class="fragment" -->
</div>
----
<!-- .slide: data-auto-animate -->
## El ciclo desde el navegador

* Verificar las cabeceras de un requerimiento HTTP 304.
* Específicamente observar el detalle del campo **`If-Modified-Since`**.
* Contrastar con la salida del comando **`TZ=UTC stat public/about.html`**.
* Ejecutar **`touch public/about.html`**.
* Cargar de nuevo la página y verificar el código de retorno.

----
<!-- .slide: data-auto-animate -->
## El ciclo desde el navegador

* Hasta ahora vimos las herramientas que disponemos desde el navegador
* Pero no podemos visualizar qué es lo que sucede en el servidor

**Analizamos la consola del servidor:**

```bash

Started GET "/" for 127.0.0.1 at ...

```

> Es importante destacar que no hay logs para los archivos servidos desde la
> carpeta **`public/`**.
<!-- .element: class="fragment" -->


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

**Creemos el archivo `public/index.html`**

```html
<h1> Hello World </h1>
```

> * Actualizamos la página y...rails observará los cambios de la carpeta `public/`
> * Si no se especifica ningún archivo en la URL, se asume **index.html**

----
## Error de ruteo

¿Qué sucede si accedemos a [http://localhost:3000/about.html](http://localhost:3000/about.html)?

![routing error](images/16/01-routing-error.png)

---
## Agregamos public/about.html

```html

<h1> About </h1>

```

*Ahora todo debería funcionar bien*

---
# Ruteo
---
## Introduciendo el ruteo
* El principio de *convention over configuration* gobierna el ruteo en rails
* Si un navegador solicita **index.html** entonces Rails servirá la página desde
  el directorio `public/` por defecto
	* No se necesita configuración para ello
* ¿Si queremos cambiar este comportamiento?
	* Haremos que la home page sea ahora el about
	* Debemos **eliminar** public/index.html: `rm public/index.html`

---
## Editamos config/routes.rb

```ruby
Rails.application.routes.draw do
  root to: redirect('/about.html')
end
```

---
# Una reflexión
* El caso anterior es un ejemplo de la *magia de rails* 
* Algunos desarrolladores consideran que *convention over configuration* es
  **magia negra**
* No es obvio el por qué las páginas se sirven de `public/`
* Si se desconoce esta convención, podemos rompernos la cabeza buscando donde se
  mapea que http://localhost:3000 sirva `public/index.html`
	* El código que implementa esto, está enterrado profundamente en el corazón de
	  rails
---
## Request & response
* Analizaremos el patron MVC desde la perspectiva de la web
* Debemos considerar que la WEB no es más que navegadores que solicitan páginas
  a un servidor
* Los navegadores realizan **requerimientos** (request)
---
## Request & response
* Los servidores **responden** (response) a estos requerimientos, enviando, por ejemplo, un
  HTML.
  * Dependiendo en los encabezados del HTML, el navegador deberá realizar más
    requerimientos para obtener estilos, javascripts e imagenes
* La simplicidad de HTTP hace que no haya más que los requerimientos de un
  navegador y las respuestas de un servidor
  * Hoy día existe además el streaming de audio/video que requieren un pipe
    entre el navegador y el servidor, pero aún así, un requerimiento y respuesta inicial 
    hacen posible la incialización del stream

---
## El ciclo request / response

![request repsonse](images/16/02-request-response.png)

---
## Analizando el ciclo desde el navegador
* Es aconsejable usar [Google Chrome](https://www.google.com/chrome)
* Antes de investigar algo, es conveniente utilizar el **modo incógnito**: que
  se accede usando **Shift+Ctrl+N** (**Shift+Ctrl+P** en Firefox)
  * Alternativamente puede limpiarse la caché del navegador para así limpiar
    cualquier solicitud previamente cacheada por el navegador 
* Abrimos la vista *Developer Tools* usando **Shift+Ctrl+I**
  * Seleccionamos el tab **Network**
  * Realizamos el requerimiento [http://localhost:3000/about.html](http://localhost:3000/about.html)
  * Visualizaremos los archivos recibidos desde el servidor: sólo uno
    **about.html**
---
## Analizando el ciclo desde el navegador

Así debe verse el requerimiento

![ejemplo chrome ok](images/16/03-navegador-ok.png)

---
## Analizando el ciclo desde el navegador

Notar cuando no es "fresco" el requerimineto

![ejemplo chrome ok](images/16/03-navegador-not-ok.png)

---
## El detalle del requerimiento

<small>
Cliqueando sobre el nombre del archivo, y luego sobre la solapa **Headers**, se visualiza el detalle del requerimiento y su respuesta
</small>

![ejemplo chrome detalle](images/16/04-navegador-detalle.png)

---
## Analizamos lo que muestra el navegador
* Que el requerimiento se compone de:
  * Un request a la URL http://localhost:3000/about.html 
  * Que el método HTTP empleado fue GET
  * Los headers del request incluyendo cookies y el identificador del UA
* La respuesta se compone de:
  * El código de estado: 200 OK o 304 Not modified
  * Los headers de la respuesta: incluyendo fecha y hora, así como el
    identificador del servidor
  * HTML

<small>
Ahora podemos analizar cómo el requerimiento a **http://localhost:3000/**
devuelve dos entradas por el redirect
</small>

---
## Analizamos ahora desde el lado del servidor
* Hasta ahora vimos las herramientas que disponemos desde el navegador
  * Pero no podemos visualizar qué es lo que sucede en el servidor

**La ventana de consola del servidor muestra:**

```bash

Started GET "/" for 127.0.0.1 at ...

```

<small>
Es importante destacar que no hay logs para los archivos servidos desde la
carpeta `public/`
</small>

---
# Model View Controller
---
## MVC en la web

El siguiente gráfico muestra qué sucede en el servidor durante el ciclo
request-response 

![ciclo request response](images/16/05-ciclo-completo-rails.png)

<small>
Algunos expertos opinan que la arquitectura de la web no se ajusta al original
diseño de MVC creado para aplicaciones visuales de escritorio
</small>


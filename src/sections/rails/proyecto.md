# un proyecto rails

<div class="main-list">

* rails

</div>
----
## Creamos una aplicación

Asumimos ya instalada la gema de rails, corremos:

```bash
rails new ttps-ruby
```

> El parámetro **ttps-ruby** indica el nombre del proyecto. Puede usarse
> cualquier nombre.

<div class="small">

El instalador sin opciones ha instalado varias gemas más que vienen con una
aplicación rails por defecto:

</div>

```bash
cd ttps-ruby && bundle list
```

> La instalación por defecto requiere node y yarn para poder integrar [webpacker](https://github.com/rails/webpacker/).

----
## Iniciamos el servidor web

Con los pasos anteriores hemos creado una aplicación simple con valores por
defecto que ya puede usarse:

```bash
$ bundle exec rails server
```

> Es posible que la aplicación no inicie si no se dispone de node/ yarn
> instalados.

<div class="fragment small">

_Recordar la opción **`--help`** para ver más opciones para el subcomando
server_.
</div>

----
## Analizamos la aplicación

* Accedemos a la aplicación usando la URL [http://localhost:3000](http://localhost:3000).
* Observar que al usar el navegador, la consola donde se inició el web server
  se actualiza con información.
  * Estos mismos mensajes se almacenan en **`log/development.log`**.
----
## Paramos el servicio

* El web server puede pararse con **Control+C**.
* No es necesario reiniciar el servidor en caso de modificar el proyecto.
  * Así sucede en el ambiente **development**.
  * Los casos que requiere reiniciar son: 
    * Cuando se cambia el **`Gemfile`**.
    * Al cambiar archivos de configuración 

----
## Estructura del proyecto


<div class="small">

| Archivo | Descripción |
| ---- | --- |
| **`Gemfile[.loc]`** | Gemas del proyecto y lock |
| **`README.md`** | Documentación en markdown |
| **`app/`** | Carpetas y archivos de la aplicación |
| **`config/`** | Carpetas y archivos de configuración |
| **`db/`** | Carpetas y archivos de la DB |
| **`public/`** | Archivos sin código ruby para ser servidos por un web server |
| **`Rakefile`** | Directivas para rake. Tareas de gestión del proyecto |
| **`bin/`** | Ejecutables del proyecto |
| **`config.ru`** | Configuración para Rack |
| **`lib/`** | Directorio para código ruby variado |
| **`log/`** | Logfiles del proyecto |
| **`tmp/`** | Archivos temporales del proyecto |
| **`vendor/`** | Librerías externas por fuera del Gemfile |

----
<!-- .slide: data-auto-animate -->
## El directorio app/

<div class="small">

Si listamos el contenido del directorio, nos encontramos con varias carpetas que
estarán presentes en todo proyecto rails:
</div>

* `assets/`
* `channels/`
* **`controllers/`**
* `helpers/`
* `javascripts/`
* `jobs/`
* `mailers/`
* **`models/`**
* **`views/`**

----
<!-- .slide: data-auto-animate -->
## El directorio app/

<div class="small">

* Aquí se hace evidente el patrón **model view controller**.
* La carpeta **`mailers/`** contempla código para el envío de mails.
* La carpeta **`helpers/`** contiene **view helpers**, que son pequeñas porciones de
  código reusable que generan HTML. Podríamos definirnos como macros que
  expanden un pequeño comando en strings más extensos de tags HTML y contenido.
* La carpeta **`assets/`** contiene estilos CSS y Javascripts que son procesados
  por *assets pipeline*, mientras que **`javascripts/`** es utilizada por
  **webpacker**.
* La carpeta **`channels/`** contiene código de websockets.
* La carpeta **`jobs/`** contiene tareas asíncronas.

</div>

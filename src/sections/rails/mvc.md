# mvc

<div class="main-list">

* rails

</div>
----
## MVC en la web

El siguiente gráfico muestra qué sucede en el servidor durante el ciclo
request-response 

![ciclo request response](static/rails-ciclo-completo.png)

> Hay quienes opinan que la arquitectura de la web no se ajusta al original
> diseño de MVC creado para aplicaciones visuales de escritorio
<!-- .element: class="frafgment" -->

----
<!-- .slide: data-auto-animate -->

## MVC en rails

![MVC en rails](static/rails-mvc.png)

----
<!-- .slide: data-auto-animate -->
## MVC en rails

<div class="small">

* **En la base del stack está el navegador:** el requerimiento fluye subiendo por
  las capas hasta llegar al **router** que despachará al controlador apropiado.
* Existe un único **`config/routes.rb`** y múltiples controladores, modelos y vistas.
* El **controlador**, al recibir el flujo, obtendrá datos de algún **modelo**.
* Con los datos listos, el controlador renderizará la respuesta _combinando_ los
  datos del modelo con una componente de **vista** que provea **_layout_** y
  **_markup_**.
* _Los archivos del model, controller y view serán código ruby_.
* Cada archivo tendrá una **estructura** y **sintaxis** específica basada en cómo se ha
  definido por el mismo framework.
* Cada model, view y controller que creemos **heradará** comportamiento de
  superclases que son parte del farmework, minimizando lo que debemos codificar.
</div>
----
## Modelos en Rails

* Generalmente son objetos de AR.
* En la mayor parte de las aplicaciones rails, un modelo obtiene datos de una
  base de datos.
* Sin embargo, en otros casos se obtienen de conexiones a otros servicios.
* Ejemplos:
  * El model **User** podría obtener el nombre y email desde una base de datos
    local.
  * El mismo modelo, podría además obtener los tweets recientes de Twitter para
    este mismo usuario, o la ciudad en la que vive desde Facebook.
----
## Controladores en Rails

<div class="small">

* Un controlador podría obtener datos de más de un modelo si fuera necesario.
* Generalmente un controlador posee más de una **acción**.
  * Por ejemplo, un controlador para **`User`** podría tener acciones para
    listar los usuarios, agregar o eliminar un usuario de la lista.
* El archivo **`config/routes.rb`** macheará el requerimiento web a una acción
  del controlador.
* En Rails se trata de limitar las acciones en un controlador a las siete
  acciones siguientes: **`index`, `show`, `new`, `create`, `edit`, `update` y
  `destroy`**.
  * Un controlador que implementa estas acciones se dice que es **RESTful**.
</div>
----
## Vistas en Rails

<div class="small">

* Una vista combina código ruby con markup HTML.
* Generalmente tendremos una vista asociada a cada acción de un controlador:
  * Una vista para **index** debería mostrar una lista de usuarios.
  * La vista **show** proveerá detalles del perfil de un usuario.
* Las vistas tendrán una sintaxis muy similar a HTML convencional, pero con
  algunos datos que se extraen de variables ruby o estructuras de control como
  loops que permitirán crear tablas.
  * Siguiendo el principio de Separation of Concerns, es considerada una buena
    práctica limitar el uso de código ruby en las vistas a sólo utilizarlo para
    imprimir valores de variables.
  * Cualquier otra cosa será responsabilidad del modelo.
* No todas las acciones tendrán una vista: por ejemplo la acción **destroy**
  usualmente redirige al **index**, y **create** redirige o al **show** o al **new**.
</div>

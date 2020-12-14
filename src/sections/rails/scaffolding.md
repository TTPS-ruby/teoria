# scaffolding

<div class="main-list">

* rails

</div>
----
## Scaffolding

El concepto de scaffold lo utilizan varios frameworks para simplificar la
generación de código a partir de templates parametrizables que
aceleran la generación inicial de CRUD para modelos. Luego se podrá construir a
partir de estos templates personalizando con código.

Rails, tiene un potente mecanismo de scaffolding que nos permitirá ir armando un
proyecto rails de forma simple y automática.

----

## ¿Qué automatiza rails?

La generación de:

* Modelos a partir de migraciones y el código ruby asociado.
* Controladores y rutas que implementan CRUD.
* Vistas que materiaizan las funciones requeridas en cualquier CRUD.

----
<!-- .slide: data-auto-animate -->

## Ejemplo

```bash
rails generate books
```

El comando generará:

* `BooksController`
* El modelo para `Book`
* Una entrada en `config/routes.rb` para [`resources :book`](https://guides.rubyonrails.org/routing.html#resources-on-the-web)
* Tests asociados
* Vistas para cada acción del controlador bajo la carpeta `app/views/books`

----
<!-- .slide: data-auto-animate -->
## Ejemplo

Lo probamos accediendo a:

[http://localhost:3000/books](http://localhost:3000/books)

y veremos que....

<div class="fragment">

Primero debemos correr las migraciones

```bash
rails db:migrate
```
</div>
<div class="fragment">


**¡¡los libros no tienen campos!!**
</div>

----

## Scaffold con campos

Para mejorar nuestro ejemplo, desharemos lo que hicimos y luego volveremos a
correr el comando pero especificando algunos campos.

**Eliminar lo generado por el scaffold**

```bash
rails db:rollback
rails destroy scaffold books
```

**Crear un nuevo scaffold con campos**

```bash
rails generate scaffold books \
  title:string author:string publication_year:integer
```
----
## Otros generators

Rails provee generators para las diferentes componentes:

```bash
rails generate model Fruit name:string color:string
rails generate controller Fruit
rails generate migration CreateResource \
  name:string description:text
```


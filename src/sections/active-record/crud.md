# crud

<div class="main-list">

* active record

</div>
----
## ¿Qué es CRUD?
CRUD significa **C**reate, **R**ead, **U**pdate, **D**elete.

<div class="fragment">

> En criollo solemos decirle ABM, aunque nos falta una letra para que sea
completa la comparación.
</div>
----
<!-- .slide: data-auto-animate -->
## Creación
* Los objetos Active Record pueden crearse desde:
  * Un Hash
  * Un bloque
  * Setear manualmente los atributos luego de la creación
* El método `new` retornará un objeto **nuevo** mientras que `create` retornará
  un objeto y lo **guardará** en la base de datos
----
<!-- .slide: data-auto-animate -->
## Creación

Creamos usando un hash:
```ruby
user = User.create(name: "David",
                   occupation: "Code Artist")
```

<div class="fragment">

Es lo mismo que hacerlo con atributos:
```ruby
user = User.new
user.name = "David"
user.occupation = "Code Artist"
user.save
```
</div>
----
<!-- .slide: data-auto-animate -->
## Creación

Creación con bloques

```ruby
user = User.new do |u|
  u.name = "David"
  u.occupation = "Code Artist"
end
```

> funciona tanto con **`new`** como **`create`**.

----
## Lectura

```ruby
# return a collection with all users
users = User.all

# return the first user
user = User.first

# find all users named David who are Code Artists and 
# sort by created_at inreverse chronological order
users = User.where(name: 'David', 
                   occupation: 'Code Artist').
                   order('created_at DESC')
```

----
## Actualización

Una vez que un dato es recuperado, sus atributos pueden modificarse y luego
almacenarse en la base de datos nuevamente

```ruby
user = User.find_by(name: 'David')
user.name = 'Dave'
user.save

# Lo mismo pero más corto
user = User.find_by(name: 'David')
user.update(name: 'Dave')

# Para cambios masivos
User.update_all "max_attempts = 3, must_change_pwd = 'true'"
```

----
## Eliminación

De igual forma, una vez recuperado un objeto Active Record, podrá destruirse 
y a su vez eliminarse de la base de datos

```ruby
user = User.find_by(name: 'David')
user.destroy
```

----
<!-- .slide: data-auto-animate -->
## Validaciones

* Active Record permite validar el estado de un modelo antes de que sea escrito
  a la base de datos.
* Existen varios mecanismos para validar y chequear que ciertos atributos no
  sean blanco, no vacío, únicos, tener un formato específico, etc. 
* Las validaciones deben ser consideradas a la hora de persistir datos en la
  base de datos.
----
<!-- .slide: data-auto-animate -->
## Validaciones
* Los métodos como `create`, `save` y `update` usan validaciones.
* Retornan `false` cuando la validación falla y no actualizan el dato en la
  base de datos.
* Todos estos métodos tiene sus correspondientes con `bang!` (**`create!`**,
  **`save!`** y **`update!`**) que son estrictos en cuanto a lanzar una
  excepción **`ActiveRecord::RecordInvalid`** cuando la validación falla.

----
<!-- .slide: data-auto-animate -->
## Validaciones

<div class="container">
<div class="col">

```ruby
class User < ActiveRecord::Base
  validates :name, presence: true
end
```
</div>
<div class="col">

```ruby
User.create  
# => User not persisted
User.create! 
# => ActiveRecord::RecordInvalid: 
#    Validation failed: 
#    Name can't be blank
```
</div>
</div>

----
## Callbacks

* Active Record callbacks permiten adjuntar código a ciertos eventos en el ciclo
  de vida de los modelos.
* Permiten agregar comportamiento a los modelos que es ejecutado de forma transparente 
  cuando estos eventos suceden.
* Pueden agregarse eventos cuando se crea un nuevo registro, al modificarse, al
  eliminarse, etc.


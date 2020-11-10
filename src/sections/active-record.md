# Active Record

<div class="main-list">

* introducción
* crud
* migraciones
* validaciones
* asociaciones
</div>
----
# introducción

<div class="main-list">

* active record

</div>
----
<!-- .slide: data-auto-animate -->
## Introducción

* Conecta clases a tablas de una base de datos estableciendo una capa de
  persistencia.
* La librería provee una clase base que al heredarse, mapea la nueva clase
  con una tabla existente de una base de datos.
* En el contexto de una aplicación a estas clases se las llama **modelos**.
* Los modelos pueden conectarse con otros modelos usando **asociaciones**.
----
<!-- .slide: data-auto-animate -->
## Introducción

* Se basa en convenciones de nombres de forma tal que utiliza el
  nombre de una clase o asociación para establecer mapeos con tablas
  de la base de datos y claves foráneas.
* A pesar de poder definir estos mapeos en forma explícita, es muy
  recomendable seguir las convenciones de nombres, especialmente durante el
  aprendizaje de la librería.
----
## ORM

* Object Relational Mapping (ORM) es una técnica que conecta objetos de una
  aplicación a tablas de un RDBMS. 
* Utilizando ORM, las propiedades y relaciones de los objetos en una aplicación
  pueden ser fácilmente almacenados y recuperados de una base de datos **sin**
  escribir SQL directamente, minimizando el código de base de datos.

----
## AR como Framework de ORM

* Representa modelos y sus datos.
* Representa asociaciones entre los modelos.
* Representa herencia entre modelos.
* Validaciones de modelos antes de ser persistidos.
* Operaciones de bases de datos de forma orientada a objetos.

----
## CoC

_Conventioin over Configuration_

* Si se siguen las convenciones adoptadas por Rails, será
  necesario escribir muy pocas configuraciones (en algunos casos ninguna
  configuración) para crear modelos.
* La configuración explícita será necesaria sólo cuando no pueda seguirse la
  convención estándar.

----
## Ejemplo

Active Record mapea automáticamente entre tablas y clases, atributos y
columnas:

<div class="small container">

<div class="col">

```ruby
class Product < ActiveRecord::Base
end
```

La clase **`Product`** se mapea automáticamente a la tabla llamada **`products`**


</div>
<div class="col">

```sql
CREATE TABLE products (
  id int(11) NOT NULL auto_increment,
  name varchar(255),
  PRIMARY KEY  (id)
);
```
</div>
</div>
<div class="fragment small">

Además se definen accessors para cada campo. En el ejemplo serían **`name`** y
**`name=`**.

[Acceso a un ejemplo
completo](https://github.com/ttps-ruby/teoria/tree/master/ejemplos/ar/00-introduccion)
</div>
----
## Convenciones de nombres

Los nombres de las clases se pluralizan para encontrar las tablas
* **`Book`** se mapea a **`books`** 
* El mecanismo de pluralización puede tanto pluralizar como singularizar 
  palabras regulares como irregulares.
* Cuando un modelo utiliza más de una palabra las clases utilizan **CamelCase** 
  y las tablas **snake_case**. Por ejemplo: la clase **`BookClub`** se mapeará con
  la tabla **`book_clubs`**.

----
## Ejemplo de mapeos

<div class="small">

Las definiciones de estos mapeos son mediante otra gema llamda
**`ActiveSupport`**.

| Modelo / Clase | Tabla / Schema|
|----------------|---------------|
| Post           | posts         |
| LineItem       | line_items    |
| Deer           | deers         |
| Mouse          | mice          |
| Person         | people        |

<div class="fragment">

Ver [ActiveSupport::Inflector](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html)

```
irb -r active_support/all
ActiveSupport::Inflector.pluralize 'person'
```

</div>
</div>
----
<!-- .slide: data-auto-animate -->
## Convenciones

Active Record utiliza convenciones para las columnas de las tablas,
dependiendo del propósito de estas columnas.
----
<!-- .slide: data-auto-animate -->
## Convenciones

* **Claves foráneas:** deben llamarse de la siguiente forma:
  **`nombre_en_singular_id`** (por ejemplo: `item_id`, `order_id`). Estos serán
  los campos por los que AR buscará cuando se creen asociaciones entre
  modelos.
* **Claves primarias:** por defecto, AR utilizará una columna de
  tipo entero llamada **`id`** como clave primaria. Cuando se usan *Migraciones de
  AR* para crear las tablas, esta columna se creará automáticamente.

----
<!-- .slide: data-auto-animate -->
## Convenciones

* **`created_at`:** esta columna automáticamente setea la fecha y hora cuando el
  registro es creado.
* **`updated_at`:** esta columna automáticamente setea la fecha y hora cuando el
  registro es actualizado.
* **`lock_version`:** agrega [optimistic
  locking](http://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html) al modelo
* **`type`:** especifica que el modelo utiliza [Single Table
  Inheritance](http://api.rubyonrails.org/classes/ActiveRecord/Base.html#label-Single+table+inheritance).
----
<!-- .slide: data-auto-animate -->
## Convenciones

* **`(association_name)_type`:** especifica el tipo de [asociaciones
  polimórifcas](http://edgeguides.rubyonrails.org/association_basics.html#polymorphic-associations).
* **`(table_name_plural)_count`:** usado para cachear el número de registros que pertenecen
  a una asociación. Por ejemplo, una columna `comments_count` en la clase `Post` que tiene muchas instancias de `Comment`, cacheará el número de comentarios existentes para cada post.

----
## Ejemplo más completo

* Usaremos herencia (STI). Para ello la superclase **debe tener(** un campo **`type`**.
* Activamos logs de AR con **`ActiveRecord::Base.logger`**
* Mostraremos además el uso de cache de una asociación. Para ello se habilita 
  creando un campo **`asociacion_en_plural_count`** y agregando un modificador
  a la asociación: **`belongs_to` llamado `counter_cache: true`**

<div class="small">

[Ver ejemplo](https://github.com/TTPS-ruby/teoria/tree/master/ejemplos/ar/01-sti-logs-cache)
</div>
----
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

----
# migraciones

<div class="main-list">

* active record

</div>
----
## ¿Qué son las migraciones?

* Son una implementación de [schema migrations](https://en.wikipedia.org/wiki/Schema_migration).
* Las migraciones son una DSL para el manejo de esquemas de bases de datos
  llamados migraciones
* Las migraciones se almacenan en archivos que son ejecutados contra una base de
  datos soportada por Active Record usando `rake`

----
<!-- .slide: data-auto-animate -->
## Migraciones

Ejemplo de una migración que crea una tabla

<div class="small">

```ruby
class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type
      t.integer :publisher_id
      t.string :publisher_type
      t.boolean :single_issue

      t.timestamps
    end
    add_index :publications, :publication_type_id
  end
end
```
</div>

----
<!-- .slide: data-auto-animate -->
## Migraciones

* Las migraciones permiten tener un registro en la misma base de datos que
  indica qué cambios se han aplicado
* Los cambios entonces pueden versionarse y comitirse o deshacerse en la base de
  datos
* Para aplicar las migraciones pendientes: `rake db:migrate`
* Para deshacer un cambio hecho: `rake db:rollback`
* La DSL es agnóstico a la base de datos: funciona en MySQL, SQLite, Oracle,
  Postgres, etc

----

## Ejemplo de migraciones

[Ver ejemplo](https://github.com/ttps-ruby/teoria/tree/master/ejemplos/ar/02-migrations)

----
## Alternativas a las Migraciones

Otros productos que hacen algo similar:

 * https://flywaydb.org/
 * http://www.liquibase.org/

----
# validaciones

<div class="main-list">

* active record

</div>

----
## Introducción

* Garantizan que se guarden datos válidos en la base de datos
* Hay alternativas:
  * Con validaciones en la DB como restricciones o store procedures, dificultan
    la portabilidad de la aplicación a otros motores. Además no es simple
    realizar los tests de la aplicación. Sin embargo, no es una mala práctica
    aplicar restricciones en la base de datos
---
## Introducción
* Más alternativas
  * Del lado del cliente usando por ejemplo JS. Pero esta funcionalidad no
    aplica a todos los usuarios, dado que un navegador puede no diponer de JS o
    un usuario mal intencionado podría enviar datos no validados de forma
    intencional
  * Validaciones en el controlador podría ser una alternativa. Sucede que el
    testeo de los controladores se complejizaría. Por otra parte es una buena
    idea mantener los controladores bien delgados

---
## ¿Cuándo ocurren las validaciones?

* Hay dos tipos de objetos en AR: 
  * Los que corresponden a una fila de la base de datos
  * Los que aún no están en la DB. Por ejemplo los objetos creados con `.new`
    hasta que no se les diga `save`
* Exite el método `.new_record?` que indica la situación de un objeto

```ruby
Person = Class.new(ActiveRecord::Base)
p = Person.new(name: "John Doe")
p.new_record?
p.save
p.new_record?
```

---
## ¿Cuándo ocurren las validaciones?

* Crear y guardar un objeto emite un `INSERT` a la DB
* Actualizar un objeto emite un `UPDATE` a la DB
	* Antes de estas acciones, se realizan las validaciones. Si alguna de las validaciones **falla** 
entonces el objeto será marcado como **inválido** y ActiveRecord no realizará el
`INSERT` o `UPDATE`
* Hay muchas formas de cambiar el estado de un objeto en la DB. Algunos métodos
  realizarán validaciones, pero otros no, significando que podrían guardarse
datos **inválidos** en la DB

---
## ¿Cuándo ocurren las validaciones?

Métodos que realizan validaciones

```ruby
create
create!
save # Puede recibir validate: false
save!
update
update!
```

Métodos que NO realizan validaciones

```ruby
decrement!
decrement_counter
increment!
increment_counter
toggle!
touch
update_all
update_attribute
update_column
update_columns
update_counters
```

---
## #valid? e #invalid?

Independientemente de los métodos antes mencionados que lanzan las
validaciones, puede utilizarse `valid?` e `invalid?` para lanzar las
validaciones

```ruby
class Person < ActiveRecord::Base
  validates :name, presence: true
end

Person.create(name: "John Doe").valid? # => true
Person.create(name: nil).valid? # => false
```

---
## Los errores

* Una vez que se realizaron las validaciones, AR almacenará los errores en
  `errors.messages`, una colección de errores indexada por el campo con errores
* Por definición un objeto será valido si la colección de errores es vacía luego
  de correr las validaciones
* Notar que un objeto creado con `new` que técnicamente es erróneo, no muestra
errores porque aún no se han corrido las validaciones

---
## Helper: acceptance 

* Se utiliza específicamente en aplicaciones WEB donde se espera que un checkbox
  sea tildado por el usuario
* No es necesario que la base de datos tenga un atributo, sino que el helper
  creará un campo virtual para este propósito

```ruby
class Person < ActiveRecord::Base
  validates :terms_of_service, acceptance: true
end
```

---
## Helper: validates_associated

* Valida las asociaciones relacionadas al objeto
* No debe utilizarse en ambas partes de una asociación porque puede terminar en
  **loop infinito**

```ruby
class Library < ActiveRecord::Base
  has_many :books
  validates_associated :books
end
```

---
## Helper: confirmation

* Se utiliza cuando dos campos de texto deben contener el mismo dato: por
  ejemplo que las direcciones de mail y su confirmación sean similares
* El campo de confirmación no debe existir, sino que crea un campo virtual
  llamado `_confirmation`
* El chequeo es realizado sólo si el campo `_confirmation` no es nil, por lo que
  debe asegurarse su exsistencia

```ruby
class Library < ActiveRecord::Base
  validates :email, confirmation: true
  validates :email_confirmation, presence: true
end
```

---
## Helper: exclusion/inclusion

Se utilizan para validar la (ex/in)clusión de valores admisibles 

```ruby
class Library < ActiveRecord::Base
  validates :subdomain, 
    exclusion: { in: %w(www us ca jp)
end

class Coffee < ActiveRecord::Base
  validates :size, 
    inclusion: { in: %w(small medium large),
    message: "%{value} is not a valid size" }
end
```

---
## Helper: format

Validan el formato con una expresión regular que se especifica usando la
opción `with:`

```ruby
class Product < ActiveRecord::Base
  validates :legacy_code, format: { 
    with: /\A[a-zA-Z]+\z/,
    message: "only allows letters" }
end
```

---
## Helper: length

Valida la longitud de un campo de diversas formas

```ruby
class Person < ActiveRecord::Base
  validates :name, length: { minimum: 2 }
  validates :bio, length: { maximum: 500 }
  validates :password, length: { in: 6..20 }
  validates :registration_number, length: { is: 6 }
end
```

---
## Helper: numericality

* Valida que el campo contenga sólo valores numéricos
* Por defecto aceptará un signo opcional seguido de un entero o punto flotante
* Para validar sólo enteros, puede usarse la opción `only_integer`
  * Además se admiten muchas otras opciones: `:greater_than`, `:greater_than_or_equal_to`, `:equal_to`, `:less_than`, `:less_than_or_equal_to`, `:odd`, `:even`


```ruby
class Player < ActiveRecord::Base
  validates :points, numericality: true
  validates :games_played, 
    numericality: { only_integer: true }
end
```
---
## Helper: presence/absence

* Valida que el atributo esté o no presente (esté vacío) usando `blank?` para
  verificar si un valor es `nil` o un string blanco (esto es vacío o consiste de
  espacios)
  * Incluso permite validar que una asociación esté presente

```ruby
class Person < ActiveRecord::Base
  validates :name, :login, :email, presence: true
end

# Es importante para usar el siguiente ejemplo que la 
# asociación use inverse_of
class LineItem < ActiveRecord::Base
  belongs_to :order
  validates :order, presence: true
end

class Order < ActiveRecord::Base
  has_many :line_items, inverse_of: :order
end
```
---
## Helper: presence/absence

* Dado que `false.blank?` es `true`, hay que tener especial cuidado con campos
  booleanos
* En el siguiente ejemplo se muestra de qué forma es posible eliminar la
  posibilidad que el campo sea `nil`
  * Para el caso de `absence` es necesario algo como: `validates :field_name,
    exclusion: { in: [true, false]` considerando que `false.present?` devuelve
    `false`

```ruby
validates :boolean_field_name, inclusion: { in: [true, false] }
validates :boolean_field_name, exclusion: { in: [nil] }
```
---
## Helper: uniqueness

* Valida la unicidad de un campo antes que sea guardado
* No considera unicidad en la base de datos
  * Por lo que dos conexiones diferentes podrían crear el mismo dato que
    esperamos sea único
  * Para evitar esto, es aconsejable agregar una restricción a nivel motor de la
    DB
* Exite la posibilidad de explicitar un alcance de la unicidad de forma de
  combinar con otros campos
* Es posible especificar otra opción `case_sesitive` para verificar la unicidad
  considerando este factor o no

```ruby
class Account < ActiveRecord::Base
  validates :email, uniqueness: true
end
```
---
## Helper: uniqueness

Más ejemplos

```ruby
class Holiday < ActiveRecord::Base
  validates :name, uniqueness: {
    scope: :year,
    message: "should happen once per year" }
end

class Person < ActiveRecord::Base
  validates :name, 
    uniqueness: { case_sensitive: false }
end
```
---
## Validaciones condicionales

* Algunas situaciones ameritan validar si un predicado es verdadero
* Esto es posible con las opciones `:if` y `:unless` que reciben:
  `Proc`, un string o arreglo
  * **Un símbolo:** invocará un método del modelo
  * **Un string:** se interpreta como código ruby como por ejemplo `validates
    :surname, presence: true, if: "name.nil?"`
  * **Un Proc:** permite escribir código inline en vez de delegarlo a un método
  * **Un arreglo**: combina multiples condiciones. Por ejemplo: `if:
    ["market.retail?", :desktop?]`

---
## Ejemplo

[Descargar ejemplo](images/samples/15/02-validaciones.zip)

[Ver
README](https://github.com/TTPS-ruby/teoria/tree/master/images/samples/15/02-validaciones)
---
# Active Record
## asociaciones

---
## Introducción

Las asociaciones simplifican la interacción entre modelos relacionados

### Asumamos los siguientes modelos

```ruby
class Customer < ActiveRecord::Base
end

class Order < ActiveRecord::Base
end
```

---
## Introducción

Si Los clientes pueden tener varias órdenes, sin asociaciones, la forma de
relacionarlos sería:

```ruby
@order = Order.create(order_date: Time.now, customer_id: @customer.id)

# Para eliminar un cliente con sus ordenes:
@orders = Order.where(customer_id: @customer.id)
@orders.each do |order|
  order.destroy
end
@customer.destroy
```

---
## La solución

```ruby
class Customer < ActiveRecord::Base
  has_many :orders, dependent: :destroy
end

class Order < ActiveRecord::Base
  belongs_to :customer
end

# Crear una orden:
@order = @customer.orders.create(order_date: Time.now)

# Eliminar un cliente:
@customer.destroy
```
---
## Tipos de asociaciones

* Las asociaciones podrán ser alguna de:
	* `belongs_to`
	* `has_one`
	* `has_many`
	* `has_many :through`
	* `has_one :through`
	* `has_and_belongs_to_many`

---
## Asociación belongs_to
* Arma una relación **uno a uno** con otro modelo
* En general se usa combinado con una asociación `has_many` o `has_one` desde el otro modelo



![belongs_to](images/15/belongs_to.png)

<small>
**Ejemplo: Clientes con múltiples órdenes, donde cada orden es de un cliente**
</small>

---
## Asociación belongs_to

* Es importante destacar que las asociaciones `belongs_to` deben usar términos
  en singular.
  * En el ejemplo anterior si se hubiese utilizado `cutomers` en la asociación,
    entonces surgiría un error indicando que `Order::Customers` es una constante
    no inicializada
  * Esto se debe a que rails infiere el nombre de la clase a partir del nombre
    de la asociación. 

---
## Migración correspondiente al belongs_to

```ruby
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :orders do |t|
      t.belongs_to :customer, index: true
      t.datetime :order_date
      t.timestamps null: false
    end
  end
end
```
---
## Asociación has_one

* Arma una relación **uno a uno** con otro modelo pero con una semántica diferente a la de `belongs_to`
* Esta asociación se utiliza para denotar relaciones uno a uno únicamente

![has_one](images/15/has_one.png)

<small>
**Ejemplo: Proveedores con una cuenta**
</small>

---
## Migración correspondiente al has_one

```ruby
class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :accounts do |t|
      t.belongs_to :supplier, index: true
      t.string :account_number
      t.timestamps null: false
    end
  end
end
```

<small>
<ul>
<li> Notar que `has_one` se coloca en la clase opuesta donde existe la clave foránea</li>
<li> Esto es porque su uso es similar a la asociación `has_many` pero se utilizará
  en casos de relaciones uno a uno en vez de uno a muchos</li>
</ul>
</small>

---
## Asociación has_many

* Arma una relación **uno a muchos** con otro modelo: este modelo puede tener 
	cero o más instancias del modelo mencionado
* Generalmente se encontrará en *el otro lado* de una asociación `belongs_to`

![has_many](images/15/has_many.png)


---
## Migración correspondiente al has_many

```ruby
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :orders do |t|
      t.belongs_to :customer, index: true
      t.datetime :order_date
      t.timestamps null: false
    end
  end
end
```

<small>
Es similar a la migración del ejemplo del `belongs_to`
</small>

---
## Asociación has_many :through
* Generalmente usada en relaciones **muchos a muchos** con otro modelo
* Esta asociación indica que el modelo que la declara puede disponer de cero o
  más instancias del otro modelo, a través de un tercer modelo

---
## Asociación has_many :through
Turnos médicos que son solicitados por pacientes para ser atendidos por médicos

![has_many_through](images/15/has_many_through.png)

---
## Asociación has_many :through

```ruby
class Physician < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
end

class Appointment < ActiveRecord::Base
  belongs_to :physician
  belongs_to :patient
end

class Patient < ActiveRecord::Base
  has_many :appointments
  has_many :physicians, through: :appointments
end
```

---
## Migración correspondiente al has_many :through

```ruby
class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :physicians do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :patients do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :appointments do |t|
      t.belongs_to :physician, index: true
      t.belongs_to :patient, index: true
      t.datetime :appointment_date
      t.timestamps null: false
    end
  end
end
```

---
## Asociación has_one :through
* Generalmente usada en relaciones **uno a uno** con otro modelo
* Esta asociación indica que el modelo que la declara puede disponer de una
  instancia de otro modelo accesible a través de un tercer modelo

---
## Asociación has_one :through

Un proveedor tiene una cuenta y cada cuenta tiene asociado un histórico de una la cuenta


![has_one_through](images/15/has_one_through.png)

---
## Ejemplo

```ruby
class Supplier < ActiveRecord::Base
  has_one :account
  has_one :account_history, through: :account
end

class Account < ActiveRecord::Base
  belongs_to :supplier
  has_one :account_history
end

class AccountHistory < ActiveRecord::Base
  belongs_to :account
end
```

---
## Migración correspondiente al has_one :through

```ruby
class CreateAccountHistories < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :accounts do |t|
      t.belongs_to :supplier, index: true
      t.string :account_number
      t.timestamps null: false
    end

    create_table :account_histories do |t|
      t.belongs_to :account, index: true
      t.integer :credit_rating
      t.timestamps null: false
    end
  end
end
```

---
## Asociación has\_and\_belongs\_to_many

Crea una relación directa **muchos a muchos** con otro modelo sin un modelo interviniente

---
## Asociación has\_and\_belongs\_to_many
<small>
Un montaje compuesto de muchas piezas, que puedan aparecer en muchos montajes
</small>

![habtm](images/15/habtm.png)

---
## Migración correspondiente a has\_and\_belongs\_to_many

```ruby
class CreateAssembliesAndParts < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :parts do |t|
      t.string :part_number
      t.timestamps null: false
    end

    create_table :assemblies_parts, id: false do |t|
      t.belongs_to :assembly, index: true
      t.belongs_to :part, index: true
    end
  end
end
```

---
## Asociaciones polimórficas

Un modelo puede pertenecer a uno o más modelos en una misma asociación


```ruby
class Picture < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
end

class Employee < ActiveRecord::Base
  has_many :pictures, as: :imageable
end

class Product < ActiveRecord::Base
  has_many :pictures, as: :imageable
end
```
<small>
**Una imagen puede pertenecer a un empleado o un producto**
</small>

---
## Asociaciones polimórficas

* Desde una instancia de empleado es posible obtener las imágenes usando
  `@employee.pictures`
* De igual forma es posible `@product.pictures`
* También es posible `@picture.imageable`

---
## Migración correspondiente a la asociación polimórfica

```ruby
class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string  :name
      t.integer :imageable_id
      t.string  :imageable_type
      t.timestamps null: false
    end

    add_index :pictures, :imageable_id
  end
end
```

---
## Migración correspondiente a la asociación polimórfica

```ruby
class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.references :imageable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
```

---
## Asociaciones conmigo mismo

```ruby
class Employee < ActiveRecord::Base
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee"
end
```
---
## Migración

```ruby
class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :manager, index: true
      t.timestamps null: false
    end
  end
end
```

---
## Referencias

* [API](http://api.rubyonrails.org/classes/ActiveRecord/Base.html)
* [Active Record base](http://edgeguides.rubyonrails.org/active_record_basics.html)
* [Active Record Associations](http://guides.rubyonrails.org/association_basics.html)
* [Active Record Querying](http://edgeguides.rubyonrails.org/active_record_querying.html)
* [Active Record Validations](http://edgeguides.rubyonrails.org/active_record_validations.html)
* [Active Record
  Callbacks](http://edgeguides.rubyonrails.org/active_record_callbacks.html)
* [Active Record Migrations](http://edgeguides.rubyonrails.org/migrations.html)

* Desde Sinatra
  * [Active Record y Sinatra](https://github.com/janko-m/sinatra-activerecord)
  * [Active Record micro_migrations](https://github.com/svenfuchs/micro_migrations)
***

# asociaciones

<div class="main-list">

* active record

</div>

----
<!-- .slide: data-auto-animate -->
## Introducción

Las asociaciones simplifican la interacción entre modelos relacionados

```ruby
class Customer < ActiveRecord::Base
end

class Order < ActiveRecord::Base
end
```

> ¿Cómo podemos representar la relación entre clientes que tienen varias ordenes?

----
<!-- .slide: data-auto-animate -->
## Introducción

<div class="asmall">

Si los clientes pueden tener varias órdenes la forma de relacionarlos sin
utilizar asociaciones sería:

```ruby
@order = Order.create order_date: Time.now,
  customer_id: @customer.id

# Para eliminar un cliente con sus ordenes:
@orders = Order.where customer_id: @customer.id

@orders.each do |order|
  order.destroy
end

@customer.destroy
```
</div>
----
## La solución

```ruby
class Customer < ActiveRecord::Base
  has_many :orders, dependent: :destroy
end

class Order < ActiveRecord::Base
  belongs_to :customer
end

# Crear una orden:
@order = @customer.orders.create order_date: Time.now

# Eliminar un cliente:
@customer.destroy
```
----
## Tipos de asociaciones

* Las asociaciones podrán ser alguna de:
	* **`belongs_to`**
	* **`has_one`**
	* **`has_many`**
	* **`has_many :through`**
	* **`has_one :through`**
	* **`has_and_belongs_to_many`**

----

<!-- .slide: data-auto-animate -->
## belongs_to

<div class="small">

* Arma una relación **uno a uno** con otro modelo.
* En general se usa combinado con una asociación **`has_many`** o **`has_one`** desde
  el otro modelo.

</div>


<img src="static/ar/belongs_to.png" class="border" height="300px" />

> Clientes con múltiples órdenes, donde cada orden es de un cliente.

----
<!-- .slide: data-auto-animate -->
## belongs_to

Es importante destacar que estas asociaciones deben usar términos
en singular.

En el ejemplo anterior si se hubiese utilizado **`cutomers`** en la asociación,
entonces surgiría un error indicando que `Order::Customers` es desconocido.

> Esto se debe a que rails infiere el nombre de la clase a partir del nombre
> de la asociación. 

----
<!-- .slide: data-auto-animate -->
## belongs_to

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
----
## has_one

<div class="small">

* Arma una relación **uno a uno** con otro modelo pero con una semántica
  diferente a la de `belongs_to`.
* Esta asociación se utiliza para denotar relaciones uno a uno únicamente.
</div>

<img src="static/ar/has_one.png" class="border" height="250px" />

> Proveedores con una cuenta.

----
## has_one

```ruby
class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :accounts do |t|
      t.belongs_to :supplier, index: :unique
      t.string :account_number
      t.timestamps null: false
    end
  end
end
```

> `has_one` se coloca en la clase opuesta donde existe la clave foránea. Es
> similar a la asociación `has_many` pero en relaciones uno a uno en vez de uno
> a muchos.

----
## has_many

<div class="small">

* Arma una relación **uno a muchos** con otro modelo: este modelo puede tener 
 cero o más instancias del modelo mencionado.
* Generalmente se encontrará en *el otro lado* de una asociación `belongs_to`.
</div>

<img src="static/ar/has_many.png" class="border" height="300px" />

----
## has_many

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

> Es similar a la migración del ejemplo del `belongs_to`

----
<!-- .slide: data-auto-animate -->
## has_many :through

* Generalmente usada en relaciones **muchos a muchos** con otro modelo.
* Esta asociación indica que el modelo que la declara puede disponer de cero o
  más instancias del otro modelo, a través de un tercer modelo.

----
<!-- .slide: data-auto-animate -->
## has_many :through


<img src="static/ar/has_many_through.png" class="border" height="350px" />

> Turnos solicitados por pacientes para ser atendidos por médicos

----
<!-- .slide: data-auto-animate -->
## has_many :through

<div class="container small">

<div class="col">

Clases del modelo

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

</div>
<div class="col">

Migraciones

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
</div>

----
## has_one :through
* Generalmente usada en relaciones **uno a uno** con otro modelo.
* Esta asociación indica que el modelo que la declara puede disponer de una
  instancia de otro modelo accesible a través de un tercer modelo.

----
<!-- .slide: data-auto-animate -->
## has_one :through

<img src="static/ar/has_one_through.png" class="border" height="300px" />

> Un proveedor tiene una cuenta y cada cuenta tiene asociado un histórico de
> cuenta

----
<!-- .slide: data-auto-animate -->
## has_one :through

<div class="container small">


<div class="col">

Clases del modelo

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

</div>
<div class="col">

Migraciones

```ruby
class CreateAccountHistories < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :accounts do |t:|
      t.belongs_to :supplier, index: :unique
      t.string :account_number
      t.timestamps null: false
    end

    create_table :account_histories do |t|
      t.belongs_to :account, index: :unique
      t.integer :credit_rating
      t.timestamps null: false
    end
  end
end
```

</div>
</div>


----
## has_and_belongs_to_many

Crea una relación directa **muchos a muchos** con otro modelo sin un modelo
interviniente.

----
<!-- .slide: data-auto-animate -->
## has_and_belongs_to_many

<img src="static/ar//habtm.png" class="border" height="400px" />

> Montaje de muchas piezas que puedan aparecer en muchos montajes

----
<!-- .slide: data-auto-animate -->
## has_and_belongs_to_many

<div class="small">

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
</div>

----
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
> Una imagen puede pertenecer a un empleado o un producto**

----
<!-- .slide: data-auto-animate -->
## Asociaciones polimórficas

* Desde una instancia de empleado es posible obtener las imágenes usando
  **`@employee.pictures`**.
* De igual forma es posible **`@product.pictures`**.
* También es posible **`@picture.imageable`**. En este caso retornará instancias
  de **`Product`** o **`Employee`**.

----
<!-- .slide: data-auto-animate -->
## Asociaciones polimórficas

<div class="small container">
<div class="col">

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
</div>
<div class="col fragment">

```ruby


class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.references :imageable, polymorphic: true,
        index: true
      t.timestamps null: false
    end
  end
end
```
> Migración conveniente
</div>
</div>

----

## Asociaciones conmigo mismo

```ruby
class Employee < ActiveRecord::Base
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee"
end
```
----
## Asociaciones conmigo mismo

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


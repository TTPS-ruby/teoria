***
# Objetos y atributos
---
## Objetos y atributos

* Luego de haber visto la *Introducción a Ruby*, ya conocemos un poco sobre la sintáxis de este lenguaje

* Para entender mejor los objetos, vamos a hacerlo mediante un ejemplo
  tomado del libro Programming Ruby (Pick Axe)

---
### El problema: Librería de reventa de libros

* Reventa de libros usuados que realiza control de stock semanalmente

* Mediante lectores de códigos de barra se registra cada libro en las 
bibliotecas. Cada lector, genera un archivo separado por comas (CSV) que contiene 
una fila para cada libro registrado.
* Cada fila contiene entre otros datos: ISBN del libro y precio. Un extracto del
archivo sería:

```csv
"Date","ISBN","Amount"
"2008-04-12","978-1-9343561-0-4",39.45
"2008-04-13","978-1-9343561-6-6",45.67
"2008-04-14","978-1-9343560-7-4",36.95
```

---
## ¿Qué tenemos que hacer?

* Tomar todos los CSV de cada lectora y determinar cuántos ejemplares de cada
  título disponemos
* Determinar además el monto total en libros que tenemos

---
## Creamos la clase Book In Stock

*Recordamos que los nombres de las clases deben comenzar con mayúsculas, los
métodos con minúscula*

```ruby

class BookInStock
end

```

### Lo probamos:

```ruby

a_book = BookInStock.new
another_book = BookInStock.new

```

---
## Pero en el ejemplo anterior:
* Se crean dos objetos diferentes de la clase `BookInStock`. 
* Podríamos decir en esta primer instancia que son el mismo libro, o iguales porque **nada los
distingue**

* Lo solucionamos obligando que la inicialización indique aquellos datos que distinga al
libro

---
## La nueva implementación

```ruby

class BookInStock
  def initialize(isbn, price)
    @isbn = isbn
    @price = Float(price)
  end
end

```

* El método `initialize` es especial en Ruby 
* Cuando se invoca el método `new`, Ruby aloca memoria para alojar un objeto no
  inicializado y luego invoca al método `initialize` **pasándole cada parámetro
  que fue enviado a `new`**
* Entonces `initialize` nos permite configurar el estado inicial de nuestros objetos

---
## Continuamos analizando

* El método `initialize`:
  * Vemos que se utilizan variables de instancia: 
      * Comienzan con **@**
      * Esto permite que los valores recibidos como parámetros no se pierdan luego
        de ejecutar `initialize`
      * Por ello almacenamos estos valores en variables de instancia
* Podríamos pensar que `@isbn` e `isbn` están relacionadas, pero:
  * No hay relación alguna más que coinciden en el nombre
  * Pero ambas son variables diferentes, una con un nombre que comienza con
    **@** y otra **no**
---
## Continuamos analizando

* Notamos además que se realiza una pequeña validación
  * El método
    [`Float`](http://www.ruby-doc.org/core-2.0.0/Kernel.html#method-i-Float)
    toma un argumento y lo convierte a `float`, terminando el programa si falla
    la conversión

*Analizar cómo es que `Float` es un método*

---
## Usamos los nuevos objetos

```ruby
b1 = BookInStock.new("isbn1", 3)
p b1
b2 = BookInStock.new("isbn2", 3.14)
p b2
b3 = BookInStock.new("isbn3", "5.67")
p b3
```

* Usamos el método `p` porque imprime el estado interno de los objetos.
* `to_s`, que es enviado a cualquier objeto que necesita convertirse a `string` 
* `puts` por defecto imprime: 

```ruby

  #<nombre_de_clase:id_objeto_en_hex>

```
---
## Modificamos la conversión a string

```ruby
class BookInStock
  def to_s
    "ISBN: #{@isbn}, price: #{@price}"
  end
end
```
---
## Objetos y sus atributos

* Un objeto como el mostrado anteriormente no permite que nadie acceda a sus
  variables
* Si bien es algo positivo encapsular, si no permitimos acceder a los datos que
  mantienen el estado del objeto, el mismo se vuelve inútil.
* A las *ventanas* de acceso a los objetos las denominaremos **atributos**
* Modificaremos nuestra clase de `BookInStock` con el fin de agregar atributos
  para `isbn` y `price` así podemos contabilizarlos

---
## Getters

```ruby
class BookInStock
  def isbn
    @isbn 
  end

  def price
    @price
  end
end
```

---
## Acceso a los atributos

* A los atributos anteriores se los denomina `accesor` porque mapean
  directamente con las variables de instancia
  * Ruby provee un shortcut: `attr_reader`

```ruby 
class BookInStock
  attr_reader :isbn, :price

  def initialize(isbn, price)
    @isbn = isbn
    @price = Float(price)
  end
  # ..
end
```

* Notar que se utilizan **símbolos**
* `attr_reader` **no define variables de instancia**
  * Sólo los métodos de acceso

---
## Atributos de escritura
* No sólo leemos atributos: a veces necesitamos modificar un valor
* Ruby permite modificar atributos definiendo un método terminado con **el signo
  igual**:

### Agregamos `price=`

```ruby
class BookInStock
  attr_reader :isbn, :price
  
  def initialize(isbn, price)
    @isbn = isbn
    @price = Float(price)
  end
  
  def price=(new_price)
    @price = new_price
  end
  # ...
end
```

---
## Atributos de escritura

```ruby
book = BookInStock.new("isbn1", 33.80)
puts "ISBN = #{book.isbn}"
puts "Price = #{book.price}"
book.price = book.price * 0.75 # discount price
puts "New price = #{book.price}"
```

* `attr_writer` provee acces de escritura únicamente
* `attr_accessor` provee acceso R/W

### La clase definitiva:


```ruby
class BookInStock

  attr_reader :isbn
  attr_accessor :price

  def initialize(isbn, price)
    @isbn = isbn
    @price = Float(price)
  end
end
```

---
## Atributos virtuales
*Agregamos el precio en centavos*

```ruby
class BookInStock
  attr_reader :isbn
  attr_accessor :price

  def initialize(isbn, price)
    @isbn = isbn
    @price = Float(price)
  end

  def price_in_cents
    Integer(price*100 + 0.5)
  end

  def price_in_cents=(cents)
    @price = cents / 100.0
  end
end
```

<small>
No hay correspondencia con variables de instancia como es el caso de `price` e `isbn`.
<br /> **El mapeo es con `price`**
</small>

---
## El lector de CSV
* Repasamos qué debemos implementar:
  * Leer varios archivos CSV
  * Totalizar ejemplares iguales
  * Totalizar el precio de los libros en stock

---
## El esqueleto de `CsvReader`

```ruby
class CsvReader
  def initialize
    # ...
  end

  def read_in_csv_data(csv_file_name)
  # ...
  end

  def total_value_in_stock
  # ...
  end

  def number_of_each_isbn
  # ...
  end
end
```
---
## ¿Cómo usríamos CsvReader?

```ruby
reader = CsvReader.new
reader.read_in_csv_data("file1.csv")
reader.read_in_csv_data("file2.csv")
# ......
# ......
puts "Total value in stock =  #{reader.total_value_in_stock}"
```

* Notamos que `CsvReader` debe ir acumulando lo que va leyendo de cada csv
* Para ello mantendremos un arreglo de valores como variable de instancia
* Para leer un CSV, Ruby provee de una librería que simplificará el trabajo

---
## Comportamiento de CsvReader

```ruby
require 'csv'

class CsvReader

  def initialize
    @books_in_stock = []
  end

  def read_in_csv_data(csv_file_name)
    CSV.foreach(csv_file_name, headers: true) do |row|
      @books_in_stock << 
        BookInStock.new(row["ISBN"], row["Amount"])
    end
  end
end
```
<small>
<ul>
  <li>La primer línea de `read_in_csv_data` indica la apertura del archivo
`csv_file_name` y el parámetro `headers: true` indica a la librería que la
primer línea del archivo son los encabezados de cada columna o campo</li>
  <li>La librería pasará entonces cada fila leída al bloque mostrado</li>
  <li>Notar que el acceso a cada campo se corresponde con los **nombres de las columnas**</li>
</ul>
</small>

---
## Calculando el precio total

```ruby
class CsvReader

  # Luego veremos como usar inject...
  def total_value_in_stock
    sum = 0.0
    @books_in_stock.each do |book| 
      sum += book.price
    end
    sum
  end

end
```

---
## Fragmentación de un programa
* Dividimos el código en tres archivos
  * `book_in_stock.rb`: la clase `BookInStock`
  * `csv_reader.rb`: el código de `CsvReader`
  * `stock_stats.rb`: el programa principal
* Aparecerán dependencias entre ellos
  * Para cargar dependencias externas se utiliza: `require` y `require_relative`

---
### `stock_stats.rb`

```ruby
require_relative 'csv_reader'

reader = CsvReader.new
ARGV.each do |csv_file_name|
  STDERR.puts "Processing #{csv_file_name}"
  reader.read_in_csv_data(csv_file_name)
end

puts "Total value = #{reader.total_value_in_stock}"
```

<small>
[Descargar ejemplo completo](images/samples/03/stock_stats.zip)
</small>

```bash
awk -F',' \
  'begin {total = 0} {total += $3} END {print "total: " total}' \
  csv_samples/*csv
```
<small>
Comprobación con AWK
</small>
***

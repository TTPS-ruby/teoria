***
# Bloques e iteradores
---

## Bloques
* Un bloque es código encerrado entre llaves o las palabras claves `do` y `end`
* Ambas formas son idénticas, salvo por la precedencia
  * Cuando el código del bloque entra en una línea usar {}
  * Cuando tiene más de una línea usar `do` / `end`
* Los bloques pueden verse como métodos anónimos
---
## Bloques
* Pueden recibir parámetros, que se explicitan entre barras verticales `|`
* El código de un bloque no se ejecuta cuando se define, sino que se almacenará
  para ser ejecutado más adelante
* En ruby, los bloques sólo podrán usarse después de la *invocación* de algún
  método
  * Si el método recibe parámetros, entonces aparecerá luego de ellos
  * Podría verse incluso como un parámetro extra que es pasado al método

---
## Ejemplo

Suma de los cuadrados de los números en un arreglo

```ruby
sum = 0
[1, 2, 3, 4].each do |value|
  square = value * value
  sum += square
end
puts sum
```

* El bloque se invoca para cada elemento en el arreglo
* El elemento del arreglo es pasado al bloque en la variable `value`
* La variable `sum` declarada fuera del bloque es actualizada dentro del bloque
---
## Bloques

* **Regla importante:** *si existe una variable en el bloque con el mismo
  nombre que una variable dentro del alcance pero creada fuera del bloque, ambas serán la
  misma variable. En el ejemplo hay sólo una variable `sum`*
* Veremos que el comportamiento mencionado podremos cambiarlo
* Si una variable aparece sólo en el bloque, entonces será local al mismo (como
`square`)

---
## Los casos no esperados

```ruby
# assume Shape defined elsewhere
square = Shape.new(sides: 4) 
#
# .. lots of code
#
sum = 0
[1, 2, 3, 4].each do |value|
  square = value * value
  sum += square
end

puts sum
square.draw # BOOM!
```

---
## Mas casos

No sucede lo mismo con los argumentos al bloque

```ruby
value = "some shape"
[ 1, 2 ].each {|value| puts value }
puts value
```

Podemos solucionar el problema de `square`

```ruby
square = "some shape"
sum = 0
[1, 2, 3, 4].each do |value; square|
  square = value * value # different variable
  sum += square
end
puts sum
puts square
```

---
## La magia de los bloques

* Mencionamos que los bloques se utilizan de forma adyacente a la llamada a un
  método y que no se ejecutan en el momento en que aparecen en el código
* Para lograr este comportamiento, dentro de un método cualquiera, podremos
  invocar un bloque
  * Los bloques se invocarán como si fueran métodos
  * Para invocar un bloque se utiliza la sentencia `yield`
  * Al invocar `yield` ruby invocará al código del bloque 
  * Cuando el bloque finaliza, ruby devuelve el código inmediatamente al
    finalizar el llamado a `yield`
---
## Ejemplo de un bloque

```ruby

def three_times
  yield
  yield
  yield
end

three_times { puts "Hola" }
```

---
## Parámetros a un bloque

* Cuando utilizamos `yield` podemos enviarle un parámetro
  * El parámetro enviado se mapea con el definido en el bloque entre las barras
    verticales
* Un bloque puede retornar un valor y ser usado en el método

---
## Ejemplo de envío de parámetros

```ruby

def fib_up_to(max)
  i1, i2 = 1, 1
  while i1 <= max
    yield i1
    i1, i2 = i2, i1+i2
  end
end

fib_up_to(1000) {|f| print f, " " }

```

---
## Ejemplo de uso del valor retornado

```ruby

class Array
  def my_find
    for i in 0...size
      value = self[i]
      return value if yield(value)
    end
    return nil
  end
end

(1..200).to_a.my_find {|x| x%5 == 0}

(1..200).to_a.my_find {|x| x == 0}

```

---
## Los iteradores
* Las clases que implementan colecciones, como `Array` *hacen lo que hacen
  mejor:*
  * Acceder a los elementos que contienen
* El comportamiento de qué hacer con cada elemento lo delegan a la aplicación
  * Permitiendo que nos concentremos sólo en un requerimiento particular
  * En los casos anteriores (`find`), sería encontrar un elemento para el cual
    el criterio sea verdadero

---
## Los iteradores each y collect

* El iterador `each` es el más simple 
  * Solo invoca `yield` para cada elemento
* El iterador `collect` también conocido como `map` 
  * Invoca `yield` para cada elemento. El resultado lo guarda en un nuevo 
  arreglo que es **retornado**

## Ejemplos

```ruby
[ 1, 3, 5, 7, 9 ].each {|i| puts i }

['k','h','m','t','w'].collect {|x| x.succ }
```

---
## Otros usos de iteradores 
* Los iteradores no solo se usan con array y hash
* Su lógica es muy utilizada en clases de entrada / salida para retornar
  líneas sucesivas o bytes

## Ejemplo
```ruby
f = File.open("testfile")
f.each { |line| puts "The line is: #{line}"}
f.close
```

Y si necesitamos el índice

```ruby
f = File.open("testfile")
f.each_with_index do |line, index| 
  puts "Line #{index} is: #{line}" 
end
f.close
```

---
## El caso de inject
* Este iterador tiene un nombre *raro*
* Permite acumular un valor a lo largo de los miembros de una colección
* Recibe un parámetro que es el valor inicial para comenzar a acumular
  * Si no se especifica **toma el primer elemento de la colección**

### Ejemplos
```ruby
[1,3,5,7].inject(0) {|sum, element| sum+element}

[1,3,5,7].inject {|sum, element| sum+element}

[1,3,5,7].inject(1) {|prod, element| prod*element}

[1,3,5,7].inject {|prod, element| prod*element}
```

---
## El caso de inject

Generando más mística para `inject`

```ruby
[1,3,5,7].inject(:+)


[1,3,5,7].inject 100, :+


[1,3,5,7].inject(:*)
```

---
## Enumerators
* Los iteradores son muy cómodos pero:
  * Son parte de la colección y no una clase a parte
  * En otros lenguajes (como Java), las colecciones no implementan sus
    iteradores, sino que son clases separadas (como por ejemplo la interfaz 
    Iterator de Java)
  * Es complicado iterar dos colecciones simultáneamente

---
## Enumerators

* La solución: clase `Enumerator`
  * Se obtiene de una colección con el método `to_enum` o `enum_for`

### Ejemplo

```ruby
a = [ 1, 3, "cat" ]
h = { dog: "canine", fox: "lupine" }
# Create Enumerators
enum_a = a.to_enum
enum_h = h.to_enum
enum_a.next   # => 1
enum_h.next   # => [ :dog, "canine" ]
enum_a.next   # => 3
enum_h.next   # => [ :fox, "lupine" ]
```
---
## Enumerators a partir de iteradores

Si un iterador se utiliza sin bloque, entonces retorna un Enumerator

```ruby

a = [1,2,3].each

a.next

```

---
## El método loop
* Ejecuta el código que se encuentra dentro del bloque
* Se puede salir con break cuando se cumple una condición
* Si hay iteradores, `loop` terminará cuando el Enumerator se quede sin valores

### Ejemplos

```ruby
loop { puts "Hola" }

i=0
loop do
  puts i += 1
  break if i >= 10
end

short_enum = [1, 2, 3].to_enum
long_enum = ('a'..'z').to_enum
loop { puts "#{short_enum.next} - #{long_enum.next}" }
```

---
## Usando Enumerator como objeto

Sabemos que es posible usar `each_with_index` en `Array`

```ruby
result = []
[ 'a', 'b', 'c' ].each_with_index do |item, index| 
  result << [item, index] 
end
```

¿Y si queremos hacer lo mismo con un `String`?

* No existe `each_with_index` en `String`
* Pero sí existe `each_char` que es como `each` de `Array` pero sobre cada
  caracter del string
  * Si no enviamos un bloque, retornará un `Enumerator`
* La interfaz `Enumerable` define el método `each_with_index`

---
## El código con String quedaría
```ruby
result = []
"cat".each_char.each_with_index do |item, index| 
    result << [item, index] 
end
# Aun más simple:
result = []
"cat".each_char.with_index do |item, index| 
    result << [item, index] 
end
```

---
## Enumerator como generadores
* Podemos crear objetos enumerator explícitamente en vez de hacerlo a partir de
  una colección
* Para ello es necesario utilizar un bloque en la creación
  * El código del bloque se usará por el objeto Enumerator cada vez que el
    programa principal le solicite un nuevo valor
  * Este bloque no se ejecutará como otros bloques dado que su ejecución
    se disparará cada vez que se solicita el siguiente valor
  * La ejecución del bloque se pausa y vuelve al programa principal cuando se
    encuentra `yield`
  * Cuando se solicita el siguiente valor, el código del bloque continúa a
    partir de la línea siguiente al `yield`

---
## Enumerator como generadores
Los enumerators creados de esta forma permiten generar **secuencias infinitas** 

```ruby
fibonacci = Enumerator.new do |caller|
  i1, i2 = 1, 1
  loop do
    caller.yield i1
    i1, i2 = i2, i1+i2
  end
end

6.times { puts fibonacci.next }
```

Como `Enumerator` es `Enumerable` sería posible:

```ruby

fibonacci.first(1000).last

```

---
## ¡Hay que tener cuidado!
* Cuidado con los enumerators que generan listas infinitas
* Los metodos comunes de los enumeradores como `count` y `select` tratarán de
  leer todos los elementos antes de retornar un valor
  * Podemos escribir la versión de `select` adecuada a nuestra lista
    infinita

```ruby
def infinite_select(enum, &block)
  Enumerator.new do |caller|
    enum.each do |value|
      caller.yield(value) if block.call(value)
    end
  end
end

p infinite_select(fibonacci) {|val| val % 2 == 0}.first(5)
```

---
## Haciendo algo más conveniente
* Podemos escribir filtros como `infinite_select` directamente en la clase
  `Enumerator`
* Esto nos permitirá encadenar filtros:

``` ruby
class Enumerator
  def infinite_select(&block)
    Enumerator.new do |caller|
      self.each do |value|
        caller.yield(value) if block.call(value)
      end
    end
  end
end

p fibonacci.
  infinite_select {|val| val % 2 == 0}.
  infinite_select {|val| val.to_s =~ /13\d$/ }.
  first(2)
```

---
## Bloques como transacciones
* Podemos usar bloques para definir código que debe ejecutarse bajo ciertas
  condiciones transaccionales.
* Por ejemplo:
  * Abrir un archivo
  * Procesarlo
  * Cerrarlo
* Si bien esto podemos hacerlo secuencialmente, utilizando bloques simplificamos
  mucho 

```ruby
class File
  def self.open_and_process(*args)
    f = File.open(*args)
    yield f
    f.close()
  end
end
```

---
## Analizamos un poco...
* El método de clase implementado fue desarrollado para que entienda los mismos
  parámetros que `File.open` 
* Para ello, lo que hicimos es pasar los parámetros tal cual se enviaron a
  `File.open`
  * Esto se logra definiendo como argumento al método `*args` que significa:
    *tomar todos los argumentos enviados al método actual y colocarlos en un
    arreglo llamado args*
  * Luego llamamos a `File.open(*args)`. Utilizar *args vuelve a expandir los
    elementos del arreglo a parámetros individuales


---
## Una versión más completa de my_open
```ruby
class File
  def self.my_open(*args)
    result = file = File.new(*args)
    if block_given?
      result = yield file
      file.close
    end
    return result
  end
end
```

* Podría suceder un error en el procesamiento
* Para asegurar el cierre del archivo, se deben usar excepciones, que veremos 
más adelante

<small class="fragment">
*Esta técnica es tan útil, que `File.open` ya lo implementa.  Además de usar `File.open`
para abrir un archivo, podemos usarlo para directamente procesarlo como lo hacíamos
con `open_and_process`*
</small>

---
# Los bloques pueden ser objetos
* Recordamos que anteriormente mencionamos que los bloques son como un parámetro
	adicional pasado a un método
* Además podremos hacer que los bloques sean parámetros explícitos
	* Si el último parámetro en un método se prefija con ampersand (como 
	&action), Ruby buscará el codigo de un bloque cuando el método es invocado
	* Este parámetro podrá utilizarse como cualquier otro

## Ejemplo
	@@@ ruby
	class ProcExample
		def pass_in_block(&action)
			@stored_proc = action
		end
		def use_proc(parameter)
			@stored_proc.call(parameter)
		end
	end

	eg = ProcExample.new
	eg.pass_in_block { |param| puts "The parameter is #{param}" }
	eg.use_proc(99)

!SLIDE smbullets small transition=uncover
# Avanzando un poco más...
* Vemos que `call` invoca la ejecución del bloque 
* Muchos programas utilizan esta idea para implementar **callbacks**
* ¿Qué pasaría si retornamos el bloque?

## Lo analizamos
	@@@ ruby
	def create_block_object(&block)
		block
	end

	bo = create_block_object do |param| 
		puts "You called me with #{param}"
	end
	bo.call 99
	bo.call "cat"

!SLIDE smbullets transition=uncover
# `Proc` y `lambda`
* Devolver un bloque es tan útil que en Ruby hay dos formas de hacerlo:
	* `lamda` y `Proc.new` toman un bloque y retornan un objeto
	* El objeto retornado es de la clase `Proc`
	* La diferencia entre `lambda` y `Proc.new` la veremos más adelante, pero ya
	  hemos mencionado que `lambda` controla los parámetros que requiere el
		bloque, mientras que `Proc` no lo hace

!SLIDE bullets small transition=uncover
# Los bloques pueden ser Closures
* Recordamos haber mencionamos que los bloques pueden utilizar variables que
	están dentro del alcance del bloque
* Veremos ahora un uso diferente de un bloque haciendo esto

## Ejemplo
	@@@ ruby
	def n_times(thing)
		lambda {|n| thing * n }
	end
	p1 = n_times(10)
	p1.call(3)
	p1.call(4)
	p2 = n_times("Hola ")
	p2.call(3)

!SLIDE smbullets smaller transition=uncover
# ¿Qué es un Closure?
* El método `n_times` referencia el parámetro `thing` que es usado por el bloque
* Aunque en las llamadas a `call` (y por ende en la ejecución del bloque) el 
	parámetro `thing` está fuera del alcance, el parámetro se mantiene accesible
	dentro del bloque
* Esto es un closure:
	* Variables en el alcance cercano que son referenciadas por el bloque se
	  mantienen accesibles por la vida del bloque y la vida del objeto Proc creado
		para este bloque

## Otro ejemplo
	@@@ ruby
	def what_do_i_do?
		value = 1
		lambda { value += value }
	end

	let_me_see = what_do_i_do?
	let_me_see.call
	let_me_see.call

!SLIDE smbullets small transition=uncover
# Notación alternativa
## A partir de ruby 1.9 
	@@@ ruby
	lambda { |params| ... }

	# es equivalente a

	->params { ... }

	# Y con parámetros

	proc1 = -> arg {puts "proc1:#{arg}" }
	proc2 = -> arg1, arg2 {puts "proc2:#{arg1} y #{arg2}" }
	proc3 = ->(arg1, arg2) {puts "proc3:#{arg1} y #{arg2}" }

	proc1.call "ant"
	proc2.call "bee", "cat"
	proc3.call "dog", "elk"

!SLIDE transition=uncover
# Locas ideas
## Reimplementamos un while usando bloques

	@@@ ruby
	def my_while(cond, &body)
		while cond.call
			body.call
		end
	end

	a = 0
	my_while -> { a < 3 } do
		puts a
		a += 1
	end

!SLIDE bullets smaller transition=uncover
# Lista de parámetros a un bloque
* Los argumentos a un bloque, al igual que los argumentos a un método podrán ser:
	* Argumentos splat, que se reemplazan por un arreglo como vimos en un ejemplo
	  previo (usando *)
	* Inicializados con un valor por defecto
	* Bloques como parámetro (usando & en el último parámetro)

## Ejemplo
	@@@ ruby
	proc1 = lambda do |a, *b, &block|
		puts "a = #{a.inspect}"
		puts "b = #{b.inspect}"
		block.call
	end
	proc1.call(1, 2, 3, 4) { puts "in block1" }

	proc2 = -> a, *b, &block do
		puts "a = #{a.inspect}"
		puts "b = #{b.inspect}"
		block.call
	end
	proc2.call(1, 2, 3, 4) { puts "in block2" }

---
# El simbolo usado como bloque

Symbol#to_proc para map o inject


!SLIDE center transition=uncover
# Herencia, módulos y mixins

!SLIDE bullets transition=uncover
# Introducción
* Uno de los principios aceptados sobre buen diseño es la eliminación de
  duplicados innecesarios
* Trataremos de lograr que cada concepto en nuestra aplicación sea expresado sólo
  una vez en el código

!SLIDE smbullets transition=uncover
# Herencia
* Permite crear clases que son un refinamiento o especialización de otra clase
* A esta clase se la llama *subclase* de la original
* A la clase original se la llama *superclase* de la subclase
* También se utilizan los términos: clase padre y clase hija
* El mecanismo de herencia es simple:
  * Los hijos heredan todas las capacidades de la clase padre
  * Todos los métodos de instancia y clase de la clase padre estarán disponibles en los
    hijos

!SLIDE transition=uncover
# Ejemplo de herencia
	@@@ ruby
	class Parent
		def say_hello
			puts "Hello from #{self}"
		end
	end

	p = Parent.new
	p.say_hello

	# Subclass the parent...
	class Child < Parent
	end

	c = Child.new
	c.say_hello


!SLIDE smbullets small transition=uncover
# Conociendo la herencia
## El método `superclass` devuelve la clase padre

	@@@ ruby
	puts "The superclass of Child is #{Child.superclass}"
	puts "The superclass of Parent is #{Parent.superclass}"
	puts "The superclass of Object is #{Object.superclass}"

* Si no se define superclase, Ruby asume `Object`
	* `to_s` está definido aquí
* `BasicObject` es utilizado en metaprogramación. 
	* Su padre es `nil`
	* Es la raíz: todas las clases lo tendran como ancestro 

!SLIDE smbullets transition=uncover
# Veamos un ejemplo completo 
* `GServer` es un servidor TCP/IP genérico
* Agregaremos funcionalidad básica a nuestro servicio subclaseando GServer
	* El servicio mostrará las últimas lineas del archivo de logs del sistema:
	  `/var/log/syslog`
* GServer manipula todo lo relacionado a sockets TCP. 
	* Nosotros sólo indicaremos el puerto en la inicialización
	* Cuando un cliente se conecte, el objeto GServer invocará al método `serve`
	* GServer no hace nada en el método que implementa `serve`

!SLIDE small transition=uncover
# LogServer
	@@@ ruby
	require 'gserver'
	class LogServer < GServer
		def initialize
			super(12345)
		end
		def serve(client)
			client.puts get_end_of_log_file
		end
		private
			def get_end_of_log_file
				File.open("/var/log/syslog") do |log|
					# back up 1000 characters from end
					log.seek(-1000, IO::SEEK_END)
					# ignore partial line
					log.gets
					# and return rest
					log.read
				end
			end
	end

	server = LogServer.new
	server.start.join


!SLIDE smbullets smaller transition=uncover
# ¿Cómo hemos usado la herencia?
* `LogServer` hereda de `GServer`
* Esto indica que: 
	* LogServer es un GServer, compartiendo toda su funcionalidad
	* LogServer es una especialización
* La primer especialización es con `initialize`
	* Se fuerza el puerto a 12345
	* El puerto es un parámetro del constructor de GServer
	* Para invocar el método constructor del padre, utilizamos `super`
	* Cando se invoca `super`, Ruby envía el método a la clase padre del objeto
	  actual, indicando que invoque el mismo método que se está ejecutando en el
		hijo. Se enviarán los parámetros que fueron pasados a `super`
* La implementación de `serve` es algo común en OO
	* El padre asume que será subclaseado invocando un método que asume será
	  implementado por sus hijos
	* Esto permite a la clase padre implementar lo más pesado del procesamiento y
	  delegar a los hijos mediante callbacks funcionalidad extra

!SLIDE bullets incremental transition=uncover
# ¿Cómo hemos usado la herencia?

* Veremos más adelante que esta práctica ***muy común en OO*** no la convierte en ***un buen diseño***

* En su lugar veremos ***mixins***

* Pero para explicar mixins, antes tenemos que explicar ***módulos***

!SLIDE center transition=uncover
# Modulos

!SLIDE bullets transition=uncover
# Modulos
* Los módulos son una forma de agrupar métodos, clases y constantes. 
* Proveen dos beneficios:
	* Proveen **namespaces** y previenen el solapamiento de nombres
	* Son la clave de los **mixins**

!SLIDE smbullets transition=uncover
# Namespaces
* A medida que los programas crecen, surge código reusables
* Es así como aparecen las librerías
* Deseamos agrupar en archivos diferentes estas rutinas de forma tal
	de poder reusarlas en programas distintos
* Generalmente estas rutinas pertenecerán a una clase, o grupos de clases
	interrelacionadas, que podríamos disponer en un único archivo
	* Sin embargo, a veces queremos agrupar cosas que no necesariamente forman una
	  clase

!SLIDE smbullets smaller transition=uncover
# Namespaces
* Como una primer idea, podríamos pensar en disponer todos los archivos que
	componen nuestra librería y luego cargar el archivo en nuestro programa cuando
	lo necesite
* Esta idea tiene un problema si definimos funciones con nombres que son iguales 
	a los de otra librería

## La solución

	@@@ ruby 
	module Trig
		PI = 3.141592654
		def Trig.sin(x)
		# ..
		end
		def Trig.cos(x)
		# ..
		end
	end
	module Moral
		VERY_BAD = 0
		BAD = 1
		def Moral.sin(badness)
		# ...
		end
	end

!SLIDE smbullets transition=uncover
# ¿Como se usa?

	@@@ ruby
	y = Trig.sin(Trig::PI/4)
	wrongdoing = Moral.sin(Moral::VERY_BAD)

* Así como en los métodos de clase, se invocan los métodos de un módulo
	precediéndolos con el nombre del módulo y un punto
* Las constantes se referencian con el nombre del módulo y doble dos puntos (::)

!SLIDE smbullets small transition=uncover
# Mixins
* En el ejemplo reciente, definimos métodos del módulo que prefijábamos con el
	nombre del módulo: `Trig.cos`
* La primer asociación es que los métodos de un módulo son como métodos de clase
* La siguiente pregunta sería: *Si los métodos del módulo son como métodos de
	clase, qué serían los métodos de instancia de un módulo?*
	* Un módulo **no puede tener instancias** porque no es una clase
	* Podremos **incluir** un módulo a una definición de clase
	* Cuando esto sucede, los métodos de instancia definidos en el módulo son
	  incluidos como métodos de instancia de la clase. Se **mezclan** (mixed in)
	* En efecto, los módulos mixed in se comportan como superclases

!SLIDE smbullets smaller transition=uncover
# Ejemplo
	@@@ ruby
	module Debug
		def who_am_i?
			"#{self.class.name}(\##{self.object_id}):#{self.to_s}"
		end
	end

	class Phonograph
		include Debug
		def initialize(n); @n=n; end
		def to_s; @n; end
	end

	class EightTrack
		include Debug
		def initialize(n); @n=n; end
		def to_s; @n; end
	end

	ph = Phonograph.new("West End Blues")
	et = EightTrack.new("Surrealistic Pillow")
	ph.who_am_i?
	et.who_am_i?

!SLIDE bullets transition=uncover
# El uso de `include`
* El `include` en Ruby agrega una referencia al módulo que agregará nuevos
	métodos a nuestra clase
* Si varias clases incluyen el mismo módulo, todas tendran referencias al mismo
* Si modificamos el módulo durante la ejecución del programa, todas las clases
	que incluían el módulo tomarán los cambios automáticamente

!SLIDE bullets transition=uncover
# El potencial
* El potencial real de los mixins se obtiene cuando el código de un mixin
	interactúa con código de una clase que lo utiliza
* Analizamos el caso de un mixin que es parte de la librería estándar de Ruby,
	`Comparable` 
	* Agrega los operadores de comparación: `<`, `<=`, `==`, `>=`, `>`
	* Agrega el método `between?`
	* Asume que la clase que utilice este mixin, implementará el método `<=>`

!SLIDE bullets transition=uncover
# Lo probamos con la clase `Person`
	@@@ ruby 
	class Person
		include Comparable
		attr_reader :name
		def initialize(name)
			@name = name
		end
		def to_s
			"#{@name}"
		end
		def <=>(other)
			self.name <=> other.name
		end
	end
	p1 = Person.new("Matz")
	p2 = Person.new("Guido")
	p3 = Person.new("Larry")
	[p1, p2, p3].sort

!SLIDE bullets transition=uncover
# Iteradores y el módulo `Enumerable`
* Si queremos que nuestra clase entienda los iteradores `each`, `include?`,
	`find_all?`
	* Incluimos el módulo `Enumerable`
	* Implementamos el iterador `each`
* Si además los elementos de nuestra colección implementan `<=>` entonces
	  dispondremos de: 
	* `min`
	* `max` 
	* `sort` 
!SLIDE bullets small transition=uncover
# Composición de módulos
## Creamos nuestra clase Enumerable
	@@@ ruby
	class VowelFinder
		include Enumerable
		def initialize(string)
			@string = string
		end
		def each
			@string.scan(/[aeiou]/i) do |vowel|
				yield vowel
			end
		end
	end
	vf = VowelFinder.new "El murcielago tiene todas"
	vf.inject(:+)

## Lo mismo hacemos con otras colecciones
	@@@ ruby
	[ 1, 2, 3, 4, 5 ].inject(:+)
	( 'a'..'m').inject(:+)

!SLIDE bullets small transition=uncover
# Creamos el módulo `Summable`
	@@@ ruby
	module Summable
		def sum
			inject(:+)
		end
	end

## Lo aplicamos a las clases del ejemplo

	@@@ ruby
	class Array; include Summable; end
	class Range; include Summable; end
	class VowelFinder; include Summable; end

	[ 1, 2, 3, 4, 5 ].sum
	('a'..'m').sum
	vf.sum


!SLIDE smbullets small transition=uncover
# Variables de instancia en mixins
* En ruby las variables de instancia se crean cuando se nombran por
	primera vez 
* Esto significa que un Mixin podrá crear variables de instancia si las nombra
	por primera vez en la clase

## Ejemplo
	@@@ ruby 
	module Observable
		def observers
			@observer_list ||= []
		end
		def add_observer(obj)
			observers << obj
		end
		def notify_observers
			observers.each {|o| o.update }
		end
	end

!SLIDE bullets small transition=uncover
# Variables de instancia en mixins
* Sin embargo, este uso es **riesgoso**
* Los nombres de las variables pueden colisionar con otro nombre de la clase u
	otros módulos.
* Un programa que caiga en este escenario dará resultados erróneos y
	difíciles de rasterar

## Solución
* La mayoría de las veces, los modulos Mixins no usan variables de instancia,
	sino accessors
* En caso de necesitarlo, utilizar nombres que se prefijen con el nombre del
	módulo por ejemplo

!SLIDE bullets small transition=uncover
# Resolución de nombres ambiguos de métodos
* *¿Cómo se resuelve el nombre de un método que es el mismo en la clase, que 
	es implementado en la superclase y además definido en uno o varios módulos 
	incluidos?*
	* Primero se busca si la clase del objeto lo implementa
	* Luego en los mixins incluidos por la clase. *Si tiene varios módulos, el
	  último será el considerado*
	* Luego en la superclase

!SLIDE small transition=uncover
# Caso 1
	@@@ ruby
	module MyModule
		def test
			"Module"
		end
	end

	class Parent
		def test
			"Parent"
		end
	end

	class Child < Parent
		include MyModule
		def test
			"Child"
		end
	end

	t = Child.new
	p t.test

!SLIDE small transition=uncover
# Caso 2
	@@@ ruby
	module MyModule
		def test
			"Module"
		end
	end

	class Parent
		def test
			"Parent"
		end
	end

	class Child < Parent
		include MyModule
	end

	t = Child.new
	p t.test

!SLIDE small transition=uncover
# Caso 3
	@@@ ruby
	module MyModule
		def test1
			"Module"
		end
	end

	class Parent
		def test
			"Parent"
		end
	end

	class Child < Parent
		include MyModule
	end

	t = Child.new
	p t.test

!SLIDE smbullets transition=uncover
# Herencia, Mixins y Diseño
* Herencia y Mixins ambos permiten escribir código en un único lugar
* *¿Cuándo usar cada uno?*
	* El uso de herencia debe aplicarse cuando se cumple la propiedade **es un**
	* La herencia puede asociarse con la creación de clases, que sería como 
	agregar nuevos tipos al lenguaje
	* Al usar herencia **deberíamos en todo momento poder reemplazar por un objeto
	  de la subclase** donde se usaba un objeto de la superclase. *Los hijos deben
		hacer honor a los contratos asumidos por el padre*

!SLIDE smbullets smaller transition=uncover
# Herencia, Mixins y Diseño
* La realidad dice que el uso de herencia no siempre se usa para representar la
	relación *es un*
	* En realidad muchas veces se utiliza **mal** en situaciones que representan 
		una relación de *posee un* o *utiliza un*
	* El mundo se crea a partir de **composiciones** más que de restricciones de
	  herencia estrictas
* Dado que la herencia era el único mecanismo disponible para compartir código,
	nos volvimos **vagos** y empezamos a afirmar cosas como: *Que una Persona* ***es un*** *DatabaseWrapper*
	* Pero una persona no es un DatabaseWrapper
	* Una Persona **usa** un DatabaseWrapper para proveer persistencia
* La herencia además representa un gran acomplamiento entre dos componentes.
	Cambiar la herencia sería algo complejo en cualquier programa mediano
* **Debemos utilizar composición cada vez que encontramos una relación:** A
	*usa* B o A *tiene un* B
	* Nuestra persona no sería un DatabseWrapper, incluiría la funcionalidad para
	  persistir y recuperar una persona



***

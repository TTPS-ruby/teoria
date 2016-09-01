***
# Colecciones, bloques e iteradores
---
## Introducción
* Las colecciones representan elementos fundamentales de cualquier programa
* Ruby provee dos clases que representan colecciones: 
  * `array`
  * `hash` o  arreglo asociativo
* El correcto uso de estas colecciones es fundamental en la programación Ruby
* Los bloques, combinados con colecciones se convierten en construcciones muy
  poderosas para la iteración

---
## Array
* La clase `Array` mantiene una colección de referencias a objetos. 
* Cada referencia a objeto ocupa una posición en el arreglo, identificada por un
  índice entero no negativo

### Ejemplos
```ruby
a = [ 3.14159, "pie", 99 ]
a.class
a.length
a[0]
a[1]
a[2]
a[3]

b = Array.new
b.class
b.length
b[0] = "second"
b[1] = "array"
b
```

---
# Arrays y `[]`
* Los elementos de un arreglo se acceden con el operador `[]`
* Pero `[]` es un método (de instancia en la clase `Array`) y por tanto puede
  implementarse por cualquier subclase
* El primer índice de un arreglo es el cero
* Un arreglo accedido en un índice positivo retorna el objeto referenciado en
  esa posición.
  * Si no hay objeto, retorna `nil`
* Un arreglo accedido en un índice negativo, retorna el objeto contando desde el
  final

---
## Indices negativos

```ruby
a = [ 1, 7, 9]
a[-1]
a[-2]
a[-99]
```

## Indexando con un par de valores
```ruby
a = [ 1, 3, 5, 7, 9 ]
a[1, 3]
a[3, 1]
a[-3, 2]
```

<small>
*Acceder arrays con dos valores indica `[start,count]` y retorna siempre un
nuevo `array`*
</small>

---
## Pueden usarse rangos

```ruby
a = [ 1, 3, 5, 7, 9]
a[1..3]
a[1...3]
a[3..3]
a[-3..-1]
```

* El rango indica los índices **desde** y **hasta**
* Usando `..` se incluye el fin de rango
* Usando `...` se **excluye** el extremo final

---
## Arrays y `[]=`
* El método `[]=` permite setear elementos de un array
* Si se utiliza con un único índice, entonces reemplaza su valor por lo que esté
  a la derecha de la asignación
  * Cualquier gap que haya quedado luego de `[]=` se completa con nil

### Ejemplo

```ruby
a = [ 1, 3, 5, 7, 9 ]
a[1] = 'bat'
a[-3] = 'cat'
a[3] = [ 9, 8 ]
a[6] = 99
```

---
## Arrays y `[]=`
* Si se utiliza con dos valores (inicio, cantidad) o un rango, luego estos
  elementos son reemplazados por lo que esté a la derecha de la asignación
  * Si la cantidad de elementos a reemplazar es cero, entonces el valor 
    es insertado en el array antes de la posición inicial: **no se eliminan 
    elementos**
  * Si el valor a la **derecha es un arreglo**, sus elementos se utilizan en el 
    reemplazo: el tamaño del arreglo destino es actualizado si la cantidad de
    elementos a la derecha difiere de los elementos a reemplazar

---
## Ejemplo doble indexación

Despejando las dudas con un ejemplo

```ruby
a = [ 1, 3, 5, 7, 9 ]
a[2, 2] = 'cat'
a[2, 0] = 'dog'
a[1, 1] = [ 9, 8, 7 ]
a[0..3] = []
a[5..6] = 99, 98
```

---
## Arrays usados como pilas
* Podemos invocar los siguientes métodos de `Array`
  * `push`
  * `pop`

### Ejemplo

```ruby
stack = []
stack.push "red"
stack.push "green"
stack.push "blue"
p stack
puts stack.pop
puts stack.pop
puts stack.pop
p stack
```

---
## Arrays usados como colas
* Podemos invocar los siguientes métodos de `Array`
  * `unshift`
  * `shift`

### Ejemplo

```ruby
queue = []
queue.push "red"
queue.push "green"
puts queue.shift
puts queue.shift
```

---
## El principio y el final

```ruby
array = [ 1, 2, 3, 4, 5, 6, 7 ]
p array.first(4)
p array.last(4)
```

---
## Hashes 
* Los arreglos se indexan con enteros, los hashes con objetos
  * Símbolos, strings, expresiones regulares, etc
* Cuando se almacena un valor en un hash, utilizamos:
  * El índice, generalmente llamado *key*
  * El dato a almacenar en dicho índice, generalmente llamado *valor*
* El acceso a los valores referenciados por un hash se realiza por medio de los
  *keys*

### Ejemplo

```ruby
h = { 'dog' => 'canine', 'cat' => 'feline' }
h.length # => 2
h['dog'] # => "canine"
h['cow'] = 'bovine'
h[12] = 'dodecine'
h['cat'] = 99
```

---
## Acceso a los hashes 
En el ejemplo anterior se utilizan strings como claves

### Ejemplo con símbolos

```ruby
# En ruby >= 1.9
h = { dog: 'canine', cat: 'feline' }

# En ruby < 1.9
h = { :dog => 'canine', :cat => 'feline' }
```

* Comparado a los arreglos, los hashes tienen una ventaja: se indexan con
  objetos
* A partir de la versión 1.9 además se recuerda el órden en que fueron
  insertados los elementos
  * Cuando se itera sobre las entradas de un hash se respeta el orden de
    inserción

---
## Un ejemplo usando Array y Hash

### Frecuencia de palabras

*Calcular el número de veces que aparece una palabra en un texto*

* El problema se divide en dos partes:
  * Separar el texto en palabras: *suena como un array*
  * Luego contar cada palabra diferente: *suena como hash*

---
## La solución
### El método que obtiene las palabras

```ruby
def words_from_string(string)
  string.downcase.scan(/[\w']+/)
end
```
### El método que cuenta las palabras

* Usaremos un hash, indexado por las palabras a contar
* El valor será la cantidad de ocurrencias 
  * Tendremos que incializar la primer ocurrencia en el valor 1 para luego sumar

---
## Una primer idea...

*Asumimos que counts es un `Hash`*

```ruby
if counts.has_key?(next_word)
  counts[next_word] += 1
else
  counts[next_word] = 1
end
```

---
## Refactorizamos

* Podemos ordenar un poco la idea anterior
  * `Hash.new` puede recibir como parámetro el valor usado para incializar cada
    valor del Hash. *(por ejemplo cuando se accede a un valor que no existe aún en
    el Hash)*

### Implementación

```ruby
def count_frequency(word_list)
  counts = Hash.new(0)
  for word in word_list
    counts[word] += 1
  end
  counts
end
```
<small>
[Descargar ejemplo](images/samples/06/words_frequency.zip)
</small>

---
## Testeando nuestra solución
* Aplicar un test rápido es una buena práctica.
* Si bien lo veremos más adelante, vamos introduciendo el concepto
* Utilizaremos un framework de test llamado `Minitest`
* Sólo explicaremos el método `assert_equal` que chequea si los dos parámetros 
  que se le envían son iguales, indicando **fuertemente** si así no
  sucede
* Utilizaremos **afirmaciones** *(en inglés assertions)* para testear los dos
  métodos implementados, uno por vez
  * He aquí la razón por la que se escribieron como métodos separados
  * Tener métodos diferentes permite testearlos en forma aislada

---
##  Testing

Testeamos `words_from_string`

```ruby
require_relative 'words_from_string.rb'
require 'minitest/autorun'

class TestWordsFromString < Minitest::Test
  def test_empty_string
    assert_equal([], words_from_string(""))
    assert_equal([], words_from_string(" "))
  end
  def test_single_word
    assert_equal(["cat"], words_from_string("cat"))
    assert_equal(["cat"], words_from_string(" cat "))
  end
  def test_many_words
    assert_equal(["the", "cat", "sat", "on","the","mat"],
        words_from_string("the cat sat on the mat"))
  end
  def test_ignores_punctuation
    assert_equal(["the", "cat's", "mat"],
        words_from_string("<the!> cat's, -mat...-"))
  end
end
```
<small>
En esta clase, los métodos que comienzan con **test** serán corridos
por el framework de testing
</small>

---
##  Testing
Testeamos `count_frequency`

```ruby
require_relative 'count_frequency.rb'
require 'minitest/autorun'

class TestCountFrequency < Minitest::Test
  def test_empty_list
    assert_equal({}, count_frequency([]))
  end
  def test_single_word
    assert_equal({"cat" => 1}, count_frequency(["cat"]))
  end
  def test_two_different_words
    assert_equal({"cat" => 1, "sat" => 1},
          count_frequency(["cat", "sat"]))
  end
  def test_two_words_with_adjacent_repeat
    assert_equal({"cat" => 2, "sat" => 1},
          count_frequency(["cat", "cat", "sat"]))
  end
  def test_two_words_with_non_adjacent_repeat
    assert_equal({"cat" => 2, "sat" => 1},
          count_frequency(["cat", "sat", "cat"]))
  end
end
```
***

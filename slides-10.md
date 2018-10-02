***
# Excepciones

---
## Introducción

* Las excepciones permiten empaquetar en un objeto información sobre un error 
* El objeto `Exception` se propagará hacia arriba en la pila de ejecución hasta
  que el sistema detecte código que sepa manejar dicha excepción

---
## La clase Exception

* Ruby define una jerarquía de excepciones que son subclase de `Exception` 
* Esta jerarquía simplifica el manejo de excepciones
  * Al lanzar una excepción, es posible hacerlo con cualquiera de las subclases de
  `Exception` o con una clase propia que sea subclase de `StandardError` o alguna
  de sus hijas. 
* Toda excepción tiene asociado un mensaje y una traza de ejecución
  * Si definimos excepciones propias, podemos agregar información específica

---
## Manejo de excepciones

Analizamos el siguiente código

```ruby
require 'open-uri'

web_page = open("http://pragprog.com/podcasts")
output = File.open("podcasts.html", "w")
while line = web_page.gets
  output.puts line
end
output.close
```

* ¿Qué sucede si ocurre un error en la mitad de la transferencia?
  * No queremos guardar una página por la mitad en el archivo de salida

---
## Manejo de excepciones

Agregamos el manejador de excepción

```ruby
require 'open-uri'

page = "podcasts"
file_name = "#{page}.html"
web_page = open("http://pragprog.com/#{page}")
output = File.open(file_name, "w")
begin
  while line = web_page.gets
    output.puts line
  end
  output.close
rescue Exception
  STDERR.puts "Failed to download #{page}: #{$!}"
  output.close
  File.delete(file_name)
  raise
end
```

---
## Manejo de excepciones

* Cuando sucede una excepción se ubica una referencia al objeto con la excepción
  asociada en la variable global `$!`
* Luego de cerrar y eliminar el archivo, se invoca a `raise` sin parámetros, que
  relanza la excepción en `$!`

---

## Jerarquía de Exception

```
  Exception
    StandardError
      ArgumentError
      FiberError (1.9)
      IndexError
        KeyError (1.9)
        StopIteration (1.9)
      IOError
        EOFError
      LocalJumpError
      NameError
        NoMethodError
      RangeError
        FloatDomainError
      RegexpError
      RuntimeError
      SystemCallError
        system-dependent exceptions (Errno::xxx)
      ThreadError
      TypeError
      ZeroDivisionError
    fatal
    NoMemoryError
    ScriptError
      LoadError
      NotImplementedError
      SyntaxError
    SecurityError 
    SignalException
      Interrupt
    SystemExit
    SystemStackError
```

---
## Múltiples rescue

* Es posible utilizar varios `rescue` para un bloque `begin`
* Cada `rescue` puede incluso indicar varias excepciones a catchear
* Al final de cada `rescue`, podemos indicar el nombre de la variable que
  usaremos para mapear la exepción (en vez de usar `$!`)

```ruby
def my_eval(string)
  begin
    eval string
  rescue SyntaxError, NameError => boom
    print "String doesn't compile: " + boom.message
  rescue StandardError => bang
    print "Error running script: " + bang.message
  end
end

my_eval 'Float 2,2'
my_eval 'undefined_method'
```
---
## Cómo funciona rescue
* La decisión de qué `rescue` utilizar, es similar al caso de un `case`
* Para cada `rescue` compara la excepción lanzada con cada uno de los parámetros
  nombrados
  * La comparación es: `parámetro == $!`
  * Esto significaría que si el tipo de la excepción lanzada coincide con el del
    parámetro
---
## Cómo funciona rescue
* Si se omiten parámetros, se compara con `StandardError`
* Si no machea con ningún parámetro, sale del bloque `begin/end` buscando en el
  método que invocó un manejador para la misma, y así siguiendo hacia arriba en
la pila
* Casi siempre usaremos nombre de clases como parámetros a `rescue`, pero
  podemos usar expresiones que retornen una subclase de `Exception`

---
## Asegurando la ejecución
* Varias veces necesitamos ejecutar determinado código al finalizar un método de
  forma segura, es decir independientemente de si se produce un error en la
  mitad
  * Por ejemplo, tenemos un archivo abierto, que necesitamos sea cerrado antes
    de finalizar el bloque
* La cláusula `ensure` cumple esta función
* El código bajo `ensure` se ejecutará siempre, haya sido una ejecución exitosa
  o con algún problema

---
## Un ejemplo ensure

```ruby
f = File.open("testfile")
begin
  # .. process
rescue
  # .. handle error
ensure
  f.close
end
```

---
## El else de rescue

* El `else` aplica cuando ninguno de los `rescue` manejan la excepción
* Tener cuidado porque `ensure` ejecutará siempre, incluso cuando no se produce
  un error

```ruby
f = File.open("testfile")
begin
  # .. process
rescue
  # .. handle error
else
  puts "Congratulations-- no errors!"
ensure
  f.close
end
```

---
## Volver a empezar...

* A veces podemos corregir una causa de excepción
* Para estos casos, podemos usar `retry` para volver a ejecutar el bloque
  `begin/end`
* Es muy factible caer en loops infinitos 

---
## Ejemplo retry

```ruby
@esmtp = true
begin
# First try an extended login. If it fails 
# because the server doesn't support it, 
# fall back to a normal login
if @esmtp then
  @command.ehlo(helodom)
else
  @command.helo(helodom)
end
rescue ProtocolError
  if @esmtp then
    @esmtp = false
    retry
  else
    raise
  end
end
```

---
## Lanzando excepciones

Podemos lanzar excepciones usando el método `Kernel.raise`

```ruby
raise
raise "bad mp3 encoding"
raise InterfaceException, "Keyboard failure", caller
```

* La primer forma relanza una excepción si la hubiere, o `RuntimeError` si no.
  Usualemnte dentro de `rescue`
* El segundo ejemplo, lanza `RuntimeError` con el mensaje indicado
* El tercer ejemplo, utiliza el primer parámetro para crear un excepción con el
  segundo parámetro usado como mensaje y la pila de ejecución en el tercer
  parámetro 
  * `Kernel.caller` genera la traza de ejecución

---
## Ejemplo de raise

```ruby
raise
raise "Missing name" if name.nil?
if i >= names.size
  raise IndexError, "#{i} >= size (#{names.size})"
end
raise ArgumentError, "Name too big", caller
```

*Generalmente no se incluye la traza en librerías*

---
## catch y throw

* Veremos un ejemplo que aclarará el concepto
  * El siguiente código leerá palabras que irá agregando en un arreglo que al
    finalizar imprimirá en orden inverso. Sin embargo, si alguna línea es
    incorrecta deberá salir sin hacer nada
  * El secreto es `throw(symbol, variable)`. **En este ejemplo es importante que
    el último puts retorna `nil`**

---
## Ejemplo de catch y throw

```ruby
def only_words(filename)
  word_list = File.open(filename)
  word_in_error = catch(:done) do
    result = []
    while line = word_list.gets
      word = line.chomp
      throw(:done, word) unless word =~ /^\w+$/
      result << word
    end
    puts result.reverse
  end
  if word_in_error
    puts "Failed: '#{word_in_error}' found. Not a word"
  end
end
```

***

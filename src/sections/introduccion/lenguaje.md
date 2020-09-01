# El lenguaje

<div class="main-list">

* introducción
</div>

----
# El lenguaje

* Dinámico
* Sintaxis concisa y expresiva 
* Orientado a objetos
* Capacidades de metaprogramación
* Características funcionales

----
## Sintaxis y convenciones

Nombres válidos y convenciones:

```ruby
  NombreDeClaseOModulo
  CONSTANTE
  @nombre_de_atributo
  @@atributo_de_clase
  $variable_global
  nombre_de_metodo
  metodo_peligroso!
  metodo_que_pregunta?
```

----
## Objetos

Todos los valores son **objetos**

```ruby
"Aprendiendo ruby".length
"Aprendiendo ruby".each_char.sort.join
1 + 2
1.send :+, 2
```
## Arreglos

```ruby
["Go", "Ruby", "Java", "Python", "PHP", "Javascript"].sort
([1,2,3] + [4,5,6]).last
```

----


## Números

```ruby
-100.abs
1_123_456 * 1_000_000
1.5 * 3
0b1000_1000   # Binario     =>  136
010           # Octal       =>    8
0x10          # Hexadecimal =>   16
```

<div class="container">
  <div class="col">

### nil

```ruby
a = Array.new
a[10].nil?
nil.nil?
```

  </div>
  <div class="col">

### object id

```ruby
1.object_id
nil.object_id
```
  </div>
</div>
----

## Strings

<div class="container">
  <div class="col">

### Literales

```ruby
'sin interpolar'
"Interpolando: #{'Ja'*3}!"

# Notación alternativa
%q/Hola/
%q!Chau!
%Q{Interpolando: #{3+3}}
```
  </div>
  <div class="col">

### Here document

```ruby
un_string = <<-EOS
  Este es un texto
  de mas de una linea
  que termina aqui.
  Se puede observar que
  espacios antes de cada
  linea.
EOS

un_string.upcase
```
  </div>
</div>

----
## Símbolos

* Son como variables prefijados con **:** (dos puntos)
  * Ejemplos: `:action`, `:line_items`, `:+`
* No es necesario declararlos 
* Se garantiza que son únicos
  * No es necesario asignarles ningún valor

```ruby

:uno.object_id  # siempre devolverá lo mismo
"uno".object_id # siempre devolverá diferente

```
----
## Colecciones

<div class="container small">
  <div class="col">

### Arreglos

```ruby

['Hola', 'Chau']

# sin interpolar
%w(Hola Chau #{2+2})

# interpolando
%W(Hola Chau #{2+2})

[1,2,3,4]
```

  </div>
  <div class="col">


### Hashes

```ruby
# Versión 1.8
{
  :nombre   => 'Christian',
  :apellido   => 'Rodriguez'
}
# Versión > 1.8
{
  nombre:   'Christian',
  apellido:   'Rodriguez'
}
```

  </div>
</div>

----
## Expresiones regulares

```ruby
/^[a-zA-Z]+$/
"Do you like cats?" =~ /like/
"192.168.0.10" =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
```


> Explicación en [Pickaxe](https://ruby-doc.com/docs/ProgrammingRuby/html/intro.html#S5).
> Con [Rubular](https://rubular.com/) es posible probarlas.
----
<div class="container small">
  <div class="col">

## Rangos

```ruby

0..1
0..10
"a".."z"
"a"..."z"

# Pueden convertirse en arreglos
("a"..."z").to_a

# Rangos como intervalos
(1..10) === 5     # => true
(1..10) === 15    # => false
(1..10) === 3.1   # => true

```

  </div>
  <div class="col">

## Expresiones

```
a = 3.14 # => 3.14

# Veamos el case
estado = nil
face =  case estado
        when "Feliz"  then ":)"
        when "Triste" then ":("
        else               ":|"
end

```


> En Ruby toda expresión retorna un valor 

  </div>
</div>

----

<div class="container small">
  <div class="col">

## Lambdas

```ruby
uno = lambda { |n| n * 2 }
dos = ->(n, m){ n * 2 + m }
tres  = ->(n, m=0){ n * 2 + m}

# Entonces

uno.call 2      # => 4
dos.call 2,3    # => 7
tres.call 2     # => 4
```
  </div>
  <div class="col">

## Bloques


```ruby
3.times do |i|
  puts i
end

3.times { |i| puts i }
```

> Rara vez usaremos un for / while

  </div>
</div>
----
<!-- .slide: data-auto-animate -->
## Ejemplos de bloques y colecciones


<pre data-id="code-animation"><code class="ruby hljs" data-trim data-line-numbers>
# Selección de números pares
(1..10).select { |n| n.even? }

# Procesar cada elemento de una colección
(1..10).map { |n| n*2 }

# Calcular con los elementos de la colección:
(1..100).reduce { |sum,n| sum + n }
</code></pre>



----
<!-- .slide: data-auto-animate -->
## Ejemplos de bloques y colecciones

<pre data-id="code-animation"><code class="ruby hljs" data-trim data-line-numbers="3,4,8,9,13,14">
# Selección de números pares
(1..10).select { |n| n.even? }
# o lo que es igual:
(1..10).select(& :even?)

# Procesar cada elemento de una colección
(1..10).map { |n| n*2 }
# o lo que es igual:
(1..10).collect { |n| n*2 }

# Calcular con los elementos de la colección:
(1..100).reduce { |sum,n| sum + n }
# o lo que es igual:
(1..100).reduce(:+)
</code></pre>

----
## Bloques y archivos

```ruby

File.open('/etc/passwd').each do |line|
  puts line if line =~ /root/
end
```


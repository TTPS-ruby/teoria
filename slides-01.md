***
# Introducción a Ruby
---
# Historia
---

![Yukihiro Matsumoto](images/01/yukihiro-matsumoto.jpg)

### MATZ
---
## MATZ
* [Yukihiro Matsumoto](http://en.wikipedia.org/wiki/Yukihiro_Matsumoto)
  * En japonés: 松本行弘 (まつもとゆきひろ)
  * Matz más simple
  * Empezó el desarrollo de Ruby en 1993
  * En 1995 lanzó la primera versión
  * Aún lidera el desarrollo de Ruby
* Su célebre frase:

Ruby is designed to make programmers **HAPPY**

---
## ¿Cómo surge Ruby?
* Fusión de lenguajes
  * Smalltalk
  * Perl
  * LISP
* Hasta el 2001 conocido sólo en Japón
  * El libro [Programming Ruby](http://pragprog.com/book/ruby/programming-ruby) fue el 
    impulsor del lenguaje fuera de Japón
  * También conocido como PickAxe
  * La primera versión puede [leerse en línea](http://ruby-doc.org/docs/ProgrammingRuby/)

---
![pickaxe](images/01/pickaxe.jpg)
---
## En el 2005, en Dinamarca aparece DHH...

![DHH](images/01/dhh.jpg)

---
## DHH
* [David Heinemeier Hansson](http://en.wikipedia.org/wiki/David_Heinemeier_Hansson) creador de Rails
* [Rails](http://rubyonrails.org/)
  * Framework open source para desarrollo de aplicaciones web
  * Creado en 2004
  * Su primer versión liberada (1.0) fue en 2005
  * Actualmente en la versión 4.0

![Rails](images/01/rails.png)
---
# El lenguaje
---
## Características
* Dinámico
* Sintaxis concisa y expresiva 
* Orientado a objetos
* Capacidades de metaprogramación
* Características funcionales

---
## Sintaxis y convenciones

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

---
## Objetos

Todos los valores son **objetos**

```ruby

"Aprendiendo ruby".length

```
---
## Arreglos

```ruby

["Mateo", "Lola", "Lihue", "Clio"].sort

```

## Números

```ruby

-100.abs

```

## nil

```ruby

nil.nil?

```

---
## Más ejemplos

```ruby

1.object_id

nil.object_id

```

### Simple y conciso

```ruby

([1,2,3] + [4,5,6]).last

```
---
## Literales
### Números literales

```ruby

3
3.14
1_999_235_243_888 == 1999235243888

```
### Binario, octal o hexadecimal

```ruby

0b1000_1000   # Binario     =>  136
010           # Octal       =>    8
0x10          # Hexadecimal =>   16

```

---
## Strings literales

```ruby

'sin interpolar'
"Interpolando: #{'Ja'*3}!"

# Otra forma de escribir un string
%q/Hola/
%q!Chau!
%Q{Interpolando: #{3+3}}

```

## Strings como here document

```ruby
un_string = <<EOS
  Este es un texto
  de mas de una linea
  que termina aqui
EOS

un_string.upcase
```

---
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

---
## Arreglos

```ruby

['Hola', 'Chau']

%w(Hola Chau #{2+2})  # sin interpolar

%W(Hola Chau #{2+2})  # interpolando

[1,2,3,4]
```

## Hashes

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

---
## Expresiones regulares

```ruby

/^[a-zA-Z]+$/

```


*Explicación detallada en
[Pickaxe](http://www.ruby-doc.org/docs/ProgrammingRuby/html/language.html#UJ)*

*Para probar expresiones regulares puede usar [Rubular](http://rubular.com/)*

---
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

---
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

---
## Métodos como operadores

```ruby

10 - 2

# Es equivalente a:
10.send :-, 2

# Operadores con arreglos
[1,2,3] - [1]

```

---
## Expresiones
En Ruby toda expresión retorna un valor 

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

---
## ¿Qué retorna la siguiente expresión?

```ruby

def foo
  "bar"
end

```
**Su ejecución retorna `"bar"`**

<small class="fragment">
En versiones previas a la 2.0 retorna **nil**, en versiones superiores el símbolo
con el nombre del método

</small>

---
## Bloques
Rara vez usaremos un for / while

```ruby

3.times do |i|
  puts i
end

# Imprime:
#  0
#  1
#  2
# Retorna 3 (que es quien recibe el método :times)

# También es posible
3.times { |i| puts i }

```
---
## Programando declarativamente

```ruby

# Los pares
(1..10).select { |n| n.even? }

# o lo que es igual:
(1..10).select(& :even?)

# Procesando cada elemento
(1..10).map { |n| n*2 }

# o lo que es igual:
(1..10).collect { |n| n*2 }

```
---
## Más ejemplos

```ruby

(1..100).reduce { |sum,n| sum + n }

# o lo que es igual:
(1..100).reduce(:+)

# La formula de verificacion es: n*(n+1)/2
100*101/2
```

---
## Aumentando la fluidez

```ruby

File.open('/etc/passwd').each do |line|
  puts line if line =~ /root/
end
```
---
## ¿Qué es duck typing?
* Es un término empleado en **OO**
* Estilo de tipeo dinámico donde:
  * Los métodos y propiedades determinan la semántica válida
  * No se basa en el uso de herencia o interfaces para indicar la propiedad: **es un
    ..**
* El nombre del concepto se refiere al *duck test*, atribuído a James Whitcomb
  Riley que podría resumirse en:

*Si veo un pájaro que camina como pato, nada como pato y hace "cuack" como pato,
entonces llamaré a ese pájaro un pato*

---
## Duck typing en Java

```java
public interface DuckLike {
  Cuack cuack();
}
//...
public void doSomething(DuckLike d) {
  d.cuack();
//  ...
}
```

---
## En Java debemos usando reflexión

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class DuckTyping {

  interface Walkable  { void walk(); }
  interface Swimmable { void swim(); }
  interface Quackable { void quack(); }

  public static void main(String[] args) {
    Duck d = new Duck();
    Person p = new Person();

    as(Walkable.class, d).walk();   //duck can walk()
    as(Swimmable.class, d).swim();  //duck can swim() 
    as(Quackable.class, d).quack(); //duck can quack()

    as(Walkable.class, p).walk();   //person can walk()
    as(Swimmable.class, p).swim();  //person can swim() 
    // Gives Runtime Error
    as(Quackable.class, p).quack(); //person can't quack()
  }
  @SuppressWarnings("unchecked")
  static <T> T as(Class<T> t, final Object obj) {
    return (T) Proxy.newProxyInstance(t.getClassLoader(), 
      new Class[] {t},
      new InvocationHandler() {
        public Object invoke(Object proxy, 
              Method method, 
              Object[] args) throws Throwable {
          try {
            return obj.getClass()
              .getMethod(method.getName(), 
                 method.getParameterTypes())
              .invoke(obj, args);
          } catch (NoSuchMethodException nsme) {
            throw new NoSuchMethodError(
              nsme.getMessage());
          } catch (InvocationTargetException ite) {
            throw ite.getTargetException();
          }
        }
      });
  }
}
```

---

## Las clases Duck y Person

```java
class Duck {
  public void walk()  {
    System.out.println("I'm Duck, I can walk...");
  }
  public void swim()  {
    System.out.println("I'm Duck, I can swim...");
  }
  public void quack() {
    System.out.println("I'm Duck, I can quack...");
  }
}

class Person {
  public void walk()  {
    System.out.println("I'm Person, I can walk...");
  }
  public void swim()  {
    System.out.println("I'm Person, I can swim...");
  }
  public void talk()  {
    System.out.println("I'm Person, I can talk...");
  }
}
```

---
# En Ruby

```ruby
class Duck
  def quack
    puts "Quaaaaaack!"
  end
  def feathers
    puts "The duck has white and gray feathers."
  end
end
class Person
  def quack
    puts "The person imitates a duck."
  end
  def feathers
    puts "The person takes a feather from the ground"
  end
end
def in_the_forest(duck)
  duck.quack
  duck.feathers
end
   
donald = Duck.new
john = Person.new
in_the_forest donald
in_the_forest john
```
---
## ¿Qué es monkey patching?
* Modificar una clase dinámicamente
* En tiempo de ejecución, agregar nuevos métodos a una clase o cambiar su
  comportamiento
* El término surge de **Gorilla Patch** 
  * *Monkey patch es menos intimidante*

---
## Monkey patching: ejemplo

```ruby
(1..10).even # da error: even no existe

class Range
  # Agregamos even a Range
  def even
    self.select(& :even?)  
  end
end

(1..10).even # ahora no da error
# => [2,4,6,8,10]
```

---
## Módulos como Namespace

```ruby
module MyAPI
  class User
  ...
  end

  def self.configuration
  ...
  end
end

user = MyAPI::User.new

puts MyAPI::configuration
```

---
## Módulos como Mixins

*Como las interfaces, pero con comportamiento*

```ruby
module MyLog
  def log(msg)
    puts "Log: #{msg}"
  end
end
```
*¿Cómo usar un mixin?*

```ruby
class String; include MyLog; end

"hola".log("pepe")
```

---
## Referencias

* [PickAxe](http://www.ruby-doc.org/docs/ProgrammingRuby/)
* [why's (poignant) Guide to Ruby](http://www.rubyinside.com/media/poignant-guide.pdf)
* Muy inspirado en la gran presentación de Jano González presentada en la
  RubyConf 2012 Argentina
  * [¿Donde están mis interfaces?](https://speakerdeck.com/janogonzalez/donde-estan-mis-interfaces)
***

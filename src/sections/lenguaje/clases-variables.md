# Clases y variables

<div class="main-list">

* ruby

</div>

----

# Clases

----
## Control de acceso

* Permitir demasiado acceso en las clases incrementará el **acoplamiento** de
  la aplicación: _los usuarios de una clase que se expone demasiado podrían confiar en
    detalles de implementación en vez de su interfaz lógica._
* Ruby provee control de acceso a los métodos
* Una regla importante es: **_Nunca exponer métodos que puedan dejar un objeto
  en estado inválido_**.

----

## Niveles de protección
* **Públicos:** los métodos públicos pueden invocarse por cualquiera. Los
  métodos son públicos por defecto excepto `initialize` que es privado.
* **Protegidos:** pueden invocarse por objetos de la clase que lo define y
  subclases.
* **Privados:** no pueden ser invocados con un receptor explícito:
  _el receptor es siempre el objeto actual, `self`_. Esto
  significa que tampoco puede invocar el método privado de otra instancia de la
  misma clase.

----
## Aplicando accesos

```ruby
class MyClass
  def method  # default is public
  end

  protected   # subsequent methods will be 'protected'
  def method2
  end

  private     # subsequent methods will be 'private'
  def method3
  end

  public      # subsequent methods will be 'public'
  def method4
  end
end
```
----
## Alternativamente

```ruby
class MyClass
  def method1; end
  def method2; end
  def method3; end
  def method4; end

  public :method1, :method4
  protected :method2
  private :method3
end
```

----

# Variables

----
## Variables
* Hemos usado variables en varias oportunidades.
* Se usan para no perder valores y poder referenciarlos nuevamente.
* Cada variable es una **referencia** a un objeto.

> *Is a variable an object?* ***In Ruby, the answer is no.*** *A variable is simply a
> reference to an object. Objects float around in a big pool somewhere (the heap, most of the
> time) and are pointed to by variables.*

----

## Son referencias

Analicemos el siguiente ejemplo

```ruby
person1 = "Tim"
person2 = person1
person1[0] = 'J'
puts "person1 is #{person1}"
puts "person2 is #{person2}"
```

### Para evitarlo: `dup`

```ruby
person1 = "Tim"
person2 = person1.dup
person1[0] = 'J'
puts "person1 is #{person1}"
puts "person2 is #{person2}"
```
----

## Freezando un objeto

Es posible freezar objetos

```ruby
person1 = "Tim"
person2 = person1
person1.freeze
person2[0] = 'J'
```



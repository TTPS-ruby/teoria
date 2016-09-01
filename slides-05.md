***
# Variables
---
## Variables
* Hemos usado variables en varias oportunidades
* Se usan para no perder valores y poder referenciarlos nuevamente
* Cada variable es una **referencia** a un objeto
* Son lo único que no son objetos en ruby: 

*Is a variable an object?* ***In Ruby, the answer is no.*** *A variable is simply a
reference to an object. Objects float around in a big pool somewhere (the heap, most of the
time) and are pointed to by variables.*

---
## Variables como alias
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
---
## Freezando un objeto
Es posible freezar objetos

```ruby
person1 = "Tim"
person2 = person1
person1.freeze
person2[0] = 'J'
```

***

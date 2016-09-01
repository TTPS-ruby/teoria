***
# Clases
---
## Control de acceso
* Al diseñar la interfaz de una clase es importante definir qué publicaremos al
  mundo
* Permitir demasiado acceso a nuestras clases, incrementará el riesgo de
 **acoplamiento** de la aplicación
  * Los usuarios de una clase que se expone demasiado podrían confiar en
    detalles de implementación en vez de su interfaz lógica
* Ruby provee control de acceso a los métodos (que son quienes permitirían
  alterar el estado de un objeto)
* Una regla importante es:
  * Nunca exponer métodos que puedan dejar un objeto en estado inválido

---
## Niveles de protección
* **Públicos:** los métodos públicos pueden invocarse por cualquiera (no hay
  control de acceso). Los métodos son públicos por defecto excepto initialize que
  siempre es privado.
* **Protegidos:** pueden invocarse sólo por objetos de la clase que lo define y 
  sus subclases. El acceso queda en la familia.
* **Privados:** estos métodos no pueden ser invocados con un receptor explícito: 
  *el receptor es siempre el objeto actual, mejor conocido como `self`*. Esto
  significa que tampoco puede invocar el método privado de otra instancia de la
  misma clase.

---
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
---
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

***

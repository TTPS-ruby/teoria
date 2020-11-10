# Ejemplo de Active Record y validaciones

Para poder utilizar este ejemplo instalaremos como de costumbre las dependencias
utilizando bundler y luego crearemos una base de datos y correremos las
migraciones:

```bash
bundle
bundle exec rake db:create db:migrate
```

Podremos analizar el esquema de la base de datos conectando con ella y
utilizando el comando `.schema`:

```bash
sqlite3 db/development.sqlite3  '.schema'
```

> El archivo `main.rb` prepara el ambiente de prueba

## Pruebas

Instanciamos una consola en el contexto de nuestro proyecto:

```bash
irb -I . -r main
```

Con el ejemplo brindado se pueden verificar algunas validaciones como ser:

* Que el campo **`name`** sea requerido y contenga sólo letras.
* Que una persona sea válida si tiene una variable de instancia **`terminos`**
  cuyo valor sea true.

## Agregar algunos ejemplos con campos booleanos

Podemos modificar a nuestro modelo y agregar validaciones respecto de un campo
booleano.

Para ello se propone agregar los siguientes atributos a la clase person:

```ruby
  attr_accessor :boolean_field_name
  validates :boolean_field_name, presence: true
```

Con esa definición, verificar cómo funciona la clase utilizando el atributo
llamado **`boolean_field_name`** con valores true, false y nil.

> Analizar qué sucede si necesitamos almacenar el valor **false**.

### Mejoramos el uso del atributo booleano

Cambiar la validación de presencia por alguna de las siguientes:

```ruby
  validates :boolean_field_name, inclusion: { in: [true, false] }
  validates :boolean_field_name, exclusion: { in: [nil] }
```

Repetir las pruebas anteriores.

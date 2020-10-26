# Ejemplo con Active Record

Este ejemplo implementa un modelo que representa productos que a priori
únicamente tienen un nombre. 

## La base de datos

AR permite conectar a diferentes motores, abstrayendo al usuario del motor
relacional a utilizar. Si bien se proveen herramientas para generar el esquema
de la base de datos, en esta instancia crearemos la estructura de la base de
datos manualmente e incluso agregaremos un dato utilizando SQL.

Para las pruebas utilizaremos [SQLite](https://www.sqlite.org/):

```bash
sqlite3 /tmp/sample.db
```

> El comando anterior conecta a un archivo que representa la base de datos.

Procedemos a inicializar la estructura e insertar un dato:

```sql
create table products(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name varchar(255));

insert into products(name) values('pelota'),('botines');
```

## El programa

Desarrollamos a modo de ejemplo una aplicación principal llamada `main.rb` que
lista los productos en la base de datos.

> Observar el uso de bundler en el ejemplo analizando `Gemfile`

```bash
ruby main.rb
```

> La aplicación fallará si la base de datos no es creada previamente como se
> indica en la sección anterior. El path a la base de datos puede parametrizarse
> con la variable de ambiente DB_NAME

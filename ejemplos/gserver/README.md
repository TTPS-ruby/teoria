# Ejemplo de socket TCP con gserver

Este ejemplo muestra como utilizar la herencia tomando como ejemplo el uso de la
clase GServer. Antes, gserver era parte de la librería estándar pero ahora debe
instalarse como una librería externa.
Por ello, este ejemplo utiliza [Bundler](https://bundler.io/), un manejador de
dependencias para ruby.

Vamos a proceder a probar el ejemplo, usando bundler para instalar gserver:

```bash
# Instalamos bundler si no está instalado
bundler version || gem install bundler

# Instalamos las dependencias del proyecto, es decir, gserver
bundle install

# Corremos el ejemplo en el contexto de bundler
bundle exec ruby log_server.rb
```
> El comando se quedará sin mostrar nada porque se queda esperando conexiones al
> puerto configurado

## Probando el servicio

El servicio que hemos desarrollado espera conexiones TCP en el puerto 12345.
Podemos verificar ésto con el comando:

```
netstat -nltp
```
> Alguna línea debe mostrar el puerto 12345. Puede que su sistema utilice el
> comando `ss` en vez de `netstat`

Para verificar el funcionamiento correcto, probamos establecer una conexión
con nuestro servicio:

```
telnet localhost 12345
```
> El comando telnet al puerto de nuestro servicio imprimirá los últimos
> caracteres de los logs del sistema.

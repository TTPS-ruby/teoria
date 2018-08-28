***
# Ruby VMs
---
## MRI

* Matz' Ruby Implementation
* También llamada CRuby
* Es la implementación de referencia del lenguaje
* Últimas versiones
  * 1.8.7-p375 (No usar!)
  * 1.9.3-p551
  * 2.0.0-p547
  * 2.1.10
  * 2.2.5
  * 2.3.1
  * 2.4.4

---
## JRuby

* Ruby en la JVM
* Es la alternativa más madura a MRI en términos de compatibilidad con MRI
* Combina lo mejor de la plataforma de la JVM con Ruby:
  * Concurrencia real
  * Interoperabilidad con librerías Java
* Últimas versiones
  * jruby-9.2.0.0
* Modos
  * 1.8.x
  * 1.9.x 
  * 2.x

---
## Rubinius

* Ruby escrito en (mayoritariamente) Ruby
* La VM fue escrita en C++
* El bytecode compiler y una gran parte de las clases Core de Ruby fueron escritas en Ruby
* Últimas versiones
  * rbx-3.105
  * rbx-2.11

---
## Otras implementaciones

* IronRuby
  * Ruby en .NET
  * El proyecto está inactivo
* MagLev: 
  * Ruby en la VM GemStone/S 3.1 de VMware (Smalltalk!)

---
## Referencias

* MRI
  * [http://ruby-lang.org](http://ruby-lang.org)
  * [https://github.com/ruby/ruby](https://github.com/ruby/ruby)
* JRuby: Referencias
  * [http://jruby.org/](http://jruby.org/)
  * [https://github.com/jruby/jruby](https://github.com/jruby/jruby)
* Rubinius: Referencias
  * [http://rubini.us/](http://rubini.us/)
  * [https://github.com/rubinius/rubinius](https://github.com/rubinius/rubinius)
---
## Referencias

* Otras implementaciones: referencias
  * [http://ironruby.codeplex.com/](http://ironruby.codeplex.com/)
  * [https://github.com/ironlanguages/main](https://github.com/ironlanguages/main)
  * [http://macruby.org/](http://macruby.org/)
  * [https://github.com/MacRuby/MacRuby](https://github.com/MacRuby/MacRuby)
  * [http://maglev.github.io/](http://maglev.github.io/)
  * [https://github.com/MagLev/maglev](https://github.com/MagLev/maglev)

---
## Instalando Ruby

Muchas implementaciones

¿Cual usar?

¿Y si necesito o quiero usar más de 1?

## Un pequeño paréntesis

Gemas

Bundler

---
## RVM

* Ruby Version Manager
* Fue la primera herramienta para instalar, administrar y trabajar con múltiples entornos de Ruby
* Introduce el concepto de gemset
* Modifica el comando `cd` para cambiar de versión de ruby

---
## rbenv

* Ruby environment
* Fue la primera alternativa a RVM y rápidamente se hizo muy popular
* Es más simple que RVM y ya no instala rubies ni usa gemsets
* Se puede agregar funcionalidad con plugins
* **Es la opción que explicaremos**

---
# Instalando rbenv
---
## Instalando rbenv

La instalación se realiza con **git** en el directorio `~/.rbenv`

```bash

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile

# En ubuntu, hacer el `echo` en `.bashrc` en vez de `.bash_profile`
# Agregamos `rbenv init` al shell para habilitar el autocompletado

echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

```
<small>
*En ubuntu, hacer el `echo` en `.bashrc` en vez de `.bash_profile`*
</small>

**Debemos reiniciar el shell para que tome cambios**

```

$ exec $SHELL -l

```

<small>
*Con rbenv podemos seleccionar qué ruby usar. __No instala ruby__*
</small>

---
## Plugin para instalar ruby

Es necesario instalar **ruby-build** en el directorio `~/.rbenv/plugins`

```bash 

git clone https://github.com/sstephenson/ruby-build.git \
  ~/.rbenv/plugins/ruby-build

```

---

## rbenv: Comandos

* **`rbenv versions`**: muestra las versiones instaladas de ruby (con un * la versión actual)
* **`rbenv global`**: muestra o setea la versión global de ruby
* **`rbenv local`**: identico al comando anterior, pero para el directorio actual
* **`rbenv install`**: instala rubies! (con `-l` listamos todas las versiones disponibles)

---
## Referencias

* [https://rvm.io/](https://rvm.io/)
* [https://github.com/sstephenson/rbenv](https://github.com/sstephenson/rbenv)
* [https://github.com/sstephenson/ruby-build](https://github.com/sstephenson/ruby-build)
***

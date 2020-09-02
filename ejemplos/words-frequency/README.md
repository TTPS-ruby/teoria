# Ejemplo de uso de colecciones

Este ejemplo muestra el uso de array y hashes. No es la implementación más
adecuada porque aún no hemos aprendido aún el manejo de colecciones con
iteradores que simplifican el uso de las mismas.

Para utilizar el ejemplo provisto, simplemente correr:

```
ruby top_five.rb <FILE>
```

> Se provee un archivo de ejemplo en este repositorio

## Pruebas usando Unit Test

El directorio `tests/` mantiene los tests de las funciones utilizadas por este
programa. Para correr los tests, simplemente correr:

```
bundle # instala las dependencias

# Corremos ruby con las dependencias instaladas
bundle exec ruby test/test-count_frequency.rb
bundle exec ruby test/test-words_from_string.rb
```

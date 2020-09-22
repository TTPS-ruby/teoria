# Ejemplo de uso de Objetos y atributos

Este ejemplo muestra como organizar el código, utilizar una librería externa y
referenciar las dependencias usando `require` y `require_relative`.

Para ello, clonar este repositorio. Luego, acceder a la carpeta del ejemplo,
y con ruby instalado, proceder de la siguiente forma:

* Generar una serie de archivos csv de ejemplo
* Probar el programa principal

## Generando los csv

```
for i in $(seq 1 10); do 
  ruby utils/generate_random_csv_files.rb > /tmp/ttps-bookinstore-file$i.csv
done
```
> El comando anterior dejará en la carpeta `/tmp` 10 archivos csv.

## Corriendo el programa

```
ruby stock_stats.rb /tmp/ttps-bookinstore-file*.csv
```

Podemos comprobar el programa usando [AWK](https://www.gnu.org/software/gawk/)

```
awk -F',' \
  'begin {total = 0} {total += $3} END {printf "total: %.3f\n", total}' \
  /tmp/ttps-bookinstore-file*.csv
```

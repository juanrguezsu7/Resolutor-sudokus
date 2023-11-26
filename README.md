# Resolutor de sudokus en Prolog
## Descripción
Este proyecto es un resolutor de [sudokus](https://wikipedia.org/wiki/sudoku) en Prolog. El programa recibe un sudoku en forma de lista y devuelve la solución del sudoku. El programa está dividido en dos partes: la primera parte es la que se encarga de resolver el sudoku y la segunda parte es la que se encarga de imprimir el sudoku por pantalla.
## Autor
- Juan Rodríguez Suárez.
## Ejecución
**1.** Para ejecutar el programa, se debe ejecutar el siguiente comando:
```
swipl sudoku.pl
```
**2.** Una vez dentro de la consola de Prolog, se debe ejecutar el siguiente comando:
```prolog
X = [9,_,_,1,_,_,_,_,7,...], sudoku($X, S).
```
**3.** El programa imprimirá la solución del sudoku (variable *S*) en un fichero llamado "sudoku_resuelto.txt".
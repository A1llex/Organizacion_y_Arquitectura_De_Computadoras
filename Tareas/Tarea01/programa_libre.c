/**
 * FernandezAguilar Alex Gerardo
 * 314338097
 **/
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int num;
    printf("Hola escribe un numero y te dire si es mayor a cero \n");
    scanf("%i",&num);
    if (num > 0)
    {
        printf("El numero es mayor a cero\n");
    }
    else
    {
        printf("El numero es menor o igual a cero\n");
    }
    return 0;
}
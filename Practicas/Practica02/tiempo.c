/**
 * @file desempeño.c
 * @author Martin Felipe Espinal Cruces
 *         Alex Gerardo  Fernández  Aguilar
 * @brief Programa que dada una tabla en un documento de texto obtiene 
 * la de mejor desempeño bajo dos unidades HIB o LIB
 * @version 1
 * @date 2020-02-29
 * 
 * @copyright Copyright (c) 2020
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

float tiempo_ejecucion(FILE *fichero);
float tiempo_ejecucion_alt(FILE *fichero);

/**
 * @brief Funcion principal
 * @param argc número de argumentos al ser ejecutado.
 * @param argv arreglo donde se almacenan los argumentos.
 */
int main(int argc, char **argv)
{
    FILE *file;
    char *ruta;
    float tiempo = 0;
    if (argc == 2)
    {
        ruta = argv[1];
        file = fopen(ruta, "r");
        tiempo = tiempo_ejecucion(file);
        fclose(file);
        printf("El tiempo de ejecucion es de %.3f \n",tiempo);   
    }
    else if (argc == 3)
    {
        ruta = argv[2];
        char *bandera = argv[1];
        if (argv[1][0] != 'C')
        {
            printf("Error, solo se pueden agregar la bandera C");
            return 0;
        }
        file = fopen(ruta, "r");
        tiempo = tiempo_ejecucion_alt(file);
        fclose(file);
        printf("El tiempo de ejecucion es de %.3f \n",tiempo);
    } else
    {
        printf("Error en el formato de ejecucion.");
        return 0;
    }
}


/**
 * @brief Funcion para leer la informacion del archivo de la forma tradicional
 * @param fichero el archivo
 * @return float el tiempo de ejecucion del programa
 */
float tiempo_ejecucion_alt(FILE *fichero)
{
    if (fichero == NULL)
    {
        printf("Ocurrio un error al leer el archivo");
    }
    int n=0;
    fscanf(fichero, "%i", &n);
    float instrucciones[n];
    int instruccion = 0;
    fscanf(fichero, "%i", &instruccion);
    float k=0;
    for (int i = 0; i < n; i++)
    {
        fscanf(fichero, "%f", &k);
        instrucciones[i] = k;
    }
    float total = 0;
    int j = 0;
    for (int i = 0; i < instruccion; i++)
    {
        fscanf(fichero , "%i", &j);
        total += instrucciones[j];
    }
    char bandera[5];
    float tiempo = 1 ;
    fscanf(fichero, "%s", &bandera[0]);
    if (bandera[0] == 'T')
    {
        fscanf(fichero, "%f", &tiempo);
        return (tiempo*total);
    }
    else
    {
        fscanf(fichero, "%f", &tiempo);
        return ((1/tiempo)*total);
    }
}

/**
 * @brief Funcion para leer la informacion del archivo de la forma tradicional
 * @param fichero el archivo
 * @return float el tiempo de ejecucion del programa
 */
float tiempo_ejecucion(FILE *fichero)
{
    if (fichero == NULL)
    {
        printf("Ocurrio un error al leer el archivo");
    }
    int n=0;
    fscanf(fichero, "%i", &n);
    float instrucciones[n];
    float k=0;
    for (int i = 0; i < n; i++)
    {
        fscanf(fichero, "%f", &k);
        instrucciones[i] = k;
    }
    float total = 0;
    k = 0;
    for (int i = 0; i < n; i++)
    {
        fscanf(fichero, "%f", &k);
        total += instrucciones[i] * k;
    }
    char bandera[5];
    float tiempo = 1 ;
    fscanf(fichero, "%s", &bandera[0]);
    if (bandera[0] == 'T')
    {
        fscanf(fichero, "%f", &tiempo);
        return (tiempo*total);
    }
    else
    {
        fscanf(fichero, "%f", &tiempo);
        return ((1/tiempo)*total);
    }
}
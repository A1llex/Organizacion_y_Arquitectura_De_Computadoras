/**
 * @file desempeño.c
 * @author Martin Felipe Espinal Cruces
 *         Alex Gerardo  Fernández  Aguilar
 * @brief Programa que dada una tabla en un documento de texto obtiene 
 * la de mejor desempeño bajo dos unidades HIB o LIB
 * @version 0.1
 * @date 2020-02-29
 * 
 * @copyright Copyright (c) 2020
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

/**
 * @brief Funcion auxiliar que crea una matriz de n por m
 * 
 * @param n numero de columnas
 * @param m numero de filas
 * @return float** arreglo dinamico con tamaño n por m
 */
float **crea_matriz(int n, int m)
{
    float **tabla = malloc(sizeof(float) * n);
    float aux;
    for (int i = 0; i < n; i++)
    {
        tabla[i] = malloc(sizeof(float) * m);
    }
    return tabla;
}

/**
 * @brief Funcion principal que cálcula el mejor desempeño de una serie de
 * computadoras y programas mediante la obtención de la normalización de
 * la tabla leida, el cálculo de la media aritmética, finalmente dada una 
 * bandera en la ejecución del programa obtiene la computadora de mejor 
 * rendimiento por el Funcion Higher Is Better (en el caso de ser R), o
 * Lower Is Better (En el caso de ser T).
 * 
 * @param fichero documento a leer
 * @param unidad caracter que indica el tipo de medida, R en caso de ser 
 * rendimiento, T en caso de ser tiempo.
 */
void mejor_desempeno(FILE *fichero, char *unidad)
{
    if (fichero == NULL)
    {
        printf("Ocurrio un error al leer el archivo");
    }
    int n, m;
    bool es_rendimiento = false;
    if (*unidad == 'R')
    {
        es_rendimiento = true;
    }
    //Lectura de numeros (Tamaño de la matriz)
    fscanf(fichero, "%d %d", &n, &m);
    //Creación del arreglo
    float **tabla = crea_matrizcrea_matriz(n, m);
    float aux;
    //Lectura del archivo
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            fscanf(fichero, "%f", &aux);
            tabla[i][j] = aux;
        }
    }
    //Creación de copia del arreglo
    float **tabla_normalizada = crea_matriz(n, m);
    //Normalización de la tabla
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            aux = tabla[i][j];
            //Se toma como referencia la primera computadora.
            tabla_normalizada[i][j] = aux / tabla[0][j];
        }
    }
    //Se obtiene la media geométrica y aritmetica de la tabla
    //normalizada y originial, respectivamente.
    float productoria = 1;
    float sumatoria = 0;
    float *media_geometrica = malloc(sizeof(float) * n);
    float *media_aritmetica = malloc(sizeof(float) * n);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            productoria *= tabla_normalizada[i][j];
            sumatoria += tabla[i][j];
        }
        aux = pow(productoria, (1.0 / n));
        media_geometrica[i] = aux;
        media_aritmetica[i] = (sumatoria / m);
        productoria = 1;
        sumatoria = 0;
    }
    float mejor = media_geometrica[0];
    int indice = 0;
    if (es_rendimiento)
    {
        //Se obtiene el indice de la computadora mayor (HIB).
        for (int i = 1; i < n; i++)
        {
            if (mejor < media_geometrica[i])
            {
                mejor = media_geometrica[i];
                indice = i;
            }
        }
    }
    else
    {
        //Se obtiene el indice de la computadora menor (LIB).
        for (int i = 1; i < n; i++)
        {
            if (mejor > media_geometrica[i])
            {
                mejor = media_geometrica[i];
                indice = i;
            }
        }
    }
    printf("%d\n", indice);
    for (int i = 0; i < n; i++)
    {
        if (es_rendimiento)
        {
            printf("%.4f \n", media_aritmetica[indice] / media_aritmetica[i]);
        }
        else
        {
            printf("%.4f \n", media_aritmetica[i] / media_aritmetica[indice]);
        }
    }
}

/**
 * @brief Funcion principal encargado de la ejecución del programa.
 * 
 * @param argc número de argumentos al ser ejecutado.
 * @param argv arreglo donde se almacenan los argumentos.
 */
void main(int argc, char **argv)
{
    FILE *file;
    char *nombre;
    char *medida;
    if (argc >= 3)
    {
        nombre = argv[2];
        file = fopen(nombre, "r");
        if (argv[1][0] != 'R' && argv[1][0] != 'T')
        {
            printf("Error, solo se pueden agregar las banderas R o T");
            return;
        }
        medida = argv[1];
        mejor_desempeno(file, medida);
    }
    else
    {
        printf("Error en el formato de ejecucion.\n Faltan argumentos");
        return;
    }
}

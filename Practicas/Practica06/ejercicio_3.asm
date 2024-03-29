.data
msg_n:	.asciiz "Ingresa un valor para n: "
msg_k: 	.asciiz "Ingresa un valor para k: "


# Termina la ejecucion del programa
# con una llamada al sistema.
.macro end()
	li 	$v0, 10       		# Se prepara para finalizar la ejecucion.   
	syscall				# Llamada al sistema para terminar el programa.
.end_macro


.macro read_int(%rd, %msg)
	move	$t0, $a0		# Movemos el contenido de $a0 a$t0 para preservarlo.
	
	li 	$v0, 4			# Se prepara para imprimir un mensaje.
	la 	$a0, %msg		# Guarda en $a0 la cadena 'msg'.
	syscall				# Imprime la cadena solicitando un numero al usuario.
	
	move 	$a0, $t0		# Regresamos el contenido original a $a0.
	li 	$v0, 5			# Se prepara para leer un entero.
	syscall				# Llamada al sistema para leer dicho entero.
	move 	%rd, $v0		# Guarda en el registro %rd el valor ingresado.
.end_macro


.macro print_int(%rs)
	move 	$a0, %rs		# Guarda el valor del registro %rs en $a0.
	li 	$v0, 1			# Se prepara para imprimir un entero.
	syscall				# Llamada al sistema para imprimir dicho entero.
.end_macro


.macro pre_cf_binomial_0()
	addi 	$sp, $sp, -16		# Guarda espacio en la pila para 4 palabras (16 bytes).
	sw	$a1, 8($sp)		# Guardamos el valor de k.
	sw 	$a0, 4($sp)		# Guardamos el valor de n.
	sw 	$ra, 0($sp)		# Guardamos la direccion de retorno.
.end_macro


.macro con_cf_binomial_0()
	lw 	$ra, 0($sp)		# Restaura de la pila la direccion de retorno.
	addi 	$sp, $sp, 16		# Limpia la pila haciendo POP de 16 bytes (4 palabras).
	jr 	$ra			# Regresamos.
.end_macro


.macro pre_cf_binomial_1()
	addi 	$a0, $a0, -1		# n = n - 1.
	addi 	$a1, $a1, -1		# k = k - 1.
.end_macro

.macro con_cf_binomial_1()
	lw 	$a1, 8($sp)		# Restaura el valor de 'k' de la pila.
	lw 	$a0, 4($sp)		# Restaura el valor de 'n' de la pila.
	sw	$v0, 12($sp)		# Guarda el resultado de C(n-1, k-1) en la pila.
.end_macro

.macro pre_cf_binomial_2()
	addi 	$a0, $a0, -1		# n = n - 1.
.end_macro

.macro con_cf_binomial_2()
	lw 	$t0, 12($sp)		# Restaura el valor de C(n-1, k-1) de la pila.
.end_macro


.macro inv_cf_binomial()
	jal cf_binomial 		# Simplemente invocamos a la subrutina cf_binomial.	
.end_macro


.macro valida_caso_base_1(%n, %k)
	sge 	$t0, %n, $zero		# Si n >= 0, guarda un 1 en $t0.
					# Si n < 0, guarda un 0 en $t0.
	
	seq 	$t1, %k, $zero		# Si k = 0, guarda un 1 en $t1.
					# Si k != 0, guarda un 0 en $t1.
	
	add 	$t2, $t0, $t1		# Si k = 0 y n >= 0, $t2 = 2.
	
	beq 	$t2, 2, base_1		# Si k = 0 y n >= 0, vamos al caso base.
.end_macro


.macro valida_caso_base_2(%n, %k)
	seq 	$t0, %n, $zero		# Si n = 0, guarda un 1 en $t0.
					# Si n != 0, guarda un 0 en $t0.
	
	sgt 	$t1, %k, $zero		# Si k > 0, guarda un 1 en $t1.
					# Si k <= 0, guarda un 0 en $t1.
	
	add 	$t2, $t0, $t1		# Si n = 0 y k > 0, $t2 = 2.
	
	beq 	$t2, 2, base_2		# Si n = 0 y k > 0, vamos al caso base.
.end_macro


	.text
	.globl main


main:
	read_int($a0, msg_n)		# Lee un entero 'n' de stdin y lo guarda en $a0.
	read_int($a1, msg_k)		# Lee un entero 'k' de stdin y lo guarda en $a1.
	
	inv_cf_binomial()		# Calcula en $v0 el coefieciente binomial de 'n' en 'k'.
	
	print_int($v0)			# Imprime el coeficiente binomial de 'n' en 'k'.
	end()				# Finaliza la ejecucion del programa.


cf_binomial:
	pre_cf_binomial_0()		# Preambulo para calcular C(n, k).
	
	valida_caso_base_1($a0, $a1)	# Valida el caso en el que n >= 0 y k = 0.
					# De cunplirse, regresa 1.
	
	valida_caso_base_2($a0, $a1)	# Valida el caso en el que n = 0 y k > 0.
					# De cunplirse, regresa 0.
	
	pre_cf_binomial_1()		# Prologo a la invocacion de C(n-1, k-1).
	inv_cf_binomial()		# Invocacion de C(n-1, k-1).
	con_cf_binomial_1()		# Conclusion de la invocacion de C(n-1, k-1).
	
	move 	$t0, $v0		# Guardamos el contenido de $v0 en un registro temporal $t0.
	
	pre_cf_binomial_2()		# Prologo a la invocacion de C(n-1, k).
	inv_cf_binomial()		# Invocacion de C(n-1, k).
	con_cf_binomial_2()		# Conclusion de la invocacion de C(n-1, k).
	
	add 	$v0, $v0, $t0		# Regresamos C(n, k) = C(n-1, k-1) + C(n-1, k).
	j 	return			# Regresamos al caller.


return:
	con_cf_binomial_0()		# Conclusion del procedimiento.
	

base_1:	
	li 	$v0, 1			# Regresamos 1.
	j 	return			# Saltamos a la conclusion.
	

base_2:	
	li 	$v0, 0			# Regresamos 0.
	j 	return			# Saltamos a la conclusion.

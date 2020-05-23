.data
	mensaje1: .asciiz "Introduce el primer número \n"
	mensaje2: .asciiz "Introduce el segundo número \n"
	mensaje3: .asciiz "EL máximo común divisor es:\n"
.text
	main:
		#Pide el primer número
		li $v0, 4
		la $a0, mensaje1
		syscall 
		
		li $v0, 5
		syscall 
		
		#Lo almacena en t0
		move $s0, $v0 #a
		
		#Pide el segundo número
		li $v0, 4
		la $a0, mensaje2
		syscall 
		
		li $v0, 5
		syscall 
		
		#Lo almacena en t1
		move $s1, $v0 #b
		
		#Se hace la llamada a la función
		jal mcd
		
		#Se imprime el valor de a0
		li $v0, 4
		la $a0, mensaje3
		syscall
		
		#Se almacena el valor de r en a0
		move $a0 $s2
		li $v0 1
		syscall
		
		#Terminamos la ejecución
		li $v0, 10
		syscall
		
	mcd:
		do:
			move $s2 $s1
			div  $s0,$s1
			mfhi $s3
			move $s0,$s1
			move $s1,$s3
		while: 	bnez $s3,do
		
		#Regresamos a la función anterior
		jr $ra
.data
	mensaje1: .asciiz "Introduce la base\n"
	mensaje2: .asciiz "Introduce el exponente\n"
	mensaje3: .asciiz "EL resultado es:"
.text
	main:
		#Pide el primer número
		li $v0, 4
		la $a0, mensaje1
		syscall 
		
		li $v0, 5
		syscall 
		
		#Se alamcena x en t0
		move $t0, $v0
		
		#Pide el segundo número
		li $v0, 4
		la $a0, mensaje2
		syscall 
		
		li $v0, 5
		syscall 
		
		#Se almacena n en t1
		move $t1, $v0
		
		#Se hace la llamada a la función
		jal exp_log
		
		#Se imprime el valor de a0
		li $v0, 4
		la $a0, mensaje3
		syscall
		
		#Se almacena el valor de r en a0
		move $a0 $s0
		li $v0 1
		syscall
		
		#Terminamos la ejecución
		li $v0, 10
		syscall
		
	exp_log:
		li $s0 1 # r
		li $s1 0 # y
		move $s1, $t0 # y = x
		while: 
			# si (n == 1) sale
			ble  $t1 1 end
			# (n % 2)
			div $t2 $t1 2
			# si (n % 2 == 1)
		      	beq $t2 1 then
		      	j multi 
		then:  
			# r = r * y
			mul $s0 $s0 $s1
		       	j multi
		multi: 
			# n = n/2
			div $t1 $t1 2
			# y = y * y
		      	mul $s1 $s1 $s1
		       	j while
		end:   
			# r = r * y
			mul $s0 $s0 $s1
		#Regresamos a la función anterior
		jr $ra
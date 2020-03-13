import time
start_time = time.time()

def LinearFibonacci(n):
 fn = f1 = f2 = 1   
 for x in range(2, n):
  fn = f1 + f2
  f2, f1 = f1, fn
  print("<<< ",x," >>>")
 return fn


def main():
    print(LinearFibonacci(int( input() ) ) )
    print("Tiempo  ", (time.time() - start_time ) )
    
main()
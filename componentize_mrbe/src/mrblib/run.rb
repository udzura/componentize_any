def run
  puts "Hello, World from Really Ruby Script!"
  puts "fib(20) = #{fib(20)}"
  0
end

def fib(n)
  n < 2 ? n : fib(n - 1) + fib(n - 2)
end
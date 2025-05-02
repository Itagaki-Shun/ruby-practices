#!/usr/bin/env ruby
for i in (1..20)
    case
    when i % 3 === 0 && i % 5 === 0
        puts "FizzBuzz"
    when i % 3 === 0
        puts "Fizz"
    when i % 5 === 0
        puts "Buzz"
    else
        puts i
    end
end
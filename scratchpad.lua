--1st class anonymous
sayHello = (function()
    return "Hello"
end)
print(sayHello())

sayHelloToPerson = (function(greeter, person, person2)
    return greeter()..", "..person.." & "..person2
end)

print(sayHelloToPerson(sayHello,"Jake","Justice"))


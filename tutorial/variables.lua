-- nil = absence of data, nothing at all. Does not mean 0 or false.
-- boolean = used to store whether something is true or false. ex: variable = false
-- number = used to store numbers, both integers (1,2,3) and floats (1.2,1.3,1.4). ex: variable = 12
-- string = used to store a string of characters. ex: variable = 'I have 3 apples'


--Declaring (creating variables)
--to declare a var simply type a var name and use "=" and the data the var should store ex: myvariable = 10, variable2 = true, stringvar = "string", nothing = nil
-- var names cant start with a number but may contain them ex: 1willnotwork = 10 vs willwork1 = 10
-- car names cant contain symbols, with the exception of "" ex: (dont do) #@%^@ = 10
-- variables are case sensative

salary = 1000
food = 300
rent = 400
investment = 600
result = salary - (food + rent + investment)

print(result)

--tables

OurAwesomeTable = {}
OurAwesomeTable.coolVariable = 10
OurAwesomeTable.coolTable = {}

--or 

OurAwesomeTable = {coolVariable = 10, coolTable = {} }


--relational values

-- == : equal to
-- ~= : not equal to
-- < : less than
-- > : great than 
-- <= : less or equal
-- >= : greater or equal

-- if statment
money = 150
if money > 100 then
    print(money)
end

-- if and statement
money = 150
if money > 100 and money < 200 then
    print(money)
end

--if or statement
money = 150
if money > 100 or money < 200 then
    print(money)
end

-- if elseif else statement
money = 150
if money > 100 and money < 200 then
    print(money)
elseif money <= 100 then
    print("I am poor :(")
else
    print("Yay I'm rich!")
end

-- functions

function checkWealth()
    if money > 100 and money < 200 then
        print(money)
    elseif money <= 100 then
        print("I am poor :(")
    else
        print("Yay I'm rich!")
    end
end

checkWealth()
money = 50

checkWealth()
money = 150

checkWealth()
money = 200


-- LOVES functions


function love.load()

end

--delta time
function love.update(dt) 

end


function love.draw()

end

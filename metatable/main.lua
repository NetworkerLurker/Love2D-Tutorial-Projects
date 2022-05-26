

Person = {} --regular table
Person.__index = Person --index self to make a meta table instead of doing below
--MetaPerson = {} --future meta table
--MetaPerson.__index = Person -- used to make future meta table a meta table

function Person.new(name)
    local instance = setmetatable({}, Person) --MetaPerson --meta table 2args(child table, metatable)
    instance.name = name -- name varaible
    return instance --when done you need to return the instance table
end

function Person:displayName()
    print(self.name)
end

person1 = Person.new("Bob") --check person table for info, if does not exist checks for a meta table and if meta table has an index, then it will look inside at what the index points to
person2 = Person.new("Fred") --goes into meta person -> metaPerson.__index -> Person = {} -> displayName()
person3 = Person.new("John")

person1:displayName()
person2:displayName()
person3:displayName()

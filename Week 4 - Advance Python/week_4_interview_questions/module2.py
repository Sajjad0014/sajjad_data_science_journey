import module1

# This means that complete code of module1 is here and will also be executed

print(__name__)
print(module1.__name__)

# This teaches us that when we just run __name__ it will print current module's __main__
# BUT when we import a file and run its __name__. Then it prints its name

user_input = int(input('Enter a number: '))
module1.square(user_input)

module1.main()
# This above code helps in running that module's function

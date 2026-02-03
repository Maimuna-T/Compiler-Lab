
class Parser:
    def __init__(self, input_string):
        self.input = input_string.replace(" ", "")
        self.pos = 0
        self.step = 2 

    def current_char(self):
        if self.pos < len(self.input):
            return self.input[self.pos]
        return None

    def match(self, ch):
        if self.current_char() == ch:
            print(f"{self.step} Match {ch}")
            self.step += 1
            self.pos += 1
        else:
            raise SyntaxError("Mismatch")

    def S(self):
        print(f"{self.step} S = aA")
        self.step += 1
        self.match('a')
        self.A()

    def A(self):
        if self.current_char() == 'b':
            print(f"{self.step} A = bA")
            self.step += 1
            self.match('b')
            self.A()
        else:
            print(f"{self.step} A = @")
            self.step += 1

    def parse(self):
        print(f"Parsing string : {original_input}")
        self.S()
        if self.current_char() == '$':
            print(f"{self.step} String Accepted")
        else:
            print("String Rejected")

original_input = input("Enter string to parse : ")

try:
    parser = Parser(original_input)
    parser.parse()
except SyntaxError:
    print("String Rejected")

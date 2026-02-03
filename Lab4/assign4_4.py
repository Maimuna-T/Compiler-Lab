parsing_table = {
    ('S', 'a'): ['a', 'A'],
    ('A', 'b'): ['b', 'A'],
    ('A', '$'): ['@']
}
stack = ['$', 'S']
s = input("String to parse : ").replace(" ", "")
input_buffer = list(s)
step = 1

print("Stack\tInput\tAction")

while True:
    stack_str = ''.join(stack)
    input_str = ''.join(input_buffer)
    top = stack[-1]
    cur = input_buffer[0]

    if top == '$' and cur == '$':
        print(f"{step} {stack_str}\t{input_str}\tMatch $")
        print(f"{step+1} String Accepted")
        break

    if top == cur:
        print(f"{step} {stack_str}\t{input_str}\tMatch {cur}")
        stack.pop()
        input_buffer.pop(0)
        step += 1

    elif (top, cur) in parsing_table:
        prod = parsing_table[(top, cur)]
        stack.pop()
        if prod != ['@']:
            for sym in reversed(prod):
                stack.append(sym)
        print(f"{step} {stack_str}\t{input_str}\t{top} -> {''.join(prod)}")
        step += 1

    else:
        print("String Rejected")
        break

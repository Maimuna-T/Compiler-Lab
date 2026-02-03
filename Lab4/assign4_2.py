
def is_non_terminal(ch):
    return ch.isupper()


def first(symbol):
  
    if symbol == '@':
        return {'@'}
    if not is_non_terminal(symbol):
        return {symbol}
    if FIRST[symbol]:
        return FIRST[symbol]

    result = set()
    for prod in grammar[symbol]:
        for sym in prod:
            sym_first = first(sym)
            result |= (sym_first - {'@'})
            if '@' not in sym_first:
                break
        else:
            result.add('@')

    FIRST[symbol] = result
    return result


def compute_follow():
    FOLLOW[start_symbol].add('$')

    changed = True
    while changed:
        changed = False
        for lhs in grammar:
            for prod in grammar[lhs]:
                for i, sym in enumerate(prod):
                    if is_non_terminal(sym):
                        before = FOLLOW[sym].copy()

                        if i + 1 < len(prod):
                            next_sym = prod[i + 1]
                            next_first = first(next_sym)
                            FOLLOW[sym] |= (next_first - {'@'})
                            if '@' in next_first:
                                FOLLOW[sym] |= FOLLOW[lhs]
                        else:
                            FOLLOW[sym] |= FOLLOW[lhs]

                        if before != FOLLOW[sym]:
                            changed = True

grammar = {}

n = int(input("Number of productions : "))
print("Enter productions :")

for _ in range(n):
    prod = input().replace(" ", "")
    lhs, rhs = prod.split("=")

    if lhs not in grammar:
        grammar[lhs] = []

    grammar[lhs].append(list(rhs))

start_symbol = list(grammar.keys())[0]

FIRST = {nt: set() for nt in grammar}
FOLLOW = {nt: set() for nt in grammar}

for nt in grammar:
    first(nt)

compute_follow()

for nt in grammar:
    print(f"FIRST ( {nt} ) = {{ {' '.join(FIRST[nt])} }}")

print()

for nt in grammar:
    print(f"FOLLOW ( {nt} ) = {{ {', '.join(FOLLOW[nt])} }}")

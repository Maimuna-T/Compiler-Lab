
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
            f = first(sym)
            result |= (f - {'@'})
            if '@' not in f:
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


def is_ll1():
    for nt in grammar:
        productions = grammar[nt]
        first_sets = []

        for prod in productions:
            fset = set()
            for sym in prod:
                f = first(sym)
                fset |= (f - {'@'})
                if '@' not in f:
                    break
            else:
                fset.add('@')

            first_sets.append(fset)

        for i in range(len(first_sets)):
            for j in range(i + 1, len(first_sets)):
                if (first_sets[i] & first_sets[j]) - {'@'}:
                    return False

        for i in range(len(first_sets)):
            if '@' in first_sets[i]:
                if (first_sets[i] - {'@'}) & FOLLOW[nt]:
                    return False

    return True
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
if is_ll1():
    print("Grammar is LL (1)")
else:
    print("Grammar is NOT LL (1)")

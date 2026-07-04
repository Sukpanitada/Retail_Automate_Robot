def simpleCipher(encrypted, k):
    result = []
    
    for char in encrypted:
        shifted = (ord(char) - ord('A') - k) % 26
        result.append(chr(shifted + ord('A')))
    return "".join(result)

print(simpleCipher('VTAOG', 2))  # TRYME
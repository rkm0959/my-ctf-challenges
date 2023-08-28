#!/usr/bin/sage
import random
import hashlib
import os
import signal 

signal.alarm(1800)

def PoW():
    prefix = os.urandom(8)
    print(prefix.hex())
    answer = bytes.fromhex(input().strip())
    assert len(answer) == 24
    result = hashlib.sha256(prefix + answer).digest()
    assert result[:3] == b"\x00\x00\x00"

P = PolynomialRing(ZZ, 'x')
x = P.gen()

def convolution(n, f, g):
    return (f * g) % (x ** n - 1)

def balance_mod(f, q):
    tt = f.coefficients(sparse = False)
    ret = 0
    for i in range(len(tt)):
        cc = int((tt[i] + q // 2) % q) - q // 2
        ret += cc * (x ** i)
    return ret

def random_poly(n, v1, v2):
    ret = v1 * [1] + v2 * [-1] + (n - v1 - v2) * [0]
    random.shuffle(ret)
    return P(ret)

def invert_prime(n, f, p):
    T = P.change_ring(GF(p)).quotient(x ** n - 1)
    ret = P(lift(1 / T(f)))
    return balance_mod(ret, 3)

def pad(n, arr):
    while len(arr) < n:
        arr.append(0)
    return arr

def encode(n, arr):
    res = 0
    for i in range(n):
        assert -1 <= arr[i] <= 1
        res += (arr[i] + 1) * (3 ** i)
    return res 

def task1(n, D):
    random.seed(int.from_bytes(os.urandom(32), "big"))
    f = random_poly(n, n // 3 + 1, n // 3)
    f3 = invert_prime(n, f, 3)

    random.seed(int.from_bytes(os.urandom(32), "big"))
    sel1 = random.sample(range(n), D)
    random.seed(int.from_bytes(os.urandom(32), "big"))
    sel2 = random.sample(range(n), D)

    coef_original = pad(n, f.coefficients(sparse = False))
    coef_inverse = pad(n, f3.coefficients(sparse = False))

    for i in range(D):
        coef_original[sel1[i]] = 0
        coef_inverse[sel2[i]] = 0
    
    print(sel1)
    print(sel2)
    print(encode(n, coef_original))
    print(encode(n, coef_inverse))

    assert int(input()) == encode(n, pad(n, f.coefficients(sparse = False)))
    assert int(input()) == encode(n, pad(n, f3.coefficients(sparse = False)))

def task2(n, D):
    random.seed(int.from_bytes(os.urandom(32), "big"))
    f = random_poly(n, n // 3 + 1, n // 3)
    f3 = invert_prime(n, f, 3)
    
    seed = int(input())
    random.seed(seed)

    sel1 = random.sample(range(n), D)
    sel2 = random.sample(range(n), D)

    coef_original = pad(n, f.coefficients(sparse = False))
    coef_inverse = pad(n, f3.coefficients(sparse = False))

    for i in range(D):
        coef_original[sel1[i]] = 0
        coef_inverse[sel2[i]] = 0
    
    print(sel1)
    print(sel2)
    print(encode(n, coef_original))
    print(encode(n, coef_inverse))

    assert int(input()) == encode(n, pad(n, f.coefficients(sparse = False)))
    assert int(input()) == encode(n, pad(n, f3.coefficients(sparse = False)))

PoW()
for _ in range(8):
    task1(2411, 83)
for _ in range(8):
    task2(8501, 2125)

flag = open("flag.txt", "r").read()
print(flag)
import random
from Crypto.Util.number import inverse, getPrime, bytes_to_long, GCD
from sympy.ntheory.modular import solve_congruence

FLAG = open('flag.txt', 'r').read()

def CRT(a, m, b, n):
	val, mod = solve_congruence((a, m), (b, n))
	return val

def gen_key():
	while True:
		p = getPrime(512)
		q = getPrime(512)
		if GCD(p-1, q-1) == 2:
			return p, q

def get_clue(p, q, BITS):
	while True:
		d_p = random.randint(1, 1 << BITS)
		d_q = random.randint(1, q - 1)
		if d_p % 2 == d_q % 2:
			d = CRT(d_p, p - 1, d_q, q - 1)
			e = inverse(d, (p - 1) * (q - 1))
			print("Clue : ", e)
			return

def get_flag(p, q):
	ans = int(input())
	if ans == p + q:
		print(FLAG)
	else:
		print("oops...")


# ask for PoW at the beginning
p, q = gen_key()
n = p * q
print("Public Modulus : ", n)
get_clue(p, q, 36)
get_flag(p, q)
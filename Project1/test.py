import numpy as np

length = 50
vector1 = np.random.randint(-32768//2, 32767//2, length)
vector2 = np.random.randint(-32768//2, 32767//2, length)

print(f"{','.join(map(str, vector1))}\n{','.join(map(str, vector2))}\n")

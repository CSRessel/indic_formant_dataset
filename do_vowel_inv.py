import glob

print("---------------- generating vowel inventory ----------------")
inv = {}
for dur in glob.glob("data/segments/all/*"):
    with open(dur, 'r') as durfile:
        for line in durfile.readlines():
            fields = line.split()
            phoneme = fields[1]
            # the notation of all vowels in indic begins with one of
            # of these characters, or the corresponding upper case
            vowels = ['a', 'e', 'i', 'o', 'u']
            vowels.extend([v.upper() for v in vowels])
            vowels.extend([str(i) for i in range(0,10)])
            if phoneme[0] in vowels:
                if phoneme not in inv:
                    inv[phoneme] = 0
                inv[phoneme] += 1

with open("log/vowel_inv.log", 'w') as outfile:
    for v in inv.keys():
        outfile.write(f'{v}\n')

import random

'''
使い方
./lines.txt の1行目に対象ファイルのfqnを書いて，2行目以降に対象にする行番号を書いていく
fqn.to.file
131
132
135
...
'''

lines = []
path = './lines.txt'
fqn = ''

with open(path) as f:
    fqn = f.readline().replace('\n','')
    for line in f:
        lines.append(int(line))

num = len(lines)
susps = list(range(1, num+1))
random.shuffle(susps)

with open ('specifications.csv', mode='w') as f:
    i = 1
    for (line, susp) in zip(lines, susps):
        if (i == num):
            s = fqn + ',' + str(line) + ',' + str(susp/num)
            f.write(s)
        else:
            s = fqn + ',' + str(line) + ',' + str(susp/num) + '\n'
            f.write(s)
        i += 1
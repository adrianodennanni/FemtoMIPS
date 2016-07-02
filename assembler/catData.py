#!/usr/bin/python
import sys

def strr(x):
    return str(round(x,4))

def auxf(lines,ind):
    return int(lines[ind])

stats = open('../femtomips/stats.txt')
allStats = open('allStats.csv','a')
lines = []
for line in stats:
    lines.append(line.split(':')[1][0:-1])
    print(line)

CICLOS_TOTAIS = auxf(lines,0)
BOLHAS = auxf(lines,1)
OPERACOES_ADD = auxf(lines,2)
OPERACOES_SLT = auxf(lines,3)
OPERACOES_JR = auxf(lines,4)
OPERACOES_ADDU = auxf(lines,5)
OPERACOES_SLL = auxf(lines,6)
OPERACOES_LW = auxf(lines,7)
OPERACOES_SW = auxf(lines,8)
OPERACOES_ADDI = auxf(lines,9)
OPERACOES_BEQ = auxf(lines,10)
OPERACOES_BNE = auxf(lines,11)
OPERACOES_SLTI = auxf(lines,12)
OPERACOES_J = auxf(lines,13)
OPERACOES_JAL = auxf(lines,14)
BRANCHES_TOMADOS = auxf(lines,15)
TOTAL_DE_BRANCHES = auxf(lines,16)
ACESSOS_AO_CACHE_I = auxf(lines,17)
MISSES_DO_CACHE_I = auxf(lines,18)
MISSES_DO_CACHE_D = auxf(lines,19)
ACESSOS_AO_CACHE_D = auxf(lines,20)
ACESSOS_A_MEMORIA_PRINCIPAL = auxf(lines,21)

sz = int(sys.argv[1])
szs  = str(sz)
res = ''

res += szs + ',' + str(CICLOS_TOTAIS) + ',' + str(BOLHAS)
res += ',' + szs + ',' + strr(CICLOS_TOTAIS/(CICLOS_TOTAIS - BOLHAS))
res += ',' + szs
for i in range(2,15):
    res += ',' + strr(100 * int(lines[i]) / (CICLOS_TOTAIS - BOLHAS))
res += ',' + szs + ',' + strr(BRANCHES_TOMADOS / TOTAL_DE_BRANCHES)
res += ',' + szs + ',' + strr(1 - MISSES_DO_CACHE_I / ACESSOS_AO_CACHE_I)
res += ',' + szs + ',' + strr(1 - MISSES_DO_CACHE_D / ACESSOS_AO_CACHE_D)
res += ',' + szs
res += ',' + str(ACESSOS_A_MEMORIA_PRINCIPAL)
res += ',' + str(ACESSOS_AO_CACHE_I)
res += ',' + str(ACESSOS_AO_CACHE_D)
res += '\n'
allStats.write(res)
print(res)

#!/usr/bin/python

import sys
import random

def main():
    choice = int(sys.argv[1])

    pc = 0

    if choice == 0:

        # 00000000000000000000000000000000
        inst = "11001100000000000000000000000000"
        emit(inst,pc,"INVALIDA")
        pc += 4

        pc = 0x70

        # 00000000000000000000000001110000
        inst = "11111111111111111111111111111111"
        emit(inst,pc,"fim da execucao")
        pc += 4

    pass

def stringBin(nm, ln):
    ret = ""
    if nm < 0:
        nm = 2**ln + nm
    for i in range(ln):
        ret = str(nm % 2) + ret
        nm = nm // 2
    return ret

def emit(inst,pc,obs):
    print(stringBin(pc,32)+"|"+inst+"|"+obs+"|"+hexS(inst))

def hexS(inst):
    lt = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
    ret = ''
    while inst != '':
        part = inst[0:4]
        inst = inst[4:]
        num = 0
        if part[0] == '1':
            num += 8
        if part[1] == '1':
            num += 4
        if part[2] == '1':
            num += 2
        if part[3] == '1':
            num += 1
        ret += lt[num]
    return ret

main()

import csv

with open('factor_gpinput.gp', 'w') as gp:
    N = []
    with open('factorme.txt') as csvfile:
        readCSV = csv.reader(csvfile,delimiter=',')
        for row in readCSV:
            N.append(int(row[0][4:]))
    gp.write('N = {};\n'.format(N))

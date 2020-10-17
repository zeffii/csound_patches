
multiline_str = """\
00 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
01 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
02 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
03 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
04 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
05 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
06 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
07 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
08 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
09 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
10 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
11 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
12 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
13 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
14 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
15 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
"""



def splitter(long_string):
    # newlines = long_string.split('\n')
    # newlines = newlines[:-1]
    # print(newlines)

    iFirstNewLine = long_string.find("\n")
    iSizeNewArray = int(len(long_string) / (iFirstNewLine + 1))
    S_new_array = []
    print(len(long_string))

    for i in range(iSizeNewArray):
        substart = i*(iFirstNewLine+1)
        subend = substart + iFirstNewLine
        print(i, substart, subend)

        S_new_array.append(long_string[int(substart): int(subend)])

    print(S_new_array)



splitter(multiline_str)
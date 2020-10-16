<CsoundSynthesizer>
<CsOptions>
-m0  ; -odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

gS_pattern_001 = {{
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
}}

;opcode split_line, S[], s

;endop

opcode multiline_split, S[], S
    ;   
    ;   multiline_split  
    ;   :   accept -  single multiple string
    ;   :   return -  an array of strings
    ;
    ;   :   this function will test if the first character in the string is a newline
    ;   :   and remove it before doing the main text split 
    ;
    ;   :   
    ;
    S_multiline_str xin

    ipos strindex S_multiline_str, "\n"
    if ipos == 0 then
        ; prints "removing first newline if pos 0"
        S_multiline_str strsub S_multiline_str, 1
    endif

    ipos strindex S_multiline_str, "\n"
    ; prints "new ipos %d", ipos
    

    S_new_array[] fillarray "AAAAAA . . ... ... ", "AAAABB . . ... ... "

    xout S_new_array

endop

instr string_tester

    S_rows[] multiline_split gS_pattern_001
    prints S_rows[0]

    Sdst strsub S_rows[0], 0, 1
    prints Sdst

endin


</CsInstruments>
<CsScore>

i "string_tester" 0 1

</CsScore>
</CsoundSynthesizer>


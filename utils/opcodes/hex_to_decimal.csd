<CsoundSynthesizer>
<CsOptions>
;-m0  ; -odac  ; -nm0
-odac 
-d  ; no messages
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

opcode char_to_num, i, S
    S_in xin

    S_chars[] fillarray "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
    i_num_items lenarray S_chars

    i_counter = 0
    until strcmp(S_in, S_chars[i_counter]) == 0 do 
        i_counter += 1
    od 

    xout i_counter

endop


opcode hex_to_decimal, i, S

    S_input xin
    i_num_chars strlen S_input
    i_running_sum = 0

    i_counter = 0
    while i_counter < i_num_chars do
        S_char strsub S_input, i_counter, i_counter+1
        i_power = i_num_chars - i_counter - 1
        
        if i_power == 0 then
            i_running_sum += char_to_num(S_char)
        elseif i_power = 1 then
            i_running_sum += char_to_num(S_char) * 16
        else
            i_running_sum += char_to_num(S_char) * (16 ^ i_power)
        endif

        i_counter += 1
    od

    xout i_running_sum

endop


instr test_hex

    prints "FAAB -> %d\n", hex_to_decimal("FAAB")

endin




</CsInstruments>
<CsScore>

i "test_hex" 0 1

</CsScore>
</CsoundSynthesizer>


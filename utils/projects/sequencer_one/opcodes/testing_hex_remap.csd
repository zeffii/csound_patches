<CsoundSynthesizer>
<CsOptions>
-m0  ; -odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

#include "hex_to_decimal.csd"

opcode convert_hex_range, i, SSiiS
    ; low2 + (value - low1) * (high2 - low2) / (high1 - low1)

    S_max, S_min, i_max, i_min, S_val_to_convert xin
    i_value hex_to_decimal S_val_to_convert
    i_hex_max hex_to_decimal S_max
    i_hex_min hex_to_decimal S_min
    i_outval = i_min + (i_value - i_hex_min) * (i_max - i_min) / (i_hex_max - i_hex_min)

    xout i_outval

endop

opcode get_hex, i, iSSiiS
    ;   ival get_hex 2, 4000, 100, "FF", "00", "3F"
    iLen, Smax, Smin, imax, imin, S_input_hex xin
    iOutput init -90000

    if iLen == 2 then
        S_dots_hex = ".."
    elseif iLen == 4 then 
        S_dots_hex = "...."
    endif 

    if strcmp(S_dots_hex, S_input_hex) != 0 then
        iOutput = convert_hex_range(Smax, Smin, imax, imin, S_input_hex)
    endif 

    xout iOutput
endop



instr 1
    print convert_hex_range("FF", "00", 12000.0, 800.0, "00")
    print convert_hex_range("FF", "00", 12000.0, 800.0, "22")
    print convert_hex_range("FF", "00", 12000.0, 800.0, "60")
    print convert_hex_range("FF", "00", 12000.0, 800.0, "80")
    print convert_hex_range("FF", "00", 12000.0, 800.0, "FF")
    prints "----"
    print get_hex(2, "FF", "00", 12000.0, 800.0, "00")
    print get_hex(2, "FF", "00", 12000.0, 800.0, "22")
    print get_hex(2, "FF", "00", 12000.0, 800.0, "60")
    print get_hex(2, "FF", "00", 12000.0, 800.0, "80")
    print get_hex(2, "FF", "00", 12000.0, 800.0, "FF")
    print get_hex(2, "FF", "00", 12000.0, 800.0, "..")

    ival = get_hex(2, "FF", "00", 12000.0, 800.0, "..")
    if ival == -90000 then
        prints "yes can be tested"

    endif

endin

</CsInstruments>
<CsScore>

i 1 0 2

</CsScore>
</CsoundSynthesizer>



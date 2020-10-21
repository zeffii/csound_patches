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
; here starts

instr 1
    print convert_hex_range("FF", "00", 1.0, 0.0, "FF")

endin

</CsInstruments>
<CsScore>

i 1 0 2

</CsScore>
</CsoundSynthesizer>



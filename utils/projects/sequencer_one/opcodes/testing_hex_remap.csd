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

    S_max, S_min, i_max, i_min, S_val_to_convert xin
    
    i_outval = 0.2
    xout i_outval

endop
; here starts

instr 1
    print convert_hex_range("FF", "00", 1.0, 0.0, "80")

endin

</CsInstruments>
<CsScore>

i 1 0 2

</CsScore>
</CsoundSynthesizer>



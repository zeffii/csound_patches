<CsoundSynthesizer>
<CsOptions>
-m0  ; -odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

#include "instrument_clave.csd"

</CsInstruments>
<CsScore>

i "CLAVE" 0 1 .4 54
i "CLAVE" 3 2 .4 65

</CsScore>
</CsoundSynthesizer>


; example_05A07_expon_pings.csd

<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>

<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1; expon envelope
    iEndVal = p4
    aEnv expon 1, p3, iEndVal
    aPEnv expon 330, .2, 20
    aSig poscil aEnv, aPEnv
    out aSig, aSig
endin

</CsInstruments>
<CsScore>
;p1 p2 p3 p4
i 1 0 1.3 0.001
e
</CsScore>
</CsoundSynthesizer>

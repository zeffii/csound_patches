; perc_hat_001.csd

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



instr 1

    aEnv expon 1, p4, .001
    kbeta line -0.9999, p3, 0.9999  ;change beta value between -1 to 1
    asig  noise .3, kbeta
    asig  clip asig, 2, .9  ;clip signal
    asig *= aEnv
          outs asig, asig

endin

</CsInstruments>
<CsScore>
i 1 0 1 0.3
e
</CsScore>
</CsoundSynthesizer>

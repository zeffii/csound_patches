; example_using_metro.csd
<CsoundSynthesizer>
<CsOptions>
-odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

giTanh          ftgen 2,0,257,"tanh",-10,10,0

instr CHHAT   ; p4  = duration

    iAmp random 1.0, 1.5
    aEnv expon 1, p4, 0.001
    aSig noise aEnv, 0
    aSig buthp aSig*0.3*iAmp, 12000
    aSig buthp aSig, 2000
    aSig distort aSig*0.8, .326, giTanh
    aSig *= .5
    outs aSig, aSig

endin

instr Sequencer
    ktrig metro 8

    k_counter init 0
    if ktrig == 1 then
        
        if k_counter % 4 == 0 then
            event "i", "CHHAT", 0, 1.2, 0.05
        endif

        k_counter += 1

    endif

endin

</CsInstruments>
<CsScore>

i "Sequencer" 0 10

</CsScore>
</CsoundSynthesizer>


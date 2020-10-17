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

    if p4 == 1 then
        iduration = .07
    elseif p4 == 2 then
        iduration = .10
    elseif p4 == 3 then
        iduration = .19
    else
        iduration = .9
    endif

    iAmp random 1.0, 1.5
    aEnv expon 1, iduration, 0.001
    aSig noise aEnv, 0
    aSig buthp aSig*0.3*iAmp, 12000
    aSig buthp aSig, 2000
    aSig distort aSig*0.8, .326, giTanh
    aSig *= .5
    outs aSig, aSig

endin

instr Sequencer
    k_event_delay init 0
    k_shuffle_max = 0.020

    itriggers[] fillarray 1, 2, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 3, 2, 3
    ktrig metro 9.7

    k_counter init 0
    k_trig_value init 0
    if ktrig == 1 then
        
        k_event_delay = (k_counter % 2 == 0 ? 0 : k_shuffle_max)

        if itriggers[k_counter] > 0 then
            event "i", "CHHAT", k_event_delay, 1.2, itriggers[k_counter]
        endif

        k_counter += 1

        /*  reset the counter to keep the numbers lower */
        if k_counter > 15 then
            k_counter = 0
        endif

    endif

endin

</CsInstruments>
<CsScore>

i "Sequencer" 0 10

</CsScore>
</CsoundSynthesizer>


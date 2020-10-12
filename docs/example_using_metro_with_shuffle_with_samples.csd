
<CsoundSynthesizer>
<CsOptions>
-odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

gSKickPath = ".\\samples\\kick_able_boom_001.wav"
;varname        ifn  itime  isize igen  Sfilnam     iskip iformat ichn
giKick  ftgen   0,   0,     0,    1,    gSKickPath, 0,    0,      0

giTanh  ftgen   2, 0, 257, "tanh", -10, 10, 0


instr KICK_WAV

    i_offset = 0.0
    i_sample_len filelen gSKickPath ;play whole length of the sound file

    aEnv expon 1, 0.7, 0.001
    aSig poscil3 .5, 1/i_sample_len, giKick, i_offset
    ; aSig distort aSig*0.8, .326, giTanh
    aSig *= aEnv
    outs aSig, aSig

endin


instr CHHAT   ; p4  = duration

    if p4 == 1 then
        iduration = .05
    elseif p4 == 2 then
        iduration = .09
    elseif p4 == 3 then
        iduration = .33
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
    
    ktrig metro 9.7

    k_event_delay init 0
    k_shuffle_max = 0.020

    itriggers[] fillarray 1, 2, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 3, 2, 3
    itrigkick[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0 ,0, 0

    k_counter init 0
    k_trig_value init 0
    if ktrig == 1 then
        
        k_event_delay = (k_counter % 2 == 0 ? 0 : k_shuffle_max)

        if itriggers[k_counter] > 0 then
            event "i", "CHHAT", k_event_delay, 1.2, itriggers[k_counter]
        endif

        if itrigkick[k_counter] > 0 then
            event "i", "KICK_WAV", k_event_delay, 1.0
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


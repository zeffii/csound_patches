; example_05E04_schroeder_reverb.csd

<CsoundSynthesizer>
<CsOptions>
-odac -m128
; activate real time sound output and suppress note printing
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
giSine ftgen 0, 0, 2^12, 10, 1 ; a sine wave
gaRvbSend init 0 ; global audio variable initialized
giRvbSendAmt init 0.4 ; reverb send amount (range 0 - 1)

instr KICK 
    iamp random 0.5, 0.5 ; amplitude randomly chosen
    p3 = 0.3 ; define duration for this sound
    aenv line 1,p3,0.001 ; amplitude envelope (percussive)
    kcps expon 280,p3,20 ; pitch glissando
    aSig oscil aenv*0.8*iamp,kcps,giSine ; oscillator
    outs aSig, aSig ; send audio to outputs
    gaRvbSend = gaRvbSend + (aSig * giRvbSendAmt) ; add to send
endin

instr SNARE 
    iAmp random 0.4, 0.5 ; amplitude randomly chosen
    p3 = 0.3 ; define duration
    aEnv expon 1, p3, 0.001 ; amp. envelope (percussive)
    aNse noise 1, 0 ; create noise component
    iCps exprand 20 ; cps offset
    kCps expon 250 + iCps, p3, 200+iCps; create tone component gliss
    aJit randomi 0.2, 1.8, 10000 ; jitter on freq.
    aTne oscil aEnv, kCps*aJit, giSine ; create tone component
    aSig sum aNse*0.1, aTne ; mix noise and tone components
    aRes comb aSig, 0.02, 0.0035 ; comb creates a 'ring'
    aSig = aRes * aEnv * iAmp ; apply env. and amp. factor
    outs aSig, aSig ; send audio to outputs
    gaRvbSend = gaRvbSend + (aSig * giRvbSendAmt); add to send
endin

instr CHHAT
    iAmp random 1.0, 1.5 ; amplitude randomly chosen
    p3 = 0.3 ; define duration for this sound
    aEnv expon 1,p3,0.001 ; amplitude envelope (percussive)
    aSig noise aEnv, 0 ; create sound for closed hi-hat
    aSig buthp aSig*0.5*iAmp, 12000 ; highpass filter sound
    aSig buthp aSig, 12000 ; -and again to sharpen cutoff
    outs aSig, aSig ; send audio to outputs
    gaRvbSend = gaRvbSend + (aSig * giRvbSendAmt) ; add to send
endin


instr 1 ; trigger drum hits 

    k_cycle_tracker init 0
    k_caret init 0
    ;.....................|           |           |           |           |
    itriggers1[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0
    itriggers2[] fillarray 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    itriggers3[] fillarray 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0

    if ((k_cycle_tracker % (ksmps*5)) == 0) then

        if itriggers1[k_caret] == 1 then
            event "i", "KICK", 0, .4
        endif

        if itriggers2[k_caret] == 1 then
            event "i", "CHHAT", 0, .4
        endif

        if itriggers3[k_caret] == 1 then
            event "i", "SNARE", 0, .4
        endif

        k_caret += 1
        if k_caret >= 16 then
            k_caret = 0
        endif

    endif

    k_cycle_tracker += 1
endin


instr 5 ; schroeder reverb - always on
    ; read in variables from the score
    kRvt = p4
    kMix = p5
    ; print some information about current settings gleaned from the score
    prints "Type:"
    prints p6
    prints "\\nReverb Time:%2.1f\\nDry/Wet Mix:%2.1f\\n\\n",p4,p5
    ; four parallel comb filters
    a1 comb gaRvbSend, kRvt, 0.0297; comb filter 1
    a2 comb gaRvbSend, kRvt, 0.0371; comb filter 2
    a3 comb gaRvbSend, kRvt, 0.0411; comb filter 3
    a4 comb gaRvbSend, kRvt, 0.0437; comb filter 4
    asum sum a1,a2,a3,a4 ; sum (mix) the outputs of all comb filters
    ; two allpass filters in series
    a5 alpass asum, 0.1, 0.005 ; send mix through first allpass filter
    aOut alpass a5, 0.1, 0.02291 ; send 1st allpass through 2nd allpass
    amix ntrpol gaRvbSend, aOut, kMix ; create a dry/wet mix
    outs amix, amix ; send audio to outputs
    clear gaRvbSend ; clear global audio variable
endin

</CsInstruments>
<CsScore>
; room reverb
i 1 0 10 ; start drum machine trigger instr
i 5 0 11 1 0.2 "Room Reverb" ; start reverb

e
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy
; modified by zeffii to make it a drum sequence trigger

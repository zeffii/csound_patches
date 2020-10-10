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
    kcps expon 220,p3,20 ; pitch glissando
    aSig oscil aenv*0.8*iamp, kcps, giSine ; oscillator
    outs aSig, aSig ; send audio to outputs
    gaRvbSend = gaRvbSend + (aSig * giRvbSendAmt) ; add to send
endin

instr CHHAT   ; p4  = duration
    iAmp random 1.0, 1.5 ; amplitude randomly chosen
    aEnv expon 1, p4, 0.001 ; amplitude envelope (percussive)
    aSig noise aEnv, 0 ; create sound for closed hi-hat
    aSig buthp aSig*0.5*iAmp, 12000 ; highpass filter sound
    aSig buthp aSig, 12000 ; -and again to sharpen cutoff
    aSig *= 1.2
    outs aSig, aSig ; send audio to outputs
    gaRvbSend = gaRvbSend + (aSig * giRvbSendAmt) ; add to send
endin

opcode clap_segment, a, ii;  duration, delay
    iduration, idelay xin
    iAmp random 1.0, 1.2 ; amplitude randomly chosen
    aNse noise 1, 0 ; create noise component
    aEnv expon 1, iduration, 0.001 ; amp. envelope (percussive)
    aSig = aNse * aEnv * iAmp ; apply env. and amp. factor
    if idelay > 0.0 then
        aSig delay aSig, idelay
    endif
    xout aSig
endop


instr CLAP
    if p4 == 1 then
        aSig1 clap_segment .17, 0
        aSig2 clap_segment .03, 0.02
        aSig3 clap_segment .034, 0.04
        aSig4 clap_segment .03, 0.05
        aSig5 clap_segment .16, 0.0601
        aSig sum aSig1, aSig2, aSig3, aSig4, aSig5
        aSig buthp aSig, 20
        aSig *= .4
    elseif p4 == 2 then
        prints "should happen"
        Sfile = "Clap.wav"
        ifilchnls filenchnls Sfile
        if ifilchnls == 1 then ;mono
            aSig soundin Sfile
        else ;stereo
            aSig, aSig2 soundin Sfile
        endif
        aSig *= .4

    endif
    
    outs aSig, aSig ; send audio to outputs
    gaRvbSend = gaRvbSend + (aSig * giRvbSendAmt); add to send
endin

instr 1 ; trigger drum hits 

    k_shuffle_amt init 0.0
    k_cycle_tracker init 0
    k_caret init 0
    ;.....................|           |           |           |           |
    itriggers1[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0
    itriggers2[] fillarray 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1
    itriggers3[] fillarray 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2

    if ((k_cycle_tracker % (ksmps*5)) == 0) then

        k_shuffle_amt = (k_caret % 2 == 0 ? 0 : 0.02)
        k_kick_trigger = itriggers1[k_caret]
        k_hats_trigger = itriggers2[k_caret]
        k_clap_trigger = itriggers3[k_caret]

        if k_kick_trigger == 1 then
            event "i", "KICK", k_shuffle_amt, .4
        endif


        if k_hats_trigger == 1 then
            event "i", "CHHAT", k_shuffle_amt, .4, 0.1
        elseif k_hats_trigger == 2 then
            event "i", "CHHAT", k_shuffle_amt, .4, 0.4
        endif


        if k_clap_trigger != 0 then
            event "i", "CLAP", k_shuffle_amt, .4, k_clap_trigger
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
i 5 0 11 1 0.12 "Room Reverb" ; start reverb

e
</CsScore>
</CsoundSynthesizer>
; example by Iain McCurdy (original)
; modified by zeffii to make it a drum sequence trigger
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>

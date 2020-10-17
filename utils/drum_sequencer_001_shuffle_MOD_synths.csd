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

giSine          ftgen 0, 0, 2^12, 10, 1 ; a sine wave
gaRvbSend       init 0 ; global audio variable initialized
giRvbSendAmt    init 0.4 ; reverb send amount (range 0 - 1)
giTanh          ftgen 2,0,257,"tanh",-10,10,0

opcode update_caret, k, kk
    k_caret, k_mod xin

    k_caret += 1
    if k_caret >= k_mod then
        k_caret = 0
    endif

    xout k_caret
endop


instr KICK 

    aenv line 0.6, 0.7, 0.01 ; amplitude envelope (percussive)
    kcps expon 180, .7, 5 ; pitch glissando
    aSig oscil aenv, kcps, giSine ; oscillator
    aSig buthp aSig, 40
    aSig buthp aSig, 50    
    aSig buthp aSig, 150    
    aSig *= 1.2
    outs aSig, aSig

endin

instr CHHAT   ; p4  = duration

    iAmp random 1.0, 1.5 ; amplitude randomly chosen
    aEnv expon 1, p4, 0.001 ; amplitude envelope (percussive)
    aSig noise aEnv, 0 ; create sound for closed hi-hat
    aSig buthp aSig*0.5*iAmp, 12000 ; highpass filter sound
    aSig buthp aSig, 12000 ; -and again to sharpen cutoff
    aSig distort aSig*0.8, .326, giTanh
    aSig *= .5
    outs aSig, aSig

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

        ;                  duration            trigger time
        aSig1 clap_segment .17,                0
        aSig2 clap_segment random:i(.025,.03), 0.02
        aSig3 clap_segment .034,               0.04
        aSig4 clap_segment .03,                0.05
        aSig5 clap_segment random:i(.4, .16),  random:i(0.0601, 0.053)
        aSig sum aSig1, aSig2, aSig3, aSig4, aSig5
        aSig buthp aSig, 20
        aSig *= .4

    elseif p4 == 2 then

        ; this loads directly from disk, each time ( i think ? ) 
        ; it's possible to load from disk once at the top and store as a table (TODO)
        Sfile = "Clap.wav"
        ifilchnls filenchnls Sfile
        if ifilchnls == 1 then ;mono
            aSig soundin Sfile
        else ;stereo
            aSig, aSig2 soundin Sfile
        endif
        aSig *= .3

    endif
    
    outs aSig, aSig ; send audio to outputs
endin

instr DRUM_MACHINE ; trigger drum hits 

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
            event "i", "CHHAT", k_shuffle_amt, .4, 0.07
        elseif k_hats_trigger == 2 then
            event "i", "CHHAT", k_shuffle_amt, .4, 0.3
        endif


        if k_clap_trigger != 0 then
            event "i", "CLAP", k_shuffle_amt, .4, k_clap_trigger
        endif

        k_caret update_caret k_caret, 16

    endif

    k_cycle_tracker += 1
endin


opcode pad_voice, a, ii
    i_note, i_duration xin

    icps    mtof i_note-12
    iwave   init 1  ; sawtooth
    kpw     init 0.5
    ifn     init 1
    
    aEnv    expon 1, i_duration, 0.001 ; amplitude envelope (percussive)
    aSig    vco aEnv, icps, iwave, kpw, ifn
    aSig *= .8

    xout aSig
endop

instr PAD
    i_notearray_index = p4
    i_duration = p5
    i_FilterFreq = p6
    i_FilterRes = p7

    aSig init 0

    if i_notearray_index == 1 then
        i_notes[] fillarray 60, 63, 65, 68
    elseif i_notearray_index == 2 then
        i_notes[] fillarray 60, 64, 65, 69
    endif

    i_num_notes = lenarray(i_notes)

    ; HARD CODING 6 NOTE POLYPHONY

    if 0 < i_num_notes then
        aNewVoice   pad_voice i_notes[0], i_duration
        aSig += aNewVoice
    endif

    if 1 < i_num_notes then
        aNewVoice   pad_voice i_notes[1], i_duration
        aSig += aNewVoice
    endif

    if 2 < i_num_notes then
        aNewVoice   pad_voice i_notes[2], i_duration
        aSig += aNewVoice
    endif

    if 3 < i_num_notes then
        aNewVoice   pad_voice i_notes[3], i_duration
        aSig += aNewVoice
    endif

    if 4 < i_num_notes then
        aNewVoice   pad_voice i_notes[4], i_duration
        aSig += aNewVoice
    endif

    if 5 < i_num_notes then
        aNewVoice   pad_voice i_notes[5], i_duration
        aSig += aNewVoice
    endif


    aSig /= i_num_notes
    ; aSig buthp aSig, i_FilterFreq
    aSig moogladder aSig, i_FilterFreq, i_FilterRes

    ; aPan     lfo       0.5, 1, 1      ; panning controlled by an lfo
    ; aPanL   =  sin((aPan + 0.5) * $M_PI_2)
    ; aPanR   =  cos((aPan + 0.5) * $M_PI_2)
    outs aSig, aSig ; send audio to outputs
endin

instr SYNTH_SEQUENCER

    k_shuffle_amt init 0.0
    k_cycle_tracker init 0
    k_caret init 0
    ;.....................|           |           |           |           |
    itriggers1[] fillarray 1, 0, 0, 1, 0, 0, 1, 0, 0, 2, 0, 0, 1, 0, 1, 2

    if ((k_cycle_tracker % (ksmps*5)) == 0) then

        k_shuffle_amt = (k_caret % 2 == 0 ? 0 : 0.02)
        k_pad_trigger = itriggers1[k_caret]

        if k_pad_trigger > 0 then
            ;                                     notes          duration   filterHz                    Res
            event "i", "PAD", k_shuffle_amt, 1.6, k_pad_trigger, 1.5,       200 + random:k(1500, 800),  .8
        endif

        k_caret update_caret k_caret, 16
    endif

    k_cycle_tracker += 1
endin



</CsInstruments>
<CsScore>
f 1 0 65536 10 1
i "DRUM_MACHINE" 0 10
i "SYNTH_SEQUENCER" 0 10

e
</CsScore>
</CsoundSynthesizer>
; example by Iain McCurdy (original)
; modified by zeffii to make it a drum sequence trigger

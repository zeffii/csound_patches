
<CsoundSynthesizer>
<CsOptions>
-odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

#include ".\\opcodes\\opcode_string_multiline_split.csd"

giTanh  ftgen   2, 0, 257, "tanh", -10, 10, 0

gSKickPath = ".\\samples\\kick_able_boom_001.wav"
gSHat     = ".\\samples\\HHODA.WAV"
gSClap_p1 = ".\\samples\\clap_p1.wav"
gSClap_p2 = ".\\samples\\clap_p2.wav"
gSClap_p3 = ".\\samples\\clap_p3.wav"
gSClap_p4 = ".\\samples\\clap_p4.wav"
gSClap_p5 = ".\\samples\\clap_p5.wav"

;varname        ifn  itime  isize igen  Sfilnam     iskip iformat ichn
giKick   ftgen  0,   0,     0,    1,    gSKickPath, 0,    0,      0
giHat    ftgen  0,   0,     0,    1,    gSHat,      0,    0,      0
giCl_p1  ftgen  0,   0,     0,    1,    gSClap_p1,  0,    0,      0
giCl_p2  ftgen  0,   0,     0,    1,    gSClap_p2,  0,    0,      0
giCl_p3  ftgen  0,   0,     0,    1,    gSClap_p3,  0,    0,      0
giCl_p4  ftgen  0,   0,     0,    1,    gSClap_p4,  0,    0,      0
giCl_p5  ftgen  0,   0,     0,    1,    gSClap_p5,  0,    0,      0

gS_pattern_001 = {{
00 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
01 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
02 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
03 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
04 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
05 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
06 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
07 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
08 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
09 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
10 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
11 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
12 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
13 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
14 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
15 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
}}

instr KICK_WAV

    i_offset = 0.0001
    i_sample_len filelen gSKickPath ;play whole length of the sound file
    kcf = 200
    aEnv expon 1, 0.4, 0.001
    aSig poscil3 .7, (1/i_sample_len)*0.99, giKick, i_offset
    aSig distort aSig*0.8, .326, giTanh
    aSig moogladder aSig, kcf, 0.4 ; filter audio signa
    aSig *= 1.6
    aSig *= aEnv
    outs aSig, aSig

endin


opcode clap_segment, a, iii;  duration, delay

    iduration, idelay, isegment xin
    ; iAmp random 1.0, 1.2 ; amplitude randomly chosen
    ; aNse noise 1, 0 ; create noise component
    ; aEnv expon 1, iduration, 0.001 ; amp. envelope (percussive)
    ; aSig = aNse * aEnv * iAmp ; apply env. and amp. factor

    aSig init 0
    aEnv expon 1, iduration, 0.001
    iAmp = .4

    if isegment == 1 then
        i_sample_len filelen gSClap_p1
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p1
    elseif isegment == 2 then
        i_sample_len filelen gSClap_p2
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p2
    elseif isegment == 3 then
        i_sample_len filelen gSClap_p3
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p3
    elseif isegment == 4 then
        i_sample_len filelen gSClap_p4
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p4
    elseif isegment == 5 then
        i_sample_len filelen gSClap_p5
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p5
    endif

    aSig *= aEnv

    if idelay > 0.0 then
        aSig delay aSig, idelay
    endif
    xout aSig
endop


instr CLAP

    ;                  duration            trigger time              segment
    aSig1 clap_segment .18,                0,                        1
    aSig2 clap_segment random:i(.025,.03), 0.02,                     2
    aSig3 clap_segment .14,                0.04,                     3
    aSig4 clap_segment .24,                0.05,                     4
    aSig5 clap_segment random:i(.9, .46),  random:i(0.0601, 0.053),  5
    aSig sum aSig1, aSig2, aSig3, aSig4, aSig5
    aSig buthp aSig, random:i(620, 400)
    aSig *= .4

    outs aSig, aSig ; send audio to output

endin


instr CHHAT   ; p4  = duration

    iamp = 0.7
    if p4 == 1 then
        iduration = .05
        iamp = random:i(0, 0.3)
    elseif p4 == 2 then
        iduration = .09
    elseif p4 == 3 then
        iduration = .33
    else
        iduration = .9
    endif

    ; iAmp random 1.0, 1.5
    ; aEnv expon 1, iduration, 0.001
    ; aSig noise aEnv, 0
    ; aSig buthp aSig*0.3*iAmp, 12000
    ; aSig buthp aSig, 2000
    ; aSig distort aSig*0.8, .326, giTanh

    i_sample_len filelen gSHat ;play whole length of the sound file

    aEnv expon 1, iduration, 0.001
    aSig poscil3 iamp, 1/i_sample_len, giHat
    aSig *= (aEnv * .7)
    outs aSig, aSig

endin

instr Sequencer
    
    ktrig metro 9.7

    k_counter init 0
    k2_counter init 0
    k_event_delay init 0
    k_shuffle_max = 0.017

    itriggers[] fillarray 1, 0, 3, 0, 1, 0, 3, 0, 1, 2, 3, 0, 1, 0, 3, 0
    itrigkick[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0 ,0, 0

    S_rows[] multiline_split gS_pattern_001
    prints S_rows[15]

    if ktrig == 1 then
        
        k_event_delay = (k_counter % 2 == 0 ? 0 : k_shuffle_max)

        if itriggers[k_counter] > 0 then
            event "i", "CHHAT", k_event_delay, 1.2, itriggers[k_counter]
        endif

        if itrigkick[k_counter] > 0 then
            event "i", "KICK_WAV", k_event_delay, 1.9
        endif

        if k2_counter % 8 == 4 then
            event "i", "CLAP", k_event_delay, .40
        endif

        k_counter += 1
        k2_counter +=1

        /*  reset the counter to keep the numbers lower */
        if k_counter > 15 then
            k_counter = 0
        endif

        if k2_counter > 31 then
            k2_counter = 0
        endif

    endif

endin

; #include "MyOpcodes.opcodes"

</CsInstruments>
<CsScore>

i "Sequencer" 0 10

</CsScore>
</CsoundSynthesizer>


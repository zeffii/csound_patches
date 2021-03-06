<CsoundSynthesizer>
<CsOptions>
-odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

#include "instrument_kick.csd"
#include "instrument_hhat.csd"
#include "instrument_clap.csd"
#include "instrument_clave.csd"

#include ".\\opcodes\\opcode_msynth1_parser.csd"
; #include ".\\opcodes\\opcode_update_param_state.csd"




gS_pattern_001 = {{
00  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  00 20 A0 20 10  80 30 E0
01  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
02  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
03  C-4 50 D#4 50 G-4 50 ... .. ... .. ... ..  00 10 80 02 ..  A0 30 ..
04  ... .. ... .. ... .. C-2 A0 ... .. ... ..  00 10 80 02 40  A0 30 ..
05  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
06  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  00 10 80 02 ..  20 A0 ..
07  ... .. ... .. ... .. C-2 A0 ... .. ... ..  00 10 80 02 20  20 A0 ..
08  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
09  C-3 80 D#3 80 G-3 80 ... .. ... .. ... ..  00 10 80 02 ..  29 A0 ..
10  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
11  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
12  C-4 80 D-4 80 G-4 80 ... .. ... .. ... ..  00 10 80 02 30  .. .. ..
13  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
14  C-5 80 D#4 80 G-4 80 ... .. ... .. ... ..  00 10 80 02 80  30 A0 ..
15  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
}}

opcode tick_modulo, k, ki

    /*
    this opcode will increment the k_counter each time it is triggered (on a tick)
    when k_counter advances beyond the pattern length, k_counter is reset to 0
    */

    k_counter, i_length xin
    k_counter += 1
    if k_counter > (i_length-1) then
        k_counter = 0
    endif
    xout k_counter
endop

opcode trigger_percussion, 0, i[]i[]kkk
    itriggers[], itrigkick[], k_counter, k_event_delay, k_shuffle_max xin

    if itriggers[k_counter] > 0 then
        event "i", "CHHAT", k_event_delay, 1.2, itriggers[k_counter]
    endif

    if itrigkick[k_counter] > 0 then
        event "i", "KICK_WAV", k_event_delay, .5
    endif

    if k_counter % 8 == 4 then
        event "i", "CLAP", k_event_delay, .40
    endif


endop


instr InitMsynthParameters

    chnset 0.0, "gkMsynthAttack"
    chnset 0.2, "gkMsynthDecay"
    chnset 0.8, "gkMsynthSustain"
    chnset 0.1, "gkMsynthRelease"
    chnset 0.6, "gkMsynthNoteDuration"

    chnset 1300, "gkMsynthFreq"
    chnset 0.4, "gkMsynthRes"
    chnset 0.1, "gkMsynthNoise"

endin

instr MSequencer

    iSpeed = p4
    ktrig metro iSpeed

    k_counter init 0
    k2_counter init 0
    k_event_delay init 0
    k_shuffle_max = 0.017

    itriggers[] fillarray 1, 0, 2, 0, 1, 0, 2, 0, 1, 0, 2, 0, 1, 1, 2, 3
    itrigkick[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0 ,0, 0

    iplen, itrkParams[][], igroupParams[][] msynth1_pattern_parser gS_pattern_001

    if ktrig == 1 then
        
        k_event_delay = (k_counter % 2 == 0 ? 0 : k_shuffle_max)

        trigger_percussion itriggers, itrigkick, k_counter, k_event_delay, k_shuffle_max

        ; - ----------- handle msynth1 ---------------- - ;
        update_param_globalstate igroupParams[k_counter][0], "gkMsynthAttack"
        update_param_globalstate igroupParams[k_counter][1], "gkMsynthDecay"
        update_param_globalstate igroupParams[k_counter][2], "gkMsynthSustain"
        update_param_globalstate igroupParams[k_counter][3], "gkMsynthRelease"
        update_param_globalstate igroupParams[k_counter][4], "gkMsynthNoteDuration"
        
        update_param_globalstate igroupParams[k_counter][5], "gkMsynthFreq"
        update_param_globalstate igroupParams[k_counter][6], "gkMsynthRes"
        update_param_globalstate igroupParams[k_counter][7], "gkMsynthNoise"

        k_num_tracks_to_handle = 6
        ktrack_num = 0
        krow_index = 0
        k_msynth_dur = chnget:i("gkMsynthNoteDuration")

        while ktrack_num < k_num_tracks_to_handle do 
            krow_index = ktrack_num * 2

            if itrkParams[k_counter][krow_index] > 0 then
                k_note = itrkParams[k_counter][krow_index]
                k_vol = itrkParams[k_counter][krow_index+1]
                ;                                       +-----note duration (istrument duration)
                ;                                       |   +----- p4
                ;                                       |   |             +---p5  +--p6
                event "i", "NEW_SYNTH", k_event_delay, .7,  k_msynth_dur, k_note, k_vol
            endif
            ktrack_num += 1
        od

        ; ---- handle tick counters and resetting ------------ ;
        k_counter tick_modulo, k_counter, 16
        k2_counter tick_modulo, k2_counter, 32

    endif

endin


</CsInstruments>
<CsScore>
t 250
f1  0   16384   10  1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111   ; Sawtooth 2^14

i "InitMsynthParameters" 0 .1
i "MSequencer" 0 10 9.4

</CsScore>
</CsoundSynthesizer>


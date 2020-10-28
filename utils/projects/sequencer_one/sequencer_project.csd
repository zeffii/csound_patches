<CsoundSynthesizer>
<CsOptions>
-odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

#include ".\\opcodes\\opcode_tick_handler.csd"

#include "instrument_kick.csd"
#include "instrument_hhat.csd"
#include "instrument_clap.csd"
#include "instrument_clave.csd"

#include ".\\opcodes\\opcode_msynth1_parser.csd"



gS_pattern_001 = {{
00  C-4 80 D#4 80 G-4 80 A#4 80 ... .. ... ..  00 A0 A0 02 E3  20 E0 10
01  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
02  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
03  C-4 50 D#4 50 G-4 50 ... .. ... .. ... ..  00 50 20 02 ..  30 A0 ..
04  ... .. ... .. ... .. C-2 A0 ... .. ... ..  00 30 20 62 23  50 A0 ..
05  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
06  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  00 60 20 02 A0  20 30 ..
07  ... .. ... .. ... .. C-2 A0 ... .. ... ..  00 20 20 02 ..  20 A0 ..
08  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
09  C-3 80 D#3 80 G-3 80 ... .. ... .. ... ..  00 60 20 02 ..  29 A0 ..
10  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
11  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
12  C-4 80 D-4 80 G-4 80 ... .. ... .. ... ..  30 A0 90 42 A0  20 .. ..
13  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
14  C-5 80 D#4 80 G-4 80 ... .. ... .. ... ..  00 10 20 02 ..  20 A0 ..
15  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. ..  .. .. ..
}}



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

gSMsynthParams[] fillarray "gkMsynthAttack", "gkMsynthDecay", "gkMsynthSustain",\
         "gkMsynthRelease", "gkMsynthNoteDuration", "gkMsynthFreq", "gkMsynthRes", "gkMsynthNoise"


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
        kparam_num = 0
        while kparam_num < lenarray(gSMsynthParams) do
            update_param_globalstate igroupParams[k_counter][kparam_num], gSMsynthParams[kparam_num]
            kparam_num += 1
        od

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
i "MSequencer" 0 10 9.2

</CsScore>
</CsoundSynthesizer>


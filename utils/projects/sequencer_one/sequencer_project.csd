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




gS_pattern_001 = {{
00  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  .. .. .. ..  .. ..
01  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
02  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
03  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  .. .. .. ..  .. ..
04  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
05  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
06  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  .. .. .. ..  .. ..
07  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
08  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
09  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  .. .. .. ..  .. ..
10  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
11  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
12  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  .. .. .. ..  .. ..
13  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
14  C-4 80 D#4 80 G-4 80 ... .. ... .. ... ..  .. .. .. ..  .. ..
15  ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. ..  .. ..
}}



instr MSequencer
    
    ktrig metro 9.4

    k_counter init 0
    k2_counter init 0
    k_event_delay init 0
    k_shuffle_max = 0.017

    itriggers[] fillarray 1, 0, 3, 0, 1, 0, 3, 0, 1, 2, 3, 0, 1, 0, 3, 0
    itrigkick[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0 ,0, 0

    iplen, itrkParams[][], iGrpParams[][] msynth1_pattern_parser gS_pattern_001

    if ktrig == 1 then
        
        k_event_delay = (k_counter % 2 == 0 ? 0 : k_shuffle_max)

        if itriggers[k_counter] > 0 then
            event "i", "CHHAT", k_event_delay, 1.2, itriggers[k_counter]
        endif

        if itrigkick[k_counter] > 0 then
            event "i", "KICK_WAV", k_event_delay, .5
        endif

        if k2_counter % 8 == 4 then
            event "i", "CLAP", k_event_delay, .40
        endif


        k_num_tracks_to_handle = 3
        ktrack_num = 0
        krow_index = 0
        while ktrack_num < k_num_tracks_to_handle do 
            krow_index = ktrack_num * 2

            if itrkParams[k_counter][krow_index] > 0 then

                k_note = itrkParams[k_counter][krow_index]
                k_vol = itrkParams[k_counter][krow_index+1]
                event "i", "CLAVE", k_event_delay, .5, 0.8, k_note, k_vol
            endif
            ktrack_num += 1
        od

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


</CsInstruments>
<CsScore>
t 0 112
i "MSequencer" 0 12

</CsScore>
</CsoundSynthesizer>


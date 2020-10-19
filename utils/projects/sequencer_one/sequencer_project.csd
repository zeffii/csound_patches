<CsoundSynthesizer>
<CsOptions>
-odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

#include "instrument_hhat.csd"
#include "instrument_clap.csd"
#include "instrument_clave.csd"

#include ".\\opcodes\\opcode_string_multiline_split.csd"
#include ".\\opcodes\\opcode_row_parser.csd"
#include ".\\opcodes\\opcode_tnote_to_midi.csd"


giTanh  ftgen   2, 0, 257, "tanh", -10, 10, 0

gSKickPath = ".\\samples\\kick_able_boom_001.wav"


;varname        ifn  itime  isize igen  Sfilnam     iskip iformat ichn
giKick   ftgen  0,   0,     0,    1,    gSKickPath, 0,    0,      0


gS_pattern_001 = {{
00 C-5 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
01 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
02 ... .. ... .. ... .. ... .. ... .. ... ..  .. .. .. .. .. ..
03 C-6 80 D#5 80 G-5 80 ... .. ... .. ... ..  .. .. .. .. .. ..
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

gS_pattern_descriptor = {{TTTNNN VV NNN VV NNN VV NNN VV NNN VV NNN VV  AA AA AA AA AA AA}}


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


instr MSequencer
    
    ktrig metro 9.4

    k_counter init 0
    k2_counter init 0
    k_event_delay init 0
    k_shuffle_max = 0.017

    itriggers[] fillarray 1, 0, 3, 0, 1, 0, 3, 0, 1, 2, 3, 0, 1, 0, 3, 0
    itrigkick[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0 ,0, 0

    S_rows[] multiline_split gS_pattern_001
    itriggersX[] parse_rows, S_rows


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

        if itriggersX[k_counter] > 0 then
            event "i", "CLAVE", k_event_delay, .5, 0.4, itriggersX[k_counter]
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


</CsInstruments>
<CsScore>
t 0 112
i "MSequencer" 0 12

</CsScore>
</CsoundSynthesizer>


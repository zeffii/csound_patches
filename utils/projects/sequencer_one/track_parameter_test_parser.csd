; track_parameter_test_parser.csd

<CsoundSynthesizer>
<CsOptions>
-m0  ; -odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1


instr TESTER
    
    i_track_counter = 0
    while i_track_counter < 6 do

        i_token = 4 + i_track_counter * 7
        prints "[%d %d],[%d %d]\n", i_token, i_token+3, i_token+4, i_token+6

        i_track_counter += 1
    od
    
    ; 4 11 18 25 32 39
endin


</CsInstruments>
<CsScore>

i "TESTER" 0 2

</CsScore>
</CsoundSynthesizer>



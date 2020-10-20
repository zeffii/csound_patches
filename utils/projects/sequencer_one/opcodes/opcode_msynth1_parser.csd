#include "opcode_tnote_to_midi.csd"

opcode msynth1_pattern_parser, ii[][]i[][], S
    /*

    pattern parser designed speficially for the following pattern format

    TTT NNN VV NNN VV NNN VV NNN VV NNN VV NNN VV  AA AA AA AA  AA AA

    takes a multiline pattern, returns a few things 
    - first the length of the pattern, as a variable (this is useful for the sequencer, altho it
      could be inferred using lenarray(any array)
    - then the next output values will be two multidimensional arrays containing Track values
      and Group parameters.

      > Track parameters is a collection of [Note Vol, Note val, ....] ( polyphonic 6)
      > Group parameters reflect the synth's characteristics, ADSR, filter settings .etc

    */


    S_rows[] xin
    iLenArray lenarray S_rows

    iline_count = iLenArray
    iTrackParams[][] init iline_count, 12   ; 2 * 6  = (note, vol) * 6
    iGroupParams[][] init iline_count, 6    ; n group parameters.

    S_temp_note_test = "..."
    iCounter = 0

    while iCounter < iLenArray do

        ; hardcoding sucks donkeys, it's too early to optimize.
        
        S_temp_note1    strsub S_rows[iCounter], 4, 7     ;3
        S_temp_vol1     strsub S_rows[iCounter], 8, 10    ;2
        S_temp_note2    strsub S_rows[iCounter], 11, 14   ;3
        S_temp_vol2     strsub S_rows[iCounter], 15, 17   ;2
        S_temp_note3    strsub S_rows[iCounter], 18, 21   ;3
        S_temp_vol3     strsub S_rows[iCounter], 22, 24   ;2
        S_temp_note4    strsub S_rows[iCounter], 25, 28   ;3
        S_temp_vol4     strsub S_rows[iCounter], 29, 31   ;2
        S_temp_note5    strsub S_rows[iCounter], 32, 35   ;3
        S_temp_vol5     strsub S_rows[iCounter], 36, 38   ;2
        S_temp_note6    strsub S_rows[iCounter], 39, 42   ;3
        S_temp_vol6     strsub S_rows[iCounter], 43, 45   ;2
        ; -----
        i_param_a       strsub S_rows[iCounter], 47, 49   ;2
        i_param_d       strsub S_rows[iCounter], 50, 52   ;2
        i_param_s       strsub S_rows[iCounter], 53, 55   ;2
        i_param_r       strsub S_rows[iCounter], 56, 58   ;2
        ; ----
        i_param_Freq    strsub S_rows[iCounter], 60, 62   ;2
        i_param_Cutoff  strsub S_rows[iCounter], 63, 65   ;2


        if strcmp(S_temp_note, S_temp_note_test) != 0 then
            inote = NoteToMidi(S_temp_note)
            itriggers[iCounter] = inote
        else 
            itriggers[iCounter] = 0
        endif

        iCounter += 1
    od

    ; xout itriggers
    xout iline_count, iTrackParams, iGroupParams

endop

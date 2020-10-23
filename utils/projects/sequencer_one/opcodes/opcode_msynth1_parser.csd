#include "hex_to_decimal.csd"

#include "opcode_string_multiline_split.csd"
#include "opcode_tnote_to_midi.csd"


opcode get_note, i, S
    S_temp_note xin
    ireturn = -1

    S_temp_note_test = "..."
    if strcmp(S_temp_note, S_temp_note_test) != 0 then
        inote = NoteToMidi(S_temp_note)
        ireturn = inote
    else 
        ireturn = 0
    endif

    xout ireturn
endop

opcode convert_hex_range, i, SSiiS

    S_max, S_min, i_max, i_min, S_val_to_convert xin
    prints "convert_hex_range input: %s", S_val_to_convert
    i_value hex_to_decimal S_val_to_convert
    i_hex_max hex_to_decimal S_max
    i_hex_min hex_to_decimal S_min
    i_outval = i_min + (i_value - i_hex_min) * (i_max - i_min) / (i_hex_max - i_hex_min)

    xout i_outval

endop

opcode get_volum, i, S
    S_vol_chars xin
    ; must ensure .. is handled.
    ; i_outval convert_hex_range, "FF", "00", 1.0, 0.0, S_vol_chars
    i_outval = 0.2
    xout i_outval
endop

opcode get_hex, i, iSSiiS
    ;   ival get_hex 2, 4000, 100, "FF", "00", "3F"
    iLen, Smax, Smin, imax, imin, S_input_hex xin
    iOutput init -90000

    if iLen == 2 then
        S_dots_hex = ".."
    elseif iLen == 4 then 
        S_dots_hex = "...."
    endif 

    if strcmp(S_dots_hex, S_input_hex) != 0 then
        iOutput = convert_hex_range(Smax, Smin, imax, imin, S_input_hex)
    endif 

    xout iOutput
endop


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

    S_multiline xin
    S_rows[] multiline_split S_multiline
    iLenArray lenarray S_rows

    iline_count = iLenArray
    iTrackParams[][] init iline_count, 12   ; 2 * 6  = (note, vol) * 6
    igroupParams[][] init iline_count, 6    ; n group parameters.

    iCounter = 0

    while iCounter < iLenArray do

        ; hardcoding sucks donkeys, it's too early to optimize.
        ;                                                 paramwidth    index
        S_temp_note1    strsub S_rows[iCounter], 4, 7     ;3            0
        S_temp_vol1     strsub S_rows[iCounter], 8, 10    ;2            1
        S_temp_note2    strsub S_rows[iCounter], 11, 14   ;3            2
        S_temp_vol2     strsub S_rows[iCounter], 15, 17   ;2            3
        S_temp_note3    strsub S_rows[iCounter], 18, 21   ;3            4
        S_temp_vol3     strsub S_rows[iCounter], 22, 24   ;2            5
        ;S_temp_note4    strsub S_rows[iCounter], 25, 28   ;3            6
        ;S_temp_vol4     strsub S_rows[iCounter], 29, 31   ;2            7
        ;S_temp_note5    strsub S_rows[iCounter], 32, 35   ;3            8
        ;S_temp_vol5     strsub S_rows[iCounter], 36, 38   ;2            9
        ;S_temp_note6    strsub S_rows[iCounter], 39, 42   ;3            10
        ;S_temp_vol6     strsub S_rows[iCounter], 43, 45   ;2            11
        /*
        ; -----
        i_param_a       strsub S_rows[iCounter], 47, 49   ;2            0
        i_param_d       strsub S_rows[iCounter], 50, 52   ;2            1
        i_param_s       strsub S_rows[iCounter], 53, 55   ;2            2
        i_param_r       strsub S_rows[iCounter], 56, 58   ;2            3
        ; ----
        */
        S_param_Freq    strsub S_rows[iCounter], 60, 62   ;2            4
        S_param_Cutoff  strsub S_rows[iCounter], 63, 65   ;2            5

        iTrackParams[iCounter][0] = get_note(S_temp_note1)  ; midi note
        iTrackParams[iCounter][1] = get_volum(S_temp_vol1)  ; note vol
        iTrackParams[iCounter][2] = get_note(S_temp_note2)  ; midi note
        iTrackParams[iCounter][3] = get_volum(S_temp_vol2)  ; note vol
        iTrackParams[iCounter][4] = get_note(S_temp_note3)  ; midi note
        iTrackParams[iCounter][5] = get_volum(S_temp_vol3)  ; note vol

        ; filter params
        igroupParams[iCounter][4] = get_hex(2, "FF", "00", 12000.0, 300.0, S_param_Freq)
        igroupParams[iCounter][5] = get_hex(2, "FF", "00", 0.9, 0.2, S_param_Cutoff)
        
        iCounter += 1
    od

    ; xout itriggers
    xout iline_count, iTrackParams, igroupParams

endop

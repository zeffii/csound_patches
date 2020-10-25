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
    ; prints "convert_hex_range input: %s", S_val_to_convert
    i_value hex_to_decimal S_val_to_convert
    i_hex_max hex_to_decimal S_max
    i_hex_min hex_to_decimal S_min
    i_outval = i_min + (i_value - i_hex_min) * (i_max - i_min) / (i_hex_max - i_hex_min)

    xout i_outval

endop

opcode get_volum, i, S
    S_vol_chars xin
    if strcmp(S_vol_chars, "..") == 0 then
        S_vol_chars = "80"
    endif
    i_outval = convert_hex_range("FF", "00", 1.0, 0.0, S_vol_chars)

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


opcode get_hex_easy, i, SiiSSii
    
    S_row, idx_start, idx_end, Shex_max, Shex_min, imax, imin xin
    S_param       strsub    S_row, idx_start, idx_end
    ioutval = get_hex(idx_end-idx_start, Shex_max, Shex_min, imax, imin, S_param)
    xout ioutval
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
    i_token = 0

    /* 
    [4 7] [8 10], [11 14] [15 17], [18 21] [22 24], [25 28] [29 31], [32 35] [36 38], [39 42] [43 45]
    */

    while iCounter < iLenArray do

        i_track_counter = 0
        while i_track_counter < 6 do

            ; i_token points at the indices representing start and end of the substrings (indexed above)
            i_token = 4 + i_track_counter * 7

            S_temp_note    strsub S_rows[iCounter], i_token, i_token+3    ;3
            S_temp_vol     strsub S_rows[iCounter], i_token+4, i_token+6  ;2
            iTrackParams[iCounter][i_track_counter*2    ] = get_note(S_temp_note)
            iTrackParams[iCounter][i_track_counter*2 + 1] = get_volum(S_temp_vol)
            i_track_counter += 1
        od

        
        ; ------- adsr params ------
        S_param_a       strsub S_rows[iCounter], 47, 49   ;2            0
        S_param_d       strsub S_rows[iCounter], 50, 52   ;2            1
        S_param_s       strsub S_rows[iCounter], 53, 55   ;2            2
        S_param_r       strsub S_rows[iCounter], 56, 58   ;2            3
        igroupParams[iCounter][0] = get_hex(2, "FF", "00", 10.0, 0.01, S_param_a)
        igroupParams[iCounter][1] = get_hex(2, "FF", "00", 10.0, 0.01, S_param_d)
        igroupParams[iCounter][2] = get_hex(2, "FF", "00", 1.00, 0.0,  S_param_s)
        igroupParams[iCounter][3] = get_hex(2, "FF", "00", 20.0, 0.01, S_param_r)

        ; ------- filter main  ------
        igroupParams[iCounter][4] = get_hex_easy(S_rows[iCounter], 60, 62, "FF", "00", 12000.0, 300.0)
        igroupParams[iCounter][5] = get_hex_easy(S_rows[iCounter], 63, 65, "FF", "00", 0.99,    0.0)

        ;S_param_Freq    strsub S_rows[iCounter], 60, 62   ;2            4
        ;S_param_Cutoff  strsub S_rows[iCounter], 63, 65   ;2            5
        ;igroupParams[iCounter][4] = get_hex(2, "FF", "00", 12000.0, 300.0, S_param_Freq)
        ;igroupParams[iCounter][5] = get_hex(2, "FF", "00", 0.99, 0.0, S_param_Cutoff)
        
        iCounter += 1
    od

    xout iline_count, iTrackParams, igroupParams

endop

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
    iTrackParams[][] = iline_count, 12
    iGroupParams[][] = iline_count, 6

    itriggers[] init iLenArray

    iCounter = 0
    while iCounter < iLenArray do
        
        S_temp_note strsub S_rows[iCounter], 4, 7
        S_temp_note_test = "..."

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

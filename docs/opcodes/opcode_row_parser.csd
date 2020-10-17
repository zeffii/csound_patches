opcode parse_rows, i[], S[]

    S_rows[] xin

    iLenArray lenarray S_rows
    itriggers[] init iLenArray

    iCounter = 0
    while iCounter < iLenArray do
        
        S_temp_note strsub S_rows[iCounter], 3, 6
        S_temp_note_test = "C-5"

        if strcmp(S_temp_note, S_temp_note_test) == 0 then
            itriggers[iCounter] = 1
        else 
            itriggers[iCounter] = 0
        endif

        iCounter += 1
    od

    xout itriggers

endop


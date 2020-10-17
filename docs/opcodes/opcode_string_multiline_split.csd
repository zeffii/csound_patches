opcode multiline_split, S[], S
    /*
       
    multiline_split  

    usage:   

            S_rows[] multiline_split gS_pattern_001
    
    info:
    
    :   accept -  single multiple string
    :   return -  an array of strings
    
    :   this function will test if the first character in the string is a newline
    :   and remove it before doing the main text split 

    : known limitations
    1. expects equal size splits
    2. this means patterns of over 99 lines long will need to do something like
       99 C-% ... 
       100C-5 ...
       effectively limiting this function to patterns of 999 lines, which is fine.
       512 is uncomfortable already, and I can use Hex instead if 1024+ was needed
    */

    S_multiline_str xin

    ipos strindex S_multiline_str, "\n"
    if ipos == 0 then
        ; prints "removing first newline if pos 0"
        S_multiline_str strsub S_multiline_str, 1
    endif

    iFirstNewLine strindex S_multiline_str, "\n"
    iSizeNewArray = int(strlen(S_multiline_str) / (iFirstNewLine + 1))

    S_new_array[] init iSizeNewArray
    i_counter = 0
    i_substart = 0
    i_subend = 0

    while (i_counter <= iSizeNewArray-1) do
        i_substart = int(i_counter * (iFirstNewLine+1))
        i_subend = int(i_substart + iFirstNewLine)
        S_new_array[i_counter] = strsub(S_multiline_str, i_substart, i_subend)
        i_counter += 1
    od

    xout S_new_array

endop

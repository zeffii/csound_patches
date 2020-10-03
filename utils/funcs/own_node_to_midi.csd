; own_note_to_hz.csd

<CsoundSynthesizer>
<CsOptions>
-odac  ; -nm0
</CsOptions>

<CsInstruments>
sr = 44100
nchnls = 2
ksmps = 32
0dbfs = 1

opcode NoteToMidi, i, S
    Sstr xin
    
    ithru       strcmp  "...", Sstr
    iterm       strcmp  "===", Sstr
    imidinote = -5
    Snums       init    "None"
    Snums       strcpyk "0123456789"

    if ithru == 1 then 
        imidinote = -2
    elseif iterm == 1 then
        imidinote = -3
    else
        ; check if within supported range
        Sidx     strsub     Sstr, 2, -1
        ioct     strindex   Snums, Sidx
        
        if (ioct < 0) then
            imidinote = -4
        endif
     
        SNoteKind strsub Sstr, 0, 2
        String_Notes_list[] fillarray "C-","C#","D-","D#","E-","F-",
                         "F#","G-","G#","A-","A#","B-"
        
        itable = 1
        itablesize = lenarray(String_Notes_list)
        i_index = 0

        forloop:
            iFound strcmp String_Notes_list[i_index], SNoteKind

            if iFound == 1 then
                imidinote = (i_index + ioct * 12)
            endif
            i_index += 1
 
        loop_lt i_index, 1, itablesize, forloop

    endif

    xout int(imidinote)
endop 

instr NoteTester

    ival NoteToMidi "C-5"
    print ival

endin

</CsInstruments>
<CsScore>

i "NoteTester" 0 2

</CsScore>
</CsoundSynthesizer>


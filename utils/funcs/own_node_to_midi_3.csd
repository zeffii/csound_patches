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

gS_notes[] fillarray "C-","C#","D-","D#","E-","F-","F#","G-","G#","A-","A#","B-"

opcode NoteToMidi, i, S
    Sstr xin
    ithru       strcmp  "...", Sstr
    iterm       strcmp  "===", Sstr
    imidinote   init    -5
    Snums       init    "0123456789"
    i_index     init    -1
    i_counter   init    0

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
     
        SNoteKind   strsub Sstr, 0, 2

        ; which element in gS_notes corresponds to SNoteKind
        until i_counter == lenarray(gS_notes) do
            if strcmp(SNoteKind, gS_notes[i_counter]) == 0 then 
                i_index = i_counter
            endif
            i_counter += 1
        od 


        if i_index < 0 then 
            imidinote = -5
        else
            imidinote = (i_index + ioct * 12) + 12
        endif 

    endif

    xout imidinote
endop 


instr NoteTester
    Sname = p4
    ival NoteToMidi Sname
    prints "note %s becomes midi %d\n", Sname, ival
endin

</CsInstruments>
<CsScore>

i "NoteTester" 0 2 "C-4"
i "NoteTester" 0 2 "C#4"
i "NoteTester" 0 2 "D-4"
i "NoteTester" 0 2 "D#4"
i "NoteTester" 0 2 "E-4"
i "NoteTester" 0 2 "F-4"
i "NoteTester" 0 2 "F#4"
i "NoteTester" 0 2 "G-4"
i "NoteTester" 0 2 "G#4"
i "NoteTester" 0 2 "A-4"
i "NoteTester" 0 2 "A#4"
i "NoteTester" 0 2 "B-4"
i "NoteTester" 0 2 "C-5"
i "NoteTester" 0 2 "B-5"
i "NoteTester" 0 2 "G-6"

</CsScore>
</CsoundSynthesizer>


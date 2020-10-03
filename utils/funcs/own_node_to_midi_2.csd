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
    ; 255 off 254 cut  ?
    ithru       strcmp  "...", Sstr
    iterm       strcmp  "===", Sstr
    imidinote   init    -5
    Snums       init    "0123456789"
    i_index     init    0

    ; prints "New Node input %s\n", Sstr

    if ithru == 1 then 
        imidinote = -2
    elseif iterm == 1 then
        imidinote = -3
    else
        ; check if within supported range
        Sidx     strsub     Sstr, 2, -1
        ioct     strindex   Snums, Sidx

        prints "%s found octave %d", Sstr, ioct
        
        if (ioct < 0) then
            imidinote = -4
        endif
     
        SNoteKind   strsub Sstr, 0, 2
        is_C        strcmp "C-", SNoteKind
        is_CSharp   strcmp "C#", SNoteKind
        is_D        strcmp "D-", SNoteKind
        is_DSharp   strcmp "D#", SNoteKind
        is_E        strcmp "E-", SNoteKind
        is_F        strcmp "F-", SNoteKind
        is_FSharp   strcmp "F#", SNoteKind
        is_G        strcmp "G-", SNoteKind
        is_GSharp   strcmp "G#", SNoteKind
        is_A        strcmp "A-", SNoteKind
        is_ASharp   strcmp "A#", SNoteKind
        is_B        strcmp "B-", SNoteKind

        if is_C == 1 then
            i_index = 0
        elseif is_CSharp == 1 then 
            i_index = 1
        elseif is_D == 1 then 
            i_index = 2
        elseif is_DSharp == 1 then 
            i_index = 3
        elseif is_E == 1 then 
            i_index = 4
        elseif is_F == 1 then 
            i_index = 5
        elseif is_FSharp == 1 then 
            i_index = 6
        elseif is_G == 1 then 
            i_index = 7
        elseif is_GSharp == 1 then 
            i_index = 8
        elseif is_A == 1 then 
            i_index = 9
        elseif is_ASharp == 1 then 
            i_index = 10
        elseif is_B == 1 then 
            i_index = 11
        else
            i_index = -1
        endif 

        if i_index < 0 then 
            imidinote = -5
        else
            imidinote = i_index + ioct * 12
        endif 

    endif

    print imidinote
    xout imidinote
endop 


instr NoteTester
    Sname = p4
    ival NoteToMidi Sname
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
i "NoteTester" 0 2 "C-5"
i "NoteTester" 0 2 "E-6"

</CsScore>
</CsoundSynthesizer>


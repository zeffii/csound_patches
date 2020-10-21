
gSHat     = ".\\samples\\HHODA.WAV"
giHat    ftgen  0,   0,     0,    1,    gSHat,      0,    0,      0


instr CHHAT   ; p4  = duration

    iamp = 0.7
    if p4 == 1 then
        iduration = .05
        iamp = random:i(0, 0.3)
    elseif p4 == 2 then
        iduration = .09
    elseif p4 == 3 then
        iamp = 0.5
        iduration = .33
    else
        iduration = .9
    endif

    i_sample_len filelen gSHat ;play whole length of the sound file

    aEnv expon 1, iduration, 0.001
    aSig poscil3 iamp, 1/i_sample_len, giHat
    aSig *= (aEnv * .7)
    outs aSig, aSig

endin


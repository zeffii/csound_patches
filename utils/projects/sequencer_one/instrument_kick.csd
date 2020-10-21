; instrument_kick.csd

giTanh  ftgen   2, 0, 257, "tanh", -10, 10, 0
gSKickPath = ".\\samples\\kick_able_boom_001.wav"

;varname        ifn  itime  isize igen  Sfilnam     iskip iformat ichn
giKick   ftgen  0,   0,     0,    1,    gSKickPath, 0,    0,      0


instr KICK_WAV

    i_offset = 0.0001
    i_sample_len filelen gSKickPath ;play whole length of the sound file
    kcf = 200
    aEnv expon 1, 0.4, 0.001
    aSig poscil3 .7, (1/i_sample_len)*0.99, giKick, i_offset
    aSig distort aSig*0.8, .326, giTanh
    aSig moogladder aSig, kcf, 0.4 ; filter audio signa
    aSig *= 1.6
    aSig *= aEnv
    outs aSig, aSig

endin

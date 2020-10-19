gSClap_p1 = ".\\samples\\clap_p1.wav"
gSClap_p2 = ".\\samples\\clap_p2.wav"
gSClap_p3 = ".\\samples\\clap_p3.wav"
gSClap_p4 = ".\\samples\\clap_p4.wav"
gSClap_p5 = ".\\samples\\clap_p5.wav"

giCl_p1  ftgen  0,   0,     0,    1,    gSClap_p1,  0,    0,      0
giCl_p2  ftgen  0,   0,     0,    1,    gSClap_p2,  0,    0,      0
giCl_p3  ftgen  0,   0,     0,    1,    gSClap_p3,  0,    0,      0
giCl_p4  ftgen  0,   0,     0,    1,    gSClap_p4,  0,    0,      0
giCl_p5  ftgen  0,   0,     0,    1,    gSClap_p5,  0,    0,      0

opcode clap_segment, a, iii;  duration, delay

    iduration, idelay, isegment xin
    ; iAmp random 1.0, 1.2 ; amplitude randomly chosen
    ; aNse noise 1, 0 ; create noise component
    ; aEnv expon 1, iduration, 0.001 ; amp. envelope (percussive)
    ; aSig = aNse * aEnv * iAmp ; apply env. and amp. factor

    aSig init 0
    aEnv expon 1, iduration, 0.001
    iAmp = .4

    if isegment == 1 then
        i_sample_len filelen gSClap_p1
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p1
    elseif isegment == 2 then
        i_sample_len filelen gSClap_p2
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p2
    elseif isegment == 3 then
        i_sample_len filelen gSClap_p3
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p3
    elseif isegment == 4 then
        i_sample_len filelen gSClap_p4
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p4
    elseif isegment == 5 then
        i_sample_len filelen gSClap_p5
        aSig poscil3 iAmp, 1/i_sample_len, giCl_p5
    endif

    aSig *= aEnv

    if idelay > 0.0 then
        aSig delay aSig, idelay
    endif
    xout aSig
endop


instr CLAP

    ;                  duration            trigger time              segment
    aSig1 clap_segment .18,                0,                        1
    aSig2 clap_segment random:i(.025,.03), 0.02,                     2
    aSig3 clap_segment .14,                0.04,                     3
    aSig4 clap_segment .24,                0.05,                     4
    aSig5 clap_segment random:i(.9, .46),  random:i(0.0601, 0.053),  5
    aSig sum aSig1, aSig2, aSig3, aSig4, aSig5
    aSig buthp aSig, random:i(620, 400)
    aSig *= .4

    outs aSig, aSig ; send audio to output

endin

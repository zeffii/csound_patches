
opcode update_param_globalstate, 0, kS

    ; usage
    ;   update_param_globalstate( igroupParams[k_counter][4], "gkParamName")

    kNewVal, SparamName xin

    if kNewVal != -90000 then 
        chnset kNewVal, SparamName
    endif

endop


instr NEW_SYNTH

    
    iNoteDuration =    p4
    iFreq         mtof p5
    ivol          =    p6

    kcf           =    chnget:k("gkMsynthFreq")
    kres          =    chnget:k("gkMsynthRes")

    aEnv          expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise        pinker                 ; pink noise
    aSig          oscil ivol, iFreq, 1   ; oscillator
    ; ---overtones
        aSig_ot1  oscil ivol/16, iFreq*2, 1      ; 1 overtone - oscillator
        aSig_ot2  oscil ivol/18, iFreq*3, 1      ; 2 overtone - oscillator

    aSig += (aSig_ot1 + aSig_ot2)

    ; --- filters
    knoise = chnget:k("gkMsynthNoteDuration")
    aSig += (aNoise * knoise)
    aSig moogladder aSig, kcf, kres
    ; aEnv madsr i(gkMsynthAttack), i(gkMsynthDecay), i(gkMsynthSustain), i(gkMsynthRelease)

    ;aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning
    
    outs (aSig*aEnv)*ivol, (aSig*aEnv)*ivol          ; stereo output


endin


instr InitMsynthParameters

    chnset 0.0, "gkMsynthAttack"
    chnset 0.2, "gkMsynthDecay"
    chnset 0.8, "gkMsynthSustain"
    chnset 0.1, "gkMsynthRelease"
    chnset 0.6, "gkMsynthNoteDuration"

    chnset 1300, "gkMsynthFreq"
    chnset 0.4, "gkMsynthRes"
    chnset 0.1, "gkMsynthNoise"

endin


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
    
    i_attack      =    chnget:i("gkMsynthAttack")
    i_decay       =    chnget:i("gkMsynthDecay")
    i_sustain     =    chnget:i("gkMsynthSustain")
    i_release     =    chnget:i("gkMsynthRelease")
    kcf           =    chnget:k("gkMsynthFreq")
    kres          =    chnget:k("gkMsynthRes")
    knoise        =    chnget:k("gkMsynthNoteDuration")

    aEnv2         expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise        pinker                 ; pink noise
    aSig          oscil ivol, iFreq, 1   ; oscillator
    ; ---         overtones
        aSig_ot1  oscil ivol/16, iFreq*2, 1      ; 1 overtone - oscillator
        aSig_ot2  oscil ivol/18, iFreq*3, 1      ; 2 overtone - oscillator

    aSig += (aSig_ot1 + aSig_ot2)

    ; ---    filters
    aSig += (aNoise * knoise)
    aSig     moogladder aSig, kcf, kres
    aEnv     madsr      i_attack, i_decay, i_sustain, i_release

    ;aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning
    
    outs (aSig*aEnv*aEnv2)*ivol, (aSig*aEnv*aEnv2)*ivol          ; stereo output


endin

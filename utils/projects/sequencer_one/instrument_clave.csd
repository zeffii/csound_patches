
gkMsynthAttack   init 0.0
gkMsynthDecay    init 0.2
gkMsynthSustain  init 0.8
gkMsynthRelease  init 0.1
gkMsynthNoteDuration init 0.6

gkMsynthFreq     init 1300
gkMsynthRes      init 0.4


opcode update_param_globalstate, 0, kS

    ; usage
    ;   update_param_globalstate( igroupParams[k_counter][4], "gkParamName")

    kNewVal, SparamName xin

    ; kNewFreq = igroupParams[k_counter][4]
    if kNewVal != -90000 then 

        if strcmp(SparamName, "gkMsynthFreq")        == 0 then
            gkMsynthFreq = kNewVal
        elseif strcmp(SparamName, "gkMsynthRes")     == 0 then
            gkMsynthRes = kNewVal
        elseif strcmp(SparamName, "gkMsynthAttack")  == 0 then
            gkMsynthAttack = kNewVal
        elseif strcmp(SparamName, "gkMsynthDecay")   == 0 then
            gkMsynthDecay = kNewVal
        elseif strcmp(SparamName, "gkMsynthSustain") == 0 then
            gkMsynthSustain = kNewVal                                    
        elseif strcmp(SparamName, "gkMsynthRelease") == 0 then
            gkMsynthRelease = kNewVal                                    
        elseif strcmp(SparamName, "gkMsynthNoteDuration") == 0 then
            gkMsynthNoteDuration = kNewVal
        endif

    endif

endop


instr NEW_SYNTH

    
    iNoteDuration =    p4
    iFreq         mtof p5
    ivol          = p6

    kcf           = gkMsynthFreq
    kres          = gkMsynthRes

    aEnv        expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise      pinker                 ; pink noise
    aSig        oscil ivol, iFreq, 1   ; oscillator
    ; ---overtones
        aSig_ot1    oscil ivol/16, iFreq*2, 1      ; 1 overtone - oscillator
        aSig_ot2    oscil ivol/18, iFreq*3, 1      ; 2 overtone - oscillator

    aSig += (aSig_ot1 + aSig_ot2)

    ; --- filters
    aSig += (aNoise / 3)
    aSig moogladder aSig, kcf, kres
    ; aEnv madsr i(gkMsynthAttack), i(gkMsynthDecay), i(gkMsynthSustain), i(gkMsynthRelease)

    ;aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning
    
    outs (aSig*aEnv)*ivol, (aSig*aEnv)*ivol          ; stereo output


endin

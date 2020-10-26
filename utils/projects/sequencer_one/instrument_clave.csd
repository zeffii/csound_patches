gkMsynthFreq = 1300
gkMsynthRes = 0.4

opcode update_param_globalstate, 0, kS

    ; usage
    ;   update_param_globalstate( igroupParams[k_counter][4], "gkParamName")

    kNewVal, SparamName xin

    ; kNewFreq = igroupParams[k_counter][4]
    if kNewVal != -90000 then 

        if strcmp(SparamName, "gkMsynthFreq") == 0 then
            gkMsynthFreq = kNewVal
        elseif strcmp(SparamName, "gkMsynthRes") == 0 then
            gkMsynthRes = kNewVal
        endif

    endif

endop


instr NEW_SYNTH

    iFreq   mtof p5
    ivol    = p6
    
    kcf     = gkMsynthFreq
    kres    = gkMsynthRes
    
    ; ires init 0.4

    aEnv        expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise      pinker                 ; pink noise
    aSig        oscil ivol, iFreq, 1   ; oscillator
    ; ---overtones
    aSig_ot1    oscil ivol/16, iFreq*2, 1      ; 1 overtone - oscillator
    aSig_ot2    oscil ivol/18, iFreq*3, 1      ; 2 overtone - oscillator

    aSig += (aSig_ot1 + aSig_ot2)

    ; --- filters
    ; aSig    moogvcf   aSig, kcf, ires
    aSig += (aNoise / 3)
    aSig moogladder aSig, kcf, kres


    ;iAtt  chnget "msynth attack"
    ;iDec  chnget "msynth decay"
    ;iSus  chnget "msynth sustain"
    ;iRel  chnget "msynth release"

    ;aEnv madsr iAtt, iDec, iSus, iRel     

    ;aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning
    
    outs (aSig*aEnv)*ivol, (aSig*aEnv)*ivol          ; stereo output


endin

instr CLAVE

    iFreq   mtof p5
    ivol    = p6
    kcf     = p7
    ires init 0.4

    aEnv    expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise  pinker                 ; pink noise
    aSin    poscil 0.4, iFreq      ; sine oscillator
    aLFO1   lfo 1.0, 2.2, 3        ; LFO - square (unipolar)
    aLFO2   lfo 1.0, 1.3, 2        ; LFO - square (bipolar)
    aSig    = (aLFO1 * aNoise) + (aLFO2 * aSin)  ; crazy mixing

    ;prints "new string... %s", S_new_val
    /*
    iAtt = 0.1
    iDec = 0.4
    iSus = 0.6
    iRel = 0.7
    kEnv madsr iAtt, iDec, iSus, iRel 
    */    
    ;kcf     chnget       "filterfreq"

    aSig    moogvcf   aSig, kcf, ires

    aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning
    
    outs (aSigL*aEnv)*ivol, (aSigR*aEnv)*ivol          ; stereo output


endin


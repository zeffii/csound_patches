

instr CLAVE

    iFreq   mtof p5
    ivol    = p6
    ;iFreq   = p7
    ;iRes    = p8

    
    ;kcf init 6000

    aEnv    expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise  pinker                 ; pink noise
    aSin    poscil 0.4, iFreq      ; sine oscillator
    aLFO1   lfo 1.0, 2.2, 3        ; LFO - square (unipolar)
    aLFO2   lfo 1.0, 4.3, 2        ; LFO - square (bipolar)
    aSig    = (aLFO1 * aNoise) + (aLFO2 * aSin)  ; crazy mixing

    /*
    iAtt = 0.1
    iDec = 0.4
    iSus = 0.6
    iRel = 0.7
    kEnv madsr iAtt, iDec, iSus, iRel 
    */    
    ;kcf     chnget       "filterfreq"
    ;print   kcf
    ; prints "%d, %d", iFreq, iRes
    ; aSig    moogladder   aSig, iFreq, iRes

    aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning

    outs (aSigL*aEnv)*ivol, (aSigR*aEnv)*ivol          ; stereo output


endin
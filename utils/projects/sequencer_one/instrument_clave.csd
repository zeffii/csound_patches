

instr CLAVE

    iFreq   mtof p5
    ivol    = p6

    aEnv    expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise  pinker                 ; pink noise
    aSin    poscil 0.4, iFreq      ; sine oscillator
    aLFO1   lfo 1.0, 2.2, 3        ; LFO - square (unipolar)
    aLFO2   lfo 1.0, 4.3, 2        ; LFO - square (bipolar)
    aSig    = (aLFO1 * aNoise) + (aLFO2 * aSin)  ; crazy mixing

    ; aSig    moogladder   aSig, kcf, 0.9

    aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning

    outs (aSigL*aEnv)*ivol, (aSigR*aEnv)*ivol          ; stereo output


endin
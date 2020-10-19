

instr CLAVE

    iFreq   mtof p5
    aEnv    expon 1, p4, 0.001     ; amplitude envelope (percussive)
    aNoise  pinker                 ; pink noise
    aSin    poscil 0.4, iFreq      ; sine oscillator
    aLFO1   lfo 0.7, 122.6, 3        ; LFO - square (unipolar)
    aLFO2   lfo 0.7, .3, 2         ; LFO - square (bipolar)
    aSig    = (aLFO1 * aNoise) + (aLFO2 * aSin)  ; crazy mixing

    aSigL, aSigR pan2 aSig, aLFO1-aLFO2       ; insane panning

    outs aSigL*aEnv, aSigR*aEnv             ; stereo output


endin
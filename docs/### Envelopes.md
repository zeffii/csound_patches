### Envelopes

csound's envelopes


line:       takes a start value, a duration, and an end value. 
            it will take duration time to go from:  start-value  to  end-value
            this is a linear interpolation

```
            aEnv line start_val, duration, end_val
            aEnv line 0.1, 2, 1.0
```

linseg:     take an arbitrary flat-list of value pairs,
            the total length of the envelope would be the sum of all durations, but if the note length is shorter, 
            the sound is cut off before the envelope completes. keep this in mind.
            below is linseg usage that corresponds to a more common ADSR envelope.

```         ;           | -attack- |  --decay-- | --sustain-- |-release-|
            aEnv linseg  0, 0.01, 1,  0.1, 0.1,  p3-0.21, 0.1,   0.1, 0

```

expon:




expseg:
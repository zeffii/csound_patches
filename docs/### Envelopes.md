### Envelopes

csound's envelopes


line:       takes a start value, a duration, and an end value. 
            it will take duration time to go from:  start-value  to  end-value
            this is a linear interpolation

```
            aEnv line start_val, duration, end_val
            aEnv line 0.1, 2, 1.0
```

linen:      take a list of value pairs,
            the total length of the envelope would be the sum of all durations, but if the note length is shorter, 
            the sound is cut off before the envelope completes. keep this in mind.

```
            aEnv line start, duration, [next_value, duration, ...], end-value
```
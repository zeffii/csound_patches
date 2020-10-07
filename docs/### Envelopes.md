### Envelopes

csound's envelopes

## line

Takes a start value, a duration, and an end value. it will take duration time to go from:  start-value  to  end-value
this is a linear interpolation

```
            aEnv line start_val, duration, end_val
            aEnv line 0.1, 2, 1.0
```

## linseg

Take an arbitrary flat-list of value pairs,
the total length of the envelope would be the sum of all durations, but if the note length is shorter, 
the sound is cut off before the envelope completes. keep this in mind.
below is linseg usage that corresponds to a more common ADSR envelope.

```         ;           | -attack- |  --decay-- | --sustain-- |-release-|
            aEnv linseg  0, 0.01, 1,  0.1, 0.1,  p3-0.21, 0.1,   0.1, 0
            aEnv linseg  0, p3/4, 0.9, p3/2, 0.9, p3/4, 0
```

## expon

Similar to line, but this opcode produces an exponential that travels from `a` to `b` during `time`.

```
            aEnv expon a, time, b
            aEnv expon start, duration, end
            aEnv expon 1, p3, 0.0001
```

## expseg

The subtraction lateron of .001 is because expseg can not produce values as they approach 0.

```
            kEnv expseg 0.001, p3/4, 0.901, p3/2, 0.901, p3/4, 0.001
            kEnv = kEnv – 0.001
```

## expseg-port

May require a second anti-click envelope over the top, maybe using `xtratim .1`

## cosseg
todo

## transeg
todo

-----------

## Release aware envelopes

Envelopes with release segment are: (ending in r)

> linenr, linsegr, expsegr, madsr, maxadsrm envlpxr

    (from flossmanual)
    > these opcodes wait until a held node is turned off before executing their final envelope segment. 
    > To facilitate this mechanism they extend the duration of the note so that this final envelope segment can complete

## linsegr:
An envelope with a release segment, the envelope sense note-releases.
```
;            attack-|sustain-|-release
aEnv linsegr 0, 0.01,   0.1,   0.5,0; envelope that senses note releases
```
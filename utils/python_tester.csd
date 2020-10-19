<CsoundSynthesizer>
<CsOptions>
-ndm0
</CsOptions>
<CsInstruments>

;start python interpreter
pyinit

;run python code at init-time
pyruni "print '*********************'"
pyruni "print '*Hello Csound world!* <---- from python'"
pyruni "print '*********************'"

instr 1
endin

</CsInstruments>
<CsScore>
i 1 0 0
</CsScore>
</CsoundSynthesizer>
;Example by Andrés Cabrera and Joachim Heintz

;Example by Andrés Cabrera and Joachim Heintz
; "C:\Python27\python.exe"
;
;
; csound --env:NAME=VALUE
; csound --env:PYTHONPATH=C:\Python24\
 ; "backup": ["csound", "-d", "-odac", "$file", "--env:PYTHONPATH=C:\\Python24\\"]
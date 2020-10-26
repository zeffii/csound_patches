opcode update_param_state, kk, kkk

    ; usage
    ;   kFreq, kLastFreq update_param_state kFreq, kLastFreq, igroupParams[k_counter][4]

    kVal, kLastVal, kNewVal xin

    ; kNewFreq = igroupParams[k_counter][4]
    if kNewVal == -90000 then 
        kVal = kLastVal
    else 
        kVal = kNewVal
        kLastVal = kNewVal
    endif

    xout kVal, kLastVal

endop




def to_note(note_str):
    # fun int to_note(string str){
    if (note_str == "..."):
        return -1
    if (note_str == "OFF"): 
        return -2
    if (note_str == "==="): 
        return -3
 
    # // check if within supported range
    octave = int(note_str[2:])
    if (octave < 0 or octave > 10):
        return -4;
 
    kind = note_str[:2]
    notes_list = ["C-","C#","D-","D#","E-","F-","F#","G-","G#","A-","A#","B-"] 
    
    idx = notes_list.index(kind)
    if idx < 0:
        print("unknown note")
        return -5
    else:
        return (idx + octave * 12) + 12
    return -5

# notes = "C-4", "C-5", "C#5", "D-5", "D#5", "E-5", "F-5", "F#5", "G-5", "G#5", "A-5","A#5","B-5"
notes = "E-6",
for note in notes:
    print(to_note(note))

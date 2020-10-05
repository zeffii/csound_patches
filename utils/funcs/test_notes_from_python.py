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

notes = [
    "C-4", "C#4", "D-4", "D#4", "E-4", "F-4", "F#4", "G-4", "G#4", "A-4", "A#4", "B-4",
    "C-5", "C#5", "D-5", "D#5", "E-5", "F-5", "F#5", "G-5", "G#5", "A-5", "A#5", "B-5",
    "C-6", "C#6", "D-6", "D#6", "E-6", "F-6", "F#6", "G-6", "G#6", "A-6", "A#6", "B-6"]

for note in notes:
    print(note, to_note(note))

"""
C-4 60
C#4 61
D-4 62
D#4 63
E-4 64
F-4 65
F#4 66
G-4 67
G#4 68
A-4 69
A#4 70
B-4 71
C-5 72
C#5 73
D-5 74
D#5 75
E-5 76
F-5 77
F#5 78
G-5 79
G#5 80
A-5 81
A#5 82
B-5 83
C-6 84
C#6 85
D-6 86
D#6 87
E-6 88
F-6 89
F#6 90
G-6 91
G#6 92
A-6 93
A#6 94
B-6 95
"""
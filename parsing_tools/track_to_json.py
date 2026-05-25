import json
import re

COLOR_MAP = {
    'b': 'blue',
    'r': 'red',
    'y': 'yellow',
    'p': 'pink',
    's': 'send',
    'f': 'fin',
    ' ': 'empty',
}

def parse_chart(text: str) -> list:
    beats = []
    beat_number = 1

    # Match either color+row (b2, r1) or standalone s/space (no row)
    tokens = re.findall(r'([brpy])(\d)|([sf ])', text)

    for token in tokens:
        color_char, row_str, lone = token
        if lone:
            if lone == "s":
                beats.append({
                    "beat": beat_number,
                    "type": COLOR_MAP[lone],
                    "row": 5
                    
                })
            elif lone == "f":
                beats.append({
                    "beat": beat_number,
                    "type": COLOR_MAP[lone],
                    "row": 0
                })
                break 
            else :
                beats.append({
                    "beat": beat_number,
                    "type": COLOR_MAP[lone],
                    "row": 0
                    
                })
        else:
            beats.append({
                "beat": beat_number,
                "type": COLOR_MAP[color_char],
                "row": int(row_str)
            })
        beat_number += 1

    return beats

def txt_to_chart(txt_path: str, output_path: str):
    with open(txt_path, 'r') as f:
        raw = f.read()

    text = raw.replace('\n', ' ').replace('\r', '')
    beats = parse_chart(text)

    chart = {"beats": beats}

    with open(output_path, 'w') as f:
        json.dump(chart, f, indent=2)

    print(f"Done → {output_path} ({len(beats)} beats)")

txt_to_chart("act2_chart.txt", "act2_chart.json")
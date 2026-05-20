import json
import sys


def convert_dialogue_txt_to_json(input_path: str, output_path: str):
    with open(input_path, "r", encoding="utf-8-sig") as file:
        lines = file.readlines()

    result = {}

    for raw_line in lines:
        line = raw_line.strip()

        if not line:
            continue

        speaker = line[0]
        content = line[1:].strip()

        sentence_parts = [
            p.strip()
            for p in content.split("/")
            if p.strip()
        ]

        if speaker not in result:
            result[speaker] = []

        for i, sentence in enumerate(sentence_parts):

            is_end = "yes" if i == len(sentence_parts) - 1 else "no"

            # P => array of words
            if speaker == "P":
                formatted_sentence = sentence.split()

            # R => plain string
            else:
                formatted_sentence = sentence

            result[speaker].append({
                "is_end": is_end,
                "sentence": formatted_sentence
            })

    final_result = []

    for speaker, dialogue in result.items():
        final_result.append({
            "speaker": speaker,
            "dialogue": dialogue
        })

    with open(output_path, "w", encoding="utf-8") as file:
        json.dump(
            final_result,
            file,
            indent=4,
            ensure_ascii=False
        )

    print(f"Generated: {output_path}")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage:")
        print("python dialogue_to_json.py input.txt output.json")
    else:
        convert_dialogue_txt_to_json(
            sys.argv[1],
            sys.argv[2]
        )
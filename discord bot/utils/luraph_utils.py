import json

with open("utils/config.json", "r") as f:
    config = json.load(f)

def replace_username(path: str, line: int, username: str):
    lines = open(path, 'r').readlines()
    text_on_line = lines[line].split('"')
    text_on_line[1] = f"{username}"
    lines[line] = f"local username                  = \"{text_on_line[1]}\"\n"
    out = open(path, 'w')
    out.writelines(lines)
    out.close()
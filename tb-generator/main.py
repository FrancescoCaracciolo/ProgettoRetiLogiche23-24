import random


def generate_sequence(k: int) -> list:
    result = []
    for i in range(0, k):
        if random.randint(0,100) > 60:
            w = 0
        else:
            w = random.randint(0, 255)
        result.append(w)
        result.append(0)
    return result

def sequence_result(sequence: list) -> list:
    k = len(sequence)
    last_valid_value = 0
    confidence = 0
    if k%2 != 0:
        return [];
    result = []
    for i in range(0, k):
        if i % 2 == 0:
            if sequence[i] == 0:
                result.append(last_valid_value)
                confidence = confidence-1 if confidence > 0 else 0
            else:
                result.append(sequence[i])
                last_valid_value = sequence[i]
                confidence = 31
        else:
            result.append(confidence)
    return result

def replace_demo_file(sequence: list, file: str, output: str, tb_name: str):
    f = open(file, "r")
    content = f.read()
    content = content.replace("{scenario_input}", get_vhdl_array(sequence))
    content = content.replace("{scenario_output}", get_vhdl_array(sequence_result(sequence)))
    content = content.replace("{scenario_length}", str(round(len(sequence)/2)))
    content = content.replace("{tb_name}", tb_name)
    f.close()
    f = open(output, "w+")
    f.write(content)
    f.close()

def get_vhdl_array(sequence: list):
    result = "("
    result += ", ".join(str(num) for num in sequence)
    result += ")"
    return result

sequence = generate_sequence(10)
print(sequence)
print(sequence_result(sequence))
replace_demo_file(sequence, "templates/ex_tb.vhd", "reset_in_operation.vhd", "reset_in_operation_tb")
#DEMO_SEQUENCE = [128, 0, 64, 0, 0, 0, 0, 0, 0, 0,0,0, 100, 0, 1, 0, 0, 0, 5, 0, 23, 0, 200, 0, 0, 0]



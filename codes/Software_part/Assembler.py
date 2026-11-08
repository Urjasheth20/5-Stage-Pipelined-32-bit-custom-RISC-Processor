
import sys
import re
from pathlib import Path

OPCODES = {
    "ADD":  0b0000,
    "SUB":  0b0001,
    "AND":  0b0010,
    "OR":   0b0011,
    "NAND": 0b0100,
    "NOR":  0b0101,
}

I_TYPE_OPCODES = {
    "ADDI":  "ADD",
    "SUBI":  "SUB",
    "ANDI":  "AND",
    "ORI":   "OR",
    "NANDI": "NAND",
    "NORI":  "NOR",
}

INSTRUCTION_TYPE_R = 0b000
INSTRUCTION_TYPE_I = 0b001
INSTRUCTION_TYPE_MEM = 0b010
INSTRUCTION_TYPE_BRANCH = 0b011
INSTRUCTION_TYPE_JUMP = 0b100
INSTRUCTION_TYPE_HALT = 0b101

LOAD_OPCODE = 0b0000
STORE_OPCODE = 0b0001

BRANCH_OPCODE = {
    "BEQ": 0b0000,
    "BNE": 0b0001,
    "BNEQ": 0b0001,
}


def parse_register(register):
    register = register.strip().upper()

    if not register.startswith("R"):
        raise ValueError(f"Invalid register: {register}")

    try:
        number = int(register[1:])
    except ValueError:
        raise ValueError(f"Invalid register: {register}")

    if not 0 <= number <= 15:
        raise ValueError(
            f"Register {register} is out of range. Use R0-R15."
        )

    return number


def parse_immediate(value, line_number):
    try:
        immediate = int(value, 0)
    except ValueError:
        raise ValueError(
            f"Line {line_number}: Invalid immediate '{value}'"
        )

    if not -(1 << 16) <= immediate < (1 << 16):
        raise ValueError(
            f"Line {line_number}: Immediate must be "
            "between -65536 and 65535."
        )

    return immediate & 0x1FFFF


def remove_comment(line):
    line = line.split("#", 1)[0]
    line = line.split("//", 1)[0]
    return line.strip()


def assemble_r_type(parts, line_number):
    if len(parts) != 4:
        raise ValueError(
            f"Line {line_number}: Expected MNEMONIC Rd, Rs1, Rs2"
        )

    mnemonic = parts[0].upper()
    rd = parse_register(parts[1])
    rs1 = parse_register(parts[2])
    rs2 = parse_register(parts[3])

    return (
        (INSTRUCTION_TYPE_R << 29)
        | (OPCODES[mnemonic] << 25)
        | (rd << 21)
        | (rs1 << 17)
        | (rs2 << 13)
    )


def assemble_i_type(parts, line_number):
    if len(parts) != 4:
        raise ValueError(
            f"Line {line_number}: Expected MNEMONIC Rd, Rs1, Immediate"
        )

    mnemonic = parts[0].upper()
    operation = I_TYPE_OPCODES[mnemonic]

    rd = parse_register(parts[1])
    rs1 = parse_register(parts[2])
    immediate = parse_immediate(parts[3], line_number)

    return (
        (INSTRUCTION_TYPE_I << 29)
        | (OPCODES[operation] << 25)
        | (rd << 21)
        | (rs1 << 17)
        | immediate
    )


def assemble_memory(parts, line_number):
    mnemonic = parts[0].upper()

    if len(parts) != 3:
        raise ValueError(
            f"Line {line_number}: Expected "
            "LOAD Rd, offset(Rbase) or STORE Rs, offset(Rbase)"
        )

    register = parse_register(parts[1])

    match = re.fullmatch(
        r"\s*([+-]?(?:0[xX][0-9a-fA-F]+|\d+))\s*"
        r"\(\s*(R\d+)\s*\)\s*",
        parts[2],
        re.IGNORECASE,
    )

    if not match:
        raise ValueError(
            f"Line {line_number}: Invalid memory operand "
            f"'{parts[2]}'. Use offset(Rbase), e.g. 4(R1)."
        )

    offset_text, base_text = match.groups()
    offset = parse_immediate(offset_text, line_number)
    base = parse_register(base_text)

    if mnemonic == "LOAD":
        opcode = LOAD_OPCODE
        field_1 = register
        field_2 = base
    else:
        opcode = STORE_OPCODE
        field_1 = base
        field_2 = register

    return (
        (INSTRUCTION_TYPE_MEM << 29)
        | (opcode << 25)
        | (field_1 << 21)
        | (field_2 << 17)
        | offset
    )


def resolve_address(target, labels, line_number):
    target = target.upper()

    if target in labels:
        address = labels[target]
    else:
        try:
            address = int(target, 0)
        except ValueError:
            raise ValueError(
                f"Line {line_number}: Undefined label '{target}'"
            )

    if not 0 <= address <= 0x1FFFF:
        raise ValueError(
            f"Line {line_number}: Target address must be "
            "between 0 and 131071."
        )

    if address % 4 != 0:
        raise ValueError(
            f"Line {line_number}: Target address must be 4-byte aligned."
        )

    return address


def assemble_branch(parts, line_number, labels):
    if len(parts) != 4:
        raise ValueError(
            f"Line {line_number}: Expected BEQ/BNE Rs1, Rs2, Label"
        )

    mnemonic = parts[0].upper()
    rs1 = parse_register(parts[1])
    rs2 = parse_register(parts[2])
    address = resolve_address(parts[3], labels, line_number)

    return (
        (INSTRUCTION_TYPE_BRANCH << 29)
        | (BRANCH_OPCODE[mnemonic] << 25)
        | (rs1 << 21)
        | (rs2 << 17)
        | address
    )


def assemble_jump(parts, line_number, labels):
    if len(parts) != 2:
        raise ValueError(
            f"Line {line_number}: Expected JUMP Label"
        )

    address = resolve_address(parts[1], labels, line_number)

    return (INSTRUCTION_TYPE_JUMP << 29) | address


def assemble_halt(parts, line_number):
    if len(parts) != 1:
        raise ValueError(
            f"Line {line_number}: HALT does not take operands."
        )

    return INSTRUCTION_TYPE_HALT << 29


def assemble_instruction(line, line_number, labels):
    line = remove_comment(line)

    if not line:
        return None

    if ":" in line:
        _, line = line.split(":", 1)
        line = line.strip()

    if not line:
        return None

    parts = line.replace(",", " ").split()
    mnemonic = parts[0].upper()

    if mnemonic in OPCODES:
        return assemble_r_type(parts, line_number)

    if mnemonic in I_TYPE_OPCODES:
        return assemble_i_type(parts, line_number)

    if mnemonic in ("LOAD", "STORE"):
        return assemble_memory(parts, line_number)

    if mnemonic in BRANCH_OPCODE:
        return assemble_branch(parts, line_number, labels)

    if mnemonic == "JUMP":
        return assemble_jump(parts, line_number, labels)

    if mnemonic == "HALT":
        return assemble_halt(parts, line_number)

    raise ValueError(
        f"Line {line_number}: Unsupported instruction '{mnemonic}'"
    )


def first_pass(lines):
    labels = {}
    instruction_count = 0

    for line_number, original_line in enumerate(lines, start=1):
        line = remove_comment(original_line)

        if not line:
            continue

        while ":" in line:
            label, line = line.split(":", 1)
            label = label.strip().upper()

            if not re.fullmatch(r"[A-Z_][A-Z0-9_]*", label):
                raise ValueError(
                    f"Line {line_number}: Invalid label '{label}'"
                )

            if label in labels:
                raise ValueError(
                    f"Line {line_number}: Duplicate label '{label}'"
                )

            labels[label] = instruction_count * 4
            line = line.strip()

            if not line:
                break

        if line:
            instruction_count += 1

    return labels


def write_program_mem(instructions, output_file):
    output_file.parent.mkdir(parents=True, exist_ok=True)

    with output_file.open("w", encoding="utf-8") as file:
        for instruction in instructions:
            for shift in (0, 8, 16, 24):
                byte = (instruction >> shift) & 0xFF
                file.write(f"{byte:08b}\n")


def main():
    if len(sys.argv) != 3:
        print("Usage: python assembler.py input.asm output.mem")
        sys.exit(1)

    input_file = Path(sys.argv[1])
    output_file = Path(sys.argv[2])

    try:
        with input_file.open("r", encoding="utf-8") as file:
            lines = file.readlines()

        labels = first_pass(lines)
        instructions = []

        for line_number, line in enumerate(lines, start=1):
            instruction = assemble_instruction(
                line, line_number, labels
            )

            if instruction is not None:
                instructions.append(instruction)

        write_program_mem(instructions, output_file)

    except (OSError, ValueError) as error:
        print(f"Assembler error: {error}")
        sys.exit(1)

    print(f"Assembled {len(instructions)} instructions.")
    print(f"Output written to: {output_file}")

    if labels:
        print("\nLabels:")
        for label, address in labels.items():
            print(f"{label} = {address}")


if __name__ == "__main__":
    main()

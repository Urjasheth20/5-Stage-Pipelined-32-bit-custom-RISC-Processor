import sys
from pathlib import Path

# R-type instruction opcodes.
# IMPORTANT: Update these values to match your ALU.v.
OPCODES = {
    "ADD": 0b0000,
    "SUB": 0b0001,
    "AND": 0b0010,
    "OR":  0b0011,
    "NAND": 0b0100,
    "NOR": 0b0101,
}

INSTRUCTION_TYPE_R = 0b000


def parse_register(register):
    """Convert R0-R15 into a 4-bit register number."""
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


def assemble_r_type(line, line_number):
    """Encode one R-type instruction into a 32-bit word."""
    # Remove comments and whitespace.
    line = line.split("#", 1)[0].strip()

    if not line:
        return None

    parts = line.replace(",", " ").split()
    mnemonic = parts[0].upper()

    if mnemonic not in OPCODES:
        raise ValueError(
            f"Line {line_number}: Unsupported instruction '{mnemonic}'"
        )

    if len(parts) != 4:
        raise ValueError(
            f"Line {line_number}: Expected "
            "'MNEMONIC Rd, Rs1, Rs2'"
        )

    rd = parse_register(parts[1])
    rs1 = parse_register(parts[2])
    rs2 = parse_register(parts[3])

    instruction = (
        (INSTRUCTION_TYPE_R << 29)
        | (OPCODES[mnemonic] << 25)
        | (rd << 21)
        | (rs1 << 17)
        | (rs2 << 13)
    )

    return instruction


def write_program_mem(instructions, output_file):
    """Write each instruction as four little-endian bytes."""
    with open(output_file, "w", encoding="utf-8") as file:
        for instruction in instructions:
            for shift in (0, 8, 16, 24):
                byte = (instruction >> shift) & 0xFF
                file.write(f"{byte:08b}\n")


def main():
    if len(sys.argv) != 3:
        print(
            "Usage: python assembler.py input.asm output.mem"
        )
        sys.exit(1)

    input_file = Path(sys.argv[1])
    output_file = Path(sys.argv[2])

    instructions = []

    try:
        with input_file.open("r", encoding="utf-8") as file:
            for line_number, line in enumerate(file, start=1):
                instruction = assemble_r_type(line, line_number)

                if instruction is not None:
                    instructions.append(instruction)

        write_program_mem(instructions, output_file)

    except (OSError, ValueError) as error:
        print(f"Assembler error: {error}")
        sys.exit(1)

    print(f"Assembled {len(instructions)} instructions.")
    print(f"Output written to: {output_file}")


if __name__ == "__main__":
    main()

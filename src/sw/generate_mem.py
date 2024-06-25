# File: generate_zeros_mem.py
# Description: Generate a zeros.mem file with all 0s.

def generate_zeros_mem(filename, num_lines):
    with open(filename, 'w') as file:
        for _ in range(num_lines):
            file.write("0000\n")

# Parameters
output_file = "../rtl/student/zeros.mem"
number_of_lines = 2 ** 16  # 65536 lines for a 16-bit address width

# Generate the file
generate_zeros_mem(output_file, number_of_lines)

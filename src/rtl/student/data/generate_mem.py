# File: generate_zeros_mem.py
# Description: Generate a zeros.mem file with all 0s.

def generate_zeros_mem(filename, num_lines):
    with open(filename, 'w') as file:
        for _ in range(num_lines):
            file.write("00\n")

# Parameters
output_file = "./random.mem"
number_of_lines = 2**10  # 1024 lines for a 10-bit address width

# Generate the file
generate_zeros_mem(output_file, number_of_lines)

import random

# Function to generate a .mem file with random two-digit numbers
def generate_random_mem(filename, num_lines):
    with open(filename, 'w') as file:
        for _ in range(num_lines):
            random_number = random.randint(0, 255)  # Generate a random number between 0 and 255
            hex_number = f"{random_number:02x}"  # Convert to 2-digit hexadecimal
            file.write(f"{hex_number}\n")

# Parameters
output_file = "./random.mem"
number_of_lines = 2**10  # 1024 lines for a 10-bit address width

# Generate the file
generate_random_mem(output_file, number_of_lines)

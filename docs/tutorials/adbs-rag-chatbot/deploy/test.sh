#!/bin/bash

# Test case 1: All steps selected
echo "Test Case 1: All steps selected"
./deploy.sh <<< "y
y
y
y
y
y
y
y
y
y
y"

# Expected Output:
# All steps should be executed successfully

# Test case 2: No steps selected
echo "\n\nTest Case 2: No steps selected"
./deploy.sh <<< "n
n
n
n
n
n
n
n
n
n"

# Expected Output:
# All steps should be skipped

# Test case 3: Only Windows VM creation selected
echo "\n\nTest Case 3: Only Windows VM creation selected"
./deploy.sh <<< "n
n
n
n
n
y
n
n
n
n"

# Expected Output:
# Only Windows VM creation step should be executed successfully
# Other steps should be skipped

# Test case 4: Windows VM creation selected, but subsequent steps not selected
echo "\n\nTest Case 4: Windows VM creation selected, but subsequent steps not selected"
./deploy.sh <<< "n
n
n
n
n
y
n
n
n
n"

# Expected Output:
# Windows VM creation step should be executed successfully
# Describe Windows VM and Reset Windows password steps should be skipped
# Other steps should be executed successfully

# Test case 5: Invalid input provided
echo "\n\nTest Case 5: Invalid input provided"
./deploy.sh <<< "abc
def
ghi
jkl
mno
pqr
stu
vwx
yz"

# Expected Output:
# Script should fail with an error message indicating invalid input
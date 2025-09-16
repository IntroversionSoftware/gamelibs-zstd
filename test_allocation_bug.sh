#!/bin/bash
echo "=== Test to show allocation bug with negative totalSizeToLoad ==="
echo ""
echo "We need at least 5 samples to pass the minimum check"
echo ""

# Clean up
rm -rf alloc_test
mkdir alloc_test

# Create exactly 5 valid files (minimum to not exit early)
echo "Creating 5 valid files (minimum required)..."
for i in {1..5}; do
    echo "data$i" > alloc_test/good_$i.txt
done

echo "Valid files created (about 6 bytes each = 30 bytes total)"
echo ""

# We need enough bad files to make totalSizeToLoad negative
# 30 bytes positive, so we need at least 31 bad files
echo "Adding 1000 non-existent files to make totalSizeToLoad very negative..."
echo "Expected: totalSizeToLoad = 30 + (1000 * -1) = -970 bytes"
echo ""

# Build command
CMD="./zstd --train alloc_test/good_*.txt"
for i in {1..1000}; do
    CMD="$CMD alloc_test/BAD_$i"
done
CMD="$CMD -o alloc_test/dict.zst --maxdict=65536 2>&1"

echo "Running command..."
echo "================="

# Run and capture ALL debug output related to our issue
eval $CMD | grep -E "\[DEBUG FINAL\]|\[DEBUG\] Memory calc|\[BUG\]|About to malloc|Error|not enough memory" 

echo ""
echo "Output should show something like the following:"
echo "1. [DEBUG FINAL] fileStats: totalSizeToLoad=-970 (NEGATIVE!)"
echo "2. [BUG] totalSizeToLoad is NEGATIVE!"
echo "3. [DEBUG] Memory calc: showing huge loadedSize value"
echo "4. Error about memory allocation"

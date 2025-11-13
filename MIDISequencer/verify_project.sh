#!/bin/bash

# Xcode project file verification script

echo "====================================="
echo "  Xcode Project File Validator"
echo "====================================="
echo ""

PROJECT_FILE="MIDISequencer.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Error: Project file not found!"
    exit 1
fi

echo "✅ Project file found: $PROJECT_FILE"
echo ""

# Extract all IDs
echo "📊 Extracting all object IDs..."
echo ""

# Build Phase IDs
echo "=== Build Phase IDs ==="
grep -E "(B1[0-9A-F]{6}) /\* (Frameworks|Resources|Sources) \*/ = \{" "$PROJECT_FILE" | \
    sed -E 's/[[:space:]]+(B1[0-9A-F]{6}) \/\* ([^*]+) \*\/.*/\1 -> \2/' | \
    while read id name; do
        echo "  $id -> $name"
    done
echo ""

# Group IDs
echo "=== Group IDs ==="
grep -E "(B1[0-9A-F]{6}) /\* [^*]+ \*/ = \{" "$PROJECT_FILE" | \
    grep "isa = PBXGroup" -B 1 | \
    grep "B1" | \
    sed -E 's/[[:space:]]+(B1[0-9A-F]{6}) \/\* ([^*]+) \*\/.*/\1 -> \2/' | \
    while read id name; do
        echo "  $id -> $name"
    done
echo ""

# Check for duplicates
echo "🔍 Checking for duplicate IDs..."
echo ""

ALL_IDS=$(grep -oE "B1[0-9A-F]{6}" "$PROJECT_FILE" | sort)
UNIQUE_IDS=$(echo "$ALL_IDS" | uniq)
DUPLICATES=$(echo "$ALL_IDS" | uniq -d)

if [ -z "$DUPLICATES" ]; then
    echo "✅ No duplicate IDs found!"
else
    echo "❌ Found duplicate IDs:"
    echo "$DUPLICATES"
    exit 1
fi
echo ""

# Check for specific conflicts
echo "🔍 Checking for Group/BuildPhase conflicts..."
echo ""

BUILD_PHASE_IDS=$(grep -E "(B1[0-9A-F]{6}) /\* (Frameworks|Resources|Sources) \*/ = \{" "$PROJECT_FILE" | \
    sed -E 's/[[:space:]]+(B1[0-9A-F]{6}).*/\1/')

GROUP_IDS=$(grep "isa = PBXGroup" -B 1 "$PROJECT_FILE" | \
    grep -oE "B1[0-9A-F]{6}")

CONFLICTS=0
for bp_id in $BUILD_PHASE_IDS; do
    if echo "$GROUP_IDS" | grep -q "$bp_id"; then
        echo "❌ Conflict found: $bp_id is used in both Group and BuildPhase"
        CONFLICTS=$((CONFLICTS + 1))
    fi
done

if [ $CONFLICTS -eq 0 ]; then
    echo "✅ No Group/BuildPhase conflicts found!"
else
    echo "❌ Found $CONFLICTS conflicts"
    exit 1
fi
echo ""

echo "====================================="
echo "  ✅ Project file is valid!"
echo "====================================="

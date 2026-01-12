#!/bin/bash

echo "🔍 Debugging Test Issues..."
echo "=========================="

# Function to run a single test with detailed output
debug_test() {
    local test_file="$1"
    local test_name="$2"
    
    echo ""
    echo "🧪 Testing: $test_name"
    echo "File: $test_file"
    echo "-------------------"
    
    # Try to run the test with a short timeout
    if timeout 30s dart test "$test_file" 2>&1 | head -20; then
        echo "✅ Test completed within 30 seconds"
    else
        echo "⏰ Test timed out or failed"
        echo ""
        echo "🔍 Checking if dart process is still running..."
        if pgrep dart > /dev/null; then
            echo "❌ Dart process still running - killing it"
            pkill dart
        else
            echo "✅ No dart processes found"
        fi
    fi
    
    echo ""
    echo "================================"
}

# Test the most critical files one by one
debug_test "test/process_manager/process_manager_test.dart" "Process Manager (Saga)"

debug_test "test/domain/patterns/filter/message_filter_test.dart" "Message Filter"

debug_test "test/domain/patterns/integration_test.dart" "Integration Patterns"

echo ""
echo "🧪 Quick syntax check..."
echo "dart analyze --fatal-infos ."
dart analyze --fatal-infos . | head -10

echo ""
echo "✨ Debug complete!"
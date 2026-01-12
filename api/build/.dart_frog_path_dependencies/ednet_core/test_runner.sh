#!/bin/bash

echo "🧪 Running EDNet Core Tests..."
echo "================================"

# Set a timeout to prevent infinite loops
TIMEOUT=120  # 2 minutes

# Function to run tests with timeout and parse results
run_tests() {
    local test_path="$1"
    local test_name="$2"
    
    echo -n "Testing $test_name... "
    
    # Run dart test with timeout
    if timeout ${TIMEOUT}s dart test "$test_path" 2>/dev/null | tail -1 | grep -q "All tests passed!"; then
        echo "✅ OK"
        return 0
    else
        echo "❌ FAILED"
        echo "  Running detailed analysis..."
        
        # Get more details on what failed
        timeout ${TIMEOUT}s dart test "$test_path" 2>&1 | grep -E "(FAILED|Error|Exception|expected|actual)" | head -5
        return 1
    fi
}

# Run individual test categories
echo ""
echo "📋 Individual Test Categories:"
echo "------------------------------"

run_tests "test/process_manager/process_manager_test.dart" "Process Manager (Saga)"
run_tests "test/domain/patterns/filter/message_filter_test.dart" "Message Filters"
run_tests "test/domain/patterns/integration_test.dart" "Integration Patterns"
run_tests "test/commands/add_command_test.dart" "Add Commands"
run_tests "test/commands/remove_command_test.dart" "Remove Commands"

echo ""
echo "🔍 Full Test Suite:"
echo "-------------------"

# Run full test suite with timeout
echo -n "Running all tests... "
if timeout ${TIMEOUT}s dart test 2>/dev/null >/tmp/test_output.log; then
    # Check if it completed successfully
    if grep -q "All tests passed!" /tmp/test_output.log; then
        echo "✅ ALL OK"
        echo ""
        echo "📊 Summary:"
        tail -3 /tmp/test_output.log | grep -E "(\+[0-9]+|\-[0-9]+|~[0-9]+)" | tail -1
    else
        echo "❌ SOME FAILED"
        echo ""
        echo "📊 Final Status:"
        tail -3 /tmp/test_output.log
    fi
else
    echo "⏰ TIMEOUT (possible infinite loop)"
    echo ""
    echo "🔍 Last test output before timeout:"
    tail -10 /tmp/test_output.log | grep -E "test/" | tail -3
fi

# Cleanup
rm -f /tmp/test_output.log

echo ""
echo "✨ Test run complete!"
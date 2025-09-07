-- Simple test runner for the mod
-- Run this file to execute all tests

print("Renewable Fireflies Mod - Test Suite")
print("====================================")

-- Load and run tests
local testFramework = require("tests/test_firefly_logic")
testFramework.runTests()

print("Test suite completed.")
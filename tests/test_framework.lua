local TestFramework = {}

TestFramework.tests = {}
TestFramework.passed = 0
TestFramework.failed = 0

function TestFramework.assert(condition, message)
    if not condition then
        error("Assertion failed: " .. (message or "no message"))
    end
end

function TestFramework.assertEquals(expected, actual, message)
    if expected ~= actual then
        local msg = string.format("Expected %s, got %s", tostring(expected), tostring(actual))
        if message then
            msg = message .. ": " .. msg
        end
        error("Assertion failed: " .. msg)
    end
end

function TestFramework.test(name, testFunc)
    table.insert(TestFramework.tests, {name = name, func = testFunc})
end

function TestFramework.runTests()
    print("Running tests...")
    TestFramework.passed = 0
    TestFramework.failed = 0
    
    for _, test in ipairs(TestFramework.tests) do
        local success, error = pcall(test.func)
        if success then
            print("✓ " .. test.name)
            TestFramework.passed = TestFramework.passed + 1
        else
            print("✗ " .. test.name .. ": " .. tostring(error))
            TestFramework.failed = TestFramework.failed + 1
        end
    end
    
    print(string.format("Tests completed: %d passed, %d failed", TestFramework.passed, TestFramework.failed))
end

return TestFramework
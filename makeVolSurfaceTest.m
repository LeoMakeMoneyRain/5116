function tests = volSurfaceTest
  tests = functiontests(localfunctions);
end

function test1(testCase)
  verifyEqual(testCase, 1, 1);
end

function test2(testCase)
  verifyEqual(testCase, 0, 0);
end

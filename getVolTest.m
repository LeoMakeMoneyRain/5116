function tests = volTest
  tests = functiontests(localfunctions);
end

function testGetVol(testCase)
  [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
  tau = 0;
  Ts = days / 365;
  fwd = 50;
  domCurve = makeDepoCurve(Ts, domdfs);
  forCurve = makeDepoCurve(Ts, fordfs);
  fwdCurve = makeFwdCurve(domCurve, forCurve, fwd, tau);
  volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
  [vol, f] = getVol(volSurface, 0, fwd);
  verifyTrue(testCase, abs(vol-0.19999) < 1e-5);
  verifyTrue(testCase, abs(f-fwd) < 1e-8);
end

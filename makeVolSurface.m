% Inputs:
%    fwdCurve: forward curve data
%    Ts: vector of expiry times
%    cps: vetor of 1 for call, -1 for put
%    deltas: vector of delta in absolute value (e.g. 0.25)
%    vols: matrix of volatilities
% Output:
%    surface: a struct containing data needed in getVol
function volSurf = makeVolSurface(fwdCurve, Ts, cps, deltas, vols)
  n = numel(Ts);
  Ts = Ts.';
  % assigning the last element first
  for m=n:-1:1
    fwdSpots(m) = getFwdSpot(fwdCurve, Ts(m));
    smiles(m) = makeSmile(fwdCurve, Ts(m), cps, deltas, vols(m,:));
    spotVols(m) = getSmileVol(smiles(m), fwdSpots(m));
  end

  % check arbitrage
  x = spotVols .* spotVols .* Ts;
  if ~issorted(x)
    error('makeVolSurface:ArbitrageError', 'There is a calendar spread abitrage opportunity');
  end
  volSurf = struct('Ts', Ts.', 'smiles', smiles, 'fwdSpots', fwdSpots, 'fwdCurve', fwdCurve);
end

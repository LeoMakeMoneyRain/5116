% Inputs:
%    volSurf: volatility surface data
%    T: time to expiry of the option
%    Ks: vector of strikes
% Output:
%    vols: vector of volatilities
%    fwd: forward spot price for maturity T
function [vols, fwd] = getVol(volSurf, T, Ks)
  smiles = volSurf.smiles;
  fwdSpots = volSurf.fwdSpots;
  Ts = volSurf.Ts;  
  fwd = getFwdSpot(volSurf.fwdCurve, T);
  Ms = Ks ./ fwd;
  if T <= Ts(1)
    K1 = Ms .* fwdSpots(1);
    vols = getSmileVol(smiles(1), K1);
  elseif T <= Ts(end)
    m = lowerBound(Ts, T);
    Ki = Ms .* fwdSpots(m);
    Kj = Ms .* fwdSpots(m+1);
    sigmaKi = getSmileVol(smiles(m), Ki);
    sigmaKj = getSmileVol(smiles(m+1), Kj);
    interval = Ts(m+1) - Ts(m);
    varT = ((Ts(m+1) - T)/interval) .* sigmaKi .* sigmaKi .* Ts(m) ...
        + ((T - Ts(m))/interval).* sigmaKj .* sigmaKj .* Ts(m+1);
    vols = sqrt(varT/T);
  else
    error('getVol:TenorBeyondRangeError', 'T is beyond last Tenor');
  end
end

function index = lowerBound(arr, x)
  l = 1;
  n = numel(arr);
  while l <= n
    m = fix((l+n)/2);
    if arr(m) <= x
      l = m+1;
    else
      n = m-1;
    end
  end
  index = n;
end

function zoomInToEstimationArea(deviceLoc, xC, yC, xO, yO, leg)
% Zoom 2D plane into region around device location
  allX = [deviceLoc(1); xO(:); xC(:)];
  allY = [deviceLoc(2); yO(:); yC(:)];
  minX = min(allX);
  maxX = max(allX);
  minY = min(allY);
  maxY = max(allY);
  axis([ ...
      minX-0.1*(maxX-minX), ...
      maxX+0.1*(maxX-minX), ...
      minY-0.1*(maxY-minY), ...
      maxY+0.1*(maxY-minY)])
  leg.Location = 'NorthEast';
end
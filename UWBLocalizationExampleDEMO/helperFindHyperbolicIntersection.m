function [xC, yC] = helperFindHyperbolicIntersection(xCell, yCell)
% HELPERFINDHYPERBOLICINTERSECTION Find intersection point(s) between 3 hyperbolas

% Copyright 2021 The MathWorks, Inc.

% A. Find closest points between hyperbolic surfaces.
% B. Linearize surfaces around their points closest to intersection, to
% interpolate actual intersection location.

numCurves = numel(xCell); % Number of array elements
% Make all vectors have equal length
maxLen = max(cellfun(@length, xCell)); % Apply function to each cell in cell array


% Loop for each hyperbole

% Dans chaque itération, les vecteurs xCell{curveIdx} et yCell{curveIdx} sont étendus 
% en ajoutant des valeurs infinies (inf) pour que tous les vecteurs aient la même longueur 
% maxLen. Cela est nécessaire pour standardiser la taille des vecteurs avant de calculer 
% les intersections.
for curveIdx = 1:numCurves
    xCell{curveIdx} = [xCell{curveIdx} inf(1, maxLen-length(xCell{curveIdx}))];
    yCell{curveIdx} = [yCell{curveIdx} inf(1, maxLen-length(yCell{curveIdx}))];
end

tempIdx = 1;

% preallocate les vecteurs xC et yC qui stockeront les coordonnées x et y des points d'intersection.
% Le nombre d'intersections possibles entre les hyperboles est donné par la combinaison de 
% deux hyperboles prises parmi numCurves, donc (numCurves*(numCurves-1)/2)
[xC, yC] = deal(zeros(1, numCurves*(numCurves-1)/2)); 

for idx1 = 1:numCurves-1
    for idx2 = (idx1+1):numCurves

        % appelée pour obtenir les points les plus proches (ou des segments de meilleure approximation) entre 
        % deux hyperboles spécifiques. Elle retourne deux ensembles de points (firstCurve et secondCurve).
        [firstCurve,secondCurve] = findMinDistanceElements(xCell{idx1},yCell{idx1},xCell{idx2},yCell{idx2});
        
        % Pour chaque paire de points (ou segment) retournée par findMinDistanceElements, les coefficients linéaires 
        % (a1, b1 pour la première hyperbole et a2, b2 pour la seconde) sont calculés pour former des équations de 
        % lignes (sous forme affine y = mx + c).
        for idx3 = 1:numel(firstCurve)
            [x1a,y1a,x1b,y1b] = deal(firstCurve{idx3}(1,1),firstCurve{idx3}(1,2), ...
                                     firstCurve{idx3}(2,1),firstCurve{idx3}(2,2));
            [x2a,y2a,x2b,y2b] = deal(secondCurve{idx3}(1,1),secondCurve{idx3}(1,2), ...
                                     secondCurve{idx3}(2,1),secondCurve{idx3}(2,2));
           
            % expression de la pente, de la forme k = (y2 - y1) / (x2 - x2)
            a1 = (y1b-y1a)/(x1b-x1a);
            b1 = y1a - a1*x1a;

            a2 = (y2b-y2a)/(x2b-x2a);
            b2 = y2a - a2*x2a;

            xC(tempIdx) = (b2-b1)/(a1-a2);
                        
            % de la forme : x * k + y ou a * x + b , fonction affine
            yC(tempIdx) = a1*xC(tempIdx) + b1;
            tempIdx = tempIdx+1;
        end
    end
end

numEstimations = numCurves*(numCurves-1)/2;     % Cette ligne calcule le nombre total d'intersections possibles entre les hyperboles.
[xC, order] = sort(xC);                         % Trie les coordonnées x des intersections stockées dans xC en ordre croissant.
xC = reshape(xC, numEstimations, [])';          % Cette ligne redimensionne le vecteur xC en une matrice ayant numEstimations lignes.
yC = reshape(yC(order), numEstimations, [])';   % redimesionne le vecteur yC
end

function [firstCurvePoints,secondCurvePoints] = findMinDistanceElements(xA,yA,xB,yB)
%   [FIRSTCURVEPOINTS,SECONDCURVEPOINTS] = findMinDistanceElements(XA,YA,XB,YB)
%   returns the closest points between the given hyperbolic surfaces.

    distAB = zeros(numel(xA),numel(xB)); % Number of array elements
    for idx1 = 1:numel(xA)
        distAB(idx1,:) = sqrt((xB-xA(idx1)).^2 + (yB-yA(idx1)).^2);
    end
    [~,rows] = min(distAB,[],'omitnan');
    [~, col] = min(min(distAB,[],'omitnan'));

    % 1st intersection is the closest distance point. That allows for more
    % accurate intersection points:
    allRows = rows(col);
    allCols = col;

    % Look for possible 2nd intersection 
    % One is identified outside a region around the 1st intersection, if
    % distance is smaller than max distance within that region
    numRegionSamples = 100;
    region = -numRegionSamples:numRegionSamples;    

    % Work with a copy, to still be able to check distAB values later on
    distAB2 = distAB;
    distAB2(allRows+region, col+region) = nan;

    [~,rows2] = min(distAB2,[],'omitnan');
    [minDist2, col2] = min(min(distAB2,[],'omitnan'));
    threshold = 0.1; % m
    if minDist2 < threshold
      allRows = [allRows rows2(col2)];
      allCols = [allCols col2];
    end

    for idx = 1:numel(allRows)
        firstCurveIndices = allRows(idx);
        secondCurveIndices = allCols(idx);
        x1a = xA(firstCurveIndices);
        y1a = yA(firstCurveIndices);
        x2a = xB(secondCurveIndices);
        y2a = yB(secondCurveIndices);

        % Use subsequent points to create line for linearization
        if firstCurveIndices == numel(xA) || distAB(firstCurveIndices-1, secondCurveIndices) < distAB(firstCurveIndices+1, secondCurveIndices)
            x1b = xA(firstCurveIndices-1);
            y1b = yA(firstCurveIndices-1);
        else
            x1b = xA(firstCurveIndices+1);
            y1b = yA(firstCurveIndices+1);
        end

        if secondCurveIndices == numel(xB) || distAB(firstCurveIndices, secondCurveIndices-1) < distAB(firstCurveIndices, secondCurveIndices+1)
            x2b = xB(secondCurveIndices-1);
            y2b = yB(secondCurveIndices-1);
        else
            x2b = xB(secondCurveIndices+1);
            y2b = yB(secondCurveIndices+1);
        end
        firstCurvePoints{idx} = [x1a y1a;x1b y1b]; %#ok<*AGROW> 
        secondCurvePoints{idx} = [x2a y2a;x2b y2b];
    end
end
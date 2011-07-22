function createTrajectory(obj, pickedCellTemp)
%CREATETRAJECTORY Summary of this function goes here
%   Detailed explanation goes here
t = obj.frameId;
pickedCellTempLen = length(pickedCellTemp);
blobsInNextFrameLen = length(obj.blobsGroupedByFrame(t + 1).frameblobs);
if blobsInNextFrameLen ~= 0 && pickedCellTempLen ~= 0
    obj.blobsInNextFrame = obj.blobsGroupedByFrame(t + 1);
    indFrame = zeros(blobsInNextFrameLen, pickedCellTempLen);
    for i = 1 : pickedCellTempLen
        indFrame(:, i) = obj.blobsInNextFrame.queryDistanceTest(pickedCellTemp(i));
        qualifyId = find(indFrame(:, i));
        if i <= obj.QueryTrajLength;
            obj.updateQueryTraj(qualifyId, i);
        else
            obj.updateQueryBlob(qualifyId);
        end
        obj.updateQueryTrajectoryArr();
    end
end
        
end


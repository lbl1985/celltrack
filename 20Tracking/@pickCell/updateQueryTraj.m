function updateQueryTraj(obj, qualifyId, i)
%UPDATEQUERYTRAJ Summary of this function goes here
%   Detailed explanation goes here
for j= 1 : length(qualifyId)
    obj.trajArrCurrFrame(i).add(obj.blobsInNextFrame.frameBlobs(qualifyId(j)));
    obj.updateTmpTrajArr('traj', i);
end


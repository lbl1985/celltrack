function [speed maxSpeed] = calOverallSpeed(trackBlobsObj)
% Input:
% trackBlobsObj:    output from tracking (connected) trajectory
% Output:
% speed:            Average Speed for each tracked trajectory (cell). 
% maxSpeed:         Max Speed of one time instance of one traj (cell).
% Binlong Li        07/July/2012    

nCell = length(trackBlobsObj.DB);
speed = zeros(nCell, 1);
maxSpeed = zeros(nCell, 1);

for i = 1 : nCell
    [speed(i) maxSpeed(i)] = eachCellSpeed(trackBlobsObj.DB{i});
end

end

function [speed maxSpeed] = eachCellSpeed(cellTrack)
% Calculate the time instance speed for each traj(cell).
% Input: 
% cellTrack:    cellData for each traj (cell)
% Output:
% speed:        Average Speed for each tracked trajectory (cell).
% maxSpeed:     Max Speed of one time instance of one traj (cell).

nTime = length(cellTrack.timeIDX);
speedInter = zeros(nTime -1 , 1);

for i = 1 : nTime - 1
    tmpDis = cellTrack.Centroid(i + 1, :) - cellTrack.Centroid(i, :);
    tmpDis = norm(tmpDis);
    tmpTimeDiff = cellTrack.timeIDX(i + 1) - cellTrack.timeIDX(i);
    speedInter(i) = tmpDis / tmpTimeDiff;
end

speed = mean(speedInter);
maxSpeed = max(speedInter);
end
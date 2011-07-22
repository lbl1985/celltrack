function updateQueryTrajectoryArr(obj)
%UPDATEQUERYTRAJECTORYARR Summary of this function goes here
%   Detailed explanation goes here
obj.trajArrCurrFrame = obj.tmpTrajArrCurrFrame;
obj.QueryTrajLength = length(obj.trajArrCurrFrame);
obj.tmpTrajArrCurrFrame = [];

end


function DBMergeDynamics2(obj)
    dbIndex = 1;    timeSearchRadius = 10;
    while dbIndex <= length(obj.DB) - 1
        % if after 10s for one trajecotry vanished, there were no other
        % trajectory shows up. Then directly go to next trajectory as
        % inqury trajectory.
        [qualifyId timeDiff] = qualifyCandidateId(obj, dbIndex, timeSearchRadius);
        if ~isempty(qualifyId)
            % Computer the location at the same time as beginning of
            % candidate trajectories.
            targetLocation = propgateTraj(obj, dbIndex, timeDiff);
            for i = 1 : length(qualifyId)
                % Still not cover the multiple qualified conflit case
                testIndex = qualifyId(i);
                isLocationQualify = checkLocation(obj, targetLocation(i, :), testIndex);
                if isLocationQualify
                     obj.mergeTrajectory(dbIndex, testIndex);
                     % break the seach once find one merge (for now).
                     % 11/Jan/2012
                     break;
                end                    
            end
        end
        
        dbIndex = dbIndex + 1;        
    end
end

function [qualifyId timeDiff] = qualifyCandidateId(obj, dbIndex, timeSearchRadius)
    % If there is no qualified candidate, qualify will be empty. Otherwise,
    % will return the qualified database ID.
    qualifyId = []; timeDiff = [];
    inquery = obj.DB{dbIndex};
    for i = dbIndex + 1 : length(obj.DB)
        if obj.DB{i}.timeIDX(1) > inquery.timeIDX(end)
            candidate = obj.DB{i};
            if candidate.timeIDX(1) <= inquery.timeIDX(end) + timeSearchRadius;        
                qualifyId = cat(1, qualifyId, i);
                timeDiff = cat(1, timeDiff, candidate.timeIDX(1) - inquery.timeIDX(end));
            else
                break;
            end            
        end
    end
    
end

function targetLocation = propgateTraj(obj, dbIndex, timeDiff)
% x_n represent location at time n. x_1 represents the first x location.
% same as y.
% x_step = (x_n - x_1) / (n - 1)
% x_(n+t) = x_n + x_step * t
    inquery = obj.DB{dbIndex};
    nCandidate = length(timeDiff);
    stepSize = (inquery.Centroid(end, :) - inquery.Centroid(1, :)) / ...
        (length(inquery.timeIDX) - 1);
    targetLocation = repmat(inquery.Centroid(end, :), nCandidate, 1) + ...
        repmat(stepSize, nCandidate, 1) .* repmat(timeDiff, 1, 2);
end

function isLocationQualify = checkLocation(obj, targetLocation, testIndex)
%     query = obj.DB{dbIndex};
    test  = obj.DB{testIndex};
%     mov = norm(abs(query.Centroid(end, :) - test.Centroid(1, :)));
    mov = norm(abs(targetLocation - test.Centroid(1, :)));
    isLocationQualify = 0;
    if mov < obj.searchRadius
        isLocationQualify = 1;
    end
end
    
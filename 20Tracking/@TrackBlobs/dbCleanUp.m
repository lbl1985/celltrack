function dbCleanUp(obj, atLeastShownUpThreshold)
    cleanUpOnlyOneAppearance(obj, atLeastShownUpThreshold);
    cleanUpSteady(obj);
%     cleanUpUnConsistent(obj);
end

function cleanUpOnlyOneAppearance(obj, atLeastShownUpThreshold)
    ndb = length(obj.DB);
    keepIndex = true(ndb, 1);
    for i = 1 : ndb
        % Clean trajectories only show up once
%         if length(obj.DB{i}.timeIDX) == 1
        % Clean trajectories only show up once or twice
%         if length(obj.DB{i}.timeIDX) <= 2
        % Clean trajectories for variable number of apperance
        if length(obj.DB{i}.timeIDX) <= atLeastShownUpThreshold
            keepIndex(i) = false;
        end
    end
    obj.DB = obj.DB(keepIndex);
end

function cleanUpUnConsistent(obj)
    ndb = length(obj.DB);
    keepIndex = true(ndb, 1);
    for i = 1 : ndb
        timeIDX = obj.DB{i}.timeIDX;
        timeIDXDiff = timeIDX(2 : end) - timeIDX(1:end - 1);
        if any(timeIDXDiff > 5) || sum(timeIDXDiff == 1) <= 3
            keepIndex(i) = false;
        end
    end
    obj.DB = obj.DB(keepIndex);
end
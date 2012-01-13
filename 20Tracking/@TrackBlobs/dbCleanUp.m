function dbCleanUp(obj)
    cleanUpOnlyOneAppearance(obj);
    cleanUpSteady(obj);
%     cleanUpUnConsistent(obj);
end

function cleanUpOnlyOneAppearance(obj)
    ndb = length(obj.DB);
    keepIndex = true(ndb, 1);
    for i = 1 : ndb
        if length(obj.DB{i}.timeIDX) == 1
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
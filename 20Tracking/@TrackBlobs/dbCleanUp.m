function dbCleanUp(obj)
    cleanUpOnlyOneAppearance(obj);
    cleanUpSteady(obj);
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

function cleanUpSteady(obj)
    ndb = length(obj.DB);
    keepIndex = true(ndb, 1);
    for i = 1 : ndb
        isSteady = checkIsSteady(obj, i);
        if isSteady == 1
            keepIndex(i) = false;
        end
    end
    obj.DB = obj.DB(keepIndex);
end

function isSteady = checkIsSteady(obj, i)
    tmpEntry = obj.DB{i};
    tmpStd = std(tmpEntry.Centroid);
    isSteady = 0;
    if all(tmpStd < obj.steadyCriteria)
        isSteady = 1;
    end
end
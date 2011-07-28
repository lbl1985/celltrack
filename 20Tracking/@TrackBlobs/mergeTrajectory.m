function mergeTrajectory(obj, dbIndex, testIndex)
    query = obj.DB{dbIndex};
    test = obj.DB{testIndex};
    query.timeIDX = vertcat(query.timeIDX, test.timeIDX);
    query.BoundingBox = vertcat(query.BoundingBox, test.BoundingBox);
    query.Centroid = vertcat(query.Centroid, test.Centroid);
    query.Area = vertcat(query.Area, test.Area);
    obj.DB{dbIndex} = query;
    obj.DB{testIndex} = [];
    obj.DB = removeEmptyCell(obj.DB);
end
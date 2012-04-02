function drawAllTrajInOneImage(trackBlobsObj, img)
% Input:
% trackBlobsObj: 1. trackBlobsObjs from preocessed program
%                2. trackBlobsObjs could be a cell array with each cell
%                contains one trackBlobsObjs, which generate from program
%                eg. trackBlobsObjs{1} = trackBlobsObjFromVideo1;
%                    trackBlobsObjs{2} = trackBlobsObjFromVideo2; .. e.t.c
% img:           Background(artery) image, on which to layout trajs
% Binlong Li        27 March 2012

h = figure(5);

img = imresize(uint16_2_uint8(img), [125 125]);
imshow(img);

if iscell(trackBlobsObj)
    trackBlobsObjBackUp = trackBlobsObj;
    trackBlobsObj.DB = [];
    for i = 1 : length(trackBlobsObjBackUp)
        trackBlobsObj.DB = cat(1, trackBlobsObj.DB, trackBlobsObjBackUp{i}.DB);
    end
end
nCell = length(trackBlobsObj.DB);
colors = varycolor(nCell);
hold on;
for i = 1 : nCell
    plot(trackBlobsObj.DB{i}.Centroid(:, 1), trackBlobsObj.DB{i}.Centroid(:, 2), ...
        '-', 'Color', colors(i, :), 'LineWidth', 3);
end
hold off;
function drawAllTrajInOneImage(trackBlobsObj, img)
% Input:
% trackBlobsObj: trackBlobsObjs from preocessed program
% img:           Background(artery) image, on which to layout trajs

h = figure(5);

img = imresize(uint16_2_uint8(img), [125 125]);
imshow(img);

nCell = length(trackBlobsObj.DB);
colors = varycolor(nCell);
hold on;
for i = 1 : nCell
    plot(trackBlobsObj.DB{i}.Centroid(:, 1), trackBlobsObj.DB{i}.Centroid(:, 2), ...
        '-', 'Color', colors(i, :), 'LineWidth', 3);
end
hold off;
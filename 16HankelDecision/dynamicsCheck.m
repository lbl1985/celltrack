function dynamicsCheck(fg, k)
% where k is the current frame ID.
% combineImage = fg(:, :, k - 1) + fg(:, :, k) + fg(:, :, k + 1);
combineImage = sum(fg(:, :, k - 1 : k + 1), 3);
combineImage = combineImage > 128;
figure(1); imshow(combineImage);
STATS = regionprops(combineImage);
if length(STATS) > 1
    vec = structField2Vector(STATS, 'Centroid');
    figure(2); plot(vec(:, 1), vec(:, 2), 'ro');    axis([1 size(fg(:, :, 1), 2) 1 size(fg(:, :, 1), 1)]);
    nSec = size(vec, 1);
    for degree = 1 : nSec
        rsq = rsqComputing(vec, degree);
        if rsq > 0.97
            break;
        end
    end
    display(['Frame ' num2str(k) '_Degree_' num2str(degree)]);
    
else
    display(['Frame ' num2str(k) '_Nothing there']);
end




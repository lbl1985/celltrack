% Log:
% Checking the dynamics of continuous frames, if they can fit into polyfit
% with ratio larger the 0.97, then output the fitting degree. 
% Lots of logical faults still exists for now, need to fix them later.
% Binlong Li    25 June 2011    11:16AM
function varargout = dynamicsCheck(fg, k)
% where k is the current frame ID.
% combineImage = fg(:, :, k - 1) + fg(:, :, k) + fg(:, :, k + 1);
combineImage = sum(fg(:, :, k - 1 : k + 1), 3);
combineImage = combineImage > 128;
% figure(1); imshow(combineImage);
STATS = regionprops(combineImage);
resDegree = 0;
if length(STATS) > 1
    vec = structField2Vector(STATS, 'Centroid');
%     figure(2); plot(vec(:, 1), vec(:, 2), 'ro');    axis([1 size(fg(:, :, 1), 2) 1 size(fg(:, :, 1), 1)]);
    nSec = size(vec, 1);
    for degree = 1 : nSec
        rsq = rsqComputing(vec, degree);
        if rsq > 0.97
            break;
        end
    end
    display(['Frame ' num2str(k) '_Degree_' num2str(degree)]);
    resDegree = degree;
else
    display(['Frame ' num2str(k) '_Nothing there']);
end
varargout{1} = resDegree;
varargout{2} = combineImage;
varargout{3} = vec;
varargout{4} = STATS;



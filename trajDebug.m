clear; 
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.blobTrackingFunc();
trackBlobsObj.playTrackingBlobs();
% pickCellObj = pickCell(blobDetector.blobCellFrameVideo);

% pickCellObj.pickCellPerFrame
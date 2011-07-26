clear; 
main_class;
fgAfterOpenClosing = OpenClosingProcess(blobDetector.inputVideoData);
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.fgAfterClosing = videoVar(fgAfterOpenClosing);
% trackBlobsObj.OpenClosingProcessFunc();
trackBlobsObj.blobTrackingFunc();
trackBlobsObj.playTrackingBlobs();
% pickCellObj = pickCell(blobDetector.blobCellFrameVideo);

% pickCellObj.pickCellPerFrame
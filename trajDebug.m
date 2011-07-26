clear; 
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.OpenClosingProcessFunc();
% fgAfterOpenClosing = OpenClosingProcess(blobDetector.inputVideoData);
% trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
% trackBlobsObj.fgAfterClosing = videoVar(fgAfterOpenClosing);
% trackBlobsObj.OpenClosingProcessFunc();
trackBlobsObj.blobTrackingFunc();
trackBlobsObj.playTrackingBlobs();
% pickCellObj = pickCell(blobDetector.blobCellFrameVideo);

% pickCellObj.pickCellPerFrame
clear; close all;
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.OpenClosingProcess();
trackBlobsObj.blobTrackingFunc();
% TODO: DBMerge
trackBlobsObj.DBMerge();
trackBlobsObj.DBMerge();
trackBlobsObj.DBSortByFrame();
trackBlobsObj.playTrackingBlobs();

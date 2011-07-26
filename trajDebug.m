clear; close all;
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.OpenClosingProcess();
trackBlobsObj.blobTrackingFunc();
trackBlobsObj.DBMerge();
trackBlobsObj.DBMerge();
% TODO Dynamics
trackBlobsObj.DBSortByFrame();
trackBlobsObj.playTrackingBlobs();

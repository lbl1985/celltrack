clear; close all;
main_class;
trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
trackBlobsObj.OpenClosingProcess();
trackBlobsObj.blobTrackingFunc();

trackBlobsObj.DBMergeLocation();
trackBlobsObj.DBMergeLocation();
% TODO Dynamics
trackBlobsObj.DBMergeDynamics();
trackBlobsObj.DBSortByFrame();
% trackBlobsObj.playTrackingBlobs();
trackBlobsObj.videoName = 'video17_trial1.avi';
trackBlobsObj.saveTrackingBlobs;
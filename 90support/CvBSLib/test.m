%test
clear
sName='d:/research/data/bal/bldgcam1.avi';
fInfo=aviinfo(sName);
d=aviread(sName,1);
h=mexCvBSLib(d.cdata);%Initialize
mexCvBSLib(d.cdata,h,[0.01 3*3 1 0.5]);%set parameters
figure(1)
for i=1:fInfo.NumFrames
    d=aviread(sName,i);
    imMask=mexCvBSLib(d.cdata,h);
    imshow(imMask);
end
mexCvBSLib(h);%Release memory
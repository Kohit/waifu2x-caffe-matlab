function im_hr = caffeFSRCNN3(prototxt, caffemodel, im_lr)
%caffe.set_mode_gpu();
%caffe.set_device(0);
caffe.reset_all();
net = caffe.Net(prototxt, caffemodel, 'test');
input = {im_lr};
fprintf('start..');
tic
conv = net.forward(input);
toc
im_hr = conv{1};

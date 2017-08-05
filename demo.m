% ==========================================
% set use_caffe to true if you have caffe installed
% Reference
%   Chao Dong, Chen Change Loy, Xiaoou Tang. Accelerating the Super-Resolution Convolutional Neural Networks, 
%   in Proceedings of European Conference on Computer Vision (ECCV), 2016
% ==========================================

clear;close all;
im = imread('test\aniset\noise65\comic.bmp');
im = modcrop(im,2);
im = im2double(im);
%im_lr = imresize(im, 1/3, 'box');
im_l = im;
use_caffe = false;
if use_caffe
    im_lr = padarray(im_l,[2, 2],'replicate');
    proto = 'anifsrcnn_mat';
    protoname = createProto(proto, size(im_lr,1), size(im_lr,2));
    model = 'model\N-56-12-4-ns2-00013_iter_8700000.caffemodel';
    tic
    im_hr = caffeFSRCNN3(protoname,model,im_lr);
    toc
else
    tic
    im_hr = FSRCNN('model\anifsrcnn_ns2_870.mat', im_l, 2);
    toc
end

imshow(im_hr);
imwrite(im_hr,'comic_sr.bmp');
im_b = imresize(im, 2, 'bicubic');
imwrite(im_b,'comic_bicubic.bmp');
% ==========================================
% Reference
%   Chao Dong, Chen Change Loy, Xiaoou Tang. Accelerating the Super-Resolution Convolutional Neural Networks, 
%   in Proceedings of European Conference on Computer Vision (ECCV), 2016
% ==========================================

clear;close all;

%% set parameters
testfolder = 'test\aniset\noise65\';
gndfolder = 'test\aniset\';
up_scale = 2;
model = 'model\N-56-12-4-ns2-00013_iter_8700000.caffemodel';

testfilepaths = [dir(fullfile(testfolder,'*.bmp'));dir(fullfile(testfolder,'*.jpg'))];
gndfilepaths = [dir(fullfile(gndfolder,'*.bmp'));dir(fullfile(gndfolder,'*.jpg'))];
psnr_bic = zeros(length(testfilepaths),1);
psnr_fsrcnn = zeros(length(testfilepaths),1)

for i = 1 : length(testfilepaths)
   
    %% read ground truth image
    [add,imname,type] = fileparts(testfilepaths(i).name);
    im = imread([testfolder imname type]);
    [add,imname,type] = fileparts(gndfilepaths(i).name);
    im_gnd = imread([gndfolder imname type]);
    
    im_gnd = modcrop(im_gnd, up_scale);

    im = im2double(im);
    im_gnd = im2double(im_gnd);
    
    im_l = im;

    %% FSRCNN
    im_lr = padarray(im_l,[2, 2],'replicate');
    protoname = createProto('anifsrcnn_mat', size(im_lr,1), size(im_lr,2));
    tic
    im_hr = caffeFSRCNN3(protoname,model,im_lr);
    toc
    %% bicubic interpolation
    im_b = imresize(im_l, up_scale, 'bicubic');

    %% remove border
    im_gnd = im_gnd(1:end-2,1:end-2,:);
    im_b = im_b(1:end-2,1:end-2,:);

    %% compute PSNR
    psnr_bic(i) = compute_psnr(uint8(im_gnd * 255),uint8(im_b * 255),'y');
    psnr_fsrcnn(i) = compute_psnr(uint8(im_gnd * 255),uint8(im_hr * 255),'y');

    %% save results
    imwrite(im_b, ['gen\' imname '_bic.bmp']);
    imwrite(im_hr, ['gen\' imname '_ns2_870.bmp']);

end

fprintf('Mean PSNR for Bicubic: %f dB\n', mean(psnr_bic));
fprintf('Mean PSNR for FSRCNN: %f dB\n', mean(psnr_fsrcnn));

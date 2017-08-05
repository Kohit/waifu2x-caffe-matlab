% ==========================================
% Slightly adapted the original demo code to fit colored images
% Reference
%   Chao Dong, Chen Change Loy, Xiaoou Tang. Accelerating the Super-Resolution Convolutional Neural Networks, 
%   in Proceedings of European Conference on Computer Vision (ECCV), 2016
% ==========================================

function im_h = FSRCNN(model, im_l, up_scale)

%% load CNN model parameters
load(model);
[hei,wid,~] = size(im_l);
outhei = hei * up_scale;
outwid = wid * up_scale;
layer_num = length(weights_conv);
conv_data = cell(layer_num,1);

%% conv2+
for idx = 1 : layer_num-1
    weight = weights_conv{idx};
    bias = biases_conv{idx};
    [channel, filtersize, filters] = size(weight);
    patchsize = sqrt(filtersize);
    data_tmp = zeros(hei, wid, filters);
    if idx == 1
        data_pre = im_l;
    else
        data_pre = conv_data{idx-1};
    end
    for i = 1 : filters
        for j = 1 : channel
            subfilter = reshape(weight(j,:,i), patchsize, patchsize);
            data_tmp(:,:,i) = data_tmp(:,:,i) + imfilter(data_pre(:,:,j), subfilter, 'same', 'replicate');
        end
        % prelu
        data_tmp(:,:,i) = max(data_tmp(:,:,i) + bias(i),0) + prelu_conv{idx} * min(data_tmp(:,:,i) + bias(i),0);
    end
    conv_data{idx} = data_tmp;
end

%% conv3
weight = weights_conv{layer_num};
bias = biases_conv{layer_num};
[channel, filtersize,filters] = size(weight);

patchsize = sqrt(filtersize);

conv3_data = zeros(outhei,outwid, channel);
conv2_data = conv_data{layer_num-1};
for i = 1:channel
    for j = 1 : filters
        subfilter = reshape(weight(i,:,j), patchsize, patchsize);
        conv3_data(:,:,i)=conv3_data(:,:,i) + deconv(conv2_data(:,:,j), subfilter, up_scale);
    end
    conv3_data(:,:,i) = conv3_data(:,:,i) + bias(i);
end
im_h = conv3_data;



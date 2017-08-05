function psnr=compute_psnr(im1,im2, style)
if style == 'y'
    if size(im1, 3) == 3,
        im1 = rgb2ycbcr(im1);
        im1 = im1(:, :, 1);
    end

    if size(im2, 3) == 3,
        im2 = rgb2ycbcr(im2);
        im2 = im2(:, :, 1);
    end
end
imdff = (double(im1) - double(im2)) .^2;
mse = 0;
if style == 'y'
    imdff = imdff(:);
    mse = sqrt(mean(imdff));
elseif style == 'rgb'
    [h w c] = size(imdff);
    imdff = reshape(imdff, h * w, c);
    mse = mean(sqrt(mean(imdff)));
end
psnr = 20*log10(255/mse);
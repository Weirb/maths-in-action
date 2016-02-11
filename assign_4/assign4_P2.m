function [] = assign4_P2()
%% Edge detection using LCN
    im = imread('yeast.jpg');
    im = double(im(:,:,1));
    y = lcn(im);
    
    figure();
    subplot(1,2,1);
    imshow(im,[]);
    title('Original Image');
    subplot(1,2,2);
    imshow(y,[]);
    title('Processed With LCN');

%% Edge detection using standard convolution
    w1 = [-1 0 1];
    w2 = [-1; 0; 1];
    
    im1 = conv2(im, w1, 'same');
    im2 = conv2(im, w2, 'same');
    im3 = im1 + im2;

    figure();
    subplot(1,3,1);
    imshow(im1, []);
    title('Horizontal Edge Detector');
    subplot(1,3,2);
    imshow(im2, []);
    title('Vertical Edge Detector');
    subplot(1,3,3);
    imshow(im3, []);
    title('Horizontal and Vertical Edge Detector');
end

function Xproc = lcn(X)
    % Create a 9x9 Gaussian filter with std=2
    w = fspecial('gaussian', 9, 2);
    % Calculate the weighted mean
    Xmean = conv2(X, w, 'same');
    X1 = X - Xmean;
    
    % Compute the std of the mean-centred image
    sigma = sqrt(conv2(X1.^2, w, 'same'));
    c = mean(mean(sigma));
    
    % Return the final result by normalising matrix
    Xproc = X1./max(c, sigma);
end



























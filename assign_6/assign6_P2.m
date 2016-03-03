function [] = assign6_P2()
    
    image = 'mona_lisa.jpg';
    
    fourier_thresholds = [0.8 0.65 0.5];
    
    for t = fourier_thresholds
        fourier_reconstruct(image, t);
    end
    
    for i = 1:3
        eofs(image, i);
    end
    
end

function [] = fourier_reconstruct(image, threshold)

    im = imread(image);
    im = double(im(:,:,1));
    
    % Compute Fourier transform and concatenate matrix columns to a vector
    ft = fftshift(fft2(im));
    F = ft(:);
    
    % Can use logF for plotting and to find threshold values, but we need to
    % keep F for the inverse transform
    logF = log(abs(F)+1);
    
    % Compute threshold values
    threshold = threshold*max(logF);
    z = find(logF < threshold);
    nonzeros = length(F) - length(z);
    F(z) = 0;
    
    figure();
    imshow(ifft2(ifftshift(reshape(F,400,400))), []);
end

function Y = eofs(image_file, n_singulars)

    im = imread(image_file);
    im = double(im(:,:,1));

    [n, m] = size(im);
    k = 8;

    ni = floor(n/k);
    nj = floor(m/k);

    X = zeros(ni*nj, k^2);
    means = zeros(ni*nj,1);
    
    for i=1:ni
        for j=1:nj
            c = i + (j-1)*ni;
            tmp = reshape(im(1+(i-1)*k:i*k, 1+(j-1)*k:j*k),1,k^2);
            m = mean(tmp);
            X(c,:) = tmp - m;
            means(c) = m;
        end
    end
    
    [U, S, V] = svd(X,0);
    S = diag(S);
    
    % Reconstruct using n_singular singular values
    Y = X*0;
    for i = 1:n_singulars
        Y = Y + S(i)*U(:,i)*V(:,i)';
    end
    Y = Y + repmat(means, 1, k^2);
    
    r = zeros(ni, nj);
    for i=1:ni
        for j=1:nj
            c = i + (j-1)*ni;
            r(1 + (i-1)*k:i*k, 1 + (j-1)*k:j*k) = reshape(Y(c, :), k, k);
        end
    end
    
    figure();
    imshow(r,[]);
end
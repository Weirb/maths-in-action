function [] = assign4_P1()
    
    im = imread('mona_lisa.jpg');
    im = double(im(:,:,1));
    
    d1 = dct_basis(1,1);
    snapeeofs = snape_eofs();
    d2 = snapeeofs(:,:,4);
    
    figure();
    subplot(2,2,1);
    imshow(conv2(im, d1,'same'), []);
    subplot(2,2,2);
    imshow(conv2(im,d2,'same'),[]);
    subplot(2,2,3);
    imshow(d1,[]);
    subplot(2,2,4);
    imshow(d2,[]);
end

function B = dct_basis(p, q)
    B = zeros(8,8);
    for m=0:7
        for n=0:7
            B(m+1,n+1) = sqrt(2)/8 * cos(pi*(2*m+1)*p/16)*cos(pi*(2*n+1)*q/16);
        end
    end
end

function Y = snape_eofs()

    im = imread('snape.jpg');
    im = double(im(:,:,1));

    [n, m] = size(im);
    k = 8;

    ni = floor(n/k);
    nj = floor(m/k);

    X = zeros(ni*nj, k^2);

    for i=1:ni
        for j=1:nj
            c = i + (j-1)*ni;
            tmp = reshape(im(1+(i-1)*k:i*k, 1+(j-1)*k:j*k),1,k^2);
            X(c,:) = tmp - mean(tmp);
        end
    end

    [~, ~, V] = svd(X,0);

    Y = zeros(k,k, ni*nj);
    for i=1:size(V,1)
        Y(:,:,i) = reshape(V(:,i),k,k);
    end

end
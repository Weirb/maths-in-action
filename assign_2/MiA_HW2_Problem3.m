% MiA 2016. Assignment 2. Problem 3 -- SVD and image compression
% 
% This files has the info on how to read a file image, show it in Matlab. 

clear all; close all; clc

X = imread('mona_lisa.jpg');
X = double(rgb2gray(X));
N = rank(X);
[U,S,V] = svd(X);

for k = 1:20
    figure();
    X = uint8(U(:,1:k)*S(1:k,1:k)*V(:,1:k)');
    imshow(X)
    title(['Low-Rank Approximation; k = ',num2str(k)],'FontSize',15);
end

var = 0;
tr = sum(diag(S));
for i = 1:N
    var = var + S(i,i);
    if var >= 0.98*tr
        disp(i); 
        break;
    end
end

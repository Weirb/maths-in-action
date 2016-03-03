clear all; close all; clc

[y, Fs] = audioread('jenny.wav');
L = length(y)/Fs;

% Combine audio channels
y = y(:,1) + y(:,2);
% sound(y, Fs);

S = y(1:2^10)'; 
n = length(S);

t2 = linspace(0,L,n+1); 
t = t2(1:n); % exclude the last point because of periodicity

k = 2*pi/L*[0:n/2-1 -n/2:-1]; 
ks = fftshift(k); 

St = fft(S);

widths = [0.01 1 10];
for i = widths
    
    tslide = 0:0.1:10;
    Sgt_spec = zeros(length(tslide), length(t));
    for jj = 1:length(tslide), 
        g = exp(-i*(t-tslide(jj)).^2);
        Sg = g.*S; 
        Sgt = fftshift(fft(Sg)); 
        Sgt_spec(jj, :) = abs(Sgt);
    end
    
    figure();
    pcolor(tslide, ks, Sgt_spec'); 
    shading interp
    set(gca,'Ylim',[-50 50],'fontsize',15); 
    colormap(hot)
    xlabel('time (t)','fontsize',15); 
    ylabel('frequency (\omega)', 'fontsize',15);
    title(strcat('Gabor width, \alpha=', num2str(i)));
end

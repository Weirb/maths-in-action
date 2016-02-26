format long;
clear all; close all; clc;

X = importdata('Scotland.txt', '\t', 1);
x = X.data;

data = x(:,2:13)';
data = data(:)';
data(isnan(data)) = [];

N = numel(data);

% Centre the data so that the mean is 0.
% This has the effect of removing the frequency at k=0.
m = mean(data);
data = data - m;

t = linspace(1910,2016, N);

noiseless_signal = fourier_filter(data);

noiseless_signal = noiseless_signal + m;
data = data + m;

%% Plots

% Plot the Fourier Transform
k = linspace(-N/2, N/2-1, N) + mod(N,2)/2;
figure('Position', [100, 100, 1000, 600]);
plot(k, abs(fftshift(fft(data))));
title('Fourier Transform of Temperature Data', 'FontSize', 16);
xlabel('Wavenumber', 'FontSize', 14);
ylabel('Absolute Value of Fourier Coefficient', 'FontSize', 14);
set(gca,'FontSize',12);
xlim([min(k) max(k)]);

% Plot the noisy wave
figure('Position', [100, 100, 1000, 600]);
plot(t, data);
title('Monthly Mean Temperature Data for Scotland, 1910-2016', 'FontSize', 16);
xlabel('Year', 'FontSize', 14);
ylabel('Temperature (Degrees C)', 'FontSize', 14);
set(gca,'FontSize',12);
xlim([1910 2016]);

% Plot the Fourier filtered wave
figure('Position', [100, 100, 1000, 600]);
subplot(211);
plot(t, noiseless_signal);
title('Fourier Transform Filtered Data', 'FontSize', 16);
xlabel('Year', 'FontSize', 14);
ylabel('Temperature (Degrees C)', 'FontSize', 14);
set(gca,'FontSize',12);
xlim([1910 1940]);

% Plot the Fourier filtered wave together with the original data
% figure('Position', [100, 100, 1000, 600]);
subplot(212);
hold on;
plot(t, data, 'b-');
plot(t, noiseless_signal, 'r-');
title('Comparison of Fourier Transform Filter and Original Data', 'FontSize', 16);
xlabel('Year', 'FontSize', 14);
ylabel('Temperature (Degrees C)', 'FontSize', 14);
set(gca,'FontSize',12);
legend('Original temperature data', 'Fourier Reconstruction');
xlim([1910 1940]);

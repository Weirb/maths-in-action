
N = 500;
t = linspace(0, 2*pi, N);

% Generate the signal
omega = 1;
S = sin(omega*t);
X = S + 0.4*randn(size(t));

noiseless_signal = fourier_filter(X);

%% Plots

% Plot the Fourier Transform
k = linspace(-N/2, N/2-1, N) + mod(N,2)/2;
figure('Position', [100, 100, 1000, 600]);
plot(k, abs(fftshift(fft(X))));
title('Fourier Transform of Noisy Signal S(t)', 'FontSize', 16);
xlabel('Wavenumber', 'FontSize', 14);
ylabel('Absolute Value of Fourier Coefficient', 'FontSize', 14);
set(gca,'FontSize',12);

% Plot the noisy wave
figure('Position', [100, 100, 1000, 600]);
plot(t, X);
title('Noisy Signal S(t)', 'FontSize', 16);
xlabel('Time', 'FontSize', 14);
ylabel('Amplitude', 'FontSize', 14);
set(gca,'FontSize',12);
xlim([0 2*pi]);

% Plot the Fourier filtered wave
figure('Position', [100, 100, 1000, 600]);
plot(t, noiseless_signal);
title('Fourier Transform Filtered Signal', 'FontSize', 16);
xlabel('Time', 'FontSize', 14);
ylabel('Amplitude', 'FontSize', 14);
set(gca,'FontSize',12);
ylim([-1 1]);
xlim([0 2*pi]);

% Plot the Fourier filtered wave together with the noiseless signal
figure('Position', [100, 100, 1000, 600]);
hold on;
plot(t, S, 'b-');
plot(t, noiseless_signal, 'r-');
title('Comparison of Fourier Transform Filter and Noiseless Signal', 'FontSize', 16);
xlabel('Time', 'FontSize', 14);
ylabel('Amplitude', 'FontSize', 14);
set(gca,'FontSize',12);
legend('Noiseless signal', 'Fourier Signal');
ylim([-1.3 1.3]);
xlim([0 2*pi]);
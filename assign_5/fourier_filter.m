function x = fourier_filter(X)
%     N = 2*floor(numel(X)/2);
    N = numel(X);
    
    % Compute the Fourier transform and correct the frequency ordering
    ft_signal = fftshift(fft(X, N));

    % The wavenumbers
    k = linspace(-N/2, N/2-1, N) + mod(N,2)/2;
    
    % Use a threshold to select frequencies whose amplitudes are greater
%     threshold = 4*mean(abs(ft_signal));
%     z = find(abs(ft_signal) > threshold) - N/2 - 1;
    
    % Include a fixed number of frequencies from the maximum
    [~, I] = sort(abs(ft_signal), 'descend');
    z = k(I(1:2));
    
    % Generate the gaussians at the peaks
    
    gaussian = @(f) exp(-0.1*(k - f).^2);
    W = zeros(numel(z), N);
    for i=1:numel(z)
        W(i,:) = gaussian(z(i));
    end
    w = sum(W, 1); w = w/max(w);

    % Multiply by the gaussian
    ft_g = ft_signal.*(w);

    % Shift back and invert the FT
    x = ifft(ifftshift(ft_g));

end
hold on;

rng(1);
N = 50;
a = 0.1;
x = linspace(-2, 2, N)';
y = a*x.^2 + 0.1*randn(N,1);
theta = 2*pi/7;

% hold on;
% plot(x,y,'bo')

x = x - mean(x);
y = y - mean(y);
X = [x y];
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
X = X*R;
x = X(:,1); y = X(:,2);

plot(x,y,'ro');
xlabel('x','FontSize',15);
ylabel('y','FontSize',15);
title('Right Singular Vectors of Quadratic Data Plus Gaussian Noise','FontSize',15);

[U, S, V] = svd(X, 0);
S
s1 = S(1,1);
s2 = S(2,2);
line([0;s1*V(1,1)], [0; s1*V(2,1)])
line([0;s2*V(1,2)], [0; s2*V(2,2)])
legend('Data', 'Right singular vectors');
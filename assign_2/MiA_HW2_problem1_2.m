% MiA. HW 2. Problem 1.2 -- C02 data -- using max log likelihood
%
% The locations where you have to put in the work are marked with >>>...<<< signs

format short;
clear all; close all; clc ; 

 
x = importdata('co2_mm_mlo.txt');
x = x.data;
%            decimal     average   interpolated    trend    #days
%             date                             (season corr)
% Note: column 3 is the decimal date for the time column 4 has the average CO2. 
% There is some missing data marked as -99, which we get rid of here: 
x = [x(:,3), x(:,4)];                    % take the timeline and the CO2 concentration data
[i,j] = find(x(:,2) > 0);     x = x(i,:); % got rid of the missing data
[i,j] = find(x(:,1) > 2000);  x = x(i,:); % got rid of the data before the year 2000

y = x(:,2);
x = x(:,1);

x = x-mean(x);
y = y-mean(y);

n = length(x);                         % number of time-points of the data
X = [ones(n,1), x, x.^2, sin(x*2*pi)];  % the matrix for the least squares fit
w = X\y;                               % weights for the least squares fit
 
lambda = 0.005;   % learning rate 

a = w(1);
b = w(2); 
c = w(3); 
d = w(4);
e = 2*pi; 
f = 0; 
s = 1;
niterations = 400;

% keeping track of all the parameters during the iterations 
a_all = zeros(niterations + 1, 1); a_all(1) = a;
b_all = a_all; b_all(1) = b;
c_all = a_all; c_all(1) = c; 
d_all = a_all; d_all(1) = d;
e_all = a_all; e_all(1) = e;
f_all = a_all; f_all(1) = f;
s_all = a_all; s_all(1) = s;
L_all = a_all;

mu = a + b*x + c*x.^2 + d*sin(e*x + f);
L_all(1) =  -sum((y - mu).^2)/(2*s^2*n) - log(s);
[a,b,c,d,e,f,s]'

%_________( the main cycle )____________________
for jj = 1:niterations, 

    L_a = sum(y - mu)/s^2/n;
    L_b = sum(x.*(y - mu))/s^2/n;
    L_c = sum(x.^2.*(y - mu))/s^2/n;
    L_d = sum(sin(e*x + f).*(y - mu))/s^2/n;
    L_e = sum(d*x.*cos(e*x + f).*(y - mu))/s^2/n;
    L_f = sum(d*cos(e*x + f).*(y - mu))/s^2/n;
    L_s = sum((y - mu).^2)/s^3/n - 1/s;

    L = [L_a, L_b, L_c, L_d, L_e, L_f, L_s];
    NormGrad = norm(L);
    beta = lambda/(1 + NormGrad);

    a = a + beta*L(1);
    b = b + beta*L(2);
    c = c + beta*L(3);
    d = d + beta*L(4);
    e = e + beta*L(5);
    f = f + beta*L(6);
    s = s + beta*L(7);

    % store the parameter values for plotting 
    a_all(jj+1) = a; 
    b_all(jj+1) = b; 
    c_all(jj+1) = c; 
    d_all(jj+1) = d; 
    e_all(jj+1) = e; 
    f_all(jj+1) = f; 
    s_all(jj+1) = s;

    % store the log-likelihood 
    mu = a + b*x + c*x.^2 + d*sin(e*x + f);
    L_all(jj+1) =  - sum((y - mu).^2)/(2*s^2*n) - log(s); 

end
L_all(end)
figure(1);
subplot(1,2,1); 
plot(L_all); 
hold on; 
axis([0 niterations min(L_all)-1 max(L_all)+1])
xlabel('Iteration Number','FontSize',15); 
ylabel('Log Likelihood','FontSize',15); 

[a,b,c,d,e,f,s]'
xp = min(x):.1:max(x); % xp = "x for plotting" array with more points

subplot(1,2,2);     
hold on;
plot(x,y,'b-')
plot(xp, a + b*xp + c*xp.^2 + d*sin(e*xp + f), 'r-'); 
plot(xp, w(1) + w(2)*xp + w(3)*xp.^2 + w(4).*sin(2*pi*xp),'k-'); 
legend('Original Data', 'Max Log-Likelihood Parameter Estimates', 'Least Squares Parameter Estimates')

title('', 'FontSize',15);
xlabel('Time','FontSize',15); 
ylabel('Concentration of CO2 (ppm)','FontSize',15); 

    
    
     


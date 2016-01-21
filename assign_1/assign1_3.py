import numpy as np
import matplotlib.pyplot as plot
import matplotlib
from assign1_1 import polyfit

np.random.seed(1)

matplotlib.style.use('ggplot')

def f(x):
    return x + x**2 - x**3

def L2(x0, x1):
    return np.sum(np.square(x0 - x1))

# Generate the training and validation sets
a = 0
b = 1
N = 20
k = N/4
std = 0.05
x_train = np.linspace(a, b, N) + np.random.normal(0, std, N)
y_train = f(x_train) + np.random.normal(0, std, N)
x_valid = np.linspace(a, b, k) + np.random.normal(0, std, k)
y_valid = f(x_valid) + np.random.normal(0, std, k)


max_degree = 8
ws = [polyfit(x_train, y_train, n) for n in range(1, max_degree)]

x = np.linspace(a-std,b+std,100)

# Create anonymous functions for each polynomial fit
y_fs = [lambda t, w=w: sum([w[i]*t**i for i in range(len(w))]) for w in ws]

training_errors = [L2(y(x_train),y_train) for y in y_fs]
valid_errors = [L2(y(x_valid),y_valid) for y in y_fs]


# Plot the polynomial fit to the training data
fig, ax = plot.subplots(frameon=True)
ax.set_axis_bgcolor((1,1,1))
ax.grid(which='both',color='gray')
for i in ax.spines:
    ax.spines[i].set_color('k')
ax.set_title('Polynomial Fits to Training Data', fontsize=18)
ax.set_xlabel('x')
ax.set_ylabel('f(x)')

plot.plot(x_train, y_train,'o')
for i,y in enumerate(y_fs, 1):
    plot.plot(x, y(x), label='Degree=%d'%i)
plot.legend(loc='best', fancybox=True)
plot.savefig('trainingpolyfit.eps', format='eps')


# Plot the polynomial fit to the validation data
fig, ax = plot.subplots(frameon=True)
ax.set_axis_bgcolor((1,1,1))
ax.grid(which='both',color='gray')
for i in ax.spines:
    ax.spines[i].set_color('k')
ax.set_title('Polynomial Fits to Validation Data', fontsize=18)
ax.set_xlabel('x')
ax.set_ylabel('f(x)')

plot.plot(x_valid, y_valid,'o')
for i,y in enumerate(y_fs, 1):
    plot.plot(x, y(x), label='Degree=%d'%i)
plot.legend(loc='best', fancybox=True)
plot.savefig('validationpolyfit.eps', format='eps')


# Plot the L2 errors
fig, ax = plot.subplots(frameon=True)
ax.set_axis_bgcolor((1,1,1))
ax.grid(which='both',color='gray')
for i in ax.spines:
    ax.spines[i].set_color('k')
ax.set_title('L2 Error in Polynomial Fits to\nTraining and Validation Data', fontsize=18)
ax.set_xlabel('Polynomial Degree')
ax.set_ylabel('L2 Error')

#plot.plot(enumerate(training_errors,1))
plot.plot(range(1, max_degree), training_errors, label='Training Error')
plot.plot(range(1, max_degree), valid_errors, label='Validation Error')
plot.legend(loc='best', fancybox=True)
plot.savefig('trainvaliderror.eps', format='eps')
#plot.show()

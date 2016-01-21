import numpy as np
import matplotlib.pyplot as plot
import matplotlib

matplotlib.style.use('ggplot')

np.random.seed(1)

def f_linear(x):
    return 5 + 2*x

def f_quadratic(x):
    return 17 - 5*x + x**2

def f_cubic(x):
    return 1 - x**2 + 5*x**3

def f_trig(x):
    return 2 + np.sin(x) - 2*np.cos(x)

def coef(x, y):
    # Equivalent to MATLAB's \ command or computing inverses and solving directly
    return np.linalg.solve(np.dot(np.transpose(x), x), np.dot(np.transpose(x),y)).flatten()

def polyfit(x, y, n):
    X = np.array([[i**j for j in range(n+1)] for i in x]).reshape((len(x),n+1))
    w = coef(X, y)
    return w

def plot_fits(function, title, N):
    # Create synthetic data
    a = 0
    b = 20
    x = np.linspace(a, b, N)
    y = (function(x) + np.random.normal(0,1,N)).reshape((N,1))

    # Compute the matrix using the trigonometric functional basis
    X_trig = np.hstack((np.ones((N,1)), x.reshape(N,1), np.sin(x).reshape(N,1), np.cos(x).reshape((N,1))))

    # Calculate the coefficients of the functional bases for the data
    w1 = polyfit(x, y, 1)
    w2 = polyfit(x, y, 2)
    w3 = polyfit(x, y, 3)
    w4 = coef(X_trig, y)

    # Plot the lines of fit for each of the computed bases
    xs = np.linspace(a,b,200)
    ys1 = sum([w*xs**i for i,w in enumerate(w1)])
    ys2 = sum([w*xs**i for i,w in enumerate(w2)])
    ys3 = sum([w*xs**i for i,w in enumerate(w3)])
    ys4 = w4[0]*xs**0 + w4[1]*xs + w4[2]*np.sin(xs) + w4[3]*np.cos(xs)

    fig, ax = plot.subplots(frameon=True)
    ax.set_axis_bgcolor((1,1,1))
    ax.grid(which='both',color='gray')
    for i in ax.spines:
        ax.spines[i].set_color('k')
    ax.set_title(title, fontsize=18)
    ax.set_xlabel('x')
    ax.set_ylabel('f(x)')

    plot.plot(x,y,'bo', label='Initial Data')
    plot.plot(xs, ys1, 'g-', label='Linear Fit')
    plot.plot(xs, ys2, 'r-', label='Quadratic Fit')
    plot.plot(xs, ys3, 'y-', label='Cubic Fit')
    plot.plot(xs, ys4, 'k-', label='Trigonometric Fit')
    plot.legend(loc='best', fancybox=True)
    #plot.savefig(function.__name__ +str(N)+'.eps', format='eps')
    plot.show()
    plot.clf()

if __name__ == "__main__":

    functions = [(f_linear,'Linear Data'), (f_quadratic,'Quadratic Data'), (f_cubic,'Cubic Data'), (f_trig,'Trigonometric Data')]
    for f,t in functions:
        plot_fits(f, t, 30)
        break

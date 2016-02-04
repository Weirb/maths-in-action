import numpy as np
import matplotlib.pyplot as plot
from matplotlib.animation import FuncAnimation

np.random.seed(1)

def f_theta(x, t):
    return 0.05*np.pi*x - t

def f(x, t):
    return 4/np.pi * sum([np.sin(np.multiply(k*np.pi, f_theta(x, t)))/k for k in range(1, 40, 2)]) + 0.1*np.random.randn()

x0, xn = -10, 10
y0, yn = -2, 2
t0, T = 0, 10
nt = 200
nx = 100
t = np.linspace(t0, T, nt)
x = np.linspace(x0, xn, nx)

# Calculate the spatial data for each timestep
x_data = np.reshape([[f(xi, ti) for xi in x] for ti in t], (nt, nx))

u, s, v = np.linalg.svd(x_data, full_matrices=False)

# Compute the low-rank approximation of the data
# NumPy's svd returns V as V transposed, so x_data=u*diag(s)*v
low_rank = lambda r: np.dot(u[:, :r], np.dot(np.diag(s[:r]), v[:r, :]))

# Calculate the variance contributions of the singular values
var = sum(s)
for i in range(len(s)):
    print i+1, '&', '{:06.5f}'.format(s[i]/var), '&', '{:06.5f}'.format(sum(s[:i+1])/var), '\\\\'


# Animation
fig = plot.figure()
ax = plot.axes(xlim=(x0, xn), ylim=(y0, yn))
ax.set_ylabel(r'$f(\theta(x,t))$',size=20)
ax.set_xlabel(r'$x$',size=20)
ax.set_title(r'Animation of One-Dimensional Synthetic Wave Data', size=24)
plot.setp(ax.get_xticklabels(), fontsize=16)
plot.setp(ax.get_yticklabels(), fontsize=16)
plot.grid()

eofs = [1, 5, 20, 85]
total, = ax.plot([], [], lw=1, label='Original Data')
lines = [ax.plot([], [], lw=1, label='k=%d'%i)[0] for i in eofs]
time_text = ax.text(x0+0.5, yn-0.5, '')
ax.legend()

def animate(frame):
    time_text.set_text('t=%.2f' % t[frame])
    total.set_data(x, x_data[frame])
    for line,k in zip(lines, eofs):
        line.set_data(x, low_rank(k)[frame])
        line.set_label(str(k))
    return [total, time_text] + lines

anim = FuncAnimation(fig, animate, frames=nt, blit=True, interval=24)


# Plot an individual frame of the animation
fig = plot.figure()
ax = plot.axes(xlim=(x0, xn), ylim=(y0, yn))
ax.set_ylabel(r'$f(\theta(x,t))$',size=20)
ax.set_xlabel(r'$x$',size=20)
ax.set_title('Low-Rank Approximations of the One-Dimensional Wave Data', size=24)
plot.setp(ax.get_xticklabels(), fontsize=16)
plot.setp(ax.get_yticklabels(), fontsize=16)
plot.grid()

plot_frame = 0
plot.plot(x,x_data[plot_frame],'b', label='Original Data')
plot.plot(x,low_rank(1)[plot_frame,:], 'r', label='k=1')
plot.plot(x,low_rank(4)[plot_frame,:],'g', label='k=5')
plot.plot(x,low_rank(10)[plot_frame,:],'m', label='k=20')
plot.plot(x,low_rank(40)[plot_frame,:],'k', label='k=85')
ax.legend()


# Plot the principal components
fig = plot.figure()
ax = plot.axes(xlim=(0, nt))
ax.set_title(r'Principal Components for One-Dimensional Wave Data', size=24)
ax.set_xlabel('Time-series',size=20)
ax.set_ylabel('Amplitude',size=20)
plot.setp(ax.get_xticklabels(), fontsize=16)
plot.setp(ax.get_yticklabels(), fontsize=16)
plot.grid()
for i in range(4):
    plot.plot(np.dot(x_data, v[i,:].T), label="Principal Component=%d"%(i+1))
ax.legend()

plot.show()





































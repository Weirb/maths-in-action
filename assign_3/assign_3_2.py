from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plot
import numpy as np

np.random.seed(1)

def generate(X, Y, t):
    return np.cos(0.2*np.pi*X - 2*np.pi*t)*np.sin(0.2*np.pi*Y + t) + 0.1*np.random.normal(0, 1, (ny, nx))

nt = 100
nx, ny = 100, 100
x0, xn = -10, 10
t = np.linspace(0, 10, nt)
X = np.linspace(x0, xn, nx)
Y = np.linspace(x0, xn, ny)
X, Y = np.meshgrid(X, Y)

x_data = np.array([generate(X,Y,ti).reshape((nx*ny)) for ti in t])
x_data = np.array([i - np.mean(i) for i in x_data])

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
ax = fig.add_subplot(111, projection='3d')
ax.set_zlim3d([-3.0, 3.0])
ax.set_ylabel(r'$y$',size=20)
ax.set_xlabel(r'$x$',size=20)
ax.set_zlabel(r'$h(x,y,t)=f(\theta_1(x,t)) g(\theta_2(y,t))$', size=20)
ax.set_title('Animation of Two-Dimensional Wave Data', size=24)
plot.setp(ax.get_xticklabels(), fontsize=16)
plot.setp(ax.get_yticklabels(), fontsize=16)
plot.setp(ax.get_zticklabels(), fontsize=16)
plot.grid()

frame = None
for i in range(nt):
    oldframe = frame
    Z = x_data[i].reshape(nx,ny)
    frame = ax.plot_wireframe(X, Y, Z, rstride=3, cstride=3, linewidth=1)

    if oldframe is not None:
        ax.collections.remove(oldframe)

    plot.pause(0.01)


# Plot an individual frame of the animation
fig = plot.figure(figsize=(16,10))
ax = fig.add_subplot(111, projection='3d')
ax.set_zlim3d([-3.0, 3.0])
ax.set_ylabel(r'$y$',size=20)
ax.set_xlabel(r'$x$',size=20)
ax.set_zlabel(r'$h(x,y,t)=f(\theta_1(x,t)) g(\theta_2(y,t))$', size=20)
plot.setp(ax.get_xticklabels(), fontsize=16)
plot.setp(ax.get_yticklabels(), fontsize=16)
plot.setp(ax.get_zticklabels(), fontsize=16)
plot.grid()

plot_frame = 0
for k in [1,5,96,100]:
    plot.title('Original Two-Dimensional Wave Data, k=%d'%k, size=24, y=1.08)
    ax.plot_surface(X,Y,low_rank(k)[plot_frame].reshape((nx,ny)), rstride=1, cstride=1, linewidth=0, cmap=plot.cm.jet)
    plot.savefig('lowrank%d.eps'%k, bbox_inches='tight')





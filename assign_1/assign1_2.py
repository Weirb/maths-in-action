import pandas as pd
import matplotlib.pyplot as plot
import matplotlib
import numpy as np
from assign1_1 import polyfit

matplotlib.style.use('ggplot')

# Load the data into a dataframe
df = pd.read_table('co2_mm_mlo.txt', delim_whitespace=True, comment='#', na_values='-99.99')

# Remove rows whose average is NaN
df = df[pd.notnull(df['average'])]

# Compute the period of the oscillations in the data
# Note that some data has been removed because it was missing
a = df.average
# http://stackoverflow.com/a/4625132
minima = np.r_[True, a[1:] < a[:-1]] & np.r_[a[:-1] < a[1:], True]
minima_index = [i for i,j in enumerate(minima) if j]
period = np.mean([j-i for i,j in zip(minima_index,minima_index[1:])])

# Compute the polynomial coefficients
x = df['decimal_date']
y = df['average']
N = len(df.index)
ws = [polyfit(x, y, n) for n in range(1,4)]
y_fs = [lambda t, w=w: sum([w[i]*t**i for i in range(len(w))]) for w in ws]

fig, ax = plot.subplots(frameon=True)
ax.set_axis_bgcolor((1,1,1))
ax.grid(which='both',color='gray')
for i in ax.spines:
    ax.spines[i].set_color('k')
ax.set_title('Polynomial Fits to Average Monthly\nMeasurements of CO2 Concentration', fontsize=18)
#ax.set_title('Mean Monthly\nMeasurements of CO2 Concentration', fontsize=18)
ax.set_xlabel('Date')
ax.set_ylabel('Average Measurement of CO2 (ppm)')

plot.plot(df['decimal_date'], df['average'], label='Original Data')
for i,y in enumerate(y_fs, 1):
    plot.plot(df['decimal_date'], y(df['decimal_date']), label='Degree=%d'%i)
plot.legend(loc='best', fancybox=True)
#plot.savefig('noaaco2polyfit.eps', format='eps')
plot.show()
import matplotlib.pyplot as plt
import pandas as pd

# Obtenha os dados do Power BI - você só preciso alterar essas informações de todo o code
data = dataset[['variável']]

# Crie o histograma
plt.hist(data, bins=10, color='blue', alpha=0.7)
plt.xlabel('Value' )
plt.ylabel('Frequency')
plt .title('Histogram')

# Mostre o histogram
plt.show()

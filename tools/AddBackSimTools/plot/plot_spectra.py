#! /usr/bin/python3

import matplotlib.pyplot as plt
import numpy as np

from config import *

# list_of_runs = {'60Co': 196, '152Eu': 195,'133Ba':194}
list_of_names = {'60Co': '$^{60}Co$', '152Eu': '$^{152}Eu$','133Ba':'$^{133}Ba$'}
server = 4


def plot_source_spectrun(source, run):

    files = [
        f"../addback_run_{run}_999_eliadeS{server}/sum_fold_1_1.spe",
        f"../addback_run_{run}_999_eliadeS{server}/sum_fold_1_2.spe",
        f"../addback_run_{run}_999_eliadeS{server}/sum_fold_1_3.spe",
        f"../addback_run_{run}_999_eliadeS{server}/sum_fold_1_4.spe"
    ]

    # Function to read one-column .spe files
    def read_spe(file_path):
        # Read the file assuming it has one column (representing either energy or intensity)
        data = np.loadtxt(file_path)
        return data  # Return the data directly (as the single column)

    # Plot data from all files
    plt.figure(figsize=(10, 6))

    for file in files:
        data = read_spe(file)
        # Assuming energy starts from 0, incrementing by 1 for simplicity
        energy = np.arange(len(data))  # Generate dummy energy values (index of data)
        plt.plot(energy, data, label=f"{file}")

    # Customize the plot
    name = list_of_names[source]
    print(name)
    plt.title(fr"{name} spectra")
    plt.xlabel("Energy (keV)")  # Assuming energy values are in the x-axis
    plt.ylabel("Counts (1 keV / bin))")
    plt.xlim(0,2000)
    plt.legend()
    plt.grid(True)
    plt.yscale('log')

    plt.savefig(f'../figures_src/{source}_fold_all.jpg', dpi = 300)

    # Show the plot
    plt.show()



for src, run in list_of_runs.items():
    plot_source_spectrun(src, run)


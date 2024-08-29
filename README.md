# Simple Xsuite study

## Introduction

This minimal repository aims at turning the initial [Dynamic Aperture template](https://github.com/xsuite/DA_study_template), designed to create large, parallelized, parameter scans, into a simpler set of scripts for making simulations of a given accelerator model with [Xsuite](https://github.com/xsuite), under a fixed configuration.

## Installation

The script ```generate.sh``` should take care of:

1. Cloning the repository for the LHC version of interest (HL 1.6, HL 1.3, run III, run III ions). Note that the runIII configurations are only available on CERN AFS for now.
2. Installing the required packages, along with Python if needed
3. Restructuring the repository to keep only the necessary files
4. Mutate the configuration files to match the desired study

Simply run the following command:

```bash
bash generate.sh
```

And follow the instructions. Don't forget to re-activate the virtual environment using ```source miniforge/bin/activate``` every time you open a new terminal and intend to run the Python scripts.

Keep in mind that it remains quite basic, and most likely not very robust. In the event of an issue, please follow the [manual installation guide](manual_installation.md).

## Usage

As in the initial template, the simulation is done in two steps, with two separate configuration files:

1. The Python script ```1_build_distr_and_collider/1_build_distr_and_collider.py``` builds a simple collider as a json file from the optics file and madx model specified in the configuration file ```1_build_distr_and_collider/config.yaml```.
2. The Python script ```2_track_particles/2_track_particles.py``` sets the initial distribution and configuration of the collider, and tracks the particles for a given number of turns, as specified in the configuration file ```2_track_particles/config.yaml```.

A typical pipeline would therefore be:

1. Modify the configuration files ```1_build_distr_and_collider/config.yaml``` and ```2_track_particles/config.yaml``` to match the desired study.
2. Run the collider building script:

    ```bash
    cd 1_build_distr_and_collider
    python 1_build_distr_and_collider.py
    ```

3. When done, run the particle tracking script:

    ```bash
    cd ../2_track_particles
    python 2_track_particles.py
    ```

4. Postprocess the results, which are available as a datadrame in the ```2_track_particles/output_particles.parquet``` folder, which you can read with, for instance, pandas, using the following command:

```python
import pandas as pd

df = pd.read_parquet('output_particles.parquet')
```

## License

This repository is licensed under the [MIT License](LICENSE).

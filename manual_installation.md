# Manual installation guide

This guide is intended for users who wish to install the necessary packages manually, or who have encountered issues with the automatic installation script.

## Cloning the initial Dynamic Aperture template

The first step is to clone the initial Dynamic Aperture template, using the following command:

```bash
git clone --recurse-submodules https://github.com/xsuite/DA_study_template.git --branch branch_name study
```

where `branch_name` is the branch of the template you wish to use. At the time of writing this guide, the available branches are:

- ```hl16```
- ```hl13```
- ```runIII``` (only available on CERN AFS)
- ```runIII_ions_2024``` (only available on CERN AFS)

Do not hesitate to check the original repository for updates.

## Installing Python

If you're new to Python, you can get the last version from miniforge, and activate it using the following commands:

```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh -b -p ./miniforge -f
rm -f Miniforge3-Linux-x86_64.sh
source miniforge/bin/activate
```

Note that you will have to activate it with ```source miniforge/bin/activate``` each time you open a new terminal.

## Installing the required packages

If you simply want something that works, just move into the project directory and install all the packages from pip:

```bash
cd study
pip install -r requirements.txt
```

If you want a cleaner installation with better dependencies management, you can proceed with Poetry, following the [tutorial from the original template](https://github.com/xsuite/DA_study_template/blob/hl16/doc/installation_guide.md).

Don't forget to run the following command to precompile Xsuite, making it faster for subsequent simulations:

```bash
xsuite-prebuild regenerate
```

## Restructuring the repository

The only files of interest are located in:

- ```studies/template_jobs``` (the scripts to do the simulations)
- ```external_dependencies``` (optics files and madx models, xmask package)

You can remove the rest of the repository, as it is not needed for a simple study, using:

```bash
rm -rf .git
rm -rf .gitignore
rm -rf .gitattributes
rm -rf .gitmodules
rm source_python.sh
rm README.md
rm LICENSE
rm pyproject.toml
rm poetry.lock
rm -rf doc
rm -rf studies/submission_files
rm -rf studies/analysis
rm -rf studies/scans
rm -rf studies/scripts
````

Finally, you can restructure to have a cleaner repository, and subsequently mutate the configuration files to match the desired structure:

```bash
# Move the template jobs to the root of the repository
mv studies/template_jobs/1_build_distr_and_collider 1_build_distr_and_collider
mv studies/template_jobs/2_configure_and_track 2_configure_and_track
mv studies/filling_scheme filling_scheme
rm -rf studies

# Now edit the configuration file 1_build_distr_and_collider/config.yaml
# to replace ../../../../../external_dependencies/ ../external_dependencies/
sed -i 's|../../../../../external_dependencies/|../external_dependencies/|g' 1_build_distr_and_collider/config.yaml

# Now edit the configuration file 2_configure_and_track/config.yaml
# to replace ../../filling_scheme/ with ../filling_scheme/
sed -i 's|../../filling_scheme/|../filling_scheme/|g' 2_configure_and_track/config.yaml
```

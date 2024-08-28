#!/bin/bash

# Ask which version of LHC study to generate: hl16 (choice a), hl13 (choice b), runIII (choice c) or runIII_ions_2024 (choice d)
# Store the choice in a variable, ensuring that the choice is valid

echo "Which version of LHC would you like to use for your study?"
echo "a) hl16"
echo "b) hl13"
echo "c) runIII"
echo "d) runIII_ions_2024"
read choice

# Store LHC version in a variable
if [ "$choice" == "a" ]; then
    version="hl16"
elif [ "$choice" == "b" ]; then
    version="hl13"
elif [ "$choice" == "c" ]; then
    version="runIII"
elif [ "$choice" == "d" ]; then
    version="runIII_ions_2024"
else
    echo "Invalid choice"
    exit 1
fi

echo "You have chosen $version"

# Clone the repository https://github.com/xsuite/DA_study_template.git with the branch corresponding
# to the choice made by the user

git clone --recurse-submodules https://github.com/xsuite/DA_study_template.git --branch $version study

# Change the directory to the repository
cd study

# Install miniforge if Python 3.9 or higher is not installed
echo "Is Python 3.9 or higher installed on your system? (y/n)"
read python
if [ $python == "y" ]; then
    echo "Python 3.9 or higher is installed. Proceeding..."
elif [ $python == "n" ]; then
    echo "Python 3.9 or higher is not installed. Installing with miniforge..."
    wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
    bash Miniforge3-Linux-x86_64.sh -b -p ./miniforge -f
    rm -f Miniforge3-Linux-x86_64.sh
    source miniforge/bin/activate
else
    echo "Invalid choice"
    exit 1
fi

# Insall requirments using pip
pip install -r requirements.txt

# Run xsuite-prebuild regenerate
xsuite-prebuild regenerate


### Now simplifying the repository to only the necessary files for the user to run the study
echo "Simplifying the repository to only the necessary files for the user to run the study"

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
mv studies/template_jobs/1_build_distr_and_collider 1_build_distr_and_collider
mv studies/template_jobs/2_configure_and_track 2_configure_and_track
mv studies/filling_scheme filling_scheme
rm -rf studies

echo "Now mutating the configuration files to match the new structure"

# Now edit the configuration file 1_build_distr_and_collider/config.yaml
# to replace ../../../../../external_dependencies/ ../external_dependencies/
sed -i 's|../../../../../external_dependencies/|../external_dependencies/|g' 1_build_distr_and_collider/config.yaml

# Now edit the configuration file 2_configure_and_track/config.yaml
# to replace ../../filling_scheme/ with ../filling_scheme/
sed -i 's|../../filling_scheme/|../filling_scheme/|g' 2_configure_and_track/config.yaml

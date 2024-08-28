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
if [ "$choice" == "a" ]
then
    version="hl16"
elif [ "$choice" == "b" ] 
then
    version="hl13"
elif [ "$choice" == "c" ] 
then
    version="runIII"
elif [ "$choice" == "d" ] 
then
    version="runIII_ions_2024"
else
    echo "Invalid choice"
    exit 1
fi

echo "You have chosen $version"

# Clone the repository https://github.com/xsuite/DA_study_template.git with the branch corresponding to the choice made by the user
# The repository contains the necessary files to generate the LHC study

git clone --recurse-submodules https://github.com/xsuite/DA_study_template.git --branch $version study

# Change the directory to the repository
cd study

# Ask if Poetry is already installed
echo "Is Poetry already installed on your system? (y/n)"
read poetry

if [ $poetry == "y" ]; then
    echo "Poetry is already installed. Proceeding..."
    poetry run pip install nafflib # bug with nafflib... need to install it manually
    poetry install
    poetry run xsuite-prebuild regenerate

elif [ $poetry == "n" ]; then
    echo "Poetry is not installed... Going with the manual pip install"
    echo "Is Python 3.9 or higher installed on your system? (y/n)"
    read python
    if [ $python == "y" ]; then
        echo "Python 3.9 or higher is installed. Proceeding..."
    elif [ $python == "n" ]; then
        echo "Python 3.9 or higher is not installed. Installing with miniforge..."
        wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
        bash Miniforge3-Linux-x86_64.sh -b  -p ./miniforge -f
        rm -f Miniforge3-Linux-x86_64.sh
        source miniforge/bin/activate
    else
        echo "Invalid choice"
        exit 1
    fi

    # Insall requirments using pip
    pip install -r requirements.txt

    # Add editable xmask installation
    pip install -e external_dependencies/xmask

    # Run xsuite-prebuild regenerate
    xsuite-prebuild regenerate

else
    echo "Invalid choice"
    exit 1
fi

### Now simplifying the repository to only the necessary files for the user to run the study
echo "Simplifying the repository to only the necessary files for the user to run the study"

rm -rf .git
rm -rf .gitignore
rm -rf .gitattributes
rm -rf .gitmodules
rm source_python.sh
rm requirements.txt
rm README.md
rm LICENSE
rm -rf doc
rm -rf studies/submission_files
rm -rf studies/analysis
rm -rf studies/scans
rm -rf studies/scripts
mv studies/template_jobs/1_build_distr_and_collider 1_build_distr_and_collider
mv studies/template_jobs/2_configure_and_track 2_configure_and_track
mv studies/filling_scheme filling_scheme
rm -rf studies
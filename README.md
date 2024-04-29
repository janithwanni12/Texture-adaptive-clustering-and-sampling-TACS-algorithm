# Overview
TACS Method for Crystallographic Analysis: A machine learning approach to create high-fidelity Euler angle datasets, improving computational crystal plasticity by accurately mimicking material textures across diverse structures.

# Requirements
Python. 

MATLAB.

MTEX toolbox for MATLAB.

A basic understanding of Python and the MTEX toolbox is expected.  

# Instructions 
1. Execute the EBSD_to_MAT.m script in MATLAB to generate the.MAT file to generate the .npy file. you will need to set up the MTEX environment. Change the file path to your file and the code will ask to select the phase if the EBSD dataset consists of multiple phases. Code will save the file with the name of the dataset and the selected phase. E.g. "Dataset1_phase.MAT" 
3. Use the MAT_to_npy.ipynb script in python to generate the .npy file. Set the file path to the generated .MAT file. E.g. "Dataset1_phase.npy" 
4. Execute the TACS.ipynb script in pytohn to generate the representative dataset. Set the file path to the .npy file and set the number of data points. This will save the dataset as a .txt file. File will have the same name as the .npy file and number of datapoints used. E.g. "Dataset1_phase_350.txt"  
5. Use the plot_PF_maps.m script in MATLAB to plot the data and compare results. The original EBSD dataset is required to determine the symmetry  of the dataset.  
* More instructions are provided in the comments of the scripts. 

# TACS publication

% Initialize MTEX
startup_mtex;

% Set default font sizes for MTEX and MATLAB figures
desiredFontSize = 24;  
setMTEXpref('FontSize', desiredFontSize);
set(groot, 'defaultAxesFontSize', desiredFontSize);
set(groot, 'defaultTextFontSize', desiredFontSize);

% Specify the exact .ctf file and .txt file paths
raw_file = '/Users/janithwanniarachchi/Documents/mybox-selected/D9 Ti-6Al-4V.ctf';  % Replace with the name of the .ctf file
txt_file = '/Users/janithwanniarachchi/Documents/Data_from_K_means-3/TACS_files/D9 Ti-6Al-4V_300.txt';  % Replace with the name of the .txt file

% Extract only the directory path
[dir_path, name, extension] = fileparts(raw_file);
% Load the specific .ctf file
ebsd_all = loadEBSD(raw_file, 'interface', 'ctf', 'convertEuler2SpatialReferenceFrame');

% Rename phases if necessary. For example in the Ti dataset both phases are
% labeled as Ti and this gives and error. 
if strcmp(ebsd_all.CSList{2}.mineral,'Ti' )
    ebsd_all.CSList{2}.mineral = 'Ti_alpha';  % Renaming the phase at index 1
    ebsd_all.CSList{3}.mineral = 'Ti_beta';   % Renaming the phase at index 2
end

% Get the size of the largest data set and remember the length of each data set
if numel(unique(ebsd_all.phase)) == 1 
    ebsd = ebsd_all; % If it is single phase (and not the notIndexed phase), use the entire dataset
    selectedPhaseName = ebsd_all.mineralList{2};
else
   % Display all phases present in the dataset
    disp('Available phases:');
    for i = 2:length(ebsd_all.mineralList)
        fprintf('%d: %s\n', i-1, ebsd_all.mineralList{i});
    end
   % Ask user to select a phase
   selectedPhaseIndex = input('Enter the number of the phase you want to plot: ');
   % Extract the phase name
   selectedPhaseName = ebsd_all.mineralList{selectedPhaseIndex + 1};
   % Extract the EBSD data for the selected phase
   ebsd = ebsd_all(selectedPhaseName);
end

%rot = rotation.byAxisAngle(yvector,90*degree);
%ebsd = rotate(ebsd,rot,'keepXY');

disp(['Plotting PF maps for ', selectedPhaseName, ' phase in the ', name, ' dataset'])

cs = ebsd.CS;

% Define Miller indices for typical pole figures
h = [Miller(1,0,0,cs), Miller(1,1,0,cs), Miller(1,1,1,cs)];

%%%%% ODF calculation
ebsd_rotated = rotate(ebsd, 0*degree, 'center', [0, 0]);   %%% Rotate if reqeuired
odf_raw = calcDensity(ebsd_rotated.orientations);

% Plot the raw ODF
figure_handle = figure;  
plotSection(odf_raw, 'sigma');
mtexColorbar('location', 'eastoutside');
% Set the figure name after plotSection
set(figure_handle, 'Name', 'ODF from Raw EBSD Data', 'NumberTitle', 'off');


% Load Euler angles from the specific .txt file
if isfile(txt_file)
    data = load(txt_file);
else
    error('Specified .txt file does not exist');
end

% Convert Euler angles to orientation objects
ori = orientation.byEuler(data(:,1), data(:,2), data(:,3), cs);

%%%%% ODF from Euler angles
odf_kmeans = calcDensity(ori);

% Plot the ODF from the Euler angles
figure_handle = figure;  
plotSection(odf_kmeans, 'sigma');
mtexColorbar('location', 'eastoutside');
% Set the figure name after plotSection
set(figure_handle, 'Name', 'ODF from TACS', 'NumberTitle', 'off');

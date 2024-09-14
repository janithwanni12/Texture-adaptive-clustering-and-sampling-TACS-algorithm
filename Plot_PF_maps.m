% Initialize MTEX
startup_mtex;
% Set default font sizes for MTEX and MATLAB figures
%Read the file directory code will save the data in the same location

desiredFontSize = 24;  
setMTEXpref('FontSize', desiredFontSize);
set(groot, 'defaultAxesFontSize', desiredFontSize);
set(groot, 'defaultTextFontSize', desiredFontSize);

% Specify the exact .ctf file and .txt file paths
raw_file = '/Users/janithwanniarachchi/Documents/mybox-selected/D4 SS 316L.ctf';  % Replace with the name of the .ctf file
txt_file = '/Users/janithwanniarachchi/Documents/Data_from_K_means-3/TACS_files/D4 SS 316L_500.txt';  % Replace with the name of the .txt file

text_file = load(txt_file);

% Extract only the directory path
[dir_path, name, extension] = fileparts(raw_file);

ebsd_all = loadEBSD(raw_file, 'interface', 'ctf', 'convertEuler2SpatialReferenceFrame'); % if you remove the ; it will show the phase freations


% Rename phases if necessary. For example in the Ti dataset both phases are
% labeled as Ti and this gives and error. 
if strcmp(ebsd_all.CSList{2}.mineral,'Ti' )
    ebsd_all.CSList{2}.mineral = 'Ti_alpha';  % Renaming the phase at index 1
    ebsd_all.CSList{3}.mineral = 'Ti_beta';   % Renaming the phase at index 2
end

%% Get the size of the largest data set and remember the length of each data set
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

% Define Miller indices for typical pole figures in FCC materials
h = [Miller(1,0,0,cs), Miller(1,1,0,cs), Miller(1,1,1,cs)];

%The RAW PF
figure_handle = figure;  
plotPDF(ebsd.orientations, h, 2, 'contourf','linecolor','none');
mtexColorbar;
% Set the figure name after plotSection
set(figure_handle, 'Name', 'PF Maps of Raw Data', 'NumberTitle', 'off');
% Retrieve axes handles
axesHandles = findall(gcf, 'type', 'axes');

min = 0;
maximum = zeros(3,1);

% Set the color scale for each subplot
for pp = 1:length(axesHandles)
    axes(axesHandles(pp)); % Set current axes to the i-th subplot
    maximum(pp) = max(clim); 
end


% Convert Euler angles to orientation objects
ori = orientation.byEuler(text_file(:,1), text_file(:,2), text_file(:,3), cs);


%The TACS PF
figure_handle = figure; 
plotPDF(ori, h, 'contourf','linecolor','none');
mtexColorbar;
% Set the figure name after plotSection
set(figure_handle, 'Name', 'PF Maps of TACS Data', 'NumberTitle', 'off');
% Retrieve axes handles
axesHandles = findall(gcf, 'type', 'axes');

% Set the color scale for each subplot
for pp = 1:length(axesHandles)
    axes(axesHandles(pp)); % Set current axes to the i-th subplot
    clim([0 maximum(pp)]);
end




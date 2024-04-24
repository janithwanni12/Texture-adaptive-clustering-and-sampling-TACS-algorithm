% Initialize MTEX
startup_mtex;

%Read the file directory code will save the data in the same location
file_path = '/Users/janithwanniarachchi/Downloads/FDH fdv1 Site 1 Map Data 8.ctf';
% Extract only the directory path
[dir_path, name, extension] = fileparts(file_path);
out_put_directory = dir_path; %% Change if you want to save the file in a different location

ebsd_all = EBSD.load(file_path); % if you remove the ; it will show the phase freations

if numel(unique(ebsd_all.phase)) == 1 
    ebsd = ebsd_all; % If it is single phase (and not the notIndexed phase), use the entire dataset
else
   % Display all phases present in the dataset
    disp('Available phases:');
    for i = 2:length(ebsd_all.mineralList)
        fprintf('%d: %s\n', i-1, ebsd_all.mineralList{i});
    end
   % Ask user to select a phase
   selectedPhaseIndex = input('Enter the number of the phase you want to analyze: ');
   % Extract the phase name
   selectedPhaseName = ebsd_all.mineralList{selectedPhaseIndex + 1};
   disp(['Generating data for ', selectedPhaseName, 'phase in the ', name, ' dataset'])
   % Extract the EBSD data for the selected phase
   ebsd = ebsd_all(selectedPhaseName);

   % generate the name for the output file 
   output = [name,'_',selectedPhaseName];
end

%% Only if your computer does not have enough memroy to handle the files. Code will first reduce the resolution of the dataset. 
max_limit = 3900000; %%% you have to change this number based on the size of the memory of your computer
if length(ebsd.orientations) > max_limit
    disp('Dataset size is too large, reducing the size')
    euler_angles = ebsd.orientations;
    row_indices = 1:10:size(euler_angles, 1);   %% Reduce the size by one order of magnitude, i.e. reduce the resolution of the dataset. 
    euler_angles = double(Euler(reduced_Euler)); %don't change this variable name, Euler angles. Python code reads the eular angles variable from the .MAT file 
    % Construct the full path for the new .mat file
    mat_file_path = fullfile(out_put_directory, output);
    save(mat_file_path, 'euler_angles');
else
    euler_angles = double(Euler(ebsd.orientations));     %don't change this variable name, Euler angles. Python code reads the eular angles variable from the .MAT file 
    % Construct the full path for the new .mat file
    mat_file_path = fullfile(out_put_directory, output);
    save(mat_file_path, 'euler_angles');
end

%% OPtional: calculate the number of grains 
% Segment the EBSD data into grains
[grains, ebsd.grainId] = calcGrains(ebsd);

% Remove very small grains (optional)
grains = grains(grains.grainSize > 5);

% Count the number of grains
numberOfGrains = length(grains);
% Display the number of grains
disp(['Number of grains belongs to ',selectedPhaseName, ' phase: ', num2str(numberOfGrains)]);
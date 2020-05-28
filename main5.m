% main5.m: load from excel spreadsheet

clear all
close all
clc

%%
infile = "roomDimensions.xlsx";

indata = readtable(infile);


%% Extract non-nan data
idx = find( ~isnan(indata.Width) );

%% Specify radius values
radius_list = [2, 2.5, 3, 3.5, 4, 4.5];
wall_offset = 1;
%%
for i = 1:length(idx)
  
    p = idx(i);
    Width = indata.Width(p);
    Depth = indata.Depth(p);
    PodiumDepth = indata.PodiumDepth(p);
    
    for j = 1:length(radius_list)
        
        % Compute:
        r = radius_list(j);
        [k,x,y,data] = getCirclePos(Width, Depth, PodiumDepth, r, ...
            wall_offset);
        
        % Plot:
        [fig, ax] = gen_plot_results(Width, Depth, PodiumDepth, r, ...
            wall_offset, x, y);
        
    end
    
end

%%

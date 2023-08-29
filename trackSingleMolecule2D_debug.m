%% trackSingleMolecule
% Last modified on August 28, 2023 by Siyang Cheng (sc201@rice.edu)

clear

%% Parameters
pixels_per_micron = 1/5.3;
micron_search_radius = 200; % threshold of identifying the same molecule
pixel_search_radius = micron_search_radius * pixels_per_micron;
FrameRate= 1/0.05; % 1/second

%% Import SML data
load('debug_savestats_sur5.mat');

xy = cat(1, savestats.Centroid);
x = xy(:, 1)'; y = xy(:, 2)';
clear xy;
frame = [savestats.frame];
baclabel = zeros(size(x));
i = min(frame); spanA = find(frame == i);
baclabel(1:length(spanA)) = 1:length(spanA);
lastlabel = length(spanA);


%% Calculate trajectories
for i = min(frame):max(frame)-1 % loop over all frame(i),frame(i+1) pairs.
    spanA = find(frame == i);
    spanB = find(frame == i + 1);
    dx = ones(length(spanA), 1) * x(spanB) - x(spanA)' * ones(1, length(spanB));
    dy = ones(length(spanA), 1) * y(spanB) - y(spanA)' * ones(1, length(spanB));
    dr2 = dx.^2 + dy.^2; % dr2(m,n) = distance^2 between r_A(m) (in frame i) and r_B(n) (in frame i+1)
    dr2test = (dr2 < pixel_search_radius^2); % dr2test=1 if beads A and B could be the same.
        %     [from,to,orphan]=beadsorter(dr2test);% RELATIVE  indices of connected and unconnected beads

    from = find(sum(dr2test, 2) == 1); % connected to only ONE bead in next frame:  from(i) -> 1 bead
    to = find(sum(dr2test, 1) == 1)'; % connected from only ONE bead in previous frame: 1 bead -> to(i)
    [k, j] = find(dr2test(from, to)); % returns list of row,column indices of nonzero entries in good subset of correction
    from = from(k); to = to(j); % translate list indices to row,column numbers.
    orphan = setdiff(1:size(dr2test, 2), to); % anyone not pointed to is an orphan

    from = spanA(from); to = spanB(to); orphan = spanB(orphan); % translate to ABSOLUTE indices
    baclabel(to) = baclabel(from); % propagate labels of connected beads

    if ~isempty(orphan) % there is at least one new (or ambiguous) bead
        baclabel(orphan) = lastlabel + (1:length(orphan)); % assign new labels for new beads.
        lastlabel = lastlabel + length(orphan); % keep track of running total number of beads
    end
end

emptybac.x = 0; emptybac.y = 0; emptybac.area = 0; emptybac.frame = 0; emptybac.boundingbox = 0; emptybac.orientation = 0;
emptybac.majorlength = 0; emptybac.minorlength = 0;
tracks(1:lastlabel) = deal(emptybac); % initialize for purposes of speed and memory management.

for i = 1:lastlabel % reassemble beadlabel into a structured array 'tracks' containing all info
    baci = find(baclabel == i);
    tracks(i).x = x(baci) / pixels_per_micron; % um
    tracks(i).y = y(baci) / pixels_per_micron;
    tracks(i).frame = frame(baci);

end

%% Output
min_track_length=10; % threshold of trajectory length
plotTrajectory(tracks,lastlabel,min_track_length);
plotVelocity(tracks,lastlabel,min_track_length,FrameRate);
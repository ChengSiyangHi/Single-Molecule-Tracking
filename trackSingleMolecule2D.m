%% trackSingleMolecule2D
% Last modified on September 1, 2023 by Siyang Cheng (sc201@rice.edu)

clear

%% Parameters
pixels_per_micron = 1/5.3; % scalebar
micron_search_radius = 100; % threshold of identifying the same molecule
pixel_search_radius = micron_search_radius * pixels_per_micron;
FrameRate= 60; % 1/second = N frames per second

%% Import SML data
[file, path] = uigetfile('C:\Users\sc201\Desktop\Fourier Shell Correlation\FourierShellCorrelation_SMLM\*.csv','Select localization csv file:','MultiSelect','off');
a = readmatrix(fullfile(path,file));

savestats = [];
savestats.frame = a(:,1);
savestats.x = a(:,2);
savestats.y = a(:,3);

frame = [savestats.frame];
x = [savestats.x]';
y = [savestats.y]';

mollabel = zeros(size(x));
i = min(frame); spanA = find(frame == i);
mollabel(1:length(spanA)) = 1:length(spanA);
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
    mollabel(to) = mollabel(from); % propagate labels of connected beads

    if ~isempty(orphan) % there is at least one new (or ambiguous) bead
        mollabel(orphan) = lastlabel + (1:length(orphan)); % assign new labels for new beads.
        lastlabel = lastlabel + length(orphan); % keep track of running total number of beads
    end
end

emptymol.x = 0; emptymol.y = 0; emptymol.area = 0; emptymol.frame = 0; emptymol.boundingbox = 0; emptymol.orientation = 0;
emptymol.majorlength = 0; emptymol.minorlength = 0;
tracks(1:lastlabel) = deal(emptymol); % initialize for purposes of speed and memory management.

for i = 1:lastlabel % reassemble beadlabel into a structured array 'tracks' containing all info
    moli = find(mollabel == i);
    tracks(i).x = x(moli) / pixels_per_micron; % um
    tracks(i).y = y(moli) / pixels_per_micron;
    tracks(i).frame = frame(moli);
end

%% Output
% Histogram of trajectory length
trajLength=calcTrajLength(tracks,lastlabel);
figure;h=histogram(trajLength, 'Normalization', 'pdf');% Normoalized histogram

% Plot trajectory and velocity
min_track_length=50; % threshold of trajectory length
% figure;plotTrajectory(tracks,lastlabel,min_track_length);

velocity=[];velocity.v=[];velocity.mean=[];velocity.msd=[];velocity.msdmax=[];
velocity=calcVelocity(tracks,velocity,lastlabel,min_track_length,FrameRate); % um/s

min_velocity=1;
max_velocity=100;
% for i=1:201 % size(velocity,2)
%     if velocity(i).mean>min_velocity
%         figure;plot(tracks(i).x, tracks(i).y, 'Color', colors(i, 1:3));
%         figure;plot(velocity(i).v);ylabel('um/s');xlabel('frame');
%     end
% end

% Calculate MSD for each trajectory
velocity=calcMSD(tracks,velocity,lastlabel,min_track_length,FrameRate); % um^2
min_msd=112111;
figure;
for i=1:size(velocity,2)
    if ((velocity(i).msdmax)>min_msd) % (velocity(i).mean>min_velocity)
        plot(velocity(i).msd);hold on
    end
end
xlabel('Time (frame)');ylabel('MSD (um^2)');
# SingleMoleculeTracking

This code is used for calculating 2D trajectories of (super) localized single molecules.
Import data should be any csv file that contains localizations in x,y and frame numbers.

Trajectories are connected according how fast the molecule could travel. (Threshold: micron_search_radius)
Trajectories are also filtered afterwards according to their length. (Threshold: min_track_length)

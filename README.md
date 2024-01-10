# SingleMoleculeTracking
### Calculate trajectory
This code is used for calculating 2D trajectories of (super) localized single molecules (bacteria).

1. Diffraction limited tracking\
Import data can be raw videos taken by scientific camera.

2. Super-localized tracking\
Import data should be any csv file that contains localizations in x,y and frame numbers.

Trajectories are connected according how fast the molecule could travel. (Threshold: micron_search_radius)\
Trajectories are also filtered afterwards according to their length. (Threshold: min_track_length)

trackSingleMolecule2D.m : for super-localized (e.g. ThunderSTORM) tracking.\
plotTrajectory.m : plot all trajectories in one figure.

### Analyze trajectory
calcTrackjLength.m : calculate the distribution of the length of each trajectory. (pdf)\
calcVelocity.m : calculate velocity (v-t) and averaged velocity of each trajectory.\

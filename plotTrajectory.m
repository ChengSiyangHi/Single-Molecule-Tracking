function plotTrajectory(tracks,lastlabel,min_track_length)
    for i=1:lastlabel
        colors=prism(lastlabel);
        if length(tracks(i).frame)>min_track_length
            plot(tracks(i).x/5.3,tracks(i).y/5.3,'Color',colors(i,1:3),'LineStyle','none','Marker','.','MarkerSize',5);
            hold on
        end
    end

end
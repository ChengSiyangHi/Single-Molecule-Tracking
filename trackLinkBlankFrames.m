%% Link trajectories between blank frames (Optional section)
frame_blank = 5; % threshold of blank frames
blank_radius = micron_search_radius*frame_blank; % threshold of identifying the same molecule after blank frames

trackslinked=tracks;

% Might connect more than 2 trajectories
for i=1:lastlabel-1
    for j=i+1:lastlabel
        if (trackslinked(j).frame(1)-trackslinked(i).frame(length(tracks(i).frame)))>0 && (trackslinked(j).frame(1)-trackslinked(i).frame(length(tracks(i).frame)))<blank_radius
            dx=trackslinked(i).x(length(tracks(i).x))-trackslinked(j).x(1);
            dy=trackslinked(i).y(length(tracks(i).y))-trackslinked(j).y(1);
            dr2=dx^2+dy^2;
            if dr2<blank_radius^2
                trackslinked(i).x=[trackslinked(i).x trackslinked(j).x];
                trackslinked(i).y=[trackslinked(i).y trackslinked(j).y];
                trackslinked(i).frame=[trackslinked(i).frame trackslinked(j).frame];
                trackslinked(j).x=0;trackslinked(j).y=0;trackslinked(j).frame=0;
                % trackslinked(j)=[];
            end
        end

    end

end

count=0;
for i=1:lastlabel
    if trackslinked(i).x(1)==0
        count=count+1;
    end
end

disp([num2str(count),' trajectories combined.');
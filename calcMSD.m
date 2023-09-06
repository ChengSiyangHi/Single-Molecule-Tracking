function velocity = calcMSD(tracks,velocity,lastlabel,min_track_length,FrameRate)
    % This function calculates the mean square deviation of each track
    for i=1:lastlabel
        if length(tracks(i).frame)>min_track_length
            [X, ~] = a_trous_dwt1D(tracks(i).x, 1);
            [Y, ~] = a_trous_dwt1D(tracks(i).y, 1);
            dx = X(2:end) - X(1);
            dy = Y(2:end) - Y(1);
            velocity(i).msd = ((dx.^2 + dy.^2)); % * FrameRate; % um^2 
            velocity(i).msdmax = ((dx(size(dx,2),1).^2 + dy(size(dy,1)).^2)); % * FrameRate; 
        end
    end
end
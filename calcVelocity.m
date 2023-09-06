function velocity = calcVelocity(tracks,velocity,lastlabel,min_track_length,FrameRate)
    % colors=prism(lastlabel);
    for i=1:lastlabel
        if length(tracks(i).frame)>min_track_length
            [X, ~] = a_trous_dwt1D(tracks(i).x, 1);
            [Y, ~] = a_trous_dwt1D(tracks(i).y, 1);
            dx = X(2:end) - X(1:end - 1);
            dy = Y(2:end) - Y(1:end - 1);
            dr = sqrt(dx.^2 + dy.^2);
            velocity(i).v = dr * FrameRate; % um/frame -> um/s
            velocity(i).mean = mean(velocity(i).v); 
           
        end
    end

end
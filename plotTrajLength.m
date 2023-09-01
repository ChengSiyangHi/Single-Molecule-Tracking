function trajLength=plotTrajLength(tracks,lastlabel)
    % colors=prism(lastlabel);
    trajLength=zeros(1,lastlabel);
    for i=1:lastlabel
        trajLength(i)=length(tracks(i).frame);
    end

end
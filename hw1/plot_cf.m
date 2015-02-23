function h = plot_cf(pose)

    pqr = pose(1:3);
    R = pqr2R(pqr);

    origin = [0,0,0]';
    x = R*[1,0,0]';
    y = R*[0,0,-1]';
    z = R*[0,1,0]';
    
    cx = origin + x; % new vector c = origin ~ xyz
    cy = origin + y;
    cz = origin + z;

    starts = [pose(1) pose(2) pose(3);
              pose(1) pose(2) pose(3);
              pose(1) pose(2) pose(3)];
    ends = [cx cy cz];
    
    hold on
    quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'color', [0,1,0])
    %quiver3(x,y,z,u,v,w) = direction (u,v,w), points determined by (x,y,z)
    axis equal

end

function [ h ] = plot_cf( pose )
% plot_cf
%   Plot the a red-green-blue coordinate frame basis for the given pose
%
    % Convert to a 4x4 transformation matrix if in 
    if prod(size(pose) == [6, 1])
       pose = Cart2T(pose); 
    end
    
    % Plot world coordinate system
    hold on          

    % Let's make some cylinders!
    [X,Y,Z] = cylinder(0.02,20);   % Unit cylinder, radius = 0.001
    
    X = X/10;
    Y = Y/10;
    Z = Z/10;
    
    % Tack a cone on top by making another cylinder, shifting it up, and
    % setting the second points to [0,0,z]    
    [coneX, coneY, coneZ] = cylinder(0.05,20);
    coneX(2,:) = 0;
    coneY(2,:) = 0;
    coneZ(2,:) = 0.2;
    
    coneX = coneX/10;
    coneY = coneY/10;
    coneZ = coneZ/10;
    
    % And shift everything up 1
    coneZ = coneZ + 1/10; 
    
    X = [X coneX];
    Y = [Y coneY];
    Z = [Z coneZ];
    
    nPoints = size(X,2);
    
    % Make a matrix of points with 1 tacked on, so we can just chunk them
    % through the translation matrix
    c0Pts = [X(1,:); Y(1,:); Z(1,:); ones(1,nPoints)];
    c1Pts = [X(2,:); Y(2,:); Z(2,:); ones(1,nPoints)];
    
    % Create matrices which rotate these points about the x and y axes
    Ty = Cart2T([0;0;0;0;pi/2;0]);
    Tx = Cart2T([0;0;0;0;0;-pi/2]);
    
    % Transform ALL the points
    x0Pts = pose*Tx*c0Pts;
    x0Pts = x0Pts(1:3,:);
    x1Pts = pose*Tx*c1Pts;
    x1Pts = x1Pts(1:3,:);
    y0Pts = pose*Ty*c0Pts;
    y0Pts = y0Pts(1:3,:);
    y1Pts = pose*Ty*c1Pts;
    y1Pts = y1Pts(1:3,:);
    z0Pts = pose*c0Pts;
    z0Pts = z0Pts(1:3,:);
    z1Pts = pose*c1Pts;
    z1Pts = z1Pts(1:3,:);
        
    % Convert back to what MatLAB needs to plot surfaces
    xX = [x0Pts(1,:); x1Pts(1,:)];
    xY = [x0Pts(2,:); x1Pts(2,:)];
    xZ = [x0Pts(3,:); x1Pts(3,:)];
    
    yX = [y0Pts(1,:); y1Pts(1,:)];
    yY = [y0Pts(2,:); y1Pts(2,:)];
    yZ = [y0Pts(3,:); y1Pts(3,:)];
    
    zX = [z0Pts(1,:); z1Pts(1,:)];
    zY = [z0Pts(2,:); z1Pts(2,:)];
    zZ = [z0Pts(3,:); z1Pts(3,:)]; 
    
    % Plot the cylinders
    hcx = surf(xX, xY, xZ, 'FaceColor', [1,0,0], 'EdgeColor', [1,0,0]);
    hcy = surf(yX, yY, yZ, 'FaceColor', [0,1,0], 'EdgeColor', [0,1,0]);
    hcz = surf(zX, zY, zZ, 'FaceColor', [0,0,1], 'EdgeColor', [0,0,1]);
   
    h = [hcx; hcy; hcz];
end

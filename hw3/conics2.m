function c = conics2()
    global ctx;
    global cmod;
    global points3D;
    global uv;
    global conics;

    conics = csvread('conics-new.csv');

    pts = load('conics-new.csv');
    [i,j]= unique(pts(:,2)); %remove duplicates of points id at same frame
                             %i = frame#, j = points# at that frame
    pts(pts(:,2)<0,:) = [];  %remove negative id 

    xwp = pts(j,5:7)'
    ids = pts(j,2)'; %points id
    

%    x = [xwc; cmod.fx; cmod.fy; cmod.cx; cmod.cy];
    
    ctx.nImg = numel(unique(pts(:,1)));
    ctx.ids = ids; %- min(ids)+1;
    ctx.target_pts = xwp; %5~7 cols from conics.csv(x,y,z)
    
    
    %question 3a - Load and diplay the points
    for ii = 0:ctx.nImg-1 %img frame: 0 ~ 105 (total 106)
        ctx.cur_ids = pts(find(pts(:,1) == ii), 2); %point(id) at that frame
        ctx.z       = pts(find(pts(:,1) == ii), 2:4)';
        hold on 
        axis ij; xlim([0 800]); ylim([0 600]);
        project();
    end
    waitforbuttonpress();
    clf;
    
    points3D = unique(conics(:,[2,5:7]), 'rows');
    points3D(points3D(:,1)==-1,:)=[]; %clearn bad points

    %question 3b - plotting 3d points
    plot3(ctx.target_pts(1,:), ctx.target_pts(2,:), ctx.target_pts(3,:), 'o');
    waitforbuttonpress();
    clf;
    
    
    %question 3c - plot 3d points with initial camera pose
    xwc = [0 0 -1 0 0 0]';
    Twc = cart2t(xwc); % Twc = 4 by 4
    cmod = struct ('fx',476.5758, 'fy',475.3656,'s',0,'cx',399.4792, 'cy',299.4964,'imgW',800, 'imgH',600);
%cmod = struct ('fx',500, 'fy',500,'s',0,'cx',400, 'cy',300,'imgW',800, 'imgH',600);

    hx = proj_3d_to_2d(Twc, xwp, cmod);
    hold on 
    axis ij; xlim([0 800]); ylim([0 600]);
    plot(hx(1,:), hx(2,:), 'x');
    
    waitforbuttonpress();
    clf;
    
    %question 3d - write residual function
    x = [0 0 -1 pi/2 0 0]';
 xwc = [x; cmod.fx; cmod.fy; cmod.cx; cmod.cy];
    
    uv = conics(conics(:,1) == 0, 2:4);
    r = residual (xwc); % r == differences of original uv & projected uv
    display(r);
    
    %question 3e - get camera pose that minimize r
    poseN = [0 0 -1 pi/2 0 0]';   
pose = [poseN; cmod.fx; cmod.fy; cmod.cx; cmod.cy];    
    
    for i = 0:ctx.nImg-1
        uv = conics(conics(:,1) == i, 2:4);
        options = optimoptions('lsqnonlin', 'Algorithm', 'trust-region-reflective', 'TolFun', 1.0e-8, 'TolX', 1.0e-8);
        xwc = lsqnonlin(@residual, pose, [], [], options);

        pose = xwc;
        Twc = cart2t(pose(1:6));
        %xwp = pts(find(pts(:,1) == i), 5:7)'; %xwp = 450 points at this frame

        hx = proj_3d_to_2d(Twc, ctx.target_pts, cmod);
        
        hold on 
        axis ij; xlim([0 800]); ylim([0 600]);
        plot(hx(1,:), hx(2,:), 'o');
        
        fprintf('Doing optimization... Sum of final Residual = %f\n', sum(sum(residual(xwc))));
    
        camera_pose(:,i+1) = xwc;
        pause(0.02);
        clf;
        
        if(i == ctx.nImg-1)
            display(xwc);
        end
    end
    
    waitforbuttonpress;
    clf;
        
    %question 3f - plot current predicted measurements, based on pose x
    for i = 0:ctx.nImg-1
        ctx.cur_ids = pts(find(pts(:,1) == i), 2); %point(id) at that frame
        ctx.z       = pts(find(pts(:,1) == i), 3:4)';
        xwp         = pts(find(pts(:,1) == i), 5:7)';
        
        Twc = cart2t(camera_pose(1:6,i+1));

        hx = proj_3d_to_2d(Twc, ctx.target_pts, cmod);
        
        hold on 
        axis ij; xlim([0 800]); ylim([0 600]);
        plot(hx(1,:), hx(2,:), 'o');  % plotting projected 3d points
        
        plot(ctx.z(1,:), ctx.z(2,:), '.'); % plottig original uv
        pause(0.02);
        clf;
    end
    
    waitforbuttonpress;
    clf;
  
 %question 3g - draw camera pose  
    for i = 0:ctx.nImg-1
        
        hold on 
        axis([0 1 0 1 -1 1]);

        %display(camera_pose(:,i+1));
        
        plot3(ctx.target_pts(1,:), ctx.target_pts(2,:), ctx.target_pts(3,:), 'o');
        plot_cf2(camera_pose(1:6,i+1));
        
        pause(0.02);
        %clf
        %fprintf('drawing camera pose n times\n');
    end
end

function p = project()
    global ctx;
    hold on
    plot(ctx.z(2,:), ctx.z(3,:), '.'); 
    
    pause(0.02);
    clf();
end
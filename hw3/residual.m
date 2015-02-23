function r = residual( x )

    global uv;
    global points3D;
    global cmod;
    
    Twc = Cart2T(x(1:6));
%{  
    cmod.fx = x(7);
    cmod.fy = x(8);
    cmod.cx = x(9);
    cmod.cy = x(10);
%}  
    uv_res = zeros(size(points3D,1), 5);
    uv_res(:,2:3) = proj_3d_to_2d(Twc, points3D(:,2:4)', cmod)';
    uv_res(:,1) = points3D(:,1);
    
    for i = 0:449
        hx = uv(uv(:,1) == i, 2:3);
        if hx
            uv_res(uv_res(:,1)==i, 4:5) = hx; %4:5 == ctx.z
        else
            uv_res(uv_res(:,1)==i, :) = [];
        end
    end
           
    bad_idx = isnan(uv_res(:,4)) | isnan(uv_res(:,5));
    
    uv_res(bad_idx ,:) = [];
    
    r = zeros(size(uv_res,1),2);
    r(:,1:2) = uv_res(:,4:5) - uv_res(:,2:3);             
    
end
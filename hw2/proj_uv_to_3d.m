function ray = proj_uv_to_3d(uv, cmod)
    d = 1;
    [r,c] = size(uv);
    
    for i=1:c
        u = (uv(1,i) - cmod.cx) / cmod.fx;
        v = (uv(2,i) - cmod.cy) / cmod.fy;
    
        D = sqrt(u^2 + v^2 + d^2);
    
        ray(1,i) = u(1,i)/D;
        ray(2,i) = v(1,i)/D;
        ray(3,i) = d(1,i)/D;

    end
end
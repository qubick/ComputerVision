function xwp = proj_uvd_to_3d(uv, d, cmod)

    [r,c] = size(uv);
    ray = proj_uv_to_3d(uv, cmod);

    for i=1:c
        xwp(1:3,i) = ray(1:3,i) * d(1,:);
    end
end
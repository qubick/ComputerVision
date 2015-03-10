function uv = proj_3d_to_2d(twc, xwp, cmod)
% twc   = 4 by 4 pose matrix - transformed from 6 by 1 pose
% xwp   = 3 by N matrix of point P
% k     = matlab struct of cmod, containing fx,fy,s,cx,cy

    K = [cmod.fx    cmod.s    cmod.cx;
            0       cmod.fy   cmod.cy;
            0          0          1  ];

    [r,c]   = size(xwp);
    xwc     = [xwp;ones(1,c)];
%    Twc= inv(twc);
    xcp = twc*xwc;
    
    uvw = K * xcp(1:3,:);
    m = 0;
    uv = zeros(2,c);
    for i=1:c
%        xcp(1:4,i) = inv(twc)*xwc(1:4,i); %xcp = 4by4
%        uvw(1:3,i) = K * xcp(1:3,i);

        if(xcp(3,i) < 0) %only for the positive-z
            uv(:,i-m) = [uvw(1:2,i)/uvw(3,i)];
    %hold on
    %xlim([0, 800]); ylim([0, 600]);
    %plot(uv(1,i), uv(2,i), 'o');

    %clf();
        else
            m = m+1;
        end
    end
end
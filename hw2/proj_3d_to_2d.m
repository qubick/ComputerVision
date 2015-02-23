function uv = proj_3d_to_2d(twc, xwp, cmod)
% uv    = 2D pixel image points of 3D real world points
% twc   = 4 by 4 pose matrix 
% xwp   = 3 by N matrix of point P
% k     = matlab struct of cmod, containing fx,fy,s,cx,cy

    K = [cmod.fx    cmod.s      cmod.cx;
                0   cmod.fy     cmod.cy;
                0       0       1];

[r,c] = size(xwp);
xwpN = [xwp;ones(1,c)];

    for i=1:c
        xcp(1:4,i) = inv(twc)*xwpN(1:4,i); %xcp = 4by4
        % filling 4th row with 1, take each cols to assign into xcp
        
        if(xcp(3,i) > 0) %only for the positive-z
            uvw(1:3,i) = K * xcp(1:3,i);
            uv(1:2,i) = [uvw(1:2,i)/uvw(3,i)];
            
            hold on
            xlim([0, cmod.imgW]); ylim([0, cmod.imgH]);
            plot(uv(1,i),uv(2,i),'x');
            % disp([uv(1,i),uv(2,i)]);
        end
    end
end
function test = test2()

    k = struct ('fx',320, 'fy',240, 's',0, 'cx',320, 'cy',240, 'imgW',640, 'imgH',480);
    sp = 20;

    xwp = [ -sp    0   +sp  -sp    0  +sp  -sp    0  +sp;
            +sp   +sp  +sp    0    0    0  -sp  -sp  -sp;
            100  100   100  100  100  100  100  100  100];
    %roll
    for x = 0:0.1:8*pi %roll
        twc = cart2t([0 0 0 x 0 0]');
        proj_3d_to_2d(twc, xwp, k);
        pause(0.02);
        clf();
    end

    %pitch
    for y = 0:0.1:8*pi %roll
        twc = cart2t([0 0 0 0 y 0]');
        proj_3d_to_2d(twc, xwp, k);
        pause(0.02);
        clf();
    end

    %yaw
    for z = 0:0.1:8*pi %roll
        twc = cart2t([0 0 0 0 0 z]');
        proj_3d_to_2d(twc, xwp, k);
        pause(0.02);
        clf();
      end
end


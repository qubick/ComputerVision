function [resL, resR] = residual(p, uvl, uvr, Twca, Twcb, cmodl, cmodr)

    2dl = proj_3d_to_2d(Twca, p, cmodl);
    2dr = proj_3d_to_2d(Twcb, p, cmodr);

    resL = uvl(1:2,:) - 2dl(1:2,:);
    resR = uvr(1:2,:) - 2dr(1:2,:);    
end
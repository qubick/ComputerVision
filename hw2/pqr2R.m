function R = pqr2R(pqr)

    p = pqr(1);
    q = pqr(2);
    r = pqr(3);

    Rx = [      1       0      0;
                0   cos(q) sin(q);
                0  -sin(q) cos(q)];
 
    Ry = [ cos(r)       0  -sin(r);
                0       1      0;
           sin(r)       0   cos(r)];
            
    Rz = [ cos(p)  -sin(p)      0;
           sin(p)   cos(p)      0;
                0       0      1];
            
     R = Ry*Rx*Rz;
     
%    R(1,1) = cos(p)*cos(r)-sin(p)*sin(q)*sin(r);
%    R(1,2) = cos(r)*sin(p)+cos(p)*sin(q)*sin(r);
%    R(1,3) = -cos(q)*sin(r);

%    R(2,1) = -cos(q)*sin(p);
%    R(2,2) = cos(p)*cos(q); 
%    R(2,3) = sin(q);

%    R(3,1) = cos(p)*sin(r)+cos(r)*sin(p)*sin(q); 
%    R(3,2) = sin(p)*sin(r)-cos(p)*cos(r)*sin(q); 
%    R(3,3) = cos(q)*cos(r);
end
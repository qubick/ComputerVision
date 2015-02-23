 function T = cart2t(Xvc)
 
    t = Xvc(1:3);
    pqr = Xvc(4:6);
    R = pqr2R(pqr);
    T = [R t;0 0 0 1];
    
 end
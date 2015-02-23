function Xvc = T2cart(T)

 R = T(1:3, 1:3);
 xyz = T(1:3,4);
 pqr = R2pqr(R);
 Xvc = [xyz,pqr];
 
end
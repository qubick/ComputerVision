function StereoVisualOdometry3

    run /home/viki/vlfeat-0.9.20/toolbox/vl_setup
    addpath('/home/viki/calibu/matlab')
    
%    rig = calibu_rig('/home/viki/Downloads/cityblock/cameras.xml');
    
    lfiles = dir('/home/viki/Downloads/cityblock/images/left*');
    rfiles = dir('/home/viki/Downloads/cityblock/images/right*');
    n = size(lfiles);

    xl_prev = []; xl_cur = [];
    yl_prev = []; yl_cur = [];
    xr_prev = []; xr_cur = [];
    yr_prev = []; yr_cur = [];
    
    for ii = 1:10 %n
       limg_prev = imread(strcat('/home/viki/Downloads/cityblock/images/', lfiles(ii).name));
       rimg_prev = imread(strcat('/home/viki/Downloads/cityblock/images/', rfiles(ii).name));
       
       limg_cur = imread(strcat('/home/viki/Downloads/cityblock/images/', lfiles(ii+1).name));
       rimg_cur = imread(strcat('/home/viki/Downloads/cityblock/images/', rfiles(ii+1).name));

       
       [fl_prev, dl_prev] = vl_sift(im2single(limg_prev)); % fl(1:2) is the descriptor area position(x,y)
       [fr_prev, dr_prev] = vl_sift(im2single(rimg_prev)); % dl is descriptor of corresponding frame f

       [fl_cur, dl_cur] = vl_sift(im2single(limg_cur)); 
       [fr_cur, dr_cur] = vl_sift(im2single(rimg_cur));
       
       
       %matches = x-,y-pos (index) of match descriptors (x:y, # of descriptor)
       %scores = math score of this point
       [matches_prev, scores_prev] = vl_ubcmatch(dl_prev, dr_prev); 
       [matches_cur, scores_cur] = vl_ubcmatch(dl_cur, dr_cur);
       
       [drop_prev, perm_prev] = sort(scores_prev, 'descend');
       [drop_cur, perm_cur] = sort(scores_cur, 'descend');
       
       
       matches_prev = matches_prev(:, perm_prev);
       scores_prev = scores_prev(perm_prev);
       
       matches_cur = matches_cur(:, perm_cur); %index of features
       scores_cur = scores_cur(perm_cur);
       
%matches_prev(1,:) = matches_prev(ismember(matches_prev(1,:),matches_cur(1,:)));
        figure(1);
       imshow(vertcat(cat(2, limg_prev, rimg_prev), cat(2,limg_cur, rimg_cur)), 'Border', 'tight');
       
        hold on;
       xl_prev = fl_prev(1, matches_prev(1,:));
       xr_prev = fr_prev(1, matches_prev(2,:)) + size(limg_prev,2);
       yl_prev = fl_prev(2, matches_prev(1,:));
       yr_prev = fr_prev(2, matches_prev(2,:));
       
       xl_cur = fl_cur(1, matches_cur(1,:));
       xr_cur = fr_cur(1, matches_cur(2,:)) + size(limg_cur,2);
       yl_cur = fl_cur(2, matches_cur(1,:)) + size(limg_cur,1);
       yr_cur = fr_cur(2, matches_cur(2,:)) + size(limg_cur,1);
       
% question 3, triangulate      
       uvl_prev = fl_prev(1:2,matches_prev(1,:)); % find descriptor center fl(x,y), which is matched
       uvr_prev = fr_prev(1:2,matches_prev(2,:));
        
        cmodl = struct('fx',268.5119, 'fy', 268.5119, 'cx', 320.5, 'cy', 240.5);
        cmodr = struct('fx',268.5119, 'fy', 268.5119, 'cx', 320.5, 'cy', 240.5);

        Twca = [ 1, 0, 0, 0.2; 0, 1, 0, 0.05; 0, 0, 1, -2.0 ];
        Twcb = [ 1, 0, 0, 0.2; 0, 1, 0, 0.75; 0, 0, 1, -2.0 ];

        Ta = t2cart(Twca);
        Tb = t2cart(Twcb);

        figure (2); hold on;
        
        %index == inliers
        [p, index] = triangulate(uvl_prev,uvr_prev,Twca,Twcb,cmodl,cmodr)
        plot3(p(1,:), p(2,:), p(3,:), '.');
        
        figure (3); hold on;
        plot_cf(Twca);
        plot_cf(Twcb);
        
        waitforbuttonpress;
        clf;
        
% question 4 - Tracking
       figure (1); hold on;
       
       %remove points from dl_prev, dr_prev which is not match      
       [rl,cl] = size(dl_prev); %clean previous frame
       for ii = 1:rl
           for ij = 1:cl
              if dl_prev(ii,ij) ~= dr_prev(ii,ij)
                 dl_prev(ii,ij) = 0;
                 dr_prev(ii,ij) = 0;
              end
           end
       end
       
       [matches_new_v1, scores_new_v1] = vl_ubcmatch(dl_cur, dl_prev); %dl_prev && dr_prev was cleaned 
       [drop, perm_prev_new_v1] = sort(scores_new_v1, 'descend');
       matches_new_v1 = matches_new_v1(:, perm_prev_new_v1);
       scores_new_v1 = scores_new_v1(perm_prev_new_v1);

       uvl_prev_new = fl_prev(1:2,matches_new_v1(1,:));
       uvl_cur_new = fl_cur(1:2,matches_new_v1(1,:));

       
       [matches_new_v2, scores_new_v2] = vl_ubcmatch(dr_cur, dr_prev); %dl_prev && dr_prev was cleaned 
       [drop, perm_prev_new_v2] = sort(scores_new_v2, 'descend');       
       matches_new_v2 = matches_new_v2(:, perm_prev_new_v2);
       scores_new_v2 = scores_new_v2(perm_prev_new_v2);
       
       uvr_prev_new = fr_prev(1:2,matches_new_v1(1,:));
       uvr_cur_new = fr_cur(1:2,matches_new_v1(1,:));

 %{      
       %find uvr_prev, uvr_cur with uvl_prev, uvl
       idx = find(ismember(uvl_prev_new(1,:),uvr_prev_new(1,:)));
       uvl_prev_new = uvl_prev_new(1:2,idx);
       uvr_prev_new = uvr_prev_new(1:2,idx);
%}       
       
       h1 = line([uvl_prev_new(1,:);uvl_cur_new(1,:)], [uvl_prev_new(2,:);uvl_cur_new(2,:)+size(limg_cur,1)]);
       h2 = line([uvr_prev_new(1,:)+size(limg_cur,2);uvr_cur_new(1,:)+size(limg_cur,2)], [uvr_prev_new(2,:);uvr_cur_new(2,:)+size(limg_cur,1)]);

       h3 = line([uvl_prev_new(1,:);uvr_prev_new(1,:)+ size(limg_prev,2)],[uvl_prev_new(2,:);uvr_prev_new(2,:)])
       %set(h, 'linewidth',1);
       waitforbuttonpress;
       %clf;
  
    end
      
end
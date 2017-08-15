function n_im_array = applyTransforms( im_array, n_scale, n_theta, n_trans )
%%
%

n_x = n_trans(:, 1); n_y = n_trans(:, 2);

n = size(n_scale, 1);
cumulative_T = cell(n, 1);
for k = 1:n
    % cumulative_T{k} = [[[cos(n_theta(i,1)) -sin(n_theta(i,1));...
    %     sin(n_theta(i,1)) cos(n_theta(i,1))]; ...
    %         n_x(i,1) n_y(i,1)], [0 0 1]'];
    cumulative_T{k} = [ cos(n_theta(k, 1)) -sin(n_theta(k, 1)) 0;
                        sin(n_theta(k, 1)) cos(n_theta(k, 1))  0;
                        n_x(k, 1)          n_y(k, 1)           1 ];
end

% Calculate per-frame individual transforms
n_T = cell(n, 1);
n_T{1} = cumulative_T{1};
for k = n:-1:2
    % curr_s = n_scale(k) / n_scale(k - 1);
    % curr_theta = n_theta(k) - n_theta(k - 1);
    % n_T{k} = inv(cumulative_T{k - 1}) * cumulative_T{k};
    n_T{k} = cumulative_T{k} \ cumulative_T{k - 1};
end

% Apply optimized transforms
n_im_array = cell(n + 1, 1);
n_im_array{1} = im_array{1};
for k = 2:n + 1
    n_im_array{k} = imwarp(im_array{k}, affine2d(n_T{k - 1}));
end
end
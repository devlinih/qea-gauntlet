% right now this is bridge of doom

clc, clear all

% Wheelbase
d = .235;

% Load the simulated data from the encoders
encoder_table = readtable('encoders.csv');
encoder = encoder_table{:,:};

% Manually looking at the file, movement does not appear to start until
% 77.4 seconds. This is the 105th entry.
encoder = encoder(105:size(encoder, 1), :);

% Normalize time to 0
encoder_time = encoder(:,1) - encoder(1,1);
encoder_l = encoder(:,2);
encoder_r = encoder(:,3);

% Calculate wheel velocities
encoder_v_l = diff(encoder_l) ./ diff(encoder_time);
encoder_v_r = diff(encoder_r) ./ diff(encoder_time);

encoder_v = (encoder_v_l + encoder_v_r) ./ 2;
encoder_omega = (encoder_v_r - encoder_v_l) ./ d;


position = [0; 0];
heading = [1; 0];
diff_encoder_time = diff(encoder_time);


clf
axis equal
hold on

num_vec = 7;
stop_gaps = round(length(encoder_v) / num_vec);
current_vec = 1;

for i = 1:153
    position(:,i+1) = position(:,i) + (heading(:,i) .* encoder_v(i) .* diff_encoder_time(i));
    % Rotate the heading
    theta = encoder_omega(i) * diff_encoder_time(i);
    R = [cos(theta), -sin(theta);...
         sin(theta), cos(theta)];
    heading(:, i+1) = R * heading(:,i);

    % Print the tangent vectors
    if mod(i, stop_gaps) == 0
        pos_actual(:,current_vec) = [position(1, i); position(2, i)];
        head_actual(:,current_vec) = [heading(1, i), heading(2, i)];
        current_vec = current_vec + 1;
    end
end

% Plot measured trajectory
plot(position(1,:), position(2,:), 'b--', 'LineWidth', 2.0)

xlabel("X Position (Meters)",'FontSize', 30)
ylabel("Y Position (Meters)",'FontSize', 30)

% Navigate the gauntlet challenge, level 1

% Collect scan data, do not RANSAC fit it

% collectScans()

% Define the potential field of the gauntlet (using the pre-defined
% values)

clear

[x,y] = meshgrid(-2:0.1:3,-4:0.1:1.5);

% Params for the circle as column vector of [h; k; r]
circle = [.75; -2.5; .25];

% Params for the line as matrix. Each column contains endpoints in the
% format [x1; y1; x2; y2]
walls = [ 2.5, -1.50, -1.50,  2.50;...
          1.0,  1.00, -3.37, -3.37;...
         -1.5, -1.50,  2.50,  2.50;...
          1.0, -3.37, -3.37,  1.00];

generic_box_p1 = [0.25, -.25, -.25, .25;...
                  0.25, .25, -.25, -.25];
generic_box_p2 = [-.25, -.25, .25, .25;...
                  0.25, -.25, -.25, .25];

theta = pi/4;
R = [cos(theta), -sin(theta);...
     sin(theta), cos(theta)];

boxa = [generic_box_p1+[1.41;-2]; generic_box_p2+[1.41;-2]];
boxb = [R*generic_box_p1+[1;-.7]; R*generic_box_p2+[1;-.7]];
boxc = [R*generic_box_p1+[-.25;-1]; R*generic_box_p2+[-.25;-1]];

lines = [walls boxa boxb boxc];

v = 0;
[~, num_lines] = size(lines);
for u = linspace(0, 1, 50)
    % Potential field for circle
    v = v + 5*circle_source(x, y, circle, u);

    % Potential field for lines
    for i = 1:num_lines
        points = lines(:, i);
        v = v - line_source(x, y, points, u);
    end
end

% Start collecting path data

% Follow gradient descent based on potential field

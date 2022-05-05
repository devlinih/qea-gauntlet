function res = approx_grad(x_pos, y_pos)
    x = -4:0.2:4;
    y = x';

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

    lines = [boxa boxb boxc];

    v = 0;
    [~, num_lines] = size(lines);
    for u = linspace(0, 1, 50)
        % Potential field for circle
        % v = v - 4*circle_source(x, y, circle, u);


        % Potential Field for walls
        for i = 1:4
            % points = walls(:, i);
            % v = v + line_source(x, y, points, u);
        end
    end

    circ_x = circle(1);
    circ_y = circle(2);
    v = v - 10*log(sqrt((x-circ_x).^2 + (y-circ_y).^2));

    % Potential field for boxes
    v = v + log(sqrt((x-1).^2 + (y+.7).^2));
    v = v + log(sqrt((x+.25).^2 + (y+1).^2));
    v = v + log(sqrt((x-1.41).^2 + (y+2).^2));

    [fx, fy] = gradient(v);

    [~,ix] = min(abs(x - x_pos));
    [~,iy] = min(abs(y - y_pos));

    f_grad = [fx(ix,iy); fy(ix,iy)];
    res = f_grad;
end
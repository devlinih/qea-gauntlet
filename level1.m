% Navigate the gauntlet challenge, level 1

% Collect scan data, do not RANSAC fit it

% collectScans()

% Define the potential field of the gauntlet (using the pre-defined
% values)

[x,y] = meshgrid(-2:0.3:3,-4:0.3:2);

v = 0

clf
axis equal
hold on

for u = linspace(0, 1, 50)
  % Walls

  wall1_x = -1.5;
  wall1_y = 4.37 * u - 3.37;

  wall2_x = 2.5;
  wall2_y = 4.37 * u - 3.37;

  wall3_x = 4 * u - 1.5;
  wall3_y = -3.37;

  wall4_x = 4 * u - 1.5;
  wall4_y = 1;

  % Boxes
  box1_x = -.25;
  box1_y = .5 * u - .25;
  box2_x = .25;
  box2_y = .5 * u - .25;
  box3_x = .5 * u - .25;
  box3_y = -.25;
  box4_x = .5 * u - .25;
  box4_y = .25;

  box_generic = [box1_x, box2_x, box3_x, box4_x;...
                 box1_y, box2_y, box3_y, box4_y];

  boxa = box_generic + [1.41;...
                        -2];

  angle = pi/4;
  R = [cos(angle) -sin(angle);...
       sin(angle) cos(angle)];

  boxb = R * box_generic + [1;...
                            -.7];

  boxc = R * box_generic + [-.25;...
                            -1];
  plot(boxa(1, :), boxa(2, :), 'ko')
  plot(boxb(1, :), boxb(2, :), 'ko')
  plot(boxc(1, :), boxc(2, :), 'ko')

  % The barrel
  theta = 2 * pi * u;
  barrel = [.25*cos(theta);...
            .25*sin(theta)];
  barrel = barrel + [.75;...
                     -2.5];
  plot(barrel(1,:), barrel(2,:), 'bo')
end


% Start collecting path data

% Follow gradient descent based on potential field

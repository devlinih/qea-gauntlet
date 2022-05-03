clf
hold on
axis equal

contourf(x, y, v, 'ShowText', 'On')

for i = 1:12
    current_line = lines(:, i);
    x1 = current_line(1);
    y1 = current_line(2);
    x2 = current_line(3);
    y2 = current_line(4);
    plot([x1 x2], [y1 y2], 'k');
end

theta = linspace(0, 2*pi);
h = circle(1);
k = circle(2);
r = circle(3);
circ_x = h + r * cos(theta);
circ_y = k + r * sin(theta);
plot(circ_x, circ_y, 'k')

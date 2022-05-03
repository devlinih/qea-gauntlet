function res = line_source(x, y, points, u)
    x1 = points(1);
    y1 = points(2);
    x2 = points(3);
    y2 = points(4);
    dx = x2 - x1;
    dy = y2 - y1;
    a = x1 + u * dx;
    b = y1 + u * dy;
    res = log(sqrt((x-a).^2 + (y-b).^2));
end

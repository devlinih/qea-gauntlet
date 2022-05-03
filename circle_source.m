function res = circle_source(x, y, hkr, u)
    h = hkr(1);
    k = hkr(2);
    r = hkr(3);
    theta = u * 2 * pi;
    a = h + r * cos(theta);
    b = k + r * sin(theta);
    res = log(sqrt((x-a).^2 + (y-b).^2));
end
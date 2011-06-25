function rsq = rsqComputing(vec, degree)
x = vec(:, 2);  y = vec(:, 1);
p = polyfit(x, y, degree);
yfit = polyval(p, x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
function [dir xi yi]=turnPridict(fit1,fit2)

xi=fzero(@(x) polyval(fit1-fit2,x),3);
yi = polyval(fit1,xi);

diff = xi-640;

if diff <= -15
    dir='left';
elseif diff > -15 && diff<15
    dir='straight';
else
    dir='right';
end

end
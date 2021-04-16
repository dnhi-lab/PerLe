function progBar(itt, total, init)
%progBar    Simple progression bar
%   progBar(~,~,1) initialized the progress bar
%   progBar(currentItt, totalItt,~) prints the updated progress bar 
%   25 steps (4% accuracy)

if itt > total; return; end

bars = 25;
step = 100/bars;

if init
    fprintf(['[' repmat('-', 1, bars) ']']);
else
    numBar = floor(((itt/total)*100)/step);
    fprintf([repmat('\b',1,bars+2) '[' repmat('#',1,numBar) repmat('-',1,bars-numBar) ']']);
end
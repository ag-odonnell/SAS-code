
data test;
    var_01='a2024';
    var_01=strip(cat(substr(var_01, 1, length(var_01)-1),'5'));
run;

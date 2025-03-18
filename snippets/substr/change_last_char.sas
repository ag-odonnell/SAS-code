
data test;
    var_01='a2024';
    var_01=strip(cat(substr(var_01, 1, length(var_01)-1),'5'));
run;

data test_01;
    file_name='var_name_2023';
    do i=1 to 3;
         /*prendre le nom de la variable jusqu'au dernier caractère du nom et ajouter 4 ou 5*/
        if i=1 then file_name=strip(cat(substr(file_name, 1, length(file_name)-1),'4'));
        else if i=2 then file_name=strip(cat(substr(file_name, 1, length(file_name)-1),'5'));
        else file_name='SOME_VAR_NAME';
        length_file_name=length(file_name);
        position_file_name=substr(file_name, length(file_name), 1);
        /*si le dernier caractère est 4 alors faites*/
        if substr(file_name, length(file_name), 1)='4' then flag=1;
        else if substr(file_name, length(file_name), 1)='5' then flag=0;
        if substr(upcase(strip(file_name)),1,4)='SOME' then flag_some=1;
        else flag_some=0;
        output;
    end;
run;

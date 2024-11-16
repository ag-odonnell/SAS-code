/**Example in gvdb_validation_2023_18mo_20240802.egp line 340 of the beneficiary program node */
ods listing close;
    ods output OneWayFreqs=aalib02.bene_t02_&yyyy.;
        proc freq data=aalib02.bene_t01_&yyyy.;
            tables
                &mvar_list_of_variables
                &mvar_another_list
                / missing;
        run;
    ods output close;
ods listing;

data aalib02.bene_t02_&yyyy. (
        keep = _name_ _label_ col1
        rename=(
            _name_=var_name
            _label_=eval_value
            col1=y&yyyy.
        ));
    array a(*) _character;
    length _table _name_ _label_ $70.;
    _table=substr(table,7);
    do i=1 to dim(a);
        if vname(a(i))=cats("F_",_table) then do;
            col1=frequency;
            _label_=trim(left(a(i)));
            _name_=_table;
        end;
    end;
    format col1 comma15.;
    output;
run;

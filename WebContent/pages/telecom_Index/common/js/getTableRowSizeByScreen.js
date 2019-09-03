function getTableRows(){
    var table_rows_array_small_screen = [15,25,35];
    var table_rows_array_big_screen = [25,35,45];

    if(window.screen.height<=768){
        return table_rows_array_small_screen;
    }else{
        return table_rows_array_big_screen;
    }
}
function getTableRows1(){
    var table_rows_array_small_screen = [15,25,35];
    var table_rows_array_big_screen = [25,35,45];

    if(window.screen.height<=768){
        return table_rows_array_small_screen;
    }else{
        return table_rows_array_big_screen;
    }
}
function getTableRows2(){
    var table_rows_array_small_screen = [20,30,40];
    var table_rows_array_big_screen = [20,30,40];

    if(window.screen.height<=768){
        return table_rows_array_small_screen;
    }else{
        return table_rows_array_big_screen;
    }
}

//竞争沙盘省级表格行数
function getTableRows3(){
    var table_rows_array_small_screen = [10,20,30];
    var table_rows_array_big_screen = [20,30,40];

    if(window.screen.height<=768){
        return table_rows_array_small_screen;
    }else{
        return table_rows_array_big_screen;
    }
}
var table_rows_array = "";
var table_rows_array_small_screen = [20,25,35];
var table_rows_array_big_screen = [30,40,50];

if(window.screen.height<=768){
    table_rows_array = table_rows_array_small_screen;
}else{
    table_rows_array = table_rows_array_big_screen;
}
var tuomin_addr = true;//地址是否脱敏，若个别页面不需要脱敏，则在具体页面中申明此变量为false即可
function addr(val){
    if(tuomin_addr)
        return val.replace(/[0-9]/ig,'*');
    return val;
}
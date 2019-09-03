/**
 * Created by admin on 2019/3/27.
 */
function nullToEmpty(val){
    return val==null?'--':val.toFixed(2);
}

//null»ò¿ÕÖµ×ª»»
function filterNull(el){
    var result = el;
    if(el==null || el=='null'|| el==undefined || el==''){
        result = 0.00;
    }
    return result;
}

function toDecimal(x){
    var num = Number(x);
    num = num.toFixed(2);
    return num;
}
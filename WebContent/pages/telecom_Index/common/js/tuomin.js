var tuomin_addr = true;//��ַ�Ƿ�������������ҳ�治��Ҫ���������ھ���ҳ���������˱���Ϊfalse����
var tuomin_phone = true;
function addr(val){
    if(val==null || val==undefined)
        return "";
    if(tuomin_addr)
        return val.replace(/[0-9]/ig,'*').replace(/[\uFF10-\uFF19]/ig,'*');
    return val;
}
function phoneHide(phone){
    if(phone==null || phone==undefined)
        return "";
    if(tuomin_phone){
        var d = phone.substr(0,3);
        for(var i = 0,l = phone.length-5;i<l;i++){
            d += "*";
        }
        return d+phone.substr(-2);
    }else{
        return phone;
    }
}
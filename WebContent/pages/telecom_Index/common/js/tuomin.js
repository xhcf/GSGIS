var tuomin_addr = true;//��ַ�Ƿ�������������ҳ�治��Ҫ���������ھ���ҳ���������˱���Ϊfalse����
function addr(val){
    if(tuomin_addr)
        return val.replace(/[0-9]/ig,'*');
    return val;
}
function isIE(){
    var userAgent = navigator.userAgent;
    var isOpera = userAgent.indexOf("Opera") > -1; //�ж��Ƿ�Opera�����
    return userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera;
}
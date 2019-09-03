package cn.com.gis.utils;

/***
 *  简单字符串处理工具
 *
 */
public class StringUtil {

    public static boolean isEmpty(String str){
        if("".equals(str)||str==null){
            return true;
        }else{
            return false;
        }
    }

    public static boolean isNotEmpty(String str){
        if(!"".equals(str)&&str!=null){
            return true;
        }else{
            return false;
        }
    }
}
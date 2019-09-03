package cn.com.gis.utils;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 简单日期处理工具
 *
 */
public class DateUtil {

    public static String formatDate(Date date,String format){
        String result="";
        SimpleDateFormat sdf=new SimpleDateFormat(format);
        if(date!=null){
            result=sdf.format(date);
        }
        return result;
    }


    public static Date formatString(String str,String format) throws Exception{
        SimpleDateFormat sdf=new SimpleDateFormat(format);
        return sdf.parse(str);
    }

    public static long getTimestamp(){
        return new Date().getTime();
    }

    public static void main(String[] args) throws Exception{
        Date date=formatString("1993/10/12", "yyyy/MM/dd");
        String str=formatDate(date, "yyyy-MM-dd");
        System.out.println(str);
    }
}

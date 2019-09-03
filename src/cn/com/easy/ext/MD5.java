package cn.com.easy.ext;

import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * <p>Description: 加密为hex或MD5</p>
 * @author chenfuquan
 */

public class MD5 {
  public MD5() {}

  public static String byte2hex(byte[] b) {
    String hs = "";
    String stmp = "";
    for (int n = 0; n < b.length; n++) {
      stmp = (java.lang.Integer.toHexString(b[n] & 0XFF));
      if (stmp.length() == 1)
        hs = hs + "0" + stmp;
      else
        hs = hs + stmp;
    }
   // System.out.println("--------" + hs.toUpperCase());
    return hs.toUpperCase();
  }

  public static String MD5Crypt(String s) {
    try {
      byte[] strTemp = s.getBytes();
     // System.out.println("--------" + s);
      MessageDigest mdTemp = MessageDigest.getInstance("MD5");
      mdTemp.update(strTemp);
      byte[] md = mdTemp.digest();
      return byte2hex(md);
    }
    catch (Exception e) {
      return null;
    }
  }

  public static void main(String[] args) {
    MD5 test = new MD5();
    long reqTime = new Date().getTime();
    String reqPath = "/dsp/broadband!statistics.action";
    String myAppKey = MD5Tools.getMD5Code("J4HF6S43KBMZHF5341FDJ68FH466V0VJ" + reqPath + reqTime);
    //System.out.print(test.MD5Crypt("konghy_bygsods"));
    /*System.out.println(myAppKey);
    System.out.println(reqTime);
    System.out.println(reqPath);*/

    String menuCode = "Mxqt2018002";
    String userCode = "316666";
    String lanId = "938";
    String externSystemCode = "10000";
    String signTimestamp = "20190626173541";//new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    String externSignKey = "xqt20181207";
    String model = "";
    String subMenuCode = "additionalCard";//PreAccept sales
    System.out.println(menuCode+userCode +lanId+externSystemCode+signTimestamp+externSignKey);
    String signString = MD5.MD5Crypt(menuCode+userCode +lanId+externSystemCode+signTimestamp+externSignKey);//md5Hex(menuCode+userCode +lanId+externSystemCode+signTimestamp+externSignKey);//MD5Tools.getMD5Code(menuCode+userCode +lanId+externSystemCode+signTimestamp+externSignKey);//md5Hex(menuCode+userCode +lanId+externSystemCode+signTimestamp+externSignKey)

    //http://ip:port/MmtWeb/ssoLogin?menuCode=Mxqt2018002&userCode=316666&lanId=938&externSystemCode=10000&signTimestamp=20190626173541&externSignKey=xqt20181207&model=””&subMenuCode= additionalCard &signString=d6730fdb7a6919a3ebd852a316254243
    //System.out.print(signTimestamp);
    System.out.println("MD5.MD5Crypt:"+signString);
    signString = MD5Tools.getMD5Code(menuCode+userCode +lanId+externSystemCode+signTimestamp+externSignKey);
    System.out.println("MD5Tools.getMD5Code:"+signString);
    System.out.println("menuCode=" + menuCode + "&userCode=" + userCode + "&lanId=" + lanId + "&externSystemCode=" + externSystemCode + "&signTimestamp=" + signTimestamp + "&externSignKey=" + externSignKey + "&model=" + model + "&subMenuCode=" + subMenuCode + "&signString=" + signString);
    //System.out.println(MD5Tools.getMD5Code("a"));
    //System.out.println(MD5Tools.getMD5Code("a"+""));

    long now = new Date().getTime();
    System.out.println("now:"+now);//1563961957954
    System.out.println("val:"+(now-1563950985748L));
  }
}
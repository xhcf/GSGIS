package cn.com.easy.ext;
import org.apache.commons.codec.digest.DigestUtils;

import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * CryptTool 封装了一些加密工具方法, 包括 3DES, MD5 等.
 *
 * @author hxq
 * @version 1.0 2006-01-10
 */
public class CryptTool {

    private static final String  SKEY    = "sdafer234rbgf456yhghh65";
    private static final Charset CHARSET = Charset.forName("utf8");

    public CryptTool() {
    }

    private final static String[] hexDigits = { "0", "1", "2", "3", "4", "5",
            "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" };
    private final static String[] hexDigits1 = { "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "A", "X", "C", "S", "U", "F" ,"M"};

    /**
     * 转换字节数组为16进制字串
     * @param b 字节数组
     * @return 16进制字串
     */
    public static String byteArrayToHexString1(byte[] b) {
        StringBuilder resultSb = new StringBuilder();
        for (byte aB : b) {
            resultSb.append(byteToHexString1(aB));
        }
        return resultSb.toString();
    }

    /**
     * 转换byte到16进制
     * @param b 要转换的byte
     * @return 16进制格式
     */
    private static String byteToHexString1(byte b) {
        int n = b;
        if (n < 0) {
            n = 256 + n;
        }
        int d1 = n / 16;
        int d2 = n % 16;
        return hexDigits1[d1] + hexDigits1[d2];
    }
    /**
     * MD5编码 本项目生成特殊版
     * @param origin 原始字符串
     * @return 经过MD5加密之后的结果
     */
    public static String MD5Encode(String origin) {
        String resultString = null;
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            resultString = byteArrayToHexString1(md.digest(origin.getBytes()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultString;
    }

    /**
     * 转换字节数组为16进制字串
     *
     * @param b
     *            字节数组
     * @return 16进制字串
     */

    public static String byteArrayToHexString(byte[] b) {
        StringBuffer resultSb = new StringBuffer();
        for (int i = 0; i < b.length; i++) {
            resultSb.append(byteToHexString(b[i]));
        }
        return resultSb.toString().toUpperCase();
    }

    private static String byteToHexString(byte b) {
        int n = b;
        if (n < 0)
            n = 256 + n;
        int d1 = n / 16;
        int d2 = n % 16;
        return hexDigits[d1] + hexDigits[d2];
    }

    /**
     * 生成3DES密钥.
     *
     * @param key_byte
     *            seed key
     * @throws Exception
     * @return javax.crypto.SecretKey Generated DES key
     */
    public static javax.crypto.SecretKey genDESKey(byte[] key_byte)
            throws Exception {

        SecretKey k = null;
        k = new SecretKeySpec(key_byte, "DESede");
        return k;
    }

    public static javax.crypto.SecretKey genDESKey() throws Exception {
        String keyStr = "$1#2@f3&4~6%7!a+*cd(e-h)";// 使用固定key
        // System.out.println("DES 加密使用的固定key，keyStr ＝＝ " + keyStr);
        byte key_byte[] = keyStr.getBytes();// 3DES 24 bytes key
        SecretKey k = null;
        k = new SecretKeySpec(key_byte, "DESede");
        return k;
    }

    public static javax.crypto.SecretKey genDESKey(String key) throws Exception {
        String keyStr = key;// 使用固定key
        // System.out.println("DES 加密使用的固定key，keyStr ＝＝ " + keyStr);
        byte key_byte[] = keyStr.getBytes();// 3DES 24 bytes key
        SecretKey k = null;
        k = new SecretKeySpec(key_byte, "DESede");
        return k;
    }

    /**
     * 3DES 解密(byte[]).
     *
     * @param key
     *            SecretKey
     * @param crypt
     *            byte[]
     * @throws Exception
     * @return byte[]
     */
    public static byte[] desDecrypt(javax.crypto.SecretKey key, byte[] crypt)
            throws Exception {
        javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("DESede");
        cipher.init(javax.crypto.Cipher.DECRYPT_MODE, key);
        return cipher.doFinal(crypt);
    }

    /**
     * 3DES 解密(String).
     *
     * @param key
     *            SecretKey
     * @param crypt
     *            byte[]
     * @throws Exception
     * @return byte[]
     */
    public static String desDecrypt(javax.crypto.SecretKey key, String crypt)
            throws Exception {
        return byteArrayToHexString(desDecrypt(key, crypt.getBytes()));
    }

    /**
     * 3DES加密(byte[]).
     *
     * @param key
     *            SecretKey
     * @param src
     *            byte[]
     * @throws Exception
     * @return byte[]
     */
    public static byte[] desEncrypt(javax.crypto.SecretKey key, byte[] src)
            throws Exception {
        javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("DESede");
        cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, key);
        return cipher.doFinal(src);
    }

    /**
     * 3DES加密(String).
     *
     * @param key
     *            SecretKey
     * @param src
     *            byte[]
     * @throws Exception
     * @return byte[]
     */
    public static String desEncrypt(javax.crypto.SecretKey key, String src)
            throws Exception {
        return byteArrayToHexString(desEncrypt(key, src.getBytes()));
    }

    /**
     * MD5 摘要计算(byte[]).
     *
     * @param src
     *            byte[]
     * @throws Exception
     * @return byte[] 16 bit digest
     */
    public static byte[] md5Digest(byte[] src) throws Exception {
        java.security.MessageDigest alg = java.security.MessageDigest
                .getInstance("MD5"); // MD5 is 16 bit message digest

        return alg.digest(src);
    }

    /**
     * MD5 摘要计算(String).
     *
     * @param src
     *            String
     * @throws Exception
     * @return String
     */
    public static String md5Digest(String src) throws Exception {
        return byteArrayToHexString(md5Digest(src.getBytes("UTF-8")));
    }

    /**
     * BASE64 编码.
     *
     * @param src
     *            String inputed string
     * @return String returned string
     */
    public static String base64Encode(String src) {
        sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();

        return encoder.encode(src.getBytes());
    }

    /**
     * BASE64 编码(byte[]).
     *
     * @param src
     *            byte[] inputed string
     * @return String returned string
     */
    public static String base64Encode(byte[] src) {
        sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();

        return encoder.encode(src);
    }

    /**
     * BASE64 解码.
     *
     * @param src
     *            String inputed string
     * @return String returned string
     */
    public static String base64Decode(String src) {
        sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();

        try {
            return byteArrayToHexString(decoder.decodeBuffer(src));
        } catch (Exception ex) {
            return null;
        }

    }

    /**
     * BASE64 解码(to byte[]).
     *
     * @param src
     *            String inputed string
     * @return String returned string
     */
    public static byte[] base64DecodeToBytes(String src) {
        sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();

        try {
            return decoder.decodeBuffer(src);
        } catch (Exception ex) {
            return null;
        }

    }

    /**
     * 对给定字符进行 URL 编码.
     *
     * @param src
     *            String
     * @return String
     */
    public static String urlEncode(String src) {
        try {
            src = java.net.URLEncoder.encode(src, "UTF-8");

            return src;
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return src;
    }

    /**
     * 对给定字符进行 URL 解码
     *
     * @param value
     *            解码前的字符串
     * @return 解码后的字符串
     */
    public String urlDecode(String value) {
        try {
            return java.net.URLDecoder.decode(value, "UTF-8");
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return value;
    }

    /** AddrRepairSendOrder crypt */
    public static void main(String[] args) {
        try {
            /**

             // 获得的明文数据
             String desStr = "MERCHANTID=0219999999&ORDERSEQ=20080225150029000001&ORDERDATE=20080225&ORDERAMOUNT=200";

             // 使用固定key值
             String keyStr = "123456";// 使用固定key
             desStr = desStr + "&KEY=" + keyStr;// 将key值和明文数据组织成一个待加密的串
             System.out.println("待加密的字符串 desStr ＝＝ " + desStr);
             // 转成字节数组
             byte src_byte[] = desStr.getBytes();

             // MD5摘要
             byte[] md5Str = md5Digest(src_byte);
             // 生成最后的SIGN
             String SING = byteArrayToHexString(md5Str);
             System.out.println("SING == " + SING);

             **/

            /*String paramStr = "MERCHANTID=10001&ORDERSEQ=1006&ORDERREQTRANSEQ=100600&ENCODETYPE=1&KEY=123456";
            String newMac = CryptTool.md5Digest(paramStr);
            System.out.println("newMac == " + newMac);*/
            //System.out.println(MD5Encode("Mxqt20180023166669381000020190626173541xqt20181207"));
            System.out.println(DigestUtils.md5Hex("Mxqt2018002316666938100009381000020190704105649xqt20181207"));
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static String md5Parse(String user_id){
        String newMac = "";
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        try{

            String paramStr = user_id+sdf.format(d)+SKEY;
            newMac = CryptTool.md5Digest(paramStr);
            System.out.println("newMac == " + newMac);
        }catch (Exception ex) {
            ex.printStackTrace();
        }

        return newMac;
    }
    public static String md5Parse(String user_id,String time_str){
        String newMac = "";
        try{
            String paramStr = user_id+time_str+SKEY;
            newMac = CryptTool.md5Digest(paramStr);
            System.out.println("newMac == " + newMac);
        }catch (Exception ex) {
            ex.printStackTrace();
        }

        return newMac;
    }
    /**
     * 采用DES算法加密
     * @param str
     * @return String
     */
    public static String DESEncrypt(String str) {
//    	Assert.hasLength(str, "要加密的字符串不能为空");
        try {
            SecureRandom random = new SecureRandom();
            SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHH");
            DESKeySpec desKey = new DESKeySpec(sf.format(new Date()).getBytes());
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            SecretKey securekey = keyFactory.generateSecret(desKey);
            Cipher cipher = Cipher.getInstance("DES");
            cipher.init(Cipher.ENCRYPT_MODE, securekey, random);
            byte[] temp = cipher.doFinal(str.getBytes());
            return byte2HexStr(temp);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }
    public static String DESEncrypt(String str,String time_str) {
//    	Assert.hasLength(str, "要加密的字符串不能为空");
        try {
            SecureRandom random = new SecureRandom();
            DESKeySpec desKey = new DESKeySpec(time_str.getBytes());
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            SecretKey securekey = keyFactory.generateSecret(desKey);
            Cipher cipher = Cipher.getInstance("DES");
            cipher.init(Cipher.ENCRYPT_MODE, securekey, random);
            byte[] temp = cipher.doFinal(str.getBytes());
            return byte2HexStr(temp);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }

    //获得跳转到crm时的url的一个加密后的请求参数
    public static String getReqParam(Map map){
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
        String time_str = sf.format(new Date());
        System.out.println("time:"+time_str);
        String md5_str = md5Parse(String.valueOf(map.get("user_id")),time_str);
        System.out.println("md5:"+md5_str);
        String des_str = null;
        try{
            String cust_name = urlEncode(String.valueOf(map.get("cust_name")));
            String address = urlEncode(String.valueOf(map.get("address")));
            String accnbr = urlEncode(String.valueOf(map.get("accnbr")));
            String broadband = urlEncode(String.valueOf(map.get("broadband")));
/*            String cust_name = new String(String.valueOf(map.get("cust_name")).getBytes("UTF-8"));
            String address = new String(String.valueOf(map.get("address")).getBytes("UTF-8"));
            String accnbr = new String(String.valueOf(map.get("accnbr")).getBytes("UTF-8"));
            String broadband = new String(String.valueOf(map.get("broadband")).getBytes("UTF-8"));*/
            System.out.println(cust_name);
            System.out.println(address);
            System.out.println(accnbr);
            System.out.println(broadband);
            String source_str = "agentcode="+String.valueOf(map.get("user_id"))+"&reqtime="+time_str+"&mac="+md5_str+
                    "&cust_name="+cust_name+"&address="+address+
                    "&accnbr="+accnbr+"&broadband="+broadband+
                    "&bus_type="+String.valueOf(map.get("bus_type"));
            System.out.println("source_str:"+source_str);
            des_str = DESEncrypt(source_str,time_str);
        }catch(Exception e){
            e.printStackTrace();
        }
        return des_str;
    }

    //2019新版crm甩单使用的加密参数的方法
    public static String getReqParam2019(Map map){
        String des_str = null;
        try{
            String menuCode = urlEncode(String.valueOf(map.get("menuCode")));
            String userCode = urlEncode(String.valueOf(map.get("userCode")));
            String lanId = urlEncode(String.valueOf(map.get("lanId")));
            String externSystemCode = urlEncode(String.valueOf(map.get("externSystemCode")));
            String signTimestamp = urlEncode(String.valueOf(map.get("signTimestamp")));
            String externSignKey = urlEncode(String.valueOf(map.get("externSignKey")));

            System.out.println(menuCode);
            System.out.println(userCode);
            System.out.println(lanId);
            System.out.println(externSystemCode);
            System.out.println(signTimestamp);
            System.out.println(externSignKey);

            String source_str = menuCode+userCode+lanId+externSystemCode+signTimestamp+externSignKey;
            System.out.println("source_str:"+source_str);
            //des_str = DESEncrypt(source_str,time_str);
            //des_str = MD5Tools.getMD5Code(source_str);
            des_str = DigestUtils.md5Hex(source_str);
        }catch(Exception e){
            e.printStackTrace();
        }
        return des_str;
    }

    /**
     * 将一个字节数组转换成十六进制的字符串形式返回
     * @param b
     * @return String
     */
    public static String byte2HexStr(byte[] b) {
        StringBuffer sb = new StringBuffer(b.length * 2);
        for(int i = 0; i < b.length; i++) {
            sb.append(Character.forDigit((b[i] & 0xf0) >> 4, 16));
            sb.append(Character.forDigit(b[i] & 0x0f, 16));
        }
        return sb.toString();
    }

    /**
     * 用MD5方式加密字符串
     * @param str 要加密的字符串
     * @return 加密后的字符串
     */
    /*public static String MD5(String str) {
        try {
            if(!StringUtil.isEmpty(str)) {
                MessageDigest md = MessageDigest.getInstance("MD5");
                md.update(str.getBytes());
                byte[] temp = md.digest();
                return TypeConvert.byte2HexStr(temp);
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return str;
    }*/
}

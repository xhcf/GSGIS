package cn.com.easy.util;

import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;

public class DesEncryptUtil
{

    private static final String DES_ALGORITHM = "DES";
    private static final String SECRETKEY = "6QJoJOPWCdyzOH2eJxUdJQ";
    public static void main(String[] args) throws Exception
    {
        //** 生成KEY *//
        Key key = SecretKey();

        //** 加密 *//
        //byte[] result = doEncrypt(key, "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = 135.149.64.139)(PORT = 1685))(LOAD_BALANCE = yes)(CONNECT_DATA =    (SERVER = DEDICATED)(SERVICE_NAME = SJDB)))");
        //byte[] result0 = doEncrypt(key, "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = 135.149.64.139)(PORT = 1685))(LOAD_BALANCE = yes)(CONNECT_DATA =  (SERVER = DEDICATED)(SERVICE_NAME = SJDB)))");
        //System.out.println("jdbc.url="+Base64Utils.encode(result));
        //System.out.println("jdbc.url="+Base64Utils.encode(result0));

        //byte[] result1 = doEncrypt(key, "EASY_DATA");
        //System.out.println("jdbc.username="+Base64Utils.encode(result1));

        //byte[] result2 = doEncrypt(key, "59Xc8isA*P");
        //System.out.println("jdbc.password="+Base64Utils.encode(result2));

        //** 解密 *//
        //System.out.println(doDecrypt(key, Base64Utils.encode(result)));
		//System.out.println(DesEncryptUtil.doDecrypt(key,"WQ9wdknj4mv4FuKxHlWz/A=="));
		byte[] result = doEncrypt(key,"7Nm2hAs+M-");
		String str = Base64Utils.encode(result);
		System.out.println(str);
		System.out.println(DesEncryptUtil.doDecrypt(key,str));
    }


    /**
     * linux 环境下生成key文件
     * @throws Exception
     */
    @SuppressWarnings("resource")
    public static Key SecretKey() throws NoSuchAlgorithmException
    {
    	SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG");
		secureRandom.setSeed(SECRETKEY.getBytes());

		KeyGenerator kg = null;
		try {
			kg = KeyGenerator.getInstance(DES_ALGORITHM);
		} catch (NoSuchAlgorithmException e) {
		}
		kg.init(secureRandom);

		Key key = kg.generateKey();
		return key;
    }

    //加密
    public static byte[] doEncrypt(Key key, String str)
    {
        try
        {
            Cipher cipher = Cipher.getInstance(DES_ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] raw = cipher.doFinal(str.getBytes());
            return raw;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    //解密
    public static String doDecrypt(Key key, String buf)
    {
        try
        {
            Cipher cipher = Cipher.getInstance(DES_ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, key);
            byte[] raw = cipher.doFinal(Base64Utils.decode(buf.toCharArray()));
            return new String(raw);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }


    static class Base64Utils {

		static private char[] alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".toCharArray();
		static private byte[] codes = new byte[256];
		static {
			for (int i = 0; i < 256; i++)
				codes[i] = -1;
			for (int i = 'A'; i <= 'Z'; i++)
				codes[i] = (byte) (i - 'A');
			for (int i = 'a'; i <= 'z'; i++)
				codes[i] = (byte) (26 + i - 'a');
			for (int i = '0'; i <= '9'; i++)
				codes[i] = (byte) (52 + i - '0');
			codes['+'] = 62;
			codes['/'] = 63;
		}

		/**
		 * 将原始数据编码为base64编码
		 */
		static public String encode(byte[] data) {
			char[] out = new char[((data.length + 2) / 3) * 4];
			for (int i = 0, index = 0; i < data.length; i += 3, index += 4) {
				boolean quad = false;
				boolean trip = false;
				int val = (0xFF & (int) data[i]);
				val <<= 8;
				if ((i + 1) < data.length) {
					val |= (0xFF & (int) data[i + 1]);
					trip = true;
				}
				val <<= 8;
				if ((i + 2) < data.length) {
					val |= (0xFF & (int) data[i + 2]);
					quad = true;
				}
				out[index + 3] = alphabet[(quad ? (val & 0x3F) : 64)];
				val >>= 6;
				out[index + 2] = alphabet[(trip ? (val & 0x3F) : 64)];
				val >>= 6;
				out[index + 1] = alphabet[val & 0x3F];
				val >>= 6;
				out[index + 0] = alphabet[val & 0x3F];
			}

			return new String(out);
		}

		/**
		 * 将base64编码的数据解码成原始数据
		 */
		static public byte[] decode(char[] data) {
			int len = ((data.length + 3) / 4) * 3;
			if (data.length > 0 && data[data.length - 1] == '=')
				--len;
			if (data.length > 1 && data[data.length - 2] == '=')
				--len;
			byte[] out = new byte[len];
			int shift = 0;
			int accum = 0;
			int index = 0;
			for (int ix = 0; ix < data.length; ix++) {
				int value = codes[data[ix] & 0xFF];
				if (value >= 0) {
					accum <<= 6;
					shift += 6;
					accum |= value;
					if (shift >= 8) {
						shift -= 8;
						out[index++] = (byte) ((accum >> shift) & 0xff);
					}
				}
			}
			if (index != out.length)
				throw new Error("miscalculated data length!");
			return out;
		}
    }
}
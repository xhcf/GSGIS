package cn.com.easy.util;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import com.ss.security.bssp.VideoSysCAUtility;
import com.ss.security.bssp.bean.ResultVO;
import net.sf.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by admin on 2018/11/5.
 */

@Controller
public class VideoDecode {

    @Action("videoDecode")
    public void decode(String enData,HttpServletRequest request,HttpServletResponse response){
        PrintWriter out = null;
        String msg = "";
        String token = "";
        String code = "";
        try {
            response.setHeader("Charset", "UTF-8");
            response.setContentType("text/html;charset=UTF-8");
            out = response.getWriter();
            // 基础数据校验
            if (StringUtils.isEmpty( enData )) {
                out.print("{\"code\" : \"-1\", \"msg\" : \"缺少字段\"}");
                out.flush();
                out.close();
            }
            // 分配给业务系统的私钥信息，一定要保管好。
            String privateKey = "MIICXAIBAAKBgQDHFKjjVSnawuDQ6TdjNgg3k87YpvaE2P/ngu6qz3JjBrzabx1uR/tcb5F7+A+q/D61yCDlMAeytQY7FRol0vL4gzPHngHciSogCxJCmXSRCscFV4dUj2mW+bKYI5wh76NO8vRW2ZghFGj2lSvtRyEO69SqkTP4BsT1ekFL8qedyQIDAQABAoGBALU0NNVXOxWHtCHzZRrEn44W13uT3WbmLWeIYbzPvYotI9CeuucaVcy5MG7qRziXCG1lj6uMoDUlWFqGxpoO/F9jw1y21VU5hRzo5Qc4MOmhWWCSOFasL7RZvKITXSataWgzlvkLGYlk1GH3NZ2u73aQ2x5SdtAXD/kO8SCAE69BAkEA6MQBs6AJkdulJMsPTl5FzGFF3NTevI47ee98uPJ9bYA1q01TKdSLComBYVU7veFkYlVIjFYJmVeat7EB6kTF9QJBANrz4eMYSKDY7rYivSIGX3181AvRB4uohqGyD9RXX47Jywgs21ZIVJc6qswWdlPSjRh8LSPmCj7w1IZVygB4wAUCQGh1Rho5cPH/M06evkC6N/KvmK2w7kCKSBDBtCQ/1qAkkHFO40p7cuaIrQJkQMpG80jZ4xPvrKEfWnSjQCvFL10CQEXvYjZMOl6OC+lHPUwR5wxJA93mXVehc6dQHbhAVDhigiRRV5m+rq5DQezAO/lYJlMszqpJvvoNqIRkAIqYBxUCQBwPMgEIp/JiKgivbrHiKT2CCj19qkcSJHEbMMkvkM4y+FlNkItiA9q+cNwISt7TnL+nEAxYK7iUXDzLQBK8ae4=";
            // 进行解密操作，把密文参数解密成明文参数进行访问。
            ResultVO result = VideoSysCAUtility.getInstance().decodeData(enData, privateKey);
            if (result.getRetCode() != 0) {
                out.print("{\"code\" : \"-1\", \"msg\" : \"解密失败\"}");
                out.flush();
                out.close();
            }
            // 把密文解密之后组成新的url进行加载到ifram中
            msg = result.getOutData();//json元素
            String ranStr = new Date().getTime()+"";
            ResultVO signResult = VideoSysCAUtility.getInstance().signData(ranStr, privateKey);
            if (signResult.getRetCode() == 0) {
                String signData = signResult.getOutData();
                //调接口获取令牌
                Map params = new HashMap(16);
                params.put("account", "Eda_System");//test12 Bss_System
                params.put("randStr", ranStr);
                params.put("sign", signData);
                //String doPost = HttpClientUtils.doPost("http://219.148.31.135:8183/videoMiddleware/videoServJson/makeToken.action", params, "utf-8");
                String doPost;//测试环境
                //doPost = HttpClientUtil.doPost("http://135.149.96.135:9201/videoMiddleware/videoServJson/makeToken.action", params, "utf-8");
                doPost = HttpClientUtil.doPost("http://135.149.81.9:9010/videoMiddleware/videoServJson/makeToken.action", params, "utf-8");
                JSONObject jsonObject = JSONObject.fromObject(doPost);
                String resCode = jsonObject.get("code")==null ? "":jsonObject.get("code").toString();
                if ("1".equals(resCode)) {
                    out.print("{\"code\" : \"1\", \"token\" : \"" + jsonObject.get("msg") + "\", \"msg\" : \"" + msg + "\"}");
                    out.flush();
                    out.close();
                }else {
                    out.print("{\"code\" : \""+resCode+"\", \"msg\" : \""+ msg +"\"}");
                    out.flush();
                    out.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\" : \"-1\",\"msg\" : \"后台异常\"}");
            out.flush();
            out.close();
        } finally {
            if(out!=null)
                out.close();
        }
    }
}

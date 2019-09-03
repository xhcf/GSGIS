package cn.com.easy.util;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import cn.com.easy.ext.CryptTool;

/**
 * Created by admin on 2018/10/9.
 */
@Controller
public class CrossDomainTools {

    @Action("accessUrl")
    public void accessUrl(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        String url = request.getParameter("url");
        String flag = request.getParameter("flag");
        // 存储相关的header值
        //Map<String,String> header = new HashMap<String, String>();
        //username:password--->访问的用户名，密码,并使用base64进行加密，将加密的字节信息转化为string类型，encoding--->token
        //String encoding = DatatypeConverter.printBase64Binary("kermit:kermit".getBytes("UTF-8"));
        //header.put("Authorization", "Basic " + encoding);
        //String response_str = HttpClientUtil.sendHttp(HttpRequestMethedEnum.HttpGet,url, null,null);
        HttpClient httpClient = new HttpClient();
        httpClient.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET,"UTF-8");
        GetMethod httpGet = new GetMethod(url);
        PrintWriter pw = null;
        try{
            int code = httpClient.executeMethod(httpGet);
            response.setCharacterEncoding("utf-8");
            pw = response.getWriter();
            if(code==200){
                String response_str = httpGet.getResponseBodyAsString();
                pw.write(response_str);
            }else{
                pw.write("访问错误");
            }
            pw.flush();
            pw.close();
        }catch (Exception e) {
            if(pw!=null)
                pw.close();
        }
    }
}

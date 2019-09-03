package cn.com.gis.webservice;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.namespace.QName;
import javax.xml.rpc.ParameterMode;
import javax.xml.rpc.ServiceException;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import org.apache.axis.encoding.XMLType;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

@Controller
public class AddrRepairSendOrder {

    @Action("ws_addrRepairSendOrder")
    public void addrRepairSendOrder(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        request.setCharacterEncoding("UTF8");

        String order_id = String.valueOf(request.getParameter("order_id"));
        String latn_id = String.valueOf(request.getParameter("latn_id"));
        String bureau_id = String.valueOf(request.getParameter("bureau_id"));
        String sender = String.valueOf(request.getParameter("sender"));
        String sender_tel = String.valueOf(request.getParameter("sender_tel"));
        String title = String.valueOf(request.getParameter("title"));
        String content = String.valueOf(request.getParameter("content"));

        String res_json = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";

        //获取WEBSERVICE接口地址
        //String nameSpace = "http://135.149.96.42:7020/axis/services/SendList";
        String nameSpace = "http://135.149.48.140:7010/axis/services/SendList";
        String endPoint = nameSpace + "?wsdl";
        //获取相应的WEBSERVICE接口方法
        String methodName = "AppSendList";
        try {
            Service service = new Service();
            Call call = (Call) service.createCall();
            call.setTargetEndpointAddress(new URL(endPoint));
            String xml = "<?xml version=\"1.0\" encoding=\"gb2312\"?>"+//utf-8
                    "<REGU_SHEET_TD>"+
                    "   <SOURCE_SYS>gis</SOURCE_SYS>"+//固定写"gis"
                    "   <WO_ID>"+order_id+"</WO_ID>"+//已有的单子编号
                    "   <AREA_CODE>"+latn_id+"</AREA_CODE>"+//地市编码
                    "   <COUNTY_TOWN>"+bureau_id+"</COUNTY_TOWN>"+//区县、分局编码
                    "   <USER_ID>"+sender+"</USER_ID>"+//工单发起人姓名
                    "   <PROJECT_TYPE>"+sender_tel+"</PROJECT_TYPE>"+//工单发起人联系方式
                    "   <ZONE_ADR>"+title+"</ZONE_ADR>"+//工单标题
                    "   <EXTEND2>"+content+"</EXTEND2>"+//工单内容
                    "</REGU_SHEET_TD>";
            call.addParameter("inBody", XMLType.XSD_STRING, ParameterMode.IN);
            call.setReturnType(XMLType.XSD_STRING);
            call.setOperationName(new QName(nameSpace, methodName));
            call.setUseSOAPAction(true);
            String resultstr = (String) call.invoke(new Object[] { xml });

            //resultstr示例
            /*<?xml version="1.0" encoding="UTF-8"?>
            <IfInfo>
                <IfResult>派单成功!</IfResult>
                <sheetNo>ZH9311903130001231699</sheetNo>
                <code>0</code>
            </IfInfo>*/

            Document doc = DocumentHelper.parseText(resultstr);
            Element root = doc.getRootElement();
            Element code = root.element("code");
            String code_num = code.getTextTrim();
            Element result = root.element("IfResult");
            String result_str = result.getTextTrim();

            res_json = res_json.replace("#code#",code_num).replace("#msg#", result_str);
        } catch (ServiceException se) {
            se.printStackTrace();
            res_json = res_json.replace("#code#","-1").replace("#msg#",se.getMessage());
        } catch (MalformedURLException ex) {
            ex.printStackTrace();
            res_json = res_json.replace("#code#","-1").replace("#msg#", ex.getMessage());
        } catch (RemoteException re) {
            re.printStackTrace();
            res_json = res_json.replace("#code#","-1").replace("#msg#", re.getMessage());
        } catch (DocumentException e) {
            e.printStackTrace();
            res_json = res_json.replace("#code#","-1").replace("#msg#", e.getMessage());
        }
        System.out.println("ws_addrRepairSendOrder接口返回结果："+res_json);
        out(response, res_json);
    }

    public void out(HttpServletResponse response, String str){
        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");
        PrintWriter out;
        try {
            out = response.getWriter();
            out.println(str);
            out.flush();
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

	public static void main(String[] args) {
		//获取WEBSERVICE接口地址
        String nameSpace = "http://135.149.96.42:7020/axis/services/SendList";
		String endPoint = nameSpace + "?wsdl";
		//获取相应的WEBSERVICE接口方法
		String methodName = "AppSendList";
		try {
            Service service = new Service();
            Call call = (Call) service.createCall();
            call.setTargetEndpointAddress(new URL(endPoint));
            String xml = "<?xml version=\"1.0\" encoding=\"gb2312\"?>"+//utf-8
                    "<REGU_SHEET_TD>"+
                    "   <SOURCE_SYS>gis</SOURCE_SYS>"+//固定写"gis"
                    "   <WO_ID>2019031215363993110001</WO_ID>"+//已有的单子编号
                    "   <AREA_CODE>931</AREA_CODE>"+//地市编码
                    "   <COUNTY_TOWN>930013101</COUNTY_TOWN>"+//区县、分局编码
                    "   <USER_ID>畅家巷支局--畅家巷网格</USER_ID>"+//工单发起人姓名
                    "   <PROJECT_TYPE>18919818558</PROJECT_TYPE>"+//工单发起人联系方式
                    "   <ZONE_ADR>这里地址修正派单标题</ZONE_ADR>"+//工单标题
                    "   <EXTEND2>这里地址修正派单内容</EXTEND2>"+//工单内容
                    "</REGU_SHEET_TD>";
            call.addParameter("inBody", XMLType.XSD_STRING, ParameterMode.IN);
            call.setReturnType(XMLType.XSD_STRING);
            call.setOperationName(new QName(nameSpace, methodName));
            call.setUseSOAPAction(true);
            String resultstr = (String) call.invoke(new Object[] { xml });
            System.out.println(resultstr);
		} catch (ServiceException se) {
			se.printStackTrace();
		} catch (MalformedURLException ex) {
			ex.printStackTrace();
		} catch (RemoteException re) {
			re.printStackTrace();
		}
	}
}

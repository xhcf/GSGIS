package cn.com.gis.action;


import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;
import cn.com.gis.utils.ExcelUtil;
import cn.com.gis.utils.ResponseUtil;

import net.sf.json.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class ExcelFileAction {
    private Logger logger = LoggerFactory.getLogger(ExcelFileAction.class);
    private SqlRunner sqlRunner;

    //action
    @Action("getSession")
    public void getSession(Map map, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uploadInfo=(String)request.getSession().getAttribute("uploadInfo");
        out(response,uploadInfo);
    }

    //excele模板下载
    @Action("excel_download")
    public void excelModelDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String type = request.getParameter("type");
        String modelName = null;
        if("1".equals(type)){//异网收集
            modelName = "1.xlsx";
            List list=downSql(request,response);
            Workbook wb = ExcelUtil.fillExcelDataWithTemplate(list, modelName);
            Object o = request.getSession().getAttribute("UserInfo");
            String SUB_NAME = (String) JSONObject.fromObject(o).get("SUB_NAME");//支局
            String GRID_NAME = (String) JSONObject.fromObject(o).get("GRID_NAME");//网格

            String name=GRID_NAME!=null?SUB_NAME+"_"+GRID_NAME:SUB_NAME;
            ResponseUtil.export(response, wb, name+"异网收集模版.xlsx");
        }else if("2".equals(type)){//异网网点信息导入
            modelName = "2.xlsx";
            Workbook wb = ExcelUtil.getExcelTemplate(modelName);
            ResponseUtil.export(response, wb, new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+"渠道市场份额导入模板.xlsx");
        }
    }

    //异网收集 第一步
    //查询六级编码地址和名称
    public List downSql(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map =new HashMap<>();
        Object o = request.getSession().getAttribute("UserInfo");
        String latn_id = (String) JSONObject.fromObject(o).get("AREA_NO");//地市
        String BUREAU_NO = (String) JSONObject.fromObject(o).get("CITY_NO");//区县
        String UNION_ORG_CODE = (String) JSONObject.fromObject(o).get("TOWN_NO");//支局
        String GRID_UNION_ORG_CODE = (String) JSONObject.fromObject(o).get("GRID_NO");//网格
        map.put("latn_id", latn_id);
        map.put("BUREAU_NO", BUREAU_NO);
        map.put("UNION_ORG_CODE", UNION_ORG_CODE);
        if(GRID_UNION_ORG_CODE!=null){
            map.put("GRID_UNION_ORG_CODE", GRID_UNION_ORG_CODE);
        }
        List<Map<String, Object>> list = null;
        try {
            Long stime = System.currentTimeMillis();
            String sql="select segm_id_2, stand_name_2 from GIS_DATA.TB_GIS_ADDR_OTHER_ALL aa, sde.TB_GIS_MAP_SEGM_LATN_MON bb where aa.segm_id = bb.segm_id and bb.latn_id=#latn_id# and bb.BUREAU_NO = #BUREAU_NO# and bb.UNION_ORG_CODE = #UNION_ORG_CODE# {and bb.GRID_UNION_ORG_CODE = #GRID_UNION_ORG_CODE#} order by segm_id_2 asc";
            list = (List<Map<String, Object>>) sqlRunner.queryForMapList(sql, map);
            Long etime = System.currentTimeMillis();
            System.out.println("执行下载模板sql耗时" + (etime - stime));
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;

    }

    //查询出了四级编码地址，六级编码地址，名字
    public List checkSql(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map =new HashMap<>();
        Object o = request.getSession().getAttribute("UserInfo");
        String latn_id = (String) JSONObject.fromObject(o).get("AREA_NO");//地市
        String BUREAU_NO = (String) JSONObject.fromObject(o).get("CITY_NO");//区县
        String UNION_ORG_CODE = (String) JSONObject.fromObject(o).get("TOWN_NO");//支局
        String GRID_UNION_ORG_CODE = (String) JSONObject.fromObject(o).get("GRID_NO");//网格
        map.put("latn_id", latn_id);
        map.put("BUREAU_NO", BUREAU_NO);
        map.put("UNION_ORG_CODE", UNION_ORG_CODE);
        if(GRID_UNION_ORG_CODE!=null){
            map.put("GRID_UNION_ORG_CODE", GRID_UNION_ORG_CODE);
        }
        List<Map<String, Object>> list = null;
        try {
            Long stime = System.currentTimeMillis();
            String sql="select bb.segm_id,segm_id_2, stand_name_2 from GIS_DATA.TB_GIS_ADDR_OTHER_ALL aa, sde.TB_GIS_MAP_SEGM_LATN_MON bb  where aa.segm_id = bb.segm_id  and bb.latn_id=#latn_id# and bb.BUREAU_NO = #BUREAU_NO# and bb.UNION_ORG_CODE = #UNION_ORG_CODE# {and bb.GRID_UNION_ORG_CODE = #GRID_UNION_ORG_CODE#} order by segm_id_2 asc";
            list = (List<Map<String, Object>>) sqlRunner.queryForMapList(sql, map);
            Long etime = System.currentTimeMillis();
            System.out.println("执行下载模板sql耗时" + (etime - stime));
            return list;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;

    }

    //excele模板上传
    @Action("excel_upload")
    public void ExcelModelUpload(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String type = request.getParameter("type");
        String message = "0";
        HttpSession session=request.getSession();
        List<Map<String,Object>> sqlDate=null;

        List<Map<String,Object>> excelDate = null;//存excel文件中的中的数据
        session.setAttribute("uploadInfo", "文件上传中");
        try {
            //使用Apache文件上传组件处理文件上传步骤：
            //1、创建一个DiskFileItemFactory工厂
            request.setCharacterEncoding("utf-8");
            response.setHeader("Charset", "UTF-8");
            response.setContentType("text/html;charset=UTF-8");
            //获取上传参数的信息
            DiskFileItemFactory factory = new DiskFileItemFactory();
            //2、创建一个文件上传解析器
            ServletFileUpload upload = new ServletFileUpload(factory);
            //解决上传文件名的中文乱码
            upload.setHeaderEncoding("UTF-8");
            //3、判断提交上来的数据是否是上传表单的数据
            if (!ServletFileUpload.isMultipartContent(request)) {
                //按照传统方式获取数据
                return;
            }
            //4、使用ServletFileUpload解析器解析上传数据，解析结果返回的是一个List<FileItem>集合，每一个FileItem对应一个Form表单的输入项
            List<FileItem> list = upload.parseRequest(request);
            for (FileItem item : list) {
                //如果fileitem中封装的是普通输入项的数据
                if (item.isFormField()) {
                    String name = item.getFieldName();
                    //解决普通输入项的数据的中文乱码问题
                    String value = item.getString("UTF-8");
                } else {
                    //如果fileitem中封装的是上传文件
                    // 得到上传的文件名称，
                    String filename = item.getName();
                    if (filename == null || filename.trim().equals("")) {
                        continue;
                    }
                    //获取item中的上传文件的输入流
                    InputStream in = item.getInputStream();
                    XSSFWorkbook wb = new XSSFWorkbook(in);
                    Sheet sh0 = wb.getSheetAt(0);
                    Map<String,Object> res = null;
                    if (sh0 != null) {
                        //遍历excel,从第二行开始 即 rowNum=1,逐个获取单元格的内容,然后进行格式处理,最后插入数据库
                        if("1".equals(type)){
                            Object o = session.getAttribute("UserInfo");
                            String USER_ID = (String) JSONObject.fromObject(o).get("USER_ID");//用户id
                            res = model2db1(sh0,message,USER_ID,excelDate);
                        }else if("2".equals(type)){
                            res = model2db2(sh0,message,excelDate);
                        }
                        message = String.valueOf(res.get("msg"));
                        excelDate = (List<Map<String,Object>>)res.get("excelDate");
                    }

                    in.close();
                    //删除处理文件上传时生成的临时文件
                    item.delete();
                }
            }


            if("0".equals(message)){
                if("1".equals(type)){//异网资料收集
                    System.out.println("开始查询及校验数据");
                    session.setAttribute("uploadInfo","数据校验中");
                    sqlDate=checkSql(request,response);//查询要校验的数据

                    Long start=System.currentTimeMillis();

                    message =checkDate(excelDate,sqlDate);//校验六级地址和id

                    Long end=System.currentTimeMillis();
                    System.out.println("校验数据耗时"+(end-start));
                }else if("2".equals(type)){//异网网点信息导入

                }
            }


            //插入数据
            if ("0".equals(message)) {
                if("1".equals(type)){//异网资料收集
                    try {
                        session.setAttribute("uploadInfo","数据插入中");
                        message = update(session,excelDate);
                    } catch (Exception e) {
                        message="插入数据库异常";
                        e.printStackTrace();
                    }
                }else if("2".equals(type)){//异网网点信息导入
                    try{
                        session.setAttribute("uploadInfo","数据插入中");
                        message = update2(session, excelDate);
                    }catch(Exception e){
                        message="插入数据库异常";
                        e.printStackTrace();
                    }
                }
            }

        } catch (Exception e) {
            message = "文件解析出错！";
            e.printStackTrace();
        }
        Map m1 = new HashMap();
        m1.put("msg", message);
        session.setAttribute("uploadInfo", null);
        out(response, Functions.java2json(m1));
    }

    /*异网收集模版*/
    public Map<String, Object> model2db1(Sheet sh0,String message,String USER_ID,List<Map<String, Object>> excelDate){
        excelDate = new ArrayList<Map<String,Object>>();
        Map<String,Object> res = new HashMap<String,Object>();
        for (int rowNum = 1; rowNum <= sh0.getLastRowNum(); rowNum++) {
            XSSFRow row = (XSSFRow) sh0.getRow(rowNum);

            if (row == null || row.getCell(0) == null) {//六级地址id列为空值时跳过
                continue;
            }
            if (row.getCell(4) == null) {
                message = "第" + (rowNum + 1) + "行 宽带运营商不能为空！！";
                break;
            }

            if(!"未装".equals(ExcelUtil.formatCell3(row.getCell(4)))&&row.getCell(6)==null){
                message = "第" + (rowNum + 1) + "行 宽带到期时间 不能为空！！";
                break;
            }

            Map<String, Object> map = new HashMap<>();
            map.put("a", ExcelUtil.formatCell3(row.getCell(0)));//六级地址
            map.put("b", ExcelUtil.formatCell3(row.getCell(1)));
            map.put("c", ExcelUtil.formatCell3(row.getCell(2)));
            map.put("d", ExcelUtil.formatCell3(row.getCell(3)));
            map.put("e", ExcelUtil.formatCell3(row.getCell(4)));
            map.put("f", ExcelUtil.formatCell3(row.getCell(5)));
            map.put("g", ExcelUtil.formatCell3(row.getCell(6)));
            map.put("h", ExcelUtil.formatCell3(row.getCell(7)));
            map.put("i", ExcelUtil.formatCell3(row.getCell(8)));
            map.put("j", ExcelUtil.formatCell3(row.getCell(9)));
            map.put("k", ExcelUtil.formatCell3(row.getCell(10)));
            map.put("l", ExcelUtil.formatCell3(row.getCell(11)));
            map.put("m", ExcelUtil.formatCell3(row.getCell(12)));
            map.put("import_person", USER_ID);
            excelDate.add(map);
        }
        res.put("msg", message);
        res.put("excelDate", excelDate);
        return res;
    }

    /*渠道市场份额导入*/
    public Map<String, Object> model2db2(Sheet sh0,String message,List<Map<String, Object>> excelDate){
        excelDate = new ArrayList<Map<String,Object>>();
        Map<String,Object> res = new HashMap<String,Object>();
        for(int i = 1,l = sh0.getLastRowNum();i<=l;i++){
            XSSFRow row = (XSSFRow)sh0.getRow(i);
            if (row == null || row.getCell(0) == null) {//六级地址id列为空值时跳过
                continue;
            }
            if(row.getCell(4)==null){
                message = "第"+(i+1)+"行 运营商不能为空！";
                break;
            }else if(row.getCell(5)==null){
                message = "第"+(i+1)+"行 厅店类型不能为空！";
                break;
            }
            Map<String, Object> map = new HashMap<>();
            map.put("a",ExcelUtil.formatCell3(row.getCell(0)));
            map.put("b",ExcelUtil.formatCell3(row.getCell(1)));
            map.put("c",ExcelUtil.formatCell3(row.getCell(2)));
            map.put("d",ExcelUtil.formatCell3(row.getCell(3)));
            map.put("e",ExcelUtil.formatCell3(row.getCell(4)));
            map.put("f",ExcelUtil.formatCell3(row.getCell(5)));
            map.put("g",ExcelUtil.formatCell3(row.getCell(6)));
            excelDate.add(map);
        }
        res.put("msg", message);
        res.put("excelDate", excelDate);
        return res;
    }

    //比较id是否被更改
    public static String checkDate(List<Map<String,Object>> excelDate,List<Map<String,Object>> sqlDate) throws Exception {
        String msg="0";
        for (int i = 0; i < excelDate.size(); i++) {//循环excel数据
            String a = (String)excelDate.get(i).get("a");
            String b = (String) excelDate.get(i).get("b");
            String segm_id_2 = (String) sqlDate.get(i).get("segm_id_2");
            String stand_name_2 = (String) sqlDate.get(i).get("stand_name_2");
            if(!segm_id_2.equals(a)){
                msg="请勿修改 第"+(i+2)+"行六级地址编码";break;
            }
            if(!stand_name_2.equals(b)){
                msg="请勿修改 第"+(i+2)+"行六级地址名称";break;
            }

            excelDate.get(i).put("segm_id", sqlDate.get(i).get("segm_id"));

        }

        return  msg;

    }

    /*资料录入 入库*/
    public String update(HttpSession session, List<Map<String, Object>> list) {
        String msg = "数据库连接超时";
        StringBuffer delSql = new StringBuffer("DELETE FROM GIS_DATA.TB_GIS_ADDR_OTHER_ALL_imp WHERE SEGM_ID_2=?");
        StringBuffer insertSql = new StringBuffer("INSERT INTO GIS_DATA.TB_GIS_ADDR_OTHER_ALL_imp (" +
                "segm_id_2,stand_name_2,CONTACT_PERSON,CONTACT_NBR,kd_business,kd_xf,kd_dq_date,itv_business,itv_xf,itv_dq_date,note_txt,warn_date,COMMENTS,IMPORT_PERSON,IMPORT_TIME,segm_id)" +
                "VALUES (?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,?,to_date(?,'yyyy-mm-dd'),?,to_date(?,'yyyy-mm-dd'),?,?,sysdate,?)");

        Connection con = null;
        try {

            Long sTime = System.currentTimeMillis();
            session.setAttribute("uploadInfo","开始导入数据");
            System.out.println("开始批量执行删除和插入" + new Date());
            con = EasyContext.getContext().getDataSource().getConnection();
            con.setAutoCommit(false);
            PreparedStatement insertPs = con.prepareStatement(insertSql.toString());
            PreparedStatement delPs = con.prepareStatement(delSql.toString());
            for(int i=0,l=list.size();i<l;i++){
                Map<String, Object> m=list.get(i);
                delPs.setString(1, m.get("a").toString());
                delPs.addBatch();
                insertPs.setString(1, m.get("a").toString());
                insertPs.setString(2, m.get("b").toString());
                insertPs.setString(3, m.get("c").toString());
                insertPs.setString(4, m.get("d").toString());
                insertPs.setString(5, m.get("e").toString());
                insertPs.setString(6, m.get("f").toString());
                insertPs.setString(7, m.get("g").toString());
                insertPs.setString(8, m.get("h").toString());
                insertPs.setString(9, m.get("i").toString());
                insertPs.setString(10, m.get("j").toString());
                insertPs.setString(11, m.get("k").toString());
                insertPs.setString(12, m.get("l").toString());
                insertPs.setString(13, m.get("m").toString());
                insertPs.setString(14, m.get("import_person").toString());
                insertPs.setString(15, m.get("segm_id").toString());
                insertPs.addBatch();

                if((i+1)%1000==0){
                    delPs.executeBatch();
                    delPs.clearBatch();
                    insertPs.executeBatch();
                    insertPs.clearBatch();
                    System.out.println("已经插入"+i+"条数据");
                    session.setAttribute("uploadInfo","已经插入"+i+"条数据");


                }
            }


            delPs.executeBatch();
            delPs.clearBatch();
            insertPs.executeBatch();
            insertPs.clearBatch();

            con.commit();

            con.setAutoCommit(true);
            long eTime = System.currentTimeMillis();

            System.out.println("批量执行删除和插入sql耗时:" + (eTime - sTime));

            msg = "导入成功";


        } catch (SQLException e) {

            e.printStackTrace();
            logger.error(e.getSQLState(), e);
            try {
                if (!con.isClosed()) {
                    System.out.println("回滚");
                    con.rollback();
                }
            } catch (SQLException e1) {
                System.out.println("回滚抛异常！");
                e1.printStackTrace();
                logger.error(e1.getSQLState(), e1);
            }
            System.out.println("con:--"+con);


            msg = "数据库异常,请刷新页面后重试";

        }

        return msg;
    }

    public String update2(HttpSession session,List<Map<String, Object>> list){
        String msg = "数据库连接超时";
        Map userInfo = (Map)session.getAttribute("UserInfo");
        StringBuffer insertSql = new StringBuffer(
                "INSERT INTO GIS_DATA.TB_GIS_QD_MARKET" +
                "(latn_name, bureau_name, branch_name, grid_name, business_name, channel_name, channel_count,INPUT_TIME,LOGIN_ID,USER_NAME)" +
                "VALUES (?,?,?,?,?,?,?,sysdate,'"+userInfo.get("LOGIN_ID")+"','"+userInfo.get("USER_NAME")+"')");
        Connection con = null;
        try {

            Long sTime = System.currentTimeMillis();
            session.setAttribute("uploadInfo","开始导入数据");
            System.out.println("开始批量执行删除和插入" + new Date());
            con = EasyContext.getContext().getDataSource().getConnection();
            con.setAutoCommit(false);
            PreparedStatement insertPs = con.prepareStatement(insertSql.toString());
            for(int i=0,l=list.size();i<l;i++){
                Map<String, Object> m=list.get(i);
                insertPs.setString(1, m.get("a").toString());
                insertPs.setString(2, m.get("b").toString());
                insertPs.setString(3, m.get("c").toString());
                insertPs.setString(4, m.get("d").toString());
                insertPs.setString(5, m.get("e").toString());
                insertPs.setString(6, m.get("f").toString());
                insertPs.setString(7, m.get("g").toString());

                insertPs.addBatch();

                if((i+1)%1000==0){
                    insertPs.executeBatch();
                    insertPs.clearBatch();
                    System.out.println("已经插入"+i+"条数据");
                    session.setAttribute("uploadInfo","已经插入"+i+"条数据");
                }
            }

            insertPs.executeBatch();
            insertPs.clearBatch();

            con.commit();

            con.setAutoCommit(true);
            long eTime = System.currentTimeMillis();

            System.out.println("批量执行删除和插入sql耗时:" + (eTime - sTime));

            msg = "导入成功";
        } catch (SQLException e) {

            e.printStackTrace();
            logger.error(e.getSQLState(), e);
            try {
                if (!con.isClosed()) {
                    System.out.println("回滚");
                    con.rollback();
                }
            } catch (SQLException e1) {
                System.out.println("回滚抛异常！");
                e1.printStackTrace();
                logger.error(e1.getSQLState(), e1);
            }
            System.out.println("con:--"+con);


            msg = "数据库异常,请刷新页面后重试";

        }

        return msg;
    }

    public void out(HttpServletResponse response, String str) {
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


}

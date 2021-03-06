package cn.com.easy.down.client.action;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

/**
 * Created by huiyf on 2018/6/11.
 * purpose：excel文件操作
 */
@Controller
public class YXSPExcelAction {
    private SqlRunner runner;
    //private ServletOutputStream out;
    //private XSSFWorkbook wb;

    /**
     * 宽带家庭渗透率Excel导出
     *
     * @param excelName
     * @param request
     * @param response
     */
    @Action("market_ExcelDownload")
    public void market_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【宽带家庭渗透率】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            String query_flag = request.getParameter("query_flag");

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.market_makeSql(request);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            String file = request.getParameter("file");
            String region = "";
            if("1".equals(file)){
                out = response.getOutputStream();
                if("1".equals(query_flag)){
                    region = "市";
                }else if("2".equals(query_flag)){
                    region = "县";
                }else if("3".equals(query_flag)){
                    region = "支局";
                }else if("4".equals(query_flag)){
                    region = "网格";
                }else if("5".equals(query_flag)){
                    region = "小区";
                }
                String title = "宽带家庭渗透率_" + region +"_"+request.getParameter("beginDate")+".xlsx";
                response.setContentType("application/vnd.ms-excel;charset=GBK");
                response.setCharacterEncoding("GBK");

                response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
                XSSFWorkbook wb = new XSSFWorkbook();

                //小区以外
                if (!"5".equals(query_flag)) {
                    //小区以外的数据excel做成
                    market_notVillageExcel(dataList, query_flag,wb);
                } else {
                    //小区的数据excel做成
                    market_villageExcel(dataList,wb);
                }

                out.flush();
                wb.write(out);
            }else{
            }
            //System.out.println("-------------------------------【宽带家庭渗透率】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 宽带家庭渗透率---小区以外的 市 县 支局 网格的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> market_notVillageCell(String query_flag) {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        if ("1".equals(query_flag))
            headMap.put("AREA_DESC", "地市");
        else if ("2".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
        } else if ("3".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
        } else if ("4".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
        }

        headMap.put("BROAD_PENETRANCE", "累计到达渗透率");
        headMap.put("FILTER_MON_RATE", "本月提升");
        headMap.put("FILTER_YEAR_RATE", "本年提升");
        headMap.put("VILLAGE_CNT", "小区数");
        headMap.put("GZ_ZHU_HU_COUNT", "住户数");
        headMap.put("GZ_H_USE_CNT", "光宽用户数");
        headMap.put("HIGH_FILTER_VILLAGE_CNT", "高渗透率小区");
        headMap.put("HIGH_FILTER_RATE", "占比");
        headMap.put("MID_FILTER_VILLAGE_CNT", "中渗透率小区");
        headMap.put("MID_FILTER_RATE", "占比");
        headMap.put("LOW_FILTER_VILLAGE_CNT", "中低渗透率小区");
        headMap.put("LOW_FILTER_RATE", "占比");
        headMap.put("LOW_10_FILTER_VILLAGE_CNT", "低渗透率小区");
        headMap.put("LOW_10_FILTER_RATE", "占比");

        System.out.println(headMap);
        return headMap;
    }

    /**
     * 宽带家庭渗透率---小区的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> market_villageCell() {

        Map<String, String> headMap = new LinkedHashMap<String, String>();

        headMap.put("NO", "序号");
        headMap.put("AREA_DESC", "分公司");
        headMap.put("AREA_DESC1", "分局");
        headMap.put("AREA_DESC2", "支局");
        headMap.put("AREA_DESC3", "网格");
        headMap.put("AREA_DESC4", "小区");
        headMap.put("BROAD_PENETRANCE", "累计达到渗透率");
        headMap.put("FILTER_MON_RATE", "本月提升");
        headMap.put("FILTER_YEAR_RATE", "本年提升");
        headMap.put("GZ_ZHU_HU_COUNT", "住户数");
        headMap.put("GZ_H_USE_CNT", "光宽用户数");
        headMap.put("GOV_ZHU_HU_COUNT", "政企住户");
        headMap.put("GOV_H_USE_CNT", "政企宽带");

        return headMap;
    }

    /**
     * 宽带家庭渗透率---小区以外的 市 县 支局 网格的情况
     *
     * @param dataList
     */
    private void market_notVillageExcel(List<Map> dataList, String query_flag,XSSFWorkbook wb) {

        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "宽带家庭渗透率");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = null;

        if ("1".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 15);
        else if ("2".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 16);
        else if ("3".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 17);
        else if ("4".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 18);

        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("宽带家庭渗透率");
        setBorderForMergeCell(1, brodercell, sheet, wb);

        //字段名称
        Map<String, String> headMap = market_notVillageCell(query_flag);

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);

    }

    /**
     * 宽带家庭渗透率---小区的情况
     *
     * @param dataList
     */
    private void market_villageExcel(List<Map> dataList,XSSFWorkbook wb) {
        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "宽带家庭渗透率");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = new CellRangeAddress(0, 0, 0, 12);
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("宽带家庭渗透率");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = market_villageCell();

        //EXCEL 写入
        System.out.print("宽带家庭渗透率 写入开始");
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    /**
     * 光网覆盖情况Excel导出
     *
     * @param excelName
     * @param request
     * @param response
     */
    @Action("fb_cover_ExcelDownload")
    public void FB_COVER_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【光网覆盖情况报表】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            String query_flag = request.getParameter("query_flag");

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql

            System.out.println("query_flag:" + query_flag);
            String excuteSql = yxspExcelSql.fb_cover_makeSql(request);
            System.out.println("excuteSql:" + excuteSql);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            String file = request.getParameter("file");
            String region = "";
            if("1".equals(file)){
                out = response.getOutputStream();
                if("1".equals(query_flag)){
                    region = "市";
                }else if("2".equals(query_flag)){
                    region = "县";
                }else if("3".equals(query_flag)){
                    region = "支局";
                }else if("4".equals(query_flag)){
                    region = "网格";
                }else if("5".equals(query_flag)){
                    region = "小区";
                }
                String title = "光网覆盖情况_" + region +"_"+request.getParameter("beginDate")+".xlsx";
                response.setContentType("application/vnd.ms-excel;charset=GBK");
                response.setCharacterEncoding("GBK");
                response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));

                response.addHeader("Pargam", "no-cache");
                response.addHeader("Cache-Control", "no-cache");

                XSSFWorkbook wb = new XSSFWorkbook();

                //小区以外
                if (!"5".equals(query_flag)) {
                    //小区以外的数据excel做成
                    fb_cover_notVillageExcel(dataList, query_flag,wb);
                } else {
                    //小区的数据excel做成
                    fb_cover_villageExcel(dataList,wb);
                }

                out.flush();
                wb.write(out);
                out.close();
            }else{

            }

            //System.out.println("-------------------------------【光网覆盖情况报表】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 光网覆盖情况---小区以外的 市 县 支局 网格的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> fb_cover_notVillageCell(String query_flag) {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        if ("1".equals(query_flag))
            headMap.put("AREA_DESC", "地市");
        else if ("2".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
        } else if ("3".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
        } else if ("4".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
        }
        headMap.put("VILLAGE_CNT", "小区");
        headMap.put("GZ_ZHU_HU_COUNT", "住户");
        headMap.put("FB_RATE", "光网覆盖率");
        headMap.put("FB_BUILD_VILLAGE", "总楼宇数");
        headMap.put("FB_BUILD_VILLAGE_RATE", "资源已达楼宇数");
        headMap.put("FB_N_BUILD_VILLAGE", "资源未达楼宇数");
        headMap.put("FB_N_BUILD_VILLAGE_RATE", "OBD设备数");

        return headMap;
    }

    /**
     * 光网覆盖情况---小区的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> fb_cover_villageCell() {

        Map<String, String> headMap = new LinkedHashMap<String, String>();

        headMap.put("NO", "序号");
        headMap.put("AREA_DESC", "分公司");
        //headMap.put("AREA_DESC1", "分局");
        headMap.put("AREA_DESC2", "支局");
        headMap.put("AREA_DESC3", "网格");
        headMap.put("AREA_DESC4", "小区");
        headMap.put("GZ_ZHU_HU_COUNT", "住户");
        headMap.put("FB_RATE", "光网覆盖率");
        headMap.put("FB_BUILD_VILLAGE", "总楼宇数");
        headMap.put("FB_BUILD_VILLAGE_RATE", "资源已达楼宇数");
        headMap.put("FB_N_BUILD_VILLAGE", "资源未达楼宇数");
        headMap.put("FB_N_BUILD_VILLAGE_RATE", "OBD设备数");
        return headMap;
    }

    /**
     * 光网覆盖情况---小区以外的 市 县 支局 网格的情况
     *
     * @param dataList
     */
    private void fb_cover_notVillageExcel(List<Map> dataList, String query_flag,XSSFWorkbook wb) {

        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "光网覆盖情况");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = null;
        if ("1".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 8);
        else if ("2".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 9);
        else if ("3".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 10);
        else if ("4".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 11);

        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("光网覆盖情况");
        setBorderForMergeCell(1, brodercell, sheet, wb);

        //字段名称
        Map<String, String> headMap = fb_cover_notVillageCell(query_flag);

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);

    }

    /**
     * 光网覆盖情况---小区的情况
     *
     * @param dataList
     */
    private void fb_cover_villageExcel(List<Map> dataList,XSSFWorkbook wb) {
        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "光网覆盖情况");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = new CellRangeAddress(0, 0, 0, 11);
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("光网覆盖情况");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = fb_cover_villageCell();

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    /**
     * 光网实占情况Excel导出
     *
     * @param excelName
     * @param request
     * @param response
     */
    @Action("fb_realPer_ExcelDownload")
    public void FB_REALPER_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【光网实占情况】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            String query_flag = request.getParameter("query_flag");

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.fb_realPer_makeSql(request);

            //System.out.println("excuteSql:"+excuteSql);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            String file = request.getParameter("file");
            String region = "";
            if("1".equals(file)){
                out = response.getOutputStream();
                if("1".equals(query_flag)){
                    region = "市";
                }else if("2".equals(query_flag)){
                    region = "县";
                }else if("3".equals(query_flag)){
                    region = "支局";
                }else if("4".equals(query_flag)){
                    region = "网格";
                }else if("5".equals(query_flag)){
                    region = "小区";
                }
                String title = "光网实占情况_" + region +"_"+request.getParameter("beginDate")+".xlsx";
                response.setContentType("application/vnd.ms-excel;charset=GBK");
                response.setCharacterEncoding("GBK");
                response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
                XSSFWorkbook wb = new XSSFWorkbook();

                //数据excel做成
                fb_realPer_Excel(dataList, query_flag,wb);

                wb.write(out);
            }else{

            }
            //System.out.println("-------------------------------【光网实占情况】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 光网实占情况---小区以外的 市 县 支局 网格,小区的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> fb_realPer_Cell(String query_flag) {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        if ("1".equals(query_flag))
            headMap.put("AREA_DESC", "地市");
        else if ("2".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
        } else if ("3".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
        } else if ("4".equals(query_flag)) {
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
        } else if ("5".equals(query_flag)) {//20180719 bug
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
            headMap.put("AREA_DESC4", "小区");
        }
        headMap.put("GZZH_CNT", "住户数");
        headMap.put("PORT_CNT", "端口数");
        headMap.put("USE_PORT_CNT", "实占端口数");
        headMap.put("PORT_RATE", "端口占用率");
        headMap.put("OBD_CNT", "OBD设备数");
        headMap.put("ZERO_OBD_CNT", "0OBD设备数");
        headMap.put("ZERO_OBD_RATE", "占比");

        headMap.put("ONE_OBD_CNT", "1OBD设备数");
        headMap.put("ONE_OBD_RATE", "占比");
        headMap.put("LOW_OBD_CNT", "小于30%占用率设备");
        headMap.put("LOW_OBD_RATE", "占比");

        return headMap;
    }

    /**
     * 光网实占情况
     *
     * @param dataList
     */
    private void fb_realPer_Excel(List<Map> dataList, String query_flag,XSSFWorkbook wb) {

        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "光网实占情况");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = null;
        if ("1".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 12);
        else if ("2".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 13);
        else if ("3".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 14);
        else if ("4".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 15);
        else if ("5".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 16);
            //brodercell = new CellRangeAddress(0, 0, 0, 16);//20180719 bug

        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("光网实占情况");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = fb_realPer_Cell(query_flag);
        System.out.println(headMap);
        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    /**
     * 精准派单营销Excel导出
     *
     * @param excelName
     * @param request
     * @param response
     */
    @Action("dispatch_yx_ExcelDownload")
    public void dispatch_yx_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【精准派单营销】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            String query_flag = request.getParameter("query_flag");

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.dispatch_yx_makeSql(request);

            //System.out.println("excuteSql:"+excuteSql);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            out = response.getOutputStream();
            String title = "精准派单营销.xlsx";
            response.setContentType("application/vnd.ms-excel;charset=GBK");
            response.setCharacterEncoding("GBK");
            response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
            XSSFWorkbook wb = new XSSFWorkbook();

            //数据excel做成
            dispatch_yx_Excel(dataList,query_flag,wb);

            wb.write(out);
            //System.out.println("-------------------------------【精准派单营销】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 精准派单营销---市 县 支局 网格,小区的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> dispatch_yx_Cell(String query_flag) {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        if ("1".equals(query_flag))
            headMap.put("AREA_DESC", "地市");
        else if ("2".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
        }else if ("3".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
        }else if ("4".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
        }else if ("5".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
            headMap.put("AREA_DESC4", "小区");
        }
        //headMap.put("AREA_DESC","地域");

        headMap.put("MBYH_CNT", "当月派单数");
        headMap.put("ZX_CNT", "当日执行数");
        headMap.put("ZX_RATE", "当日执行率");
        headMap.put("CGYH_CNT", "当日成功用户");
        headMap.put("CG_RATE", "当日成功率");
        headMap.put("ZX_CNT_MONTH", "当月执行数");
        headMap.put("ZX_RATE_MONTH", "当月执行率");
        headMap.put("CGYH_CNT_MONTH", "当月成功用户");
        headMap.put("CG_RATE_MONTH", "当月成功率");

        return headMap;
    }

    /**
     * 精准派单营销
     *
     * @param dataList
     */
    private void dispatch_yx_Excel(List<Map> dataList,String query_flag,XSSFWorkbook wb) {

        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "精准派单营销");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = null;
        if ("1".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 10);
        else if ("2".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 11);
        else if ("3".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 12);
        else if ("4".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 13);
        else if ("5".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 14);
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("精准派单营销");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = dispatch_yx_Cell(query_flag);

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    /**
     * 竞争信息收集Excel导出
     *
     * @param excelName
     * @param request
     * @param response
     */
    @Action("collect_ExcelDownload")
    public void collect_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【竞争信息收集】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            //竞争收集情况 ：0 竞争预警：1
            String typeIndex = request.getParameter("typeIndex");
            //小区区分
            String query_flag = request.getParameter("query_flag");
            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = "";//yxspExcelSql.protection_makeSql(request);
            //竞争收集情况
            if ("0".equals(typeIndex)) {
                excuteSql = yxspExcelSql.collect_net_makeSql(request);
            } else if ("1".equals(typeIndex)) {//竞争预警
                excuteSql = yxspExcelSql.collect_warning_makeSql(request);
            }

            //System.out.println("excuteSql:"+excuteSql);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            String file = request.getParameter("file");
            String region = "";
            if("1".equals(file)){
                out = response.getOutputStream();
                if("1".equals(query_flag)){
                    region = "市";
                }else if("2".equals(query_flag)){
                    region = "县";
                }else if("3".equals(query_flag)){
                    region = "支局";
                }else if("4".equals(query_flag)){
                    region = "网格";
                }else if("5".equals(query_flag)){
                    region = "小区";
                }
                String title = "竞争信息收集_" + region +"_"+request.getParameter("beginDate")+".xlsx";
                response.setContentType("application/vnd.ms-excel;charset=GBK");
                response.setCharacterEncoding("GBK");
                response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
                XSSFWorkbook wb = new XSSFWorkbook();

                //竞争收集情况
                if ("0".equals(typeIndex)) {
                    net_collect_Excel(dataList,query_flag,wb);
                } else if ("1".equals(typeIndex)) {
                    //竞争预警
                    warning_collect_Excel(dataList,query_flag, wb);
                }
                out.flush();
                wb.write(out);
                //System.out.println("-------------------------------【竞争信息收集】生成结束------------------------");
            }else{

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 竞争信息收集--竞争对手光网进线情况---小区以外的 市 县 支局 网格,小区的情况excel导出的字段内容
     *
     */
    private Map<String, String> net_collect_cell(String query_flag) {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        if ("1".equals(query_flag))
            headMap.put("AREA_DESC", "地市");
        else if ("2".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
        }else if ("3".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
        }else if ("4".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
        }else if ("5".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
            headMap.put("AREA_DESC4", "小区");
        }
        headMap.put("SHOULD_COLLECT_CNT", "未装宽带住户数");
        headMap.put("ALREADY_COLLECT_CNT", "已收集数");
        headMap.put("COLLECT_RATE", "收集率");
        headMap.put("OTHER_MON_RATE", "本月提升");
        headMap.put("OTHER_YEAR_RATE", "全年提升");

        headMap.put("COLLECT_DAY_CNT", "当日新增数");
        headMap.put("UPDATE_DAY_CNT", "当日修改数");

        headMap.put("OTHER_BD_CNT", "异网总数");
        headMap.put("OTHER_CM_CNT", "移动");
        headMap.put("MB_RATE", "占比");
        headMap.put("OTHER_CU_CNT", "联通");
        headMap.put("MU_RATE", "占比");
        headMap.put("OTHER_SARFT_CNT", "广电");
        headMap.put("OTHER_Y_CNT", "其他");
        headMap.put("OTHER_UNINSTALL_CNT", "未装宽带");

        if ("5".equals(query_flag)){
            headMap.put("COLLECT_CNT", "录入进线运营商数");
            headMap.put("BUSS_CNT", "统计进线运营商数");
        }

        return headMap;
    }

    /**
     * 竞争信息收集--竞争对手光网进线情况
     *
     * @param dataList
     */
    private void net_collect_Excel(List<Map> dataList,String query_flag,XSSFWorkbook wb) {

        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "竞争信息收集");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = null;
        if("1".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,16);
        else if("2".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,17);
        else if("3".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,18);
        else if("4".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,19);
        else if("5".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,22);
        //sheet.addMergedRegion(new CellRangeAddress(0,0,0,13));
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("竞争信息收集");

        setBorderForMergeCell(1, brodercell, sheet, wb);

        //字段名称
        Map<String, String> headMap = net_collect_cell(query_flag);

        //EXCEL 写入
        //XSSFSheet sheet, XSSFCellStyle titleCellStyle, XSSFCellStyle cellStyle, Map<String, String> headMap, List<Map> dataList
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    /**
     * 竞争信息收集--竞争预警---小区以外的 市 县 支局 网格,小区的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> warning_collect_cell(String query_flag) {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");

        if ("1".equals(query_flag))
            headMap.put("AREA_DESC", "地市");
        else if ("2".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
        }else if ("3".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
        }else if ("4".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
        }else if ("5".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
            headMap.put("AREA_DESC4", "小区");
        }

        //友商小区光网覆盖情况(个)
        if ("5".equals(query_flag)) {
            headMap.put("VILLAGE_CNT", "小区总数(个)");
            headMap.put("OTHER_NET_KD_VILLAGE_CNT", "友商光网覆盖小区总数");
        }

        headMap.put("CMCC_KD_VILLAGE_CNT", "移动");
        headMap.put("CUCC_KD_VILLAGE_CNT", "联通");
        headMap.put("CBN_KD_VILLAGE_CNT", "广电");
        headMap.put("OTHER_KD_VILLAGE_CNT", "其他");
        //友商发展宽带用户数(个)
        headMap.put("OTHER_BD_CNT", "友商发展宽带总数");
        headMap.put("OTHER_CM_CNT", "移动");
        headMap.put("OTHER_CU_CNT", "联通");
        headMap.put("OTHER_SARFT_CNT", "广电");
        headMap.put("OTHER_Y_CNT", "其他");
        //宽带市场份额(%)
        headMap.put("DX_MARKET_SHARE", "电信");
        headMap.put("CM_MARKET_SHARE", "移动");
        headMap.put("CU_MARKET_SHARE", "联通");
        headMap.put("SARFT_MARKET_SHARE", "广电");
        headMap.put("OTHER_MARKET_SHARE", "其他");

        return headMap;
    }

    /**
     * 竞争信息收集--竞争预警
     *
     * @param dataList
     */
    private void warning_collect_Excel(List<Map> dataList,String query_flag, XSSFWorkbook wb) {

        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "竞争信息收集");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = null;
        if ("1".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 15);
        else if ("2".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 16);
        else if ("3".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 17);
        else if ("4".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 18);
        else if ("5".equals(query_flag))
            brodercell = new CellRangeAddress(0, 0, 0, 19);

        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("竞争信息收集");
        setBorderForMergeCell(1, brodercell, sheet, wb);

        //字段名称
        Map<String, String> headMap = warning_collect_cell(query_flag);

        //EXCEL 写入
        //makeExcelByNotHead(sheet, cellStyle, headMap, dataList);
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    /**
     * 宽带存量保有率Excel导出
     *
     * @param excelName
     * @param request
     * @param response
     */
    @Action("protection_ExcelDownload")
    public void protection_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【宽带存量保有率】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            String query_flag = request.getParameter("query_flag");

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.protection_makeSql(request);

            //System.out.println("excuteSql:"+excuteSql);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            String file = request.getParameter("file");
            String region = "";
            if("1".equals(file)){
                out = response.getOutputStream();
                if("1".equals(query_flag)){
                    region = "市";
                }else if("2".equals(query_flag)){
                    region = "县";
                }else if("3".equals(query_flag)){
                    region = "支局";
                }else if("4".equals(query_flag)){
                    region = "网格";
                }else if("5".equals(query_flag)){
                    region = "小区";
                }
                String title = "宽带存量保有率_" + region +"_"+request.getParameter("beginDate")+".xlsx";
                response.setContentType("application/vnd.ms-excel;charset=GBK");
                response.setCharacterEncoding("GBK");
                response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
                XSSFWorkbook wb = new XSSFWorkbook();

                //数据excel做成
                protection_Excel(dataList,query_flag,wb);

                wb.write(out);
            }else{

            }
            //System.out.println("-------------------------------【宽带存量保有率】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 宽带存量保有率---小区以外的 市 县 支局 网格,小区的情况excel导出的字段内容
     *
     * @param dataList
     */
    private Map<String, String> protection_Cell(String query_flag) {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        if ("1".equals(query_flag))
            headMap.put("AREA_DESC", "地市");
        else if ("2".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
        }else if ("3".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
        }else if ("4".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
        }else if ("5".equals(query_flag)){
            headMap.put("AREA_DESC", "地市");
            headMap.put("AREA_DESC1", "分局");
            headMap.put("AREA_DESC2", "支局");
            headMap.put("AREA_DESC3", "网格");
            headMap.put("AREA_DESC4", "小区");
        }
        headMap.put("BY_RATE", "保有率");
        headMap.put("XY_RATE", "续约率");
        headMap.put("ACTIVE_RATE", "活跃率");
        headMap.put("LW_RATE", "离网率");

        return headMap;
    }

    /**
     * 宽带存量保有率
     *
     * @param dataList
     */
    private void protection_Excel(List<Map> dataList,String query_flag,XSSFWorkbook wb) {

        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "宽带存量保有率");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = null;
        if("1".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,9);
        else if("2".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,10);
        else if("3".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,11);
        else if("4".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,12);
        else if("5".equals(query_flag))
            brodercell = new CellRangeAddress(0,0,0,13);
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("宽带存量保有率");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = protection_Cell(query_flag);

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    /**
     * cellStyle 设置 styleType(title,head,cell)
     *
     * @param styleType
     */
    private XSSFCellStyle getXSSFCellStyle(String styleType,XSSFWorkbook wb) {

        XSSFCellStyle cellStyle = wb.createCellStyle();
        if ("title".equals(styleType)) {
            cellStyle.setAlignment(CellStyle.ALIGN_CENTER);  // 设置单元格水平方向对其方式
            cellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER); // 设置单元格垂直方向对其方式
            cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
            //titleCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

            XSSFFont font = wb.createFont();
            font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);//粗体显示
            cellStyle.setFont(font);
        } else if ("head".equals(styleType)) {
            cellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
            //headCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        } else if ("cell".equals(styleType)) {
            cellStyle.setAlignment(CellStyle.ALIGN_CENTER);  // 设置单元格水平方向对其方式
            cellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER); // 设置单元格垂直方向对其方式
            cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
            cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
            cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
            cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
        }

        return cellStyle;
    }

    /**
     * 合并单元格设置边框
     *
     * @param i
     * @param cellRangeTitle
     * @param sheet
     * @param wb2
     */
    private static void setBorderForMergeCell(int i, CellRangeAddress cellRangeTitle, XSSFSheet sheet, Workbook wb) {
        RegionUtil.setBorderBottom(i, cellRangeTitle, sheet, wb);
        RegionUtil.setBorderLeft(i, cellRangeTitle, sheet, wb);
        RegionUtil.setBorderRight(i, cellRangeTitle, sheet, wb);
        RegionUtil.setBorderTop(i, cellRangeTitle, sheet, wb);
    }

    /**
     * excel 做成
     *
     * @param XSSFSheet sheet,XSSFCellStyle titleCellStyle,XSSFCellStyle cellStyle,Map<String,String> headMap,List<Map>  dataList
     */
    private void makeExcel(XSSFSheet sheet, XSSFCellStyle titleCellStyle, XSSFCellStyle cellStyle, Map<String, String> headMap, List<Map> dataList) {

        //字段名称
        Row row = sheet.createRow(1);

        int cellIndex = 0;
        for (Map.Entry<String, String> entry : headMap.entrySet()) {
            //System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
            //创建cell
            Cell cell = row.createCell(cellIndex);
            //cell设置样式
            cell.setCellStyle(titleCellStyle);
            //cell 填充内容
            cell.setCellValue(entry.getValue());

            if ("序号".equals(entry.getValue())) {
                sheet.setColumnWidth(cellIndex, 8 * 256);
            } else if ("地域".equals(entry.getValue())) {
                sheet.setColumnWidth(cellIndex, 15 * 256);
            } else {
                sheet.setColumnWidth(cellIndex, 12 * 256);
            }

            cellIndex = cellIndex + 1;
        }

        //创建内容行
        int rowIndex = 2;

        try{
            if (dataList != null && !dataList.isEmpty()) {
                for (Map m : dataList) {
                    row = sheet.createRow(rowIndex++);
                    //cell单元格下标
                    cellIndex = 0;
                    //创建cell
                    for (Map.Entry<String, String> entry : headMap.entrySet()) {
                        //创建cell
                        Cell cell = row.createCell(cellIndex);
                        //cell设置样式
                        cell.setCellStyle(cellStyle);
                        //sheet.setColumnWidth(cellIndex, 15*256);
                        //序号
                        if (cellIndex == 0) {
                            //序号
                            cell.setCellValue(rowIndex - 2);
                        } else {
                            //内容设置
                            cell.setCellValue(m.get(entry.getKey()) + "");
                        }
                        cellIndex = cellIndex + 1;
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    /**
     * excel 做成 不带标题
     *
     * @param XSSFSheet sheet,XSSFCellStyle cellStyle,Map<String,String> headMap,List<Map>  dataList
     */
    private void makeExcelByNotHead(XSSFSheet sheet, XSSFCellStyle cellStyle, Map<String, String> headMap, List<Map> dataList) {

        //字段名称
        Row row;
        int cellIndex = 0;

        //创建内容行
        int rowIndex = 3;
        try{
            if (dataList != null && !dataList.isEmpty()) {
                for (Map m : dataList) {
                    row = sheet.createRow(rowIndex++);
                    //cell单元格下标
                    cellIndex = 0;
                    //创建cell
                    for (Map.Entry<String, String> entry : headMap.entrySet()) {
                        //创建cell
                        Cell cell = row.createCell(cellIndex);
                        //cell设置样式
                        cell.setCellStyle(cellStyle);
                        //序号
                        if (cellIndex == 0) {
                            //序号
                            cell.setCellValue(rowIndex - 3);
                        } else {
                            //内容设置
                            cell.setCellValue(m.get(entry.getKey()) + "");
                        }
                        cellIndex = cellIndex + 1;
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    /**
     * excel生成 住户清单
     * @param excelName
     * @param request
     * @param response
     */
    @Action("resident_ExcelDownload")
    public void resident_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response){
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【宽带存量保有率】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            String query_flag = request.getParameter("query_flag");

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.resident_makeSql(request);

            //System.out.println("excuteSql:"+excuteSql);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            out = response.getOutputStream();
            String title = "住户清单.xlsx";
            response.setContentType("application/vnd.ms-excel;charset=GBK");
            response.setCharacterEncoding("GBK");
            response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
            XSSFWorkbook wb = new XSSFWorkbook();

            //数据excel做成
            resident_Excel(dataList, wb);

            wb.write(out);
            //System.out.println("-------------------------------【宽带存量保有率】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void resident_Excel(List<Map> dataList,XSSFWorkbook wb){
        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "住户清单");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = new CellRangeAddress(0, 0, 0, 11);//起始行、终止行、起始列、终止列
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("住户清单");
        setBorderForMergeCell(1, brodercell, sheet, wb);

        //第二行
        Row titleRow1 = sheet.createRow(1);
        titleRow1.setHeight((short) (25 * 20));

        CellRangeAddress brodercell1 = new CellRangeAddress(1, 2, 0, 0);
        sheet.addMergedRegion(brodercell1);
        Cell title_cell1 = titleRow1.createCell(0);
        title_cell1.setCellStyle(titleCellStyle);
        title_cell1.setCellValue("序号");
        setBorderForMergeCell(1, brodercell1, sheet, wb);

        CellRangeAddress brodercell2 = new CellRangeAddress(1, 2, 1, 1);
        sheet.addMergedRegion(brodercell2);
        Cell title_cell2 = titleRow1.createCell(1);
        title_cell2.setCellStyle(titleCellStyle);
        title_cell2.setCellValue("楼宇名称");
        setBorderForMergeCell(1, brodercell2, sheet, wb);

        CellRangeAddress brodercell3 = new CellRangeAddress(1, 2, 2, 2);
        sheet.addMergedRegion(brodercell3);
        Cell title_cell3 = titleRow1.createCell(2);
        title_cell3.setCellStyle(titleCellStyle);
        title_cell3.setCellValue("房间号");
        setBorderForMergeCell(1, brodercell3, sheet, wb);

        CellRangeAddress brodercell4 = new CellRangeAddress(1, 1, 3, 5);
        sheet.addMergedRegion(brodercell4);
        Cell title_cell4 = titleRow1.createCell(3);
        title_cell4.setCellStyle(titleCellStyle);
        title_cell4.setCellValue("电信宽带信息");
        setBorderForMergeCell(1, brodercell4, sheet, wb);

        CellRangeAddress brodercell5 = new CellRangeAddress(1, 1, 6, 10);
        sheet.addMergedRegion(brodercell5);
        Cell title_cell5 = titleRow1.createCell(6);
        title_cell5.setCellStyle(titleCellStyle);
        title_cell5.setCellValue("异网宽带信息");
        setBorderForMergeCell(1, brodercell5, sheet, wb);

        //第三行
        Row titleRow2 = sheet.createRow(2);
        titleRow2.setHeight((short) (25 * 20));
        //电信宽带信息 子项
        CellRangeAddress brodercell6 = new CellRangeAddress(2, 2, 0, 0);
        sheet.addMergedRegion(brodercell6);
        Cell title_cell6 = titleRow2.createCell(3);
        title_cell6.setCellStyle(titleCellStyle);
        title_cell6.setCellValue("客户名称");
        setBorderForMergeCell(1, brodercell6, sheet, wb);

        CellRangeAddress brodercell7 = new CellRangeAddress(2, 2, 1, 1);
        sheet.addMergedRegion(brodercell7);
        Cell title_cell7 = titleRow2.createCell(4);
        title_cell7.setCellStyle(titleCellStyle);
        title_cell7.setCellValue("宽带接入号码");
        setBorderForMergeCell(1, brodercell7, sheet, wb);

        CellRangeAddress brodercell8 = new CellRangeAddress(2, 2, 2, 2);
        sheet.addMergedRegion(brodercell8);
        Cell title_cell8 = titleRow2.createCell(5);
        title_cell8.setCellStyle(titleCellStyle);
        title_cell8.setCellValue("联系电话");
        setBorderForMergeCell(1, brodercell8, sheet, wb);

        CellRangeAddress brodercell9 = new CellRangeAddress(2, 2, 3, 3);
        sheet.addMergedRegion(brodercell9);
        Cell title_cell9 = titleRow2.createCell(6);
        title_cell9.setCellStyle(titleCellStyle);
        title_cell9.setCellValue("联系人");
        setBorderForMergeCell(1, brodercell9, sheet, wb);

        CellRangeAddress brodercel20 = new CellRangeAddress(2, 2, 4, 4);
        sheet.addMergedRegion(brodercel20);
        Cell title_cel20 = titleRow2.createCell(7);
        title_cel20.setCellStyle(titleCellStyle);
        title_cel20.setCellValue("联系电话");
        setBorderForMergeCell(1, brodercel20, sheet, wb);

        CellRangeAddress brodercel21 = new CellRangeAddress(2, 2, 5, 5);
        sheet.addMergedRegion(brodercel21);
        Cell title_cel21 = titleRow2.createCell(8);
        title_cel21.setCellStyle(titleCellStyle);
        title_cel21.setCellValue("运营商");
        setBorderForMergeCell(1, brodercel21, sheet, wb);

        CellRangeAddress brodercel22 = new CellRangeAddress(2, 2, 6, 6);
        sheet.addMergedRegion(brodercel22);
        Cell title_cel22 = titleRow2.createCell(9);
        title_cel22.setCellStyle(titleCellStyle);
        title_cel22.setCellValue("资费");
        setBorderForMergeCell(1, brodercel22, sheet, wb);

        CellRangeAddress brodercel23 = new CellRangeAddress(2, 2, 7, 7);
        sheet.addMergedRegion(brodercel23);
        Cell title_cel23 = titleRow2.createCell(10);
        title_cel23.setCellStyle(titleCellStyle);
        title_cel23.setCellValue("到期时间");
        setBorderForMergeCell(1, brodercel23, sheet, wb);

        CellRangeAddress brodercel24 = new CellRangeAddress(1, 2, 11, 11);
        sheet.addMergedRegion(brodercel24);
        Cell title_cel24 = titleRow1.createCell(11);
        title_cel24.setCellStyle(titleCellStyle);
        title_cel24.setCellValue("备注");
        setBorderForMergeCell(1, brodercel24, sheet, wb);

        //字段名称
        Map<String, String> headMap = resident_Cell();

        //EXCEL 写入
        makeExcelByNotHead(sheet, titleCellStyle, headMap, dataList);
    }

    private Map<String, String> resident_Cell() {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        headMap.put("STAND_NAME_1", "楼宇名称");
        headMap.put("SEGM_NAME_2", "房间号");
        //headMap.put("IS_DX_USER", "是否\r\n电信用户");
        headMap.put("DX_CONTACT_PERSON", "客户名称");
        headMap.put("ACC_NBR", "宽带接入号");
        headMap.put("DX_CONTACT_NBR", "联系电话");

        headMap.put("CONTACT_PERSON", "联系人");
        headMap.put("CONTACT_NBR", "联系电话");
        headMap.put("KD_BUSINESS", "运营商");
        headMap.put("KD_XF", "资费");
        headMap.put("KD_DQ_DATE", "到期时间");
        headMap.put("COMMENTS", "备注");

        return headMap;
    }

    /**
     * 流失用户清单
     * @param excelName
     * @param request
     * @param response
     */
    @Action("lostResident_ExcelDownload")
    public void lostResident_EXCELDOWNLOAD(String excelName, HttpServletRequest request, HttpServletResponse response){
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【宽带存量保有率】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            String query_flag = request.getParameter("query_flag");

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.lost_resident_makeSql(request);

            //System.out.println("excuteSql:"+excuteSql);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            out = response.getOutputStream();
            String title = "流失用户清单.xlsx";
            response.setContentType("application/vnd.ms-excel;charset=GBK");
            response.setCharacterEncoding("GBK");
            response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
            XSSFWorkbook wb = new XSSFWorkbook();

            //数据excel做成
            lost_resident_Excel(dataList,wb);

            wb.write(out);
            //System.out.println("-------------------------------【宽带存量保有率】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void lost_resident_Excel(List<Map> dataList,XSSFWorkbook wb){
        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "流失用户清单");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = new CellRangeAddress(0, 0, 0, 7);
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("流失用户清单");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = lost_resident_Cell();

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    private Map<String, String> lost_resident_Cell() {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        headMap.put("STAND_NAME", "楼宇名称");
        headMap.put("USER_CONTACT_PERSON", "用户名称");
        headMap.put("ACC_NBR", "宽带接入号");
        headMap.put("REMOVE_DATE", "拆停日期");
        headMap.put("OWE_DUR", "拆停时长");
        headMap.put("SCENE_TEXT", "状态");
        headMap.put("COMMENTS", "备注");

        return headMap;
    }

    @Action("villageInCityByDay_ExcelDownload")
    public void villageInCityByDay_ExcelDownload(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【宽带家庭渗透率】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.vicByDay_makeSql(request);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            String file = request.getParameter("file");
            String region = "";
            if("1".equals(file)){
                out = response.getOutputStream();

                String title = "城中村攻坚活动日报"  +"_"+request.getParameter("beginDate")+".xlsx";
                response.setContentType("application/vnd.ms-excel;charset=GBK");
                response.setCharacterEncoding("GBK");

                response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
                XSSFWorkbook wb = new XSSFWorkbook();

                vic_Excel(dataList, wb);

                out.flush();
                wb.write(out);
            }else{
            }
            //System.out.println("-------------------------------【宽带家庭渗透率】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    private void vic_Excel(List<Map> dataList,XSSFWorkbook wb){
        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "城中村攻坚活动日报");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = new CellRangeAddress(0, 0, 0, 12);
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("城中村攻坚活动日报");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = vic_Cell();

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    private Map<String, String> vic_Cell() {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        headMap.put("LATN_NAME", "分公司");
        headMap.put("BUREAU_NAME", "县区");
        headMap.put("BRANCH_NAME", "支局");
        headMap.put("GRID_NAME", "网格");
        headMap.put("VILLAGE_NAME", "锁定小区名称");
        headMap.put("FILTER_RATE_Y", "锁定小区原渗透率");
        headMap.put("FILTER_RATE_DAY", "渗透率提升");
        headMap.put("ADD_KD_CNT", "新增宽带数");
        headMap.put("FILTER_RATE", "累计到达渗透率");
        headMap.put("FILTER_RATE_M", "渗透率提升");
        headMap.put("LJ_ADD_KD_CNT", "累计新增宽带数");
        headMap.put("JZ_CNT", "竞争性资费占比");

        return headMap;
    }

    @Action("villageGrabByDay_ExcelDownload")
    public void villageGrabByDay_ExcelDownload(String excelName, HttpServletRequest request, HttpServletResponse response) {
        ServletOutputStream out = null;
        try {
            //System.out.println("-------------------------------【白区反抢日报】生成开始------------------------");
            Map<String, String> parameter = new HashMap<String, String>();

            //导出的sql集合
            YXSPExcelSql yxspExcelSql = new YXSPExcelSql();

            //获取sql
            String excuteSql = yxspExcelSql.villageGrabByDay_makeSql(request);

            //获取数据(全部数据)
            List<Map> dataList = new ArrayList<Map>();
            try {
                dataList = (List<Map>) runner.queryForMapList(excuteSql);
            } catch (SQLException e) {
                System.out.println("excel downLoad SQLException ");
                e.printStackTrace();
            }

            String file = request.getParameter("file");
            String region = "";
            if("1".equals(file)){
                out = response.getOutputStream();

                String title = "白区反抢日报"  +"_"+request.getParameter("beginDate")+".xlsx";
                response.setContentType("application/vnd.ms-excel;charset=GBK");
                response.setCharacterEncoding("GBK");

                response.setHeader("Content-Disposition", "attachment;filename=\"" + response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
                XSSFWorkbook wb = new XSSFWorkbook();

                villageGrab_Excel(dataList, wb);

                out.flush();
                wb.write(out);
            }else{
            }
            //System.out.println("-------------------------------【白区反抢日报】生成结束------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    private void villageGrab_Excel(List<Map> dataList,XSSFWorkbook wb){
        // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "白区反抢日报");

        //标题的style
        XSSFCellStyle titleCellStyle = getXSSFCellStyle("title",wb);

        //内容cell的style
        XSSFCellStyle cellStyle = getXSSFCellStyle("cell",wb);

        //标题设置
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));
        CellRangeAddress brodercell = new CellRangeAddress(0, 0, 0, 12);
        sheet.addMergedRegion(brodercell);
        Cell title_cell = titleRow.createCell(0);
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("白区反抢日报");
        setBorderForMergeCell(1, brodercell, sheet, wb);
        //字段名称
        Map<String, String> headMap = villageGrab_Cell();

        //EXCEL 写入
        makeExcel(sheet, titleCellStyle, cellStyle, headMap, dataList);
    }

    private Map<String, String> villageGrab_Cell() {

        Map<String, String> headMap = new LinkedHashMap<String, String>();
        headMap.put("NO", "序号");
        headMap.put("LATN_NAME", "分公司");
        headMap.put("BUREAU_NAME", "县区");
        headMap.put("BRANCH_NAME", "支局");
        headMap.put("GRID_NAME", "网格");
        headMap.put("VILLAGE_NAME", "锁定小区名称");
        headMap.put("FILTER_RATE_Y", "锁定小区原渗透率");
        headMap.put("FILTER_RATE_DAY", "渗透率提升");
        headMap.put("ADD_KD_CNT", "新增宽带数");
        headMap.put("FILTER_RATE", "累计到达渗透率");
        headMap.put("FILTER_RATE_M", "渗透率提升");
        headMap.put("LJ_ADD_KD_CNT", "累计新增宽带数");
        headMap.put("JZ_CNT", "竞争性资费占比");

        return headMap;
    }
}
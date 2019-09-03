package cn.com.gis.utils;
import java.io.InputStream;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * Excel文件处理工具类: 包括填充数据到普通excel、模板excel文件,单元格格式处理
 *
 */
public class ExcelUtil {


    /**
     * 异网收集 第二步
     * 填充数据到模板excel文件
     * @param sqlDate
     * @param templateFileName
     * @return
     * @throws Exception
     */
    public static Workbook fillExcelDataWithTemplate(List<Map<String,Object>> sqlDate, String templateFileName)throws Exception{
        //首先:从本地磁盘读取模板excel文件,然后读取第一个sheet
        InputStream inp=ExcelUtil.class.getResourceAsStream("/cn/com/gis/templatedoc/"+templateFileName);
        Workbook wb=new XSSFWorkbook(inp);

        Sheet sheet=wb.getSheetAt(0);

        //开始写入数据到模板中:因为行头以及设置好,故而需要跳过行头
        // int cellNums=sheet.getRow(0).getLastCellNum();
        int rowIndex=1;

        for(int a=0,l=sqlDate.size();a<l;a++){
            Row row=sheet.createRow(rowIndex++);

            CellStyle style1=wb.createCellStyle();
            // 设置为文本格式，防止数字变成科学计数法
            DataFormat format = wb.createDataFormat();
            style1.setDataFormat(format.getFormat("@"));

            Cell cell0=row.createCell(0);
            Cell cell1=row.createCell(1);
            cell0.setCellStyle(style1);
            cell1.setCellStyle(style1);

            String str0=(String)sqlDate.get(a).get("segm_id_2");
            String str1=(String)sqlDate.get(a).get("stand_name_2");

            cell0.setCellValue(str0);
            cell1.setCellValue(str1);
        }

        return wb;
    }

    /**
     * 读取模板文件，返回
     */
    public static Workbook getExcelTemplate(String templateFileName) throws Exception{
        InputStream inp=ExcelUtil.class.getResourceAsStream("/cn/com/gis/templatedoc/"+templateFileName);
        Workbook wb=new XSSFWorkbook(inp);
        return wb;
    }

    /**
     * 填充数据到普通的excel文件中
     * @param rs
     * @param wb
     * @param headers
     * @throws Exception
     */
    public static void fillExcelData(ResultSet rs,Workbook wb,String[] headers)throws Exception{
        Sheet sheet=wb.createSheet();
        Row row=sheet.createRow(0);

        //先填充行头 : "编号","姓名","电话","Email","QQ","出生日期"
        for(int i=0;i<headers.length;i++){
            row.createCell(i).setCellValue(headers[i]);
        }

        //再填充数据
        int rowIndex=1;
        while(rs.next()){
            row=sheet.createRow(rowIndex++);
            for(int i=0;i<headers.length;i++){
                Object objVal=rs.getObject(i+1);
                if (objVal instanceof Date) {
                    row.createCell(i).setCellValue(DateUtil.formatDate((Date)objVal,"yyyy-MM-dd"));
                }else{
                    row.createCell(i).setCellValue(objVal.toString());
                }
            }
        }
    }





    /**
     * 处理单元格格式的简单方式
     * @param xssfCell
     * @return
     */
    public static String formatCell(XSSFCell xssfCell){
        if(xssfCell==null){
            return "";
        }else{
            if(xssfCell.getCellType()==XSSFCell.CELL_TYPE_BOOLEAN){
                return String.valueOf(xssfCell.getBooleanCellValue());
            }else if(xssfCell.getCellType()==XSSFCell.CELL_TYPE_NUMERIC){
                return String.valueOf(xssfCell.getNumericCellValue());
            }else{
                return String.valueOf(xssfCell.getStringCellValue());
            }
        }
    }

    /**
     * 处理单元格格式的第二种方式: 包括如何对单元格内容是日期的处理
     * @param cell
     * @return
     */
    public static String formatCell2(XSSFCell cell) {
        if (cell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {
            return String.valueOf(cell.getBooleanCellValue());
        } else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {

            //针对单元格式为日期格式
            if (HSSFDateUtil.isCellDateFormatted(cell)) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                return sdf.format(HSSFDateUtil.getJavaDate(cell.getNumericCellValue())).toString();
            }
            return String.valueOf(cell.getNumericCellValue());
        } else {
            return cell.getStringCellValue();
        }
    }

    /**
     * 处理单元格格式的第三种方法:比较全面
     * @param cell
     * @return
     */
    public static String formatCell3(XSSFCell cell) {
        if (cell == null) {
            return "";
        }
        switch (cell.getCellType()) {
            case XSSFCell.CELL_TYPE_NUMERIC:

                //日期格式的处理
                if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    return sdf.format(org.apache.poi.ss.usermodel.DateUtil.getJavaDate(cell.getNumericCellValue())).toString();
                }
                DecimalFormat df = new DecimalFormat("0");
                return String.valueOf(df.format(cell.getNumericCellValue()));

            //字符串
            case XSSFCell.CELL_TYPE_STRING:
                return cell.getStringCellValue();

            // 公式
            case XSSFCell.CELL_TYPE_FORMULA:
                return cell.getCellFormula();

            // 空白
            case XSSFCell.CELL_TYPE_BLANK:
                return "";

            // 布尔取值
            case XSSFCell.CELL_TYPE_BOOLEAN:
                return cell.getBooleanCellValue() + "";

            //错误类型
            case XSSFCell.CELL_TYPE_ERROR:
                return cell.getErrorCellValue() + "";
        }

        return "";
    }
}
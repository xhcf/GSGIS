package cn.com.easy.down.server.export;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.beans.factory.annotation.Autowired;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.util.SqlUtils;
import jxl.Workbook;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

public class ExcelTableBigDataBySQL extends ExcelPdf implements Strategy{
	protected int num = 0;
	protected int r = 0;
	protected int i = 0;
	protected String columns = null;
	protected List<String> elsList = new ArrayList<String>();;//>>导出的文件列表，多于1个时，需要压缩，再导出
	protected List<String> fieldList = null;
	protected List merged = null;
	protected org.apache.poi.ss.usermodel.Workbook xwb = null;
	protected Sheet xsheet = null;
	protected List data=null;
	protected ArgsBean args = null;
	@Override
	public String export(ArgsBean _args) throws Exception {
		try{
			columns = _args.getColumns() != null?_args.getColumns().replaceAll("<.*?>", ""):"";
			this.args = _args;
			if(!this.queryData()){
				return null;
			}
			if(!this.headXls()){
				return null;
			}
			if(!this.headXlsx()){
				return null;
			}
			return this.write();
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}finally{
			this.destroy();
		}
	}
	//查询数据
	protected boolean queryData() throws Exception {
		try {
			SqlRunner runner = args.getRunner();
			HttpServletRequest request = EasyContext.getContext().getRequest();
			String sql = SqlUtils.characterConversion(this.args.getDownSql());
			if(null != this.args.getDownDb() && !this.args.getDownDb().equals("")){
				data = runner.queryForMapList(this.args.getDownDb(),sql,args.getParameters());
					
			}else{
				data = runner.queryForMapList(sql,args.getParameters());
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	//写xls表头
	protected boolean headXls() throws Exception {
		WritableWorkbook wbook = Workbook.createWorkbook(new File(args.getDownPath()+args.getUuid()+"_"+"0.xls"));
		row = columns.split("&").length - 1;
		WritableSheet wsheet = wbook.createSheet("sheet", 0);
		List nameList = arr2Title(columns, "0"); // 生成excel表头
		
		fieldList = (List<String>)nameList.get(2);
		fieldList.remove(fieldList.size()-1);
		merged = (List) nameList.get(1);
		
		super.writeHeadToExcel((List) nameList.get(0),merged,wsheet);
		wbook.write();
		wbook.close();
		return true;
	}
	//写xlsx表头
	protected boolean headXlsx() throws Exception {
		xwb = new SXSSFWorkbook(1000);
		xsheet = xwb.createSheet("sheet");
		CellStyle cs = xwb.createCellStyle();
		cs.setFillForegroundColor(IndexedColors.LIGHT_TURQUOISE.getIndex());
		cs.setFillPattern(CellStyle.SOLID_FOREGROUND);
		
		File excelFileTitle = new File(args.getDownPath()+args.getUuid()+"_"+"0.xls");
		FileInputStream fis = new FileInputStream(excelFileTitle);
		org.apache.poi.ss.usermodel.Workbook hwb = new HSSFWorkbook(fis);
		Sheet sheet = hwb.getSheetAt(0);
		int rline=0;
		for (Row row : sheet) {
			Row xrow = xsheet.createRow(rline);
			int c=0;
			for (Cell cell : row) {
				Cell xcell = xrow.createCell(c);
				cell.setCellType(Cell.CELL_TYPE_STRING);
				xcell.setCellValue(cell.getStringCellValue());
				xcell.setCellStyle(cs);
				c++;
			}
			rline++;
		}
		hwb = null;
		fis.close();
		
		for (int m = 0; m < merged.size(); m++) {
			String exceStr = (String) merged.get(m);
			if (exceStr.indexOf("&") > 0) { // 合并单元格的标题
				int cols = Integer.parseInt(exceStr.split("&")[0].split(",")[1]);
				int rows = Integer.parseInt(exceStr.split("&")[0].split(",")[0]);
				int endCols = Integer.parseInt(exceStr.split("&")[1].split(",")[1]);
				xsheet.addMergedRegion(new CellRangeAddress(rows,Integer.parseInt(exceStr.split("&")[1].split(",")[0]),cols,endCols));
			}
		}
		return true;
	}
	//写xlsx数据
	protected String write() throws Exception {
		//字段先排序
		Map<Integer,String> fieldTree = new TreeMap<Integer,String>();
		for (int x = 0; x < fieldList.size(); x++) {
			String[] kv = ((String) fieldList.get(x)).split("&");
			fieldTree.put(Integer.parseInt(kv[1]),kv[0]);
		}
		int num = xsheet.getPhysicalNumberOfRows();
		
		try {
			//while (rs.next()) {
			for(int a=0;a<data.size();a++){
				Map tempDataMap=null;
				if(data.get(a)==null){
					continue;
				}
				tempDataMap=(Map) data.get(a);
				Row row = xsheet.createRow(num+this.r);
				for (int x :fieldTree.keySet()) {
					Cell cell = row.createCell(x);
					Object keyValue = null;
					try{
						keyValue = tempDataMap.get(fieldTree.get(x));
					}catch(Exception e){
						//前台有格式化的列，这个会取不到
					}
					if(null == keyValue || "".equals(keyValue)){
						cell.setCellValue("");
						cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					}else if(keyValue instanceof String){
						cell.setCellValue(String.valueOf(keyValue));
						cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					}else{
						cell.setCellValue(Double.parseDouble(String.valueOf(keyValue)));
						cell.setCellType(XSSFCell.CELL_TYPE_NUMERIC);
					}
				}
				this.i++;
				this.r++;
				if(this.i>=1000000){
					if(!this.newFile(true)){
						return null;
					}
				}
			}
			if(!this.newFile(false)){
				return null;
			}
			return this.returnFile();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	//生成文件
	protected boolean newFile(boolean flag) throws Exception{
		if(this.i>0){
			File excelFile = new File(args.getDownPath()+args.getUuid()+"_"+this.num+".xlsx");
			FileOutputStream fos = new FileOutputStream(excelFile);
			xwb.write(fos);
			xwb = null;
			xsheet = null;
			this.elsList.add(args.getDownPath()+args.getUuid()+"_"+this.num+".xlsx");
			fos.close();
			this.num++;
			this.i = 0;
			this.r = 0;
			if(flag){
				this.headXlsx();
			}
			return true;
		}
		return false;
	}
	//返回文件地址
	protected String returnFile() throws Exception{
		String file = null;
		if(elsList.size()>1){
			file = args.getDownPath()+args.getUuid()+".zip";
            super.zip(file,elsList);
		}else if(elsList.size()==1){
			file = args.getDownPath()+args.getUuid()+".xlsx";
			File downFile=new File(elsList.get(0));
			downFile.renameTo(new File(file));
		}else{
			System.err.println("在导出 "+args.getFileName()+" 文件时出错，请联系管理员");
			return null;
		}
		return file;
	}
	//释放资源
	protected void destroy(){
		if(null != xwb){
			xwb = null;
		}
	}
	private String isNull(Object v){
		if(null == v){
			return "";
		}
		String namev = String.valueOf(v);
		if(null == namev || "null".equalsIgnoreCase(namev.trim()) || namev.trim().length()<=0){
			return "";
		}
		return namev.trim();
	}
}
package cn.com.easy.down.client.action;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Writer;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.DownLoad;
import cn.com.easy.taglib.function.Functions;
/**
 * Created by huiyf on 2018/6/5.
 * purpose：excel文件操作
 */
@Controller
public class ExcelAction {
    private SqlRunner runner;
    private ServletOutputStream out;
    private XSSFWorkbook wb;

    /**
     * sql拼接
     * @param request
     * @return
     */
    private String makeSql(HttpServletRequest request) {
    	/*
    	System.out.println("beginDate===="+request.getParameter("beginDate"));
    	System.out.println("flag========="+request.getParameter("flag"));
    	System.out.println("page========="+request.getParameter("page"));
    	System.out.println("region_id===="+request.getParameter("region_id"));
    	System.out.println("query_sort==="+request.getParameter("query_sort"));
    	System.out.println("query_flag==="+request.getParameter("query_flag"));
    	System.out.println("city_id======"+request.getParameter("city_id"));
    	System.out.println("pageSize====="+request.getParameter("pageSize"));
    	*/
    	//账期
		String acct_day = request.getParameter("beginDate");
		//账期
		String flag = request.getParameter("flag");
		//页号
		String page = request.getParameter("page");
		//区县编码
		String region_id = request.getParameter("region_id");
		//查询排序
		String query_sort = request.getParameter("query_sort");
		
		//市,县,支局,网格, 小区
		String query_flag = request.getParameter("query_flag");
		
		//城市编码
		String city_id = request.getParameter("city_id");
		
		//每页数据量
		String pageSize = request.getParameter("pageSize");
		

    	StringBuffer sqlBuffer = new  StringBuffer();
    	
    	//市,县,支局,网格, 小区
    	boolean is_village = false;
    	//==5 是小区
    	if("5".equals(query_flag)) {
    		is_village = true;
    	}

	    if(is_village) {
	    		//--------------------------小区sql--------开始-----------------------------------------
	    		sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
	    		sqlBuffer.append(" SELECT");
	    		sqlBuffer.append(" ' '  AREA_DESC,");
	             if("".equals(region_id) || null ==region_id) {
	            	 sqlBuffer.append(" '全省' AREA_DESC1,");
	             }else {
	            	 if("1".equals(flag)) {
	            		 sqlBuffer.append(" '全省' AREA_DESC1,");
	            	 }else if("2".equals(flag)) {
	            		 sqlBuffer.append(" '全市' AREA_DESC1,");
	            	 }else if("3".equals(flag)) {
	            		 sqlBuffer.append(" '全县' AREA_DESC1,");
	            	 }else if("4".equals(flag)) {
	            		 sqlBuffer.append(" '全支局' AREA_DESC1,");
	            	 }else if("5".equals(flag)) {
	            		 sqlBuffer.append(" '全网格' AREA_DESC1,");
	            	 }
	             }

	             sqlBuffer.append(" '0' ORD,");
	             sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,");
	             sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,");
	             sqlBuffer.append(" DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,");
	             sqlBuffer.append(" DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,");
	             sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,");
	             sqlBuffer.append(" NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,");
	             sqlBuffer.append(" nvl(A.gov_zhu_hu_count,0) gov_zhu_hu_count,");
	             sqlBuffer.append(" nvl(A.gov_h_use_cnt,0) gov_h_use_cnt,");
	             sqlBuffer.append(" 0 C_NUM");
	             sqlBuffer.append(" FROM GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
	             if("".equals(region_id) || null == region_id) {
	                   sqlBuffer.append(" WHERE A.FLG = '0'");
	             }else {
	            	 if("2".equals(flag)) {
	            		 sqlBuffer.append(" WHERE A.LATN_ID = '"+region_id+"'");
	            	 }else if("3".equals(flag)) {
	            		 sqlBuffer.append(" WHERE A.LATN_ID IN (");
	            		 sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
	            		 sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
	            		 sqlBuffer.append(" and latn_id = '"+city_id+"'");
	            		 sqlBuffer.append(" )");
	            	 }
	             }
	            
	             sqlBuffer.append(" AND BRANCH_TYPE = 'a1'");
	             sqlBuffer.append(" AND A.ACCT_DAY = '"+acct_day+"'");
	             sqlBuffer.append(" UNION ALL");
	             sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM FROM (");
	             sqlBuffer.append(" SELECT");
	             sqlBuffer.append(" DISTINCT");
	             if("1".equals(query_flag)) {
	            	 sqlBuffer.append(" B.AREA_DESC,");
	            	 sqlBuffer.append(" B.ORD,");
	             }else if("2".equals(query_flag)) {
	            	 sqlBuffer.append(" B.BUREAU_NAME AREA_DESC,");
	            	 sqlBuffer.append(" B.BUREAU_NO ORD,");
	             }else if("3".equals(query_flag)) {
	            	 sqlBuffer.append(" B.BRANCH_NAME AREA_DESC,");
	            	 sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
	             }else if("4".equals(query_flag)) {
	            	 sqlBuffer.append(" B.GRID_NAME AREA_DESC,");
	            	 sqlBuffer.append(" B.GRID_ID ORD,");
	             }else if("5".equals(query_flag)) {
	            	 sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC,");
	            	 sqlBuffer.append(" dd.latn_name AREA_DESC1,");
	            	 sqlBuffer.append(" B.VILLAGE_ID ORD,");
	             }
	   
	             sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,");
	             sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,");
	             sqlBuffer.append(" DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,");
	             sqlBuffer.append(" DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,");
	             sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,");
	             sqlBuffer.append(" NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,");
	             sqlBuffer.append(" nvl(A.gov_zhu_hu_count,0) gov_zhu_hu_count,");
	             sqlBuffer.append(" nvl(A.gov_h_use_cnt,0) gov_h_use_cnt");
	             sqlBuffer.append(" FROM GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
	             
	             if("".equals(region_id) || null == region_id) {
	            	 if("1".equals(query_flag)) {
	            		 sqlBuffer.append(" right OUTER JOIN EASY_DATA.CMCODE_AREA B");
	            		 sqlBuffer.append(" ON A.LATN_ID = B.AREA_NO");
	            	 }else if("2".equals(query_flag)) {
	            		 sqlBuffer.append(" right OUTER JOIN (select * from GIS_DATA.DB_CDE_GRID WHERE BRANCH_TYPE = 'a1') B");
	            		 sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
	            	 }else if("3".equals(query_flag)) {
	            		 sqlBuffer.append(" right OUTER JOIN (SELECT * FROM GIS_DATA.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and BRANCH_TYPE = 'a1') B");
	            		 sqlBuffer.append(" ON (A.LATN_ID = B.UNION_ORG_CODE)");
	            	 }else if("4".equals(query_flag)) {
	            		 sqlBuffer.append(" RIGHT OUTER JOIN (SELECT * FROM GIS_DATA.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and GRID_UNION_ORG_CODE != -1 and grid_status = 1 and BRANCH_TYPE = 'a1') B");
	            		 sqlBuffer.append(" ON (A.LATN_ID = B.GRID_ID)");
	            	 }else if("5".equals(query_flag)) {
	            		 sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
	            		 sqlBuffer.append(" ON (A.LATN_ID = B.VILLAGE_ID)");
	            		 sqlBuffer.append(" right JOIN gis_data.view_db_cde_village dd");
	            		 sqlBuffer.append("  ON(b.village_id = dd.village_id)");
	            	 }
	                
	            	 sqlBuffer.append(" WHERE");
	            	 sqlBuffer.append(" A.FLG = '"+query_flag+"'");
	            	 sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	            	 sqlBuffer.append(" AND A.ACCT_DAY = '"+acct_day+"'");
	             }else {
	            	 if("2".equals(flag)) {
	            		 if("2".equals(query_flag)) {
	            			 sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
	            			 sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
	            			 sqlBuffer.append(" WHERE B.LATN_ID = '"+region_id+"'");
	            			 sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
	            			 sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	            		 }else if("3".equals(query_flag)) {
	            			 sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
	            			 sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
	            			 sqlBuffer.append(" WHERE B.LATN_ID = '"+region_id+"'");
	            			 sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
	            			 sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
	            			 sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	            		 }else if("4".equals(query_flag)) {
	            			 sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
	            			 sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
	            			 sqlBuffer.append(" WHERE B.LATN_ID = '"+region_id+"'");
	            		     sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
	            		     sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
	            		     sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
	            		     sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	            		 }else if("5".equals(query_flag)) {
	            			 sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
	            			 sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
	            			 sqlBuffer.append(" LEFT JOIN gis_data.view_db_cde_village dd");
	            			 sqlBuffer.append(" ON (b.village_id = dd.village_id)");
	            			 sqlBuffer.append(" WHERE A.LATN_ID IN (");
	            			 sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
	            			 sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
	            			 sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
	            			 sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
	            			 sqlBuffer.append(" )");
	            			 sqlBuffer.append(" WHERE C.LATN_ID = '"+region_id+"'");
	            			 sqlBuffer.append(" )");
	            			 sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1' ");
	            		 }
	            	 }else if("3".equals(flag)) {
		            		 if("3".equals(query_flag)) {
		            			 sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
		            			 sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
		            			 sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
		            			 sqlBuffer.append(" SELECT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
		            			 sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
		            			 sqlBuffer.append(" and latn_id = '"+city_id+"'");
		            			 sqlBuffer.append(" )");
		            			 sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
		            			 sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
		            			 sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
		            		 }else if("4".equals(query_flag)) {
		            			 sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
		            			 sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
		            			 sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
		            			 sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
		            			 sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
		            			 sqlBuffer.append(" and latn_id = '"+city_id+"'");
		            			 sqlBuffer.append(" )");
		            			 sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
		            			 sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
		            			 sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
		            			 sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
		            		 }else if("5".equals(query_flag)) {
		            			 sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
		            			 sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
		            			 sqlBuffer.append(" RIGHT OUTER JOIN gis_data.view_db_cde_village dd");
		            			 sqlBuffer.append(" ON a.latn_id = dd.village_id");
		            			 sqlBuffer.append(" WHERE a.LATN_ID IN (");
		            			 sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
		            			 sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
		            			 sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
		            			 sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
		            			 sqlBuffer.append(" )");
		            			 sqlBuffer.append(" WHERE C.BUREAU_NO IN (");
		            			 sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
		            			 sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
		            			 sqlBuffer.append(" and latn_id = '"+city_id+"'");
		            			 sqlBuffer.append(" )");
		            			 sqlBuffer.append(" )");
		            			 sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
		            		 }
	            	 }
	             }
	             
	            if(!"1".equals(query_flag)) {
	            	 if("0".equals(query_sort)) {
	            		 sqlBuffer.append(" ORDER BY BROAD_PENETRANCE_SORT DESC");
	  	            }else if("1".equals(query_sort)) {
	  	            	sqlBuffer.append(" ORDER BY BROAD_PENETRANCE_SORT ASC");
	  	            }
	            }
	            sqlBuffer.append(" ) T");
	            if("1".equals(query_flag)) {
	            	sqlBuffer.append(" ORDER BY ORD");
	            }
	            
	            sqlBuffer.append(" ) T");
	            //--------------------------小区sql--------终了-----------------------------------------
	    	}else {
	    		sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
	    		sqlBuffer.append("            SELECT");
	    				if("".equals(region_id) || null ==region_id) {
	    					sqlBuffer.append("  '全省' AREA_DESC,");
	    				}else {
	    					if("1".equals(flag)) {
		    					sqlBuffer.append("  '全省' AREA_DESC,");
		    				}else if("2".equals(flag)){
		    					sqlBuffer.append("   '全市' AREA_DESC,");
		    				}else if("3".equals(flag)){
		    					sqlBuffer.append("   '全县' AREA_DESC,");
		    				}else if("4".equals(flag)){
		    					sqlBuffer.append("   '全支局' AREA_DESC,");
		    				}else if("5".equals(flag)){
		    					sqlBuffer.append("   '全网格' AREA_DESC,");
		    				}
	    				}
	    		           
	    				sqlBuffer.append(" '0' ORD,");
	    				sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,");
	    				sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,");
	    				sqlBuffer.append(" DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,");
	    				sqlBuffer.append(" DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,");
	    				sqlBuffer.append(" NVL(A.VILLAGE_CNT, 0) VILLAGE_CNT,");
	    				sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,");
	    				sqlBuffer.append(" NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,");
	    				sqlBuffer.append(" NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) HIGH_FILTER_VILLAGE_CNT,");
	    				sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') HIGH_FILTER_RATE,");
	    				sqlBuffer.append(" NVL(A.MID_FILTER_VILLAGE_CNT, 0) MID_FILTER_VILLAGE_CNT,");
	    				sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.MID_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') MID_FILTER_RATE,");
	    				sqlBuffer.append(" NVL(A.LOW_FILTER_VILLAGE_CNT, 0) LOW_FILTER_VILLAGE_CNT,");
	    				sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_FILTER_RATE,");
	    				sqlBuffer.append(" NVL(A.LOW_10_FILTER_VILLAGE_CNT, 0) LOW_10_FILTER_VILLAGE_CNT,");
	    				sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_10_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_10_FILTER_RATE,");
	    				sqlBuffer.append(" 0 C_NUM");
	    				sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
	    		           
    		            if("".equals(region_id) || null ==region_id) {
    		            	sqlBuffer.append(" WHERE A.FLG = '0'");
    		            }else {
    		                	if("2".equals(flag)) {
    		                		sqlBuffer.append(" WHERE A.LATN_ID = '"+region_id+"'");
    		                	}else if("3".equals(flag)) {
    		                		sqlBuffer.append(" WHERE A.LATN_ID IN (");
    		                		sqlBuffer.append("  SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
    		                		sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
    		                		sqlBuffer.append(" and latn_id = '"+city_id+"'");
    		                		sqlBuffer.append(" )");
    		                	}
    		            }

    		            sqlBuffer.append(" AND BRANCH_TYPE = 'a1'");
    		            sqlBuffer.append(" AND A.ACCT_DAY = '"+acct_day+"'");
    		            sqlBuffer.append(" UNION ALL");
    		            sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM FROM (");
    		            sqlBuffer.append(" SELECT");
    		            sqlBuffer.append(" DISTINCT");
    		            if("1".equals(query_flag)) {
    		            	sqlBuffer.append(" B.AREA_DESC,");
    		            	sqlBuffer.append(" B.ORD,");
    		            }else if("2".equals(query_flag)) {
    		            	sqlBuffer.append(" B.BUREAU_NAME AREA_DESC,");
    		            	sqlBuffer.append(" B.BUREAU_NO ORD,");
    		            }else if("3".equals(query_flag)) {
    		            	sqlBuffer.append(" B.BRANCH_NAME AREA_DESC,");
    		            	sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
    		            }else if("4".equals(query_flag)) {
    		            	sqlBuffer.append(" B.GRID_NAME AREA_DESC,");
    		            	sqlBuffer.append(" B.GRID_ID ORD,");
    		            }else if("5".equals(query_flag)) {
    		            	sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC,");
    		            	sqlBuffer.append(" B.VILLAGE_ID ORD,");
    		            }
    		            
    		            sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100, 'FM999999990.00') || '%') BROAD_PENETRANCE,");
    		            sqlBuffer.append(" DECODE(NVL(A.GZ_ZHU_HU_COUNT, 0), 0, 0, ROUND(NVL(A.GZ_H_USE_CNT, 0) / A.GZ_ZHU_HU_COUNT, 4) * 100) BROAD_PENETRANCE_SORT,");
    		            sqlBuffer.append(" DECODE(NVL(A.FILTER_MON_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_MON_RATE, 4) * 100, 'FM999999990.00') || '%')  FILTER_MON_RATE,");
    		            sqlBuffer.append(" DECODE(NVL(A.FILTER_YEAR_RATE, '0'), '0', '0.00%', TO_CHAR(ROUND(A.FILTER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') FILTER_YEAR_RATE,");
    		            sqlBuffer.append(" NVL(A.VILLAGE_CNT,  0) VILLAGE_CNT,");
    		            sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,");
    		            sqlBuffer.append(" NVL(A.GZ_H_USE_CNT, 0) GZ_H_USE_CNT,");
    		            sqlBuffer.append(" NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) HIGH_FILTER_VILLAGE_CNT,");
    		            sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.HIGH_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') HIGH_FILTER_RATE,");
    		            sqlBuffer.append(" NVL(A.MID_FILTER_VILLAGE_CNT, 0) MID_FILTER_VILLAGE_CNT,");
    		            sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.MID_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') MID_FILTER_RATE,");
    		            sqlBuffer.append(" NVL(A.LOW_FILTER_VILLAGE_CNT, '0') LOW_FILTER_VILLAGE_CNT,");
    		            sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_FILTER_RATE,");
    		            sqlBuffer.append(" NVL(A.LOW_10_FILTER_VILLAGE_CNT, '0') LOW_10_FILTER_VILLAGE_CNT,");
    		            sqlBuffer.append(" DECODE(NVL(A.VILLAGE_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_10_FILTER_VILLAGE_CNT, 0) / A.VILLAGE_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_10_FILTER_RATE");
    		            sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
    		            
    		            if("".equals(region_id) || null ==region_id) {
    		            	if("1".equals(query_flag)) {
    		            		sqlBuffer.append(" right OUTER JOIN EASY_DATA.CMCODE_AREA B");
    		            		sqlBuffer.append(" ON A.LATN_ID = B.AREA_NO");
    		            	}else if("2".equals(query_flag)) {
    		            		sqlBuffer.append(" right OUTER JOIN (select * from GIS_DATA.DB_CDE_GRID WHERE BRANCH_TYPE = 'a1') B");
    		            		sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
    		            	}else if("3".equals(query_flag)) {
    		            		sqlBuffer.append(" right OUTER JOIN (SELECT * FROM GIS_DATA.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and BRANCH_TYPE = 'a1') B");
    		            		sqlBuffer.append(" ON (A.LATN_ID = B.UNION_ORG_CODE)");
    		            	}else if("4".equals(query_flag)) {
    		            		sqlBuffer.append(" RIGHT OUTER JOIN (SELECT * FROM GIS_DATA.DB_CDE_GRID WHERE GRID_UNION_ORG_CODE IS NOT NULL and GRID_UNION_ORG_CODE != -1 and grid_status = 1 and BRANCH_TYPE = 'a1') B");
    		            		sqlBuffer.append(" ON (A.LATN_ID = B.GRID_ID)");
    		            	}else if("5".equals(query_flag)) {
    		            		sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
    		            		sqlBuffer.append(" ON (A.LATN_ID = B.VILLAGE_ID)");
    		            	}
    		            	    sqlBuffer.append(" WHERE");
    		            		sqlBuffer.append(" A.FLG = '"+query_flag+"'");
    		            		sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
    		            		sqlBuffer.append(" AND A.ACCT_DAY = '"+acct_day+"'");
    		            }else {
    		            	if("2".equals(flag)) {
    		            		if("2".equals(query_flag)) {
    		            			sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
    		            			sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
    		            			sqlBuffer.append(" WHERE B.LATN_ID = '"+region_id+"'");
    		            			sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
    		            			sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	    		            	}else if("3".equals(query_flag)) {
	    		            		sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
	    		            		sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
	    		            		sqlBuffer.append(" WHERE B.LATN_ID = '"+region_id+"'");
	    		            		sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
	    		            		sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
	    		            		sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	    		            	}else if("4".equals(query_flag)) {
	    		            		sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
	    		            		sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
	    		            		sqlBuffer.append(" WHERE B.LATN_ID = '"+region_id+"'");
	    		            		sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
	    		            		sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
	    		            		sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
	    		            		sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	    		            	}else if("5".equals(query_flag)) {
	    		            		sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
	    		            		sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
	    		            		sqlBuffer.append(" WHERE LATN_ID IN (");
	    		            		sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
	    		            		sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
	    		            		sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
	    		            		sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
	    		            		sqlBuffer.append(" )");
	    		            		sqlBuffer.append(" WHERE C.LATN_ID = '"+region_id+"'");
	    		            		sqlBuffer.append(" )");
	    		            		sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
	    		            	}
    		            	}else if("3".equals(flag)) {
	    		            		if("3".equals(query_flag)) {
	    		            			sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
	    		            			sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
	    		            			sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
	    		            			sqlBuffer.append(" SELECT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
	    		            			sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
	    		            			sqlBuffer.append(" and latn_id = '"+city_id+"'");
	    		            			sqlBuffer.append(" )");
	    		            			sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
	    		            			sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
	    		            			sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
		    		            	}else if("4".equals(query_flag)) {
		    		            		sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
		    		            		sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
		    		            		sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
		    		            		sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
		    		            		sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
		    		            		sqlBuffer.append(" and latn_id = '"+city_id+"'");
		    		            		sqlBuffer.append(" )");
		    		            		sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
		    		            		sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
		    		            		sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
		    		            		sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
		    		            	}else if("5".equals(query_flag)) {
		    		            		sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
		    		            		sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
		    		            		sqlBuffer.append(" WHERE LATN_ID IN (");
		    		            		sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
		    		            		sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
		    		            		sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
		    		            		sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
		    		            		sqlBuffer.append(" )");
		    		            		sqlBuffer.append(" WHERE C.BUREAU_NO IN (");
		    		            		sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
		    		            		sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
		    		            		sqlBuffer.append(" and latn_id = '"+city_id+"'");
		    		            		sqlBuffer.append(" )");
		    		            		sqlBuffer.append(" )");
		    		            		sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
		    		            	}
    		            	}
    		            }
    		            if(!"1".equals(query_flag)) {
    		            	 if("0".equals(query_sort)) {
    		            		 sqlBuffer.append(" ORDER BY BROAD_PENETRANCE_SORT DESC");
  	    		            }else if("1".equals(query_sort)) {
  	    		            	sqlBuffer.append(" ORDER BY BROAD_PENETRANCE_SORT ASC");
  	    		            }
    		            }
    		            sqlBuffer.append(" ) T");

						if("1".equals(query_flag)) {
							sqlBuffer.append(" ORDER BY ORD");
						}
						sqlBuffer.append(" ) T");
	    		
	    	}
	    
    	return  sqlBuffer.toString();
    	
    }
    
    /**
     * 小区以外的 市 县 支局 网格的情况
     * @param dataList
     */
    private void notVillageExcel(List<Map>  dataList) {
    	
    	 // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "宽带家庭渗透率");
        
        //标题的style
        XSSFCellStyle titleCellStyle = wb.createCellStyle();
       
        titleCellStyle.setAlignment(CellStyle.ALIGN_CENTER);  // 设置单元格水平方向对其方式
        titleCellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER); // 设置单元格垂直方向对其方式
        titleCellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框  
        titleCellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框  
        titleCellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框  
        titleCellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框  
        //titleCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);  
        
        XSSFFont font = wb.createFont();
        font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);//粗体显示
        titleCellStyle.setFont(font);
        
        //标题的style
        XSSFCellStyle headCellStyle = wb.createCellStyle(); 
         
        headCellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headCellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框  
        headCellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框  
        headCellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框  
        headCellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框  
        //headCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);  
        
        //内容cell的style
        XSSFCellStyle cellStyle = wb.createCellStyle();
        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框  
        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框  
        cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框  
        cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框  

        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));

        sheet.addMergedRegion(new CellRangeAddress(0,0,0,15)); 
        Cell title_cell = titleRow.createCell(0); 
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("宽带家庭渗透"); 
        
        //字段名称
        Row row = sheet.createRow(1);
        //给第一行添加文本
        Cell cell_0 = row.createCell(0);  
        Cell cell_1 = row.createCell(1);
        Cell cell_2 = row.createCell(2);
        Cell cell_3 = row.createCell(3);
        Cell cell_4 = row.createCell(4);
        Cell cell_5 = row.createCell(5);
        Cell cell_6 = row.createCell(6);
        Cell cell_7 = row.createCell(7);
        Cell cell_8 = row.createCell(8);
        Cell cell_9 = row.createCell(9);
        Cell cell_10 = row.createCell(10);
        Cell cell_11 = row.createCell(11);
        Cell cell_12 = row.createCell(12);
        Cell cell_13 = row.createCell(13);
        Cell cell_14 = row.createCell(14);
        Cell cell_15 = row.createCell(15);
        
        //style 
        cell_0.setCellStyle(headCellStyle);
        cell_1.setCellStyle(headCellStyle);
        cell_2.setCellStyle(headCellStyle);
        cell_3.setCellStyle(headCellStyle);
        cell_4.setCellStyle(headCellStyle);
        cell_5.setCellStyle(headCellStyle);
        cell_6.setCellStyle(headCellStyle);
        cell_7.setCellStyle(headCellStyle);
        cell_8.setCellStyle(headCellStyle);
        cell_9.setCellStyle(headCellStyle);
        cell_10.setCellStyle(headCellStyle);
        cell_11.setCellStyle(headCellStyle);
        cell_12.setCellStyle(headCellStyle);
        cell_13.setCellStyle(headCellStyle);
        cell_14.setCellStyle(headCellStyle);
        cell_15.setCellStyle(headCellStyle);
        
        //内容
        cell_0.setCellValue("序号");
        cell_1.setCellValue("地域");
        cell_2.setCellValue("累计到达渗透率");
        cell_3.setCellValue("本月提升");
        cell_4.setCellValue("本年提升");
        cell_5.setCellValue("小区数");
        cell_6.setCellValue("住户数");
        cell_7.setCellValue("光宽用户数");
        cell_8.setCellValue("高渗透率小区");
        cell_9.setCellValue("占比");
        cell_10.setCellValue("中渗透率小区");
        cell_11.setCellValue("占比");
        cell_12.setCellValue("中低渗透率小区");
        cell_13.setCellValue("占比");
        cell_14.setCellValue("低渗透率小区");
        cell_15.setCellValue("占比");
        
        //row = sheet.createRow(2);
        int rowIndex= 2;
        if(dataList!=null&&!dataList.isEmpty()){
			for(Map m : dataList){
				row = sheet.createRow(rowIndex++);
				//创建cell
	            Cell cell_data_0 = row.createCell(0);  
	            Cell cell_data_1 = row.createCell(1);
	            Cell cell_data_2 = row.createCell(2);
	            Cell cell_data_3 = row.createCell(3);
	            Cell cell_data_4 = row.createCell(4);
	            Cell cell_data_5 = row.createCell(5);
	            Cell cell_data_6 = row.createCell(6);
	            Cell cell_data_7 = row.createCell(7);
	            Cell cell_data_8 = row.createCell(8);
	            Cell cell_data_9 = row.createCell(9);
	            Cell cell_data_10 = row.createCell(10);
	            Cell cell_data_11 = row.createCell(11);
	            Cell cell_data_12 = row.createCell(12);
	            Cell cell_data_13 = row.createCell(13);
	            Cell cell_data_14 = row.createCell(14);
	            Cell cell_data_15 = row.createCell(15);
	            
	            //cell的样式设置
	            cell_data_0.setCellStyle(cellStyle);
	            cell_data_1.setCellStyle(cellStyle);
	            cell_data_2.setCellStyle(cellStyle);
	            cell_data_3.setCellStyle(cellStyle);
	            cell_data_4.setCellStyle(cellStyle);
	            cell_data_5.setCellStyle(cellStyle);
	            cell_data_6.setCellStyle(cellStyle);
	            cell_data_7.setCellStyle(cellStyle);
	            cell_data_8.setCellStyle(cellStyle);
	            cell_data_9.setCellStyle(cellStyle);
	            cell_data_10.setCellStyle(cellStyle);
	            cell_data_11.setCellStyle(cellStyle);
	            cell_data_12.setCellStyle(cellStyle);
	            cell_data_13.setCellStyle(cellStyle);
	            cell_data_14.setCellStyle(cellStyle);
	            cell_data_15.setCellStyle(cellStyle);
        
				//序号
                cell_data_0.setCellValue(rowIndex-2);
				//地域
                cell_data_1.setCellValue(m.get("AREA_DESC")+"");
	            //累计到达渗透率
                cell_data_2.setCellValue(m.get("BROAD_PENETRANCE")+"");
	            //本月提升
                cell_data_3.setCellValue(m.get("FILTER_MON_RATE")+""); 
	            //本年提升
                cell_data_4.setCellValue(m.get("FILTER_YEAR_RATE")+"");
	            //小区数
                cell_data_5.setCellValue(m.get("VILLAGE_CNT")+"");
	            //住户数
                cell_data_6.setCellValue(m.get("GZ_ZHU_HU_COUNT")+"");
	            //光宽用户数
                cell_data_7.setCellValue(m.get("GZ_H_USE_CNT")+"");
	            //高渗透率小区
                cell_data_8.setCellValue(m.get("HIGH_FILTER_VILLAGE_CNT")+"");
	            //占比
                cell_data_9.setCellValue(m.get("HIGH_FILTER_RATE")+"");
	            //中渗透率小区
                cell_data_10.setCellValue(m.get("MID_FILTER_VILLAGE_CNT")+"");
	            //占比
                cell_data_11.setCellValue(m.get("MID_FILTER_RATE")+"");
	            //中低渗透率小区
                cell_data_12.setCellValue(m.get("LOW_FILTER_VILLAGE_CNT")+"");
	            //占比
                cell_data_13.setCellValue(m.get("LOW_FILTER_RATE")+"");
	            //低渗透率小区
                cell_data_14.setCellValue(m.get("LOW_10_FILTER_VILLAGE_CNT")+"");
	            //占比
                cell_data_15.setCellValue(m.get("LOW_10_FILTER_RATE")+"");
			}
		} 
    }
    
    
    /**
     * 小区的情况
     * @param dataList
     */
    private void villageExcel(List<Map>  dataList) {
    	
    	 // 创建一个张表
        XSSFSheet sheet = wb.createSheet();
        wb.setSheetName(0, "宽带家庭渗透率");
        
        //标题的style
        XSSFCellStyle titleCellStyle = wb.createCellStyle();
       
        titleCellStyle.setAlignment(CellStyle.ALIGN_CENTER);  // 设置单元格水平方向对其方式
        titleCellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER); // 设置单元格垂直方向对其方式
        titleCellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框  
        titleCellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框  
        titleCellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框  
        titleCellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框  
        //titleCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);  
        
        XSSFFont font = wb.createFont();
        font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);//粗体显示
        titleCellStyle.setFont(font);
        
        //标题的style
        XSSFCellStyle headCellStyle = wb.createCellStyle(); 
         
        headCellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headCellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框  
        headCellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框  
        headCellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框  
        headCellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框  
        //headCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);  
        
        //内容cell的style
        XSSFCellStyle cellStyle = wb.createCellStyle();
        cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框  
        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框  
        cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框  
        cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框  

        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) (25 * 20));

        sheet.addMergedRegion(new CellRangeAddress(0,0,0,9)); 
        Cell title_cell = titleRow.createCell(0); 
        title_cell.setCellStyle(titleCellStyle);
        title_cell.setCellValue("宽带家庭渗透"); 
        
        Row row = sheet.createRow(1);
        //给第一行添加文本
        Cell cell_0 = row.createCell(0);  
        Cell cell_1 = row.createCell(1);
        Cell cell_2 = row.createCell(2);
        Cell cell_3 = row.createCell(3);
        Cell cell_4 = row.createCell(4);
        Cell cell_5 = row.createCell(5);
        Cell cell_6 = row.createCell(6);
        Cell cell_7 = row.createCell(7);
        Cell cell_8 = row.createCell(8);
        Cell cell_9 = row.createCell(9);
        
        //style 
        cell_0.setCellStyle(headCellStyle);
        cell_1.setCellStyle(headCellStyle);
        cell_2.setCellStyle(headCellStyle);
        cell_3.setCellStyle(headCellStyle);
        cell_4.setCellStyle(headCellStyle);
        cell_5.setCellStyle(headCellStyle);
        cell_6.setCellStyle(headCellStyle);
        cell_7.setCellStyle(headCellStyle);
        cell_8.setCellStyle(headCellStyle);
        cell_9.setCellStyle(headCellStyle);
        
        //内容
        cell_0.setCellValue("序号");
        cell_1.setCellValue("分公司");
        cell_2.setCellValue("小区名称");
        cell_3.setCellValue("累计达到渗透率");
        cell_4.setCellValue("本月提升");
        cell_5.setCellValue("本年提升");
        cell_6.setCellValue("住户数");
        cell_7.setCellValue("光宽用户数");
        cell_8.setCellValue("政企住户");
        cell_9.setCellValue("政企宽带");
       
        
        row = sheet.createRow(2);
        int rowIndex= 2;
        if(dataList!=null&&!dataList.isEmpty()){
			for(Map m : dataList){
				row = sheet.createRow(rowIndex++);
				//创建cell
	            Cell cell_data_0 = row.createCell(0);  
	            Cell cell_data_1 = row.createCell(1);
	            Cell cell_data_2 = row.createCell(2);
	            Cell cell_data_3 = row.createCell(3);
	            Cell cell_data_4 = row.createCell(4);
	            Cell cell_data_5 = row.createCell(5);
	            Cell cell_data_6 = row.createCell(6);
	            Cell cell_data_7 = row.createCell(7);
	            Cell cell_data_8 = row.createCell(8);
	            Cell cell_data_9 = row.createCell(9);
	            
	            //cell的样式设置
	            cell_data_0.setCellStyle(cellStyle);
	            cell_data_1.setCellStyle(cellStyle);
	            cell_data_2.setCellStyle(cellStyle);
	            cell_data_3.setCellStyle(cellStyle);
	            cell_data_4.setCellStyle(cellStyle);
	            cell_data_5.setCellStyle(cellStyle);
	            cell_data_6.setCellStyle(cellStyle);
	            cell_data_7.setCellStyle(cellStyle);
	            cell_data_8.setCellStyle(cellStyle);
	            cell_data_9.setCellStyle(cellStyle);
        
				//序号
                cell_data_0.setCellValue(rowIndex-2);
				//分公司
                cell_data_1.setCellValue(m.get("AREA_DESC1")+"");
	            //小区名称
                cell_data_2.setCellValue(m.get("AREA_DESC")+"");
	            //累计达到渗透率
                cell_data_3.setCellValue(m.get("BROAD_PENETRANCE")+""); 
	            //本月提升
                cell_data_4.setCellValue(m.get("FILTER_MON_RATE")+"");
	            //本年提升
                cell_data_5.setCellValue(m.get("FILTER_YEAR_RATE")+"");
	            //住户数
                cell_data_6.setCellValue(m.get("GZ_ZHU_HU_COUNT")+"");
	            //光宽用户数
                cell_data_7.setCellValue(m.get("GZ_H_USE_CNT")+"");
	            //政企住户
                cell_data_8.setCellValue(m.get("GOV_ZHU_HU_COUNT")+"");
	            //政企宽带
                cell_data_9.setCellValue(m.get("GOV_H_USE_CNT")+"");
			}
		} 
    }
    
    @Action("ExcelDownload")
    public void ExcelDownload(String excelName, HttpServletRequest request, HttpServletResponse response) {
    	
    	try {
			Map<String, String> parameter = new HashMap<String, String>();

			String query_flag = request.getParameter("query_flag");
			
			//获取sql
			String excuteSql  = makeSql(request);
			System.out.println("excuteSql:"+excuteSql);
		
            //获取数据(全部数据)
            List<Map>  dataList = new ArrayList<Map>();
    		try {
    			dataList = (List<Map>)runner.queryForMapList(excuteSql);
    		} catch (SQLException e) {
    			System.out.println("excel downLoad SQLException ");
    			e.printStackTrace();
    		}

			out = response.getOutputStream();
		    String title  = "宽带家庭渗透率.xlsx";
		    response.setContentType("application/vnd.ms-excel;charset=GBK");
            response.setCharacterEncoding("GBK");
            response.setHeader("Content-Disposition","attachment;filename=\""+ response.encodeURL(new String((title).getBytes("GBK"), "ISO8859-1")));
            wb = new XSSFWorkbook();
            
            //小区以外
            if(!"5".equals(query_flag)) {
            	//小区以外的数据excel做成
                notVillageExcel(dataList);
            }else {
            	//小区的数据excel做成
            	villageExcel(dataList);
            }
            
            wb.write(out);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			  try { 
				    if(out != null) {
				    out.close();
			        }
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}
    	//公司的文件下载，可以直接下载附件文件
//        String downFilePath = request.getSession().getServletContext().getRealPath("/") + "pages/download/宽带家庭渗透率.xlsx";//文件存放路径
//        DownLoad dl = new DownLoad();
//        //dl.downloadFile(request, response, downFilePath, "附件下载");
//        dl.downloadFile(request, response, downFilePath, "宽带家庭渗透率");
    }
}


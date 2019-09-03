package cn.com.easy.down.client.action;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by huiyf on 2018/6/11.
 * purpose：excel文件操作
 */
public class YXSPExcelSql {

	 /**
     * 宽带家庭渗透-sql拼接
     * @param request
     * @return
     */
    public String market_makeSql(HttpServletRequest request) {
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
		System.out.println("flag:"+flag);
		System.out.println("region_id:"+region_id);
		System.out.println("query_flag:"+query_flag);

    	//市,县,支局,网格, 小区
    	boolean is_village = false;
    	//==5 是小区
    	if("5".equals(query_flag)) {
    		is_village = true;
    	}

	    if(is_village) {
	    		//--------------------------小区sql--------开始-----------------------------------------
				//测试导出
	    		//sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
	    		sqlBuffer.append(" SELECT");
	    		sqlBuffer.append(" '全省'  AREA_DESC,");
	             if("".equals(region_id) || null ==region_id) {
	            	 sqlBuffer.append(" ' ' AREA_DESC1,");
	            	 sqlBuffer.append(" ' ' AREA_DESC2,");
	            	 sqlBuffer.append(" ' ' AREA_DESC3,");
	            	 sqlBuffer.append(" ' ' AREA_DESC4,");
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
	             sqlBuffer.append(" 0 C_NUM,");
	             sqlBuffer.append(" 0 RN");
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
				 sqlBuffer.append(" select * from (");
	             sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM,rownum rn FROM (");
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
	            	 sqlBuffer.append(" dd.latn_name,");
	            	 sqlBuffer.append(" dd.bureau_name,");
	            	 sqlBuffer.append(" dd.branch_name,");
	            	 sqlBuffer.append(" dd.grid_name,");
	            	 sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC,");
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
	            	 sqlBuffer.append(" AND A.ACCT_DAY = '"+acct_day+"'");

	             }

				//测试导出
				//sqlBuffer.append(" AND ROWNUM < 24377");
	            if(!"1".equals(query_flag)) {
	            	 if("0".equals(query_sort)) {
	            		 sqlBuffer.append(" ORDER BY BROAD_PENETRANCE_SORT DESC");
	  	            }else if("1".equals(query_sort)) {
	  	            	sqlBuffer.append(" ORDER BY BROAD_PENETRANCE_SORT ASC");
	  	            }
	            }
				//测试导出
	            //sqlBuffer.append(" ) T)where rn > 20000)t");
	            sqlBuffer.append(" ) T)");
	            if("1".equals(query_flag)) {
	            	sqlBuffer.append(" ORDER BY ORD");
	            }
	            //--------------------------小区sql--------终了-----------------------------------------
	    	}else {
	    		sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
	    		sqlBuffer.append("            SELECT");
	    				if("".equals(region_id) || null ==region_id) {
	    					sqlBuffer.append("  '全省' AREA_DESC,");
							if("2".equals(query_flag)) {
								sqlBuffer.append("  ' ' AREA_DESC1,");
							}else if("3".equals(query_flag)) {
								sqlBuffer.append("  ' ' AREA_DESC1,");
								sqlBuffer.append("  ' ' AREA_DESC2,");
							}else if("4".equals(query_flag)) {
								sqlBuffer.append("  ' ' AREA_DESC1,");
								sqlBuffer.append("  ' ' AREA_DESC2,");
								sqlBuffer.append("  ' ' AREA_DESC3,");
							}
	    				}else {
	    					if("1".equals(flag)) {
		    					sqlBuffer.append("  '全省' AREA_DESC,");
		    					sqlBuffer.append("  ' ' area_desc1,");
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
    		            	sqlBuffer.append(" B.LATN_NAME,");
    		            	sqlBuffer.append(" B.BUREAU_NAME AREA_DESC,");
    		            	sqlBuffer.append(" B.BUREAU_NO ORD,");
    		            }else if("3".equals(query_flag)) {
							sqlBuffer.append(" B.LATN_NAME,");
							sqlBuffer.append(" B.BUREAU_NAME,");
    		            	sqlBuffer.append(" B.BRANCH_NAME AREA_DESC,");
    		            	sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
    		            }else if("4".equals(query_flag)) {
    		            	sqlBuffer.append(" B.LATN_NAME,");
    		            	sqlBuffer.append(" B.BUREAU_NAME,");
    		            	sqlBuffer.append(" B.BRANCH_NAME,");
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
    		            	 sqlBuffer.append(" AND A.ACCT_DAY = '"+acct_day+"'");
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
     * 光网覆盖情况---sql拼接
     * @param request
     * @return
     */
    public String fb_cover_makeSql(HttpServletRequest request) {
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

		System.out.println("flag:" + flag);
		System.out.println("region_id:" + region_id);
		System.out.println("query_flag:" + query_flag);

    	//市,县,支局,网格, 小区
    	boolean is_village = false;
    	//==5 是小区
    	if("5".equals(query_flag)) {
    		is_village = true;
    	}

        sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
        sqlBuffer.append(" 	    SELECT");

		if("".equals(region_id) || null ==region_id) {
			sqlBuffer.append("  '全省' AREA_DESC,");
			if("2".equals(query_flag)){
				sqlBuffer.append("  ' ' AREA_DESC1,");
			}else if("3".equals(query_flag)){
				sqlBuffer.append("  ' ' AREA_DESC1,");
				sqlBuffer.append("  ' ' AREA_DESC2,");
			}else if("4".equals(query_flag)){
				sqlBuffer.append("  ' ' AREA_DESC1,");
				sqlBuffer.append("  ' ' AREA_DESC2,");
				sqlBuffer.append("  ' ' AREA_DESC3,");
			}else if("5".equals(query_flag)){
				sqlBuffer.append("  ' ' AREA_DESC1,");
				sqlBuffer.append("  ' ' AREA_DESC2,");
				sqlBuffer.append("  ' ' AREA_DESC3,");
				sqlBuffer.append("  ' ' AREA_DESC4,");
			}
		}else {
			if("1".equals(flag)) {
				sqlBuffer.append("  '全省' AREA_DESC,");
				sqlBuffer.append("  ' ' area_desc1,");
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
		sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,");
		if (!"5".equals(query_flag)) {
			sqlBuffer.append(" NVL(A.VILLAGE_CNT, 0)  VILLAGE_CNT,");
		}

		sqlBuffer.append(" DECODE(NVL(A.LY_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND((NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT, 4) * 100, 'FM999999990.00') || '%') FB_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.LY_CNT, 0), 0, 0, (NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT ) FB_RATE_SORT,");
		sqlBuffer.append(" NVL(A.LY_CNT, 0) FB_BUILD_VILLAGE,");
		sqlBuffer.append(" NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0) FB_BUILD_VILLAGE_RATE,");
		sqlBuffer.append(" NVL(A.NO_RES_ARRIVE_CNT, 0) FB_N_BUILD_VILLAGE,");
		sqlBuffer.append(" NVL(A.OBD_CNT, 0) FB_N_BUILD_VILLAGE_RATE,");
		sqlBuffer.append(" 0 C_NUM");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
		if ("".equals(region_id) || null == region_id) {
			sqlBuffer.append(" WHERE A.FLG = '0'");
		} else {
			if ("2".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID = '" + region_id + "'");
			} else if ("3".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID IN (");
				sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
				sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
				sqlBuffer.append(" and latn_id = '" + city_id + "'");
				sqlBuffer.append(" )");
			}
		}

		sqlBuffer.append(" AND BRANCH_TYPE = 'a1'");
		sqlBuffer.append(" AND A.ACCT_DAY = '" + acct_day + "'");
		sqlBuffer.append(" UNION ALL");
		sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM FROM (");
		sqlBuffer.append(" SELECT");
		sqlBuffer.append(" DISTINCT");

		if("1".equals(query_flag)) {
			sqlBuffer.append(" B.AREA_DESC,");
			sqlBuffer.append(" B.ORD,");
		}else if("2".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NO ORD,");
		}else if("3".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME,");
			sqlBuffer.append(" B.BUREAU_NAME,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC,");
			sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
		}else if("4".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME,");
			sqlBuffer.append(" B.BUREAU_NAME,");
			sqlBuffer.append(" B.BRANCH_NAME,");
			sqlBuffer.append(" B.GRID_NAME AREA_DESC,");
			sqlBuffer.append(" B.GRID_ID ORD,");
		}else if("5".equals(query_flag)) {
			sqlBuffer.append(" dd.latn_name,");
			sqlBuffer.append(" dd.bureau_name,");
			sqlBuffer.append(" dd.branch_name,");
			sqlBuffer.append(" dd.grid_name,");
			sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC,");
			sqlBuffer.append(" B.VILLAGE_ID ORD,");
		}

		sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT, 0) GZ_ZHU_HU_COUNT,");
		if(!"5".equals(query_flag)) {
			sqlBuffer.append(" NVL(A.VILLAGE_CNT, 0)  VILLAGE_CNT,");
		}

		sqlBuffer.append(" DECODE(NVL(A.LY_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND((NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT, 4) * 100, 'FM999999990.00') || '%') FB_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.LY_CNT, 0), 0, 0, (NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0)) / A.LY_CNT ) FB_RATE_SORT,");
		sqlBuffer.append(" NVL(A.LY_CNT, 0) FB_BUILD_VILLAGE,");
		sqlBuffer.append(" NVL(A.LY_CNT, 0) - NVL(A.NO_RES_ARRIVE_CNT, 0) FB_BUILD_VILLAGE_RATE,");
		sqlBuffer.append(" NVL(A.NO_RES_ARRIVE_CNT, 0) FB_N_BUILD_VILLAGE,");
		sqlBuffer.append(" NVL(A.OBD_CNT, 0) FB_N_BUILD_VILLAGE_RATE");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");

		if ("".equals(region_id) || null == region_id) {
			if ("1".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN EASY_DATA.CMCODE_AREA B");
				sqlBuffer.append(" ON A.LATN_ID = B.AREA_NO");
			} else if ("2".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
			} else if ("3".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')");
			} else if ("4".equals(query_flag)) {
				sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
				sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1')");
			} else if ("5".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
				sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
				sqlBuffer.append(" LEFT OUTER JOIN gis_data.view_db_cde_village dd");
				sqlBuffer.append(" ON a.latn_id = dd.village_id");
			}
			sqlBuffer.append(" WHERE");
			sqlBuffer.append(" A.FLG = '" + query_flag + "'");
			sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
			sqlBuffer.append(" AND A.ACCT_DAY = '" + acct_day + "'");
		} else {
			if ("2".equals(flag)) {
				if ("2".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
					sqlBuffer.append(" WHERE C.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			} else if ("3".equals(flag)) {
				if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
					sqlBuffer.append(" WHERE C.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			}
			sqlBuffer.append(" AND A.ACCT_DAY = '" + acct_day + "'");
		}

		if (!"1".equals(query_flag)) {
			if ("0".equals(query_sort)) {
				sqlBuffer.append(" ORDER BY FB_RATE_SORT DESC");
			}
			if ("1".equals(query_sort)) {
				sqlBuffer.append(" ORDER BY FB_RATE_SORT ASC");
			}
		}
		sqlBuffer.append(" ) T");
		if ("1".equals(query_flag)) {
			sqlBuffer.append(" ORDER BY ORD");
		}
		sqlBuffer.append(" )T");

		return sqlBuffer.toString();
    }

    /**
     * 光网实占情况---sql拼接
     * @param request
     * @return
     */
    public String fb_realPer_makeSql(HttpServletRequest request) {
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
		String beginDate = request.getParameter("beginDate");
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

		System.out.println("flag:" + flag);
		System.out.println("region_id:" + region_id);
		System.out.println("query_flag:" + query_flag);

    	//市,县,支局,网格, 小区
    	boolean is_village = false;
    	//==5 是小区
    	if("5".equals(query_flag)) {
    		is_village = true;
    	}

		sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
		sqlBuffer.append(" SELECT");
		sqlBuffer.append(" '全省' AREA_DESC,");
		if("".equals(region_id) || null ==region_id) {
			if("2".equals(query_flag))
				sqlBuffer.append(" ' ' AREA_DESC1,");
			else if("3".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
			}else if("4".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
			}else if("5".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
				sqlBuffer.append(" ' ' AREA_DESC4,");
			}
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
		sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT,0) GZZH_CNT,");
		sqlBuffer.append(" NVL(A.PORT_ID_CNT,0) PORT_CNT,");
		sqlBuffer.append(" NVL(A.USE_PORT_CNT,0) USE_PORT_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.PORT_ID_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT, 4) * 100, 'FM999999990.00') || '%') PORT_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.PORT_ID_CNT, 0), 0, 0, NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT) PORT_RATE_SORT,");
		sqlBuffer.append(" NVL(A.OBD_CNT,0) OBD_CNT,");
		sqlBuffer.append(" NVL(A.ZERO_OBD_CNT_1,0) ZERO_OBD_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.ZERO_OBD_CNT_1, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ZERO_OBD_RATE,");
		sqlBuffer.append(" NVL(A.FIRST_OBD_CNT,0) ONE_OBD_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.FIRST_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ONE_OBD_RATE,");
		sqlBuffer.append(" NVL(A.LOW_OBD_CNT,0) LOW_OBD_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_OBD_RATE,");
		sqlBuffer.append(" 0 C_NUM");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
		if ("".equals(region_id) || region_id == null) {
			sqlBuffer.append(" WHERE A.FLG = '0'");
		} else {
			if ("2".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID = '" + region_id + "'");
			} else if ("3".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID IN (");
				sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
				sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
				sqlBuffer.append(" and latn_id = '" + city_id + "'");
				sqlBuffer.append(" )");
			}
		}

		sqlBuffer.append(" AND BRANCH_TYPE = 'a1'");
		sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		sqlBuffer.append(" UNION ALL");
		sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM FROM (");
		sqlBuffer.append(" SELECT");
		sqlBuffer.append(" DISTINCT");

		if("1".equals(query_flag)) {
			sqlBuffer.append(" B.AREA_DESC,");
			sqlBuffer.append(" B.ORD,");
		}else if("2".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BUREAU_NO ORD,");
		}else if("3".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
		}else if("4".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.GRID_NAME AREA_DESC3,");
			sqlBuffer.append(" B.GRID_ID ORD,");
		}else if("5".equals(query_flag)) {
			sqlBuffer.append(" dd.latn_name AREA_DESC,");
			sqlBuffer.append(" dd.bureau_name AREA_DESC1,");
			sqlBuffer.append(" dd.branch_name AREA_DESC2,");
			sqlBuffer.append(" dd.grid_name AREA_DESC3,");
			sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC4,");
			sqlBuffer.append(" B.VILLAGE_ID ORD,");
		}

		sqlBuffer.append(" NVL(A.GZ_ZHU_HU_COUNT,0) GZZH_CNT,");
		sqlBuffer.append(" NVL(A.PORT_ID_CNT,0) PORT_CNT,");
		sqlBuffer.append(" NVL(A.USE_PORT_CNT,0) USE_PORT_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.PORT_ID_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT, 4) * 100, 'FM999999990.00') || '%') PORT_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.PORT_ID_CNT, 0), 0, 0, NVL(A.USE_PORT_CNT, 0) / A.PORT_ID_CNT) PORT_RATE_SORT,");
		sqlBuffer.append(" NVL(A.OBD_CNT,0) OBD_CNT,");
		sqlBuffer.append(" NVL(A.ZERO_OBD_CNT_1,0) ZERO_OBD_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.ZERO_OBD_CNT_1, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ZERO_OBD_RATE,");
		sqlBuffer.append(" NVL(A.FIRST_OBD_CNT,0) ONE_OBD_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.FIRST_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') ONE_OBD_RATE,");
		sqlBuffer.append(" NVL(A.LOW_OBD_CNT,0) LOW_OBD_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OBD_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(A.LOW_OBD_CNT, 0) / A.OBD_CNT, 4) * 100, 'FM999999990.00') || '%') LOW_OBD_RATE");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
		if ("".equals(region_id) || region_id == null) {

			if ("1".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN EASY_DATA.CMCODE_AREA B");
				sqlBuffer.append(" ON A.LATN_ID = B.AREA_NO");
			} else if ("2".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
			} else if ("3".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL AND B.BRANCH_TYPE = 'a1')");
			} else if ("4".equals(query_flag)) {
				sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
				sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1')");
			} else if ("5".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
				sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
				sqlBuffer.append(" LEFT OUTER JOIN gis_data.view_db_cde_village dd");
				sqlBuffer.append(" ON a.latn_id = dd.village_id");
			}

			sqlBuffer.append(" WHERE");
			sqlBuffer.append(" A.FLG = '" + query_flag + "'");
			sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
			sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		} else {
			if ("2".equals(flag)) {
				if ("2".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE !=-1 and c.grid_status = 1");
					sqlBuffer.append(" )");
					sqlBuffer.append(" WHERE C.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}

			} else if ("3".equals(flag)) {
				if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
					sqlBuffer.append(" WHERE C.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			}
			sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		}

		if (!"1".equals(query_flag)) {
			if ("0".equals(query_sort)) {
				sqlBuffer.append(" ORDER BY PORT_RATE_SORT DESC");
			}
			if ("1".equals(query_sort)) {
				sqlBuffer.append(" ORDER BY PORT_RATE_SORT ASC");
			}
		}

		sqlBuffer.append(" ) T");
		if ("1".equals(query_flag)) {
			sqlBuffer.append(" ORDER BY ORD");
		}

		sqlBuffer.append(" )T");

		return sqlBuffer.toString();
    }

    /**
     * 精准派单营销---sql拼接
     * @param request
     * @return
     */
    public String dispatch_yx_makeSql(HttpServletRequest request) {
        /*
    	System.out.println("beginDate===="+request.getParameter("beginDate"));
    	System.out.println("beginMonth===="+request.getParameter("beginMonth"));
    	System.out.println("flag========="+request.getParameter("flag"));
    	System.out.println("page========="+request.getParameter("page"));
    	System.out.println("region_id===="+request.getParameter("region_id"));
    	System.out.println("query_sort==="+request.getParameter("query_sort"));
    	System.out.println("query_flag==="+request.getParameter("query_flag"));
    	System.out.println("city_id======"+request.getParameter("city_id"));
    	System.out.println("dateType====="+request.getParameter("dateType"));
    	System.out.println("scene_id======"+request.getParameter("scene_id"));
    	System.out.println("acct_month======"+request.getParameter("acct_month"));
    	System.out.println("pageSize====="+request.getParameter("pageSize"));
        */

    	//账期日
		String beginDate = request.getParameter("beginDate");
		//账期月
		String beginMonth = request.getParameter("beginMonth");

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

		//日/月
		String dateType = request.getParameter("dateType");

		//场景
		String scene_id = request.getParameter("scene_id");

		//账期
		String acct_month= request.getParameter("acct_month");

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

		System.out.println("query_flag:"+query_flag);
		System.out.println("flag:"+flag);
		System.out.println("region_id:"+region_id);
    	if(is_village) {
    		//--------------------------------------------------------小区-------------开始--------------------------------------------------------
			sqlBuffer.append("SELECT                                                                                                                       ");
			sqlBuffer.append("AREA_DESC,                                                                                                                   ");
			sqlBuffer.append("AREA_DESC1,                                                                                                                  ");
			sqlBuffer.append("AREA_DESC2,                                                                                                                  ");
			sqlBuffer.append("AREA_DESC3,                                                                                                                  ");
			sqlBuffer.append("T.VILLAGE_ID LATN_ID,                                                                                                        ");
			sqlBuffer.append("T.VILLAGE_NAME AREA_DESC4,                                                                                            ");
			sqlBuffer.append("T.ORDER_NUM MBYH_CNT,                                                                                                 ");
			sqlBuffer.append("T.EXEC_NUM ZX_CNT,                                                                                                    ");
			sqlBuffer.append("T.SUCC_NUM CGYH_CNT,                                                                                                  ");
			sqlBuffer.append("TO_CHAR(EXEC_RATE, 'FM990.00') || '%' ZX_RATE,                                                                        ");
			sqlBuffer.append("EXEC_RATE ZX_RATE1,                                                                                                   ");
			sqlBuffer.append("TO_CHAR(SUCC_RATE, 'FM990.00') || '%' CG_RATE,                                                                        ");
			sqlBuffer.append("SUCC_RATE CG_RATE1,                                                                                                   ");
			sqlBuffer.append("T.EXEC_NUM_MONTH ZX_CNT_MONTH,                                                                                        ");
			sqlBuffer.append("T.SUCC_NUM_MONTH CGYH_CNT_MONTH,                                                                                      ");
			sqlBuffer.append("TO_CHAR(EXEC_RATE_MONTH, 'FM990.00') || '%' ZX_RATE_MONTH,                                                            ");
			sqlBuffer.append("EXEC_RATE_MONTH ZX_RATE_MONTH1,                                                                                       ");
			sqlBuffer.append("TO_CHAR(SUCC_RATE_MONTH, 'FM990.00') || '%' CG_RATE_MONTH,                                                            ");
			sqlBuffer.append("SUCC_RATE_MONTH CG_RATE_MONTH1,                                                                                       ");
			sqlBuffer.append("C_NUM                                                                                                                 ");
			sqlBuffer.append("FROM (SELECT                                                                                                               ");
			sqlBuffer.append("t.AREA_DESC,                                                                                                               ");
			sqlBuffer.append("t.AREA_DESC1,                                                                                                              ");
			sqlBuffer.append("t.AREA_DESC2,                                                                                                              ");
			sqlBuffer.append("t.AREA_DESC3,                                                                                                              ");
			sqlBuffer.append("T.VILLAGE_ID,                                                                                                              ");
			sqlBuffer.append("T.VILLAGE_NAME,                                                                                               ");
			sqlBuffer.append("T.ORDER_NUM,                                                                                                  ");
			sqlBuffer.append("T.EXEC_NUM,                                                                                                   ");
			sqlBuffer.append("T.SUCC_NUM,                                                                                                   ");
			sqlBuffer.append("T.USER_NUM,                                                                                                   ");
			sqlBuffer.append("DECODE(T.ORDER_NUM,                                                                                           ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("         ROUND(T.EXEC_NUM / T.ORDER_NUM, 4) * 100) EXEC_RATE,                                                   ");
			sqlBuffer.append("DECODE(T.USER_NUM,                                                                                            ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("       ROUND(T.SUCC_NUM / T.USER_NUM, 4) * 100) SUCC_RATE,                                                    ");
			sqlBuffer.append("EXEC_NUM_MONTH,                                                                                               ");
			sqlBuffer.append("SUCC_NUM_MONTH,                                                                                               ");
			sqlBuffer.append("USER_NUM_MONTH,                                                                                               ");
			sqlBuffer.append("DECODE(T.ORDER_NUM,                                                                                           ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("       ROUND(T.EXEC_NUM_MONTH / T.ORDER_NUM, 4) * 100) EXEC_RATE_MONTH,                                       ");
			sqlBuffer.append("DECODE(T.USER_NUM_MONTH,                                                                                      ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("       0,                                                                                                     ");
			sqlBuffer.append("       ROUND(T.SUCC_NUM / T.USER_NUM, 4) * 100) SUCC_RATE_MONTH,                                              ");
			sqlBuffer.append("C_NUM,                                                                                                        ");
			sqlBuffer.append("ROWNUM RN                                                                                                     ");
			sqlBuffer.append("       FROM (WITH VILLAGE_ORDER_LIST AS (SELECT T.*                                                                       ");
			sqlBuffer.append("			FROM (SELECT BB.LEV6_ID,                                                       ");
			sqlBuffer.append("			             COUNT(AA.ORDER_ID) ORDER_NUM,                                     ");
			sqlBuffer.append("			             COUNT(CASE                                                        ");
			sqlBuffer.append("			                     WHEN EXEC_STAT <> 0 THEN                                  ");
			sqlBuffer.append("			                      AA.ORDER_ID                                              ");
			sqlBuffer.append("			                   END) EXEC_NUM,                                              ");
			sqlBuffer.append("			               COUNT(DISTINCT                                                    ");
			sqlBuffer.append("			                     DECODE(AA.SUCC_FLAG,                                        ");
			sqlBuffer.append("			                            1,                                                   ");
			sqlBuffer.append("			                            AA.PROD_INST_ID)) SUCC_NUM,                          ");
			sqlBuffer.append("			               COUNT(DISTINCT                                                    ");
			sqlBuffer.append("			                     AA.PROD_INST_ID) USER_NUM,                                  ");
			sqlBuffer.append("			               COUNT(CASE                                                        ");
			sqlBuffer.append("			                       WHEN EXEC_STAT_MONTH <> 0 THEN                            ");
			sqlBuffer.append("			                        AA.ORDER_ID                                              ");
			sqlBuffer.append("			                     END) EXEC_NUM_MONTH,                                        ");
			sqlBuffer.append("			               COUNT(DISTINCT                                                    ");
			sqlBuffer.append("			                     DECODE(AA.SUCC_FLAG_MONTH,                                  ");
			sqlBuffer.append("			                            1,                                                   ");
			sqlBuffer.append("			                            AA.PROD_INST_ID)) SUCC_NUM_MONTH,                    ");
			sqlBuffer.append("			               COUNT(DISTINCT                                                    ");
			sqlBuffer.append("			                     AA.PROD_INST_ID_MONTH) USER_NUM_MONTH                       ");
			sqlBuffer.append("			          FROM GIS_DATA.TB_MKT_INFO BB,                                          ");
			sqlBuffer.append("			               (SELECT B.PROD_INST_ID PROD_INST_ID_MONTH,                        ");
			sqlBuffer.append("                                 B.ORDER_ID,                                               ");
			sqlBuffer.append("                                 A.EXEC_STAT,                                              ");
			sqlBuffer.append("                                 A.SUCC_FLAG,                                              ");
			sqlBuffer.append("                                 B.EXEC_STAT    EXEC_STAT_MONTH,                           ");
			sqlBuffer.append("                                 B.SUCC_FLAG    SUCC_FLAG_MONTH,                           ");
			sqlBuffer.append("                                 A.PROD_INST_ID                                            ");
			sqlBuffer.append("                              FROM EDW.TB_MKT_ORDER_LIST@GSEDW A,                            ");
			sqlBuffer.append("                                   EDW.TB_MKT_ORDER_LIST@GSEDW B                             ");
			sqlBuffer.append("                             WHERE 1 = 1                                                     ");
			sqlBuffer.append("                               AND TO_CHAR(A.EXEC_TIME,'yyyymmdd') ='"+beginDate+"'          ");
			sqlBuffer.append("                               AND B.ORDER_MONTH =SUBSTR('"+beginDate+"',0,6)                ");
			sqlBuffer.append("                               AND A.ORDER_ID =                                              ");
			sqlBuffer.append("                                   B.ORDER_ID                                                ");
			if(!"".equals(scene_id) && scene_id != null) {
				sqlBuffer.append("							   and a.scene_id = '"+scene_id+"'                           ");
			}
			sqlBuffer.append("                              ) AA                                                      ");
			sqlBuffer.append("				  WHERE BB.PROD_INST_ID =                                                 ");
			sqlBuffer.append("				        AA.PROD_INST_ID                                                   ");
			sqlBuffer.append("				  GROUP BY BB.LEV6_ID) T)                                                 ");
			sqlBuffer.append("                 SELECT                                                                                                      ");
			sqlBuffer.append("                        '全省' AREA_DESC,                                                                                    ");
			sqlBuffer.append("                        ' ' AREA_DESC1,                                                                                       ");
			sqlBuffer.append("                        ' ' AREA_DESC2,                                                                                       ");
			sqlBuffer.append("                        ' ' AREA_DESC3,                                                                                       ");
			sqlBuffer.append("                        ' ' VILLAGE_ID,                                                                                       ");
			sqlBuffer.append("                        ' ' VILLAGE_NAME,                                                                                     ");
			sqlBuffer.append("                        NVL(SUM(ORDER_NUM), 0) ORDER_NUM,                                                                    ");
			sqlBuffer.append("                        NVL(SUM(EXEC_NUM), 0) EXEC_NUM,                                                                      ");
			sqlBuffer.append("                        NVL(SUM(SUCC_NUM), 0) SUCC_NUM,                                                                      ");
			sqlBuffer.append("                        NVL(SUM(USER_NUM), 0) USER_NUM,                                                                      ");
			sqlBuffer.append("                        DECODE(NVL(SUM(ORDER_NUM), 0),                                                                       ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(NVL(SUM(EXEC_NUM), 0) / SUM(ORDER_NUM), 4) * 100) EXEC_RATE,                            ");
			sqlBuffer.append("                        DECODE(NVL(SUM(USER_NUM), 0),                                                                        ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(NVL(SUM(SUCC_NUM), 0) / SUM(USER_NUM), 4) * 100) SUCC_RATE,                             ");
			sqlBuffer.append("                        NVL(SUM(EXEC_NUM_MONTH), 0) EXEC_NUM_MONTH,                                                          ");
			sqlBuffer.append("                        NVL(SUM(SUCC_NUM_MONTH), 0) SUCC_NUM_MONTH,                                                          ");
			sqlBuffer.append("                        NVL(SUM(USER_NUM_MONTH), 0) USER_NUM_MONTH,                                                          ");
			sqlBuffer.append("                        DECODE(NVL(SUM(ORDER_NUM), 0),                                                                       ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(NVL(SUM(EXEC_NUM_MONTH), 0) /                                                           ");
			sqlBuffer.append("                                     SUM(ORDER_NUM),                                                                         ");
			sqlBuffer.append("                                     4) * 100) EXEC_RATE_MONTH,                                                              ");
			sqlBuffer.append("                        DECODE(NVL(SUM(USER_NUM), 0),                                                                        ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(NVL(SUM(SUCC_NUM_MONTH), 0) /                                                           ");
			sqlBuffer.append("                                     SUM(USER_NUM),                                                                          ");
			sqlBuffer.append("                                     4) * 100) SUCC_RATE_MONTH,                                                              ");
			sqlBuffer.append("                        0 C_NUM                                                                                              ");
			sqlBuffer.append("                   FROM VILLAGE_ORDER_LIST                                                                                   ");
			sqlBuffer.append("                  WHERE LEV6_ID IS NOT NULL                                                                                  ");
			sqlBuffer.append("                 UNION                                                                                                       ");
			sqlBuffer.append("                 SELECT                                                                                                      ");
			sqlBuffer.append("                        V.latn_name AREA_DESC1,V.bureau_name AREA_DESC2,V.branch_name AREA_DESC3,V.grid_name AREA_DESC4,     ");
			sqlBuffer.append("                        V.VILLAGE_ID,                                                                                        ");
			sqlBuffer.append("                        V.VILLAGE_NAME,                                                                                      ");
			sqlBuffer.append("                        NVL(SUM(AA.ORDER_NUM), 0) ORDER_NUM,                                                                 ");
			sqlBuffer.append("                        NVL(SUM(AA.EXEC_NUM), 0) EXEC_NUM,                                                                   ");
			sqlBuffer.append("                        NVL(SUM(AA.SUCC_NUM), 0) SUCC_NUM,                                                                   ");
			sqlBuffer.append("                        NVL(SUM(AA.USER_NUM), 0) USER_NUM,                                                                   ");
			sqlBuffer.append("                        DECODE(ORDER_NUM,                                                                                    ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(EXEC_NUM / ORDER_NUM, 4) * 100) EXEC_RATE,                                              ");
			sqlBuffer.append("                        DECODE(USER_NUM,                                                                                     ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(SUCC_NUM / USER_NUM, 4) * 100) SUCC_RATE,                                               ");
			sqlBuffer.append("                        NVL(SUM(EXEC_NUM_MONTH), 0) EXEC_NUM_MONTH,                                                          ");
			sqlBuffer.append("                        NVL(SUM(SUCC_NUM_MONTH), 0) SUCC_NUM_MONTH,                                                          ");
			sqlBuffer.append("                        NVL(SUM(USER_NUM_MONTH), 0) USER_NUM_MONTH,                                                          ");
			sqlBuffer.append("                        DECODE(NVL(SUM(ORDER_NUM), 0),                                                                       ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(NVL(SUM(EXEC_NUM_MONTH), 0) /                                                           ");
			sqlBuffer.append("                                     SUM(ORDER_NUM),                                                                         ");
			sqlBuffer.append("                                     4) * 100) EXEC_RATE_MONTH,                                                              ");
			sqlBuffer.append("                        DECODE(NVL(SUM(USER_NUM), 0),                                                                        ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               0,                                                                                            ");
			sqlBuffer.append("                               ROUND(NVL(SUM(SUCC_NUM_MONTH), 0) /                                                           ");
			sqlBuffer.append("                                     SUM(USER_NUM),                                                                          ");
			sqlBuffer.append("                                     4) * 100) SUCC_RATE_MONTH,                                                              ");
			sqlBuffer.append("                        COUNT(1) OVER() C_NUM                                                                                ");
			sqlBuffer.append("                   FROM VILLAGE_ORDER_LIST AA, GIS_DATA.VIEW_DB_CDE_VILLAGE V                                                ");
			sqlBuffer.append("                  WHERE AA.LEV6_ID = V.VILLAGE_ID                                                                            ");
			sqlBuffer.append("                  GROUP BY v.latn_name,v.bureau_name,v.branch_name,v.grid_name,VILLAGE_ID, V.VILLAGE_NAME                    ");
			sqlBuffer.append("                  ORDER BY C_NUM) T                                                                                          ");
			sqlBuffer.append("        ) T                                                                                                                  ");
			//--------------------------------------------------------小区-------------终了--------------------------------------------------------
    	}else {
            //--------------------------------------------------------小区以外-------------开始--------------------------------------------------------
			String sql_part_column =
					"nvl(sum(nvl(T.ORDER_CNT,0)),0) MBYH_CNT,                                                                                                                         			 "+
					"nvl(sum(NVL(T.EXEC_CNT,0)  -  nvl(T1.EXEC_CNT,0)),0) ZX_CNT,                                                                                                                "+
					"DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),'0','0.00%',TO_CHAR(ROUND(sum(NVL(T.EXEC_CNT  -  T1.EXEC_CNT,0)) /sum(NVL(T.ORDER_CNT,0)),4) * 100,'FM999999990.00') || '%') ZX_RATE,"+
					"nvl(sum(NVL(T.SUCC_CNT  -  T1.SUCC_CNT,0)),0) CGYH_CNT,                                                                                                                     "+
					"DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),'0','0.00%',TO_CHAR(ROUND(sum(NVL(T.SUCC_CNT  -  T1.SUCC_CNT,0)) /sum(NVL(T.ORDER_CNT,0)),4) * 100,'FM999999990.00') || '%') CG_RATE,"+
					"nvl(sum(NVL(T.EXEC_CNT,0)),0)  ZX_CNT_MONTH,                                                                                                                                "+
					"DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),'0','0.00%',TO_CHAR(ROUND(sum(NVL(T.EXEC_CNT,0)) /sum(NVL(T.ORDER_CNT,0)),4) * 100,'FM999999990.00') || '%') ZX_RATE_MONTH,          "+
					"nvl(sum(NVL(T.SUCC_CNT,0)),0)  CGYH_CNT_MONTH,                                                                                                                              "+
					"DECODE(NVL(sum(NVL(T.ORDER_CNT,0)), 0),'0','0.00%',TO_CHAR(ROUND(sum(NVL(T.SUCC_CNT,0)) /sum(NVL(T.ORDER_CNT,0)),4) * 100,'FM999999990.00') || '%') CG_RATE_MONTH           ";
			sqlBuffer.append("SELECT T.*, ROWNUM ROW_NUM FROM (");
			sqlBuffer.append("SELECT");
			if("1".equals(query_flag)){
				sqlBuffer.append(" '999' LATN_ID,");
				sqlBuffer.append(" '全省' AREA_DESC,");
			}else if("2".equals(query_flag)){
				sqlBuffer.append(" '999' LATN_ID,");
				sqlBuffer.append(" '全省' AREA_DESC,");
				sqlBuffer.append(" ' ' LATN_ID1,");
				sqlBuffer.append(" ' ' AREA_DESC1,");
			}else if("3".equals(query_flag)){
				sqlBuffer.append(" '999' LATN_ID,");
				sqlBuffer.append(" '全省' AREA_DESC,");
				sqlBuffer.append(" ' ' LATN_ID1,");
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' LATN_ID2,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
			}else if("4".equals(query_flag)){
				sqlBuffer.append(" '999' LATN_ID,");
				sqlBuffer.append(" '全省' AREA_DESC,");
				sqlBuffer.append(" ' ' LATN_ID1,");
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' LATN_ID2,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' LATN_ID3,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
			}
			sqlBuffer.append("'0' LATN_SORT,                                                                       ");
			sqlBuffer.append(sql_part_column+",");
			sqlBuffer.append("0 C_NUM                                                                            ");
			sqlBuffer.append("FROM                                                                               ");
			sqlBuffer.append("gis_data.VIEW_GSCH_MKT_ORDER_STAT_DAY T,                                       	 ");
			sqlBuffer.append("gis_data.VIEW_GSCH_MKT_ORDER_STAT_DAY T1                            			 	 ");
			sqlBuffer.append("where T.BRANCH_TYPE = T1.BRANCH_TYPE                                                 ");
			sqlBuffer.append("AND T.SCENE_ID = T1.SCENE_ID                                                       ");
			sqlBuffer.append("AND T.STAT_LVL = T1.STAT_LVL                                                       ");
			sqlBuffer.append("AND T.LATN_SORT = T1.LATN_SORT                                                     ");
			sqlBuffer.append("AND T.ACCT_DAY = '"+beginDate+"'                                                   ");
			sqlBuffer.append("AND T1.ACCT_DAY = to_char(to_date('"+beginDate+"','yyyymmdd')-1,'yyyymmdd')        ");
			sqlBuffer.append("AND t.branch_type <> 'c1'                                                          ");
			sqlBuffer.append("AND t.STAT_LVL = '"+query_flag+"'                                                  ");
			sqlBuffer.append("AND T.SCENE_ID IS NOT NULL                                                         ");
			if(!"".equals(scene_id) && scene_id != null) {
				sqlBuffer.append("AND t.SCENE_ID = '"+ scene_id +"'                                              ");
			}
			sqlBuffer.append("UNION ALL                                                                          ");
			sqlBuffer.append("SELECT                                                                             ");
			if("1".equals(query_flag)) {
				sqlBuffer.append(" t.LATN_ID || '' REGION_ID,");
				sqlBuffer.append(" t.LATN_NAME AREA_DESC,");
				sqlBuffer.append(" t.LATN_SORT||'' LATN_SORT,");
			}else if("2".equals(query_flag)) {
				sqlBuffer.append(" a.LATN_ID || '' REGION_ID,");
				sqlBuffer.append(" a.LATN_NAME AREA_DESC,");
				sqlBuffer.append(" t.LATN_ID REGION_ID1,");
				sqlBuffer.append(" t.latn_name AREA_DESC1,");
				sqlBuffer.append(" t.latn_sort||'' LATN_SORT,");
			}else if("3".equals(query_flag)) {
				sqlBuffer.append(" a.LATN_ID || '' REGION_ID,");
				sqlBuffer.append(" a.LATN_NAME AREA_DESC,");
				sqlBuffer.append(" a.BUREAU_NO REGION_ID1,");
				sqlBuffer.append(" a.BUREAU_NAME AREA_DESC1,");
				sqlBuffer.append(" t.LATN_ID REGION_ID2,");
				sqlBuffer.append(" t.LATN_NAME AREA_DESC2,");
				sqlBuffer.append(" t.latn_sort||'' LATN_SORT,");
			}else if("4".equals(query_flag)) {
				sqlBuffer.append(" a.LATN_ID || '' REGION_ID,");
				sqlBuffer.append(" a.LATN_NAME AREA_DESC,");
				sqlBuffer.append(" a.BUREAU_NO REGION_ID1,");
				sqlBuffer.append(" a.BUREAU_NAME AREA_DESC1,");
				sqlBuffer.append(" a.BRANCH_NO REGION_ID2,");
				sqlBuffer.append(" a.BRANCH_NAME AREA_DESC2,");
				sqlBuffer.append(" t.LATN_ID REGION_ID3,");
				sqlBuffer.append(" t.LATN_NAME AREA_DESC3,");
				sqlBuffer.append(" t.latn_sort||'' LATN_SORT,");
			}
			sqlBuffer.append(sql_part_column+",");
			sqlBuffer.append("COUNT(1) OVER() C_NUM                                                              ");
			sqlBuffer.append("FROM                                                                               ");
			sqlBuffer.append(" gis_data.VIEW_GSCH_MKT_ORDER_STAT_DAY T,                                        	 ");
			sqlBuffer.append(" gis_data.VIEW_GSCH_MKT_ORDER_STAT_DAY T1                              			 ");
			if(!"1".equals(query_flag)){
				sqlBuffer.append(" ,(select distinct ");
				if("2".equals(query_flag)){
					sqlBuffer.append(" latn_id,latn_name,bureau_no,bureau_name ");
				}else if("3".equals(query_flag)){
					sqlBuffer.append(" latn_id,latn_name,bureau_no,bureau_name,branch_no,branch_name ");
				}else if("4".equals(query_flag)){
					sqlBuffer.append(" latn_id,latn_name,bureau_no,bureau_name,branch_no,branch_name,grid_id,grid_name ");
				}
				sqlBuffer.append(" from gis_data.db_cde_grid) a ");
			}

			sqlBuffer.append("WHERE T.LATN_ID = T1.LATN_ID                                                       ");
			if("2".equals(query_flag)){
				sqlBuffer.append("AND t.latn_id = a.bureau_no													 ");
			}else if("3".equals(query_flag)){
				sqlBuffer.append("AND t.latn_id = a.branch_no													 ");
			}else if("4".equals(query_flag)){
				sqlBuffer.append("AND t.latn_id = a.grid_id														 ");
			}
			sqlBuffer.append("AND T.BRANCH_TYPE = T1.BRANCH_TYPE                                                 ");
			sqlBuffer.append("AND T.SCENE_ID = T1.SCENE_ID                                                       ");
			sqlBuffer.append("AND T.STAT_LVL = T1.STAT_LVL                                                       ");
			sqlBuffer.append("AND T.ACCT_DAY = '"+beginDate+"'                                                   ");
			sqlBuffer.append("AND T1.ACCT_DAY = to_char(to_date('"+beginDate+"','yyyymmdd')-1,'yyyymmdd')");
			sqlBuffer.append("AND t.branch_type <> 'c1'                                                          ");
			sqlBuffer.append("AND t.STAT_LVL = '"+query_flag+"'                                                  ");
			sqlBuffer.append("AND T.SCENE_ID IS NOT NULL                                                         ");
			if(!"".equals(scene_id) && scene_id != null) {
				sqlBuffer.append("    AND t.SCENE_ID = '"+scene_id+"'                                         	 ");
			}
			if(!"".equals(region_id) && region_id != null) {
				if("2".equals(flag)){
					sqlBuffer.append("    	AND a.LATN_ID = '"+region_id+"'                                      ");
				}else if("3".equals(flag)){
					sqlBuffer.append("    	AND a.BUREAU_NAME = '"+region_id+"'                                  ");
					sqlBuffer.append("      AND a.LATN_ID = '"+city_id+"'                                		 ");
					//sqlBuffer.append("      and a.bureau_no = t.latn_id                          				 ");
				}else if("3".equals(flag)){
					sqlBuffer.append("    	AND a.BUREAU_NAME = '"+region_id+"'                                  ");
					sqlBuffer.append("      AND a.LATN_ID = '"+city_id+"'                                		 ");
					//sqlBuffer.append("      and a.bureau_no = t.latn_id                          				 ");
				}else if("3".equals(flag)){
					sqlBuffer.append("    	AND a.BUREAU_NAME = '"+region_id+"'                                  ");
					sqlBuffer.append("      AND a.LATN_ID = '"+city_id+"'                                		 ");
					//sqlBuffer.append("      and a.bureau_no = t.latn_id                          				 ");
				}else if("4".equals(flag)){
					sqlBuffer.append("    	AND a.branch_union_org_code = '"+region_id+"'                        ");
					//sqlBuffer.append("      and a.branch_union_org_code = t.latn_id                      		 ");
				}else if("5".equals(flag)){
					sqlBuffer.append("    	AND a.grid_id = '"+region_id+"'                                      ");
					//sqlBuffer.append("      and a.grid_id = t.latn_id                                    		 ");
				}
			}
			sqlBuffer.append("GROUP BY                                                                           ");
			if("2".equals(query_flag)){
				sqlBuffer.append("	a.latn_id,a.latn_name,														 ");
			}else if("3".equals(query_flag)){
				sqlBuffer.append("	a.latn_id,a.latn_name,a.bureau_no,a.bureau_name,							 ");
			}else if("4".equals(query_flag)){
				sqlBuffer.append("	a.latn_id,a.latn_name,a.bureau_no,a.bureau_name,a.branch_no,a.branch_name,	 ");
			}
			sqlBuffer.append("    t.LATN_ID, t.LATN_NAME, t.LATN_SORT                                            ");
			/*if("2".equals(flag)){
				sqlBuffer.append("    ,a.bureau_no, a.bureau_name		                                         ");
			}else if("3".equals(flag)){
				sqlBuffer.append("    ,a.bureau_no, a.bureau_name, a.branch_no		                                         ");
			}*/
			sqlBuffer.append("order by latn_sort                                                                 ");
			sqlBuffer.append(")T                                                                                 ");

    		//--------------------------------------------------------小区以外-------------终了--------------------------------------------------------
    	}
    	return  sqlBuffer.toString();
    }

    /**
     * 竞争信息收集(竞争对手光网进线情况)---sql拼接
     * @param request
     * @return
     */
    public String collect_net_makeSql(HttpServletRequest request) {
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
		String beginDate = request.getParameter("beginDate");
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

		sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
		sqlBuffer.append(" SELECT");
		sqlBuffer.append(" '全省' AREA_DESC,");
		if("".equals(region_id) || null ==region_id) {
			if("2".equals(query_flag))
				sqlBuffer.append(" ' ' AREA_DESC1,");
			else if("3".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
			}else if("4".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
			}else if("5".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
				sqlBuffer.append(" ' ' AREA_DESC4,");//20180719 bug
			}
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
		sqlBuffer.append(" NVL(TO_CHAR(A.SHOULD_COLLECT_CNT), '0') SHOULD_COLLECT_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.ALREADY_COLLECT_CNT), '0') ALREADY_COLLECT_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.SHOULD_COLLECT_CNT, '0'),'0','0.00%',TO_CHAR(ROUND(NVL(A.ALREADY_COLLECT_CNT, 0) / A.SHOULD_COLLECT_CNT,4) * 100,'FM999999990.00') || '%') COLLECT_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.SHOULD_COLLECT_CNT, 0),  0, 0,  NVL(A.ALREADY_COLLECT_CNT, 0) / A.SHOULD_COLLECT_CNT) COLLECT_RATE_SORT,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_MON_RATE, '0'),'0','0.00%',TO_CHAR(ROUND(A.OTHER_MON_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_MON_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_YEAR_RATE, '0'),'0','0.00%',TO_CHAR(ROUND(A.OTHER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_YEAR_RATE,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_BD_CNT), '0') OTHER_BD_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CM_CNT), '0') OTHER_CM_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_BD_CNT, '0'),'0','0.00%',TO_CHAR(ROUND(NVL(A.OTHER_CM_CNT, 0) / A.OTHER_BD_CNT,4) * 100,'FM999999990.00') || '%') MB_RATE,");

		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CU_CNT), '0') OTHER_CU_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_BD_CNT, '0'), '0','0.00%',TO_CHAR(ROUND(NVL(A.OTHER_CU_CNT, 0) / A.OTHER_BD_CNT,4) * 100,'FM999999990.00') || '%') MU_RATE,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_SARFT_CNT), '0') OTHER_SARFT_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_Y_CNT), '0') OTHER_Y_CNT,");
		sqlBuffer.append(" NVL(A.ALREADY_COLLECT_CNT, 0) - nvl(A.OTHER_BD_CNT,0) OTHER_UNINSTALL_CNT,");
		sqlBuffer.append(" NVL(A.COLLECT_DAY_CNT,0) COLLECT_DAY_CNT,");
		sqlBuffer.append(" NVL(A.UPDATE_DAY_CNT,0) UPDATE_DAY_CNT,");
		if("5".equals(query_flag)){
			sqlBuffer.append(" 0 COLLECT_CNT,");
			sqlBuffer.append(" 0 BUSS_CNT,");
		}
		sqlBuffer.append(" 0 C_NUM");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
		if ("".equals(region_id) || region_id == null) {
			sqlBuffer.append(" WHERE A.FLG = '0'");
		} else {
			if ("2".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID = '" + region_id + "'");
			} else if ("3".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID IN (");
				sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
				sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
				sqlBuffer.append(" and latn_id = '" + city_id + "'");
				sqlBuffer.append(" )");
			}
		}

		sqlBuffer.append(" AND BRANCH_TYPE = 'a1'");
		sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		sqlBuffer.append(" UNION ALL");
		sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM FROM (");
		sqlBuffer.append(" SELECT");
		sqlBuffer.append(" DISTINCT");

		if("1".equals(query_flag)) {
			sqlBuffer.append(" B.AREA_DESC,");
			sqlBuffer.append(" B.ORD,");
		}else if("2".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BUREAU_NO ORD,");
		}else if("3".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
		}else if("4".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.GRID_NAME AREA_DESC3,");
			sqlBuffer.append(" B.GRID_ID ORD,");
		}else if("5".equals(query_flag)) {
			sqlBuffer.append(" B.latn_name AREA_DESC,");
			sqlBuffer.append(" B.bureau_name AREA_DESC1,");
			sqlBuffer.append(" B.branch_name AREA_DESC2,");
			sqlBuffer.append(" B.grid_name AREA_DESC3,");
			sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC4,");
			sqlBuffer.append(" B.VILLAGE_ID ORD,");
		}

		sqlBuffer.append(" NVL(TO_CHAR(A.SHOULD_COLLECT_CNT), '0') SHOULD_COLLECT_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.ALREADY_COLLECT_CNT), '0') ALREADY_COLLECT_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.SHOULD_COLLECT_CNT, '0'),'0','0.00%',TO_CHAR(ROUND(NVL(A.ALREADY_COLLECT_CNT, 0) / A.SHOULD_COLLECT_CNT,4) * 100,'FM999999990.00') || '%') COLLECT_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.SHOULD_COLLECT_CNT, 0),  0, 0,  NVL(A.ALREADY_COLLECT_CNT, 0) / A.SHOULD_COLLECT_CNT) COLLECT_RATE_SORT,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_MON_RATE, '0'),'0','0.00%',TO_CHAR(ROUND(A.OTHER_MON_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_MON_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_YEAR_RATE, '0'), '0','0.00%',TO_CHAR(ROUND(A.OTHER_YEAR_RATE, 4) * 100, 'FM999999990.00') || '%') OTHER_YEAR_RATE,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_BD_CNT), '0') OTHER_BD_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CM_CNT), '0') OTHER_CM_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_BD_CNT, '0'),'0','0.00%',TO_CHAR(ROUND(NVL(A.OTHER_CM_CNT, 0) / A.OTHER_BD_CNT,4) * 100,'FM999999990.00') || '%') MB_RATE,");

		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CU_CNT), '0') OTHER_CU_CNT,");
		sqlBuffer.append(" DECODE(NVL(A.OTHER_BD_CNT, '0'),'0','0.00%',TO_CHAR(ROUND(NVL(A.OTHER_CU_CNT, 0) / A.OTHER_BD_CNT,4) * 100,'FM999999990.00') || '%') MU_RATE,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_SARFT_CNT), '0') OTHER_SARFT_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_Y_CNT), '0') OTHER_Y_CNT,");
		sqlBuffer.append(" NVL(A.ALREADY_COLLECT_CNT, 0) - nvl(A.OTHER_BD_CNT,0) OTHER_UNINSTALL_CNT,");
		sqlBuffer.append(" NVL(A.COLLECT_DAY_CNT,0) COLLECT_DAY_CNT,");
		sqlBuffer.append(" NVL(A.UPDATE_DAY_CNT,0) UPDATE_DAY_CNT");
		if("5".equals(query_flag)){
			sqlBuffer.append(" ,WIDEBAND_IN+cm_optical_fiber+cu_optical_fiber+sarft_optical_fiber+other_optical_fiber COLLECT_CNT,");
			sqlBuffer.append(" NVL(DECODE(NVL(A.OTHER_CM_CNT,0),0,0,1)+DECODE(NVL(A.OTHER_CU_CNT,0),0,0,1)+DECODE(NVL(A.OTHER_SARFT_CNT,0),0,0,1)+DECODE(NVL(A.OTHER_Y_CNT,0),0,0,1),0) BUSS_CNT");
		}
		sqlBuffer.append(" FROM GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");

		if ("".equals(region_id) || region_id == null) {
			if ("1".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN EASY_DATA.CMCODE_AREA B");
				sqlBuffer.append(" ON A.LATN_ID = B.AREA_NO");
			} else if ("2".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
			} else if ("3".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.UNION_ORG_CODE and B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')");
			} else if ("4".equals(query_flag)) {
				sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
				sqlBuffer.append(" and B.BRANCH_TYPE = 'a1')");
			} else if ("5".equals(query_flag)) {
				sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.VIEW_DB_CDE_VILLAGE B");
				sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
				sqlBuffer.append(" RIGHT OUTER JOIN gis_data.tb_gis_village_edit_info c");
				sqlBuffer.append(" ON B.VILLAGE_ID = C.VILLAGE_ID");
			}
			sqlBuffer.append(" WHERE");
			sqlBuffer.append(" A.FLG = '" + query_flag + "'");
			sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
			sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		} else {
			if ("2".equals(flag)) {
				if ("2".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.VIEW_DB_CDE_VILLAGE B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID");
					sqlBuffer.append(" AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
					sqlBuffer.append(" WHERE C.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			} else if ("3".equals(flag)) {
				if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.VIEW_DB_CDE_VILLAGE B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID");
					sqlBuffer.append(" AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
					sqlBuffer.append(" )");
					sqlBuffer.append(" WHERE C.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			}
			sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		}

		if (!"1".equals(query_flag)) {
			if ("0".equals(query_sort)) {
				sqlBuffer.append("  ORDER BY COLLECT_RATE_SORT DESC");
			}
			if ("1".equals(query_sort)) {
				sqlBuffer.append(" ORDER BY COLLECT_RATE_SORT ASC");
			}
		}

		sqlBuffer.append(" ) T");

		if ("1".equals(query_flag)) {
			sqlBuffer.append(" ORDER BY ORD");
		}

		sqlBuffer.append(" ) T");

		System.out.println(sqlBuffer.toString());
		return sqlBuffer.toString();

    }

    /**
     * 竞争信息收集(竞争预警)---sql拼接
     * @param request
     * @return
     */
    public String collect_warning_makeSql(HttpServletRequest request) {
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
		String beginDate = request.getParameter("beginDate");
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

    	sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
    	sqlBuffer.append(" SELECT");
		sqlBuffer.append(" '全省' AREA_DESC,");
		if("".equals(region_id) || null ==region_id) {
			if("2".equals(query_flag))
				sqlBuffer.append(" ' ' AREA_DESC1,");
			else if("3".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
			}else if("4".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
			}else if("5".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
				sqlBuffer.append(" ' ' AREA_DESC4,");//20180719 bug
			}
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
        sqlBuffer.append(" NVL(TO_CHAR(A.VILLAGE_CNT), '0') VILLAGE_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_NET_KD_VILLAGE_CNT), ' ') OTHER_NET_KD_VILLAGE_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.CMCC_KD_VILLAGE_CNT), ' ') CMCC_KD_VILLAGE_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.CUCC_KD_VILLAGE_CNT), ' ') CUCC_KD_VILLAGE_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.CBN_KD_VILLAGE_CNT), ' ') CBN_KD_VILLAGE_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_KD_VILLAGE_CNT), ' ') OTHER_KD_VILLAGE_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_BD_CNT), ' ') OTHER_BD_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CM_CNT), ' ') OTHER_CM_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CU_CNT), ' ') OTHER_CU_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_SARFT_CNT), ' ') OTHER_SARFT_CNT,");
        sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_Y_CNT), ' ') OTHER_Y_CNT,");
        sqlBuffer.append(" '0' DX_MARKET_SHARE,");
        sqlBuffer.append(" '0' CM_MARKET_SHARE,");
        sqlBuffer.append(" '0' CU_MARKET_SHARE,");
        sqlBuffer.append(" '0' SARFT_MARKET_SHARE,");
        sqlBuffer.append(" '0' OTHER_MARKET_SHARE,");
        sqlBuffer.append(" 0 C_NUM");
        sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
        if("".equals(region_id) || region_id == null) {
        	 sqlBuffer.append("  WHERE A.FLG = '0'");
        }else{
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
        sqlBuffer.append(" AND A.ACCT_DAY = '"+beginDate+"'");
        sqlBuffer.append(" UNION ALL");
        sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM FROM (");
        sqlBuffer.append(" SELECT");
        sqlBuffer.append(" DISTINCT");

		if("1".equals(query_flag)) {
			sqlBuffer.append(" B.AREA_DESC,");
			sqlBuffer.append(" B.ORD,");
		}else if("2".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BUREAU_NO ORD,");
		}else if("3".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
		}else if("4".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.GRID_NAME AREA_DESC3,");
			sqlBuffer.append(" B.GRID_ID ORD,");
		}else if("5".equals(query_flag)) {
			sqlBuffer.append(" B.latn_name AREA_DESC,");
			sqlBuffer.append(" B.bureau_name AREA_DESC1,");
			sqlBuffer.append(" B.branch_name AREA_DESC2,");
			sqlBuffer.append(" B.grid_name AREA_DESC3,");
			sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC4,");
			sqlBuffer.append(" B.VILLAGE_ID ORD,");
		}
		sqlBuffer.append(" NVL(TO_CHAR(A.VILLAGE_CNT), ' ') VILLAGE_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_NET_KD_VILLAGE_CNT), ' ') OTHER_NET_KD_VILLAGE_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.CMCC_KD_VILLAGE_CNT), ' ') CMCC_KD_VILLAGE_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.CUCC_KD_VILLAGE_CNT), ' ') CUCC_KD_VILLAGE_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.CBN_KD_VILLAGE_CNT), ' ') CBN_KD_VILLAGE_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_KD_VILLAGE_CNT), ' ') OTHER_KD_VILLAGE_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_BD_CNT), ' ') OTHER_BD_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CM_CNT), ' ') OTHER_CM_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_CU_CNT), ' ') OTHER_CU_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_SARFT_CNT), ' ') OTHER_SARFT_CNT,");
		sqlBuffer.append(" NVL(TO_CHAR(A.OTHER_Y_CNT), ' ') OTHER_Y_CNT,");
		sqlBuffer.append(" '0' DX_MARKET_SHARE,");
		sqlBuffer.append(" '0' CM_MARKET_SHARE,");
		sqlBuffer.append(" '0' CU_MARKET_SHARE,");
		sqlBuffer.append(" '0' SARFT_MARKET_SHARE,");
		sqlBuffer.append(" '0' OTHER_MARKET_SHARE");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");
		if("".equals(region_id) || region_id == null) {
			if("1".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN EASY_DATA.CMCODE_AREA B");
				sqlBuffer.append(" ON A.LATN_ID = B.AREA_NO");
			}else if("2".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
			}else if("3".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')");
			}else if("4".equals(query_flag)) {
				sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
				sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1')");
			}else if("5".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.VIEW_DB_CDE_VILLAGE B");
				sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
			}
			sqlBuffer.append(" WHERE");
			sqlBuffer.append(" A.FLG = '"+query_flag+"'");
			sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
			sqlBuffer.append(" AND A.ACCT_DAY = '"+beginDate+"'");
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
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				}else if("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.LATN_ID = '"+region_id+"'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}else if("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.VIEW_DB_CDE_VILLAGE B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and c.grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
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
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				}else if("4".equals(query_flag)){
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
				}else if("5".equals(query_flag)){
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.VIEW_DB_CDE_VILLAGE B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
					sqlBuffer.append(" WHERE C.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '"+region_id+"'");
					sqlBuffer.append(" and latn_id = '"+city_id+"'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			}
			sqlBuffer.append(" AND A.ACCT_DAY = '"+beginDate+"'");
		}

		if(!"1".equals(query_flag)) {
		if("0".equals(query_sort)) {
			sqlBuffer.append("   ORDER BY ORD DESC");
		}
		if("1".equals(query_sort)) {
			sqlBuffer.append(" ORDER BY ORD ASC");
		}
		}

		sqlBuffer.append(" ) T");

		if("1".equals(query_flag)) {
			  sqlBuffer.append(" ORDER BY ORD");
		}

		sqlBuffer.append(" ) T");

		return  sqlBuffer.toString();

    }

    /**
     * 宽带存量保有率---sql拼接
     * @param request
     * @return
     */
    public String protection_makeSql(HttpServletRequest request) {
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
		String beginDate = request.getParameter("beginDate");
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

		sqlBuffer.append(" SELECT T.*, ROWNUM ROW_NUM FROM (");
		sqlBuffer.append(" SELECT");
		sqlBuffer.append(" '全省' AREA_DESC,");
		if("".equals(region_id) || null ==region_id) {
			if("2".equals(query_flag))
				sqlBuffer.append(" ' ' AREA_DESC1,");
			else if("3".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
			}else if("4".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
			}else if("5".equals(query_flag)){
				sqlBuffer.append(" ' ' AREA_DESC1,");
				sqlBuffer.append(" ' ' AREA_DESC2,");
				sqlBuffer.append(" ' ' AREA_DESC3,");
				sqlBuffer.append(" ' ' AREA_DESC4,");
			}
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
		sqlBuffer.append(" DECODE(NVL(A.BY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(BY_CNT, 0) / A.BY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') BY_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.ACTIVE_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / A.ACTIVE_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') ACTIVE_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.XY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(XY_CNT, 0) / A.XY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') XY_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.LW_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(LW_CNT, 0) / A.LW_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') LW_RATE,");
		sqlBuffer.append(" 0 C_NUM");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");

		if ("".equals(region_id) || region_id == null) {
			sqlBuffer.append("  WHERE A.FLG = '0'");
		} else {
			if ("2".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID = '" + region_id + "'");
			} else if ("3".equals(flag)) {
				sqlBuffer.append(" WHERE A.LATN_ID IN (");
				sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
				sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
				sqlBuffer.append(" and latn_id = '" + city_id + "'");
				sqlBuffer.append(" )");
			}
		}
		sqlBuffer.append(" AND BRANCH_TYPE = 'a1'");
		sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		sqlBuffer.append(" UNION ALL");
		sqlBuffer.append(" SELECT T.*, COUNT(1) OVER() C_NUM FROM (");
		sqlBuffer.append(" SELECT");
		sqlBuffer.append(" DISTINCT");
		if("1".equals(query_flag)) {
			sqlBuffer.append(" B.AREA_DESC,");
			sqlBuffer.append(" B.ORD,");
		}else if("2".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BUREAU_NO ORD,");
		}else if("3".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.UNION_ORG_CODE ORD,");
		}else if("4".equals(query_flag)) {
			sqlBuffer.append(" B.LATN_NAME AREA_DESC,");
			sqlBuffer.append(" B.BUREAU_NAME AREA_DESC1,");
			sqlBuffer.append(" B.BRANCH_NAME AREA_DESC2,");
			sqlBuffer.append(" B.GRID_NAME AREA_DESC3,");
			sqlBuffer.append(" B.GRID_ID ORD,");
		}else if("5".equals(query_flag)) {
			sqlBuffer.append(" B.latn_name AREA_DESC,");
			sqlBuffer.append(" B.bureau_name AREA_DESC1,");
			sqlBuffer.append(" B.branch_name AREA_DESC2,");
			sqlBuffer.append(" B.grid_name AREA_DESC3,");
			sqlBuffer.append(" B.VILLAGE_NAME AREA_DESC4,");
			sqlBuffer.append(" B.VILLAGE_ID ORD,");
		}

		sqlBuffer.append(" DECODE(NVL(A.BY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(BY_CNT, 0) / A.BY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') BY_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.ACTIVE_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(ACTIVE_CNT, 0) / A.ACTIVE_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') ACTIVE_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.XY_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(XY_CNT, 0) / A.XY_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') XY_RATE,");
		sqlBuffer.append(" DECODE(NVL(A.LW_ALL_CNT, '0'), '0', '0.00%', TO_CHAR(ROUND(NVL(LW_CNT, 0) / A.LW_ALL_CNT, 4) * 100, 'FM999999990.00') || '%') LW_RATE");
		sqlBuffer.append(" FROM  GIS_DATA.TB_GIS_RES_CITY_DAY_HIS A");

		if ("".equals(region_id) || region_id == null) {
			if ("1".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN EASY_DATA.CMCODE_AREA B");
				sqlBuffer.append(" ON A.LATN_ID = B.AREA_NO");
			} else if ("2".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
			} else if ("3".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.UNION_ORG_CODE AND B.GRID_UNION_ORG_CODE IS NOT NULL and B.BRANCH_TYPE = 'a1')");
			} else if ("4".equals(query_flag)) {
				sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
				sqlBuffer.append(" ON (A.LATN_ID = B.GRID_ID AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
				sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1')");
			} else if ("5".equals(query_flag)) {
				sqlBuffer.append(" right OUTER JOIN GIS_DATA.VIEW_DB_CDE_VILLAGE B");
				sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
			}
			sqlBuffer.append(" WHERE");
			sqlBuffer.append(" A.FLG = '" + query_flag + "'");
			sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
			sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		} else {
			if ("2".equals(flag)) {
				if ("2".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.BUREAU_NO");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
					sqlBuffer.append(" WHERE C.LATN_ID = '" + region_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			} else if ("3".equals(flag)) {
				if ("3".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.UNION_ORG_CODE");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
				} else if ("4".equals(query_flag)) {
					sqlBuffer.append(" RIGHT OUTER JOIN GIS_DATA.DB_CDE_GRID B");
					sqlBuffer.append(" ON A.LATN_ID = B.GRID_ID");
					sqlBuffer.append(" WHERE B.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND B.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and b.grid_union_org_code != -1 and b.grid_status = 1");
					sqlBuffer.append(" AND B.BRANCH_TYPE = 'a1'");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				} else if ("5".equals(query_flag)) {
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" ON A.LATN_ID = B.VILLAGE_ID");
					sqlBuffer.append(" WHERE LATN_ID IN (");
					sqlBuffer.append(" SELECT DISTINCT VILLAGE_ID FROM GIS_DATA.TB_GIS_VILLAGE_EDIT_INFO B");
					sqlBuffer.append(" right OUTER JOIN GIS_DATA.DB_CDE_GRID C");
					sqlBuffer.append(" ON (B.GRID_ID_2 = C.GRID_ID AND C.GRID_UNION_ORG_CODE IS NOT NULL");
					sqlBuffer.append(" and c.GRID_UNION_ORG_CODE != -1 and grid_status = 1");
					sqlBuffer.append(" and C.BRANCH_TYPE = 'a1')");
					sqlBuffer.append(" WHERE C.BUREAU_NO IN (");
					sqlBuffer.append(" SELECT DISTINCT BUREAU_NO FROM GIS_DATA.DB_CDE_GRID");
					sqlBuffer.append(" WHERE BUREAU_NAME = '" + region_id + "'");
					sqlBuffer.append(" and latn_id = '" + city_id + "'");
					sqlBuffer.append(" )");
					sqlBuffer.append(" )");
					sqlBuffer.append(" AND A.BRANCH_TYPE = 'a1'");
				}
			}
			sqlBuffer.append(" AND A.ACCT_DAY = '" + beginDate + "'");
		}

		if (!"1".equals(query_flag)) {
			if ("0".equals(query_sort)) {
				sqlBuffer.append("  ORDER BY BY_RATE DESC");
			}
			if ("1".equals(query_sort)) {
				sqlBuffer.append(" ORDER BY BY_RATE ASC");
			}
		}

		sqlBuffer.append(" ) T");

		if ("1".equals(query_flag)) {
			sqlBuffer.append(" ORDER BY ORD");
		}

		sqlBuffer.append(" ) T");

		return sqlBuffer.toString();

    }

	//住户清单
	public String resident_makeSql(HttpServletRequest request){
		//
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

		//支局编码
		String branch_no = request.getParameter("branch_no");

		//网格编码
		String grid_id = request.getParameter("grid_id");

		//小区编码
		String village_id = request.getParameter("village_id");

		//楼宇编码
		String build_id = request.getParameter("build_id");

		//每页数据量
		String pageSize = request.getParameter("pageSize");


		StringBuffer sqlBuffer = new  StringBuffer();

		//市,县,支局,网格, 小区
		boolean is_village = false;
		//==5 是小区

		sqlBuffer.append(" SELECT NVL(O.STAND_NAME_1, ' ') STAND_NAME_1,");
		sqlBuffer.append(" NVL(O.SEGM_ID_2, ' ') SEGM_ID_2,");
		sqlBuffer.append(" NVL(O.SEGM_NAME_2, '  ') SEGM_NAME_2,");
		sqlBuffer.append(" CASE WHEN NVL(O.DX_CONTACT_PERSON, ' ') = ' ' THEN ' '");
		sqlBuffer.append(" ELSE SUBSTR(NVL(O.DX_CONTACT_PERSON, ' '), 1, 1) || '**'");
		sqlBuffer.append(" END DX_CONTACT_PERSON,");
		sqlBuffer.append(" CASE WHEN O.IS_KD_DX > 0 THEN nvl(BB.ACC_NBR,' ') ELSE ' ' END ACC_NBR,");
		sqlBuffer.append(" DECODE(DX_CONTACT_NBR, NULL, ' ',NVL((SUBSTR(DX_CONTACT_NBR, 0, 3) || '******' || SUBSTR(DX_CONTACT_NBR, 10, 2)),' ')) DX_CONTACT_NBR,");
		sqlBuffer.append(" CASE WHEN O.KD_BUSINESS IS NULL OR O.KD_DQ_DATE IS NULL THEN ' ' WHEN NVL(O.CONTACT_PERSON, ' ') = ' ' THEN  ' ' WHEN O.CONTACT_PERSON = '未装' THEN '未装' ELSE SUBSTR(NVL(O.CONTACT_PERSON, ' '), 1, 1) || '**' END CONTACT_PERSON,");
		sqlBuffer.append(" CASE WHEN O.KD_BUSINESS IS NULL OR O.KD_DQ_DATE IS NULL THEN ' ' WHEN O.CONTACT_NBR IS NULL THEN ' ' ELSE SUBSTR(O.CONTACT_NBR, 0, 3) || '******' || SUBSTR(O.CONTACT_NBR, 10, 2) END CONTACT_NBR,");
		sqlBuffer.append(" CASE");
		sqlBuffer.append(" WHEN NVL(O.IS_KD_DX, 0) = '0' THEN");
		sqlBuffer.append(" CASE");
		sqlBuffer.append(" WHEN O.KD_BUSINESS = '1' THEN");
		sqlBuffer.append(" '移动'");
		sqlBuffer.append(" WHEN O.KD_BUSINESS = '2' THEN");
		sqlBuffer.append(" '联通'");
		sqlBuffer.append(" WHEN O.KD_BUSINESS = '3' THEN");
		sqlBuffer.append(" '广电'");
		sqlBuffer.append(" WHEN O.KD_BUSINESS = '4' THEN");
		sqlBuffer.append(" '其他'");
		sqlBuffer.append(" WHEN O.KD_BUSINESS = '0' THEN");
		sqlBuffer.append(" '未装'");
		sqlBuffer.append(" ELSE");
		sqlBuffer.append(" '  '");
		sqlBuffer.append(" END");
		sqlBuffer.append(" WHEN O.IS_KD_DX > 0 THEN");
		sqlBuffer.append(" ' '");
		sqlBuffer.append(" END KD_BUSINESS,");
		sqlBuffer.append(" NVL(TO_CHAR(O.KD_DQ_DATE, 'YYYY-MM-DD'), '  ') KD_DQ_DATE,");
		sqlBuffer.append(" NVL(O.KD_XF, '  ') KD_XF,");
		sqlBuffer.append(" COUNT(1) OVER() C_NUM,");
		sqlBuffer.append(" ' ' COMMENTS");
		sqlBuffer.append(" FROM GIS_DATA.TB_GIS_ADDR_OTHER_ALL O ");

		if(!"".equals(village_id) && !"-1".equals(village_id)){
			sqlBuffer.append(", GIS_DATA.TB_GIS_VILLAGE_ADDR4 A");
		}

		sqlBuffer.append(" ,(select address_id,acc_nbr from GIS_DATA.TB_MKT_INFO");
		sqlBuffer.append(" where PRODUCT_CD in ('999991020','999991010','999991030','999991040')");
		sqlBuffer.append(" )bb");

		sqlBuffer.append(" WHERE 1 = 1");
		sqlBuffer.append(" and o.segm_id_2 = bb.address_id");

		if("-1".equals(village_id)){
			if(!"".equals(branch_no) && !" ".equals(branch_no) && !"-1".equals(branch_no)){
				sqlBuffer.append(" and segm_id in ( ");
				sqlBuffer.append(" SELECT segm_id FROM sde.TB_GIS_MAP_SEGM_LATN_MON where union_org_code='"+ branch_no +"' ");
				sqlBuffer.append(" and segm_id not in(select segm_id from gis_data.TB_GIS_VILLAGE_ADDR4) ");
				sqlBuffer.append(" ) ");
			}else if(!"".equals(grid_id) && !" ".equals(grid_id) && !"-1".equals(grid_id)){
				sqlBuffer.append(" and segm_id in ( ");
				sqlBuffer.append(" SELECT segm_id FROM sde.TB_GIS_MAP_SEGM_LATN_MON where grid_id='"+ grid_id +"' ");
				sqlBuffer.append(" and segm_id not in(select segm_id from gis_data.TB_GIS_VILLAGE_ADDR4) ");
				sqlBuffer.append(" ) ");
			}
		}
		if(!"".equals(build_id) && !" ".equals(build_id))
			sqlBuffer.append(" AND O.SEGM_ID IN(" + build_id + ")");

		if(!"".equals(village_id) && !"-1".equals(village_id)) {
			sqlBuffer.append(" AND O.SEGM_ID = A.SEGM_ID");
			sqlBuffer.append(" AND A.VILLAGE_ID = '" + village_id + "'");
		}

		sqlBuffer.append(" ORDER BY STAND_NAME_1 ASC, LENGTH(SEGM_NAME_2) ASC, SEGM_NAME_2 ASC");

		return  sqlBuffer.toString();
	}

	//流失用户清单
	public String lost_resident_makeSql(HttpServletRequest request){
		//支局编码
		String branch_no = request.getParameter("branch_no");

		//小区编码
		String village_id = request.getParameter("village_id");

		//楼宇编码
		String build_id = request.getParameter("build_id");

		StringBuffer sqlBuffer = new  StringBuffer();

		sqlBuffer.append(" SELECT ROWNUM ROW_NUM,");
		sqlBuffer.append("      COUNT(1) OVER() C_NUM,");
		sqlBuffer.append("      LEV6_ID VILLAGE_ID,");
		sqlBuffer.append("      ADDRESS_ID,");
		sqlBuffer.append("      ADDRESS_DESC STAND_NAME,");
		sqlBuffer.append("      CUST_NAME USER_CONTACT_PERSON,");
		sqlBuffer.append("      ACC_NBR,");
		sqlBuffer.append("     TO_CHAR(REMOVE_DATE, 'yyyy-mm-dd') REMOVE_DATE,");
		sqlBuffer.append("     CASE");
		sqlBuffer.append("       WHEN REMOVE_DATE IS NULL THEN");
		sqlBuffer.append("         '--'");
		sqlBuffer.append("        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) / 12 = 0 THEN");
		sqlBuffer.append("         TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) || '个月'");
		sqlBuffer.append("        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) / 12 > 1 THEN");
		sqlBuffer.append("         FLOOR(TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)) / 12) || '年'");
		sqlBuffer.append("     END || CASE");
		sqlBuffer.append("        WHEN MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)), 12) > 0 THEN");
		sqlBuffer.append("         MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, REMOVE_DATE)), 12) || '个月'");
		sqlBuffer.append("      END OWE_DUR,");
		sqlBuffer.append("      STOP_TYPE,");
		sqlBuffer.append("      PROD_INST_ID,");
		sqlBuffer.append("      CASE");
		sqlBuffer.append("        WHEN T.STOP_TYPE = 0 THEN");
		sqlBuffer.append("         '拆机'");
		sqlBuffer.append("        WHEN T.STOP_TYPE = 8 THEN");
		sqlBuffer.append("         '停机'");
		sqlBuffer.append("        WHEN T.STOP_TYPE = 3 THEN");
		sqlBuffer.append("         '沉默'");
		sqlBuffer.append("        WHEN T.STOP_TYPE = 2 THEN");
		sqlBuffer.append("         '沉默'");
		sqlBuffer.append("        ELSE");
		sqlBuffer.append("         ' '");
		sqlBuffer.append("      END SCENE_TEXT,");
		sqlBuffer.append("		' ' COMMENTS");
		sqlBuffer.append(" FROM EDW.TB_MKT_INFO_LOST@GSEDW T");
		sqlBuffer.append(" WHERE 1 = 1");
		if(!"".equals(village_id) && !"-1".equals(village_id)){
			sqlBuffer.append("  AND LEV6_ID = '"+village_id+"'");
		}

		if(!"".equals(build_id)){
			sqlBuffer.append("  AND address_id IN (");
			sqlBuffer.append("      SELECT segm_id_2 FROM gis_data.tb_gis_addr_info_all WHERE segm_id IN ( '"+build_id+"')");
			sqlBuffer.append("  )");
		}

		if("-1".equals(village_id)) {
			sqlBuffer.append("  AND address_id IN (");
			sqlBuffer.append("      SELECT segm_id FROM sde.TB_GIS_MAP_SEGM_LATN_MON where union_org_code='" + branch_no + "'");
			sqlBuffer.append("        and segm_id not in(select segm_id from gis_data.TB_GIS_VILLAGE_ADDR4)");
			sqlBuffer.append("  )");
		}

		sqlBuffer.append(" ORDER BY ADDRESS_ID");

		return  sqlBuffer.toString();
	}

	//城中村攻坚日报
	public String vicByDay_makeSql(HttpServletRequest request){
		//城市编码
		String city_id = request.getParameter("city_id");
		String acct_day = request.getParameter("beginDate");

		StringBuffer sqlBuffer = new  StringBuffer();

		sqlBuffer.append("SELECT LATN_ID,                                                        ");
		sqlBuffer.append("       LATN_NAME,                                                      ");
		sqlBuffer.append("       BUREAU_NO,                                                      ");
		sqlBuffer.append("       BUREAU_NAME,                                                    ");
		sqlBuffer.append("       UNION_ORG_CODE,                                                 ");
		sqlBuffer.append("       BRANCH_NAME,                                                    ");
		sqlBuffer.append("       GRID_ID,                                                        ");
		sqlBuffer.append("       GRID_NAME,                                                      ");
		sqlBuffer.append("       VILLAGE_ID,                                                     ");
		sqlBuffer.append("       VILLAGE_NAME,                                                   ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE_Y, 0) = 0 THEN                           ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE_Y * 100, 2), 'FM990.00') || '%'    ");
		sqlBuffer.append("       END FILTER_RATE_Y,                                              ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE_DAY, 0) = 0 THEN                         ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE_DAY * 100, 2), 'FM990.00') || '%'  ");
		sqlBuffer.append("       END FILTER_RATE_DAY,                                            ");
		sqlBuffer.append("       NVL(ADD_KD_CNT, 0) ADD_KD_CNT,                                  ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE, 0) = 0 THEN                             ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE * 100, 2), 'FM990.00') || '%'      ");
		sqlBuffer.append("       END FILTER_RATE,                                                ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE_M, 0) = 0 THEN                           ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE_M * 100, 2), 'FM990.00') || '%'    ");
		sqlBuffer.append("       END FILTER_RATE_M,                                              ");
		sqlBuffer.append("       NVL(LJ_ADD_KD_CNT, 0) LJ_ADD_KD_CNT,                            ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN JZ_CNT IS NULL THEN                                      ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(JZ_CNT * 100, 2), 'FM990.00') || '%'           ");
		sqlBuffer.append("       END JZ_CNT                                                      ");
		sqlBuffer.append("  FROM GIS_DATA.TB_GIS_VILLAGE_CITY_DAY AA,                            ");
		sqlBuffer.append("       EASY_DATA.CMCODE_AREA            FF                             ");
		sqlBuffer.append(" WHERE AA.LATN_ID = FF.AREA_NO                                         ");

		if(city_id!=null && !"".equals(city_id) && !"999".equals(city_id))
			sqlBuffer.append("   AND LATN_ID = "+city_id+"                                       ");

		sqlBuffer.append("   AND ACCT_DAY = '"+acct_day+"'                                       ");

		sqlBuffer.append(" ORDER BY FF.ORD,                                                      ");
		sqlBuffer.append("          AA.BUREAU_NO,                                                ");
		sqlBuffer.append("          AA.UNION_ORG_CODE,                                           ");
		sqlBuffer.append("          AA.GRID_ID,                                                  ");
		sqlBuffer.append("          AA.VILLAGE_ID                                                ");

		return  sqlBuffer.toString();
	}

	//白区反抢日报
	public String villageGrabByDay_makeSql(HttpServletRequest request){
		//城市编码
		String city_id = request.getParameter("city_id");
		String acct_day = request.getParameter("beginDate");

		StringBuffer sqlBuffer = new  StringBuffer();

		sqlBuffer.append("SELECT LATN_ID,                                                        ");
		sqlBuffer.append("       LATN_NAME,                                                      ");
		sqlBuffer.append("       BUREAU_NO,                                                      ");
		sqlBuffer.append("       BUREAU_NAME,                                                    ");
		sqlBuffer.append("       UNION_ORG_CODE,                                                 ");
		sqlBuffer.append("       BRANCH_NAME,                                                    ");
		sqlBuffer.append("       GRID_ID,                                                        ");
		sqlBuffer.append("       GRID_NAME,                                                      ");
		sqlBuffer.append("       VILLAGE_ID,                                                     ");
		sqlBuffer.append("       VILLAGE_NAME,                                                   ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE_Y, 0) = 0 THEN                           ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE_Y * 100, 2), 'FM990.00') || '%'    ");
		sqlBuffer.append("       END FILTER_RATE_Y,                                              ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE_DAY, 0) = 0 THEN                         ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE_DAY * 100, 2), 'FM990.00') || '%'  ");
		sqlBuffer.append("       END FILTER_RATE_DAY,                                            ");
		sqlBuffer.append("       NVL(ADD_KD_CNT, 0) ADD_KD_CNT,                                  ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE, 0) = 0 THEN                             ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE * 100, 2), 'FM990.00') || '%'      ");
		sqlBuffer.append("       END FILTER_RATE,                                                ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN NVL(FILTER_RATE_M, 0) = 0 THEN                           ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(FILTER_RATE_M * 100, 2), 'FM990.00') || '%'    ");
		sqlBuffer.append("       END FILTER_RATE_M,                                              ");
		sqlBuffer.append("       NVL(LJ_ADD_KD_CNT, 0) LJ_ADD_KD_CNT,                            ");
		sqlBuffer.append("       CASE                                                            ");
		sqlBuffer.append("         WHEN JZ_CNT IS NULL THEN                                      ");
		sqlBuffer.append("          '0.00%'                                                      ");
		sqlBuffer.append("         ELSE                                                          ");
		sqlBuffer.append("          TO_CHAR(ROUND(JZ_CNT * 100, 2), 'FM990.00') || '%'           ");
		sqlBuffer.append("       END JZ_CNT                                                      ");
		sqlBuffer.append("  FROM GIS_DATA.TB_GIS_FILTER_COMPARE_NEW_DAY AA,                      ");
		sqlBuffer.append("       EASY_DATA.CMCODE_AREA                  FF                       ");
		sqlBuffer.append(" WHERE AA.LATN_ID = FF.AREA_NO                                         ");
		if(city_id!=null && !"".equals(city_id) && !"999".equals(city_id))
			sqlBuffer.append("   AND LATN_ID = "+city_id+"                                     ");
		sqlBuffer.append("   AND ACCT_DAY = '"+acct_day+"'                                       ");
		sqlBuffer.append(" ORDER BY FF.ORD,                                                      ");
		sqlBuffer.append("          AA.BUREAU_NO,                                                ");
		sqlBuffer.append("          AA.UNION_ORG_CODE,                                           ");
		sqlBuffer.append("          AA.GRID_ID,                                                  ");
		sqlBuffer.append("          AA.VILLAGE_ID                                                ");

		return  sqlBuffer.toString();
	}
}
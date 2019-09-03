package cn.com.easy.down.client.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.CryptTool;
import cn.com.easy.taglib.function.Functions;

@Controller
public class ProvinceDataAction {
	private SqlRunner runner;

	//市场份额，累计份额，新增份额
	@Action("market_total_a")
	public void queryMarket_total(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		List<Map<String, String>> maplist = (List<Map<String, String>>) session.getAttribute("market_total_a");
		String flag1 = request.getParameter("flag1");
		//System.out.println(flag1);
		//判断浏览器是否刷新 1为刷新，查数据库  2为未刷新
		if (flag1.equals("1")) {
			String sql = "select " +
					"day_id, " +
					"region_id, " +
					"region_name," +
					" to_char(acc_rate_telecom,'999.00') acc_rate_telecom," +
					" to_char(add_rate_telecom,'999.00') add_rate_telecom" +
					" from GIS_DATA.GIS_KEY_MARKET_D t" +
					" where t.data_flag = 1";
			try {
				maplist = (List<Map<String, String>>) runner.queryForMapList(sql);
				session.setAttribute("market_total_a", maplist);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		/*String date = (String) session.getAttribute("date1");
		if (date == null || date.equals("")) {
			String sql = "select " +
					"min(const_value) date1 " +
					"from SYS_CONST_TABLE " +
					"where const_name = 'calendar.curdate' " +
					"and data_type = 'day' " +
					"and model_id = '1'";
			try {
				date = (String) runner.queryForMap(sql).get("date1");
				session.setAttribute("date1", date);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}*/
		String date = request.getParameter("date");
		String region_id = request.getParameter("region_id");
		Map<String, String> map = new HashMap<String, String>();
		for (Map<String, String> m : maplist) {
			if (m.get("day_id").equals(date)&&m.get("region_id").equals(region_id)) {
				map = m;
			}
		}
		//System.out.println(Functions.java2json(map));
		out(response, Functions.java2json(map));
	}

	//月累计份额
	@Action("month_acc_a")
	public void queryMonth_acc(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		List<Map<String, String>> maplist = null;
		String flag2 = request.getParameter("flag2");
		//System.out.println("flag2 "+flag2);
		//判断浏览器是否刷新 1为刷新，查数据库  2为未刷新
		if (flag2.equals("1")) {
			String sql = "select * " +
					"from GIS_DATA.TB_GIS_KEY_MARKET_MON " +
					"order by acct_month ";
			try {
				maplist = (List<Map<String, String>>) runner.queryForMapList(sql);
				session.setAttribute("month_acc_a", maplist);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else {
			maplist = (List<Map<String, String>>) session.getAttribute("month_acc_a");
		}
		int month_begin = Integer.parseInt(request.getParameter("month_begin"));
		int month_end = Integer.parseInt(request.getParameter("month_end"));
		String region_id = request.getParameter("region_id");
		List<Map<String, String>> mlist = new ArrayList<Map<String,String>>();
		for (Map<String, String> m : maplist) {
			if (m.get("region_id").equals(region_id) && Integer.parseInt(m.get("acct_month"))>=month_begin && Integer.parseInt(m.get("acct_month"))<=month_end) {
				mlist.add(m);
			}
		}
		//System.out.println(Functions.java2json(mlist));
		out(response, Functions.java2json(mlist));
	}

	//日新增份额
	@Action("day_add_a")
	public void queryDay_add(HttpServletRequest request, HttpServletResponse response) throws ParseException {
		HttpSession session = request.getSession();
		List<Map<String, String>> maplist = null;
		String flag3 = request.getParameter("flag3");
		//System.out.println("flag3 "+flag3);
		//判断浏览器是否刷新 1为刷新，查数据库  2为未刷新
		if (flag3.equals("1")) {
			String sql = "select " +
					"SUBSTR(DAY_ID, 7, 8) DAY_ID, " +
					"day_Id DA, " +
					"add_rate_telecom, " +
					"add_rate_moblie, " +
					"add_rate_union, " +
					"add_rate_dx, " +
					"add_rate_yd, " +
					"region_id, " +
					"add_rate_lt " +
					"from GIS_DATA.GIS_KEY_MARKET_D t " +
					"where t.data_flag = 1 " +
					"order by DA ";
			try {
				maplist = (List<Map<String, String>>) runner.queryForMapList(sql);
				session.setAttribute("day_add_a", maplist);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else {
			maplist = (List<Map<String, String>>) session.getAttribute("day_add_a");
		}
		String date = request.getParameter("date");
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		Date d = df.parse(date);
		String date2 = df.format(new Date(d.getTime() - 6 * 24 * 60 * 60 * 1000));
		String region_id = request.getParameter("region_id");

		List<Map<String, String>> mlist = new ArrayList<Map<String,String>>();
		for (Map<String, String> m : maplist) {
			if (m.get("region_id").equals(region_id)&&Integer.parseInt(m.get("DA"))>=Integer.parseInt(date2)&&Integer.parseInt(m.get("DA"))<=Integer.parseInt(date)) {
				mlist.add(m);
			}
		}
		//System.out.println(Functions.java2json(mlist));
		out(response, Functions.java2json(mlist));
	}

	//支局网格列表查询
	@Action("querysubgrid")
	public void querysubgrid(HttpServletRequest request, HttpServletResponse response) {
	    String latn_id=request.getParameter("city_id");
	    String bureau_id=request.getParameter("id");
		String sub_id = request.getParameter("substation");
	    String words=request.getParameter("branch_name");
		String where_city_id="";
		String where_bureau_id="";
		String where_bn="";
		String where_sub_id = "";
		if(latn_id!=null&&!latn_id.equals("")){
			where_city_id="and t.latn_id="+latn_id+" ";
		}
		if(bureau_id!=null&&!bureau_id.equals("")){
			where_bureau_id="and t.bureau_no="+bureau_id+ " ";
		}
		if(words!=null&&!words.equals("")){
			where_bn="and t.branch_name like '%"+words+ "%' ";
		}
		if(sub_id!=null && !sub_id.equals("")){
			where_sub_id = "and t.union_org_code = "+sub_id+" ";
		}

		String sql = "SELECT ROWNUM,"+
       "M.LATN_ID,"+
       "M.LATN_NAME,"+
       "M.BRANCH_NO,"+
       "M.BRANCH_NAME,"+
       "N.FLAG,"+
       "NVL(N.GRID_NUM, '(0)') GRID_NUM,"+
       "M.UNION_ORG_CODE,"+
       "M.BRANCH_SHOW,"+
       "M.BRANCH_TYPE,"+
       "CASE"+
       "  WHEN M.BRANCH_TYPE = 'a1' THEN"+
       "   '城市'"+
       "  WHEN M.BRANCH_TYPE = 'b1' THEN"+
       "   '农村'"+
       " END BRANCH_TYPE_CHAR,"+
       " M.ZOOM"+
  " FROM (SELECT DISTINCT LATN_ID,"+
                       " LATN_NAME,"+
                       " BRANCH_NO,"+
                       " BRANCH_NAME,"+
                       " REGION_ORDER_NUM,"+
                       " UNION_ORG_CODE,"+
                       " BRANCH_TYPE,"+
                       " ZOOM,"+
                       " BRANCH_SHOW"+
         " FROM GIS_DATA.DB_CDE_GRID T"+
        " WHERE 1=1"+
         	" AND BRANCH_TYPE IN ('a1', 'b1')"+
			" AND GRID_STATUS = 1 "+
         	where_city_id+where_bureau_id+where_bn+where_sub_id+
          " ) M"+
 " LEFT JOIN （"+
 " SELECT A.LATN_ID,"+
      " A.LATN_NAME,"+
      " A.BRANCH_NO,"+
      " A.BRANCH_NAME,"+
      " A.FLAG,"+
       " CASE"+
         " WHEN A.FLAG = 1 or a.grid_num = 0 THEN"+
          " '(' || A.GRID_NUM || ')'"+
         " ELSE "+
          " '(' || A.GRID_SHOWNUM || '/' || A.GRID_NUM || ')'"+
       " END GRID_NUM,"+
       " A.UNION_ORG_CODE,"+
       " A.BRANCH_SHOW,"+
       " A.BRANCH_TYPE,"+
       " CASE"+
         " WHEN A.BRANCH_TYPE = 'a1' THEN"+
          " '城市'"+
         " WHEN A.BRANCH_TYPE = 'b1' THEN"+
          " '农村'"+
       " END BRANCH_TYPE_CHAR,"+
       " A.ZOOM"+
  " FROM (SELECT T.LATN_ID,"+
               " T.LATN_NAME,"+
               " T.BRANCH_NO,"+
               " T.BRANCH_NAME,"+
               " T.REGION_ORDER_NUM,"+
               " T.UNION_ORG_CODE,"+
               " T.BRANCH_TYPE,"+
               " T.ZOOM,"+
               " T.BRANCH_SHOW,"+
               " COUNT(DISTINCT DECODE(grid_union_org_code,-1,null,grid_id)) GRID_NUM,"+
               " COUNT(DISTINCT CASE"+
                       " WHEN GRID_SHOW = 1 THEN"+
                        " GRID_ID"+
                     " END) GRID_SHOWNUM,"+
               " COUNT(DISTINCT CASE"+
                       " WHEN GRID_SHOW = 1 THEN"+
                        " GRID_ID"+
                     " END) / COUNT(DISTINCT GRID_ID) FLAG"+
		 " FROM GIS_DATA.DB_CDE_GRID T"+
         " WHERE 1=1"+
         	 " AND T.GRID_UNION_ORG_CODE IS NOT NULL"+
           " AND T.BRANCH_TYPE IN ('a1', 'b1')"+
           " AND GRID_STATUS = 1"+
           where_city_id+where_bureau_id+where_bn+where_sub_id+
         " GROUP BY T.LATN_ID,"+
                  " T.LATN_NAME,"+
                  " BRANCH_NO,"+
                  " BRANCH_NAME,"+
                  " T.REGION_ORDER_NUM,"+
                  " T.UNION_ORG_CODE,"+
                  " T.BRANCH_SHOW,"+
                  " T.BRANCH_TYPE,"+
                  " T.ZOOM,"+
                  " T.BRANCH_SHOW) A"+
 		" ORDER BY A.BRANCH_SHOW DESC, A.FLAG DESC, A.REGION_ORDER_NUM ） N"+
    	" ON M.UNION_ORG_CODE = N.UNION_ORG_CODE order by branch_type";
		List<Map<String, String>> maplist = new ArrayList<Map<String,String>>();
		Map<String, String> mapq = new HashMap<String, String>();
		String city_id = request.getParameter("city_id");
		Map<String, String> map = new HashMap<String, String>();
		map.put("city_id", city_id);
		String sql2 = "select count(distinct t.branch_no) count1, count(distinct case when branch_type = 'a1' then  t.branch_no end) count2,count(distinct case when branch_type = 'b1' then t.branch_no end) count3," +
				"count(distinct case when branch_show = 0 then branch_no end) count4,  count(distinct grid_id) count5, count(distinct case when grid_show = 0 then grid_id end) count6 " +
				"from GIS_DATA.DB_CDE_GRID t  where t.branch_type in ('a1','b1') "+where_city_id+where_bureau_id+where_bn;
				//t.grid_union_org_code is not  null and grid_status =1  and
		try {
			maplist = (List<Map<String, String>>) runner.queryForMapList(sql,map);
			mapq = (Map<String, String>) runner.queryForMap(sql2,map);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		List l = new ArrayList();
		l.add(maplist);
		l.add(mapq);
		out(response, Functions.java2json(l));
	}

	//楼宇详表，房间矩阵
	@Action("villageAll")
	public void queryVillageAll(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		List<Map<String, String>> maplist = null;
		String res_id = request.getParameter("res_id");
		String village_id = request.getParameter("village_id");
		String check_val = request.getParameter("check_val");
		String check_bussiness_val = request.getParameter("check_bussiness_val");
		String contains_uninstall = request.getParameter("contains_uninstall");
		System.out.println("contains_uninstall:" + contains_uninstall);
		String contains_dx = request.getParameter("contains_dx");
		String is_kd = check_val.indexOf("kd") > -1 ? "" : null;
		String is_ds = check_val.indexOf("itv") > -1 ? "" : null;
		String is_gh = check_val.indexOf("gh") > -1 ? "" : null;

		String sql_temp = "";
		if (is_kd == null && is_ds == null && is_gh == null) {

		} else {
			sql_temp = " and (1!=1 ";
			if (is_kd != null)
				sql_temp += " or a.is_kd_dx > 0 ";
			if (is_ds != null)
				sql_temp += " or a.is_itv > 0 ";
			if (is_gh != null)
				sql_temp += " or a.is_gu > 0 ";
			sql_temp += ")";
		}

		String sql =
				"select " +
				"a.*," +
					/*"o.stand_name,"*/
				"a.stand_name_2 stand_name," +
				"nvl(nvl(b.PEOPLE_COUNT || '',w.PEOPLE_COUNT),'0') PEOPLE_COUNT," +
				"nvl(b.income_avg || '',' ') INCOME_AVG," +
					/*"nvl(b.IS_GU_CMCC,0) IS_GU_CMCC," +
					"nvl(b.IS_KD_CMCC,0) IS_KD_CMCC," +
					"nvl(b.IS_YD_CMCC||'',' ') IS_YD_CMCC," +
					"nvl(b.IS_ITV_CMCC,0) IS_ITV_CMCC," +
					"nvl(b.IS_GU_LT,0) IS_GU_LT," +
					"nvl(b.IS_KD_LT,0) IS_KD_LT," +
					"nvl(b.IS_YD_LT||'',' ') IS_YD_LT," +
					"nvl(b.IS_ITV_LT,0) IS_ITV_LT, " +*/
				"nvl(b.DX_CONTACT_PERSON || '',a.USER_CONTACT_PERSON) DX_CONTACT_PERSON," +
				"nvl(b.DX_CONTACT_NBR || '',a.USER_CONTACT_NBR) DX_CONTACT_NBR," +
				"nvl(b.CMCC_CONTACT_PERSON||'',' ') CMCC_CONTACT_PERSON," +
				"nvl(b.CMCC_CONTACT_NBR||'',' ') CMCC_CONTACT_NBR," +
				"nvl(b.LT_CONTACT_PERSON||'',' ') LT_CONTACT_PERSON," +
				"nvl(b.LT_CONTACT_NBR||'',' ') LT_CONTACT_NBR," +

				"case when a.is_itv > 0 then '已装' else ' ' end is_itv_text, " +
				"case when b.is_kd_dx > 0 then '已装' else ' ' end is_kd_text, " +
				"nvl(a.broad_mode,' ')broad_mode, " +
				"nvl(a.broad_rate,' ')broad_rate, " +
				"case when a.is_gu > 0 then '已装' else ' ' end is_gu_text, " +
				"nvl(a.gu_acc_nbr,' ') gu_acc_nbr, " +
				"nvl(nvl(nvl(a.rh_offer_name,a.plan_offer_name),main_offer_name),' ') main_offer_name, " +
				//"nvl(b.operators_type,0) operators_type,"+
				//"case when b.operators_type=1 then '移动' when b.operators_type=2 then '联通' when b.operators_type=3 then '广电' else ' ' end operators_type_text, "+
				"CASE WHEN KD_BUSINESS = '1' THEN '移动'" +
				"WHEN KD_BUSINESS = '2' THEN '联通'     " +
				"WHEN KD_BUSINESS = '3' THEN '广电'     " +
				"WHEN KD_BUSINESS = '4' THEN '其他'     " +
				"WHEN itv_business = '1' THEN '移动'    " +
				"WHEN itv_business = '2' THEN '联通'    " +
				"WHEN itv_business = '3' THEN '广电'    " +
				"WHEN itv_business = '4' THEN '其他'    " +
				"WHEN phone_business = '1' THEN '移动'  " +
				"WHEN phone_business = '2' THEN '联通'  " +
				"WHEN phone_business1 = '1' THEN '移动' " +
				"WHEN phone_business1 = '2' THEN '联通' " +
				"WHEN phone_business2 = '1' THEN '移动' " +
				"WHEN phone_business2 = '2' THEN '联通' " +
				"ELSE ' ' END operators_type_text,      " +
				"nvl(comments,' ') comments, " +
				"case when c.address_id is not null then '有' else ' ' end is_yx, " +
				"c.prod_inst_id, " +
				"b.contact_person," +
				"b.contact_nbr," +
				"b.people_count people_count1,b.dx_comments, " +
				"b.kd_nbr,b.kd_business,b.kd_xf,b.kd_dq_date, " +
				"b.itv_nbr,b.itv_business,b.itv_xf,b.itv_dq_date, " +
				"b.phone_nbr,b.phone_business,b.phone_xf,b.phone_dq_date, " +
				"b.phone_nbr1,b.phone_business1,b.phone_xf1,b.phone_dq_date1, " +
				"b.phone_nbr2,b.phone_business2,b.phone_xf2,b.phone_dq_date2, " +
				"b.kd_nbr,b.kd_business,b.kd_xf,b.kd_dq_date, " +
				"b.itv_nbr,b.itv_business,b.itv_xf,b.itv_dq_date, " +
				"b.SERIAL_NO " +
				//"case when c.did_flag is null then 1 else 0 end is_yx " +
				"from " +
				"GIS_DATA.TB_GIS_ADDR_INFO_ALL a " +
				"left join (select distinct address_id,max(prod_inst_id) prod_inst_id from GIS_DATA.TB_GIS_BROADBD_YX_D where did_flag is null group by address_id) c on a.segm_id_2 = c.address_id," +
					/*GIS_DATA.TB_GIS_ADDR4_INFO o,*/
				//"left join gis_data.TB_GIS_BROADBD_YX_D c on a.segm_id = c.segm_id," +
				"GIS_DATA.TB_GIS_ADDR_OTHER_ALL b,GIS_DATA.TB_GIS_ADDR_INFO_VIEW w " +
				"" +
				"where 1=1 and " +
				"a.SEGM_ID= '" + res_id + "' " +
				"and a.SEGM_ID_2 = b.SEGM_ID_2 " +
					/*"and a.SEGM_ID=o.SEGM_ID "+*/
				"and a.SEGM_ID = b.SEGM_ID " +
				"and a.SEGM_ID = w.SEGM_ID ";
		sql += sql_temp;
		if (!"".equals(check_bussiness_val)) {
			if ("0".equals(contains_dx))
				sql += "and ( b.KD_BUSINESS in (" + check_bussiness_val + ") or b.ITV_BUSINESS in (" + check_bussiness_val + ")  ";
			else
				sql += "and ( b.KD_BUSINESS in (" + check_bussiness_val + ") or b.ITV_BUSINESS in (" + check_bussiness_val + ") or a.is_kd_dx > 0  ";
			if ("0".equals(contains_uninstall))
				sql += " )";
			else
				sql += "or nvl(a.is_kd_dx,0) < 1 )";
		} else if ("1".equals(contains_dx)) {
			if ("0".equals(contains_uninstall))
				sql += "and a.is_kd_dx > 0 ";
			else
				sql += "and (a.is_kd_dx > 0 or nvl(a.is_kd_dx,0) < 1) ";
		} else if ("1".equals(contains_uninstall)) {
			sql += "and nvl(a.is_kd_dx,0) < 1 ";
		}

		sql += " ORDER BY length(a.SEGM_NAME_2)asc, a.SEGM_NAME_2 asc";
		System.out.println("villageAll："+sql);
		try {
			maplist = (List<Map<String, String>>) runner.queryForMapList(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		List<List<Map<String, String>>> list2 = new ArrayList<List<Map<String, String>>>();
		//设置第一个层号
		String i = "";
		if (maplist != null && maplist.size() > 0) {
			if (maplist.get(0).get("SEGM_NAME_2").length() > 2) {
				i = maplist.get(0).get("SEGM_NAME_2").substring(0, maplist.get(0).get("SEGM_NAME_2").length() - 2);
			}
		}
		List<Map<String, String>> mlist = null;
		mlist = new ArrayList<Map<String, String>>();
		int j = 0;
		for (Map<String, String> map : maplist) {
			j++;
			if (map.get("SEGM_NAME_2").length() > 2) {
				String segm_name = map.get("SEGM_NAME_2").substring(0, map.get("SEGM_NAME_2").length() - 2);
				if (segm_name.equals(i)) {
					//同层
					mlist.add(map);
				} else {
					//不同层
					i = segm_name;
					list2.add(mlist);
					mlist = new ArrayList<Map<String, String>>();
					mlist.add(map);
				}
			} else {
				mlist.add(map);
			}
		}
		list2.add(mlist);
		//System.out.println(Functions.java2json(list2));
		out(response, Functions.java2json(list2));
	}

	@Action("crmUrl")
	public void getCrmUrl(HttpServletRequest request, HttpServletResponse response) {
		try{
			String user_id = request.getParameter("user_id");
			String cust_name = java.net.URLDecoder.decode(request.getParameter("cust_name"), "UTF-8");
			System.out.println("utf8 cust_name:"+cust_name);
			System.out.println("no_decode cust_name:"+request.getParameter("cust_name"));
			String address = java.net.URLDecoder.decode(request.getParameter("address"), "UTF-8");
			String accnbr = java.net.URLDecoder.decode(request.getParameter("accnbr"), "UTF-8");
			String broadband = java.net.URLDecoder.decode(request.getParameter("broadband"), "UTF-8");
			String bus_type = request.getParameter("bus_type");
			Map<String,String> map = new HashMap<String,String>();
			map.put("user_id",user_id);
			map.put("cust_name",cust_name);
			map.put("address",address);
			map.put("accnbr",accnbr);
			map.put("broadband",broadband);
			map.put("bus_type",bus_type);
			out(response, CryptTool.getReqParam(map));
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	@Action("crmUrl2019")
	public void getCrmUrl2019(HttpServletRequest request,HttpServletResponse response){
		try{
			String menuCode = request.getParameter("menuCode");//固定值 Mxqt2018002
			String userCode = request.getParameter("userCode");//316666
			String lanId = request.getParameter("lanId");//938
			String externSystemCode = request.getParameter("externSystemCode");//固定值10000
			String signTimestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());//"20190626173541";
			String externSignKey = request.getParameter("externSignKey");//固定值xqt20181207
			//String model = "";
			String mktCamCateId = request.getParameter("mktCamCateId");
			String isSupportAccept = request.getParameter("isSupportAccept");
			Map paramMap = new HashMap();//SQL参数
			paramMap.put("mktCamCateId", mktCamCateId);
			paramMap.put("isSupportAccept", isSupportAccept);
			Map<String,String> res = runner.queryForMap(getSubMenuCode,paramMap);
			String subMenuCode = "";
			if(res!=null)
				subMenuCode = String.valueOf(res.get("subMenuCode"));//additionalCard PreAccept sales
			Map<String,String> map = new HashMap<String,String>();
			map.put("menuCode",menuCode);
			map.put("userCode",userCode);
			map.put("lanId",lanId);
			map.put("externSystemCode",externSystemCode);
			map.put("signTimestamp",signTimestamp);
			map.put("externSignKey",externSignKey);

			out(response, subMenuCode+"_"+signTimestamp+"_"+CryptTool.getReqParam2019(map));
		}catch(Exception e){
			e.printStackTrace();
		}
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
	private String getSubMenuCode = "select subMenuCode from gis_data.tb_gis_yx_menu_code where mktCamCateId = #mktCamCateId# and isSupportAccept = #isSupportAccept#";
}

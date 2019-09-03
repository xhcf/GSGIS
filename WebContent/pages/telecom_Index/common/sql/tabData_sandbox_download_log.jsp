<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:switch value="${param.eaction}">
  <e:description>宽带家庭渗透率导出操作日志</e:description>
   <e:case value="insertLog">
             <e:q4o var="seqNO">
		    		SELECT SYS_GUID() || '' VAL FROM DUAL 
			</e:q4o>     
            <e:update var="insertLogCnt">
                      INSERT INTO
                             ${gis_user}.TB_GIS_EXP_LOGS
                                (
                                    IDN, 
                                    RPT_NAME, 
                                    EXP_FILENAME,
                                    EXP_OPR, 
                                    EXP_TIME, 
                                    EXP_STATUS                                     
                                )
                                VALUES
                                (
                                     '${seqNO.VAL}',
                                     #rpt_name#,
                                     #exp_filename#,
                                     '${sessionScope.UserInfo.USER_ID}',
                                     SYSDATE,
                                     #exp_status#                                  
                                )  
            </e:update>${insertLogCnt}                
    </e:case>
</e:switch>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<e:switch value="${param.eaction}">
  <e:case value="getVailBase">
    <e:q4o var="dataObject">
      SELECT sys_guid()||'' idn,trunc(dbms_random.value(100000,999999)) vailCode  FROM DUAL
    </e:q4o>${e:java2json(dataObject)}
  </e:case>

  <e:case value="insertMsgData">
    <e:update>
      begin

	  <e:description>
      insert into ora_etl.tb_sms_main@rtap_sms
        (
        month_no,
        local_code,
        tb_sms_content,
        calling_acc_nbr,
        send_time,
        send_timing,
        error_info
        )
        select TO_CHAR(sysdate,'YYYYMM'),
        '931',
        '您的验证码为:'|| ${param.vailCode} ||',该验证码有效期为1分钟。(来自GIS校园沙盘的消息)',
        '${param.phone}',
        sysdate + 1/(60*60),
        '',
        '东方国信'
        from dual;
      </e:description>

        insert into e_sms_logs
        select '${param.idn}','${param.phone}',sysdate,${param.vailCode},'${param.login_id}','GIS校园沙盘' from dual;
      end;
    </e:update>
  </e:case>
</e:switch>
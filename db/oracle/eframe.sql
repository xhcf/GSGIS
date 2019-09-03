-----------------------------------------------
-- Export file for user DXFRAMEWORK          --
-- Created by zuobin on 2016/12/13, 14:03:56 --
-----------------------------------------------

spool xbuilder.log

prompt
prompt Creating table CMCODE_AREA
prompt ==========================
prompt
create table CMCODE_AREA
(
  AREA_NO   VARCHAR2(10),
  AREA_DESC VARCHAR2(50),
  ORD       VARCHAR2(8)
)
;

prompt
prompt Creating table CMCODE_CITY
prompt ==========================
prompt
create table CMCODE_CITY
(
  AREA_NO   VARCHAR2(4),
  CITY_NO   VARCHAR2(8),
  CITY_DESC VARCHAR2(50),
  ORD       VARCHAR2(8),
  AREA_DESC VARCHAR2(50)
)
;

prompt
prompt Creating table D_SUBSYSTEM
prompt ==========================
prompt
create table D_SUBSYSTEM
(
  SUBSYSTEM_ID       VARCHAR2(30),
  SUBSYSTEM_NAME     VARCHAR2(50),
  SUBSYSTEM_ADDRESS  VARCHAR2(200),
  SUBSYSTEM_IP       VARCHAR2(30),
  SIMULATION_ADDRESS VARCHAR2(200),
  STATE              VARCHAR2(2),
  ORD                NUMBER,
  CONTACTS           VARCHAR2(30),
  PHONE              VARCHAR2(20),
  E_MAIL             VARCHAR2(30),
  SUBSYSTEM_ADDRESS2 VARCHAR2(200),
  SUBSYSTEM_IP2      VARCHAR2(30),
  REMARK             VARCHAR2(200),
  CREATE_USER        VARCHAR2(30),
  CREATE_TIME        VARCHAR2(50),
  MODIFY_USER        VARCHAR2(30),
  MODIFY_TIME        VARCHAR2(50)
)
;
comment on table D_SUBSYSTEM
  is '��ϵͳ����';
comment on column D_SUBSYSTEM.SUBSYSTEM_ID
  is '��ϵͳ����';
comment on column D_SUBSYSTEM.SUBSYSTEM_NAME
  is '��ϵͳ����';
comment on column D_SUBSYSTEM.SUBSYSTEM_ADDRESS
  is '��ϵͳ���ʵ�ַ';
comment on column D_SUBSYSTEM.SUBSYSTEM_IP
  is '��ϵͳ���ʵ�ַIP';
comment on column D_SUBSYSTEM.SIMULATION_ADDRESS
  is 'ģ���¼��ַ';
comment on column D_SUBSYSTEM.STATE
  is '״̬   1����Ч  0����Ч';
comment on column D_SUBSYSTEM.ORD
  is '����';
comment on column D_SUBSYSTEM.CONTACTS
  is '��ϵͳ��ϵ��';
comment on column D_SUBSYSTEM.PHONE
  is '��ϵ�绰';
comment on column D_SUBSYSTEM.E_MAIL
  is '��������';
comment on column D_SUBSYSTEM.SUBSYSTEM_ADDRESS2
  is '��ϵͳ���ʵ�ַ2';
comment on column D_SUBSYSTEM.SUBSYSTEM_IP2
  is '��ϵͳ���ʵ�ַIP2';
comment on column D_SUBSYSTEM.REMARK
  is '��ע';
comment on column D_SUBSYSTEM.CREATE_USER
  is '������';
comment on column D_SUBSYSTEM.CREATE_TIME
  is '����ʱ��';
comment on column D_SUBSYSTEM.MODIFY_USER
  is '�޸���';
comment on column D_SUBSYSTEM.MODIFY_TIME
  is '�޸�ʱ��';

prompt
prompt Creating table E_COMP_EXTEND_BTN
prompt ================================
prompt
create table E_COMP_EXTEND_BTN
(
  COMP_ID           VARCHAR2(100),
  COMP_NAME         VARCHAR2(30),
  BTN_NAME          VARCHAR2(30),
  BTN_ICON          VARCHAR2(200),
  CALL_URL          VARCHAR2(100),
  CALL_TARGET       VARCHAR2(30),
  SHOW_SELECT_FIELD VARCHAR2(2)
)
;
comment on column E_COMP_EXTEND_BTN.COMP_ID
  is '�����ڹ���id';
comment on column E_COMP_EXTEND_BTN.COMP_NAME
  is '��������';
comment on column E_COMP_EXTEND_BTN.BTN_NAME
  is '��ť���ƣ�����ʾ�ã���ֱ����ʾ';
comment on column E_COMP_EXTEND_BTN.BTN_ICON
  is '��ʾ��ͼ�꣬icon-download-excel��icon-download-excel2���ظ�����icon-download-pdf';
comment on column E_COMP_EXTEND_BTN.CALL_URL
  is '�����ťҪ����ĵ�ַ����ʼû��/����user.e��user.e?name=334444=xx';
comment on column E_COMP_EXTEND_BTN.CALL_TARGET
  is 'open��replace��ajax��form������ʱ����Ŀǰ֧��form��ʽ';
comment on column E_COMP_EXTEND_BTN.SHOW_SELECT_FIELD
  is '�Ƿ񵯳�ѡ���в˵�,1�ǣ�0�񣬵��������ѡ����';

prompt
prompt Creating table E_DEPARTMENT
prompt ===========================
prompt
create table E_DEPARTMENT
(
  DEPART_CODE VARCHAR2(20),
  DEPART_DESC VARCHAR2(20),
  PARENT_CODE VARCHAR2(20)
)
;
comment on table E_DEPARTMENT
  is '�ַ�����';
comment on column E_DEPARTMENT.DEPART_CODE
  is '���ű���';
comment on column E_DEPARTMENT.DEPART_DESC
  is '��������';
comment on column E_DEPARTMENT.PARENT_CODE
  is '�ϼ����ű���';

prompt
prompt Creating table E_EXPORTING_INFO
prompt ===============================
prompt
create table E_EXPORTING_INFO
(
  ID             VARCHAR2(32),
  FILE_NAME      VARCHAR2(200),
  STATUS_ID      CHAR(2),
  FILE_PATH      VARCHAR2(300),
  OPT_USER       VARCHAR2(30),
  OPT_TIME       VARCHAR2(50),
  SYSTEM_FLAG    VARCHAR2(100),
  FILE_TYPE      VARCHAR2(32),
  DOWN_PARAM_STR VARCHAR2(1000)
)
;
comment on table E_EXPORTING_INFO
  is '������Ϣ��';
comment on column E_EXPORTING_INFO.ID
  is '����';
comment on column E_EXPORTING_INFO.FILE_NAME
  is '�ļ�����';
comment on column E_EXPORTING_INFO.STATUS_ID
  is '״̬';
comment on column E_EXPORTING_INFO.FILE_PATH
  is '�ļ����·��';
comment on column E_EXPORTING_INFO.OPT_USER
  is '�����û�';
comment on column E_EXPORTING_INFO.OPT_TIME
  is '����ʱ��';
comment on column E_EXPORTING_INFO.SYSTEM_FLAG
  is '�ͻ��˱�ʶ';
comment on column E_EXPORTING_INFO.FILE_TYPE
  is '�ļ�����';
comment on column E_EXPORTING_INFO.DOWN_PARAM_STR
  is '��ѯ�����ַ���';

prompt
prompt Creating table E_EXPORT_LOG
prompt ===========================
prompt
create table E_EXPORT_LOG
(
  ID           VARCHAR2(32),
  EXPORTING_ID VARCHAR2(32),
  STATUS_ID    CHAR(2),
  OPT_TIME     VARCHAR2(50)
)
;
comment on table E_EXPORT_LOG
  is '������־��';
comment on column E_EXPORT_LOG.ID
  is '����';
comment on column E_EXPORT_LOG.EXPORTING_ID
  is '������Ϣ����';
comment on column E_EXPORT_LOG.STATUS_ID
  is '״̬����';
comment on column E_EXPORT_LOG.OPT_TIME
  is '����ʱ��';

prompt
prompt Creating table E_EXPORT_QUEUE_DATA
prompt ==================================
prompt
create table E_EXPORT_QUEUE_DATA
(
  ID         VARCHAR2(32),
  QUEUE_DATA CLOB
)
;
comment on table E_EXPORT_QUEUE_DATA
  is '����������Ϣ��';
comment on column E_EXPORT_QUEUE_DATA.ID
  is '����';
comment on column E_EXPORT_QUEUE_DATA.QUEUE_DATA
  is '������Ϣ����';

prompt
prompt Creating table E_EXPORT_STATUS
prompt ==============================
prompt
create table E_EXPORT_STATUS
(
  STATUS_ID   CHAR(2),
  STATUS_NAME VARCHAR2(200),
  ORD         NUMBER
)
;
comment on table E_EXPORT_STATUS
  is '����״̬���';
comment on column E_EXPORT_STATUS.STATUS_ID
  is '����״̬����';
comment on column E_EXPORT_STATUS.STATUS_NAME
  is '����״̬����';
comment on column E_EXPORT_STATUS.ORD
  is '����';

prompt
prompt Creating table E_EXT_DATASOURCE
prompt ===============================
prompt
create table E_EXT_DATASOURCE
(
  DS_CN_NAME               VARCHAR2(100),
  DS_NAME                  VARCHAR2(100),
  DB_TYPE                  VARCHAR2(10),
  DS_TYPE                  VARCHAR2(10),
  DRIVER_CLASS_NAME        VARCHAR2(100),
  URL                      VARCHAR2(200),
  USER_NAME                VARCHAR2(100),
  PASSWORD                 VARCHAR2(100),
  INITIAL_SIZE             VARCHAR2(20),
  MIN_IDLE                 VARCHAR2(20),
  MAX_IDLE                 VARCHAR2(20),
  MAX_ACTIVE               VARCHAR2(20),
  MAX_WAIT                 VARCHAR2(20),
  REMOVE_ABANDONED         VARCHAR2(20),
  REMOVE_ABANDONED_TIMEOUT VARCHAR2(20),
  TIME_BWT_EVN_MILLIS      VARCHAR2(20),
  TEST_WHILE_IDLE          VARCHAR2(20),
  VALIDATION_QUERY         VARCHAR2(200),
  STATUS                   VARCHAR2(20),
  CREATE_TIME              VARCHAR2(20),
  CREATE_USER              VARCHAR2(20)
)
;
comment on table E_EXT_DATASOURCE
  is '�����չ����Դ';
comment on column E_EXT_DATASOURCE.DS_CN_NAME
  is '����Դ��������';
comment on column E_EXT_DATASOURCE.DS_NAME
  is '����Դ����';
comment on column E_EXT_DATASOURCE.DB_TYPE
  is '���ݿ�����';
comment on column E_EXT_DATASOURCE.DS_TYPE
  is '����Դ�������ͣ�dbcp��c3p0';
comment on column E_EXT_DATASOURCE.INITIAL_SIZE
  is '��ʼ��������';
comment on column E_EXT_DATASOURCE.MIN_IDLE
  is '��С����������';
comment on column E_EXT_DATASOURCE.MAX_IDLE
  is '������������';
comment on column E_EXT_DATASOURCE.MAX_ACTIVE
  is '���������';
comment on column E_EXT_DATASOURCE.MAX_WAIT
  is '���ȴ�ʱ�䣬����';
comment on column E_EXT_DATASOURCE.REMOVE_ABANDONED
  is '�Ƿ��Զ����ճ�ʱ����';
comment on column E_EXT_DATASOURCE.REMOVE_ABANDONED_TIMEOUT
  is '��ʱʱ�䣬��';
comment on column E_EXT_DATASOURCE.TIME_BWT_EVN_MILLIS
  is '��֤�����ӳ�ȡ�������ӣ�time_between_evictionruns_millis';
comment on column E_EXT_DATASOURCE.TEST_WHILE_IDLE
  is '��֤�����ӳ�ȡ��������';
comment on column E_EXT_DATASOURCE.VALIDATION_QUERY
  is '��֤�����ӳ�ȡ��������';
comment on column E_EXT_DATASOURCE.STATUS
  is '״̬��Ĭ��1��ͣ�ú�Ϊ0';
comment on column E_EXT_DATASOURCE.CREATE_TIME
  is '����ʱ��';
comment on column E_EXT_DATASOURCE.CREATE_USER
  is '������';
create unique index DS_KEY on E_EXT_DATASOURCE (DS_NAME);

prompt
prompt Creating table E_IND_EXP
prompt ========================
prompt
create table E_IND_EXP
(
  IND_ID   VARCHAR2(20),
  IND_NAME VARCHAR2(20)
)
;
comment on table E_IND_EXP
  is 'ָ��';
comment on column E_IND_EXP.IND_ID
  is 'ָ�����';
comment on column E_IND_EXP.IND_NAME
  is 'ָ������';

prompt
prompt Creating table E_IND_EXP_DETAILS
prompt ================================
prompt
create table E_IND_EXP_DETAILS
(
  ID              VARCHAR2(20),
  IND_ID          VARCHAR2(20),
  IND_TYPE_CODE   VARCHAR2(20),
  BUS_EXP         VARCHAR2(2000),
  SKILL_EXP       VARCHAR2(2000),
  OTHER_EXP       VARCHAR2(2000),
  ORD             VARCHAR2(20),
  DEPARTMENT_CODE VARCHAR2(20),
  FACTORY_CON     VARCHAR2(20),
  MAINTE_MAN      VARCHAR2(20),
  CREATE_MAN      VARCHAR2(20),
  CREATE_TIME     VARCHAR2(50),
  UPDATE_MAN      VARCHAR2(20),
  UPDATE_TIME     VARCHAR2(50),
  IND_CODE        VARCHAR2(20)
)
;
comment on table E_IND_EXP_DETAILS
  is 'ָ���������';
comment on column E_IND_EXP_DETAILS.ID
  is 'ID';
comment on column E_IND_EXP_DETAILS.IND_ID
  is 'ָ�����';
comment on column E_IND_EXP_DETAILS.IND_TYPE_CODE
  is 'ָ�����ͱ���';
comment on column E_IND_EXP_DETAILS.BUS_EXP
  is 'ҵ�����';
comment on column E_IND_EXP_DETAILS.SKILL_EXP
  is '��������';
comment on column E_IND_EXP_DETAILS.OTHER_EXP
  is '��������';
comment on column E_IND_EXP_DETAILS.ORD
  is '����';
comment on column E_IND_EXP_DETAILS.DEPARTMENT_CODE
  is '�ַ�������ű��';
comment on column E_IND_EXP_DETAILS.FACTORY_CON
  is '����ȷ����';
comment on column E_IND_EXP_DETAILS.MAINTE_MAN
  is 'ά����';
comment on column E_IND_EXP_DETAILS.CREATE_MAN
  is '������';
comment on column E_IND_EXP_DETAILS.CREATE_TIME
  is '����ʱ��';
comment on column E_IND_EXP_DETAILS.UPDATE_MAN
  is '�޸���';
comment on column E_IND_EXP_DETAILS.UPDATE_TIME
  is '�޸�ʱ��';
comment on column E_IND_EXP_DETAILS.IND_CODE
  is 'ָ����';

prompt
prompt Creating table E_IND_TYPE
prompt =========================
prompt
create table E_IND_TYPE
(
  IND_TYPE_CODE VARCHAR2(20),
  IND_TYPE_DESC VARCHAR2(20)
)
;

prompt
prompt Creating table E_LOGIN_LOG
prompt ==========================
prompt
create table E_LOGIN_LOG
(
  SESSION_ID     VARCHAR2(100) not null,
  STATE          NUMBER(1),
  USER_ID        VARCHAR2(30),
  CLIENT_IP      VARCHAR2(50),
  LOGIN_DATE     VARCHAR2(50),
  LOGOUT_DATE    VARCHAR2(50),
  CLIENT_BROWSOR VARCHAR2(1000)
)
;
comment on table E_LOGIN_LOG
  is '��¼��־';
comment on column E_LOGIN_LOG.SESSION_ID
  is '�ỰID';
comment on column E_LOGIN_LOG.STATE
  is '״̬,0�����1���ǻ';
comment on column E_LOGIN_LOG.USER_ID
  is '�û�ID';
comment on column E_LOGIN_LOG.CLIENT_IP
  is '�û��ͻ���IP';
comment on column E_LOGIN_LOG.LOGIN_DATE
  is '��¼ʱ��';
comment on column E_LOGIN_LOG.LOGOUT_DATE
  is '�ǳ�ʱ��';
comment on column E_LOGIN_LOG.CLIENT_BROWSOR
  is '�û��ͻ��������';

prompt
prompt Creating table E_MENU
prompt =====================
prompt
create table E_MENU
(
  RESOURCES_ID   VARCHAR2(30) not null,
  RESOURCES_NAME VARCHAR2(30) not null,
  RESOURCES_TYPE VARCHAR2(50) not null,
  PARENT_ID      VARCHAR2(30),
  URL            VARCHAR2(500),
  EXT1           VARCHAR2(500),
  EXT2           VARCHAR2(500),
  EXT3           VARCHAR2(500),
  EXT4           VARCHAR2(500),
  MEMO           VARCHAR2(500),
  ORD            NUMBER(10) not null,
  ATTACHMENT     VARCHAR2(500),
  RESOURCE_STATE CHAR(1)
)
;
comment on table E_MENU
  is 'ϵͳ�˵�';
comment on column E_MENU.RESOURCES_ID
  is '�˵�����';
comment on column E_MENU.RESOURCES_NAME
  is '�˵�����';
comment on column E_MENU.RESOURCES_TYPE
  is '�˵�����';
comment on column E_MENU.PARENT_ID
  is '�ϼ��˵�����';
comment on column E_MENU.URL
  is '�˵���ַ';
comment on column E_MENU.EXT1
  is '��չ�ֶ�1';
comment on column E_MENU.EXT2
  is '��չ�ֶ�2';
comment on column E_MENU.EXT3
  is '��չ�ֶ�3';
comment on column E_MENU.EXT4
  is '��չ�ֶ�4';
comment on column E_MENU.MEMO
  is 'ע��';
comment on column E_MENU.ORD
  is '����';
comment on column E_MENU.ATTACHMENT
  is '������ַ';
comment on column E_MENU.RESOURCE_STATE
  is '�˵�״̬��1�����ݿ����У�2�����򿪷��У�3����ʽ��Ĭ�ϣ�
';

prompt
prompt Creating table E_MENU_IND
prompt =========================
prompt
create table E_MENU_IND
(
  ID           VARCHAR2(20),
  RESOURCES_ID VARCHAR2(30),
  IND_ID       VARCHAR2(20)
)
;
comment on table E_MENU_IND
  is 'ҳ��ָ��';
comment on column E_MENU_IND.ID
  is 'ID';
comment on column E_MENU_IND.RESOURCES_ID
  is '�˵�����';
comment on column E_MENU_IND.IND_ID
  is 'ָ�����';

prompt
prompt Creating table E_OPERATE_TYPE
prompt =============================
prompt
create table E_OPERATE_TYPE
(
  OPERATE_TYPE_CODE VARCHAR2(30),
  OPERATE_TYPE_DESC VARCHAR2(100),
  ORD               NUMBER
)
;
comment on table E_OPERATE_TYPE
  is '�����������';
comment on column E_OPERATE_TYPE.OPERATE_TYPE_CODE
  is '�������ͱ��';
comment on column E_OPERATE_TYPE.OPERATE_TYPE_DESC
  is '������������';
comment on column E_OPERATE_TYPE.ORD
  is '����';

prompt
prompt Creating table E_OPERATION_LOG
prompt ==============================
prompt
create table E_OPERATION_LOG
(
  USER_ID           VARCHAR2(30),
  MENU_ID           VARCHAR2(40),
  OPERATE_TYPE_CODE VARCHAR2(30),
  OPERATE_RESULT    VARCHAR2(100),
  CONTENT           CLOB,
  CLIENT_IP         VARCHAR2(100),
  CREATE_DATE       VARCHAR2(50)
)
;
comment on table E_OPERATION_LOG
  is '�����Բ�����־';
comment on column E_OPERATION_LOG.USER_ID
  is '��¼ID';
comment on column E_OPERATION_LOG.MENU_ID
  is '�˵����';
comment on column E_OPERATION_LOG.OPERATE_TYPE_CODE
  is '��������';
comment on column E_OPERATION_LOG.OPERATE_RESULT
  is '�������';
comment on column E_OPERATION_LOG.CONTENT
  is '��������';
comment on column E_OPERATION_LOG.CLIENT_IP
  is 'IP��ַ';
comment on column E_OPERATION_LOG.CREATE_DATE
  is '����ʱ��';

prompt
prompt Creating table E_POST
prompt =====================
prompt
create table E_POST
(
  POST_ID      VARCHAR2(30) not null,
  POST_TITLE   VARCHAR2(100) not null,
  ISSUE_DATE   VARCHAR2(50),
  BEGIN_DATE   VARCHAR2(50),
  END_DATE     VARCHAR2(50),
  POST_STATE   NUMBER(3) not null,
  POST_CONTENT CLOB not null,
  UPDATE_DATE  VARCHAR2(50),
  USER_ID      VARCHAR2(30)
)
;
comment on table E_POST
  is 'ϵͳ����';
comment on column E_POST.POST_ID
  is '����ID';
comment on column E_POST.POST_TITLE
  is '�������';
comment on column E_POST.ISSUE_DATE
  is '����ʱ��';
comment on column E_POST.BEGIN_DATE
  is '��ʼʱ��';
comment on column E_POST.END_DATE
  is '����ʱ��';
comment on column E_POST.POST_STATE
  is '����״̬:1�ѷ���,0δ����';
comment on column E_POST.POST_CONTENT
  is '��������';
comment on column E_POST.UPDATE_DATE
  is '�����޸�ʱ��';
comment on column E_POST.USER_ID
  is '�����˱��';
alter table E_POST
  add primary key (POST_ID);

prompt
prompt Creating table E_POST_ROLE
prompt ==========================
prompt
create table E_POST_ROLE
(
  POST_ID   VARCHAR2(30) not null,
  ROLE_CODE VARCHAR2(30) not null
)
;
comment on table E_POST_ROLE
  is '�����ɫ';
comment on column E_POST_ROLE.POST_ID
  is '����ID';
comment on column E_POST_ROLE.ROLE_CODE
  is '��ɫID';
alter table E_POST_ROLE
  add primary key (POST_ID, ROLE_CODE);

prompt
prompt Creating table E_RESOURCES_TYPE
prompt ===============================
prompt
create table E_RESOURCES_TYPE
(
  RESOURCES_TYPE_ID   NUMBER(19) not null,
  RESOURCES_TYPE_NAME VARCHAR2(30) not null,
  ORD                 NUMBER(10) not null
)
;
comment on table E_RESOURCES_TYPE
  is 'ϵͳ��Դ����';
comment on column E_RESOURCES_TYPE.RESOURCES_TYPE_ID
  is '��Դ���ͱ���';
comment on column E_RESOURCES_TYPE.RESOURCES_TYPE_NAME
  is '��Դ��������';
comment on column E_RESOURCES_TYPE.ORD
  is '����';

prompt
prompt Creating table E_ROLE
prompt =====================
prompt
create table E_ROLE
(
  ROLE_CODE     VARCHAR2(30) not null,
  PARENT_CODE   VARCHAR2(30),
  ROLE_NAME     VARCHAR2(50) not null,
  MEMO          VARCHAR2(500),
  ORD           NUMBER(10) not null,
  SUBSYSTEM_ID  VARCHAR2(30),
  CREATED_USER  VARCHAR2(30),
  CREATED_DATE  VARCHAR2(50),
  MODIFIED_USER VARCHAR2(30),
  MODIFIED_DATE VARCHAR2(50)
)
;
comment on table E_ROLE
  is '��ɫ';
comment on column E_ROLE.ROLE_CODE
  is '��ɫ����';
comment on column E_ROLE.PARENT_CODE
  is '�ϼ���ɫ����';
comment on column E_ROLE.ROLE_NAME
  is '��ɫ����';
comment on column E_ROLE.MEMO
  is '��ɫ����';
comment on column E_ROLE.ORD
  is '����';
comment on column E_ROLE.SUBSYSTEM_ID
  is '��ϵͳ����';
comment on column E_ROLE.CREATED_USER
  is '������';
comment on column E_ROLE.CREATED_DATE
  is '����ʱ��';
comment on column E_ROLE.MODIFIED_USER
  is '������';
comment on column E_ROLE.MODIFIED_DATE
  is '����ʱ��';
alter table E_ROLE
  add primary key (ROLE_CODE);

prompt
prompt Creating table E_ROLE_PERMISSION
prompt ================================
prompt
create table E_ROLE_PERMISSION
(
  ROLE_CODE   VARCHAR2(30) not null,
  MENU_ID     VARCHAR2(30) not null,
  AUTH_CREATE NUMBER(3) not null,
  AUTH_READ   NUMBER(3) not null,
  AUTH_UPDATE NUMBER(3) not null,
  AUTH_DELETE NUMBER(3) not null,
  AUTH_EXPORT NUMBER(3),
  AUTH_ISSUED NUMBER(3)
)
;
comment on table E_ROLE_PERMISSION
  is '��ɫȨ��';
comment on column E_ROLE_PERMISSION.ROLE_CODE
  is '��ɫ���';
comment on column E_ROLE_PERMISSION.MENU_ID
  is '��Դ����';
comment on column E_ROLE_PERMISSION.AUTH_CREATE
  is '����Ȩ��';
comment on column E_ROLE_PERMISSION.AUTH_READ
  is '��ȡȨ��';
comment on column E_ROLE_PERMISSION.AUTH_UPDATE
  is '����Ȩ��';
comment on column E_ROLE_PERMISSION.AUTH_DELETE
  is 'ɾ��Ȩ��';
comment on column E_ROLE_PERMISSION.AUTH_EXPORT
  is '����Ȩ��';
comment on column E_ROLE_PERMISSION.AUTH_ISSUED
  is '�·�Ȩ��';

prompt
prompt Creating table E_USER
prompt =====================
prompt
create table E_USER
(
  USER_ID     VARCHAR2(30) not null,
  LOGIN_ID    VARCHAR2(30) not null,
  PASSWORD    VARCHAR2(255) not null,
  USER_NAME   VARCHAR2(30) not null,
  ADMIN       NUMBER(3) not null,
  SEX         NUMBER(3),
  EMAIL       VARCHAR2(100),
  MOBILE      VARCHAR2(20),
  TELEPHONE   VARCHAR2(20),
  STATE       NUMBER(3),
  PWD_STATE   NUMBER(3),
  MEMO        VARCHAR2(500),
  REG_DATE    VARCHAR2(50),
  UPDATE_DATE VARCHAR2(50),
  REG_USER    VARCHAR2(30),
  UPDATE_USER VARCHAR2(30),
  EXT1        VARCHAR2(100),
  EXT2        VARCHAR2(100),
  EXT3        VARCHAR2(100),
  EXT4        VARCHAR2(100),
  EXT5        VARCHAR2(100),
  EXT6        VARCHAR2(100),
  EXT7        VARCHAR2(100),
  EXT8        VARCHAR2(100),
  EXT9        VARCHAR2(100),
  EXT10       VARCHAR2(100),
  EXT11       VARCHAR2(100),
  EXT12       VARCHAR2(100),
  EXT13       VARCHAR2(100),
  EXT14       VARCHAR2(100),
  EXT15       VARCHAR2(100),
  EXT16       VARCHAR2(100),
  EXT17       VARCHAR2(100),
  EXT18       VARCHAR2(100),
  EXT19       VARCHAR2(100),
  EXT20       VARCHAR2(100),
  EXT21       VARCHAR2(100),
  EXT22       VARCHAR2(100),
  EXT23       VARCHAR2(100),
  EXT24       VARCHAR2(100),
  EXT25       VARCHAR2(100),
  EXT26       VARCHAR2(100),
  EXT27       VARCHAR2(100),
  EXT28       VARCHAR2(100),
  EXT29       VARCHAR2(100),
  EXT30       VARCHAR2(100)
)
;
comment on table E_USER
  is '�û���';
comment on column E_USER.USER_ID
  is '�û�ID';
comment on column E_USER.LOGIN_ID
  is '��¼ID';
comment on column E_USER.PASSWORD
  is '����';
comment on column E_USER.USER_NAME
  is '�û�����';
comment on column E_USER.ADMIN
  is '����Ա';
comment on column E_USER.SEX
  is '�Ա�';
comment on column E_USER.EMAIL
  is '�����ַ';
comment on column E_USER.MOBILE
  is '�ƶ��绰';
comment on column E_USER.TELEPHONE
  is '�̶��绰';
comment on column E_USER.STATE
  is '״̬��1Ϊ���ã�0ͣ��';
comment on column E_USER.PWD_STATE
  is '����״̬���Ƿ����';
comment on column E_USER.MEMO
  is '��ע��Ϣ';
comment on column E_USER.REG_DATE
  is 'ע��ʱ��';
comment on column E_USER.UPDATE_DATE
  is '����ʱ��';
comment on column E_USER.REG_USER
  is 'ע����';
comment on column E_USER.UPDATE_USER
  is '������';
comment on column E_USER.EXT1
  is '��չ����1';
comment on column E_USER.EXT2
  is '��չ����2';
comment on column E_USER.EXT3
  is '��չ����3';
comment on column E_USER.EXT4
  is '��չ����4';
comment on column E_USER.EXT5
  is '��չ����5';
comment on column E_USER.EXT6
  is '��չ����6';
comment on column E_USER.EXT7
  is '��չ����7';
comment on column E_USER.EXT8
  is '��չ����8';
comment on column E_USER.EXT9
  is '��չ����9';
comment on column E_USER.EXT10
  is '��չ����10';
comment on column E_USER.EXT11
  is '��չ����11';
comment on column E_USER.EXT12
  is '��չ����12';
comment on column E_USER.EXT13
  is '��չ����13';
comment on column E_USER.EXT14
  is '��չ����14';
comment on column E_USER.EXT15
  is '��չ����15';
comment on column E_USER.EXT16
  is '��չ����16';
comment on column E_USER.EXT17
  is '��չ����17';
comment on column E_USER.EXT18
  is '��չ����18';
comment on column E_USER.EXT19
  is '��չ����19';
comment on column E_USER.EXT20
  is '��չ����20';
comment on column E_USER.EXT21
  is '��չ����21';
comment on column E_USER.EXT22
  is '��չ����22';
comment on column E_USER.EXT23
  is '��չ����23';
comment on column E_USER.EXT24
  is '��չ����24';
comment on column E_USER.EXT25
  is '��չ����25';
comment on column E_USER.EXT26
  is '��չ����26';
comment on column E_USER.EXT27
  is '��չ����27';
comment on column E_USER.EXT28
  is '��չ����28';
comment on column E_USER.EXT29
  is '��չ����29';
comment on column E_USER.EXT30
  is '��չ����30';

prompt
prompt Creating table E_USER_ACCOUNT
prompt =============================
prompt
create table E_USER_ACCOUNT
(
  ACCOUNT_CODE VARCHAR2(30),
  USER_ID      VARCHAR2(30)
)
;
comment on table E_USER_ACCOUNT
  is '�û�����ҵ�˻���Ӧ��ϵ';
comment on column E_USER_ACCOUNT.ACCOUNT_CODE
  is '�˺ű���';
comment on column E_USER_ACCOUNT.USER_ID
  is '�û�ID';

prompt
prompt Creating table E_USER_ATTRIBUTE
prompt ===============================
prompt
create table E_USER_ATTRIBUTE
(
  USER_ID     VARCHAR2(30) not null,
  ATTR_CODE   VARCHAR2(30) not null,
  ATTR_VALUE  VARCHAR2(30) not null,
  REG_DATE    VARCHAR2(50),
  UPDATE_DATE VARCHAR2(50),
  REG_USER    VARCHAR2(30),
  UPDATE_USER VARCHAR2(30)
)
;
comment on table E_USER_ATTRIBUTE
  is '�û����Ա�';
comment on column E_USER_ATTRIBUTE.USER_ID
  is '�û�ID';
comment on column E_USER_ATTRIBUTE.ATTR_CODE
  is '���Ա���';
comment on column E_USER_ATTRIBUTE.ATTR_VALUE
  is '����ֵ';
comment on column E_USER_ATTRIBUTE.REG_DATE
  is 'ע��ʱ��';
comment on column E_USER_ATTRIBUTE.UPDATE_DATE
  is '����ʱ��';
comment on column E_USER_ATTRIBUTE.REG_USER
  is 'ע����';
comment on column E_USER_ATTRIBUTE.UPDATE_USER
  is '������';

prompt
prompt Creating table E_USER_ATTR_DIM
prompt ==============================
prompt
create table E_USER_ATTR_DIM
(
  ATTR_CODE       VARCHAR2(30 CHAR) not null,
  ATTR_NAME       VARCHAR2(30 CHAR) not null,
  PARENT_CODE     VARCHAR2(30 CHAR),
  SHOW_MODE       VARCHAR2(30 CHAR),
  CODE_TABLE      VARCHAR2(1000 CHAR),
  CODE_KEY        VARCHAR2(30 CHAR),
  CODE_PARENT_KEY VARCHAR2(30 CHAR),
  CODE_DESC       VARCHAR2(30 CHAR),
  CODE_ORD        VARCHAR2(30 CHAR),
  DATA_TYPE       VARCHAR2(30 CHAR),
  MULTI           NUMBER(3) not null,
  ATTR_ORD        NUMBER(10) not null,
  IS_NULL         NUMBER(3) not null,
  DEFAULT_VALUE   VARCHAR2(30 CHAR),
  DEFAULT_DESC    VARCHAR2(30 CHAR),
  SUBSYSTEM_ID    VARCHAR2(30),
  ATTR_DESC       VARCHAR2(3000)
)
;
comment on table E_USER_ATTR_DIM
  is '�û���չ��������';
comment on column E_USER_ATTR_DIM.ATTR_CODE
  is '��չ���Ա���';
comment on column E_USER_ATTR_DIM.ATTR_NAME
  is '��չ��������';
comment on column E_USER_ATTR_DIM.PARENT_CODE
  is '�ϼ�����';
comment on column E_USER_ATTR_DIM.SHOW_MODE
  is '��չ����ҳ��չ��ģʽ';
comment on column E_USER_ATTR_DIM.CODE_TABLE
  is '��ѡ������';
comment on column E_USER_ATTR_DIM.CODE_KEY
  is '��ѡ����������ֶ�';
comment on column E_USER_ATTR_DIM.CODE_PARENT_KEY
  is '��ѡ���ϼ������ֶ�';
comment on column E_USER_ATTR_DIM.CODE_DESC
  is '��ѡ�����������ֶ�';
comment on column E_USER_ATTR_DIM.CODE_ORD
  is '��ѡ�����������ֶ�';
comment on column E_USER_ATTR_DIM.DATA_TYPE
  is '����ֵ����';
comment on column E_USER_ATTR_DIM.MULTI
  is '�Ƿ��ѡ';
comment on column E_USER_ATTR_DIM.ATTR_ORD
  is '����';
comment on column E_USER_ATTR_DIM.IS_NULL
  is '��չ����ֵ�Ƿ�Ϊ��';
comment on column E_USER_ATTR_DIM.DEFAULT_VALUE
  is '��չ����Ϊ��ʱ���Ĭ��ֵ';
comment on column E_USER_ATTR_DIM.DEFAULT_DESC
  is '��չ����Ϊ��ʱ���Ĭ������(���������б�)';
comment on column E_USER_ATTR_DIM.SUBSYSTEM_ID
  is '��ϵͳ����';
comment on column E_USER_ATTR_DIM.ATTR_DESC
  is '��չ������������Ե��Ǹ���չ����';

prompt
prompt Creating table E_USER_ATTR_SUBSYSTEM
prompt ====================================
prompt
create table E_USER_ATTR_SUBSYSTEM
(
  ATTR_CODE    VARCHAR2(100),
  SUBSYSTEM_ID VARCHAR2(100)
)
;

prompt
prompt Creating table E_USER_COLLECT
prompt =============================
prompt
create table E_USER_COLLECT
(
  ID           VARCHAR2(20),
  USER_ID      VARCHAR2(20),
  MENU_ID      VARCHAR2(20),
  COLLECT_DATE VARCHAR2(20),
  IDX          VARCHAR2(20)
)
;
comment on table E_USER_COLLECT
  is '�û�ҳ���ղر�';
comment on column E_USER_COLLECT.USER_ID
  is '�û�ID';
comment on column E_USER_COLLECT.MENU_ID
  is 'ҳ��ID';
comment on column E_USER_COLLECT.COLLECT_DATE
  is '�ղ�ʱ��';
comment on column E_USER_COLLECT.IDX
  is '����';

prompt
prompt Creating table E_USER_EXTVALUE_TYPE
prompt ===================================
prompt
create table E_USER_EXTVALUE_TYPE
(
  TYPE_CODE  VARCHAR2(5),
  TYPE_DESC  VARCHAR2(20),
  TYPE_VALUE VARCHAR2(15)
)
;
comment on column E_USER_EXTVALUE_TYPE.TYPE_CODE
  is '����ֵ���ͱ���';
comment on column E_USER_EXTVALUE_TYPE.TYPE_DESC
  is '����ֵ���ͱ�������';
comment on column E_USER_EXTVALUE_TYPE.TYPE_VALUE
  is '����ֵ����';

prompt
prompt Creating table E_USER_EXT_COLUMN_ATTR
prompt =====================================
prompt
create table E_USER_EXT_COLUMN_ATTR
(
  ATTR_CODE   VARCHAR2(30 CHAR) not null,
  COLUMN_NAME VARCHAR2(100 CHAR) not null
)
;
comment on table E_USER_EXT_COLUMN_ATTR
  is '�û���չ���Զ�Ӧ��ϵ��';
comment on column E_USER_EXT_COLUMN_ATTR.ATTR_CODE
  is '��չ���Ա���';
comment on column E_USER_EXT_COLUMN_ATTR.COLUMN_NAME
  is '��Ӧuser���ֶ���';

prompt
prompt Creating table E_USER_EXT_MODEL
prompt ===============================
prompt
create table E_USER_EXT_MODEL
(
  MODEL_CODE VARCHAR2(10),
  MODEL_DESC VARCHAR2(30)
)
;
comment on column E_USER_EXT_MODEL.MODEL_CODE
  is 'չ��ģʽ����';
comment on column E_USER_EXT_MODEL.MODEL_DESC
  is 'չ��ģʽ����';

prompt
prompt Creating table E_USER_PERMISSION
prompt ================================
prompt
create table E_USER_PERMISSION
(
  USER_ID     VARCHAR2(30) not null,
  MENU_ID     VARCHAR2(30) not null,
  AUTH_CREATE NUMBER(3) not null,
  AUTH_READ   NUMBER(3) not null,
  AUTH_UPDATE NUMBER(3) not null,
  AUTH_DELETE NUMBER(3) not null,
  AUTH_EXPORT NUMBER(3)
)
;
comment on table E_USER_PERMISSION
  is '�û�Ȩ��';
comment on column E_USER_PERMISSION.USER_ID
  is '�û����';
comment on column E_USER_PERMISSION.MENU_ID
  is '��Դ����';
comment on column E_USER_PERMISSION.AUTH_CREATE
  is '����Ȩ��';
comment on column E_USER_PERMISSION.AUTH_READ
  is '��ȡȨ��';
comment on column E_USER_PERMISSION.AUTH_UPDATE
  is '����Ȩ��';
comment on column E_USER_PERMISSION.AUTH_DELETE
  is 'ɾ��Ȩ��';
comment on column E_USER_PERMISSION.AUTH_EXPORT
  is '����Ȩ��';

prompt
prompt Creating table E_USER_PERMISSION_EXP
prompt ====================================
prompt
create table E_USER_PERMISSION_EXP
(
  USER_ID VARCHAR2(30) not null,
  MENU_ID VARCHAR2(32),
  REMARK  VARCHAR2(254)
)
;

prompt
prompt Creating table E_USER_ROLE
prompt ==========================
prompt
create table E_USER_ROLE
(
  ROLE_CODE     VARCHAR2(30) not null,
  USER_ID       VARCHAR2(30) not null,
  CREATE_USER   VARCHAR2(30),
  CREATED_DATE  VARCHAR2(50),
  MODIFIED_USER VARCHAR2(30),
  MODIFIED_DATE VARCHAR2(50)
)
;
comment on table E_USER_ROLE
  is '�û���ɫ';
comment on column E_USER_ROLE.ROLE_CODE
  is '��ɫID';
comment on column E_USER_ROLE.USER_ID
  is '�û�ID';
comment on column E_USER_ROLE.CREATE_USER
  is '������';
comment on column E_USER_ROLE.CREATED_DATE
  is '����ʱ��';
comment on column E_USER_ROLE.MODIFIED_USER
  is '������';
comment on column E_USER_ROLE.MODIFIED_DATE
  is '����ʱ��';

prompt
prompt Creating table OCT_ACCOUNT
prompt ==========================
prompt
create table OCT_ACCOUNT
(
  ACCOUNT_CODE  VARCHAR2(30) not null,
  ACCOUNT_NAME  VARCHAR2(100),
  ACCOUNT_DESC  VARCHAR2(200),
  CREATED_USER  VARCHAR2(30),
  CREATED_DATE  VARCHAR2(50),
  MODIFIED_USER VARCHAR2(30),
  MODIFIED_DATE VARCHAR2(50)
)
;
comment on table OCT_ACCOUNT
  is '��ҵ�˺���Ϣ��';
comment on column OCT_ACCOUNT.ACCOUNT_CODE
  is '�˺ű���';
comment on column OCT_ACCOUNT.ACCOUNT_NAME
  is '�˺�����';
comment on column OCT_ACCOUNT.ACCOUNT_DESC
  is '�˺�����';
comment on column OCT_ACCOUNT.CREATED_USER
  is '������';
comment on column OCT_ACCOUNT.CREATED_DATE
  is '����ʱ��';
comment on column OCT_ACCOUNT.MODIFIED_USER
  is '�޸���';
comment on column OCT_ACCOUNT.MODIFIED_DATE
  is '�޸�ʱ��';

prompt
prompt Creating table ORGINFO
prompt ======================
prompt
create table ORGINFO
(
  ID          VARCHAR2(255) not null,
  ORG_NAME    VARCHAR2(255 CHAR),
  ORGINFO_ID  VARCHAR2(255),
  TENANT_ID   VARCHAR2(20),
  ORGTYPE_ID  VARCHAR2(255 CHAR),
  PATH        VARCHAR2(1024 CHAR),
  MEMO        VARCHAR2(500 CHAR),
  CREATE_TIME TIMESTAMP(6),
  CREATE_USER VARCHAR2(30 CHAR)
)
;

prompt
prompt Creating table SYS_CONST_TABLE
prompt ==============================
prompt
create table SYS_CONST_TABLE
(
  CONST_TYPE  VARCHAR2(16) not null,
  CONST_NAME  VARCHAR2(64) not null,
  CONST_VALUE VARCHAR2(64),
  CONST_DESC  VARCHAR2(256)
)
;

prompt
prompt Creating sequence E_EXPORT_LOG_SEQ
prompt ==================================
prompt
create sequence E_EXPORT_LOG_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 3521
increment by 1
cache 20;

prompt
prompt Creating sequence E_IND_SEQ
prompt ===========================
prompt
create sequence E_IND_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence E_LN_SEQ
prompt ==========================
prompt
create sequence E_LN_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence E_MENU_IND_SEQ
prompt ================================
prompt
create sequence E_MENU_IND_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence E_M_SEQ
prompt =========================
prompt
create sequence E_M_SEQ
minvalue 1000
maxvalue 99999999999999
start with 1860
increment by 1
cache 20;

prompt
prompt Creating sequence E_ROLE_SEQ
prompt ============================
prompt
create sequence E_ROLE_SEQ
minvalue 1
maxvalue 99999999999999999999
start with 210
increment by 1
cache 20;

prompt
prompt Creating sequence E_UR_SEQ
prompt ==========================
prompt
create sequence E_UR_SEQ
minvalue 1
maxvalue 99999999999999
start with 1100
increment by 1
cache 20;

prompt
prompt Creating sequence E_USER_COL_SEQ
prompt ================================
prompt
create sequence E_USER_COL_SEQ
minvalue 1
maxvalue 99999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating sequence KPI_SERVICE_SEQ
prompt =================================
prompt
create sequence KPI_SERVICE_SEQ
minvalue 1
maxvalue 9999999999999
start with 541
increment by 1
cache 20;

prompt
prompt Creating sequence SYS_REPORT_DATA
prompt =================================
prompt
create sequence SYS_REPORT_DATA
minvalue 1
maxvalue 999999999
start with 2481
increment by 1
cache 20;

prompt
prompt Creating view CONSECUTIVE_2YEAR_MON
prompt ===================================
prompt
create or replace view consecutive_2year_mon as
select to_char(add_months(sysdate, - (rownum - 1)), 'yyyymm') acct_month,
         replace(replace(to_char(add_months(sysdate, - (rownum - 1)), 'yyyy/mm\'),'/','��'),'\','��') acct_desc
    from dual connect by rownum<25;

prompt
prompt Creating package EMP_PKG
prompt ========================
prompt
create or replace package emp_pkg is
 procedure emp_update_ename1(v_empno varchar2,v_ename out varchar2);
 function emp_get_sal1(v_empno varchar2) return number;
end;
/

prompt
prompt Creating type SYSTPQFg3DAQafEfgUBCsIA420w==
prompt ===========================================
prompt
CREATE OR REPLACE TYPE "SYSTPQFg3DAQafEfgUBCsIA420w==" AS TABLE OF "SYS"."SQL_BIND"
/

prompt
prompt Creating function RET_EMP_SAL
prompt =============================
prompt
create or replace function ret_emp_sal(v_ename varchar2)
return number
is
v_sal number(7,2);
begin
select nvl(admin,0) into v_sal from e_user where lower(login_id)=lower(v_ename);
return v_sal;
end;
/

prompt
prompt Creating procedure UPDATE_EMP
prompt =============================
prompt
create or replace procedure update_emp
(
v_empno  varchar2,
v_ename out  varchar2
) is
begin
--aaaaaaaaa
select login_id into v_ename from e_user;

end update_emp;
/

prompt
prompt Creating package body EMP_PKG
prompt =============================
prompt
create or replace package body emp_pkg
is
    --emp_update_ename1
    procedure emp_update_ename1
    (
    v_empno varchar2,
    v_ename out varchar2
    )
    is
    begin
     select login_id into v_ename from e_user;

    end;
    --emp_get_sall 
    function emp_get_sal1
    (
    v_empno varchar2
    )
    return number is
    v_sal number(7,2);
    begin
    select nvl(admin,0) into v_sal from e_user where lower(login_id)=lower(v_empno);
    return v_sal;
    end;
end;
/


spool off

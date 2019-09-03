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
  is '子系统管理';
comment on column D_SUBSYSTEM.SUBSYSTEM_ID
  is '子系统编码';
comment on column D_SUBSYSTEM.SUBSYSTEM_NAME
  is '子系统名称';
comment on column D_SUBSYSTEM.SUBSYSTEM_ADDRESS
  is '子系统访问地址';
comment on column D_SUBSYSTEM.SUBSYSTEM_IP
  is '子系统访问地址IP';
comment on column D_SUBSYSTEM.SIMULATION_ADDRESS
  is '模拟登录地址';
comment on column D_SUBSYSTEM.STATE
  is '状态   1：有效  0：无效';
comment on column D_SUBSYSTEM.ORD
  is '排序';
comment on column D_SUBSYSTEM.CONTACTS
  is '子系统联系人';
comment on column D_SUBSYSTEM.PHONE
  is '联系电话';
comment on column D_SUBSYSTEM.E_MAIL
  is '电子邮箱';
comment on column D_SUBSYSTEM.SUBSYSTEM_ADDRESS2
  is '子系统访问地址2';
comment on column D_SUBSYSTEM.SUBSYSTEM_IP2
  is '子系统访问地址IP2';
comment on column D_SUBSYSTEM.REMARK
  is '备注';
comment on column D_SUBSYSTEM.CREATE_USER
  is '创建人';
comment on column D_SUBSYSTEM.CREATE_TIME
  is '创建时间';
comment on column D_SUBSYSTEM.MODIFY_USER
  is '修改人';
comment on column D_SUBSYSTEM.MODIFY_TIME
  is '修改时间';

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
  is '报表内功能id';
comment on column E_COMP_EXTEND_BTN.COMP_NAME
  is '功能名称';
comment on column E_COMP_EXTEND_BTN.BTN_NAME
  is '按钮名称，做提示用，不直接显示';
comment on column E_COMP_EXTEND_BTN.BTN_ICON
  is '显示的图标，icon-download-excel；icon-download-excel2（重复）；icon-download-pdf';
comment on column E_COMP_EXTEND_BTN.CALL_URL
  is '点击按钮要请求的地址，起始没有/，如user.e或user.e?name=334444=xx';
comment on column E_COMP_EXTEND_BTN.CALL_TARGET
  is 'open、replace、ajax、form（下载时），目前支持form方式';
comment on column E_COMP_EXTEND_BTN.SHOW_SELECT_FIELD
  is '是否弹出选择列菜单,1是，0否，弹出后可以选择列';

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
  is '局方部门';
comment on column E_DEPARTMENT.DEPART_CODE
  is '部门编码';
comment on column E_DEPARTMENT.DEPART_DESC
  is '部门描述';
comment on column E_DEPARTMENT.PARENT_CODE
  is '上级部门编码';

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
  is '导出信息表';
comment on column E_EXPORTING_INFO.ID
  is '编码';
comment on column E_EXPORTING_INFO.FILE_NAME
  is '文件名称';
comment on column E_EXPORTING_INFO.STATUS_ID
  is '状态';
comment on column E_EXPORTING_INFO.FILE_PATH
  is '文件存放路径';
comment on column E_EXPORTING_INFO.OPT_USER
  is '操作用户';
comment on column E_EXPORTING_INFO.OPT_TIME
  is '操作时间';
comment on column E_EXPORTING_INFO.SYSTEM_FLAG
  is '客户端标识';
comment on column E_EXPORTING_INFO.FILE_TYPE
  is '文件类型';
comment on column E_EXPORTING_INFO.DOWN_PARAM_STR
  is '查询条件字符串';

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
  is '导出日志表';
comment on column E_EXPORT_LOG.ID
  is '编码';
comment on column E_EXPORT_LOG.EXPORTING_ID
  is '导出信息编码';
comment on column E_EXPORT_LOG.STATUS_ID
  is '状态编码';
comment on column E_EXPORT_LOG.OPT_TIME
  is '操作时间';

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
  is '导出队列信息表';
comment on column E_EXPORT_QUEUE_DATA.ID
  is '编码';
comment on column E_EXPORT_QUEUE_DATA.QUEUE_DATA
  is '队列信息数据';

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
  is '导出状态码表';
comment on column E_EXPORT_STATUS.STATUS_ID
  is '导出状态编码';
comment on column E_EXPORT_STATUS.STATUS_NAME
  is '导出状态名称';
comment on column E_EXPORT_STATUS.ORD
  is '排序';

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
  is '框架扩展数据源';
comment on column E_EXT_DATASOURCE.DS_CN_NAME
  is '数据源中文名称';
comment on column E_EXT_DATASOURCE.DS_NAME
  is '数据源名称';
comment on column E_EXT_DATASOURCE.DB_TYPE
  is '数据库类型';
comment on column E_EXT_DATASOURCE.DS_TYPE
  is '数据源连接类型，dbcp，c3p0';
comment on column E_EXT_DATASOURCE.INITIAL_SIZE
  is '初始化连接数';
comment on column E_EXT_DATASOURCE.MIN_IDLE
  is '最小空闲连接数';
comment on column E_EXT_DATASOURCE.MAX_IDLE
  is '最大空闲连接数';
comment on column E_EXT_DATASOURCE.MAX_ACTIVE
  is '最大连接数';
comment on column E_EXT_DATASOURCE.MAX_WAIT
  is '最大等待时间，毫秒';
comment on column E_EXT_DATASOURCE.REMOVE_ABANDONED
  is '是否自动回收超时连接';
comment on column E_EXT_DATASOURCE.REMOVE_ABANDONED_TIMEOUT
  is '超时时间，秒';
comment on column E_EXT_DATASOURCE.TIME_BWT_EVN_MILLIS
  is '验证从连接池取出的连接，time_between_evictionruns_millis';
comment on column E_EXT_DATASOURCE.TEST_WHILE_IDLE
  is '验证从连接池取出的连接';
comment on column E_EXT_DATASOURCE.VALIDATION_QUERY
  is '验证从连接池取出的连接';
comment on column E_EXT_DATASOURCE.STATUS
  is '状态，默认1，停用后为0';
comment on column E_EXT_DATASOURCE.CREATE_TIME
  is '创建时间';
comment on column E_EXT_DATASOURCE.CREATE_USER
  is '创建人';
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
  is '指标';
comment on column E_IND_EXP.IND_ID
  is '指标编码';
comment on column E_IND_EXP.IND_NAME
  is '指标名称';

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
  is '指标解释详情';
comment on column E_IND_EXP_DETAILS.ID
  is 'ID';
comment on column E_IND_EXP_DETAILS.IND_ID
  is '指标编码';
comment on column E_IND_EXP_DETAILS.IND_TYPE_CODE
  is '指标类型编码';
comment on column E_IND_EXP_DETAILS.BUS_EXP
  is '业务解释';
comment on column E_IND_EXP_DETAILS.SKILL_EXP
  is '技术解释';
comment on column E_IND_EXP_DETAILS.OTHER_EXP
  is '其他解释';
comment on column E_IND_EXP_DETAILS.ORD
  is '排序';
comment on column E_IND_EXP_DETAILS.DEPARTMENT_CODE
  is '局方提出部门编号';
comment on column E_IND_EXP_DETAILS.FACTORY_CON
  is '厂家确认人';
comment on column E_IND_EXP_DETAILS.MAINTE_MAN
  is '维护人';
comment on column E_IND_EXP_DETAILS.CREATE_MAN
  is '创建人';
comment on column E_IND_EXP_DETAILS.CREATE_TIME
  is '创建时间';
comment on column E_IND_EXP_DETAILS.UPDATE_MAN
  is '修改人';
comment on column E_IND_EXP_DETAILS.UPDATE_TIME
  is '修改时间';
comment on column E_IND_EXP_DETAILS.IND_CODE
  is '指标编号';

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
  is '登录日志';
comment on column E_LOGIN_LOG.SESSION_ID
  is '会话ID';
comment on column E_LOGIN_LOG.STATE
  is '状态,0：活动，1：非活动';
comment on column E_LOGIN_LOG.USER_ID
  is '用户ID';
comment on column E_LOGIN_LOG.CLIENT_IP
  is '用户客户端IP';
comment on column E_LOGIN_LOG.LOGIN_DATE
  is '登录时间';
comment on column E_LOGIN_LOG.LOGOUT_DATE
  is '登出时间';
comment on column E_LOGIN_LOG.CLIENT_BROWSOR
  is '用户客户端浏览器';

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
  is '系统菜单';
comment on column E_MENU.RESOURCES_ID
  is '菜单编码';
comment on column E_MENU.RESOURCES_NAME
  is '菜单名称';
comment on column E_MENU.RESOURCES_TYPE
  is '菜单类型';
comment on column E_MENU.PARENT_ID
  is '上级菜单编码';
comment on column E_MENU.URL
  is '菜单地址';
comment on column E_MENU.EXT1
  is '扩展字段1';
comment on column E_MENU.EXT2
  is '扩展字段2';
comment on column E_MENU.EXT3
  is '扩展字段3';
comment on column E_MENU.EXT4
  is '扩展字段4';
comment on column E_MENU.MEMO
  is '注释';
comment on column E_MENU.ORD
  is '排序';
comment on column E_MENU.ATTACHMENT
  is '附件地址';
comment on column E_MENU.RESOURCE_STATE
  is '菜单状态，1：数据开发中，2：程序开发中，3：正式（默认）
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
  is '页面指标';
comment on column E_MENU_IND.ID
  is 'ID';
comment on column E_MENU_IND.RESOURCES_ID
  is '菜单编码';
comment on column E_MENU_IND.IND_ID
  is '指标编码';

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
  is '操作类型码表';
comment on column E_OPERATE_TYPE.OPERATE_TYPE_CODE
  is '操作类型编号';
comment on column E_OPERATE_TYPE.OPERATE_TYPE_DESC
  is '操作类型描述';
comment on column E_OPERATE_TYPE.ORD
  is '排序';

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
  is '交互性操作日志';
comment on column E_OPERATION_LOG.USER_ID
  is '登录ID';
comment on column E_OPERATION_LOG.MENU_ID
  is '菜单编号';
comment on column E_OPERATION_LOG.OPERATE_TYPE_CODE
  is '操作类型';
comment on column E_OPERATION_LOG.OPERATE_RESULT
  is '操作结果';
comment on column E_OPERATION_LOG.CONTENT
  is '操作内容';
comment on column E_OPERATION_LOG.CLIENT_IP
  is 'IP地址';
comment on column E_OPERATION_LOG.CREATE_DATE
  is '创建时间';

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
  is '系统公告';
comment on column E_POST.POST_ID
  is '公告ID';
comment on column E_POST.POST_TITLE
  is '公告标题';
comment on column E_POST.ISSUE_DATE
  is '发布时间';
comment on column E_POST.BEGIN_DATE
  is '开始时间';
comment on column E_POST.END_DATE
  is '结束时间';
comment on column E_POST.POST_STATE
  is '公告状态:1已发布,0未发布';
comment on column E_POST.POST_CONTENT
  is '公告内容';
comment on column E_POST.UPDATE_DATE
  is '操作修改时间';
comment on column E_POST.USER_ID
  is '操作人编号';
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
  is '公告角色';
comment on column E_POST_ROLE.POST_ID
  is '公告ID';
comment on column E_POST_ROLE.ROLE_CODE
  is '角色ID';
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
  is '系统资源类型';
comment on column E_RESOURCES_TYPE.RESOURCES_TYPE_ID
  is '资源类型编码';
comment on column E_RESOURCES_TYPE.RESOURCES_TYPE_NAME
  is '资源类型名称';
comment on column E_RESOURCES_TYPE.ORD
  is '排序';

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
  is '角色';
comment on column E_ROLE.ROLE_CODE
  is '角色编码';
comment on column E_ROLE.PARENT_CODE
  is '上级角色编码';
comment on column E_ROLE.ROLE_NAME
  is '角色名称';
comment on column E_ROLE.MEMO
  is '角色描述';
comment on column E_ROLE.ORD
  is '排序';
comment on column E_ROLE.SUBSYSTEM_ID
  is '子系统编码';
comment on column E_ROLE.CREATED_USER
  is '创建人';
comment on column E_ROLE.CREATED_DATE
  is '创建时间';
comment on column E_ROLE.MODIFIED_USER
  is '更新人';
comment on column E_ROLE.MODIFIED_DATE
  is '更新时间';
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
  is '角色权限';
comment on column E_ROLE_PERMISSION.ROLE_CODE
  is '角色编号';
comment on column E_ROLE_PERMISSION.MENU_ID
  is '资源编码';
comment on column E_ROLE_PERMISSION.AUTH_CREATE
  is '创建权限';
comment on column E_ROLE_PERMISSION.AUTH_READ
  is '读取权限';
comment on column E_ROLE_PERMISSION.AUTH_UPDATE
  is '更新权限';
comment on column E_ROLE_PERMISSION.AUTH_DELETE
  is '删除权限';
comment on column E_ROLE_PERMISSION.AUTH_EXPORT
  is '导出权限';
comment on column E_ROLE_PERMISSION.AUTH_ISSUED
  is '下发权限';

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
  is '用户表';
comment on column E_USER.USER_ID
  is '用户ID';
comment on column E_USER.LOGIN_ID
  is '登录ID';
comment on column E_USER.PASSWORD
  is '密码';
comment on column E_USER.USER_NAME
  is '用户姓名';
comment on column E_USER.ADMIN
  is '管理员';
comment on column E_USER.SEX
  is '性别';
comment on column E_USER.EMAIL
  is '邮箱地址';
comment on column E_USER.MOBILE
  is '移动电话';
comment on column E_USER.TELEPHONE
  is '固定电话';
comment on column E_USER.STATE
  is '状态，1为启用，0停用';
comment on column E_USER.PWD_STATE
  is '密码状态，是否加密';
comment on column E_USER.MEMO
  is '备注信息';
comment on column E_USER.REG_DATE
  is '注册时间';
comment on column E_USER.UPDATE_DATE
  is '更新时间';
comment on column E_USER.REG_USER
  is '注册人';
comment on column E_USER.UPDATE_USER
  is '更新人';
comment on column E_USER.EXT1
  is '扩展属性1';
comment on column E_USER.EXT2
  is '扩展属性2';
comment on column E_USER.EXT3
  is '扩展属性3';
comment on column E_USER.EXT4
  is '扩展属性4';
comment on column E_USER.EXT5
  is '扩展属性5';
comment on column E_USER.EXT6
  is '扩展属性6';
comment on column E_USER.EXT7
  is '扩展属性7';
comment on column E_USER.EXT8
  is '扩展属性8';
comment on column E_USER.EXT9
  is '扩展属性9';
comment on column E_USER.EXT10
  is '扩展属性10';
comment on column E_USER.EXT11
  is '扩展属性11';
comment on column E_USER.EXT12
  is '扩展属性12';
comment on column E_USER.EXT13
  is '扩展属性13';
comment on column E_USER.EXT14
  is '扩展属性14';
comment on column E_USER.EXT15
  is '扩展属性15';
comment on column E_USER.EXT16
  is '扩展属性16';
comment on column E_USER.EXT17
  is '扩展属性17';
comment on column E_USER.EXT18
  is '扩展属性18';
comment on column E_USER.EXT19
  is '扩展属性19';
comment on column E_USER.EXT20
  is '扩展属性20';
comment on column E_USER.EXT21
  is '扩展属性21';
comment on column E_USER.EXT22
  is '扩展属性22';
comment on column E_USER.EXT23
  is '扩展属性23';
comment on column E_USER.EXT24
  is '扩展属性24';
comment on column E_USER.EXT25
  is '扩展属性25';
comment on column E_USER.EXT26
  is '扩展属性26';
comment on column E_USER.EXT27
  is '扩展属性27';
comment on column E_USER.EXT28
  is '扩展属性28';
comment on column E_USER.EXT29
  is '扩展属性29';
comment on column E_USER.EXT30
  is '扩展属性30';

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
  is '用户与企业账户对应关系';
comment on column E_USER_ACCOUNT.ACCOUNT_CODE
  is '账号编码';
comment on column E_USER_ACCOUNT.USER_ID
  is '用户ID';

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
  is '用户属性表';
comment on column E_USER_ATTRIBUTE.USER_ID
  is '用户ID';
comment on column E_USER_ATTRIBUTE.ATTR_CODE
  is '属性编码';
comment on column E_USER_ATTRIBUTE.ATTR_VALUE
  is '属性值';
comment on column E_USER_ATTRIBUTE.REG_DATE
  is '注册时间';
comment on column E_USER_ATTRIBUTE.UPDATE_DATE
  is '更新时间';
comment on column E_USER_ATTRIBUTE.REG_USER
  is '注册人';
comment on column E_USER_ATTRIBUTE.UPDATE_USER
  is '更新人';

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
  is '用户扩展属性配置';
comment on column E_USER_ATTR_DIM.ATTR_CODE
  is '扩展属性编码';
comment on column E_USER_ATTR_DIM.ATTR_NAME
  is '扩展属性名称';
comment on column E_USER_ATTR_DIM.PARENT_CODE
  is '上级编码';
comment on column E_USER_ATTR_DIM.SHOW_MODE
  is '扩展属性页面展现模式';
comment on column E_USER_ATTR_DIM.CODE_TABLE
  is '候选项编码表';
comment on column E_USER_ATTR_DIM.CODE_KEY
  is '候选项编码表编码字段';
comment on column E_USER_ATTR_DIM.CODE_PARENT_KEY
  is '候选项上级编码字段';
comment on column E_USER_ATTR_DIM.CODE_DESC
  is '候选项编码表描述字段';
comment on column E_USER_ATTR_DIM.CODE_ORD
  is '候选项编码表排序字段';
comment on column E_USER_ATTR_DIM.DATA_TYPE
  is '属性值类型';
comment on column E_USER_ATTR_DIM.MULTI
  is '是否多选';
comment on column E_USER_ATTR_DIM.ATTR_ORD
  is '排序';
comment on column E_USER_ATTR_DIM.IS_NULL
  is '扩展属性值是否为空';
comment on column E_USER_ATTR_DIM.DEFAULT_VALUE
  is '扩展属性为空时候的默认值';
comment on column E_USER_ATTR_DIM.DEFAULT_DESC
  is '扩展属性为空时候的默认描述(用于下拉列表)';
comment on column E_USER_ATTR_DIM.SUBSYSTEM_ID
  is '子系统编码';
comment on column E_USER_ATTR_DIM.ATTR_DESC
  is '扩展属性描述，针对的是该扩展属性';

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
  is '用户页面收藏表';
comment on column E_USER_COLLECT.USER_ID
  is '用户ID';
comment on column E_USER_COLLECT.MENU_ID
  is '页面ID';
comment on column E_USER_COLLECT.COLLECT_DATE
  is '收藏时间';
comment on column E_USER_COLLECT.IDX
  is '排序';

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
  is '属性值类型编码';
comment on column E_USER_EXTVALUE_TYPE.TYPE_DESC
  is '属性值类型编码描述';
comment on column E_USER_EXTVALUE_TYPE.TYPE_VALUE
  is '属性值类型';

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
  is '用户扩展属性对应关系表';
comment on column E_USER_EXT_COLUMN_ATTR.ATTR_CODE
  is '扩展属性编码';
comment on column E_USER_EXT_COLUMN_ATTR.COLUMN_NAME
  is '对应user表字段名';

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
  is '展现模式编码';
comment on column E_USER_EXT_MODEL.MODEL_DESC
  is '展现模式描述';

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
  is '用户权限';
comment on column E_USER_PERMISSION.USER_ID
  is '用户编号';
comment on column E_USER_PERMISSION.MENU_ID
  is '资源编码';
comment on column E_USER_PERMISSION.AUTH_CREATE
  is '创建权限';
comment on column E_USER_PERMISSION.AUTH_READ
  is '读取权限';
comment on column E_USER_PERMISSION.AUTH_UPDATE
  is '更新权限';
comment on column E_USER_PERMISSION.AUTH_DELETE
  is '删除权限';
comment on column E_USER_PERMISSION.AUTH_EXPORT
  is '导出权限';

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
  is '用户角色';
comment on column E_USER_ROLE.ROLE_CODE
  is '角色ID';
comment on column E_USER_ROLE.USER_ID
  is '用户ID';
comment on column E_USER_ROLE.CREATE_USER
  is '创建人';
comment on column E_USER_ROLE.CREATED_DATE
  is '创建时间';
comment on column E_USER_ROLE.MODIFIED_USER
  is '更新人';
comment on column E_USER_ROLE.MODIFIED_DATE
  is '更新时间';

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
  is '企业账号信息表';
comment on column OCT_ACCOUNT.ACCOUNT_CODE
  is '账号编码';
comment on column OCT_ACCOUNT.ACCOUNT_NAME
  is '账号名称';
comment on column OCT_ACCOUNT.ACCOUNT_DESC
  is '账号描述';
comment on column OCT_ACCOUNT.CREATED_USER
  is '创建人';
comment on column OCT_ACCOUNT.CREATED_DATE
  is '创建时间';
comment on column OCT_ACCOUNT.MODIFIED_USER
  is '修改人';
comment on column OCT_ACCOUNT.MODIFIED_DATE
  is '修改时间';

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
         replace(replace(to_char(add_months(sysdate, - (rownum - 1)), 'yyyy/mm\'),'/','年'),'\','月') acct_desc
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

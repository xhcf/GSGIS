var ua;
var inorout;//1为拨出方，0为接电话方
var sessionUI = {};
var receivePlaySound$;
sessionUI.isClose = 1; //设置状态，0：通话中，来电小结页面不可关闭，1：通话结束，来电小结可关闭

//初始化绑定事件
function initial(){

	/*var uri = '1022@1493979535316.com';
	var wssStr='wss://yy.91callcenter.cn:17443';
	var config = {
		uri: uri,
		wsServers: wssStr,
		authorizationUser: 1022,
		password: 19027161,
		userAgentString: "SIP.js/0.7.0 BB",
		iceCheckingTimeout: 500,
		rel100:SIP.C.supported.SUPPORTED,
		registerExpires: 60,
		traceSip: true
	};

	ua = new SIP.UA(config);*/
	setTimeout(function(){
		//判断sip是否注册成功
		if(!ua.isConnected()){
			var url = 'https://'+fsInfo.wss_ip+':'+fsInfo.wss_port;
			layer.alert('软电话未注册成功，请点确定，在新打开的页面中点击高级，再点击继续前往！', function(index){
				window.open(url);
				layer.close(index);
			});
		}
	}, 3000);

	//注册
	ua.on('registered', function () {
	});

	//签出
	ua.on('unregistered', function () {
		layer.msg('座席未注册！', {
			shade : 0.3,
			time : 2000
		});
		$("#status_check_out").click();
		sessionUI.isClose = 1;
	});

	//呼叫保持
	$('#status_hold').click(function(){
		hold$();
	});
	//呼叫保持
	$('#status_unhold').click(function(){
		unhold$();
	});
}



//发起sip invite请求，初始化信息
function sendSipInviteRequest(uri) {
	var options = {
		    media: {
		        constraints: {
		            audio: true,
		            video: false
		        }
		    }
	};
	var session = ua.invite(uri, options);
	inorout = 1; //呼出
	sessionUI.isClose = 0; //设置呼叫状态：呼叫中
	createNewSessionUI(uri, session);
}

/**
 *
 * @param uri	电话号码
 * @param session
 */
function createNewSessionUI(uri, session) {

	uri = session ? session.remoteIdentity.uri : SIP.Utils.normalizeTarget(uri, ua.configuration.hostport_params);
	if (!uri) {
		return;
	}

	//sessionUI.x_uuid = "";
	sessionUI.showTime = new showTime();
	sessionUI.session = session;
	sessionUI.renderHint = {
		remote : document.getElementById('right_video')
	};

	if (session && !session.accept) {
//		updateStatus(2);
	} else if (!session) {
		clearInterval(receivePlaySound$);// 关闭振铃
	}

	if (session) {
		setUpListeners();
	}

	function setUpListeners() {

		if (session.accept) {
			//sessionUI.x_uuid = sessionUI.session.request.getHeader("X_uuid");
			//弹框接电话
			var options = {
					media : {
						constraints : {
							audio : true,
							video : false
						}
					}
				};
			session.accept(options);
		}

		sessionUI.session.on('progress', function(response) {

			/*sessionUI.x_uuid = response.getHeader("X_uuid");*/
			var uuid=response.getHeader("X-Fs-Data");
			if(!sessionUI.session['uuid'] && uuid){
				uuid=uuid.split('=')[1];
				sessionUI.uuid=uuid;
			}
			$("#call_status").text("接听中...");
			$("#call_bye").unbind();
			$("#call_bye").on("click",function(){
				call_bye();
				layer.msg("结束通话");
				layer.close(call_out_handler);
			});
			$("#call_bye").show();

			$("#call_cancel").hide();
			$("#call_cancel").unbind();
		});

		sessionUI.session.on('accepted',
				function(response) {
					//$("#call_status").text("...");
					clearInterval(receivePlaySound$);// 关闭振铃
					if(inorout == 0){  //呼入
						//解析呼入号码
						$("#right_video").show();
						var comingPhone = session.remoteIdentity.uri.toString().replace("sip:", "");
						comingPhone = comingPhone.substring(0, comingPhone.indexOf("@"));
						if (comingPhone.length == 12 && /^01/.test(comingPhone)) {
							comingPhone = comingPhone.substring(1);
						}

						alert("呼叫号码"+comingPhone);

					}
					sessionUI.showTime.begin();
				});

		sessionUI.session.mediaHandler.on('addStream', function() {
			session.mediaHandler.render(sessionUI.renderHint);
		});

		//电话挂断
		sessionUI.session.on('bye', function() {
			callRecordProcess(1);
			console.log("主叫挂断");
			$("#call_status").text("通话结束");
			$("#call_bye").hide();
			$("#call_bye").unbind();
			$("#call_cancel").unbind();
			$("#call_cancel").on("click",function(){
				call_cancel();
				layer.msg("通话结束");
				$("#call_status").text("通话结束");
				layer.close(call_out_handler);
			});
			$("#call_cancel").show();
			$("#right_video").hide();
		});

		//电话挂断
		sessionUI.session.on('failed',function(response, cause) {
			callRecordProcess(1);
			console.log("被叫挂断");
			$("#call_status").text("通话结束");
			$("#call_bye").hide();
			$("#call_bye").unbind();
			$("#call_cancel").unbind();
			$("#call_cancel").on("click",function(){
				call_cancel();
				layer.msg("通话结束");
				$("#call_status").text("通话结束");
				layer.close(call_out_handler);
			});
			$("#call_cancel").show();
			$("#right_video").hide();
		});

		sessionUI.session.on('refer', session.followRefer(onReferred));

		function onReferred(request, newSession) {
			// attached the received video stream to the Video Elements
			attachMediaStream(remoteVideo, newSession.mediaHandler.getRemoteStreams()[0]);
		}
	}
}

function callRecordProcess(state) {



	sessionUI.showTime.stop();
	delete sessionUI.showTime;
	delete sessionUI.session;

	sessionUI.isClose = 1;

	clearInterval(receivePlaySound$);//关闭振铃
	//挂机提示

	//alert("电话挂断");

}

//通话保持
function hold$() {
	sessionUI.session.hold();
	alert("通话保持");
}

// 恢复通话
function unhold$() {
//	updateStatus(2);
	sessionUI.session.unhold();
	alert("通话恢复");
}

// 静音
function mute$() {
	var options1 = {
		audio : true,
		video : true
	};
	session.mute(options1);
}

// 取消静音
function unmute$() {
	var options1 = {
		audio : true,
		video : true
	};
	session.unmute(options1);
}

function showTime(){
   	//通话倒计时
	 var CallTime = CallTime || {};
	 CallTime.timeIndex = 0;
	 //开始计时
	 CallTime.begin = function(){
		 CallTime.timeIndex = 0;
		 //$(window.frames[0].document).find(".ui-dialog-calling").html("");
		 //$("#"+id).html("");
		 $("#call_status").text("");
		 CallTime.setTime();
		 times = setInterval(CallTime.setTime, 1000);//每隔1秒执行函数
	  };
	  //停止计时
	  CallTime.stop = function(){
	      if(typeof(times) != "undefined"){
	          clearInterval(times);//清除对函数的调用
	      }
	  };
	  CallTime.setTime = function(){
		 var hour = parseInt(CallTime.timeIndex / 3600);    // 计算时
		 var minutes = parseInt((CallTime.timeIndex % 3600) / 60);    // 计算分
		 var seconds = parseInt(CallTime.timeIndex % 60);    // 计算秒
		 hour = hour < 10 ? "0" + hour : hour;
		 minutes = minutes < 10 ? "0" + minutes : minutes;
		 seconds = seconds < 10 ? "0" + seconds : seconds;
		 //$(window.frames[0].document).find(".ui-dialog-calling").html(hour + ":" + minutes + ":" + seconds);
		 //$("#"+id).html(hour + ":" + minutes + ":" + seconds);
		 $("#call_status").text("通话中: "+hour + ":" + minutes + ":" + seconds);
		 CallTime.timeIndex++;
	  };
	  return CallTime;
}

function getNowTime() {
    var now = new Date();
    var year = now.getFullYear(); //getFullYear getYear
    var month = now.getMonth();
    var date = now.getDate();
    var day = now.getDay();
    var hour = now.getHours();
    var minu = now.getMinutes();
    var sec = now.getSeconds();
    month = month + 1;
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
    if (hour < 10) hour = "0" + hour;
    if (minu < 10) minu = "0" + minu;
    if (sec < 10) sec = "0" + sec;
    var time = "";
    time = year + "-" + month + "-" + date  + " " + hour + ":" + minu + ":" + sec ;
    return time;
}

var layerDialog = null;
function layer_show2(title, url, w, h) {
	if (w == null || w == '') {
		w = 800;
	}
	if (h == null || h == '') {
		h = ($(window).height() - 50);
	}
	layerDialog = layer.open({
		type : 2,
		area : [ w + 'px', h + 'px' ],
		shadeClose : true,
		closeBtn:0,
		shade : 0.01,
		anim : 1, //0-6的动画形式，-1不开启
		maxmin : true, //开启最大化最小化按钮
		fix : false, //不固定
		scrollbar : false, //屏蔽游览器滚动条
		title : title,
		content : url,
		success: function(layero, index){
			$('.layui-layer-shade').off('click');
	    },
	});
}
//关闭弹出层
function closeLayer(){
	layer.close(layerDialog);
}

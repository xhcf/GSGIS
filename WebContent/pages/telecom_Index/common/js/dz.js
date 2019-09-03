/**
 *实现对象数组打印效果 
 * @param {Object} objarr
 * @param {Object} textarr  为字符类型数组 
 */
function start_Arr(objarr,textarr){
       var count = 6;
       var arrindex = 0;
       if(objarr!=null && objarr.length == count)   {   //初始if开始
        var oldtext =　objarr[arrindex].text();
        if(oldtext=="- -"){
            var length = textarr[arrindex].length;
            var index = 0;
            for(var i=0 ; i<count; i++){
                objarr[i].text('');
                objarr[i].css("color","#ffffff");
            }
            var tId=setInterval(function(){
                objarr[arrindex].append("<font>"+textarr[arrindex].charAt(index)+"</font>");    
                if(++index === length){
                    index = 0;
                    objarr[arrindex].css("color","#f7d700");    
                    if(++arrindex === count){
                    index = 0;
                    arrindex = 0;
                    clearInterval(tId);
                    }
                    length = textarr[arrindex].length;
                }
            },200);
        }else{ 
            var spanarr = objarr[arrindex].children();
            oldtext = objarr[arrindex].text();
            var length = textarr[arrindex].length;
            var length1 = oldtext.length;
            var index = 0;
            var tId=setInterval(function(){
                if(index>length1){
                    obj.append("<font style='color:red'>"+textarr[arrindex].charAt(index)+"</font>");
                }else{
                    $(spanarr[index]).css({"color":"#ffffff"});
                    $(spanarr[index]).text(textarr[arrindex].charAt(index));
                }
                if(index++ === length){
                    index = 0;
                    var spanarr1 = objarr[arrindex].children();
                    for(var i=0;i<spanarr1.length;i++){
                        $(spanarr1[i]).css({"color":"#f7d700"});
                    }
                    if(arrindex++ === count){
                        index = 0;
                        arrindex = 0;
                        clearInterval(tId);
                    }
                    length = textarr[arrindex].length;
                    oldtext = objarr[arrindex].text();
                    length1 = oldtext.length;
                    spanarr = objarr[arrindex].children();
                }
            },200);    
        }       
     }else{  //初始if结束
         alert("参数有误，请联系系统管理员！！！");
     }
  }
/**
 *单个对象打印,text为字符类型 
 */
 var tId;
 function start_obj(obj,text){      
      var oldtext = obj.text();
      if(oldtext.indexOf("-") != -1){
    	  obj.innerHTML="";
          var length = text.length;
          var index = 0;
          obj.text('');
          obj.css("color","#ffffff");
          clearInterval(tId);
          tId=setInterval(function(){
            obj.append("<font>"+text.charAt(index)+"</font>");              
            if(index++ === length){
                obj.css("color","#f7d700");
                clearInterval(tId);
                index = 0;
            }
          },300);
      }else{
          var spanarr = obj.children();
          //console.log(spanarr);
          var length = text.length;
          var length1 = oldtext.length;
          var index = 0;
          clearInterval(tId);
          tId=setInterval(function(){       
          if(index>=length1){
            obj.append("<font style='color:red'>"+text.charAt(index)+"</font>");
          }else{
            $(spanarr[index]).css({"color":"#ffffff"});
            $(spanarr[index]).text(text.charAt(index));
          }     
            if(index++ === length){                 
                clearInterval(tId);
                index = 0;
                var spanarr1 = obj.children();
                for(var i=0;i<spanarr1.length;i++){
                $(spanarr1[i]).css({"color":"#f7d700"});
                }
            }
          },300);
           
      }     
    }
 
 var tId1;
 function start_obj1(obj,text){      
      var oldtext = obj.text();
      if(oldtext.indexOf("-") != -1){
        obj.innerHTML="";
          var length = text.length;
          var index = 0;
          obj.text('');
          obj.css("color","#ffffff");
          clearInterval(tId1);
          tId1=setInterval(function(){
            obj.append("<font>"+text.charAt(index)+"</font>");              
            if(index++ === length){
                obj.css("color","#f7d700");
                clearInterval(tId1);
                index = 0;
            }
          },300);
      }else{
          var spanarr = obj.children();
          //console.log(spanarr);
          var length = text.length;
          var length1 = oldtext.length;
          var index = 0;
          clearInterval(tId1);
          tId1=setInterval(function(){       
          if(index>=length1){
            obj.append("<font style='color:red'>"+text.charAt(index)+"</font>");
          }else{
            $(spanarr[index]).css({"color":"#ffffff"});
            $(spanarr[index]).text(text.charAt(index));
          }     
            if(index++ === length){                 
                clearInterval(tId1);
                index = 0;
                var spanarr1 = obj.children();
                for(var i=0;i<spanarr1.length;i++){
                $(spanarr1[i]).css({"color":"#f7d700"});
                }
            }
          },300);
           
      }     
    }
 
 var tId2;
 function start_obj2(obj,text){      
      var oldtext = obj.text();
      if(oldtext.indexOf("-") != -1){
        obj.innerHTML="";
          var length = text.length;
          var index = 0;
          obj.text('');
          obj.css("color","#ffffff");
          clearInterval(tId2);
          tId2=setInterval(function(){
            obj.append("<font>"+text.charAt(index)+"</font>");              
            if(index++ === length){
                obj.css("color","#f7d700");
                clearInterval(tId2);
                index = 0;
            }
          },300);
      }else{
          var spanarr = obj.children();
          //console.log(spanarr);
          var length = text.length;
          var length1 = oldtext.length;
          var index = 0;
          clearInterval(tId2);
          tId2=setInterval(function(){       
          if(index>=length1){
            obj.append("<font style='color:red'>"+text.charAt(index)+"</font>");
          }else{
            $(spanarr[index]).css({"color":"#ffffff"});
            $(spanarr[index]).text(text.charAt(index));
          }     
            if(index++ === length){                 
                clearInterval(tId2);
                index = 0;
                var spanarr1 = obj.children();
                for(var i=0;i<spanarr1.length;i++){
                $(spanarr1[i]).css({"color":"#f7d700"});
                }
            }
          },300);
           
      }     
    }
 
  function start1(obj,text){        
        obj.innerHTML="";
        var length = text.length;
        var index = 0;
        obj.text('');
        obj.css("color","#ffffff");
        var tId=setInterval(function(){
            obj.append(text.charAt(index));
            if(index++ === length){
                obj.css("color","#f7d700");
              clearInterval(tId);
              index = 0;
            }
          },300);
        }
    //打字效果
    function start2(obj,text){
        obj.innerHTML="";
        var length = (text+"").length;
        var index = 0;
        obj.text('');
        obj.css("color","#ffffff");
        var startInterval=setInterval(function(){
            obj.append((text+"").charAt(index));
            if(index++ === length){
                obj.css("color","#f7d700");
                clearInterval(startInterval);
                index = 0;
            }
        },300);
    }
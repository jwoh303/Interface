	/**
	 * 공통 form에서 submit 호출 시 로딩바 이미지 출력
	 */	
	$(document).ready(function(){
		$(document).find('form').bind('submit',function(e){
			loader_obj("Y");
		});
//		if(window.opener == null){
//			$(window).on('unload', function(e) {
//				explorer_x();
//			});
//		}		
	});
	
//	function explorer_x() {
//			 if(window.event.clientY < 0 ){
//			 		$.ajax({
//			 		      type: "POST",
//			 		      dataType:"json",
//			 		      url: "/login/logout2.do",
//			 		     async : false,
//			 		     success:function( response ) {  		    	 
//			 			      },
//			 			 error:function( response ) {  		    	   
//			 			      }
//					    });  
//			 }
//	} 
	
	//BackSpace키방지 
//	window.document.onkeydown=onKeyDown; 
//	function onKeyDown(e) { 
//	    if (navigator.appName == "Microsoft Internet Explorer") {
//	        if( event.keyCode == 0x25 && event.altKey == true ) { 
//	            return false ; 
//	        } 
//	        for (var i = 0; i < document.all.tags("INPUT").length; i++) { 
//	            if (document.all.tags("INPUT")(i).name == window.event.srcElement.name && 
//	                (document.all.tags("INPUT")(i).type == "text" || document.all.tags("INPUT")(i).type == "password") && 
//	                 document.all.tags("INPUT")(i).readOnly == false){ 
//	                return true; 
//	            } 
//	        } 
//	        for (var i = 0; i < document.all.tags("TEXTAREA").length; i++) { 
//	            if (document.all.tags("TEXTAREA")(i).name == window.event.srcElement.name && 
//	                document.all.tags("TEXTAREA")(i).readOnly == false){ 
//	                return true; 
//	            } 
//	        } 
//	        if( event.keyCode == 8 ) { 
//	            return false; 
//	        }
//	    } else {
//			if (navigator.appName == "Netscape") {
//				if (e.which == 8) {
//					return false;
//				} 
//			}
//		}
//	}		



	
	/**
	 * Ibsheet 용 공통콤보 생성 
	 * code 공통의 조회조건
	 *  ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * gubun ALL,SEL
	 * 
	 * ICOMCOD1 전용
	 */
	function KepSheetComboData(code,gubun){
		return KepSheetTotalComboData(code,gubun,"","","");
	 }
	
	/**
	 * Ibsheet 용 공통콤보 생성 
	 * code 공통의 조회조건 (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 *  ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * gubun ALL,SEL
	 * commonTableGubun 공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5
	 * optionCode 화면에 뿌릴 option code
	 * optionValue 화면에 뿌릴 option value
	 */
	function KepSheetTotalComboData(code,gubun,commonTableGubun,optionCode,optionValue){
		
		if (commonTableGubun==""){
			commonTableGubun = "ICOMCOD1";
		}
		if (optionCode==""){
			optionCode = "CODE";
		}
		if (optionValue==""){
			optionValue = "TEXT1";
		}
		
	    var t = "";
	    var c = ""; 
	    var o = false;
		if (gubun == "SEL"){
			 t =  t + "선택";
			 c = c + "";
		}else if (gubun == "ALL"){
			t =  t + "전체";
			c = c + "";
		}else if (gubun == "SPACE"){
			t =  t + "";
			c = c + "";
		}else{
			o = true;
		}
 		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: "/common/ajaxCombo.do",
 		     data: { TYPE: code,COMMONTABLEGUBUN:commonTableGubun },
 		     async : false,
 		     success:function( response ) {  		    	 
 		    	 	  if (response.data.length > 0){
		 		    	  for (var i=0; i<response.data.length; i++){ 		 		    		  
			 		    	var code = $.trim(eval("response.data["+i+"]."+optionCode));
			 		    	var value = $.trim(eval("response.data["+i+"]."+optionValue));			 		    		 
	                        if ( o ) {
	                        	t += $.trim(value);
	                        	c += $.trim(code);
	                        	o = false;
	                        } else {
	                        	t += $.trim("|"+value);
	                        	c += $.trim("|"+code);
				 		     }
			 		      }	 		    	   
 		    	 	  }
 			      },
 			 error:function( response ) {  		    	   
 		    	 alert("오류발생하였습니다.");
 			      }
		    });  
 		
	    var result = {}; 	 
	    result.ComboCode = c.substring(0);
	    result.ComboText = t.substring(0);
	    return result;
	   }	
	
	/**
	 * Ibsheet 용 공통콤보 생성 
	 * queryId 쿼리아이디
	 * gubun ALL,SEL
	 */
	function KepSheetComboQueryIdData(queryId,gubun, search){
	    var t = "";
	    var c = ""; 
	    var o = false;
		if (gubun == "SEL"){
			 t =  t + "선택";
			 c = c + "";
		}else if (gubun == "ALL"){
			t =  t + "전체";
			c = c + "";
		}else if (gubun == "SPACE"){
			t =  t + "";
			c = c + "";
		}else{
			o = true;
		}		
 		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: "/common/ajaxQueryIdCombo.do",
 		      data: { QUERYID: queryId , SEARCH : search},
 		     async : false,
 		     success:function( response ) {  		    	 
	 		    	 if (response.data.length > 0){
		 		    	  for (var i=0; i<response.data.length; i++){ 
		 		    		 if ( o ) {
		 		    			 t += $.trim(response.data[i].TEXT1); // 쿼리 고정
		 		    			 c += $.trim(response.data[i].CODE); // 쿼리 고정
		 		    			 o = false;
		 		    		 } else {
		 		    			 t += $.trim("|"+response.data[i].TEXT1); // 쿼리 고정
		 		    			 c += $.trim("|"+response.data[i].CODE); // 쿼리 고정
		 		    		 }
			 		      }	 		    	   
	 		    	  }
 			      },
 			 error:function( response ) {  		    	   
 		    	 alert("오류발생하였습니다.");
 			      }
		    });  
 		
	    var result = {}; 	 
	    result.ComboCode = c.substring(0);
	    result.ComboText = t.substring(0);
	    return result;
	   }

	/**
	 * Ibsheet 용 공통콤보 생성 (No cache)
	 * queryId 쿼리아이디
	 * gubun ALL,SEL
	 */
	function KepSheetComboQueryIdDataNoCache(queryId,gubun, search){
	    var t = "";
	    var c = ""; 
	    var o = false;
		if (gubun == "SEL"){
			 t =  t + "선택";
			 c = c + "";
		}else if (gubun == "ALL"){
			t =  t + "전체";
			c = c + "";
		}else if (gubun == "SPACE"){
			t =  t + "";
			c = c + "";
		}else{
			o = true;
		}		
 		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: "/common/ajaxQueryIdComboNoCache.do",
 		      data: { QUERYID: queryId , SEARCH : search},
 		     async : false,
 		     success:function( response ) {  		    	 
	 		    	 if (response.data.length > 0){
		 		    	  for (var i=0; i<response.data.length; i++){ 
		 		    		 if ( o ) {
		 		    			 t += $.trim(response.data[i].TEXT1); // 쿼리 고정
		 		    			 c += $.trim(response.data[i].CODE); // 쿼리 고정
		 		    			 o = false;
		 		    		 } else {
		 		    			 t += $.trim("|"+response.data[i].TEXT1); // 쿼리 고정
		 		    			 c += $.trim("|"+response.data[i].CODE); // 쿼리 고정
		 		    		 }
			 		      }	 		    	   
	 		    	  }
 			      },
 			 error:function( response ) {  		    	   
 		    	 alert("오류발생하였습니다.");
 			      }
		    });  
 		
	    var result = {}; 	 
	    result.ComboCode = c.substring(0);
	    result.ComboText = t.substring(0);
	    return result;
	   }

	
	/**
	 * 공통콤보 생성
	 * code 공통의 조회조건 (공통테이블구분 ICOMCOD1)
	 *  ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * value 의 selectbox 에 생성한다.
	 * gubun SEL,ALL
	 * 
	 * 무조건 ICOMCOD1 을 이용한다. kepAjaxCommonTotalCombo 참조
	 */
	function kepAjaxCommonCombo(value,code,gubun) {  		
		kepAjaxCommonTotalCombo(value,code,gubun,"","","","");
	}
	
	/**
	 * 공통콤보 생성
	 * code 공통의 조회조건 (공통테이블구분 ICOMCOD1)
	 *  ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * value 의 selectbox 에 생성한다.
	 * gubun SEL,ALL
	 * dataValue 실제의db 결과 selected 를 위한 값
	 * 무조건 ICOMCOD1 을 이용한다. kepAjaxCommonTotalCombo 참조
	 */
	function kepAjaxCommonComboDataValue(value,code,gubun,dataValue) {  		
		kepAjaxCommonTotalCombo(value,code,gubun,"","","",dataValue);
	}
	
	function comboSelGubun(gubun) {
		var str = "";
		if (gubun == "SEL"){
			str = str + "<option value=''>선택</option>";
		}else if (gubun == "ALL"){
			str = str + "<option value=''>전체</option>";
		}else if (gubun == "ALL2"){
			str = str + "<option value='ALL'>전체</option>";
		}		
		return str;
	}
	
	function comboDataResult(response,optionCode,optionValue,dataValue) {
		
		var str = "";
	 	if (response.data.length > 0){
	    	  for (var i=0; i<response.data.length; i++){ 
	    		  
	    		 var code = $.trim(eval("response.data["+i+"]."+optionCode));
	    		 var value = $.trim(eval("response.data["+i+"]."+optionValue));
	    		 
	    		 if (code == dataValue){
	    			str = str + "<option value='"+code+"' selected>"+value+"</option>";
	    		 }else{
	    			 str = str + "<option value='"+code+"'>"+value+"</option>";
	    		 }
	    		 
		      }	 		    	
		  }   
	 	return str;
	}
	
	/**
	 * 공통콤보 생성
	 * code 공통의 조회조건 (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5) 
	 *  ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * viewId 화면의 selectbox id
	 * gubun SEL,ALL
	 * commonTableGubun 공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5
	 * optionCode 화면에 뿌릴 option code
	 * optionValue 화면에 뿌릴 option value
	 * dataValue 실제의db 결과 selected 를 위한 값
	 * funcObj 성공 후 콜백으로 사용자 정의 함수를 처리 하기 위한 호출 함수 변수
	 */
	function kepAjaxCommonTotalCombo(viewId,code,gubun,commonTableGubun,optionCode,optionValue,dataValue,funcObj) {  
		
		//alert("commonTableGubun " +commonTableGubun);
		if (commonTableGubun==""){
			commonTableGubun = "ICOMCOD1";
		}
		if (optionCode==""){
			optionCode = "CODE";
		}
		if (optionValue==""){
			optionValue = "TEXT1";
		}
		
		var str = "";
		str = comboSelGubun(gubun);
		
 		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: "/common/ajaxCombo.do",
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: { TYPE: code,COMMONTABLEGUBUN:commonTableGubun },
 		     async : false,
 		     success:function( response ) {
 		    	 if(typeof(funcObj) != "undefined"){
 		    		funcObj(response,viewId,str,optionCode,optionValue,dataValue);
 		    	 }else{
 		    		 str = str + comboDataResult(response,optionCode,optionValue,dataValue);
 		    		 
 		    		 $("#"+viewId).html(str);
 		    	 }
 		    	 	 		    	  
 		     },
 			 error:function( response ) {  		    	   
 		    	 alert("오류발생하였습니다.");
 			 }
		    });  
	}
	
	/**
	 * 공통콤보 생성
	 * queryId 
	 * viewId 화면의 selectbox id
	 * gubun SEL,ALL
	 * dataValue 실제의db 결과 selected 를 위한 값
	 */
	function kepAjaxCommonQueryIdCombo(viewId,queryId,gubun,dataValue,buyer) {  
		
		var str = "";
		str = comboSelGubun(gubun);
		
 		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: "/common/ajaxQueryIdCombo.do",
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: { QUERYID: queryId, BUYER:buyer },
 		     async : false,
 		     success:function( response ) {  		    	  
	 		    	  
 		    	 	 str = str + comboDataResult(response,"CODE","TEXT1",dataValue);
	 		    	 $("#"+viewId).html(str);
 			      },
 			 error:function( response ) {  		    	   
 		    	 alert("오류발생하였습니다.");
 			      }
		    });  
	}	
	
	/**
	 * 공통콤보 생성
	 * queryId 
	 * viewId 화면의 selectbox id
	 * 	search 조회조건 
	 * gubun SEL,ALL
	 * dataValue 실제의db 결과 selected 를 위한 값
	 */
	function kepAjaxCommonQueryIdSearchCombo(viewId,queryId,search,gubun,dataValue) {  
		
		var str = "";
		str = comboSelGubun(gubun);
		
 		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: "/common/ajaxQueryIdSearchCombo.do",
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: { QUERYID: queryId , SEARCH : search},
 		     async : false,
 		     success:function( response ) {  		    	  
	 		    	  
 		    	 	str = str + comboDataResult(response,"CODE","TEXT1",dataValue);
	 		    	 $("#"+viewId).html(str);
 			      },
 			 error:function( response ) {  		    	   
 		    	 alert("오류발생하였습니다.");
 			      }
		    });  
	}	
	
	/**
	 * 공통콤보 생성
	 * queryId 
	 * viewId 화면의 selectbox id
	 * 	search1 조회조건1 
	 * 	search2 조회조건2 
	 * gubun SEL,ALL
	 * dataValue 실제의db 결과 selected 를 위한 값
	 */
	function kepAjaxCommonQueryIdSearchTwoCombo(viewId,queryId,search1,search2,gubun,dataValue) {  
		
		var str = "";
		str = comboSelGubun(gubun);
		
		$.ajax({
			type: "POST",
			dataType:"json",
			url: "/common/ajaxQueryIdSearchCombo.do",
			headers: { 'X-Requested-With': 'XMLHttpRequest' },
			data: { QUERYID: queryId , SEARCH1 : search1, SEARCH2 : search2},
			async : false,
			success:function( response ) {  		    	  
				
				str = str + comboDataResult(response,"CODE","TEXT1",dataValue);
				$("#"+viewId).html(str);
			},
			error:function( response ) {  		    	   
				alert("오류발생하였습니다.");
			}
		});  
	}
	/**
	 * 공통콤보 생성
	 * queryId 
	 * viewId 화면의 selectbox id
	 * 	search1 조회조건1 
	 * 	search2 조회조건2
	 * 	search3 조회조건3 
	 * gubun SEL,ALL
	 * dataValue 실제의db 결과 selected 를 위한 값
	 */
	function kepAjaxCommonQueryIdSearchThreeCombo(viewId,queryId,search1,search2,search3,gubun,dataValue) {  
		
		var str = "";
		str = comboSelGubun(gubun);
		
		$.ajax({
			type: "POST",
			dataType:"json",
			url: "/common/ajaxQueryIdSearchCombo.do",
			headers: { 'X-Requested-With': 'XMLHttpRequest' },
			data: { QUERYID: queryId , SEARCH1 : search1, SEARCH2 : search2, SEARCH3 : search3},
			async : false,
			success:function( response ) {  		    	  
				str = str + comboDataResult(response,"CODE","TEXT1",dataValue);
				$("#"+viewId).html(str);
			},
			error:function( response ) {  		    	   
				alert("오류발생하였습니다.");
			}
		});  
	}
	/**
	 * 다중 선택 콤보 박스 생성 함수
	 */
	function kepAjaxCommonTotalMultiCombo(viewId,code,gubun,dataValue) {
		var strPlaceholder = "";
		if(gubun == "ALL"){
			strPlaceholder = "전체";
		}else if(gubun == "SEL"){
			strPlaceholder = "선택";
		}
		
		var selectObj = $("<select />", {
			id : viewId + "_spare",
			style : $("#"+viewId).attr("style") != undefined ? $("#"+viewId).attr("style") : "",
			className : $("#"+viewId).attr("class") != undefined ? $("#"+viewId).attr("class") : ""
		});
		
		$("#"+viewId).before(selectObj);
		$("#"+viewId + "_spare").multipleSelect({
			placeholder : strPlaceholder,
			selectAllText : "전체선택",
			onClose : function(){
				$("#"+viewId).val($("#"+viewId + "_spare").multipleSelect("getSelects"));
			}
		});
		
		kepAjaxCommonTotalCombo(viewId, code, "","","","", dataValue, callback_CommonTotalMultiCombo);
	}

	/**
	 * 다중 선택 콤보 박스 생성 함수(주문진행관리용)
	 */
	function kepAjaxCommonTotalMultiComboMpso(viewId,code,gubun,dataValue) {
		var strPlaceholder = "";
		if(gubun == "ALL"){
			strPlaceholder = "전체(발주삭제제외)";
		}else if(gubun == "SEL"){
			strPlaceholder = "선택";
		}
		
		var selectObj = $("<select />", {
			id : viewId + "_spare",
			style : $("#"+viewId).attr("style") != undefined ? $("#"+viewId).attr("style") : "",
			className : $("#"+viewId).attr("class") != undefined ? $("#"+viewId).attr("class") : ""
		});
		
		$("#"+viewId).before(selectObj);
		$("#"+viewId + "_spare").multipleSelect({
			placeholder : strPlaceholder,
			selectAllText : "전체선택(발주삭제포함)",
			onClose : function(){
				$("#"+viewId).val($("#"+viewId + "_spare").multipleSelect("getSelects"));
			}
		});
		
		kepAjaxCommonTotalCombo(viewId, code, "","","","", dataValue, callback_CommonTotalMultiCombo);
	}

	
	/**
	 * 다중 선택 콤보 선택 초기화
	 * @param viewId
	 */
	function init_multiCombo(viewId){
		$("#"+viewId+"_spare").multipleSelect("uncheckAll");
	}
	
	function callback_CommonTotalMultiCombo(response,viewId,str,optionCode,optionValue,dataValue){
		$("#"+viewId + "_spare").html(str + comboDataResult(response,optionCode,optionValue,""));
		$("#"+viewId + "_spare").multipleSelect("refresh");
		if(!isEmpty(dataValue)){
			var strSelects = dataValue.split(",");
			$("#"+viewId + "_spare").multipleSelect("setSelects", strSelects);
		}
	}
	
	/**
	 * 공통 ajax 호출 시 로딩 이미지 Show or Hide
	 */	
	function loader_close(){
		var close_loader = $(document).find(".kep_sub_loader").find(".kep_close_loader");
		$(close_loader).show();
	}
	var loader_obj_cnt = 0;
	function loader_obj(showYn, maxCnt){
		
		var timerId = null;
		
		if(showYn == "Y"){
			loader_obj_cnt = 0;
			timerId = setTimeout("loader_close()", 120 * 1000);
		}
		
		var loader_img = $(document).find(".kep_ajax_loader");
		var sub_loader = $(document).find(".kep_sub_loader");
		var close_loader = $(sub_loader).find(".kep_close_loader"); 
		var docWidth = $(document).width();
		var docHeight = $(document).height();

		if(loader_img == null || loader_img.length == 0){
			if(showYn == "Y"){
				loader_img = $("<div class='kep_ajax_loader'></div>");
				
				// UI 버전에 따라 로딩 이미지 분기 처리
				var uiVersion = window.SESSION_INFO && window.SESSION_INFO.uiVersion;
				if (uiVersion === "renewal") {
					// 리뉴얼 버전 로딩 이미지
					sub_loader = $('<div class="kep_sub_loader"><img src="/resources/libs/ibsheet7/js/DeepBlue/loading.svg" alt="조회중..." style="width: 150px; height: 100px;" /></div>');
					
					close_loader = $(sub_loader).find(".kep_close_loader");
					
					$(loader_img).css("background-color", "#000000");
					$(loader_img).css("opacity", "0.4");
					$(loader_img).css("top", "-5px");
					$(loader_img).css("width", docWidth);
					$(loader_img).css("height", docHeight);
					$(loader_img).css("position", "absolute");
					$(loader_img).css("z-index", "10000");
					
					$(sub_loader).css("position", "absolute");
					$(sub_loader).css("background-color", "#FFF");
					$(sub_loader).css("border-radius", "10px");
					$(sub_loader).css("box-shadow", "0 4px 20px rgba(0,0,0,0.3)");
					$(sub_loader).css("text-align", "center");
//					$(sub_loader).css("width", "200px");
					
					$(sub_loader).css("padding", "30px");
					$(sub_loader).css("z-index", "10001");
					
					$(close_loader).css("position", "absolute");
					$(close_loader).css("top", "5px");
					$(close_loader).css("right", "5px");
					$(close_loader).hide();
					
					if(docHeight > 1000){
						$(sub_loader).css("top", "300px" );
					}else{
						$(sub_loader).css("top", ( ( docHeight - 250 ) / 2 ) + "px" );
					}
					$(sub_loader).css("left", ( ( docWidth - 300 ) / 2  ) + "px" );
					$(document).find("body").append(loader_img);
					$(document).find("body").append(sub_loader);
					
					
					
					
				} else {
					// 레거시 버전 로딩 이미지 (빈값, null, 기타 포함)
						sub_loader = $('<div class="kep_sub_loader"><a href="javascript:loader_obj(\'N\');" class="kep_close_loader"><img src="/resources/images/loader/close.gif"></a><img src="/resources/images/loading02.gif" alt="로딩" /></br></br><img src="/resources/images/loadingtxt.gif" alt="로딩" /></div>');
				
						close_loader = $(sub_loader).find(".kep_close_loader");
						
						$(loader_img).css("background-color", "#000000");
						$(loader_img).css("opacity", "0.4");
						$(loader_img).css("top", "-5px");
						$(loader_img).css("width", docWidth);
						$(loader_img).css("height", docHeight);
						$(loader_img).css("position", "absolute");
						$(loader_img).css("z-index", "10000");
						
						$(sub_loader).css("position", "absolute");
						$(sub_loader).css("background-color", "#FFF");
						$(sub_loader).css("border", "2px solid #A6B0BA");
						$(sub_loader).css("text-align", "center");
						$(sub_loader).css("width", "250px");
						$(sub_loader).css("height", "150px");
						$(sub_loader).css("padding", "20px 0px 20px 0px");
//						$(sub_loader).css("height", "130px");
//						$(sub_loader).css("padding", "50px");
						$(sub_loader).css("z-index", "10000");
						
						$(close_loader).css("position", "absolute");
						$(close_loader).css("top", "5px");
						$(close_loader).css("right", "5px");
						$(close_loader).hide();
						
						if(docHeight > 1000){
							$(sub_loader).css("top", "300px" );
						}else{
							$(sub_loader).css("top", ( ( docHeight - 200 ) / 2 ) + "px" );
						}
						$(sub_loader).css("left", ( ( docWidth - 250 ) / 2  ) + "px" );
						$(document).find("body").append(loader_img);
						$(document).find("body").append(sub_loader);
				
				
				}
				
			}
		} else {
			if(showYn == "Y"){
				$(close_loader).hide();
				$(loader_img).show();
				$(sub_loader).show();
			}else{
				if(maxCnt != null || Number(maxCnt) > 0) loader_obj_cnt ++ ;
				
				if(maxCnt == null || loader_obj_cnt == Number(maxCnt)){
					 $(loader_img).hide();
					 $(sub_loader).hide();
					 $(close_loader).hide();
				}
			}
		}
	}
	
	/**
	 * 공통 ajax 호출 
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccess ,kepAjaxError 구현한다.
	 */	
	function kepAjaxCall(pUrl,pData,pMethod) {   
		loader_obj("Y");
		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: pUrl,
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: pData,
 		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
 		      success:function( response ) {  		    
 		    	 loader_obj("N");
  		    	 if(typeof response.Message != 'undefined'){
 		    		 kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
 		    		 return;
 		    	} 
  		    	 
 		    	 kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   },
 			   error:function( response, textStatus ) {
 				   	loader_obj("N");
 				   	if(textStatus == 'timeout'){
 				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
			   		} 				   
 				   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
					if(response.status == '403'){
						alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
						location.href = "/login/sub_login.do";
						return;
					} 				  
					kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   }
 		});  
	}
	function kepAjaxCallNoBar(pUrl,pData,pMethod) {   
		$.ajax({
			type: "POST",
			dataType:"json",
			url: pUrl,
			headers: { 'X-Requested-With': 'XMLHttpRequest' },
			data: pData,
			timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
			success:function( response ) {  		    
				if(typeof response.Message != 'undefined'){
					kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
					return;
				} 
				
				kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
			},
			error:function( response, textStatus ) {
				if(textStatus == 'timeout'){
					response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
				} 				   
				//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
				if(response.status == '403'){
					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
					location.href = "/login/sub_login.do";
					return;
				} 				  
				kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
			}
		});  
	}
	
	/**
	 * 공통 ajax 호출 
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccess ,kepAjaxError 구현한다.
	 */	
	function kepAjaxFormCall(pUrl,pForm,pMethod) {    
		loader_obj("Y");
		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: pUrl,
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: $("#"+pForm+"").serialize(),
 		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
 		      success:function( response ) {  	
 		    	 loader_obj("N");
 		    	 if(typeof response.Message != 'undefined'){
 		    		 kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
 		    		 return;
 		    	} 
 		    	 kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   },
 			   error:function( response, textStatus) {
 				   	loader_obj("N");
 				   	if(textStatus == 'timeout'){
 				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
 				   	} 				   	
 				 	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
					if(response.status == '403'){
						alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
						location.href = "/login/sub_login.do";
						return;
					} 				  
					kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   }
 		});  
	}
	/**
	 * 협력사 left메뉴에서 ajax 호출 
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccess ,kepAjaxError 구현한다.
	 */	
	function kepAjaxFormCallLeft(pUrl,pForm,pMethod) {    
		loader_obj("Y");
		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: pUrl,
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: $("#"+pForm+"").serialize(),
 		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
 		      success:function( response ) {  	
 		    	 loader_obj("N");
 		    	 if(typeof response.Message != 'undefined'){
 		    		 kepAjaxErrorLeft(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
 		    		 return;
 		    	}
 		    	 kepAjaxSuccessLeft(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   },
 			   error:function( response, textStatus ) {
 				   	loader_obj("N");
 				   	if(textStatus == 'timeout'){
 				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
 				   	} 				   	
 				 	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
					if(response.status == '403'){
						alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
						location.href = "/login/sub_login.do";
						return;
					} 				  
					kepAjaxErrorLeft(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   }
 		});  
	}
	/**
	 * 리뉴얼 > 고객사 탭 화면에서 ajax 호출 
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 * pTabId : tab아이디
	 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccess ,kepAjaxError 구현한다.
	 */	
	function kepAjaxFormCallTab(pUrl,pForm,pMethod,pTabId) {    
		loader_obj("Y");
		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: pUrl,
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: $("#"+pForm+"").serialize(),
 		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
 		      success:function( response ) {  	
 		    	 loader_obj("N");
 		    	 if(typeof response.Message != 'undefined'){
 		    		 tabs[pTabId].kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
 		    		 return;
 		    	}
 		    	tabs[pTabId].kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   },
 			   error:function( response, textStatus ) {
 				   	loader_obj("N");
 				   	if(textStatus == 'timeout'){
 				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
 				   	} 				   	
 				 	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
					if(response.status == '403'){
						alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
						location.href = "/login/sub_login.do";
						return;
					} 				  
					tabs[pTabId].kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   }
 		});  
	}
	/**
	 * 공통 ajax 호출 
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccess ,kepAjaxError 구현한다.
	 */	
	function kepAjaxGetFormCall(pUrl,pForm,pMethod) {    
		$.ajax({
			dataType:"jsonp",
			url: pUrl,
			headers: { 'X-Requested-With': 'XMLHttpRequest' },
			data: $("#"+pForm+"").serialize(),
			timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
			success:function( response ) {  	
				if(typeof response.Message != 'undefined'){
					kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
					return;
				} 
				kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
			},
			error:function( response, textStatus) {
				if(textStatus == 'timeout'){
					response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
				} 				   	
				//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
				if(response.status == '403'){
					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
					location.href = "/login/sub_login.do";
					return;
				} 				  
				kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
			}
		});  
	}


	function kepAjaxFormCallNoBar(pUrl,pForm,pMethod) {    
		$.ajax({
			type: "POST",
			dataType:"json",
			url: pUrl,
			headers: { 'X-Requested-With': 'XMLHttpRequest' },
			data: $("#"+pForm+"").serialize(),
			timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
			success:function( response ) {  	
				if(typeof response.Message != 'undefined'){
					kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
					return;
				} 
				kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
			},
			error:function( response, textStatus) {
				if(textStatus == 'timeout'){
					response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
				} 				   	
				//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
				if(response.status == '403'){
					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
					location.href = "/login/sub_login.do";
					return;
				} 				  
				kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
			}
		});  
	}
	
	/**
	 * 공통 ajax 호출  (pop업용)
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccess ,kepAjaxError 구현한다.
	 */	
	function kepAjaxPopFormCall(pUrl,pForm,pMethod) {    
		loader_obj("Y");
		$.ajax({
 		      type: "POST",
 		      dataType:"json",
 		      url: pUrl,
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: $("#"+pForm+"").serialize(),
 		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
 		      success:function( response ) {  		    	
 		    	 loader_obj("N");
 		    	  if(typeof response.Message != 'undefined'){
 		    		 kepAjaxPopError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
 		    		 return;
 		    	} 
 		    	 kepAjaxPopSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   },
 			   error:function( response, textStatus ) {  
 				   	loader_obj("N");
 				   	if(textStatus == 'timeout'){
 				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
				   	}
 				   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
					if(response.status == '403'){
						alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
						location.href = "/login/sub_login.do";
						return;
					} 				  
 				   kepAjaxPopError(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   }
 		});  
	}

	/**
	 * 팝업 호출  (post 방식)
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 */	
	function openSearchPopupPost(url, formName, title, option){
	      window.open('',title,option);
	      eval("document."+formName).method = "post";
	      eval("document."+formName).target = title;
	      eval("document."+formName).action = url;
	      eval("document."+formName).submit();
	}

	
	/**
	 * 공통 ajax 호출 
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxHtmlSuccess ,kepAjaxHtmlError 구현한다.
	 */	
	function kepAjaxHtmlCall(pUrl,pData,pMethod) {   
		loader_obj("Y");
		$.ajax({
 		      type: "POST",
 		      dataType:"html",
 		      url: pUrl,
 		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
 		      data: pData,
 		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
 		      success:function( data ) {  		    
 		    	 loader_obj("N");
 		    	kepAjaxHtmlSuccess(pMethod , data); // 화면에 필수적으로 있어여한다.
 			   },
 			   error:function( response, textStatus ) {
 				   	loader_obj("N");
 				   	if(textStatus == 'timeout'){
 				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
			   		} 				   
 				   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
					if(response.status == '403'){
						alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
						location.href = "/login/sub_login.do";
						return;
					} 				  
					kepAjaxHtmlError(pMethod , response); // 화면에 필수적으로 있어여한다.
 			   }
 		});  
	}
	
	
	/**
	 * 현재 시간정보를 출력한다.
	 */
	function kepGetNowTimeStr(type,flag){
		
			var date = new Date();
			var year = date.getYear(); //현재 년도 : 현재년도 - 1900 한 결과 출력, Ex) 1991 = 91, 2013 = 113
			var fullYear = date.getFullYear(); //현재 년도 Full : 4자리 형태로 출력, Ex) 1991 = 1991, 2013 = 2013
			var month = date.getMonth()+1; //현재 월 : -1 된 월값 출력 되므로 +1 처리, Ex) 1월 = 1, 12월 = 12
			var day = date.getDate(); //현재 일
			var hour  = date.getHours(); //현재 시간
			var min   = date.getMinutes(); //현재 분		 
			//alert("["+year+":"+fullYear+":"+month+":"+day+":"+hour+":"+min+"]"); // 자리수 맞춤 세팅 전
			//자리수가 1자리인 값들은 0을 앞에 붙인다.
			if(("" + month).length == 1) { month = "0" + month; }
			if(("" + day).length   == 1) { day   = "0" + day;   }
			if(("" + hour).length  == 1) { hour  = "0" + hour;  }
			if(("" + min).length   == 1) { min   = "0" + min;   } 
			//alert("["+year+":"+fullYear+":"+month+":"+day+":"+hour+":"+min+"]"); // 자리수 맞춤 세팅 후 
			if (type == "YYYY"){
				return fullYear;
			}else if (type == "MM"){
				return month-1;
			}else if (type == "YYYYMMDD"){
				return fullYear + flag + month + flag + day ; 
			} else if (type == "YYYYMM"){
				return fullYear + flag + month; 
			} else if (type == "YYYYMMDDHHMI"){
				return fullYear + flag + month + flag + day + hour + min;
			}
	}  
	/**
	 * 전월 시간정보를 출력한다.
	 */
	function kepGetReTimeStr(type,flag){
		
			var date = new Date();
			var year = date.getYear(); //현재 년도 : 현재년도 - 1900 한 결과 출력, Ex) 1991 = 91, 2013 = 113
			var fullYear = date.getFullYear(); //현재 년도 Full : 4자리 형태로 출력, Ex) 1991 = 1991, 2013 = 2013
			var month = date.getMonth(); //현재 월 : -1 된 월값 출력 되므로 +1 처리, Ex) 1월 = 1, 12월 = 12
			var day = date.getDate(); //현재 일
			var hour  = date.getHours(); //현재 시간
			var min   = date.getMinutes(); //현재 분		 
			//alert("["+year+":"+fullYear+":"+month+":"+day+":"+hour+":"+min+"]"); // 자리수 맞춤 세팅 전
			//자리수가 1자리인 값들은 0을 앞에 붙인다.
			if(("" + month).length == 1) { month = "0" + month; }
			if(("" + day).length   == 1) { day   = "0" + day;   }
			if(("" + hour).length  == 1) { hour  = "0" + hour;  }
			if(("" + min).length   == 1) { min   = "0" + min;   } 
			//alert("["+year+":"+fullYear+":"+month+":"+day+":"+hour+":"+min+"]"); // 자리수 맞춤 세팅 후 
			if (type == "YYYY"){
				return fullYear;
			}else if (type == "MM"){
				return month-1;
			}else if (type == "YYYYMMDD"){
				return fullYear + flag + month + flag + day ; 
			} else if (type == "YYYYMM"){
				return fullYear + flag + month; 
			} else if (type == "YYYYMMDDHHMI"){
				return fullYear + flag + month + flag + day + hour + min;
			}
	}  
	/**
	 * 날짜를 리턴한다.
	 * date 20150505
	 * flag / or -
	 * 
	 */
	function kepGetDateStr(date,flag){
		 
		var fullYear = date.substring(0,4);
		var month = date.substring(4,6);
		var day = date.substring(6,8);
		
		return fullYear + flag + month + flag + day ; 
 
	}  
	
	
		
	/**
	 * 달력 환경
	 * id 로 지정된 부분에 달력을 생성한다.
	 */
	function kepSetCalender(id) {    
		kepNoSetCalender(id,"","","","", "");
	}
	
	/**
	 * 달력 환경
	 * id 로 지정된 부분에 달력을 생성한다.
	 * 
	 * callback event가 필요한 경우 사용.
	 * id 			: input id
	 * gubun 		: 기본적인 date 체크 
	 * callbackChk 	: Y 인 경우 calenderChange 명으로 function 만들어야 함.
	 * op 			: callback function 에서 사용할 parameter 
	 */
	function kepSetCalender(id, gubun, callbackChk, op) {    
		kepNoSetCalender(id, "", gubun, callbackChk, op, "");
	}
	
	function kepSetCalenderTime(id, timeId) {    
		kepNoSetCalender(id, "", "2", "", "", timeId);
	}
	
	/**
	 * 달력 환경
	 * id 로 지정된 부분에 달력을 생성한다.
	 */
	function kepNoSetCalender(id, flag, gubun, callbackChk, op, timeId) {   
		
		if (flag==""){ 
			//$("#"+id).val("");
		}else{
			$("#"+id).val(kepGetNowTimeStr("YYYYMMDD","/"));
		}
		$("#"+id).datepicker({ 
		     showOn: "button"   // 버튼 이미지 삽입 가능
		    	   , buttonImage: "/resources/images/btn_calendar.gif"  // 버튼 이미지 경로
		    	   , buttonImageOnly: true  // true:버튼 이미지만 표시  false:버튼 안에 이미지 표시(default)
		    	   , changeMonth: true   // 월 선택을 combobox로 표현
		    	   , changeYear: true   // 년 선택을 combobox로 표현
		    	   , showMonthAfterYear:true  // 연도를 월보다 앞에 표시
		    	   , showOtherMonths: true  // 다른 월도 보여지도록
		    	   , selectOtherMonths: true // 다른 월의 셀도 선택가능하도록
		    	   , dateFormat: "yy/mm/dd" // 날짜 포맷 설정
		    	   , prevText: '이전달'
		    	   , nextText: '다음달'
		    	   , dayNamesMin: ["일","월","화","수","목","금","토"]      //요일 해더 표시 설정
		    	   , monthNamesShort: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"] //월 combobox 표시 설정
				   , yearRange:'c-30:c+10'
				   , onSelect:function (dateText,inst){
						
					   // 1 : 오늘 이전날짜 입력안되게..
						if(gubun == "1"){
							
							var cur_date = kepGetNowTimeStr("YYYYMMDD","");
							var input_date = dateText.replace(/[/]/gi,"");
							var cur_date2 = kepGetNowTimeStr("YYYYMMDD","/");
							
							if(cur_date > input_date){
								alert("금일 이후날짜로 입력가능합니다.");
								$(this).val(cur_date2);
						
								if(callbackChk == "Y"){
									calenderChange("", op);
									return;
								}						
							}
						} else if(gubun == "2"){		// 2 : 오늘 날짜와 현재 시간 이전 입력 안되도록
							var cur_date = kepGetNowTimeStr("YYYYMMDDHHMI","") + "00";
							var input_date = dateText.replace(/[/]/gi,"");
							var input_time = $("#"+timeId).val();
							
							if(cur_date > (input_date + input_time)){
								alert("금일 이후날짜로 입력가능합니다.");
								$(this).val("");
							}
						}
						
						if(callbackChk == "Y"){
							calenderChange(dateText, op);	
						}
					}
		}).val();
		
		if (timeId != ""){ 
			$("#"+timeId).change(function() {
				var cur_date = kepGetNowTimeStr("YYYYMMDDHHMI","") + "00";
				var input_date = $("#"+id).val().replace(/[/]/gi,"");
				var input_time = $("#"+timeId).val();
				
				if(cur_date > (input_date + input_time) && input_date != ""){
					alert("금일 이후날짜로 입력가능합니다.");
					$("#"+id).val("");
				}
			});
		}
	}
	
	/**
	 * 년월 달력 환경
	 * id 로 지정된 부분에 년월 달력을 생성한다.
	 */
	function kepSetCalenderYearMonth(id) {   
/* 일자 부분을 없애기 위해 아래 스타일을 본문 헤더안에 넣어줘야함 
		<style type="text/css">
		<!--
			table.ui-datepicker-calendar { display:none; }
		-->
		</style>
*/
		$("#"+id).val(kepGetNowTimeStr("YYYYMM","/"));
		$("#"+id).datepicker({
		     showOn: "button"   // 버튼 이미지 삽입 가능
		    	   , buttonImage: "/resources/images/btn_calendar.gif"  // 버튼 이미지 경로
		    	   , buttonImageOnly: true  // true:버튼 이미지만 표시  false:버튼 안에 이미지 표시(default)
		    	   , changeYear: true   // 년 선택을 combobox로 표현
		    	   , changeMonth: true   // 월 선택을 combobox로 표현
		    	   , showMonthAfterYear:true  // 연도를 월보다 앞에 표시
		    	   , showOtherMonths: true  // 다른 월도 보여지도록
		    	   , selectOtherMonths: true // 다른 월의 셀도 선택가능하도록
		    	   , prevText: '이전달'
		    	   , nextText: '다음달'
		    	   , dateFormat: "yy/mm" // 날짜 포맷 설정 
	    		   , dayNamesMin: ["일","월","화","수","목","금","토"]      //요일 해더 표시 설정
		    	   , monthNamesShort: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"] //월 combobox 표시 설정
				   , onClose:function (dateText, inst){
				        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
				        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
				        $(this).datepicker("option", "defaultDate", new Date(year, month, 1) );
				        $(this).datepicker('setDate', new Date(year, month, 1));
					}
		}).val();
	}

	function kep_listkepSetCalender(id , count){
		
		for (var i=0; i<count; i++){
			kepSetCalender(id + "" +i); 
		}
	}
	
	function kep_listkepSetCalender2(id , count){
		
		for (var i=0; i<count; i++){
			kepNoSetCalender(id + "" +i , "", 1, "Y", "", "");
		}
	}
	
	
	/**
	 * 전체선택 해제
	 * tot_cnt : 목록수
	 * check_status : 체크상태
	 * checkbox : 체크 대상 배열
	 */
	function kepCheckAll(tot_cnt,check_status,checkbox){
		if (tot_cnt==0) return;
		 
		if(tot_cnt <= 1) {     
			for(var i = 0; i < tot_cnt; i++){   
				var box = eval(checkbox+"0");
				box.checked = false;
			}
			for(var i = 0; i < tot_cnt; i++){   
				var box = eval(checkbox+"0");
				box.checked = check_status.checked;
			}	
		}else{
			for(var i = 0; i < tot_cnt; i++){   
				var box = eval(checkbox + (i));
				box.checked = false;
			}
			for(var i = 0; i < tot_cnt; i++){   
				var box = eval(checkbox + (i));
				box.checked = check_status.checked;
			}	
		}
	}
	
	/**
	 * FORM 을 초기화
	 */
	function kepReload(frm){
		var form = eval('document.forms.'+frm);
		//if(form != 'undefined' && form != null) form.reset();
		var radioIdx=0;
		  var len = form.elements.length;
		  for (var i = 0; i < len; i++) { 
			  switch (form.elements[i].type) {
		      case "button":
		      case "reset":
		      case "submit":
		        break;
		      case "radio":
			       	 if(radioIdx == 0){
			       		form.elements[i].checked = true;
				       	radioIdx = i;   	
			       	 }
		    	  break;
		      case "checkbox": 
//		    	  if (form.elements[i].checked){
		    		  form.elements[i].checked = true;
//		    	  }else{
//		    		  form.elements[i].checked = false;
//		    	  }
		          break;
		      case "select-one": 
		    	  form.elements[i].selectedIndex  = 0;
		          break;
		      case "select-multiple": 
		    	  form.elements[i].selectedIndex  = 0;
		          break;
		      case "hidden":
		    	  var nm = form.elements[i].name;
//		    	  if(nm == "upperId" || nm == "curPage" || nm == "st_user_id" || nm == "st_user_name" || nm == "st_com_code" ||  nm == "st_user_name_loc"   
//		    			  ||  nm == "st_email"            ||  nm == "st_com_type"         ||  nm == "st_user_type"        ||  nm == "st_business_cond"    ||  nm == "st_mphone"           
//		    			  ||  nm == "st_tel"              ||  nm == "st_fax"              ||  nm == "st_using_catal_type" ||  nm == "st_byca_comorg_code" ||  nm == "st_department"       ||  nm == "st_position"         
//		    			  ||  nm == "st_imgview_flag"     ||  nm == "st_budget_flag"      ||  nm == "st_role"             ||  nm == "st_user_name_eng"    ||  nm == "st_country"          ||  nm == "st_department_name" 
//		    			  ||  nm == "st_status"           ||  nm == "st_dely_to_location" ||  nm == "st_dely_to_location_name" ||  nm == "st_purchase_dept"    ||  nm == "st_purchase_dept_name" 
//		    			  ||  nm == "st_zip_code"         ||  nm == "st_person_author"    ||  nm == "st_row_cnt"          ||  nm == "st_com_name_eng"     ||  nm == "st_com_name_loc"    
//		    			  ||  nm == "st_address_loc"      ||  nm == "st_hp_address"       ||  nm == "st_agent_open_flag"  ||  nm == "st_byca_comorg_level"
//		    	  ){
//		    		  continue;
//		    	  }else if(nm == "pageflag"){
//		    		  form.elements[i].value = "1";
//		    	  }else{
//			    	  form.elements[i].value = "";
//		    	  }
		    	  if(nm == "pageflag" || nm == "curPage"){
		    		  form.elements[i].value = "1";
		    	  }
		    	  break;
		      case "text":
		    	  var nm = form.elements[i].name;
		    	  var elevalue = form.elements[i].value;
		    	  
		    	  if(nm.indexOf("_date")>-1){
	        		kepSetCalender(nm);
					if(nm.indexOf("_from")>-1){
						if(nm.indexOf("_m3")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("3","M"): elevalue;
						}else if(nm.indexOf("_m2")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("2","M"): elevalue;
						}else{
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("1","M"): elevalue;	
						}
					}else if(nm.indexOf("_to")>-1){
						if(nm.indexOf("_p3")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("3","P"): elevalue;
						}else if(nm.indexOf("_p2")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("2","P"): elevalue;
						}else if(nm.indexOf("_p1")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("1","P"): elevalue;
						}else{
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepGetNowTimeStr('YYYYMMDD','/'): elevalue;
						}						
					}else{
						form.elements[i].value = (elevalue =="" || elevalue == null)?kepGetNowTimeStr('YYYYMMDD','/'): elevalue;
					}
		    	  }else{
		    		  form.elements[i].value = "";
		    	  }
			      break;
		        default : 
		        	break;
		   		}
		  }
		  $("#pageindex").html("");
	}
	//리뉴얼용 초기화(달력 생성x)
	function kepReload_v2(frm){
		var form = eval('document.forms.'+frm);
		//if(form != 'undefined' && form != null) form.reset();
		var radioIdx=0;
		  var len = form.elements.length;
		  for (var i = 0; i < len; i++) { 
			  switch (form.elements[i].type) {
		      case "button":
		      case "reset":
		      case "submit":
		        break;
		      case "radio":
			       	 if(radioIdx == 0){
			       		form.elements[i].checked = true;
				       	radioIdx = i;   	
			       	 }
		    	  break;
		      case "checkbox": 
//		    	  if (form.elements[i].checked){
		    		  form.elements[i].checked = true;
//		    	  }else{
//		    		  form.elements[i].checked = false;
//		    	  }
		          break;
		      case "select-one": 
		    	  form.elements[i].selectedIndex  = 0;
		          break;
		      case "select-multiple": 
		    	  form.elements[i].selectedIndex  = 0;
		          break;
		      case "hidden":
		    	  var nm = form.elements[i].name;
//		    	  if(nm == "upperId" || nm == "curPage" || nm == "st_user_id" || nm == "st_user_name" || nm == "st_com_code" ||  nm == "st_user_name_loc"   
//		    			  ||  nm == "st_email"            ||  nm == "st_com_type"         ||  nm == "st_user_type"        ||  nm == "st_business_cond"    ||  nm == "st_mphone"           
//		    			  ||  nm == "st_tel"              ||  nm == "st_fax"              ||  nm == "st_using_catal_type" ||  nm == "st_byca_comorg_code" ||  nm == "st_department"       ||  nm == "st_position"         
//		    			  ||  nm == "st_imgview_flag"     ||  nm == "st_budget_flag"      ||  nm == "st_role"             ||  nm == "st_user_name_eng"    ||  nm == "st_country"          ||  nm == "st_department_name" 
//		    			  ||  nm == "st_status"           ||  nm == "st_dely_to_location" ||  nm == "st_dely_to_location_name" ||  nm == "st_purchase_dept"    ||  nm == "st_purchase_dept_name" 
//		    			  ||  nm == "st_zip_code"         ||  nm == "st_person_author"    ||  nm == "st_row_cnt"          ||  nm == "st_com_name_eng"     ||  nm == "st_com_name_loc"    
//		    			  ||  nm == "st_address_loc"      ||  nm == "st_hp_address"       ||  nm == "st_agent_open_flag"  ||  nm == "st_byca_comorg_level"
//		    	  ){
//		    		  continue;
//		    	  }else if(nm == "pageflag"){
//		    		  form.elements[i].value = "1";
//		    	  }else{
//			    	  form.elements[i].value = "";
//		    	  }
		    	  if(nm == "pageflag" || nm == "curPage"){
		    		  form.elements[i].value = "1";
		    	  }
		    	  break;
		      case "text":
		    	  var nm = form.elements[i].name;
		    	  var elevalue = form.elements[i].value;
		    	  
		    	  if(nm.indexOf("_date")>-1){
//	        		kepSetCalender(nm);
					if(nm.indexOf("_from")>-1){
						if(nm.indexOf("_m3")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("3","M"): elevalue;
						}else if(nm.indexOf("_m2")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("2","M"): elevalue;
						}else{
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("1","M"): elevalue;	
						}
					}else if(nm.indexOf("_to")>-1){
						if(nm.indexOf("_p3")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("3","P"): elevalue;
						}else if(nm.indexOf("_p2")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("2","P"): elevalue;
						}else if(nm.indexOf("_p1")>-1){
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepToMonthAdd("1","P"): elevalue;
						}else{
							form.elements[i].value = (elevalue =="" || elevalue == null)?kepGetNowTimeStr('YYYYMMDD','/'): elevalue;
						}						
					}else{
						form.elements[i].value = (elevalue =="" || elevalue == null)?kepGetNowTimeStr('YYYYMMDD','/'): elevalue;
					}
		    	  }else{
		    		  form.elements[i].value = "";
		    	  }
			      break;
		        default : 
		        	break;
		   		}
		  }
		  $("#pageindex").html("");
	}
	/**
	 * FORM 을 초기화
	 */
	function kepClear(id){
		$("#"+id).val("");
	}
	
	function kepClearField(id1,id2){
		$("#"+id1).val("");
		$("#"+id2).val("");
	}

	
	/**
	 * 조회후 포커싱 처리
	 */
	function kepOnFocus(obj){
		if(obj !='undefined' && obj != null) obj.focus();
	}
	
	/**
	* 입력값이 NULL인지 체크
	* return
	* true : null 
	* false : not null
	*/
	function kepIsNull(id) { 
		
		var input = $("#"+id).val(); 
	    if (input == null || input == "") {
	        return true;
	    }
	    return false;
	}
	
	/**
	* 입력값이 Value를이용 NULL인지 체크
	* return
	* true : null 
	* false : not null
	*/
	function kepIsValueNull(value) { 
	    if (value == null || value == "" || value == 'undefined') {
	        return true;
	    }
	    return false;
	}	
	
	function isEmpty(value) {  
	    return kepIsValueNull(value);
	}	
	

	/**
	* 입력값에 스페이스 이외의 의미있는 값이 있는지 체크
	* return
	* true : null 
	* false : not null
	*/
	function kepIsEmpty(id) {
		
		var input = $("#"+id).val(); 		
	    if (input == null || input.replace(/ /gi,"") == "") {
	        return true;
	    }
	    return false;
	}

	/**
	* 입력값에 특정 문자(chars)가 있는지 체크
	* 특정 문자를 허용하지 않으려 할 때 사용
	* ex) if (containsChars(form.name,"!,*&^%$#@~;")) {
	*         alert("이름 필드에는 특수 문자를 사용할 수 없습니다.");
	*     }
	*/
	function containsChars(input,chars) {
	    for (var inx = 0; inx < input.length; inx++) {
	       if (chars.indexOf(input.charAt(inx)) != -1)
	           return true;
	    }
	    return false;
	}

	/**
	* 입력값이 특정 문자(chars)만으로 되어있는지 체크
	* 특정 문자만 허용하려 할 때 사용
	* ex) if (!containsCharsOnly(form.blood,"ABO")) {
	*         alert("혈액형 필드에는 A,B,O 문자만 사용할 수 있습니다.");
	*     }
	*/
	function containsCharsOnly(input,chars) {
		
	    for (var inx = 0; inx < input.length; inx++) {
	       if (chars.indexOf(input.charAt(inx)) == -1){
	           return false;
	       }
	    }
	    return true;
	}

	/**
	* 입력값이 알파벳인지 체크
	* return
	* true : 전부알파벳 
	* false :  
	*/
	function kepIsAlphabet(id) {
		
		var input = $("#"+id).val(); 	
	    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	    return containsCharsOnly(input,chars);
	}

	/**
	* 입력값이 알파벳 대문자인지 체크
	* return
	* true : 전부대문자
	* false :  
	*/
	function kepIsUpperCase(id) {
		
		var input = $("#"+id).val(); 	
	    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	    return containsCharsOnly(input,chars);
	}

	/**
	* 입력값이 알파벳 소문자인지 체크
	* return
	* true : 전부소문자
	* false :  
	*/
	function kepIsLowerCase(id) {
		
		var input = $("#"+id).val(); 	
	    var chars = "abcdefghijklmnopqrstuvwxyz";
	    return containsCharsOnly(input,chars);
	}

	/**
	* 입력값에 숫자만 있는지 체크
	* return
	* true : 전부 숫자
	* false :  
	*/
	function kepIsNumber(id) {
		
		var input = $("#"+id).val(); 	
	    var chars = "0123456789";
	    return containsCharsOnly(input,chars);
	}

	function kepIsNumberStr(str) {
	    var chars = "0123456789";
	    return containsCharsOnly(str,chars);
	}

	
	/**
	* 입력값에 숫자만 있는지 체크
	* return
	* true : 전부 숫자
	* false :  
	*/
	function kepIsNumberString(input) { 
	    var chars = "0123456789";
	    return containsCharsOnly(input,chars);
	}
	function kepIsNumberDashString(input) { 
	    var chars = "0123456789-";
	    return containsCharsOnly(input,chars);
	}
	
	function kepNumcheck(args){	
		if (kepIsNumberString(args.value)  == false){
			alert("숫자만 가능합니다.");
			args.value = "";
			args.focus();
		}	
	}

	function kepNumcheck2(frm, name, idx){
		var obj = $("form[name="+frm+"]").find("input[name="+name+"]").eq(idx);
		if(kepIsNumberString(obj.val()) == false){
			alert("숫자만 입력 가능합니다.");
			obj.val('');
			obj.focus();
		}
	}
	function kepNumcheck3(args){	
		if (kepIsNumberDashString(args.value)  == false){
			alert("-와 숫자만 가능합니다.");
			args.value = "";
			args.focus();
		}	
	}

	/**
	 * Input 박스에 숫자만 입력하도록 하는 함수
	 */
	function onlyNumber(){
		if((event.keyCode<48)||(event.keyCode>57))
			event.returnValue=false;
	}
	
	/**
	* 입력값이 알파벳,숫자로 되어있는지 체크
	* return
	* true : 전부 알파벳,숫자
	* false :  
	*/
	function kepIsAlphaNum(id) {
		
		var input = $("#"+id).val(); 	
	    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	    return containsCharsOnly(input,chars);
	}

	/**
	* 입력값이 숫자,대시(-)로 되어있는지 체크
	* return
	* true : 전부 숫자,대시(-)
	* false :  
	*/
	function kepIsNumDash(id) {
		
		var input = $("#"+id).val(); 	
	    var chars = "-0123456789";
	    return containsCharsOnly(input,chars);
	}

	/**
	* 입력값이 숫자,콤마(,)로 되어있는지 체크
	* return
	* true : 전부 숫자,콤마(,)
	* false :  
	*/
	function kepIsNumChk(id,flag) {
		var input = $("#"+id).val(); 	
		var chars = "";
		
		if (flag == 1){
			chars = ",0123456789";
		}else if (flag == 2){
			chars = ".0123456789";
		}else if (flag == 3){
			chars = ",.0123456789";
		} 
	    return containsCharsOnly(input,chars);
	}
	
	/**
	 * 입력값이 숫자,콤마(,)로 되어있는지 체크
	 * return
	 * true : 전부 숫자,콤마(,)
	 * false :  
	 */
	function kepIsNumChkStr(str,flag) {
		var input = str; 	
		var chars = "";
		
		if (flag == 1){
			chars = ",0123456789";
		}else if (flag == 2){
			chars = ".0123456789";
		}else if (flag == 3){
			chars = ",.0123456789";
		}else if(flag == 4){
			chars = "-0123456789";
		}
		return containsCharsOnly(input,chars);
	}
	
	/**
	* 입력값이 숫자,콤마(,)로 되어있는지 체크
	* return
	* true : 전부 숫자,콤마(,)
	* false :  
	*/
	function kepIsNumComma(id) {
		
		var input = $("#"+id).val(); 	
	    var chars = ",0123456789";
	    return containsCharsOnly(input,chars);
	}	

	/**
	* 입력값이 사용자가 정의한 포맷 형식인지 체크
	* 자세한 format 형식은 자바스크립트의 `regular expression`을 참조
	*/
	function isValidFormat(input,format) {
	    if (input.search(format) != -1) {
	        return true; //올바른 포맷 형식
	    }
	    return false;
	}

	

	/**
	* 입력값이 이메일 형식인지 체크
	* return
	* true : 이메일 형식
	* false :  
	*/
	function kepIsValidEmail(id) {
		
		var input = $("#"+id).val(); 	
//	    var format = /^(\S+)@(\S+)\.([A-Za-z]+)$/;
	    var format = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;
	    return isValidFormat(input,format);
	}
	
	/**
	 * 입력값이 이메일 형식인지 체크
	 * return
	 * true : 이메일 형식
	 * false :  
	 */
	function kepIsValidEmailValue(value) {
		
		var input = value; 	
//	    var format = /^(\S+)@(\S+)\.([A-Za-z]+)$/;
		var format = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;
		return isValidFormat(input,format);
	}
	
	/**
	* 입력값이 URL 형식 체크
	* ex) http:
	* return
	* true : URL 형식
	* false :  
	*/
	function kepIsValidUrl(id) {
		
		var input = $("#"+id).val(); 	
	    var format = /(?:^|")(http|ftp|mailto):/;
	    return isValidFormat(input,format);
	}	

	/**
	* 입력값이 전화번호 형식(숫자-숫자-숫자)인지 체크
	* return
	* true : 전화번호
	* false :  
	*/
	function kepIisValidPhone(id) {
		
		var input = $("#"+id).val(); 	
	    var format = /^(\d+)-(\d+)-(\d+)$/;
	    return isValidFormat(input,format);
	}

	/**
	* 입력값의 바이트 길이를 리턴
	* ex) if (getByteLength(form.title) > 100) {
	*         alert("제목은 한글 50자(영문 100자) 이상 입력할 수 없습니다.");
	*     }
	* Author : Wonyoung Lee
	*/
	function kepGetByteLength(id) {
		
		var input = $("#"+id).val(); 	
	    var byteLength = 0;
	    for (var inx = 0; inx < input.length; inx++) {
	        var oneChar = escape(input.charAt(inx));
	        if ( oneChar.length == 1 ) {
	            byteLength ++;
	        } else if (oneChar.indexOf("%u") != -1) {
	            byteLength += 2;
	        } else if (oneChar.indexOf("%") != -1) {
	            byteLength += oneChar.length/3;
	        }
	    }
	    return byteLength;
	}

	/**
	* 입력값에서 콤마,점등을 없앤다.
	*/
	function kepRemoveUnNum(id,flag) {
		
		var tmp = "";
		var input = $("#"+id).val(); 	
		
		if (flag == 1){
			$("#"+id).val(input.replace(/,/gi,""));
		} else if (flag == 2){
			$("#"+id).val(input.replace(/[.]/gi,""));
		} else if (flag == 3){
			$("#"+id).val(input.replace(/[.,]/gi,""));
		} 
	}

	function kepRemoveComma(num) {
			return num.replace(/,/gi,"");
	}

	
	/**
	* 입력값에서 <script 없앤다.
	*/
	function kepRemoveTag(id) {
		 
		var input = $("#"+id).val(); 	 
		$("#"+id).val($.trim(input.replace(/<script/gi,""))); 
	}
	
	/**
	 * 부동소수점 숫자인지 음수부호도 포함하여 검사
	* return
	* true : 숫자
	* false :  
	 */
	function kepIsDouble(id) {
		
		var input = $("#"+id).val(); 	
		var format = /^[-|+]?\d+\.?\d*$/;
		return isValidFormat(input,format);
	} 
	
	/**
	 * 부동소수점 숫자인지 검사
	 * cf) 음수부호는 포함하지 않음
	* return
	* true : 숫자
	* false :  
	 */
	function kepIsDoublePlus(id) {
		
		var input = $("#"+id).val(); 
	    var format = /^\d+\.?\d*$/;
	    return isValidFormat(input,format);
	}
	

	/**
	 * 한글 공백만 가능
	* return
	* true : 한글
	* false :  
	 */
	function kepIsHangu(id)  {
		
		var input = $("#"+id).val(); 
	    var format =  /[^ㄱ-ㅎ가-하]/g;
	 //   return isValidFormat(input,format);
	    if (format.test(input)) { return false; } else { return true;  };
	} 
	
	/**
	 * 날짜만가능
	* return
	* true : 날짜
	* false :  
	 */
	function KepIsDate(id)  {
		
		var input = $("#"+id).val(); 
	    var format = /^(19[7-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
	 //   return isValidFormat(input,format);
	    return format.test(input);
	} 	
	
	/**
	 * 특수문자여부
	* return
	* true : 특수문자 존재
	* false :  
	 */
	function kepIsSpecialChar(id)  {
		
		var input = $("#"+id).val(); 	
	    var chars = "~`!@#$%^&*()+={}[];':\",/<>?";
	    return containsChars(input,chars);
	} 

	function kepPasswdChkChar(val)  {
	    var chars = "~`!@%^&*()-+={}[];':\",./<>?";
	    for (var inx = 0; inx < val.length; inx++) {
		       if (chars.indexOf(val.charAt(inx)) != -1)
		           return true;
		    }
		    return false;
	}
	
	/**
	 * 숫자 세 자리마다 콤마 찍기  
	 */
	function kepNumComma(id)  {
		
		var input = $("#"+id).val(); 	
	    if (isNaN(input) || input == "") { 
               alert("숫자를 입력하세요");  
               return input;
       } else {
			var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
			input += '';                          // 숫자를 문자열로 변환
			while (reg.test(input))
				  input = input.replace(reg, '$1' + ',' + '$2');
			return input;
       }
	}

	/**
	 * 숫자 세 자리마다 콤마 찍기  
	 */
	function kepNumComma2(id)  {
		
		var input = id; 	
	    if (isNaN(input) || input == "") { 
               alert("숫자를 입력하세요");  
               return input;
       } else {
			var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
			input += '';                          // 숫자를 문자열로 변환
			while (reg.test(input))
				  input = input.replace(reg, '$1' + ',' + '$2');
			return input;
       }
	}
	
	/**
	 * 소수점 제한주기
	 */
	function kepCheckDecimals(id ,decallowed) {  
		
		var input = $("#"+id).val(); 			
       if (isNaN(input) || input == "") { 
              //alert("숫자를 입력하세요");  
    	   	  return "1";
       } 
       else { 
    	   		
    	   		//alert(kepNumComma(id));
    	   
               if (input.indexOf('.') == -1) input += "."; 
                dectext = input.substring(input.indexOf('.')+1, input.length); 
                if (dectext == 0){
                	kepRemoveUnNum(id,2);
                }

               if (dectext.length > decallowed) 
               { 
                    //alert ("소수점 " + decallowed + " 자리까지만 입력할 수 있습니다");  
            	  	return "2";
               } 
               else { 
                   //alert ("바르게 입력 하셨네요"); 
            	   return "3";
               } 
       } 
	} 
	
	/**
	 * 라디오버트 필수 체크여부
	* return
	* true : 체크 완료
	* false :  	 
	 */
	function kepRadioValid(id){ 
		
		var cnt = 0;
		$("input[name*='"+id+"']:radio").each(function(i, v){  
			if(v.checked==false){  
			} else{
				cnt ++;
			}
		}); 
		if(cnt > 0) 
		{ 
			//alert("체크 완료");
			return true; 
		}else 
		{ 
			//alert("값이 체크되지않은 항목이 있습니다.");  
			return false; 
		}  
	}
	

	/**
	 * 라디오 선택된 값을 리턴한다.
	 */
	function kepRadioSelectVal(id){  		
		
		if (kepRadioValid(id) == true){
			return  $(":radio[name='"+id+"']:checked").val();
		}else{
			return "";
		}		
	}
	
	/**
	 * 선택된 라디오 값을 해당 id에 셋팅한다.
	 */
	function kepRadioSet(id, obj){  		
		
		if (obj != null && obj != 'undefined'){
			var value = obj.value;
			$("#"+id).val(value);
		}		
	}


	/**
	 * 선택 필수 체크여부
	* return
	* true : 선택안함
	* false :  	 
	 */
	function kepSelectValid(id){  		
		
		var input = $("#"+id+" option:selected").val(); 
		return kepIsValueNull(input);
	}
	

	/**
	 * select box 선택된 값을 리턴한다.
	 */
	function kepSelectOptionVal(id){  		
		
		if (kepSelectValid(id) == false){
			return  $("#"+id+" option:selected").val() ;
		}else{
			return "";
		}		
	}
	
	/**
	 * select box 선택된 내용을 리턴한다.
	 */
	function kepSelectOptionText(id){  		
		
		if (kepSelectValid(id) == false){
			return  $("#"+id+" option:selected").text() ;
		}else{
			return "";
		}
	}
	
	/**
	 * 조회조건 항목을 엔터키를 누를때 조회 실행(IBSheet 용)
	 */
	function kepEnter() {
		if (event.keyCode == 13) { 
			doAction('search');
		}
	}
	
	function kepEnter_v2() {
		if (event.keyCode == 13) { 
			event.preventDefault();
			event.stopImmediatePropagation();
			doAction('search');
		}
	}
	//리뉴얼 탭에서 엔터용
	function kepEnter_v3(tabId) {
		if (event.keyCode == 13) { 
			event.preventDefault();
			event.stopImmediatePropagation();
			tabs[tabId].search();
		}
	}
	
	/**
	 * 그리드 테이블의 컬럼값들을 배열로 리턴
	 */
	function getFormToArr(form, checkRequired, chkGridValue) {
		form = eval(form);
/*		  if (typeof form != "object" || form.tagName != "FORM") {
		    IBS_ShowErrMsg("FormQueryStringEnc 함수의 form 인자는 FORM 태그가 아닙니다.");
		    return "";
		  }*/
		  if(checkRequired==null) checkRequired=false;

//		  var name = new Array(form.elements.length);
//		  var value = new Array(form.elements.length);
		  var name = new Array();
		  var value = new Array();
		  var j = 0;
		  var plain_text="";
		  var startGridIdx=0;
		  var MSG_REQUIRED      = "은(는) 필수입력 항목입니다.";		
		    var chkflg = false;
		  
		  //사용가능한 컨트롤을 배열로 생성한다.
		  len = form.elements.length;
		  for (i = 0; i < len; i++) {
		    var prev_j = j;

	    	if (form.elements[i].type == 'checkbox'){
	    		chkflg = (form.elements[i].checked == true)? true : false ;
	    	}
	    	if(chkflg){
			    switch (form.elements[i].type) {
			      case "button":
			      case "reset":
			      case "submit":
			        break;
			      case "radio":
			      case "checkbox":
			    	  startGridIdx = i;		// checkbox 의 인덱스를 그리드 시작점으로 셋팅한다
//			          if (form.elements[i].checked == true) {
						name[j] = getName(form.elements[i]);
						value[j] = form.elements[i].value;
						j++;
//			          }
			          break;
			      case "select-one":
			          name[j] = getName(form.elements[i]);
			          var ind = form.elements[i].selectedIndex;
			          if(ind >= 0) {
			              value[j] = form.elements[i].options[ind].value;
			          } else {
			            value[j] = "";
			          }
			          j++;
			          break;
			      case "select-multiple":
			          name[j] = getName(form.elements[i]);
			          var llen = form.elements[i].length;
			          var increased = 0;
			          for( k = 0; k < llen; k++) {
			            if (form.elements[i].options[k].selected) {
			              name[j] = getName(form.elements[i]);
			              value[j] = form.elements[i].options[k].value;
			              j++;
			              increased++;
			            }
			          }
			          if(increased > 0) {
			            j--;
			          } else {
			            value[j] = "";
			          }
			          j++;
			          break;
			        default :
			            name[j] = getName(form.elements[i]);
			            value[j] = form.elements[i].value;
			            j++;
			    }
	    	}// end flag if

		    
			  if (checkRequired) {
			      //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
			      //<input type="text" name="txtName" required="이름">
			      if (RequiredChk(form.elements[i])&&prev_j != j && value[prev_j] == "") {
			       	if (form.elements[i].getAttribute("required")=="") {
			          alert('"' + getName(form.elements[i]) + '"' + MSG_REQUIRED);
			        }else{
			          alert('"' + form.elements[i].getAttribute("required")  + '"' + MSG_REQUIRED);
			        }
			        //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
			        try{
			          form.elements[i].focus();
			        } catch(ee) {;}
			        
			        return;
			      }
			    }
		  }

		  var chkidx = 0;
		  for (var i = 0; i < name.length; i++) {
//		    	if (name[i] == "checkbox"){
	    		if (name[i].indexOf('checkbox') > -1){		    		
		    		chkidx = i; 
		    		break;
		    	} 
		  }

		  if(chkGridValue != null && chkGridValue.length > 0){
			  var chkflg = false;
			  
			  for (var k = chkidx; k < name.length; k++) {
			    if (name[k] != '') {
//			    	if (name[k] == 'checkbox'){
			    	if (name[k].indexOf('checkbox') > -1){
			    		chkflg = (value[k] == 'on')? true : false ;
			    	}
//			    	alert(name[k] +":::"+value[k]+":::"+chkflg);
			    	
			    	if(chkflg){
//			    	  if( chkGridValue.operation != null && chkGridValue.operation.length > 0){
//			    		  var key1 = chkGridValue.keys[0];
//			    		  var key2 = chkGridValue.keys[1];
//			    		  var value1 = "";
//			    		  var value2 = "";
//			    		  var oper = chkGridValue.operation[0];
//			    		  var compValue = chkGridValue.compValue[0];
//
//			    		  if(name[k] == key1){
//			    			  value1 = value[k];
//			    		  }
//			    		  if(name[k] == key2){
//			    			  value2 = value[k];
//			    		  }
//			    		  alert(value1+oper+value2);
//			    		  var targetValue = eval(value1+oper+value2);
//			    		  
//			    		  alert(targetValue);
//			    		  if(targetValue == compValue){
//			    			  alert(chkGridValue.msg0);
//			    			  return "" ;
//			    		  }
			    			  
//			    	  }else{
						  for(var i=0; i<chkGridValue.keys.length; i++){
							  var key = chkGridValue.keys[i];
							  if(name[k] == key){
//								  alert(key.toString()+"::\n"+value.toString());
								  //alert(name[k] +"::"+key+"::"+value[k]);
								  switch(i){
								  	case 0: 
								  		var result = paramChk(value[k], chkGridValue, 0);
								  		if(result == 1) return "" ;
								  		break;
								  	case 1 : 
								  		var result = paramChk(value[k], chkGridValue, 1);
								  		if(result == 1) return "" ;
								  		break;
								  	case 2 :
								  		var result = paramChk(value[k], chkGridValue, 2);
								  		if(result == 1) return "" ;
								  		break;
								  }
							  }
						  }						    		  
//			    	  }
			    	  

			    	}// chkflg end
			      } //end if
			  } // end for
		  }
		  
		  
		  //QueryString을 조합한다.
//		  var result="";
		  var resultArr = new Array(2);
		  resultArr = ['',''];
//		  for (i = 0; i < j; i++) {
		  var chkcnt = 0;
		  for (var k = chkidx; k < name.length; k++) {
		    if (name[k] != '') {
		    	if ((name[k].indexOf("checkbox") >-1 ) && chkcnt <= 1) {
			    	chkcnt++;
			    	if ( chkcnt ==2) break;
		    	}
			    resultArr[0] = resultArr[0]+ name[k]+ "|";
		    }
		  }

		  for (var k = chkidx; k < name.length; k++) {
			    resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
		  }
		  
		  
		  //마지막에 | 를 없애기 위함
		  if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
//		  return plain_text;
		  return resultArr;
	}
	
	function getFormToArr_v2(form, checkRequired, chkGridValue) {
		form = eval(form);
/*		  if (typeof form != "object" || form.tagName != "FORM") {
		    IBS_ShowErrMsg("FormQueryStringEnc 함수의 form 인자는 FORM 태그가 아닙니다.");
		    return "";
		  }*/
		  if(checkRequired==null) checkRequired=false;

//		  var name = new Array(form.elements.length);
//		  var value = new Array(form.elements.length);
		  var name = new Array();
		  var value = new Array();
		  var j = 0;
		  var plain_text="";
		  var startGridIdx=0;
		  var MSG_REQUIRED      = "은(는) 필수입력 항목입니다.";		
		    var chkflg = false;
		  
		  //사용가능한 컨트롤을 배열로 생성한다.
		  len = form.elements.length;
		  for (i = 0; i < len; i++) {
		    var prev_j = j;
		    chkflg = true;
	    	if(chkflg){
			    switch (form.elements[i].type) {
			      case "button":
			      case "reset":
			      case "submit":
			        break;
			      case "radio":
			      case "checkbox":
			    	  startGridIdx = i;		// checkbox 의 인덱스를 그리드 시작점으로 셋팅한다
//			          if (form.elements[i].checked == true) {
						name[j] = getName(form.elements[i]);
						value[j] = form.elements[i].value;
						j++;
//			          }
			          break;
			      case "select-one":
			          name[j] = getName(form.elements[i]);
			          var ind = form.elements[i].selectedIndex;
			          if(ind >= 0) {
			              value[j] = form.elements[i].options[ind].value;
			          } else {
			            value[j] = "";
			          }
			          j++;
			          break;
			      case "select-multiple":
			          name[j] = getName(form.elements[i]);
			          var llen = form.elements[i].length;
			          var increased = 0;
			          for( k = 0; k < llen; k++) {
			            if (form.elements[i].options[k].selected) {
			              name[j] = getName(form.elements[i]);
			              value[j] = form.elements[i].options[k].value;
			              j++;
			              increased++;
			            }
			          }
			          if(increased > 0) {
			            j--;
			          } else {
			            value[j] = "";
			          }
			          j++;
			          break;
			        default :
			            name[j] = getName(form.elements[i]);
			            value[j] = form.elements[i].value;
			            j++;
			    }
	    	}// end flag if

		    
			  if (checkRequired) {
			      //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
			      //<input type="text" name="txtName" required="이름">
			      if (RequiredChk(form.elements[i])&&prev_j != j && value[prev_j] == "") {
			       	if (form.elements[i].getAttribute("required")=="") {
			          alert('"' + getName(form.elements[i]) + '"' + MSG_REQUIRED);
			        }else{
			          alert('"' + form.elements[i].getAttribute("required")  + '"' + MSG_REQUIRED);
			        }
			        //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
			        try{
			          form.elements[i].focus();
			        } catch(ee) {;}
			        
			        return;
			      }
			    }
		  }

		  var chkidx = 0;
		  for (var i = 0; i < name.length; i++) {
//		    	if (name[i] == "checkbox"){
	    		if (name[i].indexOf('checkbox') > -1){		    		
		    		chkidx = i; 
		    		break;
		    	} 
		  }

		  if(chkGridValue != null && chkGridValue.length > 0){
			  var chkflg = false;
			  
			  for (var k = chkidx; k < name.length; k++) {
			    if (name[k] != '') {
			    	
			    	chkflg = true;
			    	
			    	if(chkflg){
//			    	  if( chkGridValue.operation != null && chkGridValue.operation.length > 0){
//			    		  var key1 = chkGridValue.keys[0];
//			    		  var key2 = chkGridValue.keys[1];
//			    		  var value1 = "";
//			    		  var value2 = "";
//			    		  var oper = chkGridValue.operation[0];
//			    		  var compValue = chkGridValue.compValue[0];
//
//			    		  if(name[k] == key1){
//			    			  value1 = value[k];
//			    		  }
//			    		  if(name[k] == key2){
//			    			  value2 = value[k];
//			    		  }
//			    		  alert(value1+oper+value2);
//			    		  var targetValue = eval(value1+oper+value2);
//			    		  
//			    		  alert(targetValue);
//			    		  if(targetValue == compValue){
//			    			  alert(chkGridValue.msg0);
//			    			  return "" ;
//			    		  }
			    			  
//			    	  }else{
						  for(var i=0; i<chkGridValue.keys.length; i++){
							  var key = chkGridValue.keys[i];
							  if(name[k] == key){
//								  alert(key.toString()+"::\n"+value.toString());
								  //alert(name[k] +"::"+key+"::"+value[k]);
								  switch(i){
								  	case 0: 
								  		var result = paramChk(value[k], chkGridValue, 0);
								  		if(result == 1) return "" ;
								  		break;
								  	case 1 : 
								  		var result = paramChk(value[k], chkGridValue, 1);
								  		if(result == 1) return "" ;
								  		break;
								  	case 2 :
								  		var result = paramChk(value[k], chkGridValue, 2);
								  		if(result == 1) return "" ;
								  		break;
								  }
							  }
						  }						    		  
//			    	  }
			    	  

			    	}// chkflg end
			      } //end if
			  } // end for
		  }
		  
		  
		  //QueryString을 조합한다.
//		  var result="";
		  var resultArr = new Array(2);
		  resultArr = ['',''];
//		  for (i = 0; i < j; i++) {
		  var chkcnt = 0;
		  for (var k = chkidx; k < name.length; k++) {
		    if (name[k] != '') {
		    	if ((name[k].indexOf("checkbox") >-1 ) && chkcnt <= 1) {
			    	chkcnt++;
			    	if ( chkcnt ==2) break;
		    	}
			    resultArr[0] = resultArr[0]+ name[k]+ "|";
		    }
		  }

		  for (var k = chkidx; k < name.length; k++) {
			    resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
		  }
		  
		  
		  //마지막에 | 를 없애기 위함
		  if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
//		  return plain_text;
		  return resultArr;
	}
	function getFormToArr_v3(form, checkRequired, chkGridValue) {
		form = eval(form);
/*		  if (typeof form != "object" || form.tagName != "FORM") {
		    IBS_ShowErrMsg("FormQueryStringEnc 함수의 form 인자는 FORM 태그가 아닙니다.");
		    return "";
		  }*/
		  if(checkRequired==null) checkRequired=false;

//		  var name = new Array(form.elements.length);
//		  var value = new Array(form.elements.length);
		  var name = new Array();
		  var value = new Array();
		  var j = 0;
		  var plain_text="";
		  var startGridIdx=0;
		  var MSG_REQUIRED      = "은(는) 필수입력 항목입니다.";		
		    var chkflg = false;
		  
		  //사용가능한 컨트롤을 배열로 생성한다.
		  len = form.elements.length;
		  for (i = 0; i < len; i++) {
		    var prev_j = j;

	    	if (form.elements[i].type == 'checkbox'){
	    		chkflg = (form.elements[i].checked == true)? true : false ;
	    	}
	    	if(chkflg){
			    switch (form.elements[i].type) {
			      case "button":
			      case "reset":
			      case "submit":
			        break;
			      case "radio":
			      case "checkbox":
			    	  startGridIdx = i;		// checkbox 의 인덱스를 그리드 시작점으로 셋팅한다
//			          if (form.elements[i].checked == true) {
						name[j] = getName(form.elements[i]);
						value[j] = form.elements[i].value;
						j++;
//			          }
			          break;
			      case "select-one":
			          name[j] = getName(form.elements[i]);
			          var ind = form.elements[i].selectedIndex;
			          if(ind >= 0) {
			              value[j] = form.elements[i].options[ind].value;
			          } else {
			            value[j] = "";
			          }
			          j++;
			          break;
			      case "select-multiple":
			          name[j] = getName(form.elements[i]);
			          var llen = form.elements[i].length;
			          var increased = 0;
			          for( k = 0; k < llen; k++) {
			            if (form.elements[i].options[k].selected) {
			              name[j] = getName(form.elements[i]);
			              value[j] = form.elements[i].options[k].value;
			              j++;
			              increased++;
			            }
			          }
			          if(increased > 0) {
			            j--;
			          } else {
			            value[j] = "";
			          }
			          j++;
			          break;
			        default :
			            name[j] = getName(form.elements[i]);
			            value[j] = form.elements[i].value;
			            j++;
			    }
	    	}// end flag if

		    
			  if (checkRequired) {
			      //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
			      //<input type="text" name="txtName" required="이름">
			      if (RequiredChk(form.elements[i])&&prev_j != j && value[prev_j] == "") {
			       	if (form.elements[i].getAttribute("required")=="") {
			          alert('"' + getName(form.elements[i]) + '"' + MSG_REQUIRED);
			        }else{
			          alert('"' + form.elements[i].getAttribute("required")  + '"' + MSG_REQUIRED);
			        }
			        //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
			        try{
			          form.elements[i].focus();
			        } catch(ee) {;}
			        
			        return;
			      }
			    }
		  }

		  var chkidx = 0;
		  for (var i = 0; i < name.length; i++) {
//		    	if (name[i] == "checkbox"){
	    		if (name[i].indexOf('checkbox') > -1){		    		
		    		chkidx = i; 
		    		break;
		    	} 
		  }

		  if(chkGridValue != null && chkGridValue.length > 0){
			  var chkflg = false;
			  
			  for (var k = chkidx; k < name.length; k++) {
			    if (name[k] != '') {
//			    	if (name[k] == 'checkbox'){
			    	if (name[k].indexOf('checkbox') > -1){
			    		chkflg = (value[k] == 'on')? true : false ;
			    	}
//			    	alert(name[k] +":::"+value[k]+":::"+chkflg);
			    	
			    	if(chkflg){
//			    	  if( chkGridValue.operation != null && chkGridValue.operation.length > 0){
//			    		  var key1 = chkGridValue.keys[0];
//			    		  var key2 = chkGridValue.keys[1];
//			    		  var value1 = "";
//			    		  var value2 = "";
//			    		  var oper = chkGridValue.operation[0];
//			    		  var compValue = chkGridValue.compValue[0];
//
//			    		  if(name[k] == key1){
//			    			  value1 = value[k];
//			    		  }
//			    		  if(name[k] == key2){
//			    			  value2 = value[k];
//			    		  }
//			    		  alert(value1+oper+value2);
//			    		  var targetValue = eval(value1+oper+value2);
//			    		  
//			    		  alert(targetValue);
//			    		  if(targetValue == compValue){
//			    			  alert(chkGridValue.msg0);
//			    			  return "" ;
//			    		  }
			    			  
//			    	  }else{
						  for(var i=0; i<chkGridValue.keys.length; i++){
							  var key = chkGridValue.keys[i];
							  if(name[k] == key){
//								  alert(key.toString()+"::\n"+value.toString());
								  //alert(name[k] +"::"+key+"::"+value[k]);
								  switch(i){
								  	case 0: 
								  		var result = paramChk(value[k], chkGridValue, 0);
								  		if(result == 1) return "" ;
								  		break;
								  	case 1 : 
								  		var result = paramChk(value[k], chkGridValue, 1);
								  		if(result == 1) return "" ;
								  		break;
								  	case 2 :
								  		var result = paramChk(value[k], chkGridValue, 2);
								  		if(result == 1) return "" ;
								  		break;
								  }
							  }
						  }						    		  
//			    	  }
			    	  

			    	}// chkflg end
			      } //end if
			  } // end for
		  }
		  
		  
		  //QueryString을 조합한다.
//		  var result="";
		  var resultArr = new Array(2);
		  resultArr = ['',''];
//		  for (i = 0; i < j; i++) {
		  var chkcnt = 0;
		  for (var k = chkidx; k < name.length; k++) {
		    if (name[k] != '') {
		    	if ((name[k].indexOf("checkbox") >-1 ) && chkcnt <= 1) {
			    	chkcnt++;
			    	if ( chkcnt ==2) break;
		    	}
		    	if (!/__\d+$/.test(name[k])) {  // ← 이 한 줄 추가
		            resultArr[0] = resultArr[0]+ name[k]+ "|";
		        }
		    }
		  }

		  for (var k = chkidx; k < name.length; k++) {
			  if (!/__\d+$/.test(name[k])) {
			    resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
			  }
		  }
		  
		  
		  //마지막에 | 를 없애기 위함
		  if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
//		  return plain_text;
		  return resultArr;
	}

		/**
		 * 파라미터 체크
		 * @param obj
		 * @returns
		 */
		function paramChk(gridValue, compareValue, idx){
			var val = eval('compareValue.value'+idx);
			var msg = eval('compareValue.msg'+idx);
			//alert(val+"::"+gridValue+"::"+msg);
			var rtnValue = 0;
//			var len = val.length;
//			if(len <= 1){
		  		if(gridValue == val){
			  		alert(msg);
			  		rtnValue = 1;
		  		}
//		  	}else{
////		  		alert(gridValue +"::"+ val[0]+"::"+val[1]);
//		  		if((gridValue != val[0]) && (gridValue != val[1])){
//		  			alert(msg);
//		  			rtnValue = 1;
//		  		}
//			}
			return rtnValue;
		}	



	/**
	 * 객체의 ID 또는 Name 취득
	 * @param obj
	 * @returns
	 */
	function getName(obj){
		if(obj.name!=""){
			return obj.name;	
		}else if(obj.id!=""){
			return obj.id;	
		}else{
			return "";	
		}
	}	
	
	/**
	 * required 속성값 체크
	 */
	function RequiredChk(obj){
		return (obj.getAttribute("required")!=null);
	}
	
	/**
	 * check box 선택된 count를 리턴
	 */
	function kepCheckedCnt(id){
		var chlen = $("input[name='"+id+"']:checkbox:checked").length;
		if (chlen == 0){
			alert('항목을 선택해 주십시오.');
			return 0;
		}
		return chlen;
		/*
		$("input[name='ch']:checked", "form[name=form" +num + "]").each(function() {
		alert($(this).val());
		}); 
		*/
	}	
	
	/**
	 * check box 선택된 value 모아서 리턴
	 */
	function kepCheckedVal(id){  		
		  
		if (kepCheckedCnt(id)==0) return "";
		var str = "";
		$("input[name='"+id+"']:checked").each(function() {
			str = str + $(this).val()+"/";
		});  
		
		return str;
	}	
	
	/**
	 * 대문자로변경한다.
	 */
	function kepToUpper(id){  	

		var txt =  $("#"+id).val();
		 $("#"+id).val(txt.toUpperCase());
		return  txt.toUpperCase();
		
	}	
	
	/**
	 * 소문자로 변경한다.
	 */
	function kepToLower(id){  		
		
		var txt =  $("#"+id).val();
		return  txt.toLowerCase();
	}	
	
	/**
	 * 공백을 제거한다.
	 * input 용
	 */
	function kepTrim(id){  		
		
		var txt =  $("#"+id).val();
		return  $.trim(txt);
	}		
	
	/**
	 * 공백을 제거한다.
	 * String 용
	 */
	function TrimCommon(str){  		
		 
		return  kepTrimStr(str);
	}			
	
	/**
	 * 공백을 제거한다.
	 * String 용
	 */
	function kepTrimStr(str){  		
		 
		return  $.trim(str);
	}			
	
	/**
	 * 문자열 교체
	 * str 교체할대상
	 * str1 교체한대상
	 */
	function kepReplaceAll(id,str1,str2){  		
		var txt =  $("#"+id).val();
		txt = kepTrimStr(txt); 
		var tmp = "/"+str1+"/gi"; 
		if (str2 == ""){
			return txt.replace(tmp,"");
		}else{
			return txt.replace(tmp,str2);
		} 
	}			

	/**
	 * 날짜값에 슬래시(/) 삽입
	 * startId 날짜기준
	 */    	
   	function kepDateSlashAdd (day)
   	{   		
		var ymd = day;
		if (kepIsValueNull(ymd) == true) return "계산일필수";
	
		 var yyyy = ymd.substr(0,4);
		 var mm = ymd.substr(4,2) ;
		 var dd = ymd.substr(6,2);
		 return  "" + yyyy + "/" + mm + "/" + dd ;
	} 
   	
   	/**
   	 * 날짜값에 슬래시(/) 삽입
   	 * startId 날짜기준
   	 */    	
   	function kepDateSlashAdd2 (day)
   	{   		
   		var ymd = day;
   		if (kepIsValueNull(ymd) == true) return "";
   		
   		var yyyy = ymd.substr(0,4);
   		var mm = ymd.substr(4,2) ;
   		var dd = ymd.substr(6,2);
   		return  "" + yyyy + "/" + mm + "/" + dd ;
   	} 
   	
   	
	/**
	 * 문자열 자르고 ... 붙인다.
	 * limit 자를수
	 * replaceStr 붙일문자
	 */
	function kepCutStr(id,limit,tail){
		var tmpStr = $("#"+id).val();
		var str = $("#"+id).val();
		
		var byte_count = 0;
		var len = str.length;
		var dot = "";
		for(var i=0; i<len; i++){
		  byte_count += chr_byte(str.charAt(i)); 
		  if(byte_count == limit-1){
		    if(chr_byte(str.charAt(i+1)) == 2){
		      tmpStr = str.substring(0,i+1);
		      dot = tail;
		    }else {
		      if(i+2 != len) dot = tail;
		      tmpStr = str.substring(0,i+2);
		    }
		    break;
		  }else if(byte_count == limit){
		    if(i+1 != len) dot = tail;
		    tmpStr = str.substring(0,i+1);
		    break;
		  }
		}		 
		return tmpStr+dot;
	}

	function chr_byte(chr){
		if(escape(chr).length > 4)
		  return 2;
		else
		  return 1;
	}
	
	/**
	 * 날짜 차이
	 * date1,date2 시작일,종료일
	 * pType 구분 D 일수 , M 개월수
	 */
   	function kepGetDateDiff(startId, endId, pType){
    		 //param : pStartDate - 시작일
    		 //param : pEndDate  - 마지막일
    		 //param : pType       - 'D':일수, 'M':개월수
    		var pStartDate = $("#"+startId).val();
        	var pEndDate = $("#"+endId).val();
        	
        	pStartDate = pStartDate.replace(/[/]/gi,"");
        	pEndDate = pEndDate.replace(/[/]/gi,"");
        	
        	 //alert(pStartDate + " "+pEndDate);
    		
    		 var strSDT = new Date(pStartDate.substring(0,4),pStartDate.substring(4,6)-1,pStartDate.substring(6,8));
    		 var strEDT = new Date(pEndDate.substring(0,4),pEndDate.substring(4,6)-1,pEndDate.substring(6,8));
    		 var strGapDT = 0;
    		 
    		// alert(strSDT + " "+strGapDT);
    		  
    		 if(pType == 'D') {  //일수 차이
    		     strGapDT = (strEDT.getTime()-strSDT.getTime())/(1000*60*60*24);
    		 } else {            //개월수 차이
    		     //년도가 같으면 단순히 월을 마이너스 한다.
    		     if(pEndDate.substring(0,4) == pStartDate.substring(0,4)) {
    		         strGapDT = pEndDate.substring(4,6) * 1 - pStartDate.substring(4,6) * 1;
    		     } else {
    		         strGapDT = ((strEDT.getTime()-strSDT.getTime())/(1000*60*60*24*365.25/12)).toFixed(2);
    		     }
    		 }
    		 return strGapDT;
    	}

	/**
	 * input 을 이용 날짜 계산 (더하기,기)
	 * 예) date_add("2011-03-30", 1)
	 * startId 날짜기준
	 * days 날짜계산
	 * gubun 더하기 기
	 */    	
   	function kepDateAdd (startId,days,gubun )
   	{
   		
	var ymd = $("#"+startId).val(); 
	var v_day = days; 
	ymd = ymd.replace(/[/]/gi,"");
	
	if (kepIsValueNull(v_day) == true) return "계산일필수";
	if (kepIsValueNull(gubun) == true) return "구분필수";
	
	 var yyyy = ymd.substr(0,4);
	 var mm = eval(ymd.substr(4,2) + "- 1") ;
	 var dd = ymd.substr(6,2);

	 if (gubun == "M"){
		 var dt3 = new Date(yyyy, mm, eval(dd + '-' + v_day));
	 }else if (gubun == "P"){
		 var dt3 = new Date(yyyy, mm, eval(dd + '+' + v_day));
	 }

	 yyyy = dt3.getFullYear();
	 mm = (dt3.getMonth()+1)<10? "0" + (dt3.getMonth()+1) : (dt3.getMonth()+1) ;
	 dd = dt3.getDate()<10 ? "0" + dt3.getDate() : dt3.getDate();

	 return  "" + yyyy + "/" + mm + "/" + dd ;

	} 
   	
	/**
	 * 오늘날짜를 기준으로 날짜 계산  (더하기,기)
	 * startId 날짜기준
	 * days 날짜계산
	 * gubun 더하기 기
	 */    	
   	function kepToDateAdd (days,gubun,slash )
   	{   		
		var ymd = kepGetNowTimeStr("YYYYMMDD","");
		var v_day = days;
		var flag = (slash=="noslash")? "":"/"; 

		if (kepIsValueNull(v_day) == true) return "계산일필수";
		if (kepIsValueNull(gubun) == true) return "구분필수";
	
		 var yyyy = ymd.substr(0,4);
		 var mm = eval(ymd.substr(4,2) + "- 1") ;
		 var dd = ymd.substr(6,2);
	
		 if (gubun == "M"){
			 var dt3 = new Date(yyyy, mm, eval(dd + '-' + v_day));
		 }else if (gubun == "P"){
			 var dt3 = new Date(yyyy, mm, eval(dd + '+' + v_day));
		 }
	
		 yyyy = dt3.getFullYear();
		 mm = (dt3.getMonth()+1)<10? "0" + (dt3.getMonth()+1) : (dt3.getMonth()+1) ;
		 dd = dt3.getDate()<10 ? "0" + dt3.getDate() : dt3.getDate();
	
		 return  "" + yyyy + flag + mm + flag + dd ;
	} 
   	
   	/**
   	 * 
     * 오늘날짜를 기준으로 월 계산  (더하기,기)
	 * startId 날짜기준
	 * days 월계산
	 * gubun 더하기 기
   	 */
   	function kepToMonthAdd (days,gubun ){
   		return kepToMonthAdd(days,gubun,"");
   	}
   	
	/**
	 * 오늘날짜를 기준으로 월 계산  (더하기,기) - noslash 추가
	 * startId 날짜기준
	 * days 월계산
	 * gubun 더하기 기
	 */    	
   	function kepToMonthAdd (days,gubun, slash )
   	{   		
		var ymd = kepGetNowTimeStr("YYYYMMDD","");
		var v_day = days;
		var flag = (slash=="noslash")? "":"/";

		if (kepIsValueNull(v_day) == true) return "계산일필수";
		if (kepIsValueNull(gubun) == true) return "구분필수";
	
		 var yyyy = ymd.substr(0,4);
		 var mm = eval(ymd.substr(4,2) + "- 1") ;
		 var dd = ymd.substr(6,2);
	
		 if (gubun == "M"){
			 var dt3 = new Date(yyyy, eval(mm + '-' + v_day), dd);
		 }else if (gubun == "P"){
			 var dt3 = new Date(yyyy, eval(mm + '+' + v_day), dd);
		 }
	
		 yyyy = dt3.getFullYear(); 
		 mm = (dt3.getMonth()+1)<10? "0" + (dt3.getMonth()+1) : (dt3.getMonth()+1) ;
		 dd = dt3.getDate()<10 ? "0" + dt3.getDate() : dt3.getDate();
	
		 return  "" + yyyy + flag + mm + flag + dd ;
	}    	
   	 
 
	/**
	 * 사업자번호 체크 XXX-XX-XXXXX 형태로 체크
	 * return
	 * true(맞는 형식
	 * false(잘못된 형식)
	 */    	
	function KepBizNoCheck(id) {
	  	var num = $.trim($("#"+id).val());
	 	if(num.length == 10) {
	 		num = num.substring(0, 3) + "-" + num.substring(3, 5) + "-" + num.substring(5, 10);
	 	}
	 	else {
	 		return false;
	 	}
	 	num = num.match(/([0-9]{3})-?([0-9]{2})-?([0-9]{5})/);
	 	if(!num) return false;
	 	num = RegExp.$1 + RegExp.$2 + RegExp.$3;
	 	var cVal = 0;
	 	for (var i=0; i<8; i++) {
	 		var cKeyNum = parseInt(((_tmp = i % 3) == 0) ? 1 : ( _tmp  == 1 ) ? 3 : 7);
	 		cVal += (parseFloat(num.substring(i,i+1)) * cKeyNum) % 10;	
	 	}
	 	var li_temp = parseFloat(num.substring(i,i+1)) * 5 + '0';
	 	cVal += parseFloat(li_temp.substring(0,1)) + parseFloat(li_temp.substring(1,2));
	 	return (parseInt(num.substring(9,10)) == 10 - (cVal % 10)%10) ? true : false;
	}
	
	/**
	 * 사업자번호 체크 XXX-XX-XXXXX 형태로 체크
	 * return
	 * true(맞는 형식
	 * false(잘못된 형식)
	 */    	
	function KepBizNoCheckStr(value) {
	  	var num = value.replace(/-/gi,"");
	  	
	 	if (num.length == 10) {
	 		num = num.substring(0, 3) + "-" + num.substring(3, 5) + "-" + num.substring(5, 10);
	 	}
	 	else {
	 		return false;
	 	}
	 	num = num.match(/([0-9]{3})-?([0-9]{2})-?([0-9]{5})/);
	 	alert(num);
	 	if(!num) return false;
	 	num = RegExp.$1 + RegExp.$2 + RegExp.$3;
	 	var cVal = 0;
	 	for (var i=0; i<8; i++) {
	 		var cKeyNum = parseInt(((_tmp = i % 3) == 0) ? 1 : ( _tmp  == 1 ) ? 3 : 7);
	 		cVal += (parseFloat(num.substring(i,i+1)) * cKeyNum) % 10;	
	 	}
	 	var li_temp = parseFloat(num.substring(i,i+1)) * 5 + '0';
	 	cVal += parseFloat(li_temp.substring(0,1)) + parseFloat(li_temp.substring(1,2));
	 	return (parseInt(num.substring(9,10)) == 10 - (cVal % 10)%10) ? true : false;
	}
	
	/**
	 * 사업자번호 체크 XXX-XX-XXXXX 형태로 체크
	 * return
	 * true(맞는 형식
	 * false(잘못된 형식)
	 */    	
	function KepBizNoCheckStr2(value) {
		var strNumb=  value.replace(/-/gi,"");

		 sumMod = 0;
		 sumMod += Number(strNumb.substring(0,1));
		 sumMod += Number(strNumb.substring(1,2)) * 3 % 10;
		 sumMod += Number(strNumb.substring(2,3)) * 7 % 10;
		 sumMod += Number(strNumb.substring(3,4)) * 1 % 10;
		 sumMod += Number(strNumb.substring(4,5)) * 3 % 10;
		 sumMod += Number(strNumb.substring(5,6)) * 7 % 10;
		 sumMod += Number(strNumb.substring(6,7)) * 1 % 10;
		 sumMod += Number(strNumb.substring(7,8)) * 3 % 10;
		 sumMod += Math.floor(Number(strNumb.substring(8,9)) * 5 / 10);
		 sumMod += Number(strNumb.substring(8,9)) * 5 % 10;
		 sumMod += Number(strNumb.substring(9,10));

		 if (sumMod % 10 != 0)
		 {
//		  alert("올바르지 않은 사업자등록번호입니다.");
			 return false;
		 } else {
//			 alert("유효합니다.");
			 return true;
		 }
		
	}
	
	/**
	 * alert 메시지
	 */    	
	function KepAlert(msg) { 
		//var msg = $.trim($("#"+id).val());
		return msg;
	}
	
	/**
	 * cofirm 메시지
	 * return
	 * true 확인
	 * false 취소
	 */    	
	function KepConfirm(msg) { 
		//var msg = $.trim($("#"+id).val());
		var ret = confirm(msg);
		return ret;
	}	
	
	
	/**
	 * key , value 를 이용하여 
	 * hidden 을 반복하여 만든다.
	 */    
	function kepHiddenString(key,value){
		var result = "";
		var arrKey = key.split("|");
		var arrValue = value.split("|");
		if (arrKey.length == arrValue.length){
			for (var i=0; i<arrKey.length; i++){
				result = result + "<input type='hidden' name='"+arrKey[i]+"' id='"+arrKey[i]+"' value='"+arrValue[i]+"'>";
			}
		}
		return result;
	}
	
	/**
	 * 아래의 문자를 바꾼다.
	 */    
	function KepFilterString(val){

		var str= "";

		// 특수문자 아스키코드 값
		// $	==> 36
		// '	==> 39	 
		// "	==> 34	 
		// ^	==> 94	 
		// <	==> 60
		// >	==> 62

		for(i=0;i<val.length;i++) {
			if(val.charCodeAt(i) == 36) {
				str+=val.charAt(i).replace("$", "＄");
			}else if(val.charCodeAt(i) == 39) {
				str+=val.charAt(i).replace("'", "′");
			}else if(val.charCodeAt(i) == 34) {
				str+=val.charAt(i).replace("\"", "″");
			}else if(val.charCodeAt(i) == 94) {
				str+=val.charAt(i).replace("^", "＾");
			}else if(val.charCodeAt(i) == 60) {
				str+=val.charAt(i).replace("<", "〈");
			}else if(val.charCodeAt(i) == 62) {
				str+=val.charAt(i).replace(">", "〉");
			}else {
				str+=val.charAt(i);
			}
		}
		return str;
	}

	  
	/**
	 * 아래의 문자를 바꾼다.
	 */    
	function isUploadFileCheckExt(fileName) {

		var bFlag = false;

		var ext	= fileName.substring(fileName.lastIndexOf("."),fileName.length()).toLowerCase();
		var permit_ext_list = new Array(".ncf", ".txt",".gif",".png", ".jpg",".jpeg", ".bmp",".sit",".xls",".doc",".docx",".hwp",".ppt",".pdf",".tif", ".tiff", ".xlsx", ".zip",".dwg",".ai",".gul");
		
		for(var permit_idx=0; permit_idx<permit_ext_list.length; permit_idx++) {

			if(permit_ext_list[permit_idx] == ext) {
				bFlag=true;
				break;
			}
		}

		return bFlag;
	}

	
	/** 멀티건 조회 팝업 리턴시 ~외 ?건이라 리턴
	 * text
	 * gubun  
	 * return
	 */    	
	function kepMultiName(text,gubun){
		var arrKey = text.split(gubun);
		var result = ""; 
		if (arrKey.length > 2){
			result = arrKey[0]  + " 외 "+eval(arrKey.length-2)+"건";
		}  else {
			result = arrKey[0]  ;
		}
		return result;
	}

	/*조회 조건  - 팝업 링크 조건 초기화
	 * ex) 고객사 조건
	 * 
	 */
	function kepEraser(code, name){
		var _code = "#" + code;
		var _name = "#" + name;
		$(_code).val("");
		$(_name).val("");
	}
	
	/*조회 조건  - 팝업 링크 조건 초기화
	 * ex) 고객사 조건
	 * 
	 */
	function kepEraser2(code, name, name2){
		var _code = "#" + code;
		var _name = "#" + name;
		var _name2 = "#" + name2;
		$(_code).val("");
		$(_name).val("");
		$(_name2).val("");
	}
	
	/* 조회조건 - From - To 셋팅
	 * 현재일 기준으로 -1개월 ~ -3개월
	 * 
	 * 	 */
	function kepMonth(from,to,mt){
		var _from = "#" + from;
		var _to = "#" + to;
		$(_from).val( kepToMonthAdd(mt,"M") );
		$(_to).val( kepGetNowTimeStr('YYYYMMDD','/') );
		
	}
	/* 조회조건 - From - To 셋팅
	 * 현재일 기준으로 -1개월 ~ -3개월
	 * 
	 * 	 */
	function kepMonth_v2(from,to,mt){
		var _from = "#" + from;
		var _to = "#" + to;
		$(_from).val( kepToMonthAdd(mt,"M") );
		$(_to).val( kepGetNowTimeStr('YYYYMMDD','/') );
		
		$(_from).trigger('dateChanged');
		$(_to).trigger('dateChanged');
//		setCalendar(); //날짜바꾸면 달력 셋팅 다시
		
	}
	/* 조회조건 - From - To 셋팅
	 * 시작일 기준으로 -1개월 ~ -3개월
	 * 
	 * 	 */
	function kepFromMonth(from,to,mt){
		var _from = "#" + from;
		var _to = "#" + to;
		var ymd = $(_from).val();		
		var yyyy = ymd.substr(0,4);
		var mm =  ymd.substr(5,2);
		var dd = ymd.substr(8,2);
		
		$(_to).val(yyyy+"/"+mm+"/"+ dd);
		
		var tToday = new Date(yyyy,eval(mm + '-' + mt),dd);		
		 var yyyy = tToday.getFullYear();
		 var mm = tToday.getMonth();
		 var dd   = tToday.getDate();
		 mm = "" +mm;
		 mm =(mm.length ==1)?"0"+mm: mm;
		 dd = ""+dd;
		 dd=(dd.length==1)?"0"+dd:dd;
		 if(mm == "00"){
			 mm = "12";
			 yyyy = yyyy-1;
		 }
		$(_from).val(yyyy+"/"+mm+"/"+ dd);
	}
	
	function kepYearMonth(id,diff){ //달력이 년/월 형식일 때 -1개월,당월 등을 사용하기 위함
		var id = "#"+id;
		var yearMonth = "";
		var date;
		if(diff == 0){ //당월
			date = new Date();
			yearMonth = kepGetNowTimeStr('YYYYMM','/');
		}else{
			var val = $(id).val();
			if(val && val.length >= 6){
				var cleanVal = val.replace(/[^0-9]/g,""); //슬래시 제거
				var y = parseInt(cleanVal.substring(0,4),10);
				var m = parseInt(cleanVal.substring(4,6),10) -1;
				date = new Date(y,m+diff,1);
			}else{
				date = new Date();
			}
			
			var yyyy = date.getFullYear();
			var mm = date.getMonth()+1;
			if(mm<10) mm="0"+mm;
			
			yearMonth = yyyy + "/" + mm;
		}
		$(id).val(yearMonth);
		
		//달력 동기화
		if($(id).hasClass("hasDatepicker")){
			$(id).datepicker("option","defaultDate",date);
			$(id).datepicker("setDate",date);
		}
	}
	
	function kepYearMonth(from,to,diff){ //파라미터 3개 넘길 때
		var _from = "#"+from;
		var _to = "#"+to;
		var nDiff = parseInt(diff,10);
		
		if(isNaN(nDiff)) nDiff=0;
		
		var fromDate,toDate;
		
		var formatYM = function(d){
			var y = d.getFullYear();
			var m = d.getMonth()+1;
			return y+"/"+(m<10 ? "0"+m : m);
		};
		
		var calcDate = function(id,calcMonth){
			var val = $(id).val();
			if(val && val.length >=6){
				var cleanVal = val.replace(/[^0-9]/g,"");
				var y = parseInt(cleanVal.substring(0,4),10);
				var m = parseInt(cleanVal.substring(4,6),10)-1;
				return new Date(y,m+calcMonth,1);
			}else{
				var now = new Date();
				return new Date(now.getFullYear(),now.getMonth()+calcMonth,1);
			}
		};
		
		if(nDiff == 0){ //당월
			var now = new Date();
			fromDate = new Date(now.getFullYear(),now.getMonth()-1,1);
			toDate = new Date(now.getFullYear(),now.getMonth(),1);
		}else{
			fromDate = calcDate(_from,nDiff);
			toDate = calcDate(_to,nDiff);
		}
		
		var fromYM = formatYM(fromDate);
		var toYM = formatYM(toDate);
		
		$(_from).val(fromYM);
		$(_to).val(toYM);
		
		if($(_from).hasClass("hasDatepicker")){
			$(_from).datepicker("option","defaultDate",fromDate);
			$(_from).datepicker("setDate",fromDate);
		}
		if($(_to).hasClass("hasDatepicker")){
			$(_to).datepicker("option","defaultDate",toDate);
			$(_to).datepicker("setDate",toDate);
		}
		
		$(_from).trigger("change");
		$(_to).trigger("change");
	}
	/*---------------------------------------------------
	 *
	 * 소숫점 체크(공백과 숫자 체크도 동시에....)-->cnt는....소숫점 뒤에 자릿수.....소숫점이 없으면...0
	 *
	 ----------------------------------------------------*/
	function chkDecimal(num, cnt) { 

		  return kepChkDecimal(num, cnt);
		}
	
	function kepChkDecimal(num, cnt) {
		  var i;

		  if(num.length <= 0) return false;
		  if (!(IsNumber1(num))) return false;

		  chk = false;
		  pcnt = 0;
		  for(i=0;i<num.length;i++) {
		    if ((num.charAt(i) == '.') && (cnt == 0)) return false;
		    if (num.charAt(i) == '.') chk = true;

		    if (pcnt > cnt) return false;
		    if (chk) pcnt ++;
		  }

		  return true;
		}
	/*---------------------------------------------------
	 *
	 * 숫자여부를 검사 공백은 false
	 *
	 ----------------------------------------------------*/
	function IsNumber1(num) {
	  var i;

	  if(num.length <= 0) return false;

	  pcnt = 0;
	  for(i=0;i<num.length;i++) {
	    if (num.charAt(i) == '.') {
	      pcnt ++;
	    }

	    if((num.charAt(i) < '0' || num.charAt(i) > '9') && (num.charAt(i) != '.' ||  pcnt>1)) return false;
	  }

	  return true;
	}
	
	/*---------------------------------------------------
	 *
	 * 사용자가 입력한 콤마나 화폐단위 제거하기.
	 *
	 ----------------------------------------------------*/

	function kepFilterNum(str) {
	re = /^\$|,/g;

	// "$" and "," 입력 제거

	return str.replace(re, "");
	}
	
	function filterNum(str) { 
		return kepFilterNum(str); 
	}
		
	
	
	/*---------------------------------------------------
	 *
	 * Comma를 찍어준다.
	 *
	 ----------------------------------------------------*/

	function kepCommaNum(num)
	{
	   if (num < 0 ) { num *= -1; var minus = true; }
	   else var minus = false;

	   var dotPos = (num+"").split(".");
	   var dotU = dotPos[0];
	   var dotD = dotPos[1];
	   var commaFlag = dotU.length%3;

	   if(commaFlag) {
	   var out = dotU.substring(0, commaFlag);
	   if(dotU.length > 3) out += ",";
	   }
	   else var out = "";

	     for (var i = commaFlag; i < dotU.length; i+=3) {
	      out += dotU.substring(i, i+3);
	      if(i < dotU.length-3) out += ",";
	     }

	     if(minus) out = "-" + out;
	     if(dotD) return out + "." + dotD;
	     else return out;
	}	
	
    /**   원하는 소수점 자릿수로 반올림 한다.
	    **    position이 Zero일 경우 원본을 리턴한다.(거의 의미 없음...)
	    **   @param d   : 원본  Number
	    **   @param position : 자릿수
	    **
	    **   @return  String : 바뀌 Number
		예) var temp = 0.32786;
		    getRound(temp,3)의 return값은 0.33가 된다.
	    **/
	function kepGetRound(d, position)
	{
		 var square = 0.0;
		 if(position == 0)  return d;
		 if(position == 1)  return Math.round(d);
		 square = Math.pow(10,position-1);
		 return Math.round(d * square ) / square;
	}
	
	/**   원하는 소수점 자릿수로 반올림 한다.
	**   @param d   : 원본  Number
	**   @param position : 자릿수
	**   @return  String : 바뀌 Number
	예) var temp = 0.32786;
		getRound(temp,3)의 return값은 0.33가 된다.
	**/
	function kepGetRound2(d, position)
	{
	 var square = 0.0;
	 square = Math.pow(10,position-1);
	 return Math.round(d * square ) / square;
	}
	
	/*----------------------------------------------------------------------
	 * FUNCTION: getFloor
	 * 파라메타 d : 변환하고자 하는 데이타, position : 적용 소숫점 자릿수
		getFloor은 원하는 소숫점에서 그 아래값을 절사 하는 함수이다.
		예) var temp = 0.32786;
			getFloor(temp,3)의 return값은 0.32가 된다.
	 *
	----------------------------------------------------------------------*/
	function kepGetFloor2(d, position)
	{
	   var square = 0.0;
	   square = Math.pow(10,position-1);
	   return Math.floor(d * square ) / square;
	}
	
	/*
	 * 고객사 카테고리 시작 
	 * CEJ
	 */
	var h_nodata = "<table><tr><td>조회 내용이 없습니다.</td></tr></table>";

	/*
	 * 카테고리 보이기/숨기기
	 */
	function kep_categori_show(){
		
	   // 카테고리 조회 
	   byca_comorg_code =  $("#h_byca_comorg_code").val(); 
	   kep_h_getCategoriList(byca_comorg_code,"1","");
	  if ($("#quickCategoriArea").css("display") == "none"){
		  $("#quickCategoriArea").fadeIn(150);
	  }else{
		  $("#quickCategoriArea").fadeOut(150);
	  }
	  
	  kep_h_topmenunnavi(1,"");
		
	} 

	/*
	 * 카테고리 보이기/숨기기
	 */
	function kep_categori_pco_show(){
		
	   // 카테고리 조회 
	   byca_comorg_code =  $("#h_byca_comorg_code").val(); 
	   kep_h_pco_getCategoriList(byca_comorg_code,"2","R");
	  if ($("#quickCategoriArea").css("display") == "none"){
		  $("#quickCategoriArea").fadeIn(150);
	  }else{
		  $("#quickCategoriArea").fadeOut(150);
	  }
	  
	  kep_h_pco_topmenunnavi(2,"");
		
	} 
	// 고객사,분류 depth,카테고리아이디
	/*
	 * 카테고리 보인후 화면 출력
	 */
	function kep_h_pco_getCategoriList(com_code,depth,std_categ_id) {  
		
			var strTmp = "<table width=style:100%>";
			var p_depth = eval(depth)+1; 
			if (depth == 2){
				$("#h_cateMenu3").html(h_nodata);
				$("#h_cateMenu4").html(h_nodata);
				$("#h_cateMenu5").html(h_nodata);
			}else if (depth == 3){ 
				$("#h_cateMenu4").html(h_nodata);
				$("#h_cateMenu5").html(h_nodata);
			}else if (depth == 4){  
				$("#h_cateMenu5").html(h_nodata);
			}
		 
		 
			$.ajax({
			      type: "POST",
			      dataType:"json",
			      url: "/mdcm/getCategoriList.do",
			      headers: { 'X-Requested-With': 'XMLHttpRequest' },
			      data: { param1: com_code,param2: depth,param3: std_categ_id},
			     async : false,
			     success:function( response ) {  		    	  
			    	 	 		    	  
		    	 	if (response.data.length > 0){
		 		    	  for (var i=0; i<response.data.length; i++){ 
		 		    		  
		 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
		 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
		 		    		var CATEG_NAME_REAL = $.trim(eval("response.data["+i+"].CATEG_NAME_REAL")); 
		 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
		 		    		var D_CATEG_SYS_CODE = $.trim(eval("response.data["+i+"].CATEG_SYS_CODE")); 
		 		    		var D_PID = $.trim(eval("response.data["+i+"].PID")); 
		 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
		 		    		   
		 		    		if ((i%6)==0){
		 		    			strTmp += "<tr>";
							}else{
								strTmp += "";
							}
		 		    		
		 		    		if (D_CNT == ""){
		 		    			strTmp += "<td style=width:180px><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_h_pco_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+CATEG_NAME_REAL+"\')\">－ "+D_CATEG_NAME+" "+D_CNT+"</td>";	    	
		 		    		}else{
		 		    			strTmp += "<td style=width:180px><a href=\"javascript:kep_sel_h_pco_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+CATEG_NAME_REAL+"\')\">－ "+D_CATEG_NAME+" "+D_CNT+"</td>";	 			 	
		 		    		}
		 		    		
		 		    		if ((i%6)==5){
		 		    			strTmp += "</tr>";
							}else{
								strTmp += "";
							}
		 		    		 
			 		      }	 		    //	class="selected"
		    		  }else{
		    			  strTmp = h_nodata;
		    		  }   	  
		    	 	
		    	 	strTmp += "</table>"
		    	 	//alert(strTmp);
						$("#h_cateMenu"+depth).html(strTmp);

				      },
				 error:function( response ) {  		    	   
			    	 alert("오류발생하였습니다.");
				      }
		    });  
	}

	/*
	 * 카테고리 보인후 선택된 대상 출력
	 */
	function kep_h_pco_topmenunnavi(depth,categ_name){
	    if (depth==2){		   
			$("#h_category_name1").val("");
		   	$("#h_category_name2").val("");
		   	$("#h_category_name3").val("");
		}else if (depth==3){
		   	$("#h_category_name1").val(categ_name);
		   	$("#h_category_name2").val("");
		   	$("#h_category_name3").val("");
	   }else    if (depth==4){ 
		   	$("#h_category_name2").val(" >"+categ_name);
		   	$("#h_category_name3").val("");
		   }else    if (depth==5){ 
		   	$("#h_category_name3").val(" >"+categ_name);
	   }
	   
	   $("#h_topmenunnavi").text("전체 >"+$("#h_category_name1").val() +  $("#h_category_name2").val() +  $("#h_category_name3").val());
	}
	/*
	 * 카테고리 목록조회
	 */
	function kep_sel_h_pco_getCategoriList(depth,std_categ_id,categ_name) {  
		
	   var byca_comorg_code =  $("#h_byca_comorg_code").val();  
	   
	   kep_h_pco_topmenunnavi(depth,categ_name);
	   kep_h_pco_getCategoriList(byca_comorg_code,depth,std_categ_id); // 고객사,분류 depth,카테고리아이디 
	}
	/*
	 * 카테고리 목록조회
	 */
	function kep_sel_h_getCategoriList(depth,std_categ_id,categ_name) {  
		
	   var byca_comorg_code =  $("#h_byca_comorg_code").val();  
	   
	   kep_h_topmenunnavi(depth,categ_name);
	   kep_h_getCategoriList(byca_comorg_code,depth,std_categ_id); // 고객사,분류 depth,카테고리아이디 
	}

	/*
	 * 카테고리 를 이용한 화면 이동 삼품목록으로 이동
	 */
	function kep_sel_h_pco_getItmeList(std_categ_id,categ_name){

		document.forms.locationForm.st_categ_id.value = std_categ_id;		
		$('#locationForm').attr("action", "/mdcm/getBuyerMdCmPCODLisList.do").submit(); 
		
	}
	/*
	 * 카테고리 를 이용한 화면 이동 삼품목록으로 이동
	 */
	function kep_sel_h_getItmeList(std_categ_id,categ_name){
		//alert(std_categ_id + " " +categ_name);
		/*
		var categ_code =  std_categ_id; 
		var buyer =  $("#h_byca_comorg_code").val(); 
		var byca_comorg_code =  $("#h_byca_comorg_code").val(); 
		
		$("#buyerCategItemListLocation_categ_code").val(categ_code); // 카테고리번호
		$("#buyerCategItemListLocation_byca_comorg_code").val(byca_comorg_code);  
		$("#quickCategoriArea").hide();
		
		 $('#buyerCategItemListLocation').attr("action", "/mdcm/getBuyerMdCmGoodsLisList.do").submit();    
		 */
		
		document.searchDiForm.st_description.value = "";	 
		document.searchDiForm.st_specification.value = "";	 
		document.searchDiForm.st_maker.value = "";	 
		document.searchDiForm.st_categoty_name.value = "";	 
		document.searchDiForm.searchMode.value = "";	 
		
		document.searchDiForm.onepagerow.value = "10";
		document.searchDiForm.curPage.value = "1";
		document.searchDiForm.st_image_status.value = "";
		document.searchDiForm.groupCategoryText.value = "";
		document.searchDiForm.groupMakerName.value = "";
		document.searchDiForm.searchSort.value = "";
		document.searchDiForm.st_sort_change.value = "";	 
		document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = std_categ_id;	 
		document.searchDiForm.searchTarget.value = "CATEG_NAME";	 
		document.searchDiForm.searchTerm.value = categ_name;
		document.searchDiForm.upperId.value = "b00100000000";
		document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
		document.searchDiForm.submit();
		
	}
	function kep_sel_h_getItmeList_v2(std_categ_id,categ_name){
		//alert(std_categ_id + " " +categ_name);
		/*
		var categ_code =  std_categ_id; 
		var buyer =  $("#h_byca_comorg_code").val(); 
		var byca_comorg_code =  $("#h_byca_comorg_code").val(); 
		
		$("#buyerCategItemListLocation_categ_code").val(categ_code); // 카테고리번호
		$("#buyerCategItemListLocation_byca_comorg_code").val(byca_comorg_code);  
		$("#quickCategoriArea").hide();
		
		 $('#buyerCategItemListLocation').attr("action", "/mdcm/getBuyerMdCmGoodsLisList.do").submit();    
		 */
		
		document.searchDiForm.st_description.value = "";	 
		document.searchDiForm.st_specification.value = "";	 
		document.searchDiForm.st_maker.value = "";	 
		document.searchDiForm.st_categoty_name.value = "";	 
		document.searchDiForm.searchMode.value = "";	 
		
		document.searchDiForm.onepagerow.value = "";
		document.searchDiForm.curPage.value = "1";
		document.searchDiForm.st_image_status.value = "";
		document.searchDiForm.groupCategoryText.value = "";
		document.searchDiForm.groupMakerName.value = "";
		document.searchDiForm.searchSort.value = "";
		document.searchDiForm.st_sort_change.value = "";	 
		document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = std_categ_id;	 
		document.searchDiForm.searchTarget.value = "CATEG_NAME";	 
		document.searchDiForm.searchTerm.value = categ_name;
		document.searchDiForm.upperId.value = "b00100000000";
		document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
		document.searchDiForm.submit();
		
	}
	function kep_sel_h_getItmeList_v3(std_categ_id,categ_name,categ_sys_code){
		//alert(std_categ_id + " " +categ_name);
		/*
		var categ_code =  std_categ_id; 
		var buyer =  $("#h_byca_comorg_code").val(); 
		var byca_comorg_code =  $("#h_byca_comorg_code").val(); 
		
		$("#buyerCategItemListLocation_categ_code").val(categ_code); // 카테고리번호
		$("#buyerCategItemListLocation_byca_comorg_code").val(byca_comorg_code);  
		$("#quickCategoriArea").hide();
		
		 $('#buyerCategItemListLocation').attr("action", "/mdcm/getBuyerMdCmGoodsLisList.do").submit();    
		 */
		
		document.searchDiForm.st_description.value = "";	 
		document.searchDiForm.st_specification.value = "";	 
		document.searchDiForm.st_maker.value = "";	 
		document.searchDiForm.st_categoty_name.value = "";	 
		document.searchDiForm.searchMode.value = "";	 
		
		document.searchDiForm.onepagerow.value = "";
		document.searchDiForm.curPage.value = "1";
		document.searchDiForm.st_image_status.value = "";
		document.searchDiForm.groupCategoryText.value = "";
		document.searchDiForm.groupMakerName.value = "";
		document.searchDiForm.searchSort.value = "";
		document.searchDiForm.st_sort_change.value = "";	 
		document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = categ_sys_code;	 
		document.searchDiForm.searchTarget.value = "CATEG_LIKE";	 
		document.searchDiForm.searchTerm.value = categ_name;
		document.searchDiForm.upperId.value = "b00100000000";
		document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
		document.searchDiForm.submit();
		
	}

	/*
	 * 카테고리 보인후 선택된 대상 출력
	 */
	function kep_h_topmenunnavi(depth,categ_name){
	    if (depth==1){		   
			$("#h_category_name1").val("");
		   	$("#h_category_name2").val("");
		   	$("#h_category_name3").val("");
		}else if (depth==2){
		   	$("#h_category_name1").val(categ_name);
		   	$("#h_category_name2").val("");
		   	$("#h_category_name3").val("");
	   }else    if (depth==3){ 
		   	$("#h_category_name2").val(" >"+categ_name);
		   	$("#h_category_name3").val("");
		   }else    if (depth==4){ 
		   	$("#h_category_name3").val(" >"+categ_name);
	   }
	   
	   $("#h_topmenunnavi").text("전체 >"+$("#h_category_name1").val() +  $("#h_category_name2").val() +  $("#h_category_name3").val());
	}

	// 고객사,분류 depth,카테고리아이디
	/*
	 * 카테고리 보인후 화면 출력
	 */
	function kep_h_getCategoriList(com_code,depth,std_categ_id) {  
		
			var strTmp = "<table width=style:100%>";
			var p_depth = eval(depth)+1; 
			
			if (depth == 1){
				$("#h_cateMenu2").html(h_nodata);
				$("#h_cateMenu3").html(h_nodata);
				$("#h_cateMenu4").html(h_nodata);
			}else if (depth == 2){ 
				$("#h_cateMenu3").html(h_nodata);
				$("#h_cateMenu4").html(h_nodata);
			}else if (depth == 3){  
				$("#h_cateMenu4").html(h_nodata);
			}
		 
		 
			$.ajax({
			      type: "POST",
			      dataType:"json",
			      url: "/mdcm/getCategoriList.do",
			      headers: { 'X-Requested-With': 'XMLHttpRequest' },
			      data: { param1: com_code,param2: depth,param3: std_categ_id},
			     async : false,
			     success:function( response ) {  		    	  
			    	 	 		    	  
		    	 	if (response.data.length > 0){
		 		    	  for (var i=0; i<response.data.length; i++){ 
		 		    		  
		 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
		 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
		 		    		var CATEG_NAME_REAL = $.trim(eval("response.data["+i+"].CATEG_NAME_REAL")); 
		 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
		 		    		var D_CATEG_SYS_CODE = $.trim(eval("response.data["+i+"].CATEG_SYS_CODE")); 
		 		    		var D_PID = $.trim(eval("response.data["+i+"].PID")); 
		 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
		 		    		   
		 		    		if ((i%4)==0){
		 		    			strTmp += "<tr>";
							}else{
								strTmp += "";
							}
		 		    		
		 		    		if (D_CNT == ""){
		 		    			strTmp += "<td style=width:180px><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_h_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+CATEG_NAME_REAL+"\')\">－ "+D_CATEG_NAME+" "+D_CNT+"</td>";	    	
		 		    		}else{
		 		    			strTmp += "<td style=width:180px><a href=\"javascript:kep_sel_h_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+CATEG_NAME_REAL+"\')\">－ "+D_CATEG_NAME+" "+D_CNT+"</td>";	 			 	
		 		    		}
		 		    		
		 		    		if ((i%6)==5){
		 		    			strTmp += "</tr>";
							}else{
								strTmp += "";
							}
		 		    		 
			 		      }	 		    //	class="selected"
		    		  }else{
		    			  strTmp = h_nodata;
		    		  }   	  
		    	 	
		    	 	strTmp += "</table>"
		    	 	//alert(strTmp);
						$("#h_cateMenu"+depth).html(strTmp);

				      },
				 error:function( response ) {  		    	   
			    	 alert("오류발생하였습니다.");
				      }
		    });  
	}

	/*
	 * 카테고리 선택된 대상 초기화
	 */
	function kep_h_categori_clear(){
			$("#h_cateMenu1").html(h_nodata);
			$("#h_cateMenu2").html(h_nodata);
			$("#h_cateMenu3").html(h_nodata);
			$("#h_cateMenu4").html(h_nodata);
	}
	
	
	/*
	 * 자동완성 검색엔진
	 */
	function kep_h_getBuyerMdCmGoodsDiAitoLisList(searchTerm) {  
		
		if (searchTerm == "") return;
	 
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getBuyerMdCmGoodsDiAitoLisList.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { searchTerm: searchTerm},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	   	var cateSb = $.trim(eval("response.cateSb"));  
	    	   	var cateSbA = $.trim(eval("response.cateSbA"));  
	    	   	var cateSbB = $.trim(eval("response.cateSbB"));  
	    	   	var cateSbC = $.trim(eval("response.cateSbC"));  
	    	   	var cateSbD = $.trim(eval("response.cateSbD"));  
	    	   	var cateSbE = $.trim(eval("response.cateSbE"));  
	 		    	   
	    	 
	    		  if ($("#autoDiSearchView").css("display") == "none"){
	    			  $("#autoDiSearchView").fadeIn(150);
	    		  }else{
	    		  }
	    		  
		    		  var cateSbAString = "<table style='width:100%'>";
		    		  var cateSbAarray=cateSbA.split("@@");
		    		  for (var i=0; i < cateSbAarray.length -1; i++) {
		    				cateSbAString = cateSbAString + "<tr><td style='width:100%' class='left'><a href=\"javascript:actionBuyerMdCmGoodsDiLisList3(\'"+"DESCRIPTION"+"\',\'"+cateSbAarray[i]+"\')\">"+cateSbAarray[i].substring(0,25)+"...</td></tr>";
					  }		    		   
		    		  cateSbAString = cateSbAString + "</table>";
		    		  
		    		  var cateSbCString = "<table style='width:100%'>";
		    		  var cateSbCarray=cateSbC.split("@@");
		    		  for (var i=0; i < cateSbCarray.length -1; i++) {
		    			  cateSbCString = cateSbCString +   "<tr><td style='width:100%' class='left'><a href=\"javascript:actionBuyerMdCmGoodsDiLisList3(\'"+"MAKER_NAME"+"\',\'"+cateSbCarray[i]+"\')\">"+cateSbCarray[i].substring(0,25)+"...</td></tr>"; 
					  }
		    		  cateSbCString = cateSbCString + "</table>";
		    		  
		    		  var cateSbDString = "<table style='width:100%'>";
		    		  var cateSbDarray=cateSbD.split("@@");
		    		  for (var i=0; i < cateSbDarray.length -1; i++) {
		    			  cateSbDString = cateSbDString +    "<tr><td style='width:100%' class='left'><a href=\"javascript:actionBuyerMdCmGoodsDiLisList3(\'"+"SPECIFICATION"+"\',\'"+cateSbDarray[i]+"\')\">"+cateSbDarray[i].substring(0,25)+"...</td></tr>"; 
					  }
		    		  cateSbDString = cateSbDString + "</table>";   
		    		  
		    		  var cateSbEString = "<table style='width:100%'>";
		    		  var cateSbEarray=cateSbE.split("@@");
		    		  for (var i=0; i < cateSbEarray.length -1; i++) {
		    			  cateSbEString = cateSbEString +   "<tr><td style='width:100%' class='left'><a href=\"javascript:actionBuyerMdCmGoodsDiLisList3(\'"+"AGENT"+"\',\'"+cateSbEarray[i]+"\')\">"+cateSbEarray[i].substring(0,25)+"...</td></tr>"; 
					  }
		    		  cateSbEString = cateSbEString + "</table>";     
		    		  
		    		  
		    		  $("#dicart1").html(cateSbAString);
		    		  $("#dicart2").html(cateSbCString);
		    		  $("#dicart3").html(cateSbDString);
		    		  $("#dicart4").html(cateSbEString);
		    		  
		    		  

			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
		    	 $("#autoDiSearchView").fadeOut(150);
			      }
	    });  
		
		
		
}
	
	function kep_h_getBuyerMdCmGoodsDiAitoLisList_v2(searchTerm) {
		
		if (searchTerm == ""){
			const searchBox = document.getElementById('searchBox');
	   		  searchBox.classList.add('expanded');
			  $("#dropdownArea").attr("style","display:block");
			  $("#autoDiSearchView").attr("style","display:none");
			  openCookieKeyword();
			return;
		}
			
	 
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getBuyerMdCmGoodsDiAitoLisList.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { searchTerm: searchTerm},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	   	var cateSb = $.trim(eval("response.cateSb"));  
	    	   	var cateSbA = $.trim(eval("response.cateSbA"));  
	    	   	var cateSbB = $.trim(eval("response.cateSbB"));  
	    	   	var cateSbC = $.trim(eval("response.cateSbC"));  
	    	   	var cateSbD = $.trim(eval("response.cateSbD"));  
	    	   	var cateSbE = $.trim(eval("response.cateSbE"));  
	 		    	   
	    	 
//	    		  if ($("#autoDiSearchView").css("display") == "none"){
	    			  //최근검색어 확장 제거
	    	   		  const searchBox = document.getElementById('searchBox');
	    	   		  searchBox.classList.add('expanded');
	    			  $("#dropdownArea").attr("style","display:none");
	    			  $("#autoDiSearchView").attr("style","display:block");
//	    		  }else{
//	    			  
//	    		  }
	    		      $('#autoDiSearchList *').remove();
		    		  var cateString = "";
		    		  var cateSbAarray=cateSbA.split("@@");
		    		  for (var i=0; i < cateSbAarray.length-1; i++) {
		    			  cateString = cateString + "<li><p class=\"Tit\">품목명</p><p class=\"Txt\"><a href=\"javascript:actionBuyerMdCmGoodsDiLisList3(\'"+"DESCRIPTION"+"\',\'"+cateSbAarray[i]+"\')\">"+cateSbAarray[i]+"</a></p></li>";
					  }
		    		  
		    		  var cateSbCarray=cateSbC.split("@@");
		    		  for (var i=0; i < cateSbCarray.length -1; i++) {
		    			  cateString = cateString +   "<li><p class=\"Tit\">제조사</p><p class=\"Txt\"><a href=\"javascript:actionBuyerMdCmGoodsDiLisList3(\'"+"MAKER_NAME"+"\',\'"+cateSbCarray[i]+"\')\">"+cateSbCarray[i]+"</a></p></li>"; 
					  }
		    		  
		    		  var cateSbDarray=cateSbD.split("@@");
		    		  for (var i=0; i < cateSbDarray.length -1; i++) {
		    			  cateString = cateString +    "<li><p class=\"Tit\">규격</p><p class=\"Txt\"><a href=\"javascript:actionBuyerMdCmGoodsDiLisList3(\'"+"SPECIFICATION"+"\',\'"+cateSbDarray[i]+"\')\">"+cateSbDarray[i]+"</a></p></li>"; 
					  }
		    		  $("#autoDiSearchList").append(cateString);
			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
		    	 $("#autoDiSearchView").attr("style","display:none");
			      }
	    });  
		
		
		
}
	
	function kep_h_getBuyerMdCmGoodsDiAitoHidden(){
		 $("#autoDiSearchView").fadeOut(150);
	}
	
	
	/*
	 * 고객사 카탈로그 종료 
	 * CEJ
	 */
	
	
    /**  화면의 조회조건을 셋팅
    **/
	function setSearchFormData(form){
		var els = eval("document.forms."+form+".elements");

		var size = els.length;
	    for(var idx=0;idx<size;idx++) {
	        var element = els[idx];
	        var elename = element.name;
	        var elevalue = element.value;
	        var type = element.type;
	        if(elename.indexOf("st_")>-1){
		        switch(type){
		         case 'hidden':
		         	eval($('#'+elename)).val("${st_spec}");
		         	break;
		         case 'text':
		         	eval($('#'+elename)).val(elevalue);
		         	break;
		         case 'select-one':
//		             alert(elename+":::"+elevalue +":::"+type );
		        	 eval('$("#'+elename+' > option[value='+elevalue+']")').attr("selected", "ture");
		         	break;
	        	 default:
	        		 alert('you should add new type!!');
		         	break;
		        }//end of switch
	        }//end of if
	    }
	}

	function initSearchCondition(form, id, elevalue, onloadvalue){
		if($("#"+id).val() == null || $("#"+id).val() == 'undefined') return;
		
		var element = eval("document.forms."+form+".elements."+id);
		
//		var element = eval($('#'+id)).name;
        
        var elename = element.name;
        var type = element.type;
//        alert(type);
        
        switch(type){
         case 'hidden':
	    	  if(elename == "curPage" && elevalue == ''){
	    		  element.value = 1;
	    	  }else{
	    		  element.value = elevalue;
	    	  }        	 
         	break;
         case 'text':
        	 if(elename.indexOf("_date")>-1){
        		 kepSetCalender(elename);
					if(elename.indexOf("_from")>-1){
						if(elename.indexOf("_m3")>-1){
							element.value = (elevalue =="" || elevalue == null)?kepToMonthAdd("3","M"): kepDateSlashAdd(elevalue);
						}else if(elename.indexOf("_m2")>-1){
							element.value = (elevalue =="" || elevalue == null)?kepToMonthAdd("2","M"): kepDateSlashAdd(elevalue);
						}else{
							element.value = (elevalue =="" || elevalue == null)?kepToMonthAdd("1","M"): kepDateSlashAdd(elevalue);	
						}
					}else if(elename.indexOf("_to")>-1){
						if(elename.indexOf("_p3")>-1){
							element.value = (elevalue =="" || elevalue == null)?kepToMonthAdd("3","P"): kepDateSlashAdd(elevalue);
						}else if(elename.indexOf("_p2")>-1){
							element.value = (elevalue =="" || elevalue == null)?kepToMonthAdd("2","P"): kepDateSlashAdd(elevalue);
						}else if(elename.indexOf("_p1")>-1){
							element.value = (elevalue =="" || elevalue == null)?kepToMonthAdd("1","P"): kepDateSlashAdd(elevalue);
						}else{
							element.value = (elevalue =="" || elevalue == null)?kepGetNowTimeStr('YYYYMMDD','/'): kepDateSlashAdd(elevalue);
						}						
					}else{
						element.value = (elevalue =="" || elevalue == null)?kepGetNowTimeStr('YYYYMMDD','/'): kepDateSlashAdd(elevalue);
					}
	    	  }else{
	    		  element.value = elevalue;
	    	  }
	    	  
//         	eval($('#'+elename)).val(elevalue);
         	break;
         case 'select-one':
        	 var len = element.length;
        	 var selFlag = false;
        	 var onloadFlag = false;
        	 var firstSel = "";
        	 for(var i=0; i<len; i++){
        		 var val = element.options[i].value;
        		 if(i==0) firstSel = val;
        		 if(val  == "ALL" || val == "SEL" )  selFlag = true;
        		 if(val  == onloadvalue )  onloadFlag = true;
        	 }
        	 if (elevalue=="" || elevalue=='undefined'){
 	 			if(kepTrimStr(onloadvalue) != '' && onloadFlag == true){
 	 				element.value = onloadvalue;
 	        	 }else{
 	 				element.value =  (selFlag == true)?"ALL":firstSel;	
 	        	 }
 			}else{
 				element.value =  elevalue;
 			}

//        	 eval('$("#'+elename+' > option[value='+elevalue+']")').attr("selected", "ture");
         	break;
         case "checkbox":
//     		var chk = eval("document.forms.searchForm."+id);
	   		 if(elevalue == ''){
				 element.checked = true;	 
			 }else{
	        	 if(elevalue =='on'){
	        		 element.checked = true;
	        	 }else{
	    	 		element.checked = false;
	        	 }
			 }
        	 break;
    	 default:
	       	 var len = (element != null)? element.length : 0;
	    	 if(len > 0){
	        	 for(var j=0; j<len; j++){
	            	 if(element[j] != null && element[j].type == "radio") {
	            		 element[j].checked = element[j].checked;
	            	 }	            	 
	        	 }
	    	 }
//    		 alert('you should add new type!!');
         	break;
        }//end of switch
	}
	
	function kepSelectboxSet(id, value){
		if(value == "" || value == 'undefined')
			$("#"+id).val("ALL");
		else
			$("#"+id).val(value);
	}	
	
	/* 항목에 한글이 포함되어 있는지 여부 체크 : 영문회사명등 체크시 사용 */
	function chkKorea(chkstr) {
		var j, lng = 0;

		for (j=0; j<chkstr.length; j++) {
			if (chkstr.charCodeAt(j) > 255) {
				++lng;
			}
			++lng;
		}
		return lng;
	}
	
	/* 항목에 공백이 포함되어 있는지 여부 체크 : 비밀번호 체크시 사용 */
	function checkSpace(val) {
		for (var i=0; i< val.length; i++) {
			if (val.charAt(i) == ' ') {
				return true;
			}
		}
		return false;
	}
	
	
	/**
	 * 필드값 유효성(Validation) 체크 
	 */
	$( document ).on( "keyup kepdown", "textarea", function( e ) { 
		 var str = $(this).val();
		   var mx = parseInt($(this).attr("maxlength"));  
		   if (str.length > mx) {
			  alert("입력가능 문자수를 초과하였습니다.[" +mx+ "이내]");
		      $(this).val(str.substr(0, mx));
		      return false;  
		    }  	
	});
	
	//엔터값을 변경.
	function FilterString_ent(val){ 
		var str= val; 
		str = str.replace(/\r\n/g, " ");
		str = str.replace(/\n/g, " ");
		str = str.replace(/\r/g, " ");  
		return str; 
	}
	
	
	
	 /*---------------------------------------------------
	 *
	 * 윤년 계산 및 입력날짜 Check
	 *
	 ----------------------------------------------------*/
	function checkDate(str) {
	  var yy,mm,dd,ny,nm,nd;
	  var arr_d;

	  if(str.length != 8) return false;

	  yy = str.substring(0,4);  // 년, 월, 일을 문자열로 가지고 있는다.
	  mm = str.substring(4,6);
	  dd = str.substring(6,8);

	  if(mm < '10') mm = mm.substring(1);           // patch 판
	  if(dd < '10') dd = dd.substring(1);           // patch 판

	  ny = parseInt(yy);      // 년, 월, 일을 정수형으로 가지고 있는다.
	  nm = parseInt(mm);
	  nd = parseInt(dd);

	  if(!(Number(yy)) || (ny < 1000) || (ny>9999)) return false;
	  if(!(Number(mm)) || (nm < 1) || (nm > 12)) return false;

	  arr_d = new Array('31','28','31','30','31','30','31','31','30','31','30','31');

	  //윤년계산
	  if(((ny % 4 == 0)&&(ny % 100 !=0)) || (ny % 400 == 0)) arr_d[1] = 29;
	  if(!(Number(dd)) || (nd < 1) || (nd > arr_d[nm-1])) return false;

	  return true;
	}

	// 로딩프로그래스바 사용으로 인해 사용 안함 ( 사용하지 말것 )
	function checkProcessDuplicate(ch_duplicate) { 
		if (ch_duplicate == "Y"){
			alert("작업중입니다. 작업완료후 시도해 주세요.");
			return false;
		}else{
			return true;
		}
	}

	/**
	* 입력값이 이메일 형식인지 체크
	* return
	* true : 이메일 형식
	* false :  
	*/
	function checkemail(id) {
		var invalidaddress=new Array();
//		invalidaddress[0]="daum";
//		invalidaddress[1]="kebi";
//		invalidaddress[2]="yahoo";
//		invalidaddress[3]="hanmail";

		var testresults;
		var invalidcheck = 0;
		var str= $.trim($("#" + id).val());
		if (str != "") {
//			var filter=/^(\w+(?:-\.\w+)*)@((?:\w+\.)*\w[\w]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
			var filter = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,3}$/;
			if (filter.test(str)) {
				var tempstring=str.split("@");
				tempstring=tempstring[1].split(".");

				for (var i=0; i < invalidaddress.length; i++) {
					if (tempstring[0] == invalidaddress[i]) {
						invalidcheck = 1;
					}
				}

				if (invalidcheck != 1) {
					testresults = true;
				} else {
//					alert("입력 금지된 계정입니다.\n\n금지된계정 : daum, kebi, yahoo, hanmail");
					alert("입력 금지된 계정입니다.");
					testresults = false;
				}
			} else {
				alert("이메일 형식에 맞지 않습니다.예)aaa@aaa.com");
				testresults = false;
				$("#" + id).val("");
				$("#" + id).focus();
			}
			return (testresults);
		}
	}
	
	/**
	* 입력값이 길이 체크
	* return : maxBytes로 넘긴 길이의 문자열
	*/
	function fnCheckInputByte(obj, maxBytes, m) {

		var objStr = obj.value;
		var objLen = objStr.length;
		var inByteLen = 0;
		var limitCharLen = 0;
		var c_cnt = (m && m=='k') ? 1 : 2;
		
		for (var i=0; i< objLen; i++) {
			inByteLen +=  (escape(objStr.charAt(i)).length > 4) ? c_cnt : 1;
			if (inByteLen <= maxBytes) {
				limitCharLen = i + 1;
			}
		}
		 
		if (inByteLen > maxBytes) {
			alert("영문 "+ maxBytes+"자, 한글 " + parseInt(maxBytes/2) + "자 까지 입력할수 있습니다.");
			obj.value = objStr.substr(0, limitCharLen-2);
		}
		obj.focus();
	}
	
	function fnCheckInputByteStr(objStr, maxBytes, m) {

		var objLen = objStr.length;
		var inByteLen = 0;
		var c_cnt = (m && m=='k') ? 1 : 2;
		
		for (var i=0; i< objLen; i++) {
			inByteLen +=  (escape(objStr.charAt(i)).length > 4) ? c_cnt : 1;
			if (inByteLen <= maxBytes) {
				limitCharLen = i + 1;
			}
		}

		if (inByteLen > maxBytes) {
			return false;
		}

		return true;
	}
	
	/**
	* 전화번호 / FAX 입력값 체크
	*/
	function fnPhoneNumberCheck(id) {
		
		if (!kepIsNumDash(id)) {
			alert("숫자와 - 만 입력할수 있습니다.");
			$("#"+id).val("");
		}
	}
	
	
	/**
	 * 시작일 종료일 검증
	 */
	function kep_dateSearchCheck(startdate,enddate){
		
		var s = startdate.replace(/[/]/gi,"");
		var e = enddate.replace(/[/]/gi,"");
		
		if (s > e) {
			alert("시작일이 종료일보다 전이어야 합니다. 확인 부탁드립니다.");
			return false;
		}
	}
	
	
	
	/**
	* 천자리 콤마 추가
	* return
	*/
	function addComma(num){

	  if(num<1000){

	   return num;

	  }

	    var len, point, str;  

	 

	    num = num + "";  

	    point = num.length % 3;

	    len = num.length;  

	 

	    str = num.substring(0, point);  

	    while (point < len) {  

	        if (str != "") str += ",";  

	        str += num.substring(point, point + 3);  

	        point += 3;  

	    }  

	    return str;  

	}	
	
	
	/**
	* 입력값 숫자인지 체크 후 콤마를 붙임
	* return
	*/
	function checkNumAddComma(obj){
		
		if(obj.value != null && obj.value !=''){	
			obj.value = obj.value.replace(/[^0-9]/g, '') ;
			obj.value =  addComma(obj.value);
		}
	}	
	
	/**
	 * 레이어팝업 view
	 * @param id : div ID
	 * @param gbn : show or ''
	 */
	function layerView(id, gbn){
		if(gbn == "show"){
			$("#"+id).show();
		} else {
			$("#"+id).hide();
		}
	}
	
	function buildOption(pOptions){	
		var _options  = pOptions.split(",");
		var _leftPosition = (screen.width) ? (screen.width - parseInt(_options[0])) / 2 : 0; 
		var _topPosition = (screen.height) ? (screen.height - parseInt(_options[1])) / 2 : 0;
		
		var _builtOption = "";
		
		if(_options.length >= 4){
			_builtOption = "resizable="+_options[3]+",";
		}
		_options[1] = parseInt(_options[1])+parseInt(30);
		_builtOption += "width="+_options[0]+ ", height="+ _options[1]+", top="+_topPosition+", left="+_leftPosition+", scrollbars="+_options[2]+" ,status=0, location=0, titlebar=0,menubar=0";
		
		return _builtOption;
	}
	
	function openSearchPopup(pPopupGubun,pSearch, pOptions){
		// 인자 1개로만 부르는 호출이 62곳 있다. JS 는 오버로딩이 없어 전부 여기로 들어오므로
		// 빠진 인자를 여기서 채운다. 안 채우면 encodeURI(undefined) 가 문자열 "undefined" 를
		// 만들어 URL 이 깨지고, buildOption(undefined) 는 TypeError 를 던진다.
		// "500,500,no" 는 같은 팝업들의 정상 호출이 실제로 쓰는 값이다.
		if (pSearch  === undefined) pSearch  = "";
		if (pOptions === undefined) pOptions = "500,500,no";

		pSearch = encodeURI(pSearch);
		var _option = buildOption(pOptions);
		var _url = pPopupGubun +""+pSearch;
		var _names = pPopupGubun.split("/");
		var _name = _names[_names.length -1].split(".")[0];
		var popup = window.open(_url,_name, _option );
   		popup.focus();
	}
	function openSearchPopupName(pPopupGubun,pSearch, pOptions, name){
		pSearch = encodeURI(pSearch);
		var _option = buildOption(pOptions);
		var _url = pPopupGubun +""+pSearch;
		var _names = pPopupGubun.split("/");
		var _name = name;
		var popup = window.open(_url,_name, _option );
   		popup.focus();
	}
	// 상품상세
	function getBuyerCatalogDisplayPop(BUYER,BUYER_ITEM_NO,CONTRACT_NO,CONTRACT_SEQ){ 
		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+BUYER+"&BUYER_ITEM_NO="+escape(BUYER_ITEM_NO)+"&CONTRACT_NO="+CONTRACT_NO+"&CONTRACT_SEQ="+CONTRACT_SEQ,"800,300,no");
	}	
	// 카테고리별항목보기
	function getBuyerCategoryPunchOutDisplayPop(com_code){ 
		openSearchPopup("/common/categoryPunchOutDetailPop.do","?st_com_code="+com_code,"430,350,no");
	}
	// 펀치아웃 품목구분
	function getBuyerSourcingItemGubunPop(com_code){ 
		openSearchPopup("/common/buyerSourcingItemGubunPop.do","?st_com_code="+com_code,"430,350,no");
	}
	// 펀치아웃 품목
	function getBuyerSourcingItemPop(com_code,inventory_gubun_flag){ 
		openSearchPopup("/common/buyerSourcingItemPop.do","?st_com_code="+com_code+"&inventory_gubun_flag="+inventory_gubun_flag,"430,500,no");
	}
	// 표준명검색
	function getBuyerSourcingStdDescPop(byca_comorg_code,text_gubun,s_cate_no){ 
		openSearchPopup("/common/buyerSourcingStdDescPop.do","?byca_comorg_code="+byca_comorg_code+"&st_text_gubun="+text_gubun+"&s_cate_no="+s_cate_no,"900,500,no");
	}
	// 카테고리명검색
	function getBuyerSourcingCtgNmPop(byca_comorg_code,text_gubun,s_cate_no){ 
		openSearchPopup("/common/buyerSourcingCtgNmPop.do","?byca_comorg_code="+byca_comorg_code+"&st_text_gubun="+text_gubun+"&s_cate_no="+s_cate_no,"900,500,no");
	}
	// 카테고리ID 검색
	function getBuyerSourcingCtgIdPop(com_code,inventory_gubun_flag){ 
		openSearchPopup("/common/buyerSourcingCtgIdPop.do","?st_com_code="+com_code+"&inventory_gubun_flag="+inventory_gubun_flag,"380,600,no");
	}
	//펀치아웃정비기술주문현황
	function getDeptPOInfo(com_code, buyer_item_no){
		//openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+com_code+"&BUYER_ITEM_NO="+buyer_item_no+"&CONTRACT_NO="+"sdfsdfs"+"&CONTRACT_SEQ="+"sdfsdf","800,300,no");
		openSearchPopup("/common/deptPOInfoPunchOutDetailPop.do","?st_com_code="+com_code+"&st_buyer_item_no="+buyer_item_no, "630,350,no");
	}
	//협력사 팝업
	function getAgentDisplayPop(com_code){
		openSearchPopup("/common/agentInfoDisplayPop.do","?st_com_code="+com_code,"800,550,no");
	}
	function getAgentDisplayPop_v2(com_code){
		openSearchPopup("/common/agentInfoDisplayPop.do","?st_com_code="+com_code,"800,650,no");
	}
	// 달력
	function kepCalendarOpenPopup(){
		openSearchPopup("/common/calendarPop.do","","230,245,no");
	}
	// 파일 업로드 팝업
	function kepFileUploadOpenPopup(img_key,type,viewType){
		 
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+img_key+'&TYPE='+type+'&viewType='+viewType , "500,430,no");  
	}
	
	//표준카탈로그 이미지 상세보기
	function getCmsImgPop(img_no, cms_catlg_id){
		if(img_no == "null"||img_no == null||img_no == ""||img_no == " "){
			alert("해당 이미지가 존재하지 않습니다.");
			return;
		}else{
			openSearchPopup("/mdcm/getMasterMdCmImageViewPop.do","?st_img_no="+img_no+"&st_cms_catlg_id="+cms_catlg_id,"770,575,no");
		}
	}

	function reportOpen(fileName,param){ 
		param = param.replace(/&/gi, "%26");	//파라메터 값에 & 가 포함되면 파라메터구분자로 인식하여 레포트 데이터가 나오지 않아 치환이 필요하다.
		//openSearchPopup("/coco/showReportViewer.do","?fileName=" + fileName + "&param=" + param,"800,850,no,yes"); 임시주석 변경전 현명환 2021.09.30
		var pSearch = encodeURI("?fileName=" + fileName + "&param=" + param);
		var _option = buildOption("800,850,no,yes");
		var _url = "/coco/showReportViewer.do" +""+pSearch;
		var popup = window.open(_url,"", _option );
   		popup.focus();
	}
	
	function reportOpenInvoker(fileName,param){ 
		param = param.replace(/&/gi, "%26");	//파라메터 값에 & 가 포함되면 파라메터구분자로 인식하여 레포트 데이터가 나오지 않아 치환이 필요하다.
		var pSearch = encodeURI("?fileName=" + fileName + "&param=" + param);
		var _option = buildOption("800,850,no,yes");
		var _url = "/coco/showReportHtmlViewerInvoker.do" +""+pSearch;
		var popup = window.open(_url,"", _option );
   		popup.focus();
	}
	
	
	function reportPostOpen(fileName,param){ // 사용 비추(jsp 내에 reportPostForm 별도 선언 필요하기 때문)
		  var pOptions = "800,850,no,yes";
	      var f = document.reportPostForm;
	    //http로 접속되도록 임시조치 한승준 2021.06.08
	      var url = "/coco/showReportViewer.do";
	      f.fileName.value = fileName;
	      param = param.replace(/&/gi, "%26");	//파라메터 값에 & 가 포함되면 파라메터구분자로 인식하여 레포트 데이터가 나오지 않아 치환이 필요하다.
	      f.param.value = param;
	      f.method = "post";
	      f.target = "POP";
	      f.action = url; 
  		 var _option = buildOption(pOptions);
  		 var popup = window.open("","POP", _option ); 
  		popup.focus();
	      f.submit();
	}
	
	function OpenReportPost(url, name, params) // 사용 권장 (동적 form, 동적 파라미터 생성)
	{
		var pOptions = "800,850,no,yes";
		var _option = buildOption(pOptions);
		var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("action", url);
		form.setAttribute("target", name);
		for (var i in params)
		{
			var input = document.createElement('input');
			input.type = 'hidden';
			input.name = params[i].key;
			input.value = params[i].value;
			form.appendChild(input);
		}
		document.body.appendChild(form);
		var popup = window.open("", name, _option);
		popup.focus();
		form.submit();
		document.body.removeChild(form);
	}
	
	//상품 큰이미지
	function getBigImageView(url, file_dir, file_name){		

	    if(file_dir == "" || file_name == "" ){
	        alert("등록된 이미지가 없습니다.");
	        return;
	    }
	    openSearchPopup("/common/showBigImageViewPop.do","?file_dir="+file_dir+"&file_name="+file_name,"400,430,no");
	}
	
	//상품 큰이미지
	function getBigImageReSizeView(url, file_dir, file_name){		

	    if(file_dir == "" || file_name == "" ){
	        alert("등록된 이미지가 없습니다.");
	        return;
	    }
	    openSearchPopup("/common/showBigImageViewPop.do","?file_dir="+file_dir+"&file_name="+file_name,"400,430,no,yes");
	}
	
	function openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no){
		// STX 조선해양
		if(buyer=="KRSTX-0001"&& buyer == tr_buyer) {
			if(legacy_iv_serial == ""){
				alert("고객사 시스템에 등록중입니다.\n생성 후 30분이 지났을 경우 KEP담당자에게 연락바랍니다.");
				return;
			}
			
			window.open("http://scmerp.stxons.com/pcm/scm/0403/pcmScm0403sd_rpt.do?type=sd04&bill_id="+legacy_iv_serial,"sheetWin2","width=700,height=700,resizable=YES,scrollbars=YES,top=50,left=50");
			window.open("http://scmerp.stxons.com/pcm/scm/0403/pcmScm0403sd_rpt.do?type=sd05&bill_id="+legacy_iv_serial,"sheetWin3","width=700,height=700,resizable=YES,scrollbars=YES,top=100,left=100");

		//STX 엔진3사 (KRSTX-0002,KRSTX-0003,KRSTX-0005,KRSTX-0006)
		} else if((buyer=="KRSTX-0002" ||buyer=="KRSTX-0003" ||buyer=="KRSTX-0005"  ||buyer=="KRSTX-0006" ||buyer=="KRSTX-0007")&& buyer == tr_buyer ) {
			if(legacy_iv_serial == ""){
				alert("고객사 시스템에 등록중입니다.\n생성 후 30분이 지났을 경우 KEP담당자에게 연락바랍니다.");
				return;
			}
			
			if(print_gbn == "0"){	// 발주서
				window.open("http://kor.enginem.com/servlet/kor.prc.comm.OZPrintServletSingle4MRO?count=2&xml_nm=PRC002M_newM&company_id=KEP&deliv_no="+legacy_iv_serial,"sheetWin1","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");				
			} else {	// 납품서
				window.open("http://kor.enginem.com/servlet/kor.prc.comm.OZPrintServletSingle4MRO?count=2&xml_nm=PRC003&company_id=KEP&deliv_no="+legacy_iv_serial,"sheetWin2","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
			}
			
			// 발주서 check
		   	//window.open("http://kor.enginem.com/servlet/kor.prc.comm.OZPrintServletSingle4MRO?count=2&xml_nm=PRC002M_newM&company_id=KEP&deliv_no="+legacy_iv_serial,"sheetWin1","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
		   	
			
			// OZ Viewer 가 같은 창에만 열려서 이를 해결하기 위해 팝업처리함.
			//window.open("/kr/agent/invoice/agent_invoice_print_sel_pop.jsp?st_buyer="+buyer+"&st_legacy_iv_serial="+legacy_iv_serial,"sheetWin","width=300,height=150,resizable=YES,scrollbars=YES,top=0,left=0").focus();
		// 코오롱 SAP
		} else if((buyer=="KRKOLO0097" || buyer=="KRKOLO0098" || buyer=="KRKOLO0099" || 
				   buyer=="KRKOLO0100" || buyer=="KRKOLO0101" || buyer=="KRKOLO0102" ||
				   buyer=="KRKOLO0103" || buyer=="KRKOLO0104" || buyer=="KRKOLO0105" ||
				   buyer=="KRKOLO0106" || buyer=="KRKOLO0107" || buyer=="KRKOLO0108" ||
				   buyer=="KRKOLO0109" || buyer=="KRKOLO0110" || buyer=="KRKOLO0111" ||
				   buyer=="KRKOLO0112" || buyer=="KRKOLO0113" || buyer=="KRKOLO0114" ||
				   buyer=="KRKOLO0115" || buyer=="KRKOLO0116" || buyer=="KRKOLO0117" ||
				   buyer=="KRKTPI0002"|| buyer=="KRKOLO0145")&& buyer == tr_buyer ) {
			if(legacy_iv_serial == ""){
				alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
			} else {
				openTranStatReportOpen(rpt_url, param);	
			}
		} else if((buyer=="KRDOOS0035")&& buyer == tr_buyer ) {
			return;
		} else if(buyer == "KRGS-C0003"){ // GS칼텍스 분할납품요청서(발주서) 같이 출력 2016.08.11 by HSJ
			window.open("http://supplier.gscaltex.co.kr/apprtoffice/KEP_FILE_M.do?PO_NO="+legacy_po_no,"sheetWin2","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
			openTranStatReportOpen(rpt_url, param);
		} else if(buyer=="KRKORE0212" && buyer == tr_buyer ) {
			if(legacy_iv_serial == ""){
				alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
			} else {
				openTranStatReportOpen(rpt_url, param);	
			}
		} else {
			openTranStatReportOpen(rpt_url, param);
		}
	}
	
	//여러개 RD 호출시 사용되는 함수
	/*rpt_url : RD 코드명
	 * param : 
	 * user_param :
	 * seq : RD를 여러번 호출시 순번
	 * 호출하는쪽에 openHttp() 생성되어있어야함.
	 */
	function openTranStatReportOpen(rpt_url, param, seq){
		
		var idx = rpt_url.indexOf("^");
		param = param.replace(/&/gi, "%26");	//파라메터 값에 & 가 포함되면 파라메터구분자로 인식하여 레포트 데이터가 나오지 않아 치환이 필요하다.
		if(idx > -1){
			var rpt_url_arr = rpt_url.split("^");
			
			for(var i = 0; i < rpt_url_arr.length; i++){
				//console.log("rpt_url_arr["+i+"] ==>> "+rpt_url_arr[i]);
				var num = i;
				if (seq != "") {
					num = num +"_" + seq;
				}
				if(rpt_url_arr[i].indexOf("http") > -1){
					
					openHttp(rpt_url_arr[i], ""+num);
					
					//var _option = buildOption("1015,700,no");
					
					//window.open(rpt_url+param1,"sheetWin"+i, _option );
				} else {
					//reportOpen(rpt_url,param);
					// https(상대경로) 로 연속 거래명세서 열리지 않아 http 로 강제 임시 적용 2021.06.03 HSJ
					var _url = "/coco/showReportViewer.do?fileName=" + rpt_url_arr[i] + "&param=" + param;
					var _name = rpt_url_arr[i];
					var _option = buildOption("800,850,no,yes");
					_url = encodeURI(_url);
					window.open(_url,""+num, _option );
				}
			}
		} else {
			if(rpt_url.indexOf("http") > -1){
				
				openHttp(rpt_url, "");
				
				//var _option = buildOption("1015,700,no");
				//var param1 = "?kepvndno="+com_code;
				//window.open(rpt_url+param1,"sheetWin", _option );
			} else {

				reportOpen(rpt_url,param);
			}
		}
	}
	function openHttp(rptUrl, winName){
		var param = "";
		
		if(rptUrl.indexOf("doowin") > -1){
			// http://doowin.doosaninfracore.com/keplogin.do
			var _option = buildOption("1024,760,no");
			
			var agent = $("#st_com_code").val();
			var agent_name = $("#st_com_name").val();
			var legacy_po_no = "<%=p_legacy_po_no%>";
			
			var legacy_po_seq = "00001";
	        var sap_user = "20493";
	        var sap_password = "20493";
	        
			param 	 = "?agent=" + agent;
			param	+= "&agent_name=" + agent_name;
			param	+= "&po_no=" + legacy_po_no;
			param	+= "&po_seq=" + legacy_po_seq;
			param	+= "&portal_user_id=" + sap_user;
			param	+= "&portal_password=" + sap_password;
			
			window.open(rptUrl+param, winName, _option );
			
		} else {
			// http://ez-van.doosaninfracore.co.kr/dhivan2/kep/index.asp
			var com_code = $("#st_com_code").val();
		
			var _option = buildOption("1015,700,no");
			param = "?kepvndno="+com_code;
			
			window.open(rptUrl+param, winName, _option );
		}
		
		self.close();
	}
	//이메일무단수집거부
	function poptype01(link) {
		openSearchPopup("/common/pop_email.do","", "400,260,no");
	}
	//개인정보취급방침
	function poptype02(link) {
		window.open("/common/pop_privacy.do","pop_privacy","width=1000, height=600, scrollbars =yes");
	}
	
	// faq팝업
	function faqpopup()
	{
		var left = 0;
		var top = 0;
		var width = 710;
		var height = 658;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		window.open('/resources/html/common/popup/pop_faq.html', 'newwindow', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function jspTableClean(TableID, colCnt) // JSP 테이블 전체 삭제
	{
//		alert(TableID+"::"+colCnt);
	  var tbody = document.getElementById(TableID).getElementsByTagName("tbody")[0];
	  var del_cnt = tbody.rows.length;
	  var colSize = (colCnt == null || colCnt == '' || colCnt == 'undefined' )? 0: colCnt;
	 for ( var i = 1; i <= del_cnt; i++ )
	 {  
	  tbody.deleteRow(0); // 테이블 삭제
	 }
	 this.addRow(TableID,colSize);
	 var paging = $("#paging");
	 if (paging != 'undefined' && paging != null){
		 paging.hide();
	 }
	 colSize = 0; // 테이블 관련 번호를 초기화
	}
	
	function addRow(TableID,colSize) // 테이블 빈행 생성
	{
	    var tbody = document.getElementById(TableID).getElementsByTagName("TBODY")[0];
	    var row   = document.createElement("TR");
	    var td1   = document.createElement("TD");
     	td1.setAttribute("colspan", (colSize == 0)? 15 : colSize );
     	td1.setAttribute("align", "center");
     	td1.setAttribute("height", "50");
        td1.insertAdjacentHTML('beforeEnd', "<span>조회된 데이타가 없습니다.</span>");
	    row.appendChild(td1);
	    tbody.appendChild(row);
	}
	//특수문자 필터링
	function FilterString(val){

	    var str= "";

	    // 특수문자 아스키코드 값
	    // $    ==> 36
	    // '    ==> 39
	    // "    ==> 34
	    // ^    ==> 94

	    for(i=0;i<val.length;i++) {

	    //  alert(val.charCodeAt(i));

	        if(val.charCodeAt(i) == 36) {

				str+=val.charAt(i).replace("$", "＄");

			}else if(val.charCodeAt(i) == 39) {

				str+=val.charAt(i).replace("'", "′");

			}else if(val.charCodeAt(i) == 34) {

				str+=val.charAt(i).replace("\"", "″");

			}else if(val.charCodeAt(i) == 94) {

				str+=val.charAt(i).replace("^", "＾");

			}else if(val.charCodeAt(i) == 60) {

				str+=val.charAt(i).replace("<", "〈");

			}else if(val.charCodeAt(i) == 62) {

				str+=val.charAt(i).replace(">", "〉");

			}else {

				str+=val.charAt(i);

			}
	    }

	    return str;

	}
	//쿠키저장
	function setKePCookie(name,value,expiredays) {
		var todayDate = new Date();
		todayDate.setDate(todayDate.getDate() + expiredays);
		document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
	}
	//쿠키 가져오기
	function getKePCookie(name) {
		var nameOfCookie = name + "=";
		var x = 0;
		while ( x <= document.cookie.length ) {
			var y = (x+nameOfCookie.length);
			if ( document.cookie.substring( x, y ) == nameOfCookie ) {
				if ( (endOfCookie=document.cookie.indexOf( ";",y )) == -1 )
					endOfCookie = document.cookie.length;
					return unescape( document.cookie.substring(y, endOfCookie ) );
			}
			x = document.cookie.indexOf( " ", x ) + 1;
			if ( x == 0 )
			break;
		}
		return "";
	}
	function reportTrOpen(fileName,param){
		param = param.replace(/&/gi, "%26");	//파라메터 값에 & 가 포함되면 파라메터구분자로 인식하여 레포트 데이터가 나오지 않아 치환이 필요하다.
		var pPopupGubun = "/coco/showReportViewer.do";
		var pSearch ="?fileName=" + fileName + "&param=" + param;
		var pOptions = "800,850,no,yes";
		
		pSearch = encodeURI(pSearch);
		var _option = buildOption(pOptions);
		var _url = pPopupGubun +""+pSearch;
		var _names = pPopupGubun.split("/");
		var _name = _names[_names.length -1].split(".")[0];
		var popup = window.open(_url,fileName, _option );
   		popup.focus();
	}
	/**
	 * 팝업 호출  (post 방식)
	 * pUrl  : 호출할 URL
	 * pData : 전달할 data
	 */	
	function openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option){
		var _option = buildOption(st_popup_option);
		window.open('',st_form_name, _option);

		//from 생성
		var form = document.createElement("form");
		form.setAttribute("id", st_form_name);
		form.setAttribute("method", "post");
		form.setAttribute("action", st_popup_url);
		form.setAttribute("target", st_form_name);
		var arr = ""; //pram 데이터
		var st_hidden_field = "";
		if(st_popup_param != null){
			arr = st_popup_param.split("^||^");	
		}
		var hiddenField = "";
		for(var i = 0 ; i < arr.length; ++i){
			var st_field = arr[i].split("@@");
			hiddenField = "";
			hiddenField = document.createElement("input");
			hiddenField.setAttribute("type", "hidden");
			hiddenField.setAttribute("name", st_field[0]);
			hiddenField.setAttribute("value",st_field[1]);
			form.appendChild(hiddenField);
		}
		document.body.appendChild(form);		
		form.submit();
		document.body.removeChild(form);
		
	}
	
	/**
	 * 오늘 날짜를 기준으로 당월 1일부터 말일까지 조회기간 설정
	 * @param from : 기간 시작일 폼 id 명
	 * @param to : 기간 종료일 폼 id 명
	 */
	function setCurMonth(from, to){
		var today = kepGetNowTimeStr("YYYYMM","/"); // 오늘의 년 월
		var last = new Date(today.substring(0,4),today.substring(5), 0).getDate(); // 당월의 말일
		$("#"+from).val(today + "/01");
		$("#"+to).val(today +"/"+ last);
	}
	
	// 마스킹 가운데부분, 2자리 이하는 맨 앞 * 표시, 9자리길이 초과는 앞 3자리 + *** + 뒷 3자리 리턴
	function kepMaskingName(value){
		if (value == null || value == "" || value == " "){
			return value;
		}else if (value.length < 2) {
			return value.replace(value.substring(0, 1), "*");
		}else if (value.length > 9){
			return (value.slice(0,3) + "*".repeat(3) + value.slice(value.length -3, value.length));
		}else{
			return (value[0] + "*".repeat(value.substring(1, value.length - 1).length) + value[value.length -1]);
		}
	}

	// 마스킹 전화번호
	function kepMaskingPhone(value){
		if(value == null || value == "" || value == " " || value.indexOf("-") < 0){
			return;
		}
		const values = value.split("-");
		
		values[1] = "*".repeat(values[1].length);
		
		return values.join("-");
	}
	
	// 마스킹 이메일
	function kepMaskingEmail(value){
		if(value == null || value == "" || value == " " || value.indexOf("@") < 0){
			return;
		}
		const mask = "*".repeat(value.split("@")[0].length - 1);
		
		return value[0] + mask + value.slice(mask.length + 1, value.length);
	}

	// 문자열(비고) 내 개인정보 마스킹
	function kepMaskingRemark(value){
		var return_value = "";
		var email_return_list = "";
		var email_return_item = "";
		const emailRegExp = /[0-9a-zA-Z-_\.]*@[0-9a-zA-Z-_\.]*\.[a-zA-Z]{2,3}/g;
		
		return_value = value.replace(/-([0-9]{3})-/g, "-***-");
		return_value = return_value.replace(/-([0-9]{4})-/g, "-****-");
		return_value = return_value.replace(/(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{3,4})/g, "0********");
		return_value = return_value.replace(/\+?82-?(1[016789]{1}|[2-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{3,4})/g, "+82********");

		email_return_list = value.match(emailRegExp);
		
		if(email_return_list != null){
			for(var i=0; i<email_return_list.length; i++){
				email_return_item = email_return_list[i].split("@");
				
				const mask = "*".repeat(email_return_item[0].length - 1);
				const email_return_item_first = email_return_item[0].substr(0,1);
				
				return_value = return_value.replaceAll(email_return_list[i], email_return_item_first + mask + '@' + email_return_item[1]);	
			}
		}
		
		return return_value;
	}
	
	/**
	 * 라디오버튼 쿼리기준으로 동적 생성
	 * viewId 화면의 radio button이 생성될 div id
	 * queryId
	 * radioName 라디오버튼의 name 값 
	 * dataValue 실제의db 결과 selected 를 위한 값 (디폴트 값)
	 */
	function kepAjaxCommonQueryIdRadio(viewId,queryId,radioName,dataValue,buyer) {  
		var str = "";
		$.ajax({
			type: "POST",
			dataType:"json",
			url: "/common/ajaxQueryIdCombo.do",
			headers: { 'X-Requested-With': 'XMLHttpRequest' },
			data: { QUERYID: queryId, BUYER:buyer },
			async : false,
			success:function( response ) {  		    	  
    	  
 		     	 str = radioDataResult(response,"CODE","TEXT1",dataValue, radioName);
	 		   	 $("#"+viewId).append(str);
			},
			error:function( response ) {  		    	   
				alert("오류발생하였습니다.");
			}
		});  
	}
	function kepAjaxCommonQueryIdRadioMedium_v2(viewId,queryId,radioName,dataValue,buyer) {  
		var str = "";
		$.ajax({
			type: "POST",
			dataType:"json",
			url: "/common/ajaxQueryIdCombo.do",
			headers: { 'X-Requested-With': 'XMLHttpRequest' },
			data: { QUERYID: queryId, BUYER:buyer },
			async : false,
			success:function( response ) {  		    	  
    	  
 		     	 str = radioDataResultMedium_v2(response,"CODE","TEXT1",dataValue, radioName);
	 		   	 $("#"+viewId).append(str);
			},
			error:function( response ) {  		    	   
				alert("오류발생하였습니다.");
			}
		});  
	}
	
	function radioDataResult(response,optionCode,optionValue,dataValue, radioName) {
		var str = "";
	 	if (response.data.length > 0){
	    	  for (var i=0; i<response.data.length; i++){ 
	    		 var code = $.trim(eval("response.data["+i+"]."+optionCode));
	    		 var value = $.trim(eval("response.data["+i+"]."+optionValue));
	    		 
	    		 if (code == dataValue){
	    			str = str + "<label><input type = 'radio' name = '"+radioName+"' value='"+code+"' checked='checked'> "+value+"</label>&nbsp;&nbsp;";
	    		 }else{
	    			str = str + "<label><input type = 'radio' name = '"+radioName+"' value='"+code+"'> "+value+"</label>&nbsp;&nbsp;";
	    		 }
	    		 
		      }	 		    	
		  }   
	 	return str;
	}
	
	function radioDataResultMedium_v2(response,optionCode,optionValue,dataValue, radioName) {
		var str = "";
	 	if (response.data.length > 0){
	    	  for (var i=0; i<response.data.length; i++){ 
	    		 var code = $.trim(eval("response.data["+i+"]."+optionCode));
	    		 var value = $.trim(eval("response.data["+i+"]."+optionValue));
	    		 
	    		 if(i == 0){
	    			 if (code == dataValue){
	 	    			str = str + "<label class='RadioMediumLabel' style=' margin-left:0px'><input type = 'radio' name = '"+radioName+"' value='"+code+"' checked='checked'><span class='RadioMediumTxt'></span> "+value+"</label>";
	 	    		 }else{
	 	    			str = str + "<label class='RadioMediumLabel' style=' margin-left:0px'><input type = 'radio' name = '"+radioName+"' value='"+code+"'><span class='RadioMediumTxt'></span> "+value+"</label>";
	 	    		 }
	    		 }else{
	    			 if (code == dataValue){
	 	    			str = str + "<label class='RadioMediumLabel'><input type = 'radio' name = '"+radioName+"' value='"+code+"' checked='checked'><span class='RadioMediumTxt'></span> "+value+"</label>";
	 	    		 }else{
	 	    			str = str + "<label class='RadioMediumLabel'><input type = 'radio' name = '"+radioName+"' value='"+code+"'><span class='RadioMediumTxt'></span> "+value+"</label>";
	 	    		 }
	    		 }
	    		 
	    		 
		      }	 		    	
		  }   
	 	return str;
	}
	
	/**
	 * 주어진 문자열에 공백 등이 들어있는지 확인하는 정규식
	 * @params str 문자열
	 * @return 파라미터에 문자열 이외의 값이 들어온다면 false 리턴
	 * @return boolean 공백이 들어있다면 TRUE 아니면 FALSE
	 */
	function containsWhitespace(str) {
		if(typeof str != 'string') return false;
		// \s는 공백 문자 (스페이스, 탭, 줄바꿈 등)를 의미
		return /\s/.test(str);
	}

/* ================================================================
 * KepPopupBroker — 팝업별 컨텍스트 격리
 *
 * 문제: 부모가 "지금 어느 팝업인지"를 전역변수 하나(popupSel 등)로만
 *       기억해서, 팝업을 여러 개 띄우면 나중 것이 앞의 것을 덮어쓴다.
 *       그 결과 팝업 A에서 값을 반환해도 팝업 B의 위치에 값이 들어간다.
 * 해결: 팝업을 열 때 그 시점의 전역값을 토큰에 스냅샷해 두고,
 *       그 팝업이 포커스를 잡는 순간 부모 전역값을 되돌려 놓는다.
 *
 * 이 파일은 부모 화면과 팝업 양쪽에서 모두 로드되므로 한 벌로 동작한다.
 * 화면 JSP(부모 585개 / 자식 527개)는 수정하지 않는다.
 *
 * ── 동작 순서 (배송지 팝업을 1행에서 여는 예) ──────────────────
 *  1) 부모가 openSearchPopup("/common/delLocationTwoTabPop_v2.do", ...) 호출
 *  2) [부모] 래퍼가 토큰 'kpt1' 발급 + 이때의 popupSel='location', gridIndex=1 을 저장
 *     → 팝업 URL 뒤에 &__kpt=kpt1 을 붙여서 연다
 *  3) 사용자가 다른 팝업을 열면 부모의 popupSel/gridIndex 는 그쪽 값으로 덮여쓰인다 (오염)
 *  4) [자식] 배송지 팝업 안에서 클릭이 일어나기 직전(mousedown),
 *     자기 URL의 kpt1 로 부모에게 "내 값으로 되돌려줘" 요청 → popupSel/gridIndex 복원
 *  5) 그 다음 팝업의 원래 코드가 opener.setPopupReturn(...) 을 호출
 *     → 부모는 복원된 값(location/1)으로 분기하므로 1행에 제대로 들어간다
 * ────────────────────────────────────────────────────────────────
 * ================================================================ */
(function () {
	'use strict';

	// 팝업 URL 에 붙는 파라미터 이름. 예) xxxPop.do?com_code=A&__kpt=kpt1_1784...
	var TOKEN_KEY = '__kpt';

	// 부모가 팝업 상태로 쓰는 전역변수 (popupSel/user_flag = 어느 팝업인지, gridIndex/popRow/rowIndex/grbRow = 몇 번째 행인지)
	var TRACKED = ['popupSel', 'gridIndex', 'popRow', 'rowIndex', 'grbRow', 'user_flag'];

	var MAX_SNAPSHOTS = 100;   // 오래 켜둔 화면에서 메모리가 계속 쌓이지 않도록 상한
	var seq = 0;               // 토큰 일련번호
	var order = [];            // 발급 순서 (상한 초과 시 오래된 것부터 버리기 위함)
	var snapshots = {};        // 토큰 -> 그 팝업을 열던 순간의 전역값
	var latest = null;         // 가장 마지막에 발급한 토큰 (= 가장 나중에 열린 팝업)

	// 지금 이 순간의 전역값을 복사해 둔다 (없는 변수는 건너뜀)
	function takeSnapshot() {
		var s = {};
		for (var i = 0; i < TRACKED.length; i++) {
			var k = TRACKED[i];
			if (typeof window[k] !== 'undefined') s[k] = window[k];
		}
		return s;
	}

	// 팝업 하나에 붙일 고유 토큰을 만들고, 지금 전역값을 그 토큰에 저장한다.
	// 팝업을 열 때마다 호출된다.
	function issue() {
		// 창마다 seq 가 따로 돌기 때문에 시각만으로는 서로 다른 창의 첫 토큰이 겹칠 수 있다.
		// 겹치면 자식이 남의 창 스냅샷을 적용하게 되므로 난수 한 조각을 더 붙인다.
		var token = 'kpt' + (++seq) + '_' + (+new Date()) + '_' + Math.random().toString(36).substring(2, 8);
		snapshots[token] = takeSnapshot();
		order.push(token);
		while (order.length > MAX_SNAPSHOTS) delete snapshots[order.shift()];
		latest = token;
		// 상당수 화면이 openSearchPopup(...) 을 부른 "다음 줄"에서 popupSel 을 세팅한다.
		// (예: masterMpSoProgressDownLoadList.jsp — open 후 popupSel="buyerMulti")
		// issue() 는 open 시점(= 아직 popupSel 세팅 전)에 돌아 옛 값을 담으므로, 그대로 두면
		// 자식 팝업이 옛 값으로 부모를 되돌려 setPopupReturn 이 빈 분기를 타 값이 안 들어온다.
		// 같은 실행 틱이 끝난 뒤(= popupSel 세팅까지 완료된 최종 상태) 스냅샷을 다시 뜬다.
		// popupSel 을 먼저 세팅하는 화면은 값이 같아 무해하다. 자식 창/iframe 로드는 이 타이머
		// 이후 틱에서 일어나므로 activate 전에 스냅샷이 항상 갱신된다.
		setTimeout(function () {
			if (snapshots[token]) snapshots[token] = takeSnapshot();
		}, 0);
		return token;
	}

	// 이 토큰이 "가장 나중에 열린 팝업" 인가.
	// 사용자가 조작하지 않은 팝업(로드 완료·자동 포커스)이 부모의 최신 상태를 덮어쓰지 않도록 하는 판단 기준.
	function isLatest(token) {
		return !!token && token === latest;
	}

	// 창이름 -> 토큰. 팝업이 자기 안에서 페이지를 이동하면(검색/조회 폼 전송) URL 의 토큰이
	// 사라지는데, window.name 은 이동해도 유지되므로 이걸로 자기 토큰을 되찾게 한다.
	var nameToToken = {};

	function register(name, token) {
		if (name) nameToToken[name] = token;
		return token;
	}

	function tokenForName(name) {
		return (name && nameToToken[name]) || null;
	}

	// openSearchPopup 원본과 동일한 규칙으로 창 이름을 만든다 (URL 마지막 경로에서 확장자 제거)
	function nameFromUrl(u) {
		var p = String(u || '').split('/');
		return p[p.length - 1].split('.')[0];
	}

	var lastChild = null;   // 가장 최근에 컨텍스트를 복원한 자식 팝업 (콘솔 로그에 이름 찍는 용도)

	// 저장해 둔 값을 부모 전역변수에 도로 넣는다. 자식 팝업이 호출한다.
	// childPath 는 "누가 불렀는지" 기록용 (없어도 복원은 정상 동작)
	function activate(token, childPath) {
		var s = snapshots[token];
		if (!s) return false;            // 토큰은 있는데 저장분이 없음 (부모 새로고침 등)
		for (var k in s) if (s.hasOwnProperty(k)) window[k] = s[k];
		if (childPath) lastChild = childPath;
		return true;
	}

	// pSearch("?a=1" 또는 "")에 토큰을 붙인다.
	// 최종 URL은 pBase + pSearch 로 조립되므로, '?' 유무는 반드시 둘을 합쳐서 판단해야 한다.
	// (예: openSearchPopup("/x.do?a=1", "", ...) 처럼 base 에만 쿼리가 있는 호출이 실제로 존재)
	function withToken(pBase, pSearch, token) {
		pSearch = pSearch || '';
		var combined = (pBase || '') + pSearch;
		if (combined.indexOf(TOKEN_KEY + '=') > -1) return pSearch;
		return pSearch + (combined.indexOf('?') > -1 ? '&' : '?') + TOKEN_KEY + '=' + token;
	}

	// 완성된 URL에 토큰을 붙인다 (해시 보존)
	function appendToken(url, token) {
		if (!url) return url;
		if (url.indexOf(TOKEN_KEY + '=') > -1) return url;
		var hash = '', h = url.indexOf('#');
		if (h > -1) { hash = url.substring(h); url = url.substring(0, h); }
		return url + (url.indexOf('?') > -1 ? '&' : '?') + TOKEN_KEY + '=' + token + hash;
	}

	window.KepPopupBroker = {
		TOKEN_KEY: TOKEN_KEY,
		issue: issue,
		isLatest: isLatest,
		activate: activate,
		register: register,
		tokenForName: tokenForName,
		withToken: withToken,
		appendToken: appendToken
	};

	/* ---------------- 부모측: 기존 오픈 헬퍼 래핑 ---------------- */
	/* 기존 함수를 붙잡아 두고(_원본) 같은 이름으로 새 함수를 씌운다.
	 * 화면에서 부르는 방식은 그대로이고, 안에서 URL에 토큰만 얹어 원본에 넘긴다.
	 * → 화면 JSP 를 한 개도 고치지 않고 전 화면에 적용되는 이유가 이것이다.   */

	var _openSearchPopup = window.openSearchPopup;
	if (typeof _openSearchPopup === 'function') {
		window.openSearchPopup = function (pPopupGubun, pSearch, pOptions) {
			// 인자 1개로 부르는 호출도 그대로 통과시킨다.
			// withToken 은 pSearch 가 없으면 "" 로 보고, 빠진 pOptions 는 원본이 채운다.
			var tok = register(nameFromUrl(pPopupGubun), issue());
			return _openSearchPopup.call(this, pPopupGubun, withToken(pPopupGubun, pSearch, tok), pOptions);
		};
	}

	var _openSearchPopupName = window.openSearchPopupName;
	if (typeof _openSearchPopupName === 'function') {
		window.openSearchPopupName = function (pPopupGubun, pSearch, pOptions, name) {
			var tok = register(name, issue());
			return _openSearchPopupName.call(this, pPopupGubun, withToken(pPopupGubun, pSearch, tok), pOptions, name);
		};
	}

	// 아래 둘은 POST 방식(form 전송)이라 URL 전체(action)에 토큰을 붙인다
	var _openSearchPopupPost = window.openSearchPopupPost;
	if (typeof _openSearchPopupPost === 'function') {
		window.openSearchPopupPost = function (url, formName, title, option) {
			// window.open('', title, ...) 로 열리므로 창 이름은 title 이다
			return _openSearchPopupPost.call(this, appendToken(url, register(title, issue())), formName, title, option);
		};
	}

	var _openSearchPopupAppendPost = window.openSearchPopupAppendPost;
	if (typeof _openSearchPopupAppendPost === 'function') {
		window.openSearchPopupAppendPost = function (formName, popupUrl, popupParam, popupOption) {
			// window.open('', st_form_name, ...) 로 열리므로 창 이름은 formName 이다
			return _openSearchPopupAppendPost.call(this, formName, appendToken(popupUrl, register(formName, issue())), popupParam, popupOption);
		};
	}

	/* ---------------- 자식측: 자기 컨텍스트로 되돌리기 ----------------
	 * 아래는 이 파일이 "팝업 안에서" 실행될 때만 동작하는 부분이다.        */

	// 내 주소창에서 __kpt 값을 꺼낸다. 없으면 브로커를 거치지 않고 열린 팝업.
	function readToken() {
		var m = new RegExp('[?&]' + TOKEN_KEY + '=([^&#]+)').exec(window.location.search);
		return m ? decodeURIComponent(m[1]) : null;
	}

	// IBSheet 우클릭 "컬럼 정보 저장" 은 저장 키로 location.href 전체(쿼리 포함)를 쓴다.
	// 팝업마다 __kpt 가 난수라 저장할 때 키와 다시 열 때 키가 달라져 컬럼정보가 복원되지 않는다.
	// 토큰을 한 번 읽어 보관한 뒤 주소창에서 __kpt 를 지워, 그리드가 만들어지기(onload) 전에 URL 을 깨끗이 한다.
	// (head 에서 동기 실행되므로 IBSheet 가 키를 읽기 전에 끝난다. 아래 sync 들은 보관해 둔 selfToken 을 쓴다.)
	var selfToken = readToken();
	(function () {
		try {
			if (!selfToken || !window.history || !history.replaceState) return;
			var ns = window.location.search.replace(new RegExp('[?&]' + TOKEN_KEY + '=[^&#]*'), '');
			if (ns.charAt(0) === '&') ns = '?' + ns.substring(1);
			history.replaceState(history.state, document.title,
				window.location.pathname + ns + window.location.hash);
		} catch (e) {}
	})();

	// 나를 띄운 부모 창을 찾는다. 두 가지 팝업 방식을 모두 지원한다.
	function getHost() {
		try {
			// (1) window.open 으로 뜬 별도 창 → opener 가 부모
			if (window.opener && window.opener !== window && !window.opener.closed) return window.opener;
		} catch (e) {}
		try {
			// (2) 레이어 팝업(iframe) → parent 가 부모
			if (window.parent && window.parent !== window) return window.parent;
		} catch (e) {}
		return null;
	}

	function initChild() {
		var host = getHost();
		if (!host || !host.KepPopupBroker) return; // 팝업이 아니거나 부모를 못 찾음 → 아무것도 안 함

		var token = selfToken || readToken();      // ① 위에서 보관한 토큰(주소창은 이미 정리됨) 우선
		if (!token && window.name) {
			// ② 이 팝업이 자기 안에서 페이지를 이동해 주소창 토큰을 잃은 경우.
			//    window.name 은 이동해도 유지되므로 부모에게 내 토큰을 되물어본다.
			try { token = host.KepPopupBroker.tokenForName(window.name); } catch (e) {}
		}
		if (!token) return;

		// 부모에게 "내 값으로 되돌려줘" 라고 요청하는 함수
		var sync = function () {
			try { host.KepPopupBroker.activate(token, location.pathname); } catch (e) {}
		};

		// 사용자가 아직 이 팝업을 만지지 않은 시점(로드 완료·자동 포커스)에는
		// "내가 가장 나중에 열린 팝업일 때"만 되돌린다.
		// 별도 창은 로드가 느려서, 그 사이 부모가 다른 행에서 레이어팝업을 여는 등
		// 더 최신 상태를 만들어 놓았는데도 예전 스냅샷으로 통째로 되돌려 버리는 일이 있었다.
		// (예: 5행 예산계정 팝업 → 3행 파일첨부 레이어팝업 → 예산계정 창 로드 완료 시 gridIndex 가 5 로 복귀)
		var syncIfLatest = function () {
			try {
				if (host.KepPopupBroker.isLatest && !host.KepPopupBroker.isLatest(token)) return;
			} catch (e) {}
			sync();
		};

		syncIfLatest();                                   // 팝업이 뜨는 즉시 한 번
		window.addEventListener('focus', syncIfLatest);   // 이 팝업으로 초점이 옮겨올 때마다
		// capture 단계: 팝업 안에서 클릭 핸들러가 돌기 "전"에 부모 컨텍스트를 복원한다.
		// setPopupReturn 을 부르는 확인 버튼/IBSheet OnClick 이 모두 이 뒤에 실행된다.
		// 클릭·키 입력은 사용자가 이 팝업을 실제로 쓰고 있다는 뜻이므로 조건 없이 복원한다.
		document.addEventListener('mousedown', sync, true);
		document.addEventListener('keydown', sync, true);
	}

	/* ---------------- 부모측: 반환 로그 ----------------
	 * 화면의 setPopupReturn 을 감싸 "어느 자식 팝업이 불렀는지" 콘솔에 한 줄 남긴다.
	 * 오류가 나면 팝업 이름과 함께 찍고 예외는 그대로 다시 던져 원래 스택을 보존한다.
	 *
	 * 주의: JS 로는 "나를 호출한 창"을 직접 알 수 없어서, 위 sync 로 가장 최근에
	 *       자기를 알린 팝업(lastChild)을 호출자로 본다. 확실하지 않으면 이름을
	 *       단정하지 않고 '(호출 팝업 미상)' 으로 찍는다.                       */
	function initParentLog() {
		var orig = window.setPopupReturn;
		// 화면에 setPopupReturn 이 없거나, 이미 한 번 씌웠으면 건너뛴다 (이중 래핑 방지)
		if (typeof orig !== 'function' || orig.__kepWrapped) return;

		var wrapped = function () {
			var who = lastChild || '(호출 팝업 미상)';
			console.log('[KepPopup] ' + who + ' → setPopupReturn',
			            Array.prototype.slice.call(arguments));
			try {
				// 화면의 원본을 그대로 실행 (인자·this·반환값 모두 통과시킨다)
				return orig.apply(this, arguments);
			} catch (e) {
				console.error('[KepPopup] setPopupReturn 오류 — 호출 팝업: ' + who, e);
				throw e;   // 원래 스택을 그대로 보존
			}
		};
		wrapped.__kepWrapped = true;
		window.setPopupReturn = wrapped;
	}

	// 한 페이지가 부모이면서 동시에 팝업일 수도 있으므로 둘 다 실행한다.
	// (각 함수가 해당 없으면 스스로 빠져나간다)
	function initAll() { initChild(); initParentLog(); }

	// 화면의 function setPopupReturn(){} 선언이 끝난 뒤에 감싸야 하므로 DOM 완료 시점에 실행
	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', initAll);
	} else {
		initAll();
	}
})();


	/**
	* 품목코드 입력값을 저장 가능한 형태로 다듬는다.
	* 공백(스페이스·탭·줄바꿈) 전부 제거 + 영문 대문자화.
	* 
	* return 다듬어진 문자열 (null·undefined 는 빈 문자열)
	*/
	function kepNormalizeItemCode(str) {
		if (str == null) return "";
		return String(str).replace(/\s/g, "").toUpperCase();
	}

	/**
	* 문자열에 한글이 섞여 있는지 검사한다.
	* 한글은 유니코드 상에서 한 구간이 아니라 여러 구간에 펼쳐져 있어서,
	* /[가-힣]/ 하나로만 보면 자모 한 글자(ㄱ, ㅏ)가 그대로 통과한다. 그래서 3개 구간을 본다.
	*
	*   \uAC00-\uD7FF : 한글 음절. 가(AC00) ~ 힣(D7A3). /[가-힣]/ 가 가리키는 그 구간이다.
	*                   뒷부분(D7B0~)은 옛한글 자모라 거기까지 같이 포함했다.
	*                   ex) "UV램프", "자외선소독등" 처럼 평범하게 완성된 글자
	*   \u3130-\u318F : 한글 호환 자모. ㄱ~ㅎ, ㅏ~ㅣ 처럼 자모 한 글자만 입력한 경우.
	*                   ㄱ 은 음절 구간에 없으므로 이 구간이 없으면 놓친다.
	*                   ex) "AP-ㄱ", "ㅋㅋ", "ㅏ" — 오타나 초성만 친 값이 여기 걸린다.
	*   \u1100-\u11FF : 한글 자모(조합용 초성·중성·종성).
	*                   IME 로 아직 조합 중인 미완성 글자, Mac 에서 복사해 오는 분해형 문자열이 여기로 온다.
	*                   ex) 화면에는 "한" 으로 보이지만 실제로는 ㅎ+ㅏ+ㄴ 세 글자로 저장된 값.
	*                       Mac 에서 파일명·엑셀을 복사해 붙여넣으면 이 형태로 들어온다.
	*
	* return
	* true : 한글이 하나라도 섞여 있다
	* false : 없다
	*/
	function kepHasHangul(str) {
		if (str == null) return false;
		return /[\u1100-\u11FF\u3130-\u318F\uAC00-\uD7FF]/.test(String(str));
	}

	function kepFormatDate(date, flag) {
		var mm = date.getMonth() + 1;
		var dd = date.getDate();
		return date.getFullYear() + flag + (mm < 10 ? "0" : "") + mm + flag + (dd < 10 ? "0" : "") + dd;
	}

	function kepFormatValue(d, f, type) {
		var v = kepTrimStr(d[f]);
		switch (type) {
			case "date":
				return (v.length == 8) ? kepGetDateStr(v, "/") : v;
			case "num":
				if (v == "" || isNaN(v)) return v;
				return kepCommaNum(v);
			case "hm":
				return (v.length >= 4) ? v.substring(0, 2) + ":" + v.substring(2, 4) : v;
			case "yn":
			case "chk":
				return (v == "1" || v == "Y") ? "Y" : (v == "" ? "" : "N");
		}
		return v;
	}

	function kepSelectByText($sel, txt) {
		$sel.val("");
		if (txt == "") return;
		$sel.find("option").each(function() {
			if ($(this).text() == txt || $(this).text().indexOf(txt) == 0) {
				$sel.val($(this).val() || $(this).text());
				return false;
			}
		});
	}

	function kepOpenUrl(u) {
		if (kepTrimStr(u) == "") return;
		window.open(/^https?:\/\//i.test(u) ? u : "http://" + u, "_blank");
	}

	// 대량입력 팝업이 돌려준 '@' 구분 문자열 정리 : 공백행·중복 제거 + 대문자화.
	// 팝업은 빈 행까지 '@'로 이어붙이므로 그대로 쓰면 IN 절에 빈 값이 섞인다.
	// kepMultiName("A@B@","@") 이 "A 외 1건"으로 세도록 끝에 구분자를 남긴다.
	function kepCleanMultiCode(str) {
		if (str == null) return "";
		var arr = String(str).split("@");
		var out = [];
		for (var i = 0; i < arr.length; i++) {
			var v = $.trim(arr[i]).toUpperCase();
			if (v != "" && $.inArray(v, out) < 0) out.push(v);
		}
		return (out.length > 0) ? out.join("@") + "@" : "";
	}

	function kepSheetCheckedRows(sheet, saveName) {
		var chk = sheet.FindCheckedRow(saveName);
		var rows = [];
		if (chk == "") return rows;
		var arr = chk.split("|");
		for (var i = 0; i < arr.length; i++) rows.push(parseInt(arr[i], 10));
		rows.sort(function(a, b) { return a - b; });
		return rows;
	}

	function kepCheckedIdx(id) {
		var idx = [];
		$("#" + id + " td input[type=checkbox]:checked").each(function() { idx.push(parseInt($(this).attr("data-idx"), 10)); });
		return idx;
	}

	function kepNotYet() {
		alert("준비중입니다.");
	}

	/* 금액 문자열 → 숫자. 콤마·공백·원표시를 걷어낸다. 숫자가 아니면 NaN 을 돌려준다.
	 * 엑셀에서 온 값은 "6,110" 처럼 서식이 붙어 오기도 하고 6110 처럼 숫자로 오기도 한다. */
	function kepParseNum(v) {
		if (v == null) { return NaN; }
		var s = ("" + v).replace(/[,\s₩원]/g, "");
		if (s == "") { return NaN; }
		if (!/^-?\d+(\.\d+)?$/.test(s)) { return NaN; }
		return parseFloat(s);
	}

	// 금액 표시용 천단위 콤마. 값이 숫자가 아니면 원문 그대로 둔다(오류 행을 눈으로 보게).
	function kepNumToComma(v) {
		var n = kepParseNum(v);
		if (isNaN(n)) { return (v == null) ? "" : ("" + v); }
		return kepCommaNum(n);
	}

	/* YYYYMMDD 인가. 엑셀이 날짜셀을 "2026-01-02" 로 내려보내는 경우가 있어 구분자는 걷어내고 본다.
	 * 실제 달력 날짜인지까지 본다 — 20260231 은 통과시키지 않는다. */
	function kepToDate8(v) {
		var s = ("" + (v == null ? "" : v)).replace(/[-\/\.\s]/g, "");
		if (!/^\d{8}$/.test(s)) { return ""; }
		var y = parseInt(s.substring(0, 4), 10);
		var m = parseInt(s.substring(4, 6), 10);
		var d = parseInt(s.substring(6, 8), 10);
		if (m < 1 || m > 12 || d < 1) { return ""; }
		var dt = new Date(y, m - 1, d);
		if (dt.getFullYear() != y || (dt.getMonth() + 1) != m || dt.getDate() != d) { return ""; }
		return s;
	}

	/* 변동률(%) = (변경 - 기존) / 기존 × 100.
	 * 절삭단위 : 소수점 한자리, 반올림. 표기는 + 대신 '↑', - 대신 '↓'
	 * 기존이 없거나 0이면 나눌 수 없다 → 빈 문자열.
	 * 반환 {rate:숫자|null, text:"↑6.3%"|"", up:true|false|null} */
	function kepRateChange(before, after) {
		var b = kepParseNum(before);
		var a = kepParseNum(after);
		if (isNaN(b) || isNaN(a) || b == 0) { return {rate:null, text:"", up:null}; }

		var rate = Math.round(((a - b) / b) * 1000) / 10;
		if (rate == 0) { return {rate:0, text:"", up:null}; }

		var up = (rate > 0);
		return {rate:rate, text:(up ? "↑" : "↓") + Math.abs(rate).toFixed(1) + "%", up:up};
	}

	/* 엑셀에 담을 컬럼 — 화면에 그려진 것만.
	 * 숨김컬럼과 체크박스(SELECTED), 아이콘 버튼(Type=Image)은 값이 아니라서 뺀다. */
	function kepSheetExcelDownCols(sheet) {
		var cols = "";
		for (var c = 0; c <= sheet.LastCol(); c++) {
			if (sheet.GetColHidden(c)) { continue; }
			if (sheet.ColSaveName(c) == "SELECTED") { continue; }
			if (sheet.GetCellProperty(1, c, "Type") == "Image") { continue; }
			cols += "|" + c;
		}
		return cols;
	}

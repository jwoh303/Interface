
var g_errorFlag = "";
var endFlag = "";     //종료여부.
//var smUrl = "http://demoapi.smartbill.co.kr/sb-api/request/";
//var smUrl = "https://api.smartbill.co.kr/sb-api/request/";
//전송양식 생성
//정보, 공급자사업자번호, 공급받는자사업자번호, ar_no, 토근, 상태, 세금계산서정상/취소구분/수정세금계산서(S/R/M) ,정발행역발행구분(A/B), 과세면세영세구분
/*gbn 상태
 * gbn2 세금계산서 정상/수정세금계산서(S/M)
 * gbn3 정발행역발행구분(A/B)
 * gbn4 취소사유
 * gbn5 과세영세면세구분
 */
function getSendFormat(paramInfo,send_irs_no,recv_irs_no,ar_no,authtoken,gbn,gbn2,gbn3,gbn4,gbn5,totalRow,toRow,reason,detailArIssue, issueSendYn,arrConvId,issue_ar_no, system_id){

	var rtnData = "";
	var certPassword = "";
	var con_id = "";
	var requestTime = "";
	g_snmGbn= gbn4;
	var user_id = $("#st_user_id").val();
	var trow = totalRow;
	var row = toRow;
	var smarbillUrl = "";
	var gbn_issueYn = "";
	if(issueSendYn == ""){
		issueSendYn = "N";
	}
	gbn_issueYn = gbn3+"@@"+issueSendYn;
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/cmcl/SendARMasterCmClSalesTaxsheetIssueFormat.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: paramInfo, param2:user_id, param3:gbn, param4:gbn2, param5:gbn_issueYn},
	     async : false,
	     success:function( response ) {  		    	
	    	if(response.data == null){
  				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(1)");
					 doAction('search');	
				}    return;
	    	}
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		rtnData = $.trim(eval("response.data["+i+"].SEND_FORMAT"));
 		    		certPassword = $.trim(eval("response.data["+i+"].SERT_PASSWORD"));
 		    		con_id = $.trim(eval("response.data["+i+"].CON_ID"));
 		    		requestTime = $.trim(eval("response.data["+i+"].REQUEST_TIME"));
 		    		smarbillUrl = $.trim(eval("response.data["+i+"].SMARTBILL_URL"));
 		    		//취소시 O 국세청 전송전
 		    		if(issueSendYn =="Y"){//국세청전송
 		    			sendIssueInfo(issue_ar_no,requestTime,send_irs_no,authtoken,arrConvId,smarbillUrl,system_id);
 		    		}else{
 	 		    		if(gbn == "O"){
 	 		    			sendRSmartBill(ar_no,rtnData,send_irs_no,recv_irs_no,certPassword,con_id,requestTime,authtoken,gbn3,gbn4,gbn5,trow,row,reason,smarbillUrl,system_id);
 	 		    		}else{
 	 		    			sendSmartBill(ar_no,rtnData,send_irs_no,recv_irs_no,certPassword,con_id,requestTime,authtoken,gbn,trow,row,detailArIssue,smarbillUrl,system_id);
 	 		    		}
 		    		}

	 		      }	 		    
    		  }
		   },
		 error:function( response ) {
				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(2)");
					 doAction('search');	
				}
	    	 return;
		   }
    });  
}

var g_con_id = "";//참조ID
//국세청전송
function sendIssueInfo(issue_ar_no,requestTime,send_irs_no,authtoken,arrConvId,smarbillUrl,system_id){
	var request = JSON.stringify({ 
		'MessageId': issue_ar_no
		, 'Signal': 'NTS_REQUEST'
		, 'RequestTime': requestTime
		, 'SendComRegno': send_irs_no
		, 'AuthToken': authtoken
		, 'ServiceCode': 'DTI'
		, 'SystemType': 'OAPI'
		, 'ConversationId': arrConvId });	
 
	$.support.cors = true; 
	$.ajax({ 
		type: "POST"
		, dataType: "json"
		, crossDomain: true
		, contentType: "application/json"
		, url: smarbillUrl
		, data: request
		, success: function (data) { 
			if ("30000" != data.ResultCode) {
				alert(data.ResultMessage);
				return;
			}else{
				alert("국세청 전송 처리되었습니다.");
				doAction('search');	
				return;
			}
		}, error: function (error) { //error 처리 
			alert("국세청 전송 처리 실패했습니다.");
			doAction('search');	
			return;
		}
	});

}
//스마트빌 전송
function sendSmartBill(ar_no, xml_info, send_irs_no, recv_irs_no, cert_password,con_id,requestTime,authtoken,gbn,trow,row,detailArIssue,smarbillUrl,system_id){
	//세금계산서 1건와 1:1로 매핑되는 스마트빌 시스템 고유의 식별자(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
	var arrConId = new  Array();
	arrConId[0] = con_id;
	g_con_id = con_id;
	var st_signal   = "";
	if(gbn == "V"){
		st_signal = "RARREQUEST";//역발행
	}else{
		if(detailArIssue =="1"){
			st_signal ="DETAILARISSUE";//거래명세서+계산서			
		}else{
			st_signal ="ARISSUE";//정상
		}
	}
	var request ="";
	if(system_id=="BQMS"||system_id=="CBMS"){
		request = JSON.stringify({
		'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
		'Signal' : st_signal ,  // 트랜잭션 식별자 고정
		'RequestTime': requestTime, // //yyyymmddhh24miss
		'SendComRegno': send_irs_no , //공급자 사업번호
		'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
		'AuthToken': authtoken ,  //인증토큰
		'ServiceCode': 'DTI' ,  //서비스코드 고정
		'SystemType': 'OAPI' ,  //시스템타입
		'ConversationId': arrConId ,  //참조번호
		'SMTPEmail': '' ,  //시스템타입
		'RValue': '', //신원확인값 공백
		'SystemId': system_id,
		'CertPassword': cert_password ,
		'SignedXML': xml_info,
		'UnSignedXML': xml_info
		});
	}else{
		request = JSON.stringify({
			'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
			'Signal' : st_signal ,  // 트랜잭션 식별자 고정
			'RequestTime': requestTime, // //yyyymmddhh24miss
			'SendComRegno': send_irs_no , //공급자 사업번호
			'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
			'AuthToken': authtoken ,  //인증토큰
			'ServiceCode': 'DTI' ,  //서비스코드 고정
			'SystemType': 'OAPI' ,  //시스템타입
			'ConversationId': arrConId ,  //참조번호
			'SMTPEmail': '' ,  //시스템타입
			'RValue': '', //신원확인값 공백
			'CertPassword': cert_password ,
			'SignedXML': xml_info,
			'UnSignedXML': xml_info
			});		
	}
	$.support.cors = true;
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      contentType: "application/json",
	      url: smarbillUrl,
	      data: request,
	     success:function( data ) {
	    	 sendSuccessSB(data,con_id,"R",trow,row); 	
	   },
		 error:function( response ) {
				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(3)");
					 doAction('search');	
				}
			 return;
	   }
  }); 
	
}
//스마트빌 취소
function sendRSmartBill(ar_no, xml_info, send_irs_no, recv_irs_no, cert_password,con_id,requestTime,authtoken,gbn3,gbn4,gbn5,trow,row,reason,smarbillUrl,system_id){
	//세금계산서 1건와 1:1로 매핑되는 스마트빌 시스템 고유의 식별자(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
	var arrConId = new  Array();
	var st_signal = "";
	var st_status_signal = "";
	//A정발행 B역발행
	if(gbn3 == "A"){
		st_signal = "CHGSTATUS";
		st_status_signal = "CANCELALL";
	}else{
		st_signal = "CHGSTATUS";
		st_status_signal = "CANCELRREQUEST";		
	}
	arrConId[0] = con_id;
	g_con_id = con_id;
	var request ="";
	//시스템 ID가 BQMS, CBMSD일때
	if(system_id=="BQMS"||system_id=="CBMS"){
		request = JSON.stringify({
		'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
		'Signal' : st_signal, // 트랜잭션 식별자 고정
		'RequestTime': requestTime, // //yyyymmddhh24miss
		'SendComRegno': send_irs_no , //공급자 사업번호
		'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
		'AuthToken': authtoken ,  //인증토큰
		'ServiceCode': 'DTI' ,  //서비스코드 고정
		'SystemType': 'OAPI' ,  //시스템타입
		'ConversationId': arrConId ,  //참조번호
		'SMTPEmail': 'OAPI' ,  //시스템타입
		'RValue': '', //신원확인값 공백
		'CertPassword': cert_password ,
		'StatusSignal': st_status_signal,
		'SystemId': system_id,
		'StatusReason': gbn4,
		'SignedXML': xml_info
		});
	}else{
		request = JSON.stringify({
			'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
			'Signal' : st_signal, // 트랜잭션 식별자 고정
			'RequestTime': requestTime, // //yyyymmddhh24miss
			'SendComRegno': send_irs_no , //공급자 사업번호
			'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
			'AuthToken': authtoken ,  //인증토큰
			'ServiceCode': 'DTI' ,  //서비스코드 고정
			'SystemType': 'OAPI' ,  //시스템타입
			'ConversationId': arrConId ,  //참조번호
			'SMTPEmail': 'OAPI' ,  //시스템타입
			'RValue': '', //신원확인값 공백
			'CertPassword': cert_password ,
			'StatusSignal': st_status_signal,
			'StatusReason': gbn4,
			'SignedXML': xml_info
			});		
	}
	$.support.cors = true;
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      contentType: "application/json",
	      url: smarbillUrl,
	      data: request,
	     success:function( data ) {
	    		if("30000" != data.ResultCode){
	    			errorSendSmartBill(data.ResultCode,data.ResultMessage,con_id,trow,row);
	    		}else{
	    			cancleSuccessSmartBill(con_id,reason,trow,row);
	    		}
	   },
		 error:function( response ) {
				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(4)");
					 doAction('search');	
				}
			 return;
	   }
  }); 
}
//스마트빌 전송.
function sendSuccessSB(data, con_id,gbn,trow,row){  
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/cmcl/sendSuccessSmartbill.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: con_id},
	     async : false,
	     success:function( response ) {
	    	 getSmartbillData(data,"R",con_id,trow,row);   	 
		   },
		 error:function( response ) {  	
				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(5)");
					 doAction('search');	
				}
	    	 return;
		   }
    });  
}
//스마트빌 전송결과
function getSmartbillData(data,gbn,con_id,trow,row){
	if("30000" != data.ResultCode){
		errorSendSmartBill(data.ResultCode,data.ResultMessage,con_id,trow,row);
	}else{
		if(trow==row){
			if(g_errorFlag == "Y"){
				loader_obj("N");
				 alert("전송 에러가 발생했습니다.(6)");
				 doAction('search');	
			}else{
				loader_obj("N");
				 alert("전송 처리되었습니다.");
				 doAction('search');				
			}
		}
	}
}

//스마트빌 오류처리
function errorSendSmartBill(st_error_code,st_error_msg,con_id,trow,row){
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/cmcl/errorSendSmartBill.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: con_id, param2: st_error_code, param3: st_error_msg},
	     async : false,
	     success:function( response ) {
  			if(trow==row){
  				loader_obj("N");
				 alert("전송 에러가 발생했습니다.(8)");
				 doAction('search');
  			}
	    	 return;  
		   },
		 error:function( response ) {  	
	  			if(trow==row){
	  				loader_obj("N");
					 alert("전송 에러가 발생했습니다.(9)");
					 doAction('search');
	  			}
	    	 return;
		   }
  });  
	
}
//취소성공처리
function cancleSuccessSmartBill(con_id,reason,trow,row){
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/cmcl/cancleSuccessSmartBill.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: con_id, param2: reason},
	     async : false,
	     success:function( response ) {
			if(trow==row){
				loader_obj("N");
				 alert("취소처리 되었습니다.");
				 doAction('search');
			}
	    	 return;  
		   },
		 error:function( response ) {  	
	  			if(trow==row){
	  				loader_obj("N");
					 alert("전송 에러가 발생했습니다.(10)");
					 doAction('search');
	  			}
	    	 return;
		   }
	      });  

	
}

//전송양식 생성
//정보, 공급자사업자번호, 공급받는자사업자번호, ar_no, 토근, 상태, 세금계산서정상/취소구분/수정세금계산서(S/R/M) ,정발행역발행구분(A/B), 과세면세영세구분
/*gbn 상태
* gbn2 세금계산서 정상/수정세금계산서(S/M)
* gbn3 정발행역발행구분(A/B)
* gbn4 취소사유
* gbn5 과세영세면세구분
*/
//스마트빌 역발행 전송(승인)
function getSendFormatForRaIssue(paramInfo,send_irs_no,recv_irs_no,ar_no,authtoken,gbn,gbn2,gbn3,gbn4,gbn5,totalRow,toRow,reason,detailArIssue, issueSendYn,arrConvId,issue_ar_no, system_id){

	var rtnData = "";
	var certPassword = "";
	var con_id = "";
	var requestTime = "";
	g_snmGbn= gbn4;
	var user_id = $("#st_user_id").val();
	var trow = totalRow;
	var row = toRow;
	var smarbillUrl = "";
	if(issueSendYn == ""){
		issueSendYn = "N";
	}
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/cmcl/SendARMasterCmClSalesTaxsheetRaIssueFormat.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: paramInfo, param2:user_id, param3:gbn, param4:gbn2, param5:gbn3},
	     async : false,
	     success:function( response ) {  		    	
	    	if(response.data == null){
  				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(11)");
					 doAction('search');	
				}    return;
	    	}
    	 	if (response.data.length > 0){
    	 		for (var i=0; i<response.data.length; i++){ 
					rtnData = $.trim(eval("response.data["+i+"].SEND_FORMAT"));
					certPassword = $.trim(eval("response.data["+i+"].SERT_PASSWORD"));
					con_id = $.trim(eval("response.data["+i+"].CON_ID"));
					requestTime = $.trim(eval("response.data["+i+"].REQUEST_TIME"));
					smarbillUrl = $.trim(eval("response.data["+i+"].SMARTBILL_URL"));
					//smarbillUrl = smUrl;
					//alert(smarbillUrl);
					//취소시 O 국세청 전송전
					if(gbn == "T"){
						sendSmartRaIssueBillCancel(ar_no,rtnData,send_irs_no,recv_irs_no,certPassword,con_id,requestTime,authtoken,gbn3,gbn4,gbn5,trow,row,reason,smarbillUrl,system_id);
					}else{
						sendSmartRaIssueBill(ar_no,rtnData,send_irs_no,recv_irs_no,certPassword,con_id,requestTime,authtoken,gbn,trow,row,detailArIssue,smarbillUrl,system_id);
					}
 		    	}
    	 	}
		   },
		 error:function( response ) {
				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(12)");
					 doAction('search');	
				}
	    	 return;
		   }
    });  
}

function sendSmartRaIssueBill(ar_no, xml_info, send_irs_no, recv_irs_no, cert_password,con_id,requestTime,authtoken,gbn,trow,row,detailArIssue,smarbillUrl,system_id){
	//세금계산서 1건와 1:1로 매핑되는 스마트빌 시스템 고유의 식별자(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
	var arrConId = new  Array();
	arrConId[0] = con_id;
	g_con_id = con_id;
	var st_signal   = "";
	
	st_signal = "RARISSUE";

	var request ="";
	if(system_id=="BQMS"||system_id=="CBMS"){
		request = JSON.stringify({
			'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
			'Signal' : st_signal ,  // 트랜잭션 식별자 고정
			'RequestTime': requestTime, // //yyyymmddhh24miss
			'SendComRegno': send_irs_no , //공급자 사업번호
			'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
			'AuthToken': authtoken ,  //인증토큰
			'ServiceCode': 'DTI' ,  //서비스코드 고정
			'SystemType': 'OAPI' ,  //시스템타입
			'ConversationId': arrConId ,  //참조번호
			'SMTPEmail': '' ,  //시스템타입
			'RValue': '', //신원확인값 공백
			'SystemId': system_id,
			'CertPassword': cert_password ,
			'SignedXML': xml_info,
			'UnSignedXML': xml_info
		});
	}else{
		request = JSON.stringify({
			'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
			'Signal' : st_signal ,  // 트랜잭션 식별자 고정
			'RequestTime': requestTime, // //yyyymmddhh24miss
			'SendComRegno': send_irs_no , //공급자 사업번호
			'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
			'AuthToken': authtoken ,  //인증토큰
			'ServiceCode': 'DTI' ,  //서비스코드 고정
			'SystemType': 'OAPI' ,  //시스템타입
			'ConversationId': arrConId ,  //참조번호
			'SMTPEmail': '' ,  //시스템타입
			'RValue': '', //신원확인값 공백
			'CertPassword': cert_password ,
			'SignedXML': xml_info,
			'UnSignedXML': xml_info
		});
	}
	$.support.cors = true;
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      contentType: "application/json",
	      url: smarbillUrl,
	      data: request,
	     success:function( data ) {
	    	 sendSuccessSB(data,con_id,"R",trow,row); 	
	   },
		 error:function( response ) {
				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(13)");
					 doAction('search');	
				}
			 return;
	   }
	}); 
	
}

//스마트빌 역발행 전송(반려)
function sendSmartRaIssueBillCancel(ar_no, xml_info, send_irs_no, recv_irs_no, cert_password,con_id,requestTime,authtoken,gbn3,gbn4,gbn5,trow,row,reason,smarbillUrl,system_id){
	//세금계산서 1건와 1:1로 매핑되는 스마트빌 시스템 고유의 식별자(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
	var arrConId = new  Array();
	var st_signal = "";
	var st_status_signal = "";
	
	st_signal = "CHGSTATUS";
	st_status_signal = "RIREJECT";
	
	arrConId[0] = con_id;
	g_con_id = con_id;

	var request ="";
	//시스템 ID가 BQMS, CBMSD일때
	if(system_id=="BQMS"||system_id=="CBMS"){
		request = JSON.stringify({
		'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
		'Signal' : st_signal, // 트랜잭션 식별자 고정
		'RequestTime': requestTime, // //yyyymmddhh24miss
		'SendComRegno': send_irs_no , //공급자 사업번호
		'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
		'AuthToken': authtoken ,  //인증토큰
		'ServiceCode': 'DTI' ,  //서비스코드 고정
		'SystemType': 'OAPI' ,  //시스템타입
		'ConversationId': arrConId ,  //참조번호
		'SMTPEmail': 'OAPI' ,  //시스템타입
		'RValue': '', //신원확인값 공백
		'CertPassword': cert_password ,
		'StatusSignal': st_status_signal,
		'SystemId': system_id,
		'StatusReason': gbn4,
		'SignedXML': xml_info
		});
	}else{
		request = JSON.stringify({
			'MessageId':ar_no ,// 트랜잭션 식별자 ,AR,AP번호
			'Signal' : st_signal, // 트랜잭션 식별자 고정
			'RequestTime': requestTime, // //yyyymmddhh24miss
			'SendComRegno': send_irs_no , //공급자 사업번호
			'ReceiveComRegno': recv_irs_no ,  //공급받는자 사업번호
			'AuthToken': authtoken ,  //인증토큰
			'ServiceCode': 'DTI' ,  //서비스코드 고정
			'SystemType': 'OAPI' ,  //시스템타입
			'ConversationId': arrConId ,  //참조번호
			'SMTPEmail': 'OAPI' ,  //시스템타입
			'RValue': '', //신원확인값 공백
			'CertPassword': cert_password ,
			'StatusSignal': st_status_signal,
			'StatusReason': gbn4,
			'SignedXML': xml_info
			});		
	}
	$.support.cors = true;
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      contentType: "application/json",
	      url: smarbillUrl,
	      data: request,
	     success:function( data ) {
	    		if("30000" != data.ResultCode){
	    			errorSendSmartBill(data.ResultCode,data.ResultMessage,con_id,trow,row);
	    		}else{
	    			cancleSuccessSmartBill(con_id,reason,trow,row);
	    		}
	   },
		 error:function( response ) {
				if(trow==row){
					loader_obj("N");
					 alert("전송 에러가 발생했습니다.(14)");
					 doAction('search');	
				}
			 return;
	   }
	});
}

//역발행 메일 요청 step1
function sendApMailSmartBill(ap_no,recv_mail,recv_user_name,authtoken){
	var conv_id = "";
	var requestTime = "";
	var user_id = $("#st_user_id").val();
	var smarbillUrl = "";
	var kep_irs_no = "";
	
	$.ajax({
		type: "POST",
		dataType:"json",
		url: "/cmcl/sendMasterCmClsendApRMail.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: {param1:ap_no, param2:recv_mail, param3:recv_user_name},
		async: false,
		success: function( response ) {
			if(response.data == null){
				alert("전송 에러가 발생했습니다.(1)");
				return;
			}

			if(response.data.length > 0){
				requestTime = $.trim(eval("response.data[0].REQUEST_TIME"));
				kep_irs_no = $.trim(eval("response.data[0].BYR_IRS_NO"));
				conv_id = $.trim(eval("response.data[0].CON_ID"));
				smarbillUrl = $.trim(eval("response.data[0].SMARTBILL_URL"));
				
	    		sendSmartBillApMail(ap_no,requestTime,kep_irs_no,authtoken,conv_id,recv_mail,smarbillUrl);
			}
		},
		error:function( response ) {
			alert("전송 에러가 발생했습니다.(2)");
			return;
		}
	});
}

//역발행 메일 요청 step2
function sendSmartBillApMail(ap_no,requestTime,kep_irs_no,authtoken,conv_id,recv_mail,smarbillUrl){
	// array 형태로 전송되어야 함.
	var arrConId = new Array();
	var arrEmail = new Array();
	
	arrConId[0] = conv_id;
	arrEmail[0] = recv_mail;
	
	var request ="";
	
	request = JSON.stringify({
		'MessageId':ap_no ,// 트랜잭션 식별자 ,AR,AP번호
		'Signal' : 'SENDMAIL' ,  // 트랜잭션 식별자 고정
		'RequestTime': requestTime, // //yyyymmddhh24miss
		'SendComRegno': kep_irs_no , //공급받는자 사업번호(KeP)
		'AuthToken': authtoken ,  //인증토큰
		'ServiceCode': 'DTI' ,  //서비스코드 고정
		'SystemType': 'OAPI' ,  //시스템타입
		'ConversationId': arrConId ,  //참조번호
		'StatusSignal': 'RARREQUEST',
		'Email' : arrEmail
	});		

	$.support.cors = true;
	
	$.ajax({
		type: "POST",
		dataType:"json",
		contentType: "application/json",
		url: smarbillUrl,
		data: request,
		success:function( data ) {
			if("30000" == data.ResultCode){
//				alert(ap_no + "\n" + requestTime + "\n" + kep_irs_no + "\n" + authtoken + "\n" + conv_id + "\n" + recv_mail + "\n" + smarbillUrl + "\n" + data.MessageId + "\n" + data.Signal + "\n" + data.ConversationId + "\n" + data.ResultCode + "\n" + data.ResultMessage + "\n" + "스마트빌에 역발행 메일을 요청하였습니다.");
				alert("스마트빌에 역발행 메일을 요청하였습니다.");
				doAction('search');
    		}else{
//    			alert(ap_no + "\n" + requestTime + "\n" + kep_irs_no + "\n" + authtoken + "\n" + conv_id + "\n" + recv_mail + "\n" + smarbillUrl + "\n" + data.MessageId + "\n" + data.Signal + "\n" + data.ConversationId + "\n" + data.ResultCode + "\n" + data.ResultMessage + "\n" + "전송 에러가 발생했습니다.(3)");
    			alert(ap_no + "\n" + requestTime + "\n" + kep_irs_no + "\n" + authtoken + "\n" + conv_id + "\n" + recv_mail + "\n" + smarbillUrl + "\n" + data.MessageId + "\n" + data.Signal + "\n" + data.ConversationId + "\n" + data.ResultCode + "\n" + data.ResultMessage + "\n" + "전송 에러가 발생했습니다.(3)");
    			return;
    		}
		},
		
		error:function( data ) {
//			alert(ap_no + "\n" + requestTime + "\n" + kep_irs_no + "\n" + authtoken + "\n" + conv_id + "\n" + recv_mail + "\n" + smarbillUrl + "\n" + data.MessageId + "\n" + data.Signal + "\n" + data.ConversationId + "\n" + data.ResultCode + "\n" + data.ResultMessage + "\n" + "\n" + "전송 에러가 발생했습니다.(4)");
			alert(ap_no + "\n" + requestTime + "\n" + kep_irs_no + "\n" + authtoken + "\n" + conv_id + "\n" + recv_mail + "\n" + smarbillUrl + "\n" + data.MessageId + "\n" + data.Signal + "\n" + data.ConversationId + "\n" + data.ResultCode + "\n" + data.ResultMessage + "\n" + "\n" + "전송 에러가 발생했습니다.(4)");
			return;
		}
	});
}
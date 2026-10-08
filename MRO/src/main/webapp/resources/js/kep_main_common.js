$(function () {
  //navlist
  $('#navList').on('click', '.nav-btn', function(event) {
    if($(this).hasClass('btn-active')){
      $('#expandZone #closeBtn').click();
      $('#expandZoneEn #closeBtn').click();
      return false;
    }
    var device = $(this).data('device');
    $(this).addClass('btn-active').siblings().removeClass('btn-active');
    $(device).addClass('item-active').siblings().removeClass('item-active');
    $('#expandZone').animate({height: '220px'}).addClass('active');
    $('#expandZoneEn').animate({height: '220px'}).addClass('active');
    return false;
  });
  $('#expandZoneEn #closeBtn').on('click', function() {
	    $('#expandZoneEn').animate({height: '0px'}, function () {
	      $(this).removeClass('active');
	      $('#navList .btn-active').removeClass('btn-active');
	    });
	    return false;
	  });
  $('#expandZone #closeBtn').on('click', function() {
    $('#expandZone').animate({height: '0px'}, function () {
      $(this).removeClass('active');
      $('#navList .btn-active').removeClass('btn-active');
    });
    return false;
  });
});

/**
 * 페이지이동
 */	
function MovePage(urlLink , subNo, pageNo) {	
	if(subNo == "01"){ //회사소개
		switch (pageNo) {
			case "01":
				location.href = urlLink + "/main/sub01/sub01_01ceo_greeting.do";
				break;
					 
			case "02":
				location.href = urlLink + "/main/sub01/sub01_02summary.do";				
				break;
				
			case "03":
				location.href = urlLink + "/main/sub01/sub01_03history.do";				
				break;
				
			case "04":
				location.href = urlLink + "/main/sub01/sub01_04winwin_activities.do";				
				break;
				
			case "05":
				location.href = urlLink + "/main/sub01/sub01_05society_activity.do";				
				break;
				
			case "06":
				location.href = urlLink + "/main/sub01/sub01_06recruit.do";				
				break;
				
			case "07":
				location.href = urlLink + "/main/sub01/sub01_07map.do";				
				break;
		}
	}else if(subNo == "02"){ //사업소개
		switch (pageNo) {
			case "01":
				location.href = urlLink + "/main/sub02/sub02_01bmodel.do";
				break;
					 
			case "02":
				location.href = urlLink + "/main/sub02/sub02_02distinction.do";				
				break;
				
			case "03":
				location.href = urlLink + "/main/sub02/sub02_03value.do";				
				break;
				
			case "04":
				location.href = urlLink + "/main/sub02/sub02_04supply.do";				
				break;
				
			case "05":
				location.href = urlLink + "/main/sub02/sub02_05intergrated.do";				
				break;
		}
		
	}else if(subNo == "03"){ //이용안내
		switch (pageNo) {
			case "01":
				location.href = urlLink + "/main/sub03/sub03_01faq.do";
				break;
					 
			case "03":
				location.href = urlLink + "/main/sub03/sub03_03qna.do";				
				break;
				
			case "04":
				location.href = urlLink + "/main/sub03/sub03_04download.do";				
				break;
		}
	}else if(subNo == "04"){ //정보안내
		switch (pageNo) {
			case "01":
				location.href = urlLink + "/main/sub04/sub04_01notice.do";
				break;
				
			case "02":
				location.href = urlLink + "/main/sub04/sub04_02ebiz_news.do";				
				break;
					 
			case "03":
				location.href = urlLink + "/main/sub04/sub04_03pecialists.do";				
				break;
				
			case "04":
				location.href = urlLink + "/main/sub04/sub04_04customer.do";
				break;
		}
		
	}else if(subNo == "05"){ //회원가입, ID/PWD찾기
		switch (pageNo) {
			case "03_1":
				location.href = urlLink + "/main/sub05/sub05_03id_search.do";
				break;
				
			case "03_2":
				location.href = urlLink + "/main/sub05/sub05_03pw_search.do";
				break;
					 
		}
		
	}
}
/**
 * 2016_페이지이동
 */	
function MovePage_2016(urlLink , subNo, pageNo) {
	if(subNo == "00"){ //영문사이트 이동
		switch (pageNo) {
		case "01": //영문사이트 이동
			//location.href = urlLink + "/main/main_en.do";
			break;
		}
	}else if(subNo == "01"){ //회사소개
		switch (pageNo) {
			case "01": //CEO메시지
				location.href = urlLink + "/main/sub01/sub01_01ceo_greeting_2016.do";
				break;
			case "02": //개요
				location.href = urlLink + "/main/sub01/sub01_02summary_2016.do";				
				break;
				
			case "03": //연혁
				location.href = urlLink + "/main/sub01/sub01_03history_2016.do";				
				break;
				
			case "04"://비전
				location.href = urlLink + "/main/sub01/sub01_04vision_2016.do";				
				break;
				
			case "05": //오시는길
				location.href = urlLink + "/main/sub01/sub01_07map_2016.do";				
				break;
				
			case "06": //공고
				location.href = urlLink + "/main/sub01/sub01_06invest_notice.do";				
				break;
				

		}
	}else if(subNo == "02"){ //사업소개
		switch (pageNo) {
			case "01"://MRO구매대행
				location.href = urlLink + "/main/sub02/sub02_mro_2016.do";
				break;
					 
			case "02": //부자재구매대행
				location.href = urlLink + "/main/sub02/sub02_materie_2016.do";				
				break;
				
			case "03": //건설MRO소개
				location.href = urlLink + "/main/sub02/sub02_cmro_2016.do";				
				break;
				
			case "04"://해외법인
				location.href = urlLink + "/main/sub02/sub02_global_2016.do";				
				break;
				
			case "05"://구매시스템
				location.href = urlLink + "/main/sub02/sub02_system_2016.do";				
				break;
				
			case "06"://물류센터
				location.href = urlLink + "/main/sub02/sub02_network_2016.do";				
				break;
		}
		
	}else if(subNo == "03"){ //이용안내
		switch (pageNo) {
			case "01"://FAQ
				location.href = urlLink + "/main/sub03/sub03_01faq_2016.do";
				break;
			case "02"://업무처리프로세스
				location.href = urlLink + "/main/sub03/sub03_03process_2016.do";				
				break;
			case "03"://공지사항
				location.href = urlLink + "/main/2016/sub03/getSub03_04notice.do";				
				break;
			case "04"://인재상
				location.href = urlLink + "/main/sub03/sub03_recruit_2016.do";				
				break;
			case "05"://인사정보
				location.href = urlLink + "/main/sub03/sub03_recruit02_2016.do";				
				break;
			case "06"://채용정보
				location.href = urlLink + "/main/sub03/sub03_recruit03_2016.do";				
				break;
			case "07"://구매대행 도입문의
				location.href = urlLink + "/main/sub04/sub04_newcustomer.do";				
				break;
		}
	}else if(subNo == "04"){ //회원가입
		switch (pageNo) {
			case "01"://신규회원가입안내
				location.href = urlLink + "/main/sub04/sub04_joininfo_2016.do";
				break;
			case "02"://회원가입하기
				location.href = urlLink + "/main/sub04/sub04_join_2016.do";				
				break;
			case "03"://계약서다운로드
				location.href = urlLink + "/main/sub04/sub04_download_2016.do";				
				break;
			case "04"://IDPW찾기
				location.href = urlLink + "/main/sub04/sub04_idpw_search_2016.do";
				break;
			case "05"://LOGIN
				location.href = urlLink + "/main/sub04/sub04_login_2016.do";
				break;
		}
		
	}
}
/**
 * 공통 ajax 호출 
 * pUrl  : 호출할 URL
 * pData : 전달할 data
 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccessMain ,kepAjaxErrorMain 구현한다.
 */	
function kepAjaxCallMain(pUrl,pData,pMethod) {   
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
		    		 kepAjaxErrorMain(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
		    		 return;
		    	} 
		    	 
		    	 kepAjaxSuccessMain(pMethod , response); // 화면에 필수적으로 있어여한다.
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
				kepAjaxErrorMain(pMethod , response); // 화면에 필수적으로 있어여한다.
			   }
		});  
}

/**
 * 공통 ajax 호출 
 * pUrl  : 호출할 URL
 * pData : 전달할 data
 * pMethod : 구분 을 이용 해당 화면에서 kepAjaxSuccessMain ,kepAjaxErrorMain 구현한다.
 */	
function kepAjaxFormCallMain(pUrl,pForm,pMethod) {    
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
		    		 kepAjaxErrorMain(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
		    		 return;
		    	} 
		    	 kepAjaxSuccessMain(pMethod , response); // 화면에 필수적으로 있어여한다.
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
				kepAjaxErrorMain(pMethod , response); // 화면에 필수적으로 있어여한다.
			   }
		});  
}

//업무프로세스
function poptype17(urlLink) {
	window.open(urlLink + "/resources/html/main/pop/agent_process.html", "업무프로세스", "left=100,top=100,width=820,height=600,toolbar=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0");
}
 

	
	
	
	
	
	
	
	
	
	
		

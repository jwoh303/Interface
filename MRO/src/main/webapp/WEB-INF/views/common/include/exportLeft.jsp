<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.menu.domain.Menu"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
$( document ).ready(function() {  
	//$('#lnbArea1').hide();
	//leftShowHidden('hide');
	/*if ($.cookie('leftShowHidden') == "show" || $.cookie('leftShowHidden') == "onload_show"){
		leftShowHidden("onload_show");
	}else{
		leftShowHidden($.cookie('leftShowHidden'));
	}*/
	 	
	/*$(window).resize(function() { // 화면 리사이즈시 다시검사....
		var winWidth = $(window).width();
		//alert(winWidth);
		if (winWidth < 1200) {
			$("#ContArea").css("width", "950px");
		} else {
			if ($.cookie('leftShowHidden') == "show" || $.cookie('leftShowHidden') == "onload_show") {
				$("#ContArea").css("width", "83%"); 
			} else {
				$("#ContArea").css("width", "100%"); 
			}
		}  
	});*/
	var param = null; 
	function getParameters(){ 
        var uri = location.href; 
        var param = null; 
        var params = new Object; 
         param = uri.split("?");  
         if(param.length > 1){  
               param = param[1].split("&");  
               for(var i = 0 ; i < param.length; ++i){  
                      var imsi = param[i].split("=");  
                      params[imsi[0]] = imsi[1];  
               }  
               params.getString = function(str){  
                     if(this[str]) return this[str];  
                     else return null;  
               }; 
               return params;  
         }  
         return null;   
   }
	
	//header중메뉴를 클릭하면 leftMenu보이도록 처리.
	param = getParameters();
	var menuShow = ""; 
    if(param != null){  
    	menuShow = param.getString("menuShow");  
    } 
    
    if(menuShow == "Y"){
    	leftShowHidden('show');
    	//$.cookie('leftShowHidden','onload_show');
    }
    
     
    
	$(window).resize(function() { // 화면 리사이즈시 다시검사....
		fn_winResize();
	});
    
	fn_winResize();
});

function fn_winResize(){
	var winWidth = $(window).width(); 
	if (winWidth < 1200) {
		$("#ContArea").css("width", "995px"); 
		$(".cont_searchA").css("width", "995px");
	} else  {
		$("#ContArea").css("width", "97%");		
	}
}
	
function leftShowHidden(flag){ 	
	
	if (flag == "onload_show" || flag == "show") {
		$("#lnbArea1").hide();
		$("#lnbArea").show();
	} else {
		$("#lnbArea1").show();
		$("#lnbArea").hide();
	}
	//$.cookie('leftShowHidden',flag);
	
	/* AS-IS 컨텐츠 FRAME 사이즈 조정
	if (flag == "onload_show" || flag == "show"){			
		var w = $("#lnbArea").width(); 
		if (flag=="onload_show"){
			$("#ContArea").animate({"left": "+=5px"}, 0);  
		}else{
			$("#ContArea").animate({"left": "+=205px"}, 0);  	
		}
		$("#lnbArea1").hide();
		$("#lnbArea").show();
		$("#ContArea").css("width",  "83%");				
		$("#ContArea").css("left",  "20px");				
		$("#searchBtnA").css("width", "750px");
		$(".cont_searchA").css("width", "750px");
		$(".cont_t_list01").css("width", "750px");
	}else{		 				 
		$("#ContArea").animate({"left": "-=205px"}, 0); 
		$("#lnbArea1").show();
		$("#lnbArea").hide();
		$("#ContArea").css("width",  "98%");		 	
		$("#searchBtnA").css("width", "900px");
		$(".cont_searchA").css("width", "900px");
		$(".cont_t_list01").css("width", "900px");	
	}	 
	$.cookie('leftShowHidden',flag);
	*/
} 
</script>
<div id="lnbArea1" >
<p class="lnb_open"><a href="javascript:leftShowHidden('show');"><img src="/resources/images/lnb_btn_openS.gif" alt="보여주기버튼" /></a></p>
</div> 
<div id="lnbArea" style="display:none;">
        	<p class="lnb_title"><%= request.getAttribute("title") %></p>
            <p class="lnb_hide"><a href="javascript:leftShowHidden('hide')"><img src="/resources/images/s_lnb_btn_hide.gif" alt="숨기기버튼" /></a></p>
        	<div id="lnbBox">
            	<ul class="lnb_1depth"> 
                    	<%= request.getAttribute("menu") %>
<!-- 
<li><a href="javascript:MovePage('sample1');">Buyer Sample화면</a></li> 
<li><a href="/masterMain.do">Master Main이동</a></li>       
<li><a href="javascript:MovePage('sample3');">Master Sample화면</a></li>  
<li><a href="/sellerMain.do">Seller Main이동</a></li>       
<li><a href="/sample/sellerSample.do">Seller SAMPLE이동</a></li>         
<li><a href="javascript:MovePage('sample2');">동적table 관리 Sample화면</a></li>  
<li><a href="javascript:MovePage('vallid');">vallid 화면</a></li>
<li><a href="javascript:MovePage('popup');">popup 화면</a></li> 		
<li><a href="javascript:MovePage('jspSearchv');">jsp 조회,등록 샘플(ajax)</a></li>  
<li><a href="javascript:MovePage('jspSearchaf');">jsp 조회,등록 샘플(formAjax)</a></li>
<li><a href="javascript:MovePage('jspSearchf');">jsp 조회,등록 샘플(form)</a></li>
<li><a href="javascript:MovePage('jspBoard');">jsp 게시판 샘플</a></li>
<li><a href="javascript:MovePage('jspCode');">jsp 코드관리 샘플</a></li>
<li>>>>업무화면<<<</li>
<li><a href="javascript:MovePage('o1');">신규상품 규격의뢰</a></li>
<li><a href="javascript:MovePage('o2-1');">신규상품 규격확인</a></li> 
<li><a href="javascript:MovePage('o3');">고객사 견적의뢰 입력</a></li>
<li><a href="javascript:MovePage('o4');">견적의뢰 접수</a></li>
<li><a href="javascript:MovePage('o5');">고객사 Nego의뢰 접수</a></li>
<li><a href="javascript:MovePage('o6');">견적접수 및 견적제출</a></li>
<li><a href="javascript:MovePage('o7');">견적접수 및 견적제출(두중)</a></li>
<li><a href="javascript:MovePage('o8');">진행상태 조회</a></li>
<li><a href="javascript:MovePage('o9');">최종단가 합의</a></li>
<li><a href="javascript:MovePage('os1');">발주진행관리</a></li>
  -->
                </ul>
        	</div>
        </div>
 <script>
function MovePage(no) {
	switch (no) {
	case "o1":
		location.href = "/mprq/showMasterMpRqItemReqStnd.do";
		break;
	case "o2-1":
		location.href = "/mprq/showMasterMpRqItemReqRcpt.do";
		break;
/* 	case "o2-2":
		location.href = "/showMasterMpRqItemReqRcpt2.do";
		break; */
	case "o3":
		location.href = "/mprq/showMasterMpRqBuyerReq.do";
		break;
	case "o4":
		location.href = "/mprq/showMasterMpRqReqQuotReceipt.do";
		break;
	case "o5":
		location.href = "/mprq/showMasterMpRqReqNegoReceipt.do";
		break;
	case "o6":
		location.href = "/mprq/showMasterMpRqItemReqStnd.do";
		break;
	case "o7":
		location.href = "/mprq/showMasterMpRqItemReqStnd.do";
		break;
	case "o8":
		location.href = "/mprq/showMasterMpRqItemReqStnd.do";
		break;
	case "o9":
		location.href = "/mprq/showMasterMpRqItemReqStnd.do";
		break;
	case "os1":
		location.href = "/mpso/showMasterMpSoProgress.do";
		break;
	case "c1":
		location.href = "/mprq/showBuyerMpRqSpecReq.do";
		break;
	case "c2":
		location.href = "/mprq/showBuyerMpRqSpecChkRes.do";
		break;
	case "c3":
		location.href = "/.do";
		break;
	case "c4":
		location.href = "/.do";
		break;
	case "c5":
		location.href = "/mprq/showBuyerMpRqQuotaProceStateList.do";
		break;
	case "sample1":
		location.href = "/sample/sample.do";
		break;
	case "sample2":
		location.href = "/sample/sample2.do";
		break;		
	case "sample3":
		location.href = "/sample/masterSample.do";
		break;				
	case "vallid":
		location.href = "/sample/valid.do";
		break;		
	case "popup":
		location.href = "/common/sample.do";
		break;				
	case "jspSearchv":
		location.href = "/sample/jspSearchViewSample.do";
		break;
	case "jspSearchaf":
		location.href = "/sample/jspSearchViewAjaxFormSample.do";
		break;		
	case "jspSearchf":
		location.href = "/sample/jspSearchViewFormSample.do";
		break;		
	case "jspBoard":
		location.href = "/board/boardViewList.do";
		break;				
	case "jspCode":
		location.href = "/board/codeMasterViewList.do";
		break;				 
	case "clear":
		location.href = "./test.html";
		break;
		
		/*		case 4:
		document.getElementById("contentFrame").src = "statics/sample/ibsheet_sample.html";
		break;
	case 5:
		document.getElementById("contentFrame").src = "statics/sample/html_sample.html";
		break;
	case 6:
		document.getElementById("contentFrame").src = "./sample/searchForJsp.do?sdate=201300101&edate=20130103";
		break;
	case 7:
		document.getElementById("contentFrame").src = "./sample/htmlSample.do";
		break;
	case 8:
		document.getElementById("contentFrame").src = "./buytaxcntViewA.do";
		break;
	case 9:
		document.getElementById("contentFrame").src = "./cmsViewA.do";
		break; 
		*/
	}
}
</script>

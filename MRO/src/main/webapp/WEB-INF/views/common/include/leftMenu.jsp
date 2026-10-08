<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="com.koreab2b.mro.manager.menu.domain.Root"%> 
   
    	<div id="lnbArea">
        	<p class="lnb_title">메뉴</p>
            <p class="lnb_hide"><a href="#"><img src="/resources/images/lnb_btn_hide.gif" alt="숨기기버튼" /></a></p>
        	<div id="lnbBox">
            	<ul class="lnb_1depth">
        	  
<!--            

<li><a href="javascript:MovePage('sample1');">Sample화면</a></li> 
<li><a href="javascript:MovePage('sample2');">동적table 관리 Sample화면</a></li>  
<li><a href="javascript:MovePage('vallid');">vallid 화면</a></li>
<li><a href="javascript:MovePage('popup');">popup 화면</a></li> 		
<li><a href="javascript:MovePage('jspSearchv');">jsp 조회,등록 샘플(ajax)</a></li>  
<li><a href="javascript:MovePage('jspSearchaf');">jsp 조회,등록 샘플(formAjax)</a></li>
<li><a href="javascript:MovePage('jspSearchf');">jsp 조회,등록 샘플(form)</a></li>
<li><a href="javascript:MovePage('jspBoard');">jsp 게시판 샘플</a></li>
<li><a href="javascript:MovePage('jspCode');">jsp 코드관리 샘플</a></li>
<li>>>>업무화면>>></li>
<li><a href="javascript:MovePage('c1');">신규상품규격의뢰</a></li>
<li><a href="javascript:MovePage('c2');">신규상품규격확인</a></li>
<li><a href="javascript:MovePage('c3');">신상품등록신청</a></li>
<li><a href="javascript:MovePage('c4');">단가합의및Nego신청</a></li>
<li><a href="javascript:MovePage('c5');">진행상태조회</a></li> -->

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
		location.href = "/sample/sample3.do";
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

<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 장바구니 관리항목 팝업
* 기능 : 한컴라이프케어 장바구니 관리항목 팝업
* 프로그램 ID :
* 담당자 : 
* 착수일 : 2017-04-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String cond0_code = (String)request.getAttribute("cond0_code"); // 조회된 결과
String cond1_code = (String)request.getAttribute("cond1_code"); // 조회된 결과
String cond2_code = (String)request.getAttribute("cond2_code"); // 조회된 결과
String cond2_name = (String)request.getAttribute("cond2_name"); // 조회된 결과
String cond3_code = (String)request.getAttribute("cond3_code"); // 조회된 결과
String cond3_name = (String)request.getAttribute("cond3_name"); // 조회된 결과
String cond4_code = (String)request.getAttribute("cond4_code"); // 조회된 결과
String cond4_name = (String)request.getAttribute("cond4_name"); // 조회된 결과

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
String st_remark = CommonUtil.nvl((String) request.getParameter("st_remark"),"");  //  (조회조건)
%>

<script type="text/javascript">
	var st_ref_pr_no = "";
	var st_ref_pr_no_text = "";
	var popupSel = "";
	var st_buyer = "<%=st_buyer%>";
function kep_onload(){
	
<%-- 	//라디오데이터 셋팅	cond0 - 회계단위(C021), cond1 - 원가(M014) FLAG값 Y인 경우만 보여줌  --%>
	kepAjaxCommonQueryIdRadio("cont_st_cond0","common.mpso.selectUOACombo","st_cond0","<%=cond0_code%>", st_buyer);
	kepAjaxCommonQueryIdRadio("cont_st_cond1","common.mpso.selectCostCombo","st_cond1","<%=cond1_code%>", st_buyer);
}

// 코스트센터 팝업
function getCond2Pop(){
	popupSel = "COND2";
	
	var st_gbn = "코스트센터";
	var st_type = "C020";
	var st_code = "";
	var st_text = "";
	
    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
}

// 프로젝트코드 팝업
function getCond4Pop(){
	popupSel = "COND4";
	
	var st_gbn = "프로젝트코드";
	var st_type = "C022";
	var st_code = "";
	var st_text = "";

    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
}

//계정코드 팝업
function getCond3Pop(){
	popupSel = "COND3";
	
	openSearchPopup("/coco/showCommonCoCoAccountPop.do", "?open=Y&st_com_code="+st_buyer, "500,500,no");
}


function setReturn(){
	if(set_ref_pr_no()){
		var cond5 = document.forms.searchForm.st_remark.value;
		
		if (!fnCheckInputByteStr(cond5, 400)) {
			alert("용도는 영문 400자, 한글 200자 까지 입력할수 있습니다.");
			return;
		}
		
		opener.setPopupReturn("",st_ref_pr_no, cond5);
		this.close();	
	}	
}

function set_ref_pr_no(){
	var cond0 = "";
	var cond1 = "";
	var cond2 = "";
	var cond3 = "";
	var cond4 = "";
	var cond0_name = "";
	var cond1_name = "";
	var cond2_name = "";
	var cond3_name = "";
	var cond4_name = "";
	
	cond0 = document.forms.searchForm.st_cond0.value;
	cond1 = document.forms.searchForm.st_cond1.value;
	cond2 = document.forms.searchForm.st_cond2_code.value;
	cond3 = document.forms.searchForm.st_cond3_code.value;
	cond4 = document.forms.searchForm.st_cond4_code.value;
	
	cond0_name = $("#st_cond0 option:selected").text();
	cond1_name = $("#st_cond1 option:selected").text();
	cond2_name = document.forms.searchForm.st_cond2_name.value;
	cond3_name = document.forms.searchForm.st_cond3_name.value;
	cond4_name = document.forms.searchForm.st_cond4_name.value;
	
	if(cond1 == "" || cond2 == "" || cond3 == "" || cond0 == ""){
		alert("필수입력 사항을 선택하여 주시기 바랍니다.");
		return false;
	}

	st_ref_pr_no = cond0 + "^" + cond1 + "^" + cond2 + "^" + cond3 + "^" + cond4;
	remark = document.forms.searchForm.st_remark.value;
	return true;
}

function setPopupReturn(value1,value2,value3){
	if(popupSel == "COND2"){
		document.forms.searchForm.st_cond2_code.value = value2;
		document.forms.searchForm.st_cond2_name.value = value3;
	}else if(popupSel == "COND3"){
		document.forms.searchForm.st_cond3_code.value = value1;
		document.forms.searchForm.st_cond3_name.value = value2;
	}else if(popupSel == "COND4"){
		document.forms.searchForm.st_cond4_code.value = value2;
		document.forms.searchForm.st_cond4_name.value = value3;
	}
}

</script>
<body onload="kep_onload()">
	<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">MRO 구매품목 관리항목 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            </div>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption> 리스트</caption>
						<colgroup>
							<col width="20%" />
							<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<td><span class="f_red">*</span> 회계단위</td>
							<td>
								<div id = "cont_st_cond0">
								</div>
                            </td>
						</tr>
												
						<tr>
							<td><span class="f_red">*</span> 원가</td>
							<td>
								<div id = "cont_st_cond1">
								</div>
                            </td>
						</tr>
						<tr>
							<td><span class="f_red">*</span> 코스트센터</td>
							<td>
								<input type="text" name="st_cond2_code" id="st_cond2_code" style="width:20%" value="<%=cond2_code%>" readonly>
								<a href="javascript:getCond2Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
								<input type="text" name="st_cond2_name" id="st_cond2_name" style="width:62%" value="<%=cond2_name%>" class="input_type_text" readonly>
							</td>
						</tr>
                         
                         <tr>
							<td><span class="f_red">*</span> 계정</td>
							<td>
								<input type="text" name="st_cond3_code" id="st_cond3_code" style="width:20%" value="<%=cond3_code%>" readonly>
								<a href="javascript:getCond3Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
								<input type="text" name="st_cond3_name" id="st_cond3_name" style="width:62%" value="<%=cond3_name%>" class="input_type_text" readonly>
							</td>
						</tr>
						
						<tr>
							<td>&nbsp;&nbsp;프로젝트코드</td>
							<td>
								<input type="text" name="st_cond4_code" id="st_cond4_code" style="width:20%" value="<%=cond4_code%>" readonly>
								<a href="javascript:getCond4Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
								<input type="text" name="st_cond4_name" id="st_cond4_name" style="width:62%" value="<%=cond4_name%>" class="input_type_text" readonly>
							</td>
						</tr>

						<tr>
							<td>&nbsp;&nbsp;비고<br>&nbsp;&nbsp;(연구소/개발 프로젝트명)</td>
							<td>
								<input type="text" name="st_remark"  id="st_remark" maxlength="400" style="width:89%; ime-mode:active" value="<%=st_remark%>" class="input_type_text">
                            </td>
                         </tr>
					</tbody>
				</table>
            </div>
        <!--버튼영역-->
		 <div class="btnArea" >
		 <span class="fr">
				<span class="btn_02 mr02"  title="확인"> <a href="javascript:setReturn();">확인</a></span>
		  </span>
		</div>
    </div>
</div>
</form>
</body>
</html>

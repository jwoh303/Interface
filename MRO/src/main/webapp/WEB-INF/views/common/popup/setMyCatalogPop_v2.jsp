<%--
**********************************************
* 메뉴 : 관심상품
* 화면 : 관심상품 폴더 관리 팝업
* 기능 : 관심상품 폴더 관리 팝업
* 프로그램 ID : BU0803004
* 담당자 : 최찬규
* 착수일 : 2026-03-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
	String SessionComCode = "";
	String SessionUserId = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId());
	}
	
	//관심상품 분류 리스트
// 	List<Map<String,String>> myItemList =  CommonUtil.getCode3List(SessionComCode, "SEL", "ITEM",SessionUserId, "ICOMCOD3_v2", "", "");
	List<Map<String,String>> myItemList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
%>
<script>
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
}

//modifycancel , modifystart 함수 구현
function modifyCancel(index){
	$("#myFolderText"+index).show();
	$("#myFolderTextModify"+index).hide();
}

function modifyStart(index){
	$("#myFolderText"+index).hide();
	$("#myFolderTextModify"+index).show();
}
function modifyList(index){
	// 수정하시겠습니까?
	var text = "<%=CommonLang.msg("MSG686")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:saveProcess('modify','"+index+"')";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "60px";
	var but2widthC = "60px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
}

function deleteList(index){
	var deleteFlag = $("#deleteFlag"+index).val();
	
	var text = "";
	if(deleteFlag == "Y"){ //폴더안에 아이템 들어가있는 경우임
		//해당 폴더에는 추가한 품목이 있습니다. 삭제하시겠습니까?
		text = "<%=CommonLang.msg("MSG785")%>";
	}else{
		// 삭제하시겠습니까?
		text = "<%=CommonLang.msg("MSG42")%>";
	}
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:saveProcess('delete','"+index+"')";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "60px";
	var but2widthC = "60px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
	
}
function saveProcess(flag,index){
	closePopText1();
	$("#CODE2").val($("#myFolder"+index).val());
	
	if(flag == "delete"){
		kepAjaxFormCall("/mdcm/delBuyerMdAmGoodsCategLis_v2.do","setMyCataologPop","delete");
	}else{ //수정부터 시작
		$("#TEXT1").val($("#folderName"+index).val());
		kepAjaxFormCall("/mdcm/updateBuyerMdAmGoodsCategLis_v2.do","setMyCataologPop","update");
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	
    if(sMsg == "CREATE_OK"){
    	if (pMethod == "delete"){ 
    		//정상적으로 삭제되었습니다.
    		 var text = "<%=CommonLang.msg("MSG75")%>";
      		 openLayerPopText2(text,but1text,but1funcSearch,but1width);
    	}else if (pMethod == "update"){ 
    		//정상적으로 수정되었습니다.
    		 var text = "<%=CommonLang.msg("MSG687")%>";
      		 openLayerPopText2(text,but1text,but1funcSearch,but1width);
    	}
        
      }else{
    	  if (pMethod == "delete"){ 
    			//삭제 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
    			 var text = "<%=CommonLang.msg("MSG162")%>";
    	  		 openLayerPopText2(text,but1text,but1func,but1width);
    		}else if (pMethod == "update"){ 
    			//수정 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
    			 var text = "<%=CommonLang.msg("MSG688")%>";
    	  		 openLayerPopText2(text,but1text,but1func,but1width);
    		}
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "delete"){ 
		//삭제 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG162")%>";
  		 openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "update"){ 
		//수정 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG688")%>";
  		 openLayerPopText2(text,but1text,but1func,but1width);
	}
} 

function thisPopClose(){
	closePopText2();
	location.reload();
}

function thisPopClose2(){ //창 닫으면 바닥 페이지 새로고침
	parent.reloadFunc();
	parent.closePop();
}
</script>
</head>
<body onload="kep_onload_view()">
		<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1117") %><!-- 폴더관리 --><span><a href="javascript:thisPopClose2();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="FolderBoxManage mt10">
   <ul>
  	<%if(myItemList.size()<=0 || myItemList == null) {%>
  	<%}else{ %>
  		<%for(int i = 0; i<myItemList.size(); i++) {%>
  			<input type="hidden" name="myFolder" id="myFolder<%=i %>" value="<%=myItemList.get(i).get("CODE2")%>">
  			<input type="hidden" name="deleteFlag" id="deleteFlag<%=i %>" value="<%=myItemList.get(i).get("DELETE_FLAG")%>">
  			<li id="myFolderText<%=i%>">
  			<p class="HeartWon"></p> <%=myItemList.get(i).get("TEXT1")%>  <p class="Btnarea" <%if(myItemList.get(i).get("CODE2").equals("MCDEFAULT")) {%> style="display: none;"<%} %>><button class="But_Pencil" onclick="javascript:modifyStart('<%=i %>'); return false;" ><%=CommonLang.get("HTITLE781") %><!-- 수정 --></button> <button class="But_WasteBaske" onclick="javascript:deleteList('<%=i %>'); return false;"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></button></p>
  			</li>
  			
  			<li id="myFolderTextModify<%=i%>" style="display: none;">
  			<input class="input30_6px" style="width:255px" name="folderName" id="folderName<%=i %>" type="text" value="<%=myItemList.get(i).get("TEXT1")%>"/>
         	<p class="Btnarea"><button class="ButOutline_Small" onclick="javascript:modifyCancel('<%=i %>'); return false;" >취소</button> <button class="ButQuaternary_Small" onclick="javascript:modifyList('<%=i %>'); return false;"><%=CommonLang.get("HTITLE781") %><!-- 수정 --></button></p>
  			</li>
  		<%} %>
  	<%} %>
  </ul>
  </div>
  <input type="hidden" name="selFolderCode" id="selFolderCode" value="">
  <div class="PopupListBtnBox_Center mt30">
    <button class="ButPrimary_large" onclick="javascript:thisPopClose2();return false;"><%=CommonLang.get("HTITLE497") %><!-- 닫기 --></button>
  </div>
</div><!-- wrapPopup 끝--> 
<form name="setMyCataologPop" id="setMyCataologPop" method="post">	
	<input type="hidden" id="st_type" name="st_type"  value="ITEM">
	<input type="hidden" name="CODE2" id="CODE2" value="" /> 
	<input type="hidden" name="TEXT1" id="TEXT1" value="" />
	<input type="hidden" name="TEXT2" id="TEXT2" value="" />
	<input type="hidden" name="TEXT3" id="TEXT3" value="" />
	<input type="hidden" name="TEXT4" id="TEXT4" value="" />
	<input type="hidden" name="CODE1" id="CODE1" value="${sessionInfo.userId}" />
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}" /> 
</form>
</body>
</html>

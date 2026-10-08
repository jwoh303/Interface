<%--
**********************************************
* 메뉴 : 
* 화면 : 표준카탈로그 상세보기 
* 기능 : 
* 프로그램 ID : PG_03_M_003_01
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 표준카탈로그 상세 list
List<Map<String,String>> _attrDataList = (List<Map<String,String>>) request.getAttribute("attrData"); // 상품상세속성 list
List<Map<String,String>> _imgDataList = (List<Map<String,String>>) request.getAttribute("imgData"); // 이미지 list

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = _sessionInfo.getUserId();

String st_cms_catlg_id = CommonUtil.nvl((String) request.getParameter("st_cms_catlg_id"),"");  //  (조회조건)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

Map<String,String> _rowImgData = null;
if (_imgDataList != null && _imgDataList.size() != 0) { 
	_rowImgData = _imgDataList.get(0);
}
%>

<script type="text/javascript">
<!--
var popupSel = "";

function MM_findObj(n, d) { //v4.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	  d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_showHideLayers() { //v3.0
	var i,p,v,obj,args=MM_showHideLayers.arguments;
	for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
	  if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
	  obj.visibility=v; }
}

function kep_onload_view() {
	<% if (_dataList.size() == 0) { %>
		alert("표준카탈로그 상세정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% }%>
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "masterMpRqKepStndrdCategorySelPop": //표준카테고리
			openSearchPopup("/mprq/showMasterMpRqKepStndrdCategorySelPop.do", "", "721,670,no");	
			break;
			
		case "maker": //제조사
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
			
		case "country": //원산지
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
			break;
			
		case 	"fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=CMS", "500,430,no");
			popupSel = "fileUpload";
			break;
		
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택
  		$("#st_category_path").val(value4);
  		$("#st_cms_categ_id").val(value3);
  		$("#st_cms_categ_change_yn").val("Y");
	
	}else if (popupSel == "maker") {	//제조사 선택
  		$("#st_maker_code").val(value1);
  		$("#st_maker_name").val(value2);
  		
	}else if (popupSel == "country") {	//원산지 선택
  		$("#st_origin_code").val(value1);
  		$("#st_origin_name").val(value3);
  		
	} else if (popupSel == "fileUpload") {
		$("#st_image_key").val(value1);
		if(value1 != ""){
			$("#CmsAtchImage").attr("src","/resources/images/disk_on.gif");	
		}
	}
	
	grbRow="";	//초기화
}

//기능함수
function doAction(str, flag) {
	switch (str) {
		case "save":
			
			var cms_spec = "";
			var attrValue = "";
			var attr_cnt = "<%=_attrDataList.size()%>";

			for(var i=1; i<=eval(attr_cnt); i++) {
				attrValue = $("#st_attb_nm"+i).val();
				cms_spec += attrValue+";";
			}
			
			if($("#st_std_flag").val() == "Y"){
				$("#st_specification").val(cms_spec);
			}
			
			if(!getCheckedCmsAttr()) return;	// 속성필수값 체크
			
			if(confirm("해당 카탈로그 정보를 수정하시겠습니까?")) {
				kepAjaxFormCall("/mdcm/saveMasterMdCmStndrdCatalogDetailViewPop.do","masterMdCmStndrdCatalogDetailViewPop","CATALOGSAVE");
			}
			break;
	}
}

//속성값 입력 체크
function getCheckedCmsAttr() {

	attr_flag = new Array();
	attr_name = new Array();

	var bFlag = true;
	var attrValue = "";
	var attr_cnt = "<%=_attrDataList.size()%>";

<%
	for(int attrIdx=0; attrIdx<_attrDataList.size(); attrIdx++) {
		Map<String,String> _rowAttrData = _attrDataList.get(attrIdx);
%>
	attr_name[<%=attrIdx%>]="<%=_rowAttrData.get("X_ATTB_NM")%>";
	attr_flag[<%=attrIdx%>]="<%=_rowAttrData.get("ATTB_FLAG")%>";
<%
	}
%>

	for(var i=1; i<=eval(attr_cnt); i++) {

		attrValue = $("#st_attb_nm"+i).val();
		if(attr_flag[i-1]=="Y" && isEmpty(attrValue)) {
			alert(attr_name[i-1]+" 값을 입력하여 주십시요.");
			$("#st_attb_nm"+i).focus();
			bFlag = false;
			break;
		}
	}
	
	return bFlag;
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 reload
	location.reload();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
	
	// 처리후 reload
	location.reload();
} 

//TEXTAREA 최대값 체크
function fn_TextAreaInputLimit() {

    var tempText = $("textarea[name='st_remark']");
    var tempChar = "";                                        // TextArea의 문자를 한글자씩 담는다
    var tempChar2 = "";                                        // 절삭된 문자들을 담기 위한 변수
    var countChar = 0;                                        // 한글자씩 담긴 문자를 카운트 한다
    var tempHangul = 0;                                        // 한글을 카운트 한다
    var maxSize = 200;                                        // 최대값

    // 글자수 바이트 체크를 위한 반복
    for(var i = 0 ; i < tempText.val().length; i++) {
        tempChar = tempText.val().charAt(i);
        // 한글일 경우 2 추가, 영문일 경우 1 추가
        /*if(escape(tempChar).length > 4) {
            countChar += 2;
            tempHangul++;
        } else {
            countChar++;
        }*/
        countChar++;
    }
    // 카운트된 문자수가 MAX 값을 초과하게 되면 절삭 수치까지만 출력을 한다.(한글 입력 체크)
    // 내용에 한글이 입력되어 있는 경우 한글에 해당하는 카운트 만큼을 전체 카운트에서 뺀 숫자가 maxSize보다 크면 수행
    if((countChar-tempHangul) > maxSize) {
        alert("상품상세정보란에 입력한 내용이 입력가능한 크기를 초과하였습니다.")
        tempChar2 = tempText.val().substr(0, maxSize-1);
        tempText.val(tempChar2);
    }
}

//-->
</script> 
<body onload="kep_onload_view();">
<form name="masterMdCmStndrdCatalogDetailViewPop" id="masterMdCmStndrdCatalogDetailViewPop" method=post >
<input type="hidden"	id="st_cms_catlg_id"				name="st_cms_catlg_id"				value="<%=st_cms_catlg_id%>" />
<input type="hidden"	id="st_cms_categ_change_yn"				name="st_cms_categ_change_yn"				value="N" />
<input type="hidden"	id="st_user_id"				name="st_user_id"				value="N" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:760px;">
    	<div id="popHeader">
        	<h1 class="title">표준카탈로그 상세보기 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<div id="ContArea" style="width:940px;margin-left:0;" >
           	<!--grid-->
            <div style="height:330px">
            
            <% if (_rowData != null) {  %>
				<table   style="width:100%">
					<caption>표준카탈로그 상세보기</caption>
                    <colgroup>
                    	<col width="320px" />
	                    <col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td width=320>
								<table border=0 cellSpacing=0 cellPadding=0 width="100%">
								<tbody>
									<tr>
									<td vAlign=top align=center>
									<table border=0 cellSpacing=0 cellPadding=0 width="100%">
									<tbody>
									<tr>
									<td width="45">&nbsp;</td>
									<td height=230 vAlign=top>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
									<div style="z-index: 0; position: absolute; width: 200px; height: 200px; visibility: visible" id="first"><a href="javascript:getCmsImgPop('<%=_rowData.get("IMG_NO")%>','<%=st_cms_catlg_id%>');"><img src="<%=_rowImgData.get("IMG01_NM")%>" border=0 src="" width=200 height=200></a></div>
									<div style="z-index: 0; position: absolute; width: 200px; height: 200px; visibility: hidden" id="second"><a href="javascript:getCmsImgPop('<%=_rowData.get("IMG_NO")%>','<%=st_cms_catlg_id%>');"><img src="<%=_rowImgData.get("IMG02_NM")%>" border=0 src="" width=200 height=200></a></div>
									<div style="z-index: 0; position: absolute; width: 200px; height: 200px; visibility: hidden" id="third"><a href="javascript:getCmsImgPop('<%=_rowData.get("IMG_NO")%>','<%=st_cms_catlg_id%>');"><img src="<%=_rowImgData.get("IMG03_NM")%>" border=0 src="" width=200 height=200></a></div>
									<div style="z-index: 0; position: absolute; width: 200px; height: 200px; visibility: hidden" id="fourth"><a href="javascript:getCmsImgPop('<%=_rowData.get("IMG_NO")%>','<%=st_cms_catlg_id%>');"><img src="<%=_rowImgData.get("IMG04_NM")%>" border=0 src="" width=200 height=200></a></div></td>
									<td width=20>&nbsp;</td>
									</tr>
									</tbody>
									</table>
									<table border=0 cellSpacing=0 cellPadding=0>
									<tbody>
									<tr>
										<td width=25><a href="javascript:getCmsImgPop('<%=_rowData.get("IMG_NO")%>','<%=st_cms_catlg_id%>');"><img src="/resources/images/btn_search03.gif"></a></td>
										<td><a href="javascript:getCmsImgPop('<%=_rowData.get("IMG_NO")%>','<%=st_cms_catlg_id%>');">확대보기</a>
										<input id="st_image_dir" name=st_image_dir type=hidden value="" > 
										<input id="st_image_name" name=st_image_name type=hidden value="" > 
										</td>
									</tr>
									</tbody></table>
									<table border=0 cellSpacing=0 cellPadding=0 width="100%" height=10>
									<tbody>
									<tr>
									<td></td></tr></tbody></table>
									<table border=0 cellSpacing=0 cellPadding=0>
									<tbody>
										<tr align=center>
										<td width=66>
										<table border=0 cellSpacing=1 cellPadding=0 width=66 bgColor=#cccccc>
										<tbody>
										<tr>
										<td bgColor=#ffffff><img onmouseover="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" onmouseout="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" src="<%=_rowImgData.get("IMG01_NM")%>" width=65 height=65></td></tr></tbody></table></td>
										<td width=10>&nbsp;</td>
										<td width=66>
										<table border=0 cellSpacing=1 cellPadding=0 width=66 bgColor=#cccccc>
										<tbody>
										<tr>
										<td bgColor=#ffffff><img onmouseover="MM_showHideLayers('first','','hide','second','','show','third','','hide','fourth','','hide')" onmouseout="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" src="<%=_rowImgData.get("IMG02_NM")%>" width=65 height=65></td></tr></tbody></table></td>
										<td width=10>&nbsp;</td>
										<td width=66>
										<table border=0 cellSpacing=1 cellPadding=0 width=66 bgColor=#cccccc>
										<tbody>
										<tr>
										<td bgColor=#ffffff><img onmouseover="MM_showHideLayers('first','','hide','second','','hide','third','','show','fourth','','hide')" onmouseout="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" src="<%=_rowImgData.get("IMG03_NM")%>" width=65 height=65></td></tr></tbody></table></td>
										<td width=10>&nbsp;</td>
										<td width=66>
										<table border=0 cellSpacing=1 cellPadding=0 width=66 bgColor=#cccccc>
										<tbody>
										<tr>
										<td bgColor=#ffffff><img onmouseover="MM_showHideLayers('first','','hide','second','','hide','third','','hide','fourth','','show')" onmouseout="MM_showHideLayers('first','','show','second','','hide','third','','hide','fourth','','hide')" src="<%=_rowImgData.get("IMG04_NM")%>" width=65 height=65></td></tr></tbody></table></td></tr>
									</tbody>
									</table>
									</td>
									<td vAlign=top width=20 align=right>&nbsp;</td>
									<td vAlign=middle align=right></td>
									</tr>
								</tbody>
								</table>
							</td>
							<td align="center">
							<table  class="cont_t_list06"  style="width:100%">
								<colgroup>
				                    <col width="120px" />
				                    <col width="32%" />
				                    <col width="120px" />
				                    <col width="32%" />
				                </colgroup>
				                <tbody>
				                	<tr>
				                        <th  scope="row" colspan="4" class="center"  style="font-weight:bold; font-size:15px;"><%=_rowData.get("DESCRIPTION_LOC")%></th>
				                    </tr>
				                	<tr>
				                        <th  scope="row">카테고리</th>
				                      	<td colspan="3">
				                      		<input id="st_category_path" name="st_category_path" type="text" class="input_type_text"  style="width:89%;" value = "<%=_rowData.get("CATEG_PATH")%>" readonly>
				                      		<a href="javascript:doPop('masterMpRqKepStndrdCategorySelPop');"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="st_cms_categ_id" name="st_cms_categ_id" value="<%=_rowData.get("CMS_CATEG_ID")%>">
				                      	</td>
				                    </tr>
					                <tr>
				                        <th  scope="row">품목코드</th>
				                      	<td colspan="3">
				                      		<b><%=_rowData.get("CMS_CATLG_ID")%></b>
				                      		<input type="hidden" id="st_cms_catgl_id" name="st_cms_catgl_id" value="<%=_rowData.get("CMS_CATLG_ID")%>">
				                      	</td>
				                        <!-- 
				                        <th  scope="row">자재구분</th>
				                      	<td>
				                      		<select id="st_item_group" name="st_item_group" >
				                      		<%
									 			Map<String, String> _map = new HashMap<String, String>();
									 			_map.put("TYPE","M102");
									 			_map.put("FLAG","Y");
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mdcm.getMdcmICOMCOD1","NO",_map,_rowData.get("ITEM_GROUP")) %>
											</select>
				                      	</td>
				                      	 -->
				                    </tr>
				                    <tr>
				                        <th  scope="row">품목명(한글)</th>
				                      	<td colspan="3">
				                      		<input type="text" id="st_description_loc" name="st_description_loc" class="input_type_text" style="width:93%;" value="<%=_rowData.get("DESCRIPTION_LOC")%>"></td>
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">품목명(영문)</th>
				                      	<td colspan="3">
				                      		<input type="text" id="st_description_eng" name="st_description_eng" class="input_type_text" style="width:93%;" value="<%=_rowData.get("DESCRIPTION_ENG")%>"></td>
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">전체규격</th>
				                      	<td colspan="3">
				                      		<input type="text" id="st_specification" name="st_specification" class="input_type_text" style="width:93%;" value="<%=_rowData.get("SPECIFICATION")%>"></td>
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">제조사</th>
				                      	<td>
				                      		<input type="text" id="st_maker_name" name="st_maker_name" value="<%=_rowData.get("MAKER_NAME")%>" class="input_type_text"  readonly>
				                      		<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="st_maker_code" name="st_maker_code" value="<%=_rowData.get("MAKER_CODE")%>">
				                      	</td>
				                        <th  scope="row">원산지</th>
				                      	<td>
				                      		<input type="text" id="st_origin_name" name="st_origin_name" value="<%=_rowData.get("ORIGIN_NAME")%>" class="input_type_text" readonly>
				                      		<a href="javascript:doPop('country');"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="st_origin_code" name="st_origin_code" value="<%=_rowData.get("ORIGIN_CODE")%>">
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">상품구분</th>
				                      	<td>
											<select id="st_item_gubun" name="st_item_gubun">
												<option value="SD" <%if(_rowData.get("ITEM_GUBUN").equals("SD")) {%>selected<%}%>>표준품</option>
												<option value="NS" <%if(_rowData.get("ITEM_GUBUN").equals("NS")) {%>selected<%}%>>비표준품</option>
											</select>
				                      	</td>
				                        <th  scope="row">작성구분</th>
				                      	<td>
				                      		<select name="st_onoff_type">
												<option value="ON" <%if(_rowData.get("ONOFF_TYPE").equals("ON")){%>selected<%}%>>On-line</option>
												<option value="FF" <%if(_rowData.get("ONOFF_TYPE").equals("FF")){%>selected<%}%>>Off-line</option>
												<option value="EE" <%if(_rowData.get("ONOFF_TYPE").equals("EE")){%>selected<%}%>>기타</option>
											</select>
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">주문단위</th>
				                      	<td>
				                      		<select id="st_order_measure" name="st_order_measure" >
				                      		<%
									 			_map.put("TYPE","M007");
									 			_map.put("FLAG","Y");
									 			_map.put("TEXT","CODE");
									 			_map.put("ORDERBY","NUMBER");
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mdcm.getMdcmICOMCOD1","NO",_map,_rowData.get("ORDER_MEASURE")) %>
											</select>
				                      	</td>
				                        <th  scope="row">표준납기일</th>
				                      	<td>
				                      		<input type="text" id="st_delivery_lt" name="st_delivery_lt" value="<%=_rowData.get("DELIVERY_LT")%>" class="input_type_text" > 일
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">표준화여부</th>
				                      	<td>
				                      		<select id="st_std_flag" name="st_std_flag">
												<option value="Y" <%if(_rowData.get("STD_FLAG").equals("Y")) {%>selected<%}%>>표준화</option>
												<option value="N" <%if(_rowData.get("STD_FLAG").equals("N")) {%>selected<%}%>>미표준화</option>
											</select>
				                      	</td>
				                        <th  scope="row">이미지필수</th>
				                      	<td>
				                      		<select id="st_img_flag" name="st_img_flag">
												<option value="Y" <%if(_rowData.get("IMG_FLAG").equals("Y")) {%>selected<%}%>>필수</option>
												<option value="N" <%if(_rowData.get("IMG_FLAG").equals("N")) {%>selected<%}%>>선택</option>
											</select>
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">첨부파일</th>
				                      	<td colspan="3">
			                            <%
											if(_rowData.get("IMAGE_KEY").equals("N")) {
										%>
											<a href="javascript:doPop('fileUpload');">
											<img src="/resources/images/disk_off.gif" id="CmsAtchImage"  name="CmsAtchImage" border="0">
			                            	<input type="hidden" id="st_image_key"  name="st_image_key" value="">
			                            	</a>
										<%
											}else{
										%>
											<a href="javascript:doPop('fileUpload');">
											<img src="/resources/images/disk_on.gif" id="CmsAtchImage"  name="CmsAtchImage" border="0">
			                            	<input type="hidden" id="st_image_key"  name="st_image_key" value="<%=_rowData.get("IMAGE_KEY")%>">
			                            	</a>
										<%
											}
										%>
				                      	</td>
				                    </tr>
				                    
				                </tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				<% }  %>
        	</div>
        	<div class="scrollArea" style="height:285px">
        		<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        			<tr valign="top">
        				<td width="460">
        					<table border="0" class="cont_t_list06"  style="width:100%">
        						<colgroup>
				                    <col width="120px" />
				                    <col width="*" />
				                </colgroup>
				                <tbody>
				                	<tr>
				                        <th  scope="row" colspan="2" class="center" style="font-weight:bold; font-size:15px;">[상품상세속성]</th>
				                    </tr>
				                    <tr>
				                        <th  scope="row" class="center" style="font-weight:bold; ">속성항목</th>
				                      	<th  scope="row" class="center" style="font-weight:bold; ">속성값</th>
				                    </tr>
<%
if (_attrDataList == null || _attrDataList.size() == 0){
%>
				               		<tr bgcolor="#FFFFFF">
				                        <td colspan="2" align="center" height = "280">
				                        <span class="font1">조회된 데이타가 없습니다.</span>
				                        </td> 
				                    </tr>
<%}else{
	String str = "";
	for (int j=0; j<_attrDataList.size(); j++) {
		Map<String,String> _rowData2 = _attrDataList.get(j);
		
		if(_rowData2.get("ATTB_FLAG").equals("Y")) {
			str="*";
		}else {
			str="";
		}
%> 				                    
				                    <tr>
				                        <th  scope="row"><%=str%><%=_rowData2.get("X_ATTB_NM")%></th>
				                      	<td>
				                      		<input type="text" id="st_attb_nm<%=j+1%>" name="st_attb_nm<%=j+1%>" maxlength="150" class="input_type_text"  style="width:96%" value="<%=_rowData2.get("Y_ATTB_NM")%>">
				                      	</td>
				                    </tr>
<%
		}
	}
%>
				                </tbody>
        					</table>
        				</td>
        				<td width ="30"></td>
        				<td align="right">
        					<table border="0" class="cont_t_list06"  style="width:100%">
        						<colgroup>
				                    <col width="120px" />
				                    <col width="*" />
				                </colgroup>
				                <tbody>
				                	<tr>
				                        <th  scope="row" colspan="2" class="center" style="font-weight:bold; font-size:15px;">[상품상세정보]</th>
				                    </tr>
				                    <tr>
				                        <th  scope="row" colspan="2" class="center" style="font-weight:bold; ">Product Detail Inforamtion</th>
				                    </tr>
				                    <tr>
				                        <td colspan="2" class="pt05 pb05" style="padding-left:1px;">
					                        <textarea id="st_remark" name="st_remark" onkeyup="javascript:fn_TextAreaInputLimit();" style="border:1px solid #d4d4d4; overflow:auto;" rows="15" cols="78" ><% if (_rowData != null) {  %><%=(_rowData.get("REMARK").equals("N") ? "" : CommonUtil.nvl(_rowData.get("REMARK")))%><%} %></textarea>
					                    </td>
				                    </tr>
				                </tbody>
        					</table>
        				</td>
        			</tr>
        		</table>
        	</div>
        	<!--버튼영역-->
            <div class="btnArea">
            	<span class="fr">
            		<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
            	</span>
            </div>
    		</div>    
    	</div>    
	</div>
</form> 
</body>
</html>

<%--
**********************************************
* 메뉴 : 정산관리>카탈로그>카탈로그조회
* 화면 : 카탈로그조회
* 기능 : 
* 프로그램 ID : PG_03_A_003_00
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	int grid_cnt = (_gridList != null )? _gridList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>카탈로그조회</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
		<span class="btn_search"><a href="javascript:kepSearch(1);">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="12%" />
				    <col width="38%" />
				    <col width="12%" />
				    <col width="38%" />
				</colgroup>
				
				<tbody>
				<tr>
					<th><font color="red"><b>*</b></font>고객사</th>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" value="" style="width:65%;ime-mode:active" READONLY>
						<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="" >
						<a href="javascript:doPop('sellerMpClTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
					<th>품목코드</th>
					<td> 
                        <input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:90%" onKeyUp="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()" value="">
                    </td>
				</tr>
				<tr>
					<th>품목명</th>
					<td> 
                        <input type="text" class="input_type_text" id="st_description" name="st_description" style="width:90%" onkeydown="kepEnter()" value="">
                    </td>
					
					<th>규격</th>
					<td width="18%"> 
                        <input type="text" class="input_type_text" id="st_specification"  name="st_specification" style="width:90%" onkeydown="kepEnter()" value="">
                    </td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow">
					<option value = "10" >10건</option>
					<option value = "20" >20건</option>
					<option value = "30" >30건</option>
					<option value = "40" >40건</option>
					<option value = "50" >50건</option> 
				</select>
      	</span>     
       <span class="fr">총건수 <%=total_cnt %></span>
       	<br>
	</form> 
	<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
	<form name = "contentForm" id="contentForm" method = "post"  modelAttribute="uploadForm" enctype="multipart/form-data">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	<input type="hidden" name="st_g_row" id="st_g_row" value="">
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="2%" />
	            <col width="12%" />
	            <col width="8%" />
	            <col width="6%" />
	            <col width="6%" />
	            <col width="*" />
	            <col width="6%" />
	            <col width="8%" />
	            <col width="6%" />
	            <col width="15%" />
	            <col width="6%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="javascript:kepCheckAll('<%=grid_cnt %>',document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
				</th>
                <th scope="col">고객사</th>
                <th scope="col">품목코드</th>
                <th scope="col">상품<br>이미지</th>
                <th scope="col">상품<br>상세 이미지</th>
                <th scope="col">품목명<br>규격</th>
                <th scope="col">단위<br>계약단가</th>
                <th scope="col">제조사<br>원산지</th>
                <th scope="col">등록일<br>수정일</th>
                <th scope="col">이미지등록 요청<br>상세이미지등록 요청</th>
                <th scope="col">이미지<br>등록신청 상태</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="12" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="font1_black1"  align="center">
						<input type="checkbox" id="checkbox<%=j%>" name="checkbox<%=j%>">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
						<input type="hidden" id="st_buyer"	 name="st_buyer"	        value="<%=rowData.get("BUYER")%>">
						<input type="hidden" id="st_buyer_item_no2"  name="st_buyer_item_no2" value="<%=rowData.get("BUYER_ITEM_NO")%>">
						<input type="hidden" id="st_contract_no"	name="st_contract_no"	  value="<%=rowData.get("CONTRACT_NO")%>">
						<input type="hidden" id="st_contract_seq"	 name="st_contract_seq"	  value="<%=rowData.get("CONTRACT_SEQ")%>">
						<input type="hidden" id="st_seller_item_no" name="st_seller_item_no"	value="<%=rowData.get("SELLER_ITEM_NO")%>">
						<input type="hidden" id="st_file_no" name="st_file_no"	value="">
						<input type="hidden" id="st_file_dir" name="st_file_dir"	value="">
						<input type="hidden" id="st_file_no2" name="st_file_no2"	value="">
						<input type="hidden" id="st_file_dir2" name="st_file_dir2"	value="">
					</td>
					<td title="고객사" class="left">
						<a class="hyperLink" href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER"))%>');">
							<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_NAME")))%>
						</a>
					</td>
					<td title="품목코드" class="left">
						<a class="hyperLink" href="javascript:doPop('sellerMpClGoodsDetailInfoPop','<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
							<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%>
						</a>
					</td>
					<td title="상품이미지">
					<%
						if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
					%>
						<img src="/resources/images/noimage.gif" width="80" height="80" border="0">
					<%
						}else{
					%>
						<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>','A');">
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0">
						</a>
					<%
						}
					%>										
					</td>
					<td title="상품상세이미지">
					<%
						if("".equals(CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR")))){
					%>
						<img src="/resources/images/noimage.gif" width="80" height="80" border="0">
					<%
						}else{
					%>
						<a class="hyperLink"  href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR"))+"/"%>','<%=CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_NAME"))%>','B');">
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("DETAIL_IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0">
						</a>
					<%
						}
					%>										
					</td>
					<td title="품목명/규격" class="left">
						&nbsp;&nbsp;<%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%><br>
						&nbsp;&nbsp;<%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%>
					</td>
					<td title="단위/계약단가" >
						<%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%><br>
						<%=CommonUtil.formatNumber(String.valueOf(rowData.get("LIST_PRICE")),true,0,3)%>
						
					</td>
					<td title="제조사/원산지" >
						<%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%><br>
						<%=String.valueOf(CommonUtil.nvl(rowData.get("ORIGIN_NAME")))%>
					</td>
					<td title="등록일/수정일">
						<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%><br>
						<%=CommonUtil.formatStrinigDate(rowData.get("CHANGE_DATE"))%>
					</td>
					<td title="이미지등록신청">
						<input name="files" id="files" type="file" size="18" onchange="saveAttatchFile(this.value,<%=j%>);" value=""  style="width:200px;"/>
						<input name="files2" id="files2" type="file" size="18" onchange="saveAttatchDetailFile(this.value,<%=j%>);" value=""  style="width:200px;"/>
					</td>
					<td title="이미지등록신청이력">
					<%
						if(CommonUtil.nvl(rowData.get("IMG_STATUS_CD")).equals("X")){
					%>
						<input type="hidden" id="st_img_status" name="st_img_status"	 value="<%=CommonUtil.nvl(rowData.get("IMG_STATUS_CD"))%>">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("IMG_STATUS_NM")))%>
					<%
						}else{
					%>
						<input type="hidden" id="st_img_status" name="st_img_status"	 value="<%=CommonUtil.nvl(rowData.get("IMG_STATUS_CD"))%>">
						<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('sellerMpClCatalogImgPopList','<%=String.valueOf(rowData.get("AGENT"))%>','<%=String.valueOf(rowData.get("BUYER_ITEM_NO"))%>');">
							<%=String.valueOf(CommonUtil.nvl(rowData.get("IMG_STATUS_NM")))%>
						</a>					
					<%
						}
					%>
					</td>
				</tr>
            <%
                        }
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<!--  span class="btn_04 mr04>
					<a href="javascript:doAction('reg');">재고등록</a>
				</span-->
				<span class="btn_08 mr04">
					<a href="javascript:doAction('regImg');">이미지등록요청</a>
				</span>
<!-- 
				<span class="btn_04 mr04">
					<a href="javascript:doAction('excelDown');">다운로드</a>
				</span>
 -->				
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post"  modelAttribute="uploadForm" enctype="multipart/form-data">
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_gbn" id="st_gbn"  value=""/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";
var btnEvent="";

// 최초 화면 함수 
function kep_onload_view(){
	
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//고객사코드
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//
	initSearchCondition("searchForm", "st_description", "${st_description}");	//
	initSearchCondition("searchForm", "st_specification", "${st_specification}");	//
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
}

var st;
//기능함수
function doAction(str) {
	var buyer       = $("#st_buyer_code").val();

    if(isEmpty(buyer) && (str =="search" || str =="excelDown")){
        alert("고객사를 선택해 주십시오.");
        return ;
    }
    
	switch (str) {
	case "search":	 //조회
	    
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		$("#st_buyer_code").val("");
// 		kepSearch(-1);
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpcl/excelSellerMpClCatalogList.do";
		document.forms.searchForm.submit();
		break;
	case "regImg":
		kepAddImage("IMG");
		break;
	case "regDesc":
		kepAddImage("DESC");
		break;
	case "reg": // 재고등록	
		btnEvent = "stockReg";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("재고품목으로 등록 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpcl/saveSellerMpClCatalogList.do","processForm",btnEvent); 	
		}
		break;
	
	}
}
//이미지등록
function kepAddImage(gbn){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.checkbox0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.contentForm.checkbox" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.checkbox0" ); 
            if(box.checked == true){
        		var fileName     = document.forms.contentForm.st_file_no.value;
        		var fileName2     = document.forms.contentForm.st_file_dir.value;
        		var fileName3     = document.forms.contentForm.st_file_no2.value;
        		var fileName4     = document.forms.contentForm.st_file_dir2.value;
        		var st_buyer     = document.forms.contentForm.st_buyer.value;
        		var st_buyer_item_no     = document.forms.contentForm.st_buyer_item_no2.value;
        		var st_img_status     = document.forms.contentForm.st_img_status.value;
            	if (fileName == "" && fileName2=="" ||fileName3==""&&fileName4==""){
            		alert("상품이미지를 선택하세요.");
            		return;
            	}
        		if(st_img_status  =="S"){
            		alert("상품이미지 등록요청건이 존재합니다.");
            		return;            			
        		}

            	query = st_buyer+"@@" + st_buyer_item_no+ "@@" + fileName +"@@" + fileName2+ "@@" + fileName3 +"@@" + fileName4;
            }
        }else{
        	for(var i = 0; i <tot_cnt; i++){
        		var box = eval("document.forms.contentForm.checkbox" + i);
        		if(box.checked == true){
            		var fileName     = document.forms.contentForm.st_file_no[i].value;
            		var fileName2     = document.forms.contentForm.st_file_dir[i].value;
            		var fileName3     = document.forms.contentForm.st_file_no2[i].value;
            		var fileName4     = document.forms.contentForm.st_file_dir2[i].value;
            		var st_buyer     = document.forms.contentForm.st_buyer[i].value;
            		var st_buyer_item_no     = document.forms.contentForm.st_buyer_item_no2[i].value;
            		var st_img_status     = document.forms.contentForm.st_img_status[i].value;
                	if (fileName == "" && fileName2==""){
                		alert(i+ "번째 상품이미지를 선택하세요.");
                		return;
                	}
            		if(st_img_status  =="S"){
                		alert("상품이미지 등록요청건이 존재합니다.");
                		return;            			
            		}
                	query += st_buyer+"@@" + st_buyer_item_no+ "@@" + fileName +"@@" + fileName2+ "@@" + fileName3 +"@@" + fileName4;
                	query += "|";
        		}

        	}
        }
        document.forms.processForm.st_query2.value = query;
        
        kepAjaxFormCall("/mpcl/saveSellerMpClCatalogImg.do","processForm","REQ_IMG");
    }

 	
}
// 조회
function kepSearch(curPage){
    if(isEmpty($("#st_buyer_code").val()) && (curPage >0 )){
        alert("고객사를 선택해 주십시오.");
        return ;
    }
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpcl/getSellerMpClCatalogList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "sellerMpClTranBuyerChoicePop": // 고객사 M
			popupSel = "sellerMpClTranBuyerChoicePop";
			openSearchPopup("/mpcl/getSellerMpClTranBuyerChoicePop.do", '?com_code='+$("#st_com_code").val(), "400,550,no");
			break;
		
		case "sellerMpClGoodsDetailInfoPop": // 품목정보상세
			popupSel = "sellerMpClGoodsDetailInfoPop";
			openSearchPopup("/mpcl/getSellerMpClGoodsDetailInfoPop.do", '?st_byit_comorg_code='+value1+'&st_item_no='+value2+'&st_contract_no='+value3+'&st_contract_seq='+value4+'&st_com_type=S', "850,330,no");
			break;
		
		case "sellerMpClCatalogImgPopList":
			popupSel = "sellerMpClCatalogImgPopList";
			openSearchPopup("/mpcl/getSellerMpClCatalogImgPopList.do", "?st_agent="+value1+"&st_buyer_item_no="+value2, "800,600,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "sellerMpClTranBuyerChoicePop") {	// 거래고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(kepMultiName(text,"@"));
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var tot_cnt  = $("#display_item_cnt").val();
	var chkGridValue = {};
	
	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr[0].length == 0){
		alert(" 재고등록 대상 품목을 선택하여 주십시요..!! ");
		return;	
	}
	
	if(btnEvent == "stockReg"){ //재고등록
		for(var i = 0; i < tot_cnt; i++){
	        var box = eval("document.forms.contentForm.checkbox"+i+"");
	        if(box !=null && box.checked == true){
	        	var st_buyer = $("form[name=contentForm]").find("input[name=st_buyer]").eq(i).val();
	        	var st_buyer_item_no2 = $("form[name=contentForm]").find("input[name=st_buyer_item_no2]").eq(i).val();
	        	var st_seller_item_no = $("form[name=contentForm]").find("input[name=st_seller_item_no]").eq(i).val();
	        	
	        	if(st_buyer != "KRDOOD0001"){
					alert(" 현재 재고품목등록은 두산중공업 고객사에 한하여 적용됩니다.  ");
					return false;
				}
	        	
	        	if(st_seller_item_no == ""){
	        		st_seller_item_no = st_buyer_item_no2;
				}	 
	        }
	    }
	}
	
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if (msg != ""){
		alert("이미지 등록요청이 완료 되었습니다.");
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}
/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
} 
var g_row = "";
var g_gbn  = "";
function saveAttatchFile(a,b){
	g_row= b;
	g_gbn = "saveAttatchFile";
	var tot_cnt  = $("#display_item_cnt").val();
	var fileName = "";
	if(eval(tot_cnt) < 2){
		fileName = document.forms.contentForm.files.value;
	}else{
		fileName =document.forms.contentForm.files[b].value;
	}
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		if(eval(tot_cnt) < 2){
			document.forms.contentForm.files.select();
			document.selection.clear();
		}else{
			document.forms.contentForm.files[b].select();
			document.selection.clear();
		}
		return;
	}
	$("#contentForm").attr("target","account_work");
	$("#contentForm").attr("action","/mpcl/saveSellerMpClCatalogImgFile.do").submit();
}
function saveAttatchDetailFile(a,b){
	g_row= b;
	g_gbn = "saveAttatchDetailFile";
	var tot_cnt  = $("#display_item_cnt").val();
	var fileName = "";
	if(eval(tot_cnt) < 2){
		fileName = document.forms.contentForm.files2.value;
	}else{
		fileName =document.forms.contentForm.files2[b].value;
	}
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		if(eval(tot_cnt) < 2){
			document.forms.contentForm.files2.select();
			document.selection.clear();
		}else{
			document.forms.contentForm.files2[b].select();
			document.selection.clear();
		}
		return;
	}
	$("#contentForm").attr("target","account_work");
	$("#contentForm").attr("action","/mpcl/saveSellerMpClCatalogDetailImgFile.do").submit();
}
function upSet(msg){
	loader_obj("N");
	var tot_cnt  = $("#display_item_cnt").val();
	if(eval(tot_cnt) < 2){
		var file = msg.split("@@");
		if(g_gbn=="saveAttatchDetailFile"){
			document.forms.contentForm.st_file_no2.value = file[1];
			document.forms.contentForm.st_file_dir2.value = file[0];			
		}else{
			document.forms.contentForm.st_file_no.value = file[1];
			document.forms.contentForm.st_file_dir.value = file[0];			
		}
		var box = eval("document.forms.contentForm.checkbox0");
		box.checked =true;
	}else{
		var file = msg.split("@@");
		if(g_gbn=="saveAttatchDetailFile"){
			document.forms.contentForm.st_file_no2[g_row].value =file[1];
			document.forms.contentForm.st_file_dir2[g_row].value = file[0];						
		}else{
			document.forms.contentForm.st_file_no[g_row].value =file[1];
			document.forms.contentForm.st_file_dir[g_row].value = file[0];			
		}
	    var box = eval("document.forms.contentForm.checkbox" + g_row);
	    box.checked =true;
	}
}
function setImageView(img_dr,img_name,gbn){

	window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');
	
}

</script>
</html>

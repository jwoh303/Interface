<%--
**********************************************
* 메뉴 : 상품검색 > 유니폼검색
* 화면 : 유니폼검색
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2020-09-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
</head>
<% 
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

	//조회조건
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");
	
	String SessionComCode = "";
  
	String img_view_flag   = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
	}  
	 
	//SLOGIC-BEGIN(P06-0000036)
	 String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	 String p060000036 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000036","COL02_DATA", request); // 권한별URL
	 if (p060000036 == null){
	 	p060000036 = defaultUrl;
	 }else if ("".equals(p060000036)){
	 	p060000036 = defaultUrl;
	 }
	 //SLOGIC-END
	 
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	//SLOGIC-END
	
%> 

<body onload="kep_onload_view()">

<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<div id="container2">
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>유니폼 검색</h3><!-- 유니폼 검색 -->
	<div id="searchBtnA">
     	<span class="btn_search" title="조회" ><a href="javascript:doAction('search','');"><%=CommonLang.get("HTITLE7")%></a></span> <!-- 조회 -->
		<span class="btn_reset" title="초기화" ><a href="javascript:doAction('reload','');"><%=CommonLang.get("HTITLE8")%></a></span><!-- 초기화 -->
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
		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7")%></caption>	<!-- 조회 -->
				<colgroup>
				    <col width="12%" />
				    <col width="38%" />
				</colgroup>
				
				<tbody>
				<tr>
					<th><%=CommonLang.get("HTITLE13")%></th>	<!-- 품목명 -->
					<td>
					<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:90%;" value="<%=st_description%>"  onKeyDown="kepEnter()">
					</td>

					<th><%=CommonLang.get("HTITLE15")%></th>	<!-- 제조사 -->
					<td>
						<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:90%;" value="<%=st_maker_name%>"  onKeyDown="kepEnter()">
					</td>
				</tr>
				</tbody>
			</table>
		</div>		
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595")%></option>	<!-- 건 -->
				<option value = "15" <%if ("15".equals(onepagerow)) {%>selected<%} %>>15<%=CommonLang.get("HTITLE595")%></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595")%></option>
				<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25<%=CommonLang.get("HTITLE595")%></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595")%></option> 
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100<%=CommonLang.get("HTITLE595")%></option> 
			</select>
      	</span>      
       <span class="fr"><%=CommonLang.get("HTITLE594")%></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" >
			<colgroup>
	            <col width="4%" />
	            <col width="4%" />
	            <col width="*" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="15%" />
	        </colgroup>
	        <thead>
			<tr>
               <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>                
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
							
<%} %>
				</th> 
                <th scope="col"></th>
                <th scope="col">
                <%=CommonLang.get("HTITLE13")%></th>	<!-- 품목코드 / 품목명  -->
                <th scope="col"><%=CommonLang.get("HTITLE20")%> <!-- 원산지 /제조사 -->
                </th>
                <th scope="col"><%=CommonLang.get("HTITLE31") %></th>	<!-- 협력사/단위  -->
                <th scope="col"><%=CommonLang.get("HTITLE22")%></th>	<!-- 현단가 / 구매수량 --> 
			</tr>
	</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
			<tr>
				<td colspan="15" align="center" height = "50"> 
				<span><%=CommonLang.msg("MSG347")%></span>	<!-- 조회된 데이타가 없습니다. -->
				</td> 
			</tr>
<%
}else{
	Map<String,String> rowData = null;
	for (int j=0; j<_gridList.size(); j++) {
		rowData = _gridList.get(j);
		String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		
%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="font1_black1"  class="center">
						<input type="checkbox" name="lnCheck<%=j%>">	                   
					</td>
					<td title="이미지"> 
<% 
    	if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0"  id="st_image" name="st_image">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%> 
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>  
 
<%     }else{ %> 
             <a class="hyperLink"  href="javascript:getBigImage('<%=j %>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  id="st_image" name="st_image" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>  
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>  
 
<%     }

%>				
                   <input type="hidden" name="st_grp_code<%=j %>" id="st_grp_code<%=j %>" value="<%=CommonUtil.nvl(rowData.get("GRP_CODE"))%>"><!-- 대표코드 -->
					<input type="hidden" name="st_imgfile_dir<%=j %>"  id="st_imgfile_dir<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>"><!-- 이미지폴더 -->
					<input type="hidden" name="st_imgfile_name<%=j %>"  id="st_imgfile_name<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"><!-- 이미지파일명 -->
					</td>
                    <td title="품목명" class="left">&nbsp;<%=rowData.get("DESCRIPTION")%><br>
	                    &nbsp;<select id="st_size<%=j %>" name="st_size<%=j %>" style="width:30%; height:20px" onchange="getPriceAgent(<%=j %>)"></select>
					<% if(rowData.get("PRODUCT_CLOSE_FLAG").equals("Y")) { %>&nbsp;
					<% }else if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>&nbsp;
					 <% } else { %> <br>&nbsp;&nbsp;<font color="green"><%=CommonLang.get("HTITLE597")%><%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font><% } %>	<!-- (재 판매일 : -->
                    </td> 
					<td class="center" title="원산지 /제조사 ">
						<%=rowData.get("ORIGIN_TEXT")%>/<%=rowData.get("MAKER_NAME")%>
					</td>
					 <td class="center"  title="협력사/단위">
					 <a class="hyperLink" id="st_agent<%=j %>" >-</a><br><%=rowData.get("UNIT_MEASURE")%>  
					</td>
		          	<td class="right"  title="현단가 / 구매수량">
		          	<span id="st_unit_price<%=j %>">-</span><br>	
		            <input type="text" name="st_order_qty" style="width:70%;text-align:right;" id="line" class = "input_type_text" value = "1">
		            </td> 
				</tr> 
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598")%> <%=total_cnt %><%=CommonLang.get("HTITLE599")%></span> 		<!-- 총건 -->						<!-- [ 총  건 ] --> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04" title="장바구니담기" >
					<a href="javascript:doAction('cartItem','');"><%=CommonLang.get("HTITLE11") %></a>	<!-- 장바구니담기 -->
				</span>				
            </div>
        </div> 
</form>
 


<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" /> 
</form>

<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	 
</form>
 
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<div id="confirmArea"   style="display:none;">
   <div  style="position:absolute; left:50%; margin-left:-300px; top:400px; width: 600px; height:100px; text-align:center; background-color: #fff;  z-index:999;  border: 0px; padding:50px 0;">
   	<div style="font-size:16px;" ><h4  id="confirmMsg"></h4></div>
 		<!-- 버튼영역 -->
		<div style="text-align:center; margin-top:40px"> 
				<span class="btn_04">
					<a href="javascript:kep_confrim_search();"><%=CommonLang.get("HTITLE591") %><!-- 계속검색 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();"><%=CommonLang.get("HTITLE592") %><!-- 이동 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_cancel();"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></a>
				</span>
			</div>					
         </div>
    	<div style="position:absolute; top:0; width:100%; height:100%; display:table-cell; background-color:#03F; z-index:99; background-color:#000; opacity: 0.4;   "></div>
</div>
<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	var com_code = $("#st_com_code").val();
	for(var i = 0; i < <%=total_cnt%>; i++){
		var grp_code = $("#st_grp_code"+i).val();
		//콤보 데이터 셋팅
		kepAjaxCommonQueryIdSearchTwoCombo('st_size'+i,'buyer.mdcm.getUniformSizeSelect',com_code,grp_code,'SEL','');
	}
}

var st;
//기능함수
function doAction(str , gubun) {
	switch (str) {
	case "search":	 //조회 
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		document.forms.searchForm.st_description.value = "";
		document.forms.searchForm.st_maker_name.value = "";

		jspTableClean("table_list");
		break; 
	case "cartItem": // 장바구니 담기
		saveProcess("C");
		break;  		
	}
}

// 조회
function kepSearch(curPage){	
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmUniformSearchList.do").submit();   
} 

/*
 * 장바구니담기 C
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        //  목록에 표시된 상품이 없습니다.
    	alert("<%=CommonLang.msg("MSG16")%>");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.contentForm.lnCheck" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    
    if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17")%>");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
            	var st_size = document.forms.contentForm.st_size0.value;
            	if(st_size == ""){ //size선택 안한 것 있는 경우
            		alert("1번째 상품 사이즈가 선택되지 않았습니다.");
            		document.forms.contentForm.st_size0.focus();
            		return ;
            	}
            	var arr = st_size.split('@');
            	var order_qty     = document.forms.contentForm.st_order_qty.value;
                var st_agent_flag = arr[0];
		        var st_item_no   = arr[1];
				var st_order_qty = document.forms.contentForm.st_order_qty.value;
				var st_agent     = arr[0];
				var contract_no  = arr[2];
				var contract_seq = arr[3];
				var byit_comorg_code = arr[4];

                var key_flag      = st_agent_flag.substr(0,2); 
                if(st_agent_flag == "MULTI_AGENT"){
                    var st_key_flag = "Y";
                }else{
                    var st_key_flag = "N";
                }
                if (flag == "C"){ // 장바구니
	                if(!kepChkDecimal(order_qty,3)){
	                	//  첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    
	                    alert( "<%=CommonLang.msg("MSG18")%>");
	                    document.forms.contentForm.st_order_qty.focus();
	                    return;
	                }
	                else if(st_key_flag == "Y"){
	                    // 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     
	                	alert( "<%=CommonLang.msg("MSG19")%>");
	                    box.checked = false;
	                    return;
	                }else{
						query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+"&&";
					}
                }
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);

                if(box.checked == true){
                	var st_size = eval("document.forms.contentForm.st_size"+i+".value");
                	if(st_size == ""){ //size선택 안한 것 있는 경우
                		alert((i+1)+"번째 상품 사이즈가 선택되지 않았습니다.");
                		eval("document.forms.contentForm.st_size"+i).focus();
                		return ;
                	}
                	var arr = st_size.split('@');
                	var order_qty     = document.forms.contentForm.st_order_qty[i].value;
                    var st_agent_flag = arr[0];
    				var st_item_no   = arr[1];
    				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;
    				var st_agent     = arr[0];
    				var contract_no  = arr[2];
    				var contract_seq = arr[3];
    				var byit_comorg_code = arr[4];
                    var key_flag      = st_agent_flag.substr(0,2); 
                    if(st_agent_flag == "MULTI_AGENT"){
                        var st_key_flag = "Y";
                    }else{
                        var st_key_flag = "N";
                    }
                    
                    if (flag == "C"){ // 장바구니
	                    if(!kepChkDecimal(order_qty,3)){
	                    	//  번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.    
	                        alert( i+"<%=CommonLang.msg("MSG20")%>");
	                        document.forms.contentForm.st_order_qty[i].focus();
	                        return;
	                    }
	                    else if(st_key_flag == "Y"){
	                    	// 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     
	                        alert( "<%=CommonLang.msg("MSG19")%>");
	                        box.checked = false;
	                        return;
	                    }else {
						  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
						  query += "&&";
						}
                    }
                }
            }
        }
    }	 
     
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	kep_showConfirm(); 
}
 


function kep_showConfirm(){
	
	
	var runFlag = $("#confirm1").val();
	
    var msg = "";
    if (runFlag == "CsaveProcess"){
    	msg = "장바구니";
    }

    $('body,html').animate({
		scrollTop: 0
	}, 100);
	
    if (runFlag == "CsaveProcess"){
    	// 으로 저장하시고 보기 화면으로 이동하시겠습니까?
		$("#confirmMsg").text(msg+"<%=CommonLang.msg("MSG348")%>"+"\n"+msg+"<%=CommonLang.msg("MSG349")%>");
		$("#confirmArea").show(); 
    }
}

// 계속검색
function kep_confrim_search(){ 
	$("#confirm4").val("search");
	$("#confirmArea").hide(); 
	runProcess();
}

// 이동
function kep_confirm_location(){ 
	$("#confirm4").val("location");
	$("#confirmArea").hide(); 
	runProcess();
}

// 취소
function kep_confirm_cancel(){ 
	$("#confirm4").val("");
	$("#confirmArea").hide(); 
}
/** 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(C:장바구니)
 
 */
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	
	if (gubun == "CsaveProcess"){ // 장바구니 
		document.forms.processForm.st_use_flag.value = "C"; // 장바구니
		document.forms.processForm.st_query2.value = query;		
		document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm",gubun); 
	}
}
  

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	var confirm4 = $("#confirm4").val();

	if(sMsg == "CREATE_OK"){
    	
        if(pMethod == "CsaveProcess")
        {
        	// 장바구니에 저장되었습니다.   
           alert("<%=CommonLang.msg("MSG22")%>");
           
           if (confirm4 == "search"){ 
         	  // 계속검색클릭 
            	 // 처리후 재조회
            	 kepSearch($("#curPage").val());           	   
           }else{     
        	   
        	   $('#locationForm').attr("action", "<%=p060000036%>").submit();    
        	 
           }
       } 
        
      }else{
         if(pMethod == "CsaveProcess"){
        	 //품목코드 ( ) 은 이미 장바구니에 저장된 항목입니다.  
            alert("<%=CommonLang.msg("MSG352")%>" + sMsg + "<%=CommonLang.msg("MSG353")%>");	
          }else if(pMethod == "CsaveProcess"){
        	  
          }
     	 // 처리후 재조회
     	 kepSearch($("#curPage").val());
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "CsaveProcess"){ 
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 alert("<%=CommonLang.msg("MSG26")%>"); 
	}
} 
//상품 큰이미지
function getBigImage(index){
	var st_imgfile_dir= $("#st_imgfile_dir"+index).val();
	var st_imgfile_name= $("#st_imgfile_name"+index).val();
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", st_imgfile_dir, st_imgfile_name);
}

//선택된 사이즈의 협력사,단가 정보를 가져오는 함수
function getPriceAgent(index){

	var id = "st_size"+index;
	var arr = $("#"+id).val().split("@");

	if(arr == ""){ //사이즈 선택하지 않는 경우
		$("#st_unit_price"+index).html("-");
		$("#st_agent"+index).html("-");
		$("#st_agent"+index).removeAttr("href");
	}
	else{
		var agent = arr[0];
		var agent_name = arr[6];
		var unit_price = AddCommas(arr[5]);
		//이미지 경로
		var st_imgUpload_path = "<%=CommonUtil.realImgS3UploadPath%>"; 
		var st_image = "";
		//품목 이미지 존재 여부
		if(arr[7] == ""){
			st_image ="/resources/images/noimage.gif"; 	
		}else{
			st_image = st_imgUpload_path+"/"+arr[7]+"/"+arr[8];
		}
		$("#st_unit_price"+index).html(unit_price);
		$("#st_agent"+index).html(agent_name);
		$("#st_agent"+index).attr("href","javascript:getAgentDisplayPop('"+agent+"')");
		//이미지 경로 셋팅
		$("#st_imgfile_dir"+index).val(arr[7]);
		$("#st_imgfile_name"+index).val(arr[8]);
		$("img[id=st_image]").eq(index).attr("src",st_image);//이미지 변경
	}
}
//3자리 마다 , 를 찍어주는 함수
function AddCommas(number){
	return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",");
}
</script>
</html>

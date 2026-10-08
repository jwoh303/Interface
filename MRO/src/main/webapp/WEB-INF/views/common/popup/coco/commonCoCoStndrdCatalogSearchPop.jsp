<%--
**********************************************
* 메뉴 : 
* 화면 : 표준카달로그검색(CMS)
* 기능 : 
* 프로그램 ID : PG_90_C_900_36
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#commonCoCoStndrdCatalogSearchPop').attr("action", "/coco/getCommonCoCoStndrdCatalogSearchPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

function kepCustomEraser(code, name1, name2){
	var _code = "#" + code;
	var _name1 = "#" + name1;
	var _name2 = "#" + name2;
	$(_code).val("");
	$(_name1).val("");
	$(_name2).val("");
}

 //-->
</script> 
<body onload="">
<form name="commonCoCoStndrdCatalogSearchPop" id="commonCoCoStndrdCatalogSearchPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:794px; min-height: 100px;">
		<div id="popHeader">
        	<h1 class="title">표준카달로그검색(CMS)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div class="scrollArea mt10" style="height:678px">
				<h4 class="b">[ 매핑대상 ]</h4>
				<table  class="board_write" summary="사용자 대한 정보입력">
					<caption>LOGIN 정보</caption>
					<colgroup>
						<col width="18%" />
						<col width="32%" />
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<tbody> 
			    	  <tr>
						<th scope="row">고객사</th>
						<td scope="row">&nbsp;</td>
						<th scope="row">품목코드</th>
						<td scope="row">&nbsp;</td>
					  </tr>
					  <tr>
					  	<th scope="row">품목명</th>
						<td scope="row" ></td>
						<th scope="row">규격</th>
						<td scope="row">&nbsp;</td>
					  </tr>
					  <tr>
					  	<th scope="row">제조사명</th>
						<td scope="row">&nbsp;</td>
						<th scope="row">제조사코드</th>
						<td scope="row">&nbsp;</td>
					  </tr>
					  <tr>
						<th scope="row">매핑여부/Master코드</th>
						<td scope="row">&nbsp;</td>
						<th scope="row">미매핑 사유</th>
						<td scope="row">&nbsp;</td>
					  </tr>
					  <tr>
						<th scope="row">매핑여부/Master코드</th>
						<td scope="row">&nbsp;</td>
						<th scope="row">미매핑 사유</th>
						<td scope="row">&nbsp;</td>
					  </tr>
			    	</tbody>
			    </table>
	        	
	        	<div class="fl">
					<h4 class="b">[ 검색조건 ]</h4>
	        	</div>
	        	<div class="fr">
	            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>
	            	<span class="btn_reset"><a href="javascript:kepSearch();">초기화</a></span>
	            </div>
	            <br>
	            <!--조회영역-->
	            <div id="cont_searchA" style="margin-top: 10px;">
	            	<table class="cont_t_list01" style="width:100%">
							<caption>표준카달로그검색(CMS) 리스트</caption>
							<colgroup>
								<col width="18%" />
								<col width="32%" />
								<col width="15%" />
								<col width="*" />
							</colgroup>
							<tbody>
							<tr>
								<td>제조사/제조사코드</td>
								<td>
									<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:51%" value="" readonly>
									<input type="hidden" name="st_maker_code" id="st_maker_code" style="width:80%" value="">
									<a href="javascript:alert('준비 중 입니다.');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_maker_name','st_maker_code');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<td>Master코드</td>
								<td>
									<input type="text" class="input_type_text" id="st_cmscatlg" name="st_cmscatlg" style="width:80%;" maxlength="25" value="" onkeydown="kepEnter()" onKeyUp="ToUpper(this)" style="ime-mode:active" />
								</td>
							</tr>
							<tr>
								<td>표준카테고리</td>
								<td>
									<input type="text" class="input_type_text" name="st_category_path" id="st_category_path" style="width:51%" value="" readonly>
									<input type="hidden" name="st_categ_id" id="st_categ_id" style="width:80%" value="">
									<input type="hidden" name="st_mast_check" id="st_mast_check" style="width:80%" value="">
									<a href="javascript:alert('준비 중 입니다.');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepCustomEraser('st_category_path','st_categ_id','st_mast_check');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<td>SG</td>
								<td>
									<input type="text" class="input_type_text" id="st_sg_name" name="st_sg_name" style="width:80%;" maxlength="25" value="" onkeydown="kepEnter()" style="ime-mode:active" />
								</td>
							</tr>
							<tr>
								<td>품목명</td>
								<td>
									<input type="text" class="input_type_text" id="st_description_loc" name="st_description_loc" style="width:80%;" maxlength="25" value="" onkeydown="kepEnter()" style="ime-mode:active" />
								</td>
								<td>규격</td>
								<td>
									<input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:80%;" maxlength="25" value="" onkeydown="kepEnter()" style="ime-mode:inactive" />
								</td>
							</tr>
							<tr>
								<td>결과내 재검색 품명</td>
								<td>
									<input type="text" class="input_type_text" id="st_description_loc_2" name="st_description_loc_2" style="width:80%;" maxlength="25" value="" onkeydown="kepEnter()" style="ime-mode:active" />
								</td>
								<td>결과내 재검색 규격</td>
								<td>
									<input type="text" class="input_type_text" id="st_specification_2" name="st_specification_2" style="width:80%;" maxlength="25" value="" onkeydown="kepEnter()" style="ime-mode:active" />
								</td>
							</tr>
						</tbody>
					</table>
	            </div>
				<div class="fl">
					<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		               	<label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="pg_row" style="width: 70px;" >
							<option value="10" selected>10건</option>
							<option value="20">20건</option>
							<option value="30">30건</option>
							<option value="40">40건</option>
							<option value="50">50건</option>
						</select>
					</span>
	        	</div>
	        	<span class="fr">총건수 0</span>
	            <br>
           	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>표준카달로그검색(CMS) 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">부서코드</th> 
                            <th scope="col">요약 부서명</th> 
                            <th scope="col">상세 부서명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "180">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=_tmp.get("CODE")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=_tmp.get("TEXT1")%></a>
					   </td>
						<td>
								<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=CommonUtil.nvl(_tmp.get("TEXT2"))%></a>
						</td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>
	        </div>
	        
	        <div class="btnArea" style="margin-bottom:0; margin-top: 10px;">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:alert('준비 중 입니다.');" >매핑</a></span>
					<span class="btn_02 mr04"><a href="javascript:alert('준비 중 입니다.');" >미매핑</a></span>
					<span class="btn_02 mr04"><a href="javascript:self.close()" >닫기</a></span>
				</span>                	
			</div>
		</div>
	</div>
</form> 
</body>
</html>

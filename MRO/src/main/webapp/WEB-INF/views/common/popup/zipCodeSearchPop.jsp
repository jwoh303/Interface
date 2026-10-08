<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<script type="text/javascript">
	/**
	 * ajax 시군구 목록 조회
	 */
	function setSiGunGu(){
		kepAjaxFormCall("/common/sigunguList.do","myzip","SIGUNGU_LIST");
	}
	
	function setSearchflag(){
		var flag = $("input[name=st_search_flag]:checked").val();
		if(flag == "DO"){
			$("#DOSearch").css("display","block");
			$("#JISearch").css("display","none");
			$("#BDSearch").css("display","none");
			
			$("input[name=search1]:eq(1)").val("");
			$("input[name=search2]:eq(1)").val("");
			$("input[name=search1]:eq(2)").val("");
			$("input[name=search2]:eq(2)").val("");
		}else if(flag == "JI"){
			$("#DOSearch").css("display","none");
			$("#JISearch").css("display","block");
			$("#BDSearch").css("display","none");
			
			$("input[name=search1]:eq(0)").val("");
			$("input[name=search2]:eq(0)").val("");
			$("input[name=search1]:eq(2)").val("");
			$("input[name=search2]:eq(2)").val("");
		}else if(flag == "BD"){
			$("#DOSearch").css("display","none");
			$("#JISearch").css("display","none");
			$("#BDSearch").css("display","block");
			
			$("input[name=search1]:eq(0)").val("");
			$("input[name=search2]:eq(0)").val("");
			$("input[name=search1]:eq(1)").val("");
			$("input[name=search2]:eq(1)").val("");
		}
	}
	
	function zipcode_search(){
		var si_type = $("#st_si_select option:selected").val();
		var gu_type = $("#st_gu_select option:selected").val();
		var flag = $("input[name=st_search_flag]:checked").val();
		
		$("input[name=st_search_flag_nm]").val(flag);
		$("input[name=st_si_select_nm]").val(si_type);
		$("input[name=st_gu_select_nm]").val(gu_type);
		
		if(si_type == "ALL"){
			// '시도'를 선택하여 주십시오.
			alert("<%=CommonLang.msg("MSG411") %>");
			$("#st_si_select").focus();
			return;
		}
		if(gu_type == "ALL"){
			//'시군구'를 선택하여 주십시오.
			alert("<%=CommonLang.msg("MSG412") %>");
			$("#st_gu_select").focus();
			return;
		}
		if(flag == "DO"){
			if($("input[name=search1]:eq(0)").val() == "" || $("input[name=search1]:eq(0)").val() == null){
				//도로명을 입력하여 주십시요
				alert("<%=CommonLang.msg("MSG413") %>");
				$("input[name=search1]:eq(0)").val("");
				$("input[name=search1]:eq(0)").focus();
				return;
			}
			if($("input[name=search2]:eq(0)").val() == "" || $("input[name=search2]:eq(0)").val() == null){
				//건물번호를 입력하여 주십시요
				alert("<%=CommonLang.msg("MSG414") %>");
				$("input[name=search2]:eq(0)").val("");
				$("input[name=search2]:eq(0)").focus();
				return;
			}
			$("input[name=st_search1]").val($("input[name=search1]:eq(0)").val());
			$("input[name=st_search2]").val($("input[name=search2]:eq(0)").val());
		}else if(flag == "JI"){
			if($("input[name=search1]:eq(1)").val() == "" || $("input[name=search1]:eq(1)").val() == null){
				//동(읍/면)을 입력하여 주십시요
				alert("<%=CommonLang.msg("MSG415") %>");
				$("input[name=search1]:eq(1)").val("");
				$("input[name=search1]:eq(1)").focus();
				return;
			}
			if($("input[name=search2]:eq(1)").val() == "" || $("input[name=search2]:eq(1)").val() == null){
				//지번을 입력하여 주십시요
				alert("<%=CommonLang.msg("MSG416") %>");
				$("input[name=search2]:eq(1)").val("");
				$("input[name=search2]:eq(1)").focus();
				return;
			}
			$("input[name=st_search1]").val($("input[name=search1]:eq(1)").val());
			$("input[name=st_search2]").val($("input[name=search2]:eq(1)").val());
		}else if(flag == "BD"){
			if($("input[name=search1]:eq(2)").val() == "" || $("input[name=search1]:eq(2)").val() == null){
				//건물명을 입력하여 주십시요
				alert("<%=CommonLang.msg("MSG417") %>");
				$("input[name=search1]:eq(2)").val("");
				$("input[name=search1]:eq(2)").focus();
				return;
			}
			$("input[name=st_search1]").val($("input[name=search1]:eq(2)").val());
			$("input[name=st_search2]").val($("input[name=search2]:eq(2)").val());
		}
		
		kepAjaxFormCall("/common/zipCodeSearchList.do","myzip","ZIP_SEARCH");
	}
	
	/**
	* ajax 공통 호출후 성공시 처리 함수
	*/ 
	function kepAjaxSuccess(pMethod , response){
		if(pMethod == "ZIP_SEARCH"){
			var zipcodeList = response.data;
			
			$(".cont_t_list02 tbody tr").remove();
			if(zipcodeList.length > 0){
				$.each(zipcodeList, function(index, value){
					var zipcode_building_nm = zipcodeList[index].BUILDING_NM == "null" || zipcodeList[index].BUILDING_NM == null ? "" : zipcodeList[index].BUILDING_NM;
					var strTag = "";
					strTag   = "<tr>";
					strTag += "<td class=\"left\">";
					strTag += "&nbsp;<a href=\"#imsi\" onclick=\"javascript:setReturn('" + zipcodeList[index].ZIP_CODE + "', '" + zipcodeList[index].BUILDING_MNG_NO + "', '" + zipcodeList[index].SIDO + "', '" + zipcodeList[index].GUGUN + "', '" + zipcodeList[index].ROAD_NM + "', '" + zipcodeList[index].BUILDING_NO + "', '" + zipcode_building_nm + "', '" + zipcodeList[index].DONG + "');\">";
					strTag += "[" + zipcodeList[index].ZIP_CODE + "]  " + zipcodeList[index].SIDO + " " + zipcodeList[index].GUGUN + " " + zipcodeList[index].ROAD_NM + " " + zipcodeList[index].BUILDING_NO + " (" + zipcodeList[index].DONG + ", " + zipcode_building_nm + ") <br/>";
					strTag += zipcodeList[index].SIDO + " " + zipcodeList[index].GUGUN + " " + zipcodeList[index].DONG + " " + zipcodeList[index].JIBUN;
					strTag += "</a>";
					strTag += "</td>";
					strTag += "</tr>";
					$(".cont_t_list02 tbody").append(strTag);
				});
			}else{
				//조회된 데이타가 없습니다.
				$(".cont_t_list02 tbody").append("<tr bgcolor=\"#FFFFFF\"><td align=\"center\" height = \"230\"><span class=\"font1\"><%=CommonLang.msg("MSG347") %></span></td></tr>");
			}
			
		}
		if(pMethod == "SIGUNGU_LIST"){
			var sigunguList = response.sigungu_data;
			
			$("#st_gu_select option").remove();
			$("#st_gu_select").append("<option value=\"ALL\">-- 선택 --</option>");
			$.each(sigunguList, function(index, value){
				$("#st_gu_select").append("<option value=\"" + sigunguList[index].TEXT2 + "\">" + sigunguList[index].TEXT2 + "</option>");
			});
		}
	}

	/**
	* ajax 공통 호출후 에러시 처리 함수
	*/
	function  kepAjaxError(pMethod , response) {
		//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		alert("<%=CommonLang.msg("MSG418") %>  "); 
	}
	
	function kepEnter() {	
		if (event.keyCode == 13) { 
			zipcode_search();
		}
	}
	
	/**
	* 선택 주소값을 리턴한다.
	* @param str_zipcode : 우편번호
	* @param str_zip_key : 관리번호
	* @param str_si : 시도
	* @param str_gu : 구군
	* @param str_do : 도로명
	* @param str_bd : 건물 번호
	* @param str_bdnm : 건물명
	* @param str_dong : 동
	**/
	function setReturn(str_zipcode, str_zip_key, str_si, str_gu, str_do, str_bd, str_bdnm, str_dong)
	{ 
	  opener.setZipPopupReturn(str_zipcode, str_zip_key, str_si, str_gu, str_do, str_bd, str_bdnm, str_dong);
	  this.close();
	}
	
</script> 
<body>
	<form name="myzip"  id="myzip" method="post">
		<input type="hidden" name="st_search_flag_nm">
		<input type="hidden" name="st_si_select_nm">
		<input type="hidden" name="st_gu_select_nm">
		<input type="hidden" name="st_search1">
		<input type="hidden" name="st_search2">
   
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE343") %><!-- 우편번호 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
         <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:zipcode_search();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div> 
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>우편번호 리스트</caption>
						<colgroup>
							<col width="15%" />
                            <col width="35%" />
							<col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td colspan="4"> 
								<input type="radio" class="Noborder"  name="st_search_flag" value="DO" onClick="setSearchflag();"> <%=CommonLang.get("HTITLE556") %><!-- 도로명+건물번호 -->
								<input type="radio" class="Noborder"  name="st_search_flag" value="JI" onClick="setSearchflag();" checked> <%=CommonLang.get("HTITLE557") %><!-- 동(읍/면)+지번 -->
								<input type="radio" class="Noborder"  name="st_search_flag" value="BD" onClick="setSearchflag();"> <%=CommonLang.get("HTITLE558") %><!-- 건물명(아파트명) -->
                            </td>
						</tr>
						<tr>
							<td><%=CommonLang.get("HTITLE559") %><!-- 시도 --></td>
							<td>
								<select name="st_si_select" id="st_si_select" onchange="javascript:setSiGunGu();">
									<option value="ALL">-- <%=CommonLang.get("HTITLE178") %><!-- 선택 --> --</option>
									<c:if test="${sido_data ne null && fn:length(sido_data) > 0 }">
										<c:forEach var="item" items="${sido_data}" varStatus="status">
											<option value="${item.TEXT1 }">${item.TEXT1 }</option>
										</c:forEach>
									</c:if>
								</select>
                            </td>
							<td><%=CommonLang.get("HTITLE560") %><!-- 시군구 --></td>
							<td> 
								<select name="st_gu_select" id="st_gu_select">
									<option value="ALL">-- <%=CommonLang.get("HTITLE178") %><!-- 선택 --> --</option>
								</select>
                            </td>
						</tr>
						<tr>
							<td colspan="4"> 
								<div id="DOSearch" style="display:none;">
								  <table cellspacing="0" cellpadding="0" border="0" width="100%">
								  	<colgroup>
										<col width="15%" />
			                            <col width="35%" />
										<col width="15%" />
			                            <col width="*" />
									</colgroup>
									<tbody>
									<tr>
										<td align="left"><%=CommonLang.get("HTITLE714") %><!-- 도로명 --></td>
										<td align="left"><input type="text" name="search1" style="width:80%;" class="input_type_text" />&nbsp;+</td>
										<td align="left"><%=CommonLang.get("HTITLE715") %><!-- 건물번호 --></td>
										<td align="left"><input type="text" name="search2" style="width:80%;" onkeypress="javascript:kepEnter();" class="input_type_text" /></td>
									</tr>
									<tr>
										<td align="left" colspan="4">
											<%=CommonLang.get("HTITLE719") %><!-- * 예)강남대로 331 -> '서울특별시''서초구' 선택 후 강남대로(도로명) + 331(건물번호) --><br><br>
											<font color="#666666"><%=CommonLang.get("HTITLE716") %><!-- * 새주소가 검색되지 않는 경우는 행정안전부 새주소안내시스템(http://www.juso.go.kr)에서 확인하시기 바랍니다. --></font>
										</td>
									</tr>
									</tbody>
								  </table>
								</div>
								<div id="JISearch" style="display:block;">
								  <table cellspacing="0" cellpadding="0" border="0" width="100%">
									<colgroup>
										<col width="15%" />
			                            <col width="35%" />
										<col width="15%" />
			                            <col width="*" />
									</colgroup>
									<tbody>
									<tr>
										<td align="left"><%=CommonLang.get("HTITLE561") %><!-- 동(읍/면) --></td>
										<td align="left"><input type="text" name="search1" style="width:80%;" class="input_type_text" />&nbsp;+</td>
										<td align="left"><%=CommonLang.get("HTITLE562") %><!-- 지번 --></td>
										<td align="left"><input type="text" name="search2" style="width:80%;" onkeypress="javascript:kepEnter();" class="input_type_text" /></td>
									</tr>
									<tr>
										<td align="left" colspan="4">
											<%=CommonLang.get("HTITLE563") %><!-- * 예)서초동 1337-32 -> '서울특별시''서초구' 선택 후 서초동(동명) + 1337-32(지번) --><br><br>
											<font color="#666666"><%=CommonLang.get("HTITLE716") %><!-- * 새주소가 검색되지 않는 경우는 행정안전부 새주소안내시스템(http://www.juso.go.kr)에서 확인하시기 바랍니다. --></font>
										</td>
									</tr>
								  </table>
								</div>
								<div id="BDSearch" style="display:none;">
								  <table cellspacing="0" cellpadding="0" border="0" width="100%">
									<colgroup>
										<col width="15%" />
			                            <col width="*" />
									</colgroup>
									<tbody>
									<tr>
										<td align="left"><%=CommonLang.get("HTITLE717") %><!-- 건물명 --></td>
										<td align="left"><input type="text" name="search1" style="width:80%;" onkeypress="javascript:kepEnter();" class="input_type_text" />&nbsp;
											<input type="hidden" name="search2" ></td>
									</tr>
									<tr>
										<td align="left" colspan="4">
											<%=CommonLang.get("HTITLE718") %><!-- * 예)서초동 광일빌딩 -> '서울특별시''서초구' 선택 후 서초동 광일빌딩(건물명) --><br><br>
											<font color="#666666"><%=CommonLang.get("HTITLE716") %><!-- * 새주소가 검색되지 않는 경우는 행정안전부 새주소안내시스템(http://www.juso.go.kr)에서 확인하시기 바랍니다. --></font>
										</td>
									</tr>
								  </table>
								</div>
                            </td>
						</tr>
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:338px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>우편번호 리스트</caption>
                    <colgroup>
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE345") %><!-- 주소 --></th> 
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>                  
        </div>
    </div>        
    <!--  팝업내용종료 --> 
</div>
</form>
</body>
</html>

<%--
**********************************************
* 메뉴 : 회원가입>협력회원사 등록
* 화면 : 협력회원사 등록
* 기능 : 
* 프로그램 ID : PG_01_M_013_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-09
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
</head>
<body onload="kep_onload()">
<div class="wrap" >
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:set var="jqueryGbn"  value="Y"/>
	<%@ include file="/WEB-INF/views/common/include/mainHeader.jsp" %>
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	
	<!--내용 시작-->
	<div class="Subwrap">
		<!------------------------------------------------------------------------------------------------left-------------------------------------------------------------------------------------------------------------->
		<c:import charEncoding="utf-8" url="/main/mainLeft.do" >
			<c:param name="subNo" value="None"/>
		</c:import>
		<!------------------------------------------------------------------------------------------------left-------------------------------------------------------------------------------------------------------------->
		<div class="SubCenter" >
			<form name = "contentForm" id="contentForm" method = "post">
		 	<input type="hidden" id="id_check_flag" name="id_check_flag" value="N" />
		 	<input type="hidden" name="chkPassword" id="chkPassword" value="N" />
		 	
			<div class="CenterVisual_MemberJoin"></div>
			<div class="MentLocation"><img src="/resources/images/main/br_home.gif" alt=""> > 회원가입 > 협력회원사 등록하기 </div>
			<div class="CenterBody" >
				<h2> 협력회원사 가입</h2>
				<div class="MemberJoin" >
					<div><span class="FontBlue">Koreab2b.com</span>사이트를 이용하시려면, 먼저 회원사 등록을 하셔야 합니다. KeP는 고객사의 경쟁력 확중에 기여하고 있으며 시장에서도 KeP의 역할을 인정하고 있습니다.</div>
					<div class="h50"></div>
					<h3>협력회원사 등록 <span class="h3stext"><span class="FontRed">*</span> 필수 입력사항 입력해 주세요.</span></h3>
					
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="130px" />
							<col width="210px" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="FontRed">*</span> 회사명(국문)</th>
								<td><input type="text" id="st_com_name_loc" name="st_com_name_loc" title=""value=""  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width:98%"/></td>
								<th>회사명(영문)</th>
								<td><input type="text" id="st_com_name_eng" name="st_com_name_eng" title="" value="" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);"style="width:98%; ime-mode:disabled;" /></td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 사업자등록번호</th>
								<td>
									<input type="text" id="st_irs_no1" name="st_irs_no1" title="" size="4" value=""  maxlength="3" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />-
									<input type="text" id="st_irs_no2" name="st_irs_no2" title="" size="3" value=""  maxlength="2" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
									<input type="text" id="st_irs_no3" name="st_irs_no3" title="" size="6" value=""  maxlength="5" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
								</td>
								<th><span class="FontRed">*</span> 등록구분</th>
								<td>
									<label for="st_reg_type" class="hidden">등록구분</label>
									<select name="st_reg_type" id="st_reg_type" style="width:99%">										
									</select>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 업태</th>
								<td><input type="text" id="st_industry_type" name="st_industry_type" title="" value=""  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 종목</th>
								<td><input type="text" id="st_business_items" name="st_business_items" title="" value="" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" style="width:98%"/></td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 대표자명</th>
								<td><input type="text" id="st_ceo_name_loc" name="st_ceo_name_loc" title="" value=""  maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 설립년도</th>
								<td>
									<input type="text" id="establish_date" name="establish_date" title=""  maxlength="8" value=""  readonly style="width:82%;" />
									<input type="hidden" id="st_establish_date" name="st_establish_date" value="" />
									
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 대표전화번호</th>
								<td>
									<select id="st_tel_no1" name="st_tel_no1" style="width:50px;">
										<option value="02" >02</option>
										<option value="031">031</option>
										<option value="032">032</option>
										<option value="033" >033</option>
										<option value="041" >041</option>
										<option value="042" >042</option>
										<option value="043" >043</option>
										<option value="044" >044</option>
										<option value="051" >051</option>
										<option value="052" >052</option>
										<option value="053" >053</option>
										<option value="054" >054</option>
										<option value="055" >055</option>
										<option value="061" >061</option>
										<option value="062" >062</option>
										<option value="063" >063</option>
										<option value="064" >064</option>
										<option value="070" >070</option>
									<option value="0303" >0303</option>
									<option value="0502" >0502</option>
									<option value="0504" >0504</option>
									<option value="0505" >0505</option>
									<option value="0506" >0506</option>
									<option value="0507" >0507</option>
									</select> -
									<input type="text" id="st_tel_no2" name="st_tel_no2" title="" size="5" value=""  maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
									<input type="text" id="st_tel_no3" name="st_tel_no3" title="" size="5" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
								<th><span class="FontRed">*</span> KeP담당자</th>
								<td>
									<input type="text" id="st_kep_damdang_id" name="st_kep_damdang_id" title="" style="width:82%;" value=""  />
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 유통레벨</th>
								<td>
									<label for="st_biz_type" class="hidden">유통레벨</label>
									<select name="st_biz_type" id="st_biz_type" style="width:99%;">
									
									</select>
								</td>
								<th><span class="FontRed">*</span> 종업원 수</th>
								<td>
									<label for="st_emp_cnt" class="hidden">3명</label>
									<select name="st_emp_cnt" id="st_emp_cnt" style="width:99%;">
									
									</select>
								</td>
							</tr>
							<tr>
								<th>홈페이지 주소</th>
								<td colspan="3"><input type="text" id="st_hp_address" name="st_hp_address" title="" value="" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width:99%"/></td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 본사 주소</th>
								<td colspan="3">
									<input type="text" id="st_zip_code" name="st_zip_code" title="" style="width:21%" readonly value="" />
									<input type="hidden" id="st_zip_key" name="st_zip_key" value=""/>
									<input type="text" id="st_address" name="st_address" title=""  value="" readonly style="width:60%"/>
									<!-- <a href="javascript:doPop('zipcode', 'COM');"><span class="Joinbtn_Gray" title="우편번호" >우편번호찾기</span></a> -->		<!-- ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
									<a href="javascript:doPop('newzipcode', 'COM');"><span class="Joinbtn_Gray" title="우편번호" >우편번호찾기</span></a>
								</td>
							</tr>
							<tr>
								<th>본사 상세주소</th>
								<td colspan="3"><input type="text" id="st_address_dt" name="st_address_dt" title="" value="" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" style="width:99%"/></td>
							</tr>
						</tbody>
					</table>
					
					<div class="h50"></div>
					<h3>사용자정보 등록<span class="h3stext"><span class="FontRed">*</span> 필수 입력사항 입력해 주세요.</span></h3>
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="130px" />
							<col width="210px" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="FontRed">*</span> 담당자명</th>
								<td><input type="text" id="st_usr_name_loc" name="st_usr_name_loc" title="" value="" maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 담당자 ID</th>
								<td>
									<input type="text" id="st_user_id" name="st_user_id" title=""  onkeyup="kepToUpper('st_user_id');"  maxlength="20" value="" style="width:61%;ime-mode:disabled;"/>
									<a href="javascript:doAction('idCheck');"><span class="Joinbtn_Gray" title="중복검사">중복확인</span></a>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 비밀번호</th>
								<td>
									<input type="password" id="st_password" name="st_password" title="" maxlength="20" value="" onchange="doAction('pwdCheck')" style="width:76%;ime-mode:disabled;"/>
									<font color="#FF0000" title=" 1. 8자리 이상 사용해야 합니다.
 2. 혼합(영문자+숫자+특수문자) 사용해야 합니다.
 3. 변경주기는 90일 입니다.
 4. 아이디와 동일하게 사용할수 없습니다."><b>※규정</b></font>
								</td>
								<th><span class="FontRed">*</span> 비밀번호 확인</th>
								<td><input type="password" id="st_confirmpasswd" name="st_confirmpasswd" title="" maxlength="20"  value="" onchange="doAction('pwdCheck')" style="width:98%;ime-mode:disabled;"/></td>
							</tr>
							<tr>
							<th><span class="FontRed">*</span> 전화번호</th>
							<td>
								<select id="st_phone1" name="st_phone1" style="width:50px;">
									<option value="02" >02</option>
									<option value="031" >031</option>
									<option value="032" >032</option>
									<option value="033" >033</option>
									<option value="041" >041</option>
									<option value="042" >042</option>
									<option value="043" >043</option>
									<option value="044" >044</option>
									<option value="051" >051</option>
									<option value="052" >052</option>
									<option value="053" >053</option>
									<option value="054" >054</option>
									<option value="055" >055</option>
									<option value="061" >061</option>
									<option value="062" >062</option>
									<option value="063" >063</option>
									<option value="064" >064</option>
									<option value="070" >070</option>
									<option value="0303" >0303</option>
									<option value="0502" >0502</option>
									<option value="0504" >0504</option>
									<option value="0505" >0505</option>
									<option value="0506" >0506</option>
									<option value="0507" >0507</option>
								</select> -
								<input type="text" id="st_phone2" name="st_phone2" title="" size="5" value=""  maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />-
								<input type="text" id="st_phone3" name="st_phone3" title="" size="5" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							</td>
							<th><span class="FontRed">*</span>이메일</th>
							<td><input type="text" id="st_usr_email" name="st_usr_email" title="" value="" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" style="width:98%"/></td>
							</tr>
							<tr>
							<th><span class="FontRed">*</span> 핸드폰번호</th>
							<td>
								<select id="st_usr_mobile1" name="st_usr_mobile1" style="width:50px;">
									<option value="010" >010</option>
									<option value="011" >011</option>
									<option value="016" >016</option>
									<option value="017" >017</option>
									<option value="018" >018</option>
									<option value="019" >019</option>
								</select> -
								<input type="text" id="st_usr_mobile2" name="st_usr_mobile2" title="" size="5" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/> -
								<input type="text" id="st_usr_mobile3" name="st_usr_mobile3" title="" size="5" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							</td>
							<th><span class="FontRed">*</span> 팩스번호</th>
							<td>
								<select id="st_fax_no1" name="st_fax_no1" style="width:50px;">
									<option value="02" >02</option>
									<option value="031" >031</option>
									<option value="032" >032</option>
									<option value="033" >033</option>
									<option value="041" >041</option>
									<option value="042" >042</option>
									<option value="043" >043</option>
									<option value="044" >044</option>
									<option value="051" >051</option>
									<option value="052" >052</option>
									<option value="053" >053</option>
									<option value="054" >054</option>
									<option value="055" >055</option>
									<option value="061" >061</option>
									<option value="062" >062</option>
									<option value="063" >063</option>
									<option value="064" >064</option>
									<option value="070" >070</option>
									<option value="0303" >0303</option>
									<option value="0502" >0502</option>
									<option value="0504" >0504</option>
									<option value="0505" >0505</option>
									<option value="0506" >0506</option>
									<option value="0507" >0507</option>
								</select> -
								<input type="text" id="st_fax_no2" name="st_fax_no2" title="" size="3" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>  -
								<input type="text" id="st_fax_no3" name="st_fax_no3" title="" size="4" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 주소</th>
								<td colspan="3">
									<input type="text" id="st_usr_zip_code" name="st_usr_zip_code" title="" style="width:21%" readonly value="" />
									<input type="hidden" id="st_usr_zip_key" name="st_usr_zip_key" value=""/>
									<input type="text" id="st_usr_address" name="st_usr_address" title="" value="" readonly style="width:60%"/>
									<!-- <a href="javascript:doPop('zipcode', 'USR');"><span class="Joinbtn_Gray" title="우편번호" >우편번호찾기</span></a> -->	<!-- ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->	
									<a href="javascript:doPop('newzipcode', 'USR');"><span class="Joinbtn_Gray" title="우편번호" >우편번호찾기</span></a>
								</td>
							</tr>
							<tr>
							<th>상세 주소</th>
								<td colspan="3"><input type="text" id="st_usr_address_dt" name="st_usr_address_dt" title="" value="" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" style="width:98%"/></td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 납기담당자</th>
								<td><input type="text" id="st_de_emp_nm" name="st_de_emp_nm" title="" value="" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width:99%"/></td>
								<th><span class="FontRed">*</span> 핸드폰번호</th>
								<td>
									<select id="st_de_emp_tel1" name="st_de_emp_tel1" style="width:50px;">
									<option value="010" >010</option>
									<option value="011" >011</option>
									<option value="016" >016</option>
									<option value="017" >017</option>
									<option value="018" >018</option>
									<option value="019" >019</option>
									</select> -
									<input type="text" id="st_de_emp_tel2" name="st_de_emp_tel2" title="" size="3" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/> -
									<input type="text" id="st_de_emp_tel3" name="st_de_emp_tel3" title="" size="3" value="" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
								</td>
							</tr>
							<tr>
							<th >사번</th>
								<td colspan="3"><input type="text" id="st_user_com_id" name="st_user_com_id" title="" value="" maxlength="30" onkeyup="fnCheckInputByte(this, 30);" onchange="fnCheckInputByte(this, 30);" style="width:34%"/></td>
							</tr>		
						</tbody>
					</table>
					
					<div class="h50"></div>
					<h3>업체현황 등록<span class="h3stext"><span class="FontRed">*</span> 필수 입력사항 입력해 주세요.</span></h3>
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="160px" />
						<col width="180px" />
						</colgroup>
						<tbody>
							<tr>
								<th>첨부파일</th>
								<td colspan="3">
									<input type="text" id="st_image_key" name="st_image_key" title="" style="width:86%" value="" />
									<input type="hidden" id="st_image_key_org" name="st_image_key_org" title="" style="width:86%" value="" />
									<input type="hidden" id="st_image_key_Text" name="st_image_key_Text" title="" style="width:86%" value="" />
									<a href="javascript:doPop('fileUpload2','')"><span class="Joinbtn_Gray" title="파일첨부">파일첨부</span></a>
								</td>
							</tr>
							<tr>
								<th>서류접수현황</th>
								<td colspan="3" class="S_txt">
									<input type="checkbox" id="st_deal_contract_doc_yn"	name="st_deal_contract_doc_yn"	value="Y" class="noborder"/> 물품거래기본계약서&nbsp; 
									<input type="checkbox" id="st_biz_licence_doc_yn"	name="st_biz_licence_doc_yn"	value="Y" class="noborder"/> 사업자등록증&nbsp; 
									<input type="checkbox" id="st_account_doc_yn"	 	name="st_account_doc_yn"	value="Y" class="noborder"/> 결제계좌신고서&nbsp; 
									<input type="checkbox" id="st_bankbook_copy_yn"	name="st_bankbook_copy_yn"	value="Y" class="noborder"/> 통장사본&nbsp; 
									<input type="checkbox" id="st_seal_cert_doc_yn"	name="st_seal_cert_doc_yn"	value="Y" class="noborder"/> 인감증명서&nbsp; 
									<input type="checkbox" id="st_using_seal_doc_yn"	ame="st_using_seal_doc_yn"	value="Y" class="noborder"/> 사용인감계
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 대리점권보유품목</th>
								<td colspan="3">
									<input type="text" id="st_itmg1_nm" name="st_itmg1_nm" title="" style="width:72px;" value="" readonly /><input type="hidden" id="st_itmg1_cd" name="st_itmg1_cd" value="" /><a href="javascript:doPop( 'itmg',  '1');"><img src="/resources/images/btn_search03.gif" /></a>&nbsp; 
									<input type="text" id="st_itmg2_nm" name="st_itmg2_nm" title="" style="width:72px;" value=""  readonly /><input type="hidden" id="st_itmg2_cd" name="st_itmg2_cd" value="" /><a href="javascript:doPop( 'itmg',  '2');"><img src="/resources/images/btn_search03.gif" /></a>&nbsp; 
									<input type="text" id="st_itmg3_nm" name="st_itmg3_nm" title="" style="width:72px;" value=""  readonly /><input type="hidden" id="st_itmg3_cd" name="st_itmg3_cd" value="" /><a href="javascript:doPop( 'itmg',  '3');"><img src="/resources/images/btn_search03.gif" /></a>&nbsp; 
									<input type="text" id="st_itmg4_nm" name="st_itmg4_nm" title="" style="width:72px;" value=""  readonly /><input type="hidden" id="st_itmg4_cd" name="st_itmg4_cd" value="" /><a href="javascript:doPop( 'itmg',  '4');"><img src="/resources/images/btn_search03.gif" /></a>&nbsp; 
									<input type="text" id="st_itmg5_nm" name="st_itmg5_nm" title="" style="width:72px;" value=""  readonly  /><input type="hidden" id="st_itmg5_cd" name="st_itmg5_cd" value="" /><a href="javascript:doPop( 'itmg',  '5');"><img src="/resources/images/btn_search03.gif" /></a>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 대리점권보유<br> &nbsp;&nbsp;메이커명</th>
								<td colspan="3" class="lineH">
									<input type="text"  id="st_itm_mk1_nm" name="st_itm_mk1_nm"title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk1" name="st_itm_mk1" value="" /><a href="javascript:doPop( 'itmMk',  '1');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk1','st_itm_mk1_nm'); setItmMkYn('1');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>&nbsp; 
									<input type="text" id="st_itm_mk2_nm" name="st_itm_mk2_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk2" name="st_itm_mk2" value="" /><a href="javascript:doPop( 'itmMk',  '2');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk2','st_itm_mk2_nm'); setItmMkYn('2');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>&nbsp; 
									<input type="text" id="st_itm_mk3_nm" name="st_itm_mk3_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk3" name="st_itm_mk3" value="" /><a href="javascript:doPop( 'itmMk',  '3');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk3','st_itm_mk3_nm'); setItmMkYn('3');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a></br>
									<input type="text" id="st_itm_mk4_nm" name="st_itm_mk4_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk4" name="st_itm_mk4" value="" /><a href="javascript:doPop( 'itmMk',  '4');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk4','st_itm_mk4_nm'); setItmMkYn('4');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>&nbsp; 
									<input type="text" id="st_itm_mk5_nm" name="st_itm_mk5_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk5" name="st_itm_mk5" value="" /><a href="javascript:doPop( 'itmMk', '5');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk5','st_itm_mk5_nm'); setItmMkYn('5');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 유통레벨/대리점<br> &nbsp;&nbsp;계약서류</th>
								<td colspan="3"> 
									<p ><label for="st_itm_mk1_yn" class="hidden">--선택--</label>
									<select id="st_itm_mk1_yn" name="st_itm_mk1_yn" style="width:100px;" disabled>
										 
									</select>
									<input type="hidden"  id="st_itm_mk1_image_key" name="st_itm_mk1_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '1', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
									<p><label for="st_itm_mk2_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk2_yn" id="st_itm_mk2_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk2_image_key" name="st_itm_mk2_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '2', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
									<p><label for="st_itm_mk3_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk3_yn" id="st_itm_mk3_yn" style="width:100px;" disabled>
								 
									</select>
									<input type="hidden"  id="st_itm_mk3_image_key" name="st_itm_mk3_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '3', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
									</br>
									<p><label for="st_itm_mk4_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk4_yn" id="st_itm_mk4_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk4_image_key" name="st_itm_mk4_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '4', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
									<p><label for="st_itm_mk5_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk5_yn" id="st_itm_mk5_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk5_image_key" name="st_itm_mk5_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '5', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>						
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 대리점권보유<br> &nbsp;&nbsp;메이커명</th>
								<td colspan="3" class="lineH">
									<input type="text"  id="st_itm_mk6_nm" name="st_itm_mk6_nm"title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk6" name="st_itm_mk6" value="" /><a href="javascript:doPop( 'itmMk', '6');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk6','st_itm_mk6_nm'); setItmMkYn('6');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>&nbsp; 
									<input type="text" id="st_itm_mk7_nm" name="st_itm_mk7_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk7" name="st_itm_mk7" value="" /><a href="javascript:doPop( 'itmMk', '7');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk7','st_itm_mk7_nm'); setItmMkYn('7');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>&nbsp; 
									<input type="text" id="st_itm_mk8_nm" name="st_itm_mk8_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk8" name="st_itm_mk8" value="" /><a href="javascript:doPop( 'itmMk', '8');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk8','st_itm_mk8_nm'); setItmMkYn('8');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a></br>
									<input type="text" id="st_itm_mk9_nm" name="st_itm_mk9_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk9" name="st_itm_mk9" value="" /><a href="javascript:doPop( 'itmMk', '9');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk9','st_itm_mk9_nm'); setItmMkYn('9');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>&nbsp; 
									<input type="text" id="st_itm_mk10_nm" name="st_itm_mk10_nm" title="" style="width:117px;" value="" /><input type="hidden"  id="st_itm_mk10" name="st_itm_mk10" value="" /><a href="javascript:doPop( 'itmMk', '10');"><img src="/resources/images/btn_search03.gif" /></a><a href="javascript:kepEraser('st_itm_mk10','st_itm_mk10_nm'); setItmMkYn('10');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 유통레벨/대리점<br> &nbsp;&nbsp;계약서류</th>
								<td colspan="3"><p><label for="st_itm_mk6_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk6_yn" id="st_itm_mk6_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk6_image_key" name="st_itm_mk6_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '6', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
									<p><label for="st_itm_mk7_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk7_yn" id="st_itm_mk7_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk7_image_key" name="st_itm_mk7_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '7', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
									<p><label for="st_itm_mk8_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk8_yn" id="st_itm_mk8_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk8_image_key" name="st_itm_mk8_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '8', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p></br>
									<p><label for="st_itm_mk9_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk9_yn" id="st_itm_mk9_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk9_image_key" name="st_itm_mk9_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '9', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
									<p><label for="st_itm_mk10_yn" class="hidden">--선택--</label>
									<select name="st_itm_mk10_yn" id="st_itm_mk10_yn" style="width:100px;" disabled>
										
									</select>
									<input type="hidden"  id="st_itm_mk10_image_key" name="st_itm_mk10_image_key" value="" />
									<a href="javascript:doPop('fileUpload', '10', '' ) ;"><span class="Joinbtn_Gray" title="첨부등록">첨부등록</span></a></p>
								</td>
							</tr>
							<tr>
								<th colspan="4" height="35px"><span class="FontRed">* 대리점 보유 메이커 해당 없음</span>&nbsp; <input type="checkbox" id="st_itm_mk_yn"  name="st_itm_mk_yn" value="Y" class="noborder" style=" vertical-align:middle"   /></th>
							</tr>
							<tr>
								<th>타마켓플레이스<br />거래유무</th>
								<td colspan="3">
									<input type="checkbox" id="st_mp1_business_yn" name="st_mp1_business_yn" value="Y" class="noborder"/> &nbsp;IMK&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="st_mp2_business_yn" name="st_mp2_business_yn" value="Y" class="noborder"/> &nbsp;서브원&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="st_mp3_business_yn" name="st_mp3_business_yn" value="Y" class="noborder"/> &nbsp;NtoB&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="st_mp4_business_yn" name="st_mp4_business_yn" value="Y" class="noborder"/> &nbsp;Biz MRO&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="st_mp5_business_yn" name="st_mp5_business_yn" value="Y"class="noborder"/> &nbsp;MRO Korea&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="st_mp_business_yn" name="st_mp_business_yn"   onclick="checkMp(this);" value="Y" class="noborder"/> &nbsp;해당없음&nbsp;&nbsp;&nbsp;
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> ISO여부</th>
								<td>
									<label for="st_iso_yn" class="hidden">없음</label>
									<select name="st_iso_yn" id="st_iso_yn" style="width:99%">
										
									</select></td>
								<th><span class="FontRed">*</span> 특허여부</th>
								<td>
									<label for="st_license_yn" class="hidden">미보유</label>
									<select name="st_license_yn" id="st_license_yn" style="width:99%">
										
									</select>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 매출액전년도</th>
								<td>
									<label for="st_year_amt" class="hidden">11~30억</label>
									<select name="st_year_amt" id="st_year_amt" style="width:99%">
									
									</select>
								</td>
								<th>주요거래처</th>
								<td><input type="text" id="st_major_com" name="st_major_com" title=""  value=""  maxlength="250" onkeyup="fnCheckInputByte(this, 250);" onchange="fnCheckInputByte(this, 250);" style="width:99%"/></td>
							</tr>
							<tr>
								<th ><span class="FontRed">*</span> 직납가능지역</th>
								<td colspan="3">
									<div  style="float:left; padding-right:60px">
										<span style="color:#06F; font-weight:bold; padding-bottom:2px">※ 대분류</span><br/>
										<input type="checkbox" id="st_dr_b_all" name="st_dr_b_all" value="Y" class="noborder"/> 전국&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_b_soodo" name="st_dr_b_soodo"	value="Y" class="noborder"/> 수도권&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_b_chungnam" name="st_dr_b_chungnam"	value="Y" class="noborder"/> 충남&nbsp;&nbsp;&nbsp;<br>
										<input type="checkbox" id="st_dr_b_chungbuk" name="st_dr_b_chungbuk"	value="Y" class="noborder"/> 충북&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_b_gyeongnam" name="st_dr_b_gyeongnam" value="Y" class="noborder"/> 경남&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_b_gyeongbuk" name="st_dr_b_gyeongbuk" value="Y" class="noborder"/> 경북&nbsp;&nbsp;&nbsp;<br>
										<input type="checkbox" id="st_dr_b_jeonnam" name="st_dr_b_jeonnam" value="Y" class="noborder" /> 전남&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_b_jeonbuk" name="st_dr_b_jeonbuk" value="Y" class="noborder"/> 전북&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_b_kangwon" name="st_dr_b_kangwon" value="Y" class="noborder"/> 강원&nbsp;&nbsp;&nbsp;<br>
										<input type="checkbox" id="st_dr_b_jeju" name="st_dr_b_jeju"	 value="Y" class="noborder"/> 제주&nbsp;&nbsp;&nbsp; 
									</div>
									<div >
										<span style="color:#06F; font-weight:bold; padding-bottom:2px">※ 소분류</span><br/>
										<input type="checkbox" id="st_dr_s_seoul" name="st_dr_s_seoul" value="Y" class="noborder"/> 서울&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_incheon"name="st_dr_s_incheon" value="Y" class="noborder"/> 인천&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_suwon" name="st_dr_s_suwon" value="Y" class="noborder"/> 수원&nbsp;&nbsp;&nbsp;<br>
										<input type="checkbox" id="st_dr_s_daegumi" name="st_dr_s_daegumi" value="Y" class="noborder"/> 대구/구미&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_pohang" name="st_dr_s_pohang" value="Y" class="noborder"/> 포항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_ulsan" name="st_dr_s_ulsan" value="Y" class="noborder"/> 울산&nbsp;&nbsp;&nbsp;<br>
										<input type="checkbox" id="st_dr_s_machang" name="st_dr_s_machang" value="Y" class="noborder"/> 마산/창원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_busan" name="st_dr_s_busan" value="Y" class="noborder" /> 부산&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_yeocheon" name="st_dr_s_yeocheon" value="Y" class="noborder"/> 여천&nbsp;&nbsp;&nbsp;<br>
										<input type="checkbox" id="st_dr_s_gwangju" name="st_dr_s_gwangju" value="Y" class="noborder"/> 광주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_gunsan" name="st_dr_s_gunsan" value="Y" class="noborder"/> 군산&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" id="st_dr_s_daejeon" name="st_dr_s_daejeon" value="Y" class="noborder"/> 대전&nbsp;&nbsp;&nbsp; 
									</div>
								</td>
							</tr>	
							<tr>
								<th><span class="FontRed">*</span> 배송차량 수</th>
								<td>
									<label for="st_deliv_equip_cnt" class="hidden">1~2대</label>
									<select name="st_deliv_equip_cnt" id="st_deliv_equip_cnt" style="width:99%">
										
									</select>
								</td>
								<th>KeP시스템 교육희망시기</th>
								<td>
									<label for="st_kep_system_ed_year" class="hidden">KeP시스템 교육희망시기</label>
									<%
									SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
									Date todate = new Date();
											
									int kepEdYear = Integer.parseInt(sdf.format(todate).toString().substring(0,4));
									int kepEdMonth = Integer.parseInt(sdf.format(todate).toString().substring(4,6));
									%>
									<select name="st_kep_system_ed_year" id="st_kep_system_ed_year" style="width:80px;">
										<% for (int i=kepEdYear; i <= kepEdYear+4; i++) { %>
										<option value="<%=i%>" <%=kepEdYear == i ? "selected" : ""%>><%=i%></option>
										<% } %>
									</select>
									<select name="st_kep_system_ed_month" id="st_kep_system_ed_month" style="width:60px;">
										<% for (int i=1; i <= 12; i++) { %>
										<option value="<%=i%>" <%=kepEdMonth == i ? "selected" : ""%>><%=i%></option>
										<% } %>
									</select>
								</td>
							</tr>	
						</tbody>
					</table>
					
					<div class="h50"></div>
					<h3>결제정보 등록<span class="h3stext"><span class="FontRed">*</span> 필수 입력사항 입력해 주세요.</span></h3>
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="140px" />
							<col width="200px" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="FontRed">*</span> 경리담당자</th>
								<td><input type="text" id="st_ac_emp_nm" name="st_ac_emp_nm" title=""  value=""  maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 경리담당자연락처</th>
								<td><input type="text" id="st_ac_emp_tel" name="st_ac_emp_tel" title="" value=""  maxlength="20" onkeyup="fnPhoneNumberCheck('st_ac_emp_tel');" onchange="fnPhoneNumberCheck('st_ac_emp_tel');" style="width:98%;" /></td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 영업담당자</th>
								<td><input type="text" id="st_gr_emp_nm" name="st_gr_emp_nm" title=""  value=""  maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 영업담당자연락처</th>
								<td><input type="text" id="st_gr_emp_tel" name="st_gr_emp_tel" title=""  value=""  maxlength="20" onkeyup="fnPhoneNumberCheck('st_gr_emp_tel');" onchange="fnPhoneNumberCheck('st_gr_emp_tel');" style="width:98%"/></td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 지급조건</th>
								<td>
									<select id="st_pay_terms" name="st_pay_terms" style="width:99%;">
										
									</select>
								</td>
								<th><span class="FontRed">*</span> 지급형태</th>
								<td>
									<select id="st_pay_type" name="st_pay_type" style="width:99%;">
										
									</select>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 은행명</th>
								<td>
									<input type="hidden" id="st_bank_cd" name="st_bank_cd" value=""  />
									<input type="text" id="st_bank_name" name="st_bank_name" title="" style="width:82%;" value=""  readonly />
									<input type="hidden" id="st_pay_date_type" name="st_pay_date_type" value="" />
									<a href="javascript:doPop( 'bankcode');"><img src="/resources/images/btn_search03.gif" /></a>
								</td>
								<th>발행조건</th>
								<td>
									<select id="st_bill_type" name="st_bill_type" style="width:99%;">
										
									</select>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 계좌번호</th>
								<td><input type="text" id="st_bank_account_no" name="st_bank_account_no" title="" value=""  maxlength="30" onkeyup="fnPhoneNumberCheck('st_bank_account_no');" onchange="fnPhoneNumberCheck('st_bank_account_no');" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 예금주</th>
								<td><input type="text" id="st_depositor" name="st_depositor" title="" value=""  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width:98%"/></td>
							</tr>
						</tbody>
					</table>
					
					<div class="h50"></div>
					<h3>SMS 및 이메일 수신여부<span class="h3stext"><span class="FontRed">*</span> 필수 입력사항 입력해 주세요.</span></h3>
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="140px" />
							<col width="200px" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="FontRed">*</span> 이메일 수신여부</th>
								<td>
									<input type="radio" id="mail_send_flag1" name="mail_send_flag" value="Y" class="noborder"/> 수신&nbsp;&nbsp;&nbsp;
									<input type="radio" id="mail_send_flag2" name="mail_send_flag" value="N" class="noborder"/> 미수신&nbsp;&nbsp;&nbsp;
									<input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag" value="" class="noborder"/>
								</td>
								<th><span class="FontRed">*</span> SMS 수신여부</th>
								<td>
									<input type="radio" id="sms_recv_flag1" name="sms_recv_flag" value="Y" class="noborder"/> 수신&nbsp;&nbsp;&nbsp;
									<input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N" class="noborder"/> 미수신&nbsp;&nbsp;&nbsp;
									<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="" class="noborder"/>
								</td>
							</tr>
						</tbody>
					</table>
					
					<div class="h50"></div>
					<div class="JoinBtnArea">
						<a href="javascript:doAction('save');"><span class="BtnBlue">등록하기</span></a>
						<a href="javascript:doAction('reload');"><span class="BtnGray">취소하기</span></a>
					</div>
					<div class="h50"></div>
				</div>
			</div>
		</div>
		</form>
		<!--SubCenter-->
	</div>
	<!--Subwrap-->
	
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	<%@ include file="/WEB-INF/views/common/include/mainFooter.jsp" %>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
</div>
<!--내용 종료-->	                 
</body>
</html>
<script type="text/javascript">
<!--
var popupSel = "";
var popupItem = "";


function kep_onload(){
	kepAjaxCommonComboDataValue('st_reg_type', 'M109', '', '');
	kepSetCalender('establish_date');
	kepAjaxCommonComboDataValue('st_biz_type', 'M110', 'SEL', '');
	kepAjaxCommonComboDataValue('st_emp_cnt', 'M111', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk1_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk2_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk3_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk4_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk5_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk6_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk7_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk8_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk9_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk10_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_iso_yn', 'M112', 'SEL', '');
	kepAjaxCommonComboDataValue('st_license_yn', 'M113', 'SEL', '');
	kepAjaxCommonComboDataValue('st_year_amt', 'M114', 'SEL', '');
	kepAjaxCommonComboDataValue('st_deliv_equip_cnt', 'M115', 'SEL', '');
	kepAjaxCommonComboDataValue('st_pay_terms', 'SA01', 'SEL', '');
	kepAjaxCommonComboDataValue('st_pay_type', 'SA03', 'SEL', '');
	kepAjaxCommonComboDataValue('st_bill_type', 'TX03', 'SEL', '');

}

var st;
//기능함수
function doAction(str, tag) {
	actionFlag = tag;
	switch (str) {
		case "reload":	//초기화
			kepReload("contentForm");
			break;
		case "save": // 저장	
			if (checkSubmit(tag)) {
				kepAjaxFormCall("/mdam/saveMasterMdAmSellerMbrcmpyRegList.do", "contentForm", str); 	
			}
			break;
		case "idCheck": // 저장
			if (isEmpty($("#st_user_id").val())) {
				alert("사용자 ID를 입력해 주십시요");
				$("#st_user_id").focus();
				return;
			} else {
				kepAjaxFormCall("/mdam/getMasterMdAmSellerMbrcmpyRegIDCheck.do","contentForm","idCheck");
			}	
			break;
		case "pwdCheck":
			if (passwordValidCheck()) {
				kepAjaxFormCall("/mdam/getMasterMdAmSellerMbrcmpyRegPwdValidCheck.do","contentForm","pwdCheck");
			}
			break;	
	}
}

//팝업 함수호출
function doPop(str, item, val1, val2, val3, val4, val5) {
	popupSel = str;
	popupItem = item;
	switch (str) {
		/* case "zipcode":					//우편번호 검색	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode":					//우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case "kepManagerPop":		// KeP담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do","?st_buyer=KRKORE0001&pop_css_type=S", "500,500,no");
			break;	
		case "itmg":						// 대리점권보유품목
			openSearchPopup("/coco/getCommonCoCoTranGoodsPop.do", "", "600,500,no");
			break;
		case "kepBuyer":				//Kep 경우협력사선택
			openSearchPopup("/mprq/showMasterMpRqSellerSelPop.do", "?com_type=B&multi_flag=S", "500,500,no");
			break;	
		case "itmMk":					// 대리점권보유 메이커명
			if ($("#st_itm_mk_yn").is(":checked")) {
				alert("대리점권 보유 메이커 해당없음을 해제 하십시오");
				return;
			}	
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
		case "bankcode":				// 은행조회
			openSearchPopup("/common/bankCodePop.do", "", "500,500,no");
			break;	
		case "fileUpload":				//파일업로드
			if ($("#st_itm_mk_yn").is(":checked")) {
				alert("대리점권 보유 메이커 해당없음을 해제 하십시오");
				return;
			}
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_itm_mk"+popupItem+"_image_key").val(), "500,430,no");	
			break;
			
		case "fileUpload2":				//파일업로드
		    
		   var  image_key_1 = $("#st_image_key").val();
		   var  image_key_2 = $("#st_image_key_org").val();
		    	
			if (isEmpty(image_key_1)) {
				openSearchPopup("/common/fileUploadPop.do", "", "500,430,no");
				break; 
			}else{				   
				if (image_key_1 == image_key_2) { 
					 openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_image_key").val(), "500,430,no");
					 break;
				}else{
					openSearchPopup("/common/fileUploadPop.do", "", "500,430,no");
				   break;  
				}				
			}
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "itmg":				// 대리점권보유품목
			$("#st_itmg" + popupItem + "_cd").val(code);
			$("#st_itmg" + popupItem + "_nm").val(text);
			break;
		case "itmMk":			// 대리점권보유 메이커명
			$("#st_itm_mk" + popupItem).val(code);
			$("#st_itm_mk" + popupItem + "_nm").val(text);
			$("#st_itm_mk" + popupItem + "_yn").attr("disabled", false);
			break;
		case "kepBuyer":		//Kep 경우협력사선택
			$("#st_kep_buyer" + popupItem).val(code);
			$("#st_kep_buyer_name" + popupItem).val(text);
			break;		
		case "bankcode":			//은행 검색
			$("#st_bank_cd").val(code);
			$("#st_bank_name").val(text);
			break;
		case "fileUpload":					//파일업로드
			$("#st_itm_mk" +popupItem + "_image_key").val(code);
			break;	
		case "fileUpload2":					//파일업로드
			$("#st_image_key").val(code);
			$("#st_image_key_org").val(code);
			break;
	}
}

function setItmMkYn(str) {
	$("#st_itm_mk" + str + "_yn").attr("disabled", true);
}
/* ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	if (popupItem == "COM") {
		$("#st_zip_code").val(str_zipcode);
		$("#st_zip_key").val(str_zip_key);
		$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
		$("#st_address_dt").val(str_buildingName);
	} else {
		$("#st_usr_zip_code").val(str_zipcode);
		$("#st_usr_zip_key").val(str_zip_key);
		$("#st_usr_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
		$("#st_usr_address_dt").val(str_buildingName);
	}
}
 */

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	if (popupItem == "COM") {
		$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
		$("#st_zip_key").val(bdMgtSn);
		$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#st_address_dt").val(addrDetail);
	} else {
		$("#st_usr_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
		$("#st_usr_zip_key").val(bdMgtSn);
		$("#st_usr_address").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#st_usr_address_dt").val(addrDetail);
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "pwdCheck") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword").val("Y");
			return;
		}
	} else if (pMethod == "idCheck") {
		if (sMsg == 'OK') {
			alert("사용가능한 ID 입니다.");
			$("#id_check_flag").val("Y");
			return;
		} else {
			alert("이미 사용하고 있는 ID 입니다. 다른 ID를 입력하세요.");
			$("#id_check_flag").val("N");
			$("#st_user_id").val("");
			$("#st_user_id").focus();
			return;
		}
	} else if (pMethod == "save") {
		if (sMsg == "OK") {
			location.href="<%=httpurl%>/mdam/showMasterMdAmMbrcmpyRegEnd.do?type=B&com_code="+response.com_code;
			return;
		} else {
			if (sMsg == "Err") {
				alert("협력사 및 Admin 사용자 등록이 실패 하였습니다.\n다시 확인하여 주십시요!");
			}	else if (sMsg == "irs" ) {
				alert("이미 등록된 업체입니다.\n다시 확인하여 주십시요!");
				return;
			} else if (sMsg == "9999") {
				alert("한 회사에서 9999건 이상 초과해서 등록할 수 없습니다.");
				return;
			}
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. ");
}

function checkPhoneNumber(str) {
	for(var i=2; i <= 3 ; i++){
		if (isEmpty($("#"+str+i).val())) {
			alert("전화번호를 입력 하여 주십시오");
			$("#"+str+i).focus();
			return false;
		}

		if (i == 2 && $("#"+str+i).val().length < 3 ) {
			alert("국번을 정확히 입력 해주세요");
			$("#"+str+i).val().focus();
			return false;

		} else if (i == 3 && $("#"+str+i).val().length != 4 ) {
			alert("전화번호를 정확히 입력 해주세요");
			$("#"+str+i).val().focus();
			return false;
		}
	}
	return true;
}

function passwordValidCheck() {
	$("#chkPassword").val("N");

	if (isEmpty($("#st_user_id").val())) {
		alert("사용할 id를 입력 하여 주십시오");
		$("#st_user_id").focus();
		return  false;
	}
	
	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		$("#st_user_id").focus();
		return false;
	}
	
	if (!checkSpecialChar(kepTrimStr($("#st_user_id").val()))){
		alert("아이디에 특수기호(%,$,&,*,@,!,#,\",\')를 사용 할수 없습니다.");
		$("#st_user_id").focus();
		return false;
	}

	if ($("#id_check_flag").val() != "Y"){
		alert("아이디 중복 검사를 해주십시오");
		return false;
	}

	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password").focus();
		return false;
	}

	if (checkSpace($("#st_password").val()) && $("#st_password").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_password").val("");
		$("#st_password").focus();
		return false;
	}

	if ($("#st_password").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password").focus();
		$("#st_password").select();
		return false;
	}

	if ($("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password").focus();
		return false;
	}

	if ($("#st_confirmpasswd").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_confirmpasswd").focus();
		return false;
	}

	if (checkSpace($("#st_confirmpasswd").val()) && $("#st_confirmpasswd").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_confirmpasswd").val("");
		$("#st_confirmpasswd").focus();
		return false;
	}

	if ($("#st_confirmpasswd").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_confirmpasswd").focus();
		return false;
	}

	if ($("#st_confirmpasswd").val().length < chkKorea($("#st_confirmpasswd").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_confirmpasswd").focus();
		return false;
	}

	if ($("#st_password").val() != $("#st_confirmpasswd").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		$("#st_password").focus();
		return false;
	}

	return true;
}

function checkUserInfo() {

	if (isEmpty($("#st_usr_name_loc").val())) {
		alert("사용자 명을 입력 하여 주십시오.");
		$("#st_usr_name_loc").focus();
		return false;
	}
	
	if (isEmpty($("#st_user_id").val())) {
		alert("사용할 id를 입력 하여 주십시오");
		$("#st_user_id").focus();
		return  false;
	}
	
	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		$("#st_user_id").focus();
		return false;
	}
	
	if (!checkSpecialChar(kepTrimStr($("#st_user_id").val()))){
		alert("아이디에 특수기호(%,$,&,*,@,!,#,\",\')를 사용 할수 없습니다.");
		$("#st_user_id").focus();
		return false;
	}

	if ($("#id_check_flag").val() != "Y"){
		alert("아이디 중복 검사를 해주십시오");
		return false;
	}

	if ($("#chkPassword").val() != "Y") {
		doAction("pwdCheck");
		return false;
	}

	if (!checkPhoneNumber("st_phone")) { return false; }
	
	if (isEmpty($("#st_usr_email").val())) {
		alert("E-Mail 주소를 입력해 주십시오.");
		$("#st_usr_email").focus();
		return false;
	}
	
	if (!checkemail("st_usr_email")) { return false; }
	if (!checkPhoneNumber("st_usr_mobile")) { return false; }
	if (!checkPhoneNumber("st_fax_no")) { return false; }

	if (isEmpty($("#st_usr_zip_code").val())) {
		alert("사용자주소 우편번호를 입력 하세요.");
		$("#st_usr_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_usr_zip_key").val())) {
		alert("사용자주소를 도로명 주소로 변경 바랍니다.");
		$("#st_usr_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_usr_address").val())) {
		alert("사용자 주소를 입력 하세요.");
		$("#st_usr_address").focus();
		return false;
	}
	
	if (isEmpty($("#st_de_emp_nm").val())) {
		alert("납기관리 담당자명을 입력 하여 주십시오.");
		$("#st_de_emp_nm").focus();
		return  false;
	}

	if (!checkPhoneNumber("st_de_emp_tel")) { return false; }

	return true;
}

function checkCompanyInfo() {

	if (isEmpty($("#st_com_name_loc").val())){
		alert("한글 회사명을 입력해주세요.");
		$("#st_com_name_loc").select();
		return false;
	}

	if (isEmpty($("#st_com_name_eng").val())){
		alert("영문 회사명을 입력해주세요.");
		$("#st_com_name_eng").select();
		return false;
	}
	
	if (kepTrimStr($("#st_com_name_eng").val()).length < chkKorea(kepTrimStr($("#st_com_name_eng").val()))) {
		alert("영문회사명을 영문으로 입력해 주십시요.");
		$("#st_com_name_eng").select();
		return false;
	}

	if (kepTrimStr($("#st_com_name_eng").val()).length < 4) {
		alert("영문 회사명을 4자리 이상 입력해 주십시오");
		$("#st_com_name_eng").select();
		return false;
	}

	if (!checkSpecialChar(kepTrimStr($("#st_com_name_eng").val()))) {
		alert("영문 회사명에 특수기호(%,$,&,*,@,!,#)를 사용 할수 없습니다.");
		$("#st_com_name_eng").select();
		return false;
	}
	
	var irsLength = new Array();
	irsLength[0] = 3;
	irsLength[1] = 2;
	irsLength[2] = 5;

	for (var i=1; i <= 3 ; i++) {
		if(isEmpty($("#st_irs_no"+i).val())){
			alert('사업자 등록 번호를 입력 하여 주십시오');
			$("#st_irs_no"+i).focus();
			return false;
		}
		

		if($("#st_irs_no"+i).val().length != irsLength[i-1] ) { 
			alert("사업자등록번호 "+i+"번째는 숫자로 "+irsLength[i-1]+"자리 입니다.");
			$("#st_irs_no"+i).val("");
			$("#st_irs_no"+i).focus();
			return false;
		}
	}

	if (!KepBizNoCheckStr2($("#st_irs_no1").val() + $("#st_irs_no2").val() + $("#st_irs_no3").val())) {
		alert("사업자 등록번호가 유효하지 않습니다.");
		$("#st_irs_no_1").focus();
		return false;
	}

	if(isEmpty($("#st_industry_type").val()))  {
		alert("업태를 입력해 주십시요.");
		$("#st_industry_type").focus();
		return false;
	}

	if(isEmpty($("#st_business_items").val())) {
		alert("종목을 입력해 주십시요.");
		$("#st_business_items").focus();
		return false;
	}

	if(isEmpty($("#st_ceo_name_loc").val()))  {
		alert("대표자명을 입력해주세요.");
		$("#st_ceo_name_loc").focus();
		return false;
	}
	
	if (isEmpty($("#establish_date").val())) {
	   alert("설립년도를 선택해 주십시요.");
	   $("#establish_date").focus();
	   return false;
	}
		
	$("#st_establish_date").val($("#establish_date").val().replace(/[/]/gi,""));

	for (i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_tel_no"+i).val())) {
			alert('대표번호를 입력 하여 주십시오');
			$("#st_tel_no"+i).focus();
			return false;
		}
	}
	
	if (isEmpty($("#st_kep_damdang_id").val())) {
		alert("KEP 담당자를 선택 하여주십시오");
		return false;
	}
	
	if ($("#st_biz_type option:selected").val() == "") {
		alert("유통레벨을 선택 하세요");
		return false;
	}

	if ($("#st_emp_cnt option:selected").val() == "" ) {
		alert("종업원 수 를 선택 하세요");
		return false;
	}

	if(isEmpty($("#st_zip_code").val())){
		alert("본사 우편번호를 선택 하여주십시오");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_zip_key").val())) {
		alert("본사 주소를 도로명 주소로 변경 바랍니다.");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_address").val())) {
		alert("본사 우편번호를 선택 하여주십시오");
		$("#st_address").focus();
		return false;
	}

	return true;
}

function checkSubmit(Flag) {

	$("#st_SaveFlag").val(Flag);
	
	if (!checkCompanyInfo()) { // 회사정보 체크
		return false;
	}
	
	if (!checkUserInfo()) { //사용자 정보체크
		return false;
	}


	var itmgSelectCount = 0;
	for (var i=1; i <= 5; i++) {
		if (!isEmpty($("#st_itmg"+i+"_cd").val())) {
			itmgSelectCount++;
		}
	}
	
	if (itmgSelectCount < 2 ) {
		alert("취급품목을 2개 이상 선택 해 주십시오");
		return false;
	}
	
	var makerSelectCount = 0;
	if (!$("#st_itm_mk_yn").is(":checked")) {
		
		for (var i=1; i < 11; i++) {
			if ($("#st_itm_mk" + i).val() != "") {
				makerSelectCount++;
			}
		}

		if (makerSelectCount < 1 ) {
			alert("대리점권 보유 메이커를 1개 이상 선택 해주십시오");
			return false;
		}
	}

	for (var i=1; i < 11; i++) {
		if (!isEmpty($("#st_itm_mk"+i).val())) {
			if ($("#st_itm_mk"+i+"_yn option:selected").val() == "") {
				alert($("#st_itm_mk"+i+"_nm").val() + "의 유통레벨을 선택하십시오");
				return false;
			}   
		}
	}
	
	if ( !$("#st_mp_business_yn").is(":checked")	&& !$("#st_mp1_business_yn").is(":checked") && !$("#st_mp2_business_yn").is(":checked") && !$("#st_mp3_business_yn").is(":checked") && !$("#st_mp4_business_yn").is(":checked") && 
		!$("#st_mp5_business_yn").is(":checked")	) {
		alert("타 마켓 플레이스 거래 여부를 체크 해 주십시오");
		return false;
	}
	
	if ($("#st_iso_yn option:selected").val() == "" ) {
		alert("ISO 보유여부를 선택 하세요");
		return false;
	}

	if ($("#st_license_yn option:selected").val() == "" ) {
		alert("특허 보유여부를 선택 하세요");
		return false;
	}

	if ($("#st_year_amt option:selected").val() == "" ) {
		alert("전년도 매출액을 선택 하세요");
		return false;
	}
	
	if (	!$("#st_dr_b_all").is(":checked") && !$("#st_dr_b_soodo").is(":checked") && !$("#st_dr_b_chungnam").is(":checked")	&& !$("#st_dr_b_chungbuk").is(":checked")	&& !$("#st_dr_b_gyeongnam").is(":checked") && 	
		!$("#st_dr_b_gyeongbuk").is(":checked")	&& !$("#st_dr_b_jeonnam").is(":checked") && !$("#st_dr_b_jeonbuk").is(":checked") && !$("#st_dr_b_kangwon").is(":checked")	&& !$("#st_dr_b_jeju").is(":checked")	&& !$("#st_dr_s_seoul").is(":checked") && // 대분류지역
		!$("#st_dr_s_incheon").is(":checked") && !$("#st_dr_s_suwon").is(":checked") && 	!$("#st_dr_s_daegumi").is(":checked") && !$("#st_dr_s_pohang").is(":checked") && !$("#st_dr_s_ulsan").is(":checked") && !$("#st_dr_s_machang").is(":checked") &&
		!$("#st_dr_s_busan").is(":checked") && !$("#st_dr_s_yeocheon").is(":checked") && !$("#st_dr_s_gwangju").is(":checked") && !$("#st_dr_s_gunsan").is(":checked") && !$("#st_dr_s_daejeon").is(":checked") ) {
		alert("직납 가능 지역을 하나 이상 선택 하십시오");
		return false;
	}
	
	if ($("#st_deliv_equip_cnt option:selected").val() == "") {
		alert("배송차량 수를 선택 하세요");
		return false;
	}
	
	if (isEmpty(kepTrimStr($("#st_ac_emp_nm").val()))) {
		alert("경리 담당자를 입력 해주십시오");
		$("#st_ac_emp_nm").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_ac_emp_nm").val()))) {
		alert("경리 담당자를 입력 해주십시오");
		$("#st_ac_emp_nm").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_ac_emp_tel").val()))) {
		alert("경리 담당자 전화번호를 입력 해주십시오");
		$("#st_ac_emp_tel").focus();
		return;
	}
	
	if (isEmpty(kepTrimStr($("#st_gr_emp_nm").val()))) {
		alert("영업 담당자를 입력 해주십시오");
		$("#st_gr_emp_nm").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_ac_emp_tel").val()))) {
		alert("영업 담당자 전화번호를 입력 해주십시오");
		$("#st_gr_emp_tel").focus();
		return;
	}
	
	if ($("#st_pay_terms").val() == "") {
		alert("지급조건을 선택해 주십시요.");
		$("#st_pay_terms").focus();
		return false;
	}
	
	if ($("#st_pay_type").val() == "") {
		alert("지급형태를 선택해 주십시요.");
		$("#st_pay_type").focus();
		return false;
	}

	if (isEmpty(kepTrimStr($("#st_bank_cd").val()))) {
		alert("은행을 선택 해주십시오");
		return;
	}

	if (isEmpty(kepTrimStr($("#st_bank_account_no").val()))) {
		alert("계좌번호를 입력 해주십시오");
		$("#st_bank_account_no").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_depositor").val()))) {
		alert("예금주명을 입력 해주십시오");
		$("#st_depositor").focus();
		return;
	}
	
	if (!$("#mail_send_flag1").is(":checked") && !$("#mail_send_flag2").is(":checked")) {
		alert("메일 수신 여부를 선택 해주세요");
		return false;
	}
	
	$("#st_mail_send_flag").val($("input[name=mail_send_flag]:checked").val());

	if(!$("#sms_recv_flag1").is(":checked") && !$("#sms_recv_flag2").is(":checked")) {
		alert("SMS 메세지 수신 여부를 선택 해주세요");
		return false;
	}

	$("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
	
	if (!$("#mail_send_flag1").is(":checked") && !$("#sms_recv_flag1").is(":checked")) {
		alert("메일 또는 SMS 중 하나이상을 수신하셔야 합니다.\n메일 수신 또는 SMS수신을 선택해 주세요");
		return;
	}

	return confirm("협력회원사 및 Admin 사용자를 등록 하시겠습니까?");
}

function checkMp (obj) {
	if (obj.checked) {
		for (var i=1; i <=5 ; i++) {
			$("#st_mp"+i+"_business_yn").attr("checked", false);
			$("#st_mp"+i+"_business_yn").attr("disabled", true);
		}
	} else {
		for (var i=1; i <=5 ; i++) {
			$("#st_mp"+i+"_business_yn").attr("checked", false);
			$("#st_mp"+i+"_business_yn").attr("disabled", false);
		}
	}
}

function checkSpecialChar(str) {
	for (var i=0 ; i < str.length; i++) {
		if (str.charAt(i) == '%' || str.charAt(i) == '$' || str.charAt(i) == '&' || str.charAt(i) == '*' || str.charAt(i) == '@' || str.charAt(i) == '! '|| str.charAt(i) == '#') {
			return false;
		}
	}
	return true;
}
//-->
</script>

<%--
**********************************************
* 메뉴 : 
* 화면 : BL 등록 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>  

</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var searchOn = "/resources/images/btn_search03.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1},
		      			{Align : "Left",SaveName : "BUYER_NM",		Header : "고객사",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
		      			{Align : "Left",SaveName : "FORWARDER_NM",		Header : "Forwarder",	Type : "Text",	Width : 110, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "CI_NO",		Header : "C/I 번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"C/I Date",	SaveName:"CI_DATE"},
		    			{Align : "Right",SaveName : "SUM_INV_QTY",		Header : "Quantity",	Type:"Float", Format:"${qtyFormat}", Width : 60, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "CURRENCY_CODE",		Header : "Currency",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "Amount",	Type:"Float", Format:"${qtyFormat}", Width : 80, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "GROSS_WEIGHT",		Header : "Gross Weight",	Type:"Float", Format:"${qtyFormat}", Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "PACKING_WEIGHT",		Header : "Weight",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "SHIP_METHOD",		Header : "SHIP_METHOD",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Left",SaveName : "PORT_OF_LOADING",		Header : "PORT_OF_LOADING",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Left",SaveName : "FINAL_DESTINATION",		Header : "FINAL_DESTINATION",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : true}

	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetImageList(1, searchOn);
	kepSearch(document.searchCondition ,  mySheet , "/exbl/getExportExBlExportBlProcDetail.do" ,pagingMode );
	//달력 셋팅
	kepSetCalender("st_eta_date");
	kepSetCalender("st_etd_date");
	kepSetCalender("st_board_date");
	kepSetCalender("st_issue_date");
	kepAjaxCommonQueryIdSearchTwoCombo('st_ship_method','getSrsysTypeList','EP02','4','SEL','');
	
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "save": // 저장
			//필수값 체크.
			if($("#st_bl_no").val() ==""){
				alert("House B/L No 입력 바랍니다.");
				$("#st_bl_no").focus();
				return;
			}
			if($("#st_f_v_no").val() ==""){
				alert("Flight/Vessel No 입력 바랍니다.");
				$("#st_f_v_no").focus();
				return;
			}
			if($("#st_issue_date").val() ==""){
				alert("B/L Issue Date 입력 바랍니다.");
				$("#st_issue_date").focus();
				return;
			}
			if($("#st_board_date").val() ==""){
				alert("On Board Date 입력 바랍니다.");
				$("#st_board_date").focus();
				return;
			}
			if($("#st_shipper").val() ==""){
				alert("Shipper 입력 바랍니다.");
				$("#st_shipper").focus();
				return;
			}
			if($("#st_etd_date").val() ==""){
				alert("ETD Date 입력 바랍니다.");
				$("#st_etd_date").focus();
				return;
			}
			if($("#st_eta_date").val() ==""){
				alert("ETA 입력 바랍니다.");
				$("#st_eta_date").focus();
				return;
			}
			if($("#st_charg").val() ==""){
				alert("Chargable Weight 입력 바랍니다.");
				$("#st_charg").focus();
				return;
			}
			if($("#st_image_key").val() ==""){
				alert("B/L 첨부 등록 바랍니다.");
				return;
			}
			//CI 입력한값 그대로 SHIP_METHOD, PORT_OF_LOADING, FINAL_DESTINATION 입력
			$("#st_ship_method").val(mySheet.GetCellValue(1,"SHIP_METHOD"));
			$("#st_departure").val(mySheet.GetCellValue(1,"PORT_OF_LOADING"));
			$("#st_destination").val(mySheet.GetCellValue(1,"FINAL_DESTINATION"));
			if($("#st_ship_method").val() ==""){
				alert("Ship method 입력 바랍니다.");
				$("#st_ship_method").focus();
				return;
			}
			if($("#st_departure").val() =="" || $("#st_departure").val() == null){
				alert("Port of Loading 입력 바랍니다.");
				$("#st_departure").focus();
				return;
			}
			if($("#st_destination").val() =="" || $("#st_destination").val() == null){
				alert("Final Destination 입력 바랍니다.");
				$("#st_destination").focus();
				return;
			}
	 	   kepSaveAll(document.searchCondition ,  mySheet , "/exbl/saveExportExBlExportReceipt.do");
			break;			
	}

}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
}


//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	//입고정상 등록
	if(msg == "OK"){
		alert("B/L 생성 되었습니다.");
		opener.doAction("search");
		this.close();
	}else{
		if (msg != "") {
			alert(msg);
			doAction('search');
		}		
	}
}

//페이지 인덱스 눌렀을 경우 조회


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;

	return;
}
//팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6) {
	switch (str) {
	case "attachSet"://파일 첨부(등록)
		var type="EXP_BL";
		var viewType="VI";
		var image_key =  $("input[name=st_image_key]").val();
		popupSel = "attachSet";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	if(popupSel == "attachSet") {	//파일 첨부
		 $("input[name=st_image_key]").val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").attr("src",diskOn);
	 	 }
	}
}

</script> 
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method = "post">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_pkg_cmpy_no" name="st_pkg_cmpy_no"  value="${sessionInfo.comCode}">
	<input type="hidden" id="st_key"  name="st_key" value="<%=CommonUtil.nvl((String) request.getParameter("st_key"),"") %>">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
	<input type="hidden" id="st_ship_method" name="st_ship_method"  value="">
	<input type="hidden" id="st_departure" name="st_departure"  value="">
	<input type="hidden" id="st_destination" name="st_destination"  value="">
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">B/L 등록</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"   style="height:448px;">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list07" style="width:100%;">
						<caption>조회</caption>
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="30%" />
						</colgroup>
						<tbody>
						<tr>
							<th><font color="#FF6600">*</font>House B/L No</th>
							<td >
								<input type="text" name="st_bl_no"  id="st_bl_no" class="al"   value =""  style="width:90%;"/>
							</td>
                  			<th ><font color="#FF6600">*</font>Flight/Vessel No</th>
					  		<td >
					  			<input type="text" name="st_f_v_no"  id="st_f_v_no" class="al"   value =""  style="width:90%;"/>
					  		</td>
						 </tr>
						<tr>
							<th>Master B/L No</th>
							<td >
								<input type="text" name="st_master_bl"  id="st_master_bl" class="al"   value =""  style="width:90%;"/>
							</td>
							<th>Carrier</th>
							<td>
								<input type="text" name="st_carrier"  id="st_carrier" class="al"   value =""  style="width:90%;"/>
							</td>
						 </tr>
						<tr>
							<th><font color="#FF6600">*</font>B/L Issue Date</th>
							<td >
								<input type="text" class="al" name="st_issue_date"  id="st_issue_date" readOnly  />
								<a href="javascript:kepCalendar('st_issue_date')"></a>	
							</td>
                  			<th ><font color="#FF6600">*</font>On Board Date</th>
					  		<td >
								<input type="text" class="al" name="st_board_date"  id="st_board_date" readOnly  />
								<a href="javascript:kepCalendar('st_board_date')"></a>
					  		</td>
						 </tr>
						<tr>
							<th><font color="#FF6600">*</font>Shipper</th>
							<td >
								<input type="text" name="st_shipper"  id="st_shipper" class="al"   value ="KOREA E PLATFORM CO., LTD."  style="width:90%;"/>
							</td>
                  			<th >Consignee's</th>
					  		<td >
								<input type="text" name="st_con"  id="st_con" class="al"   value =""  style="width:90%;"/>
					  		</td>
						 </tr>
						<tr>
							<th><font color="#FF6600">*</font>ETD Date</th>
							<td >
								<input type="text" class="al" name="st_etd_date" id="st_etd_date" style="width:30%;" readOnly/>
								<a href="javascript:kepCalendar('st_etd_date')"></a>
								<select name="st_etd_hour" id="st_etd_hour">
									<option value="00">00</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
									<option value="21">21</option>
									<option value="22">22</option>
									<option value="23">23</option>
								</select>시
								<select name="st_etd_minute" id="st_etd_minute">
									<option value="00">00</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
									<option value="21">21</option>
									<option value="22">22</option>
									<option value="23">23</option>
									<option value="24">24</option>
									<option value="25">25</option>
									<option value="26">26</option>
									<option value="27">27</option>
									<option value="28">28</option>
									<option value="29">29</option>
									<option value="30">30</option>
									<option value="31">31</option>
									<option value="32">32</option>
									<option value="33">33</option>
									<option value="34">34</option>
									<option value="35">35</option>
									<option value="36">36</option>
									<option value="37">37</option>
									<option value="38">38</option>
									<option value="39">39</option>
									<option value="40">40</option>
									<option value="41">41</option>
									<option value="42">42</option>
									<option value="43">43</option>
									<option value="44">44</option>
									<option value="45">45</option>
									<option value="46">46</option>
									<option value="47">47</option>
									<option value="48">48</option>
									<option value="49">49</option>
									<option value="50">50</option>
									<option value="51">51</option>
									<option value="52">52</option>
									<option value="53">53</option>
									<option value="54">54</option>
									<option value="55">55</option>
									<option value="56">56</option>
									<option value="57">57</option>
									<option value="58">58</option>
									<option value="59">59</option>
								</select>분
							</td>
                  			<th ><font color="#FF6600">*</font>ETA Date</th>
					  		<td >
								<input type="text" class="al" name="st_eta_date" id="st_eta_date" style="width:30%;" readOnly/>
								<a href="javascript:kepCalendar('st_eta_date')"></a>
								<select name="st_eta_hour" id="st_eta_hour">
									<option value="00">00</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
									<option value="21">21</option>
									<option value="22">22</option>
									<option value="23">23</option>
								</select>시
								<select name="st_eta_minute" id="st_eta_minute">
									<option value="00">00</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
									<option value="21">21</option>
									<option value="22">22</option>
									<option value="23">23</option>
									<option value="24">24</option>
									<option value="25">25</option>
									<option value="26">26</option>
									<option value="27">27</option>
									<option value="28">28</option>
									<option value="29">29</option>
									<option value="30">30</option>
									<option value="31">31</option>
									<option value="32">32</option>
									<option value="33">33</option>
									<option value="34">34</option>
									<option value="35">35</option>
									<option value="36">36</option>
									<option value="37">37</option>
									<option value="38">38</option>
									<option value="39">39</option>
									<option value="40">40</option>
									<option value="41">41</option>
									<option value="42">42</option>
									<option value="43">43</option>
									<option value="44">44</option>
									<option value="45">45</option>
									<option value="46">46</option>
									<option value="47">47</option>
									<option value="48">48</option>
									<option value="49">49</option>
									<option value="50">50</option>
									<option value="51">51</option>
									<option value="52">52</option>
									<option value="53">53</option>
									<option value="54">54</option>
									<option value="55">55</option>
									<option value="56">56</option>
									<option value="57">57</option>
									<option value="58">58</option>
									<option value="59">59</option>
								</select>분
					  		</td>
						 </tr>
						<tr>
                  			<th ><font color="#FF6600">*</font>Chargable Weight</th>
					  		<td >
								<input type="text" name="st_charg"  id="st_charg" class="al"   value =""  style="width:70%;"/> KG
					  		</td>
							<th><font color="#FF6600">*</font>B/L 첨부</th>
							<td>
								<a href="javascript:doPop('attachSet');"><img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
								<input type="hidden" name="st_image_key" id="st_image_key" value="">
							</td>
						 </tr>
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:240px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet", "", "240px");
				</script>
			</div>
			<div id="pageindex"></div>
			<br/>
			
			        <!--버튼영역-->
     
			<span class="fr">
  				<table border="0" cellspacing="0" cellpadding="0">
  					<TR>
  						<td>
  							  <span class="btn_06"><a href="javascript:doAction('save');" style="text-align:center;cursor:hand">B/L 생성</a></span>
  						</td>
  					</TR>
  				</table>
			</span>
		</div>	

    </div>
</form> 
</body>
</html>

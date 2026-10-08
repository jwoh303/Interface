<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) 데일리소싱(구매) 상세
* 기능 : 구매팀 견적 상세 (견적TF 2차)
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style type="text/css">
html, body{overflow:hidden;}
body{background-color:#e8e9ee;}
#popHeader{font-family:'Pretendard', sans-serif;}
#popHeader .title{letter-spacing:0px; font-family:'Pretendard', sans-serif;}
#popWrapper #popHeader{height:40px;}
#popHeader h1.title{top:9px; font-size:18px;}
#popHeader .popClose{top:11px;}
#popContainer{font-family:'Pretendard', sans-serif; background-color:#e8e9ee; padding:4px 12px 0 12px;}

input:focus, textarea:focus, select:focus{outline:none;}
.input30{height:22px; line-height:22px; padding:0 5px; color:#1b1b1b; font-size:13px; letter-spacing:-0.2px; font-weight:500; border:1px solid #DEDEDE; border-radius:4px; vertical-align:middle; box-sizing:border-box; background-color:#fff;}
.input30[readonly]{background-color:#f3f3f5;}
.Select{height:22px; line-height:20px; color:#24252B; font-size:13px; letter-spacing:-0.2px; font-weight:500; cursor:pointer; vertical-align:middle; border:1px solid #DEDEDE; border-radius:4px; background-color:#fff; box-sizing:border-box;}
.textarea{width:100%; box-sizing:border-box; border-radius:6px; padding:5px 8px; border:1px solid #DEDEDE; color:#24252B; font-size:13px; letter-spacing:-0.5px; font-weight:500; resize:none; background-color:#fff;}
.textarea[readonly]{background-color:#f3f3f5;}

.Btn-Searchimg{width:22px; height:22px; cursor:pointer; vertical-align:middle; background:url(/resources/imgs/btn_search_new.gif) no-repeat center; border:1px solid #DEDEDE; border-radius:4px;}
.Btn-eraser{width:22px; height:22px; cursor:pointer; vertical-align:middle; background:url(/resources/imgs/btn_eraser_new.gif) no-repeat center; border:1px solid #DEDEDE; border-radius:4px;}
.tip{vertical-align:middle; margin-bottom:2px; cursor:help;}
.desc-table.plain th, .desc-table.plain td{background-color:#fff !important; border:0 !important;}
.desc-table.plain tr.lbl th{padding:3px 2px 0 2px !important;}
.desc-table.plain td{padding:0 2px 1px 2px !important;}
.dely-box{display:flex; flex-direction:column;}
.dely-box .dely-icons{flex:1 1 auto; height:100%;}
.dely-box .dely-icons tr > *:first-child{border-left:0;}
.dely-box .dely-icons tr > *:last-child{border-right:0;}
.dely-box .dely-icons tr:last-child td{border-bottom:0;}
.ButOutline{height:28px; line-height:26px; padding:0 10px; font-size:13.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle;}
.ButOutline:hover{color:#fff; border:1px solid #595D7E; background:#595D7E;}
.ButOutline.hilite{background-color:#fff3c4; border-color:#e8b93c;}
.ButOutline.hilite:hover{color:#404046; background-color:#ffe38a;}
.ButOutline-on{height:28px; line-height:26px; padding:0 10px; font-size:13.5px; font-weight:500; letter-spacing:-0.5px; color:#fff; background-color:#595D7E; border:1px solid #595D7E; border-radius:6px; cursor:pointer; vertical-align:middle;}
.ArrowRight{height:28px; line-height:26px; padding:0 25px 0 10px; font-size:13.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle; background:url(/resources/imgs/arrow_right.png) no-repeat center right; background-size:25px 25px; background-color:#fff;}
.ArrowLeft{height:28px; line-height:26px; padding:0 10px 0 25px; font-size:13.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle; background:url(/resources/imgs/arrow_left_b.png) no-repeat center left; background-size:25px 25px; background-color:#fff;}
.ArrowRight:hover, .ArrowLeft:hover{background-color:#f6f6f6;}
.titBtn{height:22px; line-height:20px; padding:0 8px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:4px; cursor:pointer; vertical-align:middle;}
.titBtn:hover{background-color:#f6f6f6;}

.topbtn-area{height:30px;}
.topbtn-area p.page{display:inline-block; vertical-align:middle; padding:0 6px; font-size:14px; font-weight:500; letter-spacing:-0.5px; color:#404046;}
.topbtn-area p.reason{display:inline-block; margin-left:10px; vertical-align:middle; font-size:14px; font-weight:500; letter-spacing:-0.5px; color:#404046;}

.top-table{width:100%; table-layout:fixed; font-size:13px; color:#1b1b1b; border-top:2px solid #6a6a6a; border-bottom:1px solid #929292; background-color:#e8e9ee;}
.top-table th{padding-left:10px; height:26px; text-align:left; font-weight:500; letter-spacing:-0.5px; white-space:nowrap;}
.top-table td{white-space:nowrap;}
.top-table tr:first-child th, .top-table tr:first-child td{padding-top:2px;}
.top-table tr:last-child th, .top-table tr:last-child td{padding-bottom:2px;}

.MainArea{width:100%; display:grid; grid-template-columns:32% 31% 37%; align-items:stretch;}
.MainArea > .col{box-sizing:border-box; display:flex; flex-direction:column; overflow-y:auto; overflow-x:hidden; padding-right:6px; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.MainArea > .col-right{overflow:hidden; padding-right:0; display:flex; flex-direction:column;}
.Row2{display:grid; grid-template-columns:1fr 1fr; gap:6px;}
.Row3{display:grid; grid-template-columns:1fr 1fr 140px; gap:6px;}
.RowImg{display:grid; grid-template-columns:130px 1fr; gap:6px;}
.RowWide{display:grid; grid-template-columns:1fr 140px; gap:6px;}

.ContentBox, .ContentBox-Table{flex:none; position:relative; margin-top:4px; border:1px solid #DEDEDE; border-radius:10px; background-color:#fff;}
.ContentBox{padding:3px 10px 6px 10px;}
.grow{flex:1 1 auto !important; display:flex; flex-direction:column;}
.grow > .fill{flex:1 1 auto; height:auto !important;}
.ContentBox-Table{overflow:hidden;}
.ContentBox .title, .ContentBox-Table .title{position:relative; height:24px; line-height:24px; font-size:14px; font-weight:600; letter-spacing:-0.3px; color:#000;}
.ContentBox-Table .title{padding-left:12px;}
.title .right{position:absolute; top:0; right:0; font-size:13px; font-weight:400;}
.ContentBox-Table .title .right{right:10px;}
.title .right input[type=checkbox]{vertical-align:middle; width:16px; height:16px; margin:0 0 2px 3px;}
.sub-title{height:21px; line-height:21px; font-size:13px; font-weight:500; letter-spacing:-0.5px; color:#1b1b1b;}
.sub-title .right{float:right;}
.fxline{display:flex; align-items:center; gap:8px;}
.fxline .input30{flex:1; min-width:0;}

.desc-table{width:100%; table-layout:fixed; font-size:13px; color:#1b1b1b; background-color:#fff;}
.desc-table th{height:23px; text-align:left; font-weight:500; letter-spacing:-0.5px; white-space:nowrap; overflow:hidden;}
.desc-table td{height:23px; white-space:nowrap;}
.desc-table.tight th, .desc-table.tight td{height:21px;}
.desc-table tr.lbl th{height:18px; line-height:18px; padding-top:2px; font-size:12.5px; color:#404046;}
.desc-table td input.input30, .desc-table td select.Select{width:100%;}
.desc-table td .fx{display:flex; align-items:center; gap:3px;}
.desc-table td .fx input.input30, .desc-table td .fx select.Select{width:auto; flex:1; min-width:0;}
.desc-table td .fx .fix, .desc-table td .fx input.input30.fix, .desc-table td .fx select.Select.fix{flex:none;}
.desc-table td .fx input.input30.hasDatepicker{background-color:#fff;}
.desc-table td .fx .ui-datepicker-trigger{flex:none; cursor:pointer;}

.IBsheetScroll{overflow:auto; background-color:#fff; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.IBsheet-table{font-size:12.5px; color:#1b1b1b; background-color:#fff; border-collapse:collapse; table-layout:fixed;}
.IBsheet-table th{height:22px; padding:0 3px; font-weight:500; letter-spacing:-0.5px; text-align:center; border:1px solid #cbcbcb; background-color:#e4e5ea; white-space:nowrap; overflow:hidden;}
.IBsheet-table td{height:22px; padding:0 4px; border:1px solid #e1e1e1; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;}
.IBsheet-table td.empty{text-align:center; color:#888888;}
.IBsheet-table tr.base td{background-color:#f7f7f9;}
.IBsheet-table tr.base td:first-child{font-weight:500;}

.dely-icons{width:100%; table-layout:fixed; font-size:12px; text-align:center; border-collapse:collapse;}
.dely-icons th{height:21px; font-weight:500; background-color:#f1f2f4; border:1px solid #d5d8de;}
.dely-icons td{height:22px; border:1px solid #d5d8de;}
.mark-y{color:#1fa35a; font-weight:700;}
.mark-n{color:#e0434d; font-weight:700;}

.imgbox{height:108px; border:1px solid #eee; border-radius:6px; text-align:center; background-color:#fff;}
.imgbox img{width:90px; height:90px; margin-top:8px; border-radius:5px;}
.spec-table{width:100%; font-size:12.5px; border-collapse:collapse; table-layout:fixed;}
.spec-table th{height:22px; padding-left:8px; text-align:left; font-weight:500; background-color:#f3f3f5; border-bottom:1px solid #e6e6e6; white-space:nowrap;}
.spec-table td{height:22px; padding:0 3px; border-bottom:1px solid #e6e6e6;}
.spec-table td input{width:100%; height:22px; border:0; font-size:12.5px; box-sizing:border-box;}
.spec-table td.spec-msg{padding-left:8px; color:#888888; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
.radio-line{font-size:12.5px; white-space:nowrap; line-height:22px;}
.radio-line input{vertical-align:middle; margin:0 2px 2px 0;}
.radio-line label{margin-right:8px;}

.tab-container{flex:1; min-height:0; display:flex; flex-direction:column; margin-top:6px;}
.tabs{display:flex; gap:3px; flex:none;}
.tab-button{position:relative; flex:1; height:30px; line-height:30px; font-size:14px; font-weight:500; letter-spacing:-0.5px; color:#000; border:1px solid #dfdfdf; border-bottom:0px; background:#fff; cursor:pointer; border-top-left-radius:10px; border-top-right-radius:10px;}
.tab-button.active{color:#fff; z-index:2; border:1px solid #595d7e; border-bottom:0px; background:#595d7e;}
.tab-content{display:none; flex:1; min-height:0; flex-direction:column; border-top:2px solid #595d7e; border-bottom-left-radius:10px; border-bottom-right-radius:10px; background-color:#d6d7dd;}
.tab-content.active{display:flex;}
.tab-body{flex:1; min-height:0; display:flex; flex-direction:column; overflow-y:auto; padding:0 8px 6px 8px; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.tab-foot{flex:none; padding:3px 8px 4px 8px; border-top:1px solid #c3c4cb;}
.tab-foot div{height:32px; line-height:32px;}

.C-F6495F{color:#F6495F; letter-spacing:-0.2px;}
.C-2172EC{color:#2172EC !important; letter-spacing:-0.2px;}
.link{cursor:pointer;}

.top-table{border-collapse:collapse; border-top:2px solid #6a6a6a; border-bottom:0; background-color:#fff;}
.top-table th{background-color:#e4e6ea; border:1px solid #c9ccd2; padding:0 8px;}
.top-table td{background-color:#fff; border:1px solid #c9ccd2; padding:2px 4px;}
.ContentBox, .ContentBox-Table{border-radius:0; border-color:#c4c7ce;}
.ContentBox .title{margin:-3px -10px 1px -10px; padding:0 10px; background-color:#dfe1e6; border-bottom:1px solid #c4c7ce;}
.ContentBox .title .right{right:10px;}
.ContentBox-Table .title{background-color:#dfe1e6; border-bottom:1px solid #c4c7ce;}
.ContentBox > .fxline{margin:-3px -10px -6px -10px; padding:2px 10px; background-color:#dfe1e6;}
.fxline .title{margin:0 !important; padding:0 !important; background:none !important; border:0 !important;}
.desc-table{border-collapse:collapse;}
.desc-table th{background-color:#f1f2f4; border:1px solid #d5d8de; padding:0 6px !important;}
.desc-table td{border:1px solid #d5d8de; padding:1px 3px !important;}
.spec-table{border:1px solid #d5d8de;}
.spec-table th{border:1px solid #d5d8de; background-color:#f1f2f4;}
.spec-table td{border:1px solid #d5d8de;}
.imgbox{border-radius:0; border-color:#d5d8de;}
.sub-title{background-color:#f1f2f4; border:1px solid #d5d8de; border-bottom:0; padding:0 6px;}
.sub-title + .textarea, .sub-title + textarea{border-radius:0; border-color:#d5d8de;}
.mt04{margin-top:4px;}
.ContentBox{padding:0 !important;}
.ContentBox .title{margin:0 !important;}
.ContentBox .desc-table tr > *:first-child{border-left:0;}
.ContentBox .desc-table tr > *:last-child{border-right:0;}
.ContentBox .desc-table tr:first-child > *{border-top:0;}
.ContentBox .desc-table tr:last-child > *{border-bottom:0;}
.ContentBox > .RowImg + .desc-table tr:first-child > *{border-top:1px solid #d5d8de;}
.ContentBox .desc-table.plain tr > *:first-child{padding-left:8px !important;}
.ContentBox .desc-table.plain tr > *:last-child{padding-right:8px !important;}
.desc-table.plain tr:last-child > *{padding-bottom:6px !important;}
.ContentBox .sub-title{border-left:0; border-right:0; margin-top:0 !important;}
.ContentBox textarea.textarea{display:block; margin:0; border-width:0; border-radius:0;}
.ContentBox .sub-title + textarea.textarea{border-top:1px solid #d5d8de;}
.ContentBox > .input30, .ContentBox > select.Select{display:block; width:100%; height:26px; border-width:0; border-radius:0;}
.ContentBox > .radio-line{padding:3px 8px;}
.ContentBox > .ar{margin:0 !important; padding:4px 8px; border-top:1px solid #d5d8de;}
.ContentBox > .RowImg{gap:0;}
.ContentBox > .RowImg > div:first-child{border-right:1px solid #d5d8de;}
.ContentBox > .RowImg .imgbox{border:0; border-radius:0;}
.ContentBox > .RowImg .ButOutline{display:block; margin:0 !important; border-width:1px 0 0 0; border-radius:0;}
.ContentBox > .RowImg .radio-line{border-top:1px solid #d5d8de;}
.ContentBox > .RowImg .sub-title{border-top:0; border-radius:0 !important;}
.ContentBox > .RowImg .spec-table{border:0;}
.ContentBox > .RowImg .spec-table tr > *:first-child{border-left:0;}
.ContentBox > .RowImg .spec-table tr > *:last-child{border-right:0;}
#popContainer{padding:3px 10px 0 10px;}
.input30{height:20px; line-height:20px; font-size:12px;}
.Select{height:20px; line-height:18px; font-size:12px;}
.textarea{font-size:12px; padding:3px 6px;}
.Btn-Searchimg, .Btn-eraser{width:20px; height:20px; background-size:14px 14px;}
.ButOutline, .ButOutline-on, .ArrowLeft, .ArrowRight{height:26px; line-height:24px; font-size:12.5px;}
.titBtn{height:18px; line-height:16px; padding:0 6px; font-size:11.5px;}
.topbtn-area{height:28px;}
.topbtn-area p.page{font-size:13px;}
.top-table{font-size:12px;}
.top-table th{height:23px;}
.top-table td{padding:1px 4px;}
.ContentBox, .ContentBox-Table{margin-top:3px;}
.ContentBox .title, .ContentBox-Table .title{height:22px; line-height:22px; font-size:13px;}
.sub-title{height:19px; line-height:19px; font-size:12px;}
.desc-table{font-size:12px;}
.desc-table th, .desc-table td{height:21px;}
.desc-table.plain tr.lbl th{height:17px; line-height:17px; font-size:12px;}
.IBsheet-table{font-size:12px;}
.IBsheet-table th{height:20px;}
.IBsheet-table td{height:20px;}
.dely-icons{font-size:12px;}
.spec-table{font-size:12px;}
.spec-table th, .spec-table td{height:20px;}
.spec-table td input{height:20px; font-size:12px;}
.radio-line{font-size:12px; line-height:20px;}
.imgbox{height:92px;}
.imgbox img{width:78px; height:78px; margin-top:7px;}
.tab-container{margin-top:4px;}
.tab-button{height:26px; line-height:26px; font-size:13px;}
.tab-foot{padding:2px 8px 3px 8px;}
.tab-foot div{height:30px; line-height:30px;}
.title .right input[type=checkbox]{width:14px; height:14px;}
.sub-title .right input[type=checkbox]{width:14px !important; height:14px !important;}
.desc-table .titBtn{height:18px !important;}
.title .input30{height:17px; line-height:17px;}
.sub-title .titBtn{height:16px; line-height:14px; vertical-align:top; margin-top:1px;}
.desc-table th, .desc-table td{height:20px;}
.ContentBox .title, .ContentBox-Table .title{height:21px; line-height:21px;}
.sel-wrap{padding:4px 6px;}
.sel-wrap #trSel{display:block; width:100%; height:22px; margin:0; border:1px solid #DEDEDE; border-radius:4px; box-sizing:border-box;}
.att-ico{vertical-align:middle; cursor:pointer;}
.foot-line{display:flex; align-items:center; gap:4px; height:30px; flex-wrap:nowrap;}
.foot-line .spacer{flex:1 1 auto; min-width:4px;}
.foot-line button{flex:none; white-space:nowrap; padding:0 5px; font-size:12px; height:24px; line-height:22px;}
button{white-space:nowrap;}
.ContentBox .title, .ContentBox-Table .title{display:flex; align-items:center; gap:4px;}
.title .right{top:0; bottom:0; display:flex; align-items:center; gap:4px;}
.title .right > *, .title > button, .title > input, .title > img{margin-top:0 !important; margin-bottom:0 !important;}
.sub-title{display:flex; align-items:center;}
.sub-title .right{float:none; margin-left:auto; display:flex; align-items:center; gap:3px;}
.sub-title .right > *{margin:0 !important;}
.tip{margin-bottom:0; position:relative; top:0;}
th .tip{top:-1px;}
.IBsheet-table th .tip{top:-2px;}
.desc-table.plain tr.lbl th .tip{top:-2px;}
.topbtn-area{display:flex; align-items:center; justify-content:space-between;}
.topbtn-area > span, .topbtn-area .fr{float:none; display:flex; align-items:center; gap:4px;}
.maint-mask{display:none; position:fixed; left:0; top:0; right:0; bottom:0; z-index:1000; background-color:rgba(0,0,0,0.3);}
.maint-layer{position:absolute; left:50%; top:50%; width:640px; margin:-120px 0 0 -320px; background-color:#f1f1f1; border:1px solid #9a9ca5; box-shadow:0 2px 10px rgba(0,0,0,0.25);}
.maint-layer .maint-tit{display:flex; align-items:center; height:30px; padding:0 10px; background-color:#aaa6a6; color:#fff; font-size:14px; font-weight:600;}
.maint-layer .maint-tit a{margin-left:auto; color:#fff; font-size:16px; text-decoration:none;}
.maint-layer .maint-sub{height:22px; padding:0 10px; line-height:22px; background-color:#d3d3d3; font-size:12px; font-weight:600;}
.maint-layer table{width:100%; margin:8px 0; border-collapse:collapse;}
.maint-layer th{width:70px; padding:4px 0 4px 14px; text-align:left; vertical-align:top; font-size:12px; font-weight:400;}
.maint-layer td{padding:4px 14px 4px 0; font-size:12px;}
.maint-layer .Select{width:160px;}
.maint-layer .textarea{height:100px;}
.maint-layer .maint-btn{padding:0 14px 12px 0; text-align:right;}
</style>
</head>
<body onload="kep_onload_view();">
<input type="hidden" id="navKeys" value="<c:out value="${param.nav_keys}"/>">
<input type="hidden" id="navIdx" value="<c:out value="${param.nav_idx}"/>">
<input type="hidden" data-f="BTOA_USER_ID">
<input type="hidden" data-f="MAKER_CODE">
<input type="hidden" data-f="ORIGIN_CODE">
<input type="hidden" data-f="MAKER_NOT_REASON">
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">데일리소싱(구매)</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
	<div id="popContainer">
		<div class="topbtn-area">
			<span id="topLeftNormal">
				<button type="button" class="ButOutline" onclick="kepNotYet();">전체이력조회</button>
				<button type="button" class="ButOutline" onclick="openDupSearchPop();">중복검색</button>
			</span>
			<span id="topLeftReproc" style="display:none;">
				<button type="button" class="ButOutline" onclick="kepNotYet();">전체이력조회</button>
				<button type="button" class="ButOutline" onclick="kepNotYet();">접수</button>
				<p class="reason">재진행요청 사유 <input type="text" class="input30 C-2172EC" style="width:520px" id="reprocReason" value="" readonly></p>
			</span>
			<div class="fr">
				<button type="button" class="ButOutline" onclick="kepNotYet();">카테고리변경요청</button>
				<button type="button" class="ButOutline" onclick="openMaintLayer();">정비요청</button>
				<button type="button" class="ButOutline" id="btnAutoQuot" onclick="openAutoQuotReqPop();">자동견적요청</button>
				<button type="button" class="ButOutline" id="btnAgentSel" onclick="openAgentSelPop();">협력사선택</button>
				<button type="button" class="ArrowLeft" onclick="move(-1);">이전</button>
				<p class="page" id="pageInfo">0 / 0</p>
				<button type="button" class="ArrowRight" onclick="move(1);">다음</button>
			</div>
		</div>

		<table class="top-table">
			<colgroup>
				<col width="5.5%" /><col width="12%" /><col width="4%" />
				<col width="4.5%" /><col width="8.5%" />
				<col width="5.5%" /><col width="7%" />
				<col width="6%" /><col width="9%" />
				<col width="5.5%" /><col width="11%" />
				<col width="6.5%" /><col width="15%" />
			</colgroup>
			<tr>
				<th>고객사</th>
				<td colspan="2"><input type="text" class="input30 C-2172EC link" style="width:95%" data-f="BUYER_NAME" onclick="openBuyerPop();" readonly></td>
				<th>요청자</th>
				<td><input type="text" class="input30 C-2172EC link" style="width:92%" data-f="BTOA_USER_NAME" onclick="openUserPop();" readonly></td>
				<th>견적의뢰일</th>
				<td><input type="text" class="input30" style="width:92%" data-f="BTOA_DATE" data-fmt="date" readonly></td>
				<th>구매담당자</th>
				<td><input type="text" class="input30" style="width:92%" data-f="SM_MNG_NM" readonly></td>
				<th>카테고리</th>
				<td><input type="text" class="input30" style="width:95%" data-f="SG_NAME" readonly></td>
				<th>표준DB코드</th>
				<td>
					<input type="text" class="input30" style="width:62%" data-f="CMS_CODE" readonly>
					<input type="text" class="input30" style="width:32%" value="" readonly>
				</td>
			</tr>
			<tr>
				<th>견적번호</th>
				<td><input type="text" class="input30 C-2172EC link" style="width:97%" data-f="QUOTATION_NO" onclick="openQuotationPop();" readonly></td>
				<td><input type="text" class="input30 ac" style="width:95%" data-f="QUOTATION_SEQ" readonly></td>
				<th>견적Key</th>
				<td><input type="text" class="input30" style="width:92%" data-f="QUOTATION_KEY" readonly></td>
				<th>회신요청일</th>
				<td><input type="text" class="input30" style="width:92%" data-f="BTOA_END_DATE" data-fmt="date" readonly></td>
				<th>사업담당자</th>
				<td><input type="text" class="input30" style="width:92%" id="bizUserName" placeholder="영업 / 운영" title="영업 / 운영" readonly></td>
				<th>상세분류</th>
				<td><input type="text" class="input30" style="width:95%" data-f="CATEG_PATH" readonly></td>
				<th>DB매핑방식</th>
				<td><input type="text" class="input30" style="width:95%" data-f="DB_MAPPING_TYPE_NM" readonly></td>
			</tr>
		</table>

		<div class="MainArea" id="mainArea">
			<div class="col col-left">
				<div class="ContentBox">
					<div class="title">자동견적여부/지정·추천협력사 정보</div>
					<table class="desc-table">
						<colgroup><col width="24%" /><col width="76%" /></colgroup>
						<tr>
							<th>자동견적대상</th>
							<td><div class="fx">
								<input type="text" class="input30 fix" style="width:34px; text-align:center;" data-f="AUTO_QUOT_YN" readonly>
								<input type="text" class="input30 fix C-2172EC link" style="width:34px; text-align:center;" data-f="RECOM_AGENT_CNT" onclick="openAgentRcmdPop();" readonly>
								<input type="text" class="input30 C-2172EC link" value="" onclick="openAgentRcmdPop();" readonly>
							</div></td>
						</tr>
					</table>
				</div>

				<div class="ContentBox-Table">
					<div class="title">요청정보 및 변경이력</div>
					<div class="IBsheetScroll" style="height:80px;">
						<table class="IBsheet-table" style="width:1130px;">
							<colgroup>
								<col width="60" /><col width="90" /><col width="120" /><col width="150" /><col width="110" /><col width="70" />
								<col width="50" /><col width="45" /><col width="50" /><col width="90" /><col width="70" /><col width="125" /><col width="100" />
							</colgroup>
							<tr><th>구분</th><th>품목코드</th><th>품목명</th><th>규격</th><th>제조사</th><th>원산지</th><th>수량</th><th>단위</th><th>선입고</th><th>표준DB</th><th>변경자</th><th>변경일시</th><th>변경단계</th></tr>
							<tr class="base">
								<td class="ac">최초요청</td>
								<td data-f="BUYER_ITEM_NO"></td>
								<td data-f="DESCRIPTION"></td>
								<td data-f="SPECIFICATION"></td>
								<td data-f="MAKER_NAME"></td>
								<td data-f="ORIGIN_NAME"></td>
								<td class="ar" data-f="ITEM_QTY" data-fmt="num"></td>
								<td class="ac" data-f="UNIT_MEASURE"></td>
								<td class="ac" data-f="PRE_GR_FLAG" data-fmt="yn"></td>
								<td data-f="CMS_CODE"></td>
								<td></td><td></td><td></td>
							</tr>
						</table>
					</div>
				</div>

				<div class="Row2">
					<div class="ContentBox-Table dely-box">
						<div class="title">고객사 배송조건</div>
						<table class="dely-icons">
							<tr><th>TR</th><th>간선여부</th><th>택배</th><th>직접방문</th></tr>
							<tr><td>-</td><td>-</td><td>-</td><td>-</td></tr>
							<tr><th colspan="4">고객사 관리번호</th></tr>
							<tr><td colspan="4" style="text-align:left; padding:0 4px;"></td></tr>
						</table>
					</div>
					<div class="ContentBox">
						<div class="title">고객사 특이사항</div>
						<table class="desc-table">
							<colgroup><col width="62%" /><col width="38%" /></colgroup>
							<tr><th>MOQ설정</th><td><input type="text" class="input30 ac" value="" readonly></td></tr>
							<tr><th>필수참여업체수</th><td><input type="text" class="input30 ac" value="" readonly></td></tr>
							<tr><th>비딩내역공개</th><td><input type="text" class="input30 ac" value="" readonly></td></tr>
							<tr><th>고객사 그룹여부</th><td><input type="text" class="input30 ac" value="" readonly></td></tr>
							<tr><th>제출비고기재</th><td><input type="text" class="input30 ac" value="" readonly></td></tr>
						</table>
					</div>
				</div>

				<div class="ContentBox grow" style="min-height:50px;">
					<div class="title">고객사비고 <span class="right">전달<input type="checkbox" data-f="BTOA_REMARK_PASS_FLAG" data-fmt="chk" disabled></span></div>
					<textarea class="textarea fill" rows="1" style="height:22px; min-height:22px;" data-f="BTOA_REMARK" readonly></textarea>
				</div>

				<div class="ContentBox">
					<div class="title">URL</div>
					<input type="text" class="input30 C-2172EC link" style="width:100%" data-f="REMARK_URL" onclick="kepOpenUrl(this.value);" readonly>
				</div>

				<div class="ContentBox-Table">
					<div class="title">첨부(B) <span class="right">전달<input type="checkbox" data-f="IMAGE_PASS_FLAG" data-fmt="chk" disabled></span></div>
					<div class="IBsheetScroll" style="height:60px;">
						<table class="IBsheet-table" style="width:100%;">
							<colgroup><col width="25%" /><col width="75%" /></colgroup>
							<tr><th>구분</th><th>파일명</th></tr>
							<tr><td colspan="2" class="empty" id="attachInfo"></td></tr>
						</table>
					</div>
				</div>

				<div class="ContentBox-Table" style="margin-bottom:1px;">
					<div class="title">규제·인증 관리정보</div>
					<table class="IBsheet-table" style="width:100%;">
						<colgroup><col width="26%" /><col width="20%" /><col width="20%" /><col width="34%" /></colgroup>
						<tr>
							<th>관리항목</th>
							<th>관리대상 <img src="/resources/images/but_query.png" class="tip" title="▶ 관리대상 – KeP 상세분류 기준으로 설정되어 있으며,&#10;관리대상에 해당하는 상세분류인 경우 Y 표시"></th>
							<th>관리유형 <img src="/resources/images/but_query.png" class="tip" title="▶ 관리유형 – KeP 상세분류 기준으로 설정&#10;- 안전인증정보 → 상세분류 별로 KC인증, KFI인증, KCS 세가지 인증으로 구분&#10;- 화학물질정보 → MSDS, 안전확인대상 생활화학제품 중 해당하는 자료로 제출"></th>
							<th>고객사 요청사항 <img src="/resources/images/but_query.png" class="tip" title="▶ 고객사 요청사항&#10;- 안전인증정보 → 안전인증 완료된 제품으로 제출&#10;- 화학물질정보 → MSDS, 안전확인대상 생활화학제품 중 해당하는 자료로 제출"></th>
						</tr>
						<tr><td class="ac">안전인증정보</td><td class="ac" data-f="SAFETY_CERT_YN" data-fmt="yn"></td><td class="ac"></td><td class="ac C-F6495F"></td></tr>
						<tr><td class="ac">화학물질정보</td><td class="ac" data-f="CHEMICAL_YN" data-fmt="yn"></td><td class="ac"></td><td class="ac C-F6495F"></td></tr>
					</table>
				</div>
			</div>

			<div class="col col-mid">
				<div class="ContentBox">
					<div class="title">상품정보(표준DB)
						<span class="right">품목코드 <img id="imgRegItem" src="/resources/images/rd_pin.gif" title="기등록 품목" style="display:none; cursor:pointer; vertical-align:middle;" onclick="kepNotYet();"> <input type="text" class="input30" style="width:120px" data-f="BUYER_ITEM_NO" readonly></span>
					</div>
					<table class="desc-table plain">
						<colgroup><col width="62%" /><col width="38%" /></colgroup>
						<tr class="lbl">
							<th>품목명</th>
							<th>모델번호 <img src="/resources/images/but_query.png" class="tip" title="▶ 모델번호 – 고객사 화면에도 노출되는 값이며, 기재 시 RPA 시장가 확인 가능"></th>
						</tr>
						<tr>
							<td><input type="text" class="input30" data-f="DESCRIPTION"></td>
							<td><input type="text" class="input30" data-f="MAKER_PART_NO"></td>
						</tr>
						<tr class="lbl"><th colspan="2">규격</th></tr>
						<tr><td colspan="2"><input type="text" class="input30" data-f="SPECIFICATION" readonly></td></tr>
					</table>
					<table class="desc-table plain">
						<colgroup><col width="36%" /><col width="30%" /><col width="16%" /><col width="18%" /></colgroup>
						<tr class="lbl"><th>제조사</th><th style="padding-left:6px;">원산지</th><th style="padding-left:6px;">수량</th><th style="padding-left:6px;">단위</th></tr>
						<tr>
							<td><div class="fx"><input type="text" class="input30" data-f="MAKER_NAME"><button type="button" class="Btn-Searchimg fix" onclick="openMakerPop();"></button></div></td>
							<td style="padding-left:6px;"><div class="fx"><input type="text" class="input30" data-f="ORIGIN_NAME"><button type="button" class="Btn-Searchimg fix" onclick="openCountryPop();"></button></div></td>
							<td style="padding-left:6px;"><input type="text" class="input30 ar" data-f="ITEM_QTY" data-fmt="num"></td>
							<td style="padding-left:6px;"><select class="Select" id="unitSel"><option value=""></option></select></td>
						</tr>
					</table>
				</div>

				<div class="ContentBox">
					<div class="RowImg">
						<div>
							<div class="imgbox"><img src="/resources/images/noimage.gif" alt="" /></div>
							<button type="button" class="ButOutline mt04" style="width:100%" onclick="kepNotYet();">이미지등록</button>
						</div>
						<div>
							<div class="sub-title" style="text-align:center; background-color:#f3f3f5; border-radius:4px;">상세규격</div>
							<div class="IBsheetScroll" style="height:102px;">
								<table class="spec-table" id="specTable">
									<colgroup><col width="38%" /><col width="62%" /></colgroup>
									<tr class="spec-fixed"><th>모델번호</th><td><input type="text" data-f="MAKER_PART_NO" readonly></td></tr>
								</table>
							</div>
						</div>
					</div>
				</div>

				<div class="Row3">
					<div class="ContentBox">
						<div class="title">피베이스구분 <img src="/resources/images/but_query.png" class="tip" title="▶ 일반상품 / 피베이스상품으로 구분&#10;상품 등록 후에도 피가 유지되어야 하는 상품은 피베이스상품으로 등록&#10;피베이스 대상 고객사는 유형3 판매권고가 기재 불가"></div>
						<div class="radio-line"><label><input name="rd_fee" type="radio" checked>일반</label><label><input name="rd_fee" type="radio">피베이스</label></div>
					</div>
					<div class="ContentBox">
						<div class="title">상품구분 <img src="/resources/images/but_query.png" class="tip" title="▶ 표준품 - 인터넷 검색 시 확인 가능한 시중품&#10;▶ 비표준품 - 제작/설치/수리/금형포함/로고포함 등의 표준적이지 않거나 추가 가공이 포함된 품목"></div>
						<div class="radio-line"><label><input name="rd_std" type="radio" checked>표준품</label><label><input name="rd_std" type="radio">비표준품</label></div>
					</div>
					<div class="ContentBox">
						<div class="title">일회성구분 <img src="/resources/images/but_query.png" class="tip" title="▶ 일반 - 정기거래 가능한 상품&#10;▶ 일회성 - 수리, 설치 등 인건비 포함 및 금형비 포함, 단종이나 일회성으로 수급이 가능한 경우"></div>
						<div class="radio-line"><label><input name="rd_once" type="radio" checked>일반</label><label><input name="rd_once" type="radio">일회성</label></div>
					</div>
				</div>

				<div class="RowWide">
					<div class="ContentBox">
						<div class="title">TR 취급가능여부 <img src="/resources/images/but_query.png" class="tip" title="▶ 상품이 TR 납품 가능한 품목인지 선택 (고객사 조건과 상관없이 상품만으로 판단)&#10;불가 선택 시 협력사 화면 배송조건에 TR은 불가로 노출"><span class="right"><button type="button" class="titBtn" onclick="openTrStdPop();">참고</button></span></div>
						<div class="sel-wrap">
						<select class="Select" id="trSel">
							<option value="">선택</option>
							<option>가능</option>
							<option>불가(중량물/부피물/장축물)</option>
							<option>불가(극냉동-시약)</option>
							<option>불가(위험물/유해화학물질)</option>
							<option>불가(파손주의품)</option>
							<option>불가(냉동/냉장-식품)</option>
							<option>불가(고가품)</option>
							<option>불가(설치/수리품)</option>
						</select>
						</div>
					</div>
					<div class="ContentBox">
						<div class="title">직송필요 <img src="/resources/images/but_query.png" class="tip" title="▶ 고객사 요청 시 직송으로 배송조건을 노출&#10;체크 시 협력사 선택 팝업·협력사 견적 화면의 배송조건이 직송 기준으로 변경 (TR은 불가로 노출)"></div>
						<div class="radio-line"><label><input type="checkbox">고객사 직송 납품</label></div>
					</div>
				</div>

				<div class="RowWide">
					<div class="ContentBox">
						<div class="title">지정협력사</div>
						<table class="desc-table">
							<colgroup><col width="20%" /><col width="80%" /></colgroup>
							<tr><th>고객사</th><td><input type="text" class="input30" data-f="BUYER_ASSIGN_AGENT_NAME" readonly></td></tr>
							<tr><th>운영사</th><td><div class="fx"><input type="text" class="input30" style="cursor:pointer;" data-f="ASSIGN_AGENT_NAME" onclick="kepNotYet();" readonly><button type="button" class="Btn-eraser fix" onclick="kepNotYet();"></button></div></td></tr>
						</table>
					</div>
					<div class="ContentBox">
						<div class="title">선입고여부</div>
						<div class="radio-line" style="line-height:42px;"><label><input type="checkbox" data-f="PRE_GR_FLAG" data-fmt="chk">선입고</label></div>
					</div>
				</div>

				<div class="ContentBox-Table grow" style="margin-bottom:3px; min-height:90px;">
					<div class="title">운영 특이사항 <span class="right"><button type="button" class="titBtn" onclick="kepNotYet();">상세보기</button></span></div>
					<div class="IBsheetScroll fill" style="height:40px;">
						<table class="IBsheet-table" style="width:100%;">
							<colgroup><col width="9%" /><col width="21%" /><col width="70%" /></colgroup>
							<tr><th>No</th><th>구분</th><th>내용</th></tr>
							<tr><td colspan="3" class="empty">임시 화면 - 조회 미연결</td></tr>
						</table>
					</div>
				</div>
			</div>

			<div class="col col-right">
				<div class="tab-container">
					<div class="tabs">
						<button type="button" class="tab-button active" onclick="openTab(0);">견적진행</button>
						<button type="button" class="tab-button" onclick="openTab(1);">선정정보</button>
						<button type="button" class="tab-button" onclick="openTab(2);">기타비고</button>
					</div>

					<div class="tab-content active">
						<div class="tab-body">
							<div class="ContentBox">
								<table class="desc-table">
									<colgroup><col width="17%" /><col width="33%" /><col width="19%" /><col width="31%" /></colgroup>
									<tr>
										<th>견적요청일시</th>
										<td><div class="fx"><input type="text" class="input30" data-f="ATOS_DATE" data-fmt="date" readonly><input type="text" class="input30 fix" style="width:56px" value="" readonly></div></td>
										<th style="padding-left:10px;">고객사 요청단가</th>
										<td><div class="fx"><input type="text" class="input30 fix ac" style="width:56px" value="" readonly><input type="text" class="input30 ar" data-f="BUYER_TARGET_PRICE" data-fmt="num" readonly></div></td>
									</tr>
									<tr>
										<th>견적마감일시</th>
										<td><div class="fx"><input type="text" class="input30" data-f="ATOS_END_DATE" data-fmt="date" readonly><input type="text" class="input30 fix" style="width:56px" data-f="ATOS_END_TIME" data-fmt="hm" readonly></div></td>
										<th style="padding-left:10px;">RPA 시장단가</th>
										<td><input type="text" class="input30 ar C-2172EC link" value="" onclick="kepNotYet();" readonly></td>
									</tr>
								</table>
							</div>

							<div class="ContentBox">
								<div class="title">견적진행내용</div>
								<div class="sub-title">협력사 전달비고 (KeP ▶ 협력사)
									<span class="right">첨부파일 <img src="/resources/images/disk_off.gif" class="att-ico" title="첨부파일" onclick="kepNotYet();">&nbsp; 이미지필수 <input type="checkbox" style="vertical-align:middle; width:14px; height:14px;"></span>
								</div>
								<textarea class="textarea" style="height:72px;" data-f="ATOS_REMARK" readonly></textarea>
								<div class="sub-title mt04">운영사 비고</div>
								<textarea class="textarea" style="height:52px; cursor:pointer;" data-f="ATOA_REMARK" onclick="kepNotYet();" readonly></textarea>
							</div>

							<div class="ContentBox-Table grow" style="min-height:160px;">
								<div class="title">진행현황 <input type="text" class="input30 ac" style="width:60px; height:17px; line-height:17px;" id="recvCnt" readonly>
									<span class="right">견적차수: <span id="revision">0</span>차 <button type="button" class="titBtn" onclick="kepNotYet();">이력보기</button></span>
								</div>
								<div class="IBsheetScroll fill" style="height:60px;">
									<table class="IBsheet-table" style="width:1690px;">
										<colgroup>
											<col width="30" /><col width="55" /><col width="120" /><col width="85" /><col width="70" /><col width="70" /><col width="60" /><col width="65" /><col width="65" />
											<col width="60" /><col width="170" /><col width="50" /><col width="45" /><col width="65" /><col width="65" /><col width="100" /><col width="50" /><col width="75" /><col width="100" /><col width="95" /><col width="95" />
										</colgroup>
										<tr>
											<th><input type="checkbox" disabled></th><th>상태</th><th>협력사명</th><th>매입단가<br/>(VAT별도)</th><th>최소주문<br/>수량</th><th>주문배수<br/>수량</th><th>배송일수</th><th>거래유형</th><th>배송유형</th>
											<th>입고TR</th><th>협력사 제출비고</th><th>선입고</th><th>첨부</th><th>과세구분</th><th>품목구분</th><th>협력사 품목코드</th><th>MSDS</th><th>안전인증여부</th><th>안전인증번호</th><th>매입단가<br/>시작일</th><th>매입단가<br/>종료일</th>
										</tr>
										<tr><td colspan="21" class="empty" style="text-align:left; padding-left:200px;">임시 화면 - 조회 미연결</td></tr>
									</table>
								</div>
							</div>
						</div>
						<div class="tab-foot">
							<div class="foot-line">
								<button type="button" class="ButOutline" onclick="kepNotYet();">재견적요청</button>
								<button type="button" class="ButOutline" onclick="kepNotYet();">견적조기마감</button>
								<button type="button" class="ButOutline" onclick="kepNotYet();">견적독려메일</button>
								<button type="button" class="ButOutline" onclick="extendEndTime();">마감시간연장</button>
								<button type="button" class="ButOutline" onclick="quotInit();">견적초기화</button>
								<span class="spacer"></span>
								<button type="button" class="ButOutline" onclick="saveCurrent();">저장</button>
								<button type="button" class="ButOutline-on" onclick="kepNotYet();">협력사선정</button>
							</div>
						</div>
					</div>

					<div class="tab-content">
						<div class="tab-body">
							<div class="ContentBox">
								<div class="title">선정내용 <span class="right">고객사 부가세포함가 노출여부 <img src="/resources/images/but_query.png" class="tip" title="▶ 부가세포함 – 고객사의 부가세 환급(매입세액 공제) 가능 여부에 따라,&#10;부가세포함과 부가세미포함으로 구분 (고객사에 따라 구분되는 값)"> <input type="text" class="input30 ac" style="width:30px" value="" readonly></span></div>
								<div class="RowImg" style="grid-template-columns:96px 1fr;">
									<div>
										<div class="imgbox" style="height:84px;"><img src="/resources/images/noimage.gif" alt="" style="width:72px; height:72px; margin-top:6px;" /></div>
										<div class="radio-line ac"><label><input type="checkbox">이미지</label></div>
									</div>
									<div>
										<div class="sub-title">협력사 제출비고 (협력사 ▶ KeP)</div>
										<textarea class="textarea" style="height:78px;" readonly></textarea>
									</div>
								</div>
								<table class="desc-table mt04">
									<colgroup><col width="20%" /><col width="30%" /><col width="20%" /><col width="30%" /></colgroup>
									<tr>
										<th>협력사명</th>
										<td colspan="2"><input type="text" class="input30 C-2172EC link" data-f="PICK_AGENT_NAME" onclick="kepNotYet();" readonly></td>
										<td style="padding-left:6px;"><input type="text" class="input30" value="" readonly></td>
									</tr>
									<tr>
										<th>매입단가<span style="font-size:11px;">(VAT별도)</span></th>
										<td><input type="text" class="input30 ar" data-f="STOA_LIST_PRICE" data-fmt="num" readonly></td>
										<th style="padding-left:10px;">매입단가<span style="font-size:11px;">(VAT포함)</span></th>
										<td><input type="text" class="input30 ar" value="" readonly></td>
									</tr>
									<tr>
										<th>최소주문수량</th><td><input type="text" class="input30 ar" value=""></td>
										<th style="padding-left:10px;">주문배수수량</th><td><input type="text" class="input30 ar" value=""></td>
									</tr>
									<tr>
										<th>거래유형</th><td><select class="Select"><option></option></select></td>
										<th style="padding-left:10px;">배송유형</th><td><select class="Select"><option></option></select></td>
									</tr>
									<tr>
										<th>입고TR</th><td><select class="Select"><option></option></select></td>
										<th style="padding-left:10px;">배송일수</th><td><input type="text" class="input30 ar" value="" readonly></td>
									</tr>
									<tr>
										<th>협력사품목코드</th><td><input type="text" class="input30" value=""></td>
										<th style="padding-left:10px;">품목구분</th><td><select class="Select"><option></option></select></td>
									</tr>
									<tr>
										<th>선입고여부</th><td><select class="Select"><option></option><option>Y</option><option>N</option></select></td>
										<th style="padding-left:10px;">첨부파일</th><td><img src="/resources/images/disk_off.gif" class="att-ico" title="첨부파일" onclick="kepNotYet();"></td>
									</tr>
									<tr>
										<th>과세구분</th><td><select class="Select"><option></option></select></td>
										<td colspan="2"></td>
									</tr>
									<tr>
										<th>매입단가 유효기간</th>
										<td colspan="3"><div class="fx"><input type="text" class="input30 ac" id="sel_price_start_date" readonly> ~ <input type="text" class="input30 ac" id="sel_price_end_date" readonly></div></td>
									</tr>
								</table>
							</div>

							<div class="ContentBox">
								<div class="title">화학물질 제출정보</div>
								<table class="desc-table">
									<colgroup><col width="20%" /><col width="30%" /><col width="20%" /><col width="30%" /></colgroup>
									<tr>
										<th>MSDS</th><td><img src="/resources/images/disk_off.gif" class="att-ico" title="첨부파일" onclick="kepNotYet();"></td>
										<th style="padding-left:10px;">유해화학물질</th><td><select class="Select"><option></option><option>Y</option><option>N</option></select></td>
									</tr>
									<tr>
										<th>보관조건/온도</th>
										<td colspan="3"><div class="fx">
											<select class="Select fix" style="width:80px"><option></option></select>
											<select class="Select fix" style="width:42px"><option>-</option><option>+</option></select><input type="text" class="input30 fix ar" style="width:48px" value="">℃ ~
											<select class="Select fix" style="width:42px"><option>-</option><option>+</option></select><input type="text" class="input30 fix ar" style="width:48px" value="">℃
											<button type="button" class="titBtn fix" onclick="kepNotYet();">상세보기</button>
										</div></td>
									</tr>
								</table>
							</div>

							<div class="ContentBox">
								<div class="title">안전인증 제출정보</div>
								<table class="desc-table">
									<colgroup><col width="20%" /><col width="30%" /><col width="20%" /><col width="30%" /></colgroup>
									<tr>
										<th>안전인증여부</th><td><select class="Select"><option></option></select></td>
										<th style="padding-left:10px;">안전인증번호</th><td><input type="text" class="input30" value=""></td>
									</tr>
								</table>
							</div>

							<div class="ContentBox-Table">
								<div class="title">표준DB 기존 구매정보</div>
								<div class="IBsheetScroll" style="height:110px;">
									<table class="IBsheet-table" style="width:880px;">
										<colgroup><col width="35" /><col width="50" /><col width="120" /><col width="85" /><col width="65" /><col width="65" /><col width="70" /><col width="75" /><col width="65" /><col width="65" /><col width="95" /></colgroup>
										<tr><th>No</th><th>상태</th><th>협력사명</th><th>매입단가<br/>(VAT별도)</th><th>최소주문<br/>수량</th><th>주문배수<br/>수량</th><th>거래유형</th><th>배송조건</th><th>입고TR</th><th>배송일수</th><th>매입단가<br/>종료일</th></tr>
										<tr><td colspan="11" class="empty" style="text-align:left; padding-left:200px;">임시 화면 - 조회 미연결</td></tr>
									</table>
								</div>
							</div>

							<div class="ContentBox">
								<div class="title">판매기준가 <button type="button" class="titBtn" onclick="kepNotYet();">매익율계산기</button></div>
								<table class="desc-table">
									<colgroup><col width="12%" /><col width="46%" /><col width="16%" /><col width="26%" /></colgroup>
									<tr>
										<th>유형1</th><td><input type="text" class="input30" value="전체 카테고리 평균 매익율" readonly></td>
										<td style="padding-left:6px;"><div class="fx"><input type="text" class="input30 ar" value="" readonly><span class="fix">%</span></div></td>
										<td style="padding-left:6px;"><div class="fx"><input type="text" class="input30 ar" value="" readonly><span class="fix">원</span></div></td>
									</tr>
									<tr>
										<th>유형2</th><td><input type="text" class="input30" value="고객사 카테고리 평균 매익율" readonly></td>
										<td style="padding-left:6px;"><div class="fx"><input type="text" class="input30 ar" value="" readonly><span class="fix">%</span></div></td>
										<td style="padding-left:6px;"><div class="fx"><input type="text" class="input30 ar" value="" readonly><span class="fix">원</span></div></td>
									</tr>
									<tr>
										<th>유형3</th><td><input type="text" class="input30" value="판매권고가(구매 수기입력)" readonly></td>
										<td style="padding-left:6px;"><div class="fx"><input type="text" class="input30 ar" value="" readonly><span class="fix">%</span></div></td>
										<td style="padding-left:6px;"><div class="fx"><input type="text" class="input30 ar" value=""><span class="fix">원</span></div></td>
									</tr>
								</table>
							</div>

							<div class="ContentBox">
								<div class="title">고객사 그룹관리</div>
								<table class="desc-table">
									<colgroup><col width="30%" /><col width="70%" /></colgroup>
									<tr>
										<th>그룹여부/적용고객사</th>
										<td><div class="fx"><input type="text" class="input30 fix ac" style="width:34px" value="" readonly><select class="Select"><option>전체</option></select></div></td>
									</tr>
								</table>
							</div>
						</div>
						<div class="tab-foot">
							<div class="foot-line">
								<button type="button" class="ButOutline" onclick="kepNotYet();">재견적요청</button>
								<button type="button" class="ButOutline" onclick="quotInit();">견적초기화</button>
								<span class="spacer"></span>
								<button type="button" class="ButOutline" onclick="saveCurrent();">저장</button>
								<button type="button" class="ButOutline-on" onclick="kepNotYet();">매입가제출</button>
							</div>
						</div>
					</div>

					<div class="tab-content">
						<div class="tab-body">
							<div class="ContentBox">
								<div class="title">MSDS 제출</div>
								<table class="desc-table">
									<colgroup><col width="26%" /><col width="74%" /></colgroup>
									<tr><th>진행상태</th><td><input type="text" class="input30" data-f="CMC_REQ_STATUS" readonly></td></tr>
									<tr><th>요청일시</th><td><input type="text" class="input30" value="" readonly></td></tr>
									<tr><th>제출 예외사유</th><td><input type="text" class="input30" value="" readonly></td></tr>
									<tr><th>MSDS NO</th><td><input type="text" class="input30" value="" readonly></td></tr>
									<tr><th>생활화학제품 NO</th><td><input type="text" class="input30" value="" readonly></td></tr>
								</table>
								<div class="ar mt04">
									<button type="button" class="titBtn" onclick="kepNotYet();">MSDS독려메일</button>
									<button type="button" class="titBtn" onclick="msdsReq();">MSDS제출요청</button>
								</div>
							</div>

							<div class="ContentBox">
								<div class="title">전달내용(영업)</div>
								<div class="sub-title">매입가제출 비고 (구매 ▶ 영업)</div>
								<textarea class="textarea" style="height:52px;"></textarea>
								<div class="sub-title mt04">재진행요청 비고 (영업 ▶ 구매)</div>
								<textarea class="textarea" style="height:52px;" readonly></textarea>
							</div>

							<div class="ContentBox">
								<div class="title">전달내용(DB관리)</div>
								<div class="sub-title">중복확인 비고 (구매 ▶ DB관리)</div>
								<textarea class="textarea" style="height:52px;"></textarea>
								<div class="sub-title mt04">중복재확인 비고 (DB관리 ▶ 구매)</div>
								<textarea class="textarea" style="height:52px;" readonly></textarea>
							</div>

							<div class="ContentBox">
								<div class="title">진행사유 이력</div>
								<div class="sub-title">단수견적사유</div>
								<textarea class="textarea" style="height:42px;" readonly></textarea>
								<div class="sub-title mt04">최저가업체 미선정사유</div>
								<textarea class="textarea" style="height:42px;" readonly></textarea>
								<div class="sub-title mt04">필수참여업체수 미만 진행사유</div>
								<textarea class="textarea" style="height:42px;" readonly></textarea>
								<div class="sub-title mt04">요청단가 초과사유(매입단가 기준)</div>
								<textarea class="textarea" style="height:42px;" readonly></textarea>
							</div>
						</div>
						<div class="tab-foot">
							<div class="foot-line">
								<button type="button" class="ButOutline" onclick="kepNotYet();">재견적요청</button>
								<button type="button" class="ButOutline" onclick="quotInit();">견적초기화</button>
								<span class="spacer"></span>
								<button type="button" class="ButOutline" onclick="saveCurrent();">저장</button>
								<button type="button" class="ButOutline-on" onclick="kepNotYet();">매입가제출</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="maint-mask" id="maintLayer">
	<div class="maint-layer">
		<div class="maint-tit">정비요청 <a href="javascript:closeMaintLayer();">✕</a></div>
		<div class="maint-sub">요청정보</div>
		<table>
			<tr>
				<th>정비구분</th>
				<td>
					<select class="Select" id="maint_req_type"></select>
					<span style="margin-left:20px;">정비첨부</span>
					<a href="javascript:openMaintFile();"><img id="maint_file_img" src="/resources/images/disk_off.gif" style="vertical-align:middle;" alt="첨부"></a>
					<input type="hidden" id="maint_image_key" value="">
				</td>
			</tr>
			<tr>
				<th>요청사유</th>
				<td><textarea class="textarea" id="maint_req_note" maxlength="2000"></textarea></td>
			</tr>
		</table>
		<div class="maint-btn"><button type="button" class="ButOutline" onclick="saveMaintReq();">요청</button></div>
	</div>
</div>
</body>

<script type="text/javascript">
var keys = [];
var idx = 0;
var snapshot = null;
var loading = false;
var popupSel = "";
var dupMapping = null;
var cur = null;

function kep_onload_view() {
	var raw = $("#navKeys").val().split(",");
	for (var i = 0; i < raw.length; i++) {
		var k = raw[i].split("^");
		if (k.length == 4) keys.push({buyer: k[0], no: k[1], seq: k[2], rev: k[3]});
	}
	idx = parseInt($("#navIdx").val(), 10) || 0;
	if (idx < 0 || idx >= keys.length) idx = 0;
	kepSetCalender("sel_price_start_date");
	kepSetCalender("sel_price_end_date");
	fitLayout();
	$(window).on("resize", fitLayout);
	$(window).on("beforeunload", function() {
		if (isDirty()) return "저장하지 않은 내용이 있습니다.";
	});
	if (keys.length == 0) {
		alert("목록 화면에서 다시 열어 주세요.");
		self.close();
		return;
	}
	show();
}

function fitLayout() {
	var $m = $("#mainArea");
	var h = $(window).height() - $m.offset().top - 6;
	if (h < 300) h = 300;
	$m.css("height", h + "px");
	$m.children(".col").css("height", h + "px");
}

function formFields() {
	return $("input, select, textarea").not("[type=hidden], :button, #maintLayer *");
}

function formState() {
	var a = [];
	formFields().each(function() {
		a.push((this.type == "checkbox" || this.type == "radio") ? (this.checked ? "1" : "0") : $(this).val());
	});
	return a.join("\u0001");
}

function takeSnapshot() {
	snapshot = formState();
}

function isDirty() {
	return snapshot != null && formState() != snapshot;
}

function resetForm() {
	formFields().each(function() {
		if (this.type == "checkbox" || this.type == "radio") {
			this.checked = this.defaultChecked;
		} else if (this.tagName == "SELECT") {
			var found = false;
			for (var i = 0; i < this.options.length; i++) {
				this.options[i].selected = this.options[i].defaultSelected;
				if (this.options[i].defaultSelected) found = true;
			}
			if (!found && this.options.length > 0) this.selectedIndex = 0;
		} else {
			this.value = this.defaultValue;
		}
	});
}

function show() {
	var k = keys[idx];
	loading = true;
	dupMapping = null;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/getMasterMpRqDailySourcingPurchaseDetail.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { st_buyer: k.buyer, st_quotation_no: k.no, st_quotation_seq: k.seq, st_revision: k.rev },
		success: function(response) {
			loading = false;
			if (response && response.errMsg) {
				alert(response.errMsg);
				return;
			}
			if (!response || !response.data) {
				alert("견적 정보를 찾을 수 없습니다. (" + k.no + " / " + k.seq + ")");
				return;
			}
			bind(response.data);
		},
		error: function() {
			loading = false;
			alert("오류가 발생하였습니다.");
		}
	});
}

function bind(d) {
	cur = d;
	resetForm();
	$("[data-f]").each(function() {
		var $el = $(this);
		var v = kepFormatValue(d, $el.attr("data-f"), $el.attr("data-fmt"));
		if ($el.is(":checkbox")) {
			$el.prop("checked", v == "Y");
		} else if ($el.is("input, textarea")) {
			$el.val(v);
		} else {
			$el.text(v);
		}
	});

	var bm = kepTrimStr(d.BM_USER_NAME);
	var mis = kepTrimStr(d.MIS_BUYER_NAME);
	$("#bizUserName").val((bm == "" && mis == "") ? "" : (bm || "-") + " / " + (mis || "-"));

	var unit = kepTrimStr(d.UNIT_MEASURE);
	$("#unitSel").empty().append($("<option>").val(unit).text(unit));
	kepSelectByText($("#trSel"), kepTrimStr(d.TR_HANDLE_TYPE));

	$("#attachInfo").text(kepTrimStr(d.IMAGE_KEY) != "" ? "첨부 있음 (파일 목록 미연결)" : "첨부 없음");
	$("#recvCnt").val(kepTrimStr(d.QUOTA_CNT));
	$("#imgRegItem").toggle(kepTrimStr(d.ITEM_GUBUN) == "4");
	$("#revision").text(kepTrimStr(d.REVISION) == "" ? "0" : kepTrimStr(d.REVISION));

	var auto = kepTrimStr(d.AUTO_QUOT_YN);
	$("#btnAutoQuot").toggleClass("hilite", auto == "Y");
	$("#btnAgentSel").toggleClass("hilite", auto == "N");

	var reproc = (kepTrimStr(d.REPROC_REQ_YN) == "Y");
	$("#topLeftNormal").toggle(!reproc);
	$("#topLeftReproc").toggle(reproc);
	$("#reprocReason").val("");

	$(".top-table input").each(function() {
		this.title = this.value;
	});
	$("#pageInfo").text((idx + 1) + " / " + keys.length);
	renderSpec(d);
	takeSnapshot();
}

function renderSpec(d) {
	var $t = $("#specTable");
	$t.find("tr").not(".spec-fixed").remove();
	if (kepTrimStr(d.CMS_CATEG_ID) == "") {
		$t.append(specMsg("상세분류를 지정하면 속성이 표시됩니다."));
		return;
	}
	var cnt = Number(kepTrimStr(d.SPEC_CNT) || "0");
	var shown = 0;
	for (var i = 1; i <= 20 && i <= cnt; i++) {
		var nm = kepTrimStr(d["SPEC_NM" + i]);
		if (nm == "") continue;
		var $th = $("<th>").attr("title", nm).text(nm + " ");
		if (kepTrimStr(d["SPEC_REQ" + i]) == "Y") $th.append($("<span class='C-F6495F'>").text("*"));
		var $in = $("<input type='text'>").attr("data-attr", i).val(kepTrimStr(d["SPEC_VAL" + i]));
		$t.append($("<tr>").append($th).append($("<td>").append($in)));
		shown++;
	}
	if (shown == 0) $t.append(specMsg("이 상세분류에는 등록된 속성이 없습니다."));
}

function specMsg(msg) {
	return $("<tr>").append($("<td colspan='2' class='spec-msg'>").attr("title", msg).text(msg));
}

function move(step) {
	if (loading) return;
	var n = idx + step;
	if (n < 0 || n >= keys.length) {
		alert(step < 0 ? "첫 번째 건입니다." : "마지막 건입니다.");
		return;
	}
	if (isDirty()) {
		if (!confirm("저장하지 않은 내용이 있습니다.\n저장하고 이동할까요?")) return;
		saveCurrent(function() {
			idx = n;
			show();
		});
		return;
	}
	idx = n;
	show();
}

function saveCurrent(onSaved) {
	kepNotYet();
	takeSnapshot();
	if (onSaved) onSaved();
}

function quotInit() {
	if (loading) return;
	if (!confirm('선택한 항목을 견적초기화 하시겠습니까?'))
		return;
	var k = keys[idx];
	loading = true;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/initMasterMpRqDailySourcingPurchase.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: {
			s_SAVENAME: "BUYER|QUOTATION_NO|QUOTATION_SEQ|REVISION",
			BUYER: k.buyer,
			QUOTATION_NO: k.no,
			QUOTATION_SEQ: k.seq,
			REVISION: k.rev,
			st_user_id: "${sessionInfo.userId}"
		},
		success: function(response) {
			loading = false;
			var r = response ? response.Result : null;
			if (r && r.Code == 1) {
				alert(r.msg);
				show();
				try {
					if (opener && !opener.closed && opener.doAction) opener.doAction('search');
				} catch (e) {}
				return;
			}
			alert((response && typeof response.Message == "string") ? response.Message : "견적 초기화에 실패하였습니다.");
		},
		error: function() {
			loading = false;
			alert("오류가 발생하였습니다.");
		}
	});
}

function openTab(i) {
	$(".tab-button").removeClass("active").eq(i).addClass("active");
	$(".tab-content").removeClass("active").eq(i).addClass("active");
}

function openQuotationPop() {
	if (loading) return;
	var k = keys[idx];
	popupSel = "quotationReDetailPop";
	openSearchPopup("/common/mprq/quotationReDetailPop.do", "?st_buyer=" + k.buyer + "&st_quotation_no=" + k.no + "&st_revision=" + k.rev, "1020,500,no");
}

function openBuyerPop() {
	if (loading) return;
	openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code=" + keys[idx].buyer, "900,700,no");
}

function openUserPop() {
	if (loading) return;
	var id = $("input[data-f=BTOA_USER_ID]").val();
	if (id == "") {
		alert("요청자ID 정보가 없습니다.");
		return;
	}
	openSearchPopup("/common/userDisplayPop.do", "?user_id=" + id, "800,500,no");
}

function openMakerPop() {
	if (loading) return;
	popupSel = "maker";
	openSearchPopup("/common/agentRegMakerCodePop.do", "?st_del_name=" + $("input[data-f=MAKER_NAME]").val() + "&st_buyer_code=" + keys[idx].buyer + "&st_ent_confirm=Y", "500,500,no");
}

function openCountryPop() {
	if (loading) return;
	popupSel = "country";
	openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
}

function openAgentRcmdPop() {
	if (loading) return;
	openSearchPopup("/mprq/showMasterMpRqDailySourcingAgentRcmdPop.do", "", "540,397,no");
}

function openTrStdPop() {
	openSearchPopup("/mprq/showMasterMpRqDailySourcingTrStdPop.do", "", "520,269,no");
}

function openDupSearchPop() {
	if (loading) return;
	openSearchPopup("/mprq/showMasterMpRqDailySourcingDupSearchPop.do", "", "1400,555,no");
}

function applyDupMapping(info) {
	var k = keys[idx];
	if (loading || info.buyer != k.buyer || info.quotationNo != k.no || info.quotationSeq != k.seq) {
		alert("중복검색을 연 뒤 다른 견적으로 이동했습니다. 중복검색을 다시 열어 주세요.");
		return false;
	}
	dupMapping = info;
	$("input[data-f=CMS_CODE]").first().val(info.cmsCatlgId);
	$("input[data-f=DB_MAPPING_TYPE_NM]").val(info.typeName);
	alert(info.typeName + " 저장은 아직 연결되지 않았습니다.");
	return true;
}

function openAutoQuotReqPop() {
	if (loading) return;
	openSearchPopup("/mprq/showMasterMpRqDailySourcingAutoQuotReqPop.do", "", "1000,568,no");
}

function openAgentSelPop() {
	if (loading) return;
	openSearchPopup("/mprq/showMasterMpRqDailySourcingAgentSelPop.do", "", "1000,720,no");
}

function getReqInfo() {
	return {
		BUYER: keys[idx].buyer,
		QUOTATION_NO: $("input[data-f=QUOTATION_NO]").val(),
		QUOTATION_SEQ: $("input[data-f=QUOTATION_SEQ]").val(),
		QUOTATION_KEY: $("input[data-f=QUOTATION_KEY]").val(),
		ATOS_REMARK: $("textarea[data-f=ATOS_REMARK]").val(),
		ATOA_REMARK: $("textarea[data-f=ATOA_REMARK]").val(),
		BUYER_NAME: $("input[data-f=BUYER_NAME]").val(),
		BUYER_ITEM_NO: $("input[data-f=BUYER_ITEM_NO]").val(),
		DESCRIPTION: $("input[data-f=DESCRIPTION]").val(),
		MAKER_PART_NO: $("input[data-f=MAKER_PART_NO]").first().val(),
		SPECIFICATION: $("input[data-f=SPECIFICATION]").val(),
		MAKER_NAME: $("input[data-f=MAKER_NAME]").val(),
		ORIGIN_NAME: $("input[data-f=ORIGIN_NAME]").val(),
		ITEM_QTY: $("input[data-f=ITEM_QTY]").val(),
		UNIT_MEASURE: $("#unitSel").val(),
		CMS_CODE: $("input[data-f=CMS_CODE]").first().val()
	};
}

function setPopupReturn(value1, value2, value3, value4, value5) {
	if (popupSel == "maker") {
		$("input[data-f=MAKER_CODE]").val(value1);
		$("input[data-f=MAKER_NAME]").val(value2);
		$("input[data-f=ORIGIN_CODE]").val(value3);
		$("input[data-f=ORIGIN_NAME]").val(value4);
		$("input[data-f=MAKER_NOT_REASON]").val((value5 == null || value5 == undefined) ? "" : value5);
	} else if (popupSel == "country") {
		$("input[data-f=ORIGIN_CODE]").val(value1);
		$("input[data-f=ORIGIN_NAME]").val(value3);
	} else if (popupSel == "masterMpRqQuotationStoATimePop") {
		saveEndTime(value1, value2);
	} else if (popupSel == "itemChgReqfileUpload") {
		$("#maint_image_key").val(value1);
		$("#maint_file_img").attr("src", (value2 == "on") ? "/resources/images/disk_on.gif" : "/resources/images/disk_off.gif");
	}
}

function openMaintLayer() {
	if (loading || cur == null) return;
	var k = keys[idx];
	if (kepTrimStr(cur.CMS_REJECT_YN) == "Y" && kepTrimStr(cur.ITEM_MD_DATE) == "") {
		alert("이미 품목정비 요청중인 견적건입니다.[" + k.no + "]");
		return;
	}
	var cb = KepSheetComboData("DM04", "SEL");
	var codes = cb.ComboCode.split("|");
	var texts = cb.ComboText.split("|");
	var $sel = $("#maint_req_type").empty();
	for (var i = 0; i < codes.length; i++) {
		$sel.append($("<option>").val(codes[i]).text(texts[i]));
	}
	$("#maint_req_note").val("");
	$("#maint_image_key").val("");
	$("#maint_file_img").attr("src", "/resources/images/disk_off.gif");
	$("#maintLayer").show();
}

function closeMaintLayer() {
	$("#maintLayer").hide();
}

function openMaintFile() {
	popupSel = "itemChgReqfileUpload";
	openSearchPopup('/common/fileUploadPop.do', '?DOC_NO=' + $("#maint_image_key").val() + '&TYPE=RFQ&viewType=VI', '500,430,no');
}

function saveMaintReq() {
	if (loading || cur == null) return;
	var st_req_type = $("#maint_req_type").val();
	var st_req_note = $("#maint_req_note").val();
	if (st_req_type == "") {
		alert("정비구분을 선택하여 주십시요.");
		$("#maint_req_type").focus();
		return;
	}
	if (st_req_note.length == 0) {
		alert("요청사유를 입력하여 주십시요.");
		$("#maint_req_note").focus();
		return;
	}
	if (!confirm("품목재정비를 요청하시겠습니까?"))
		return;
	var k = keys[idx];
	closeMaintLayer();
	loading = true;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/saveMasterMpRqDailySourcingPurchaseItemChgReq.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: {
			s_SAVENAME: "BUYER|QUOTATION_NO|QUOTATION_SEQ|REVISION|CMS_REJECT_YN|ITEM_CHG_REQ_ID|ITEM_CHG_REQ_TYPE|ITEM_CHG_REQ_NOTE|ITEM_CHG_REQ_IMAGE_KEY|BTOA_USER_NAME|BTOA_USER_TEL|DESCRIPTION|SPECIFICATION|MAKER_NAME",
			BUYER: k.buyer,
			QUOTATION_NO: k.no,
			QUOTATION_SEQ: k.seq,
			REVISION: k.rev,
			CMS_REJECT_YN: "Y",
			ITEM_CHG_REQ_ID: "${sessionInfo.userId}",
			ITEM_CHG_REQ_TYPE: st_req_type,
			ITEM_CHG_REQ_NOTE: st_req_note,
			ITEM_CHG_REQ_IMAGE_KEY: $("#maint_image_key").val(),
			BTOA_USER_NAME: kepTrimStr(cur.BTOA_USER_NAME),
			BTOA_USER_TEL: kepTrimStr(cur.BTOA_USER_TEL),
			DESCRIPTION: kepTrimStr(cur.DESCRIPTION),
			SPECIFICATION: kepTrimStr(cur.SPECIFICATION),
			MAKER_NAME: kepTrimStr(cur.MAKER_NAME),
			st_user_id: "${sessionInfo.userId}"
		},
		success: function(response) {
			loading = false;
			var r = response ? response.Result : null;
			alert((response && typeof response.Message == "string") ? response.Message : "오류가 발생하였습니다.");
			if (r && r.Code == 1) {
				show();
				try {
					if (opener && !opener.closed && opener.doAction) opener.doAction('search');
				} catch (e) {}
			}
		},
		error: function() {
			loading = false;
			alert("오류가 발생하였습니다.");
		}
	});
}

function msdsReq() {
	if (loading || cur == null) return;
	if (kepTrimStr(cur.BID_SUCCESS_FLAG) != "Y") {
		alert("협력사선정완료된 견적만 요청 가능합니다.");
		return;
	}
	if (!confirm('선택한 항목을 협력사에 MSDS 요청 하시겠습니까?\n현재 매핑된 MSDS_NO는 해제됩니다.'))
		return;
	var k = keys[idx];
	loading = true;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/saveMasterMpRqDailySourcingPurchaseMsdsReq.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: {
			s_SAVENAME: "BUYER|QUOTATION_NO|QUOTATION_SEQ|REVISION",
			BUYER: k.buyer,
			QUOTATION_NO: k.no,
			QUOTATION_SEQ: k.seq,
			REVISION: k.rev,
			st_user_id: "${sessionInfo.userId}"
		},
		success: function(response) {
			loading = false;
			var r = response ? response.Result : null;
			alert((response && typeof response.Message == "string") ? response.Message : "오류가 발생하였습니다.");
			if (r && r.Code == 1) {
				show();
				try {
					if (opener && !opener.closed && opener.doAction) opener.doAction('search');
				} catch (e) {}
			}
		},
		error: function() {
			loading = false;
			alert("오류가 발생하였습니다.");
		}
	});
}

function extendEndTime() {
	if (loading || cur == null) return;
	popupSel = "masterMpRqQuotationStoATimePop";
	openSearchPopup("/mprq/showMasterMpRqDailySourcingEndTimePop.do", "", "420,150,no");
}

function saveEndTime(toDate, toTime) {
	if (loading || cur == null) return;
	var k = keys[idx];
	var atosDate = kepTrimStr(cur.ATOS_END_DATE) + kepTrimStr(cur.ATOS_END_TIME);
	var st_buyer = kepTrimStr(cur.BUYER_NAME);
	if (kepTrimStr(cur.AGENT_REVISION) == "") {
		alert(st_buyer + "(" + k.no + ")건  협력사 견적요청 전 건은 견적마감 시간 연장 불가능 합니다.");
		return;
	}
	if (kepTrimStr(cur.EXTEND_FLAG) != "Y") {
		alert(st_buyer + "(" + k.no + ")건  견적마감 시간이 도래한 견적건은 연장 불가능 합니다.");
		return;
	}
	if (kepTrimStr(cur.ADMIN_CLOSE_FLAG) == "Y") {
		alert(st_buyer + "(" + k.no + ")건  조기마감건은 견적마감 시간 연장 불가능 합니다.");
		return;
	}
	if (atosDate > toDate + toTime) {
		alert(st_buyer + "(" + k.no + ")건 견적마감 시간 연장 대상건이 아닙니다.");
		return;
	}
	loading = true;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/saveMasterMpRqDailySourcingPurchaseEndTime.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: {
			s_SAVENAME: "BUYER|QUOTATION_NO|QUOTATION_SEQ|REVISION|AGENT_REVISION|TO_ATOS_END_DATE|TO_ATOS_END_TIME",
			BUYER: k.buyer,
			QUOTATION_NO: k.no,
			QUOTATION_SEQ: k.seq,
			REVISION: k.rev,
			AGENT_REVISION: kepTrimStr(cur.AGENT_REVISION),
			TO_ATOS_END_DATE: toDate,
			TO_ATOS_END_TIME: toTime
		},
		success: function(response) {
			loading = false;
			var r = response ? response.Result : null;
			alert((response && typeof response.Message == "string") ? response.Message : "오류가 발생하였습니다.");
			if (r && r.Code == 1) {
				show();
				try {
					if (opener && !opener.closed && opener.doAction) opener.doAction('search');
				} catch (e) {}
			}
		},
		error: function() {
			loading = false;
			alert("오류가 발생하였습니다.");
		}
	});
}
</script>
</html>

<%--
**********************************************
* 메뉴 : DashBoard>
* 화면 : DashBoard
* 기능 : 
* 프로그램 ID : PG_90_C_800_01
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-25
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("_data"); // 조회된결과  
List<Map<String,String>> _dash_board_data1 = (List<Map<String,String>>) request.getAttribute("_dash_board_data1"); // 조회된결과  
List<Map<String,String>> _dash_board_data2 = (List<Map<String,String>>) request.getAttribute("_dash_board_data2"); // 조회된결과  
List<Map<String,String>> _dash_board_data3 = (List<Map<String,String>>) request.getAttribute("_dash_board_data3"); // 조회된결과  
List<Map<String,String>> _dash_board_data4 = (List<Map<String,String>>) request.getAttribute("_dash_board_data4"); // 조회된결과  
String buyer_own_cnt	= CommonUtil.nvl((String) request.getAttribute("buyer_own_cnt"),"0");

String user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String user_name	= CommonUtil.nvl((String) request.getParameter("st_user_name"),_sessionInfo.getUserNameLoc());
String user_dept = CommonUtil.nvl((String) request.getParameter("st_user_dept"),_sessionInfo.getDepartment());
String st_buyer_type = CommonUtil.nvl((String) request.getParameter("st_buyer_type"), "");

if("".equals(st_buyer_type) && !buyer_own_cnt.equals("0")){
	st_buyer_type = "OWN";
}
%>

<script src="/resources/js/common.js"></script>
<script>
function pageTransfer(ds_user_id, date_type){

	var date_flag = "";

	if(date_type == "WEEK"){
		date_flag = "-7";
	}
    var dashboard_flag = "Y";
    var param = encodeURI("?st_dashboard_flag="+dashboard_flag+"&st_ds_user_id="+ds_user_id+"&st_date_type="+date_type+"&st_date_flag="+date_flag);
    
    parent.tab("담당자별 접수 현황","/mpvo/showMasterMpVoChargeReceiptState.do" + param);
}

function pageTransferBuyer(buyer_name, buyer_code, sys_type){
    var dashboard_flag = "Y"; 
    var param = encodeURI("?st_dashboard_flag="+dashboard_flag+"&st_sys_type="+sys_type+"&st_buyer_name="+buyer_name+"&st_buyer_code="+buyer_code+"&st_ds_user_id=ALL");
    	
    parent.tab("VOC 진행현황","/mpvo/showMasterMpVoVocProgressState.do" + param);
}

function pageTransferBuyerFB(buyer_name, buyer_code, sys_type){
    var dashboard_flag = "Y"; 
    var recv_flag = "FB";
    
    var param = encodeURI("?st_dashboard_flag="+dashboard_flag+"&st_sys_type="+sys_type+"&st_buyer_name="+buyer_name+"&st_buyer_code="+buyer_code+"&st_recv_flag="+recv_flag+"&st_ds_user_id=ALL");
    parent.tab("VOC 진행현황","/mpvo/showMasterMpVoVocProgressState.do" + param);
}

function pageTransferDept(ds_dept){
    var dashboard_flag = "Y"; 
    
    var param = encodeURI("?st_ds_dept_code="+ds_dept+"&st_dashboard_flag="+dashboard_flag);
    parent.tab("사업팀별 현황","/mpvo/showMasterMpVoBizTeamState.do" + param);
}

function changeBuyerCaseState(buyer_type){
    $("#searchCondition").attr("action", "/mpvo/getMasterMpVoDashBoardList.do").submit();
}
</script>
</head>
<body>
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>DashBoard</h3>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method = "post">
       		<div class="main_table_summ">
				<p>
<%
if(_dataList == null || _dataList.size() == 0 ){
%>
					<img src="/resources/images/lnb_Sbg_br_S.gif" alt="ball_blue" style="vertical-align:middle" />
					<%=user_name%> 님의 전체 미결건 수는 <b>[ 0 ]</b> 건이며, 최근 1주간 미결건 수는 <b>[ 0 ]</b> 건 임.
<%
} else {
	int cnt_all	= 0;
	int cnt_week	= 0;
	String str_ds_user_id = "";

    for(int j=0; j < _dataList.size(); j++){
    	Map<String,String> rowData = _dataList.get(j);

		cnt_all		+= Integer.parseInt(CommonUtil.bnvl(rowData.get("TOT_CNT")));
		cnt_week	+= Integer.parseInt(CommonUtil.bnvl(rowData.get("T_DATE")));
		str_ds_user_id = CommonUtil.nvl(rowData.get("DS_USER_ID"));
	}
%>
					<img src="/resources/images/lnb_Sbg_br_S.gif" alt="ball_blue" style="vertical-align:middle" />
					<%=user_name%> 님의 전체 미결건 수는 <a href="javascript:pageTransfer('<%=str_ds_user_id%>', 'MONTH')"><b>[ <%=cnt_all%> ]</b></a>
					 건이며, 최근 1주간 미결건 수는 <a href="javascript:pageTransfer('<%=str_ds_user_id%>', 'WEEK')"><b>[ <%=cnt_week%> ]</b></a> 건 임.
<%
}
%>
				</p>
			</div>
			<br/>
			<div id="middle_div">
                <div class="sub_table_div sub_table_div_first" style="float: left; width : 48%;">
                    <div class="sub_table_summ " style="width : 100%;">
                        <div>
                        	<img src="/resources/images/m_ball_blue.gif" alt="ball_blue" style="vertical-align:middle" /> <b>VOC L/T</b>&nbsp;(F/B완료된 클레임 건 수)
                       	</div >
                    </div>
                    <div class="tbl_wrap">
                    	<div class="scrollArea" style="height:200px">
                        <table class="t_masterMain02" style="width : 100%;">
                            <caption>VOC L/T</caption>
                            <colgroup>
                                <col width="" />
                                <col width="13%" />
                                <col width="13%" />
                                <col width="13%" />
                                <col width="13%" />
                                <col width="13%" />
                                <col width="13%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="greenBg" rowspan="2">사업팀</th>
                                    <th class="greenBg" colspan="3">발생건수</th> 
                                    <th class="greenBg" colspan="3">처리 리드타임(일)</th>
                                </tr> 
                                <tr class="second_head">
                                    <th class="grayBg">전월</th>
                                    <th class="grayBg">당월</th>
                                    <th class="grayBg">금주</th>
                                    <th class="grayBg">전월</th>
                                    <th class="grayBg">당월</th>
                                    <th class="grayBg">금주</th>
                                </tr> 
                            </thead>
                            <tbody>
<%
	        if (_dash_board_data1 == null || _dash_board_data1.size() == 0){
%>
	        					<tr>
                                    <th>&nbsp;</th>
                                    <td>0 건</td>
                                    <td>0 건</td>
                                    <td>0 건</td>
                                    <td>0 일</td>
                                    <td>0 일</td>
                                    <td class="last">0 일</td>                        	
                                </tr>
	        					<tr>
                                    <th>합/평균</th>
                                    <td class="first"><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td><b>0</b> 일</td>
                                    <td><b>0</b> 일</td>
                                    <td class="last"><b>0</b> 일</td>                        	
                                </tr>
<%
	        }else{
	        	int db1_item_01 = 0;
	            int db1_item_02 = 0;
	            int db1_item_03 = 0;
	            int db1_item_04 = 0;
	            int db1_item_05 = 0;
	            int db1_item_06 = 0;
	        	
				for (int j=0; j<_dash_board_data1.size(); j++) {
					Map<String,String> rowData = _dash_board_data1.get(j);
					db1_item_01 += Integer.parseInt(CommonUtil.bnvl(rowData.get("LAST_MONTH_CNT")));
		            db1_item_02 += Integer.parseInt(CommonUtil.bnvl(rowData.get("THIS_MONTH_CNT")));
		            db1_item_03 += Integer.parseInt(CommonUtil.bnvl(rowData.get("WEEK_CNT")));
		            db1_item_04 += Integer.parseInt(CommonUtil.bnvl(rowData.get("LAST_MONTH")));
		            db1_item_05 += Integer.parseInt(CommonUtil.bnvl(rowData.get("THIS_MONTH")));
		            db1_item_06 += Integer.parseInt(CommonUtil.bnvl(rowData.get("WEEK")));
%>
								<tr>
                                    <th><%=CommonUtil.nvl(rowData.get("DS_DEPT_NAME")) %></th>
                                    <td><%=CommonUtil.bnvl(rowData.get("LAST_MONTH_CNT"))  %></td>
                                    <td><%=CommonUtil.bnvl(rowData.get("THIS_MONTH_CNT"))  %></td>
                                    <td><%=CommonUtil.bnvl(rowData.get("WEEK_CNT"))  %></td>
                                    <td><%=CommonUtil.bnvl(rowData.get("LAST_MONTH"))  %></td>
                                    <td><%=CommonUtil.bnvl(rowData.get("THIS_MONTH"))  %></td>
                                    <td class="last"><%=CommonUtil.bnvl(rowData.get("WEEK"))  %></td>                        	
                                </tr>
<%
				}
%>
								<tr>
                                    <th>합/평균</th>
                                    <td><b><%=db1_item_01 %></b> 건</td>
                                    <td><b><%=db1_item_02 %></b> 건</td>
                                    <td><b><%=db1_item_03 %></b> 건</td>
                                    <td><b><%=(int) Math.round(db1_item_04 /_dash_board_data1.size()) %></b> 일</td>
                                    <td><b><%=(int) Math.round(db1_item_05 /_dash_board_data1.size()) %></b> 일</td>
                                    <td class="last"><b><%=(int) Math.round(db1_item_06 /_dash_board_data1.size()) %></b> 일</td>                        	
                                </tr>
<%
			}
%>
                            </tbody>
                        </table>
                        </div>
                    </div>
                </div>
                <div class="sub_table_div sub_table_div2" style="float: left; width : 48%; margin-left : 20px; ">
                    <div class="sub_table_summ " style="width : 100%;">
                        <div>
                        	<img src="/resources/images/m_ball_blue.gif" alt="ball_blue" style="vertical-align:middle" /> <b>고객사별 현황</b>
                        	<select id="st_buyer_type" name="st_buyer_type" onchange="changeBuyerCaseState(this.value);">
								<option value="ALL" <%=("ALL".equals(st_buyer_type) ? "selected" : "")%>>전체</option>
								<option value="OWN" <%=("OWN".equals(st_buyer_type) ? "selected" : "")%>>관심고객사</option>
							</select>&nbsp;(D-14 ~ Today 발생건 수|F/B완료건 수)
                        </div >
                    </div>
                    <div class="tbl_wrap">
                    	<div class="scrollArea" style="height:200px">
                        <table class="t_masterMain03" summary="신규품목매입률" style="width : 100%;">
                            <caption>고객사별 현황</caption>
                            <colgroup>
                                <col width="25%" />
                                <col width="25%" />
                                <col width="25%" />
                                <col width="25%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="greenBg">고객사</th>
                                    <th class="greenBg">발생건 수</th> 
                                    <th class="greenBg">완료건 수</th> 
                                    <th class="greenBg">완료률 (%)</th>
                                </tr> 
                            </thead>
                            <tbody>
<%
	        if (_dash_board_data3 == null || _dash_board_data3.size() == 0){
%>
	        					<tr>
                                    <th><b>합계</b></th>
                                    <td class="first"><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td class="last"><b>0</b> %</td>                        	
                                </tr>
<%
	        }else{
	        	int db3_item_01 = 0;
	            int db3_item_02 = 0;
	        	
				for (int j=0; j<_dash_board_data3.size(); j++) {
					Map<String,String> rowData = _dash_board_data3.get(j);
					db3_item_01 += Integer.parseInt(CommonUtil.bnvl(rowData.get("BUYER_ALL_CNT")));
					db3_item_02 += Integer.parseInt(CommonUtil.bnvl(rowData.get("BUYER_CPL_CNT")));
%>
								<tr>
                                    <th><%=CommonUtil.nvl(rowData.get("BUYER_NAME")) %></th>
                                    <td class="first">
<%				if(Integer.parseInt(CommonUtil.bnvl(rowData.get("BUYER_ALL_CNT"))) == 0){ %>
										<%=CommonUtil.bnvl(rowData.get("BUYER_ALL_CNT"))%> 건
<%				}else{ %>
										<a href="javascript:pageTransferBuyer('<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("SYS_TYPE"))%>')"><%=CommonUtil.bnvl(rowData.get("BUYER_ALL_CNT"))%></a> 건
<%				} %>
                                    </td>
                                    <td>
<%				if(Integer.parseInt(CommonUtil.bnvl(rowData.get("BUYER_CPL_CNT"))) == 0){ %>
										<%=CommonUtil.bnvl(rowData.get("BUYER_CPL_CNT"))%> 건
<%				}else{ %>
										<a href="javascript:pageTransferBuyerFB('<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("SYS_TYPE"))%>')"><%=CommonUtil.bnvl(rowData.get("BUYER_CPL_CNT"))%></a> 건
<%				} %>
                                    </td>
                                    <td class="last"><%=CommonUtil.bnvl(rowData.get("BUYER_CPL_PCT"))%> %</td>                        	
                                </tr>
<%
				}
%>
								<tr>
				                    <th><b>합계</b></th>
				                    <td class="first"><b><%=db3_item_01 %></b> 건</td>
				                    <td><b><%=db3_item_02 %></b> 건</td>
				                    <td class="last"><b><%=(int) Math.round((db3_item_02 * 100) /db3_item_01)%></b> %</td>                        	
				                </tr>
<%
			}
%>
                            </tbody>
                        </table>
                        </div>
                    </div>
                </div>
                <div class="sub_table_div sub_table_div_first" style="float: left; width : 48%; margin-top: 20px;">
                    <div class="sub_table_summ " style="width : 100%;">
                        <div>
                        	<img src="/resources/images/m_ball_blue.gif" alt="ball_blue" style="vertical-align:middle" /> <b>유형별 건수</b>&nbsp;(D-14 ~ Today 전체 발생건 수)
                       	</div >
                    </div>
                    <div class="tbl_wrap">
                    	<div class="scrollArea" style="height:200px">
                        <table class="t_masterMain02" summary="신규품목매입률" style="width : 100%;">
                            <caption>유형별 건수</caption>
                            <colgroup>
                                <col width="" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="greenBg">유형</th>
                                    <th class="greenBg">1사업본부</th>
                                    <th class="greenBg">2사업본부</th>
                                    <th class="greenBg">전략사업본부</th>
                                    <th class="greenBg">합계</th>
                                </tr> 
                            </thead>
                            <tbody>
<%
	        if (_dash_board_data2 == null || _dash_board_data2.size() == 0){
%>
	        					<tr>
                                    <th>&nbsp;</th>
                                    <td>0 건</td>
                                    <td>0 건</td>
                                    <td>0 건</td>
                                    <td class="last">0 건</td>                        	
                                </tr>
	        					<tr>
                                    <th>합/평균</th>
                                    <td><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td class="last"><b>0</b> 건</td>                        	
                                </tr>
<%
	        }else{
	        	int db2_item_01 = 0;
	            int db2_item_02 = 0;
	            int db2_item_03 = 0;
	            int db2_item_04 = 0;
	        	
				for (int j=0; j<_dash_board_data2.size(); j++) {
					Map<String,String> rowData = _dash_board_data2.get(j);
					db2_item_01 += Integer.parseInt(CommonUtil.bnvl(rowData.get("DEPT_1")));
					db2_item_02 += Integer.parseInt(CommonUtil.bnvl(rowData.get("DEPT_2")));
					db2_item_03 += Integer.parseInt(CommonUtil.bnvl(rowData.get("DEPT_3")));
					db2_item_04 += Integer.parseInt(CommonUtil.bnvl(rowData.get("T_DEPT")));
%>
								<tr>
                                    <th><%=CommonUtil.nvl(rowData.get("CLAIM_TEXT")) %></th>
                                    <td><%=CommonUtil.bnvl(rowData.get("DEPT_1"))%> 건</td>
                                    <td><%=CommonUtil.bnvl(rowData.get("DEPT_2"))%> 건</td>
                                    <td><%=CommonUtil.bnvl(rowData.get("DEPT_3"))%> 건</td>
                                    <td class="last"><%=CommonUtil.bnvl(rowData.get("T_DEPT"))%> 건</td>                        	
                                </tr>
<%
				}
%>
								<tr>
				                    <th><b>합계</b></th>
				                    <td><b><%=db2_item_01 %></b> 건</td>
				                    <td><b><%=db2_item_02 %></b> 건</td>
				                    <td><b><%=db2_item_03 %></b> 건</td>
				                    <td class="last"><b><%=db2_item_04%></b> 건</td>                        	
				                </tr>
<%
			}
%>
                            </tbody>
                        </table>
                        </div>
                    </div>
                </div>
                <div class="sub_table_div sub_table_div2" style="float: left; width : 48%; margin-left : 20px; margin-top: 20px;">
                    <div class="sub_table_summ " style="width : 100%;">
                        <div>
                        	<img src="/resources/images/m_ball_blue.gif" alt="ball_blue" style="vertical-align:middle" /> <b>장기미해결 현황</b>&nbsp;(D-14 ~ Today 발생 건 중 처리완료를 제외한 건 수)
                        </div >
                    </div>
                    <div class="tbl_wrap">
                    	<div class="scrollArea" style="height:200px">
                        <table class="t_masterMain03" summary="신규품목매입률" style="width : 100%;">
                            <caption>장기미해결 현황</caption>
                            <colgroup>
                                <col width="" />
                                <col width="15%" />
                                <col width="15%" />
                                <col width="15%" />
                                <col width="15%" />
                                <col width="15%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="greenBg">사업팀</th>
                                    <th class="greenBg">1~2일</th>
                                    <th class="greenBg">3~4일</th>
                                    <th class="greenBg">5~6일</th>
                                    <th class="greenBg">7일이상</th>
                                    <th class="greenBg">합계</th>
                                </tr> 
                            </thead>
                            <tbody>
<%
	        if (_dash_board_data4 == null || _dash_board_data4.size() == 0){
%>
	        					<tr>
                                    <th>&nbsp;</th>
                                    <td class="first">0 건</td>
                                    <td>0 건</td>
                                    <td>0 건</td>
                                    <td>0 건</td>
                                    <td class="last">0 건</td>                        	
                                </tr>
	        					<tr>
                                    <th>합/평균</th>
                                    <td class="first"><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td><b>0</b> 건</td>
                                    <td class="last"><b>0</b> 건</td>                        	
                                </tr>
<%
	        }else{
	        	int db4_item_01 = 0;
	            int db4_item_02 = 0;
	            int db4_item_03 = 0;
	            int db4_item_04 = 0;
	            int db4_item_05 = 0;
	        	
				for (int j=0; j<_dash_board_data4.size(); j++) {
					Map<String,String> rowData = _dash_board_data4.get(j);
					db4_item_01 += Integer.parseInt(CommonUtil.bnvl(rowData.get("DATE_0")));
					db4_item_02 += Integer.parseInt(CommonUtil.bnvl(rowData.get("DATE_1")));
					db4_item_03 += Integer.parseInt(CommonUtil.bnvl(rowData.get("DATE_2")));
					db4_item_04 += Integer.parseInt(CommonUtil.bnvl(rowData.get("DATE_3")));
					db4_item_05 += Integer.parseInt(CommonUtil.bnvl(rowData.get("T_DATE")));
%>
								<tr>
                                    <th><%=CommonUtil.nvl(rowData.get("DS_DEPT_NAME")) %></th>
                                    <td class="first"><%=CommonUtil.bnvl(rowData.get("DATE_0"))%> 건</td>
                                    <td><%=CommonUtil.bnvl(rowData.get("DATE_1"))%> 건</td>
                                    <td><%=CommonUtil.bnvl(rowData.get("DATE_2"))%> 건</td>
                                    <td><%=CommonUtil.bnvl(rowData.get("DATE_3"))%> 건</td>
                                    <td class="last">
<%				if(Integer.parseInt(CommonUtil.bnvl(rowData.get("T_DATE"))) == 0){ %>
										<b><%=CommonUtil.bnvl(rowData.get("T_DATE"))%></b> 건
<%				}else{ %>
										<b><a href="javascript:pageTransferDept('<%=CommonUtil.nvl(rowData.get("DS_DEPT"))%>')"><%=CommonUtil.bnvl(rowData.get("T_DATE"))%></b></a> 건
<%				} %>
                                    </td>                        	
                                </tr>
<%
				}
%>
								<tr>
					                <th><b>합계</b></th>
					                <td class="first"><b><%=db4_item_01 %></b> 건</td>
					                <td><b><%=db4_item_02 %></b> 건</td>
					                <td><b><%=db4_item_03 %></b> 건</td>
					                <td><b><%=db4_item_04 %></b> 건</td>
					                <td class="last"><b><%=db4_item_05%></b> 건</td>                        	
					            </tr>
<%
			}
%>
                            </tbody>
                        </table>
                        </div>
                    </div>
                </div>
            </div> 
		</form>
<!--내용 종료-->	                 
</body>
</html>

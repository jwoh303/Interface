<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ include file="../../common/include/head.jspf"  %>
<%
DecimalFormat decFormat = new DecimalFormat("###,###");

List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("H_data");
System.out.println("H_data : " + _gridList);
int rec_cnt = _gridList.size();	

String tot_price = request.getParameter("Extern_TOT_PRICE").replaceAll("\\,","");
int Itot_price = Integer.parseInt(tot_price.trim());

Map<String,String> str = _gridList.get(0);
String []RefNoList = str.get("REF_PR_NO").split("_");
//RefNoList[1] -- 계정과목 코드 //  RefNoList[2] -- y/n


//String []RefNoList = "테스트계정_Y".split("_");


%>

<!DOCTYPE html>
<html>

<body>
<div id = "contents" style="visibility:hidden;">
<html>
 <div >
	<table style="width: 650px;table-layout: fixed;border-collapse: collapse;border:1px solid #cdcdcd;margin:20px 0 0;padding:0" >
             <tr>
             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: left; width: 35%;" >&nbsp;&nbsp;신청 부서</td>
             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: left; width: 70%;" >&nbsp;&nbsp;<%= str.get("ADD_USER_DEPT")%></td>
             </tr>
             <tr>
             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: left; width: 35%;" >&nbsp;&nbsp;규격문의</td>
             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: left; width: 70%;">
             		&nbsp;&nbsp;담당자 : <%= str.get("CHNAGE_USER_NAME")%> &nbsp;&nbsp;&nbsp;&nbsp;  ☎  :  <%= str.get("CHANGE_USER_TEL")%>       	
             	</td>
             	
             </tr>
	</table> 
</div>	   
    <table style="width: 650px;table-layout: fixed;border-collapse: collapse;border:1px solid #cdcdcd;margin:20px 0 0;padding:0">
          
             <tr>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 30px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">No.</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 140px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">품명</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 160px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">규격</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 50px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">수량</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 50px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">단위</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 50px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">단가</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 90px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">금액</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 60px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">비고</p>
	              </td>
	             
              </tr>
               <% 
              Map<String,String> rowData = null;
              
              for (int j=0; j<rec_cnt; j++) { 
            	  rowData = _gridList.get(j);
              %>
              
              <tr>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 30px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= j+1 %></p>
	              </td>
	              <td style="padding: 10px; border: 1px solid rgb(205, 205, 205); text-align: left; width: 140px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">&nbsp;<%= rowData.get("DESCRIPTION") %></p>
	              </td>
	              <td style="padding: 10px; border: 1px solid rgb(205, 205, 205); text-align: left; width: 160px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">&nbsp;<%= rowData.get("SPECIFICATION") %></p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 50px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("TARGET_QTY") %> </p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 50px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("UNIT_MEASURE") %></p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 50px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("TARGET_PRICE") %> 원</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 90px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("TOTAL_AMT") %> 원</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 60px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("PO_REMARK") %> </p>
	              </td>
              </tr>
              
              <% } %>
              
              <tr>
              	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; " colspan="2">
	             <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">합계</p>
	            </td>
              	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; " >
	            </td>
	            <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; " >
	            </td>
	            <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; " >
	            </td>
	            <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; " >
	            </td>
	            <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; " >
	           	 <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= decFormat.format(Itot_price) %> 원</p>
	            </td>
	            <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; " >
	            </td>
              </tr>
              
              </table>
              
              <table style="width: 650px;table-layout: fixed;border-collapse: collapse;border:1px solid #cdcdcd;margin:20px 0 0;padding:0" >
	             <tr>
	             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 13%;" >
		             	<p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">
		             	재무팀
		             	</p>
	             	</td>
	             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 13%;" >
		             	<p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">
		             	회계별
		             	</p>
	             	</td>
	             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 26%;" >  
		             	<p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">         	
							<input type='checkbox' name = 'checkbox_y' id = 'checkbox_y' disabled/> 등록금 <input type='checkbox' name = 'checkbox_n' id = 'checkbox_n' disabled/>비등록금
						</p>
					</td>
	             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 15%;" >
		             	<p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">
		             	과목
		             	</p>
	             	</td>
	             	<td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 35%;" >
		             	<p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">
		             	  <%= str.get("ACCOUNT_NAME")%> ( <%= RefNoList[1]%> ) 
		             	</p>
	             	</td>
	             </tr>
	             
			</table> 
              
              <br>
              <div style = "float:left;">
           	  <p style="font-family: &quot;맑은 고딕&quot;; font-size: 14px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">[MRO]</p>
              </div>
              </html>
</div>
              
<div class="container" style="visibility:hidden;">

    <form
            action="https://ngw.hongik.ac.kr/ssologin.aspx"
            method="post"
            target="_self"
            name = "contentForm" 
            id="contentForm"
    >
      
        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">사용자 ID</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="userID"
                        id = "userID"
                        value= '<%= str.get("LEGACY_USER_ID")%>'
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">전자결재 기안시 수신처를 고정으로 등록해주는 값으로 서울캠퍼스 사용자인 경우 2021000034 값으로 넘겨주시고 세종캠퍼스인 경우 2021000035로 보내주시면 됩니다.</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="formID"
                        value= '<%= str.get("COMP")%>'
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">부서 ID </label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="deptID"
                        value='<%= str.get("PURCHASER_DEPT")%>'
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">문서 제목</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="doctitle"
                        value="물품구입 신청서(MRO)"
                />
            </div>
        </div>

 		<div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">본문HTML(encoding 처리 필수)</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="htmlBody"
                        id= "htmlBody"
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">TYPE</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="type"
                        value= "MRO"
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">연동키값</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="connkey"
                        value='<%=request.getParameter("Extern_BUYER")%>_<%=request.getParameter("Extern_PR_NO")%>'
                />
            </div>
        </div>

        <div class="form-group row">
            <div class="col-sm-10">
                <button type="submit" class="btn btn-primary btn-sm">기안</button>
            </div>
        </div>
    </form>
</div>
<!-- end container -->
<script
        src="https://code.jquery.com/jquery-3.3.1.min.js"

></script>
<script>

//var tableHtml = document.getElementById("contents").innerHTML;
//document.getElementById("htmlBody").innerText = encodeURIComponent(tableHtml);

var chk = "<%= RefNoList[2] %>";
if(chk == "Y" ){
	
	document.getElementById('checkbox_y').setAttribute("checked", true);
	//$("input[name='checkbox_y']").setAttribute("checked", true);
} else {
	document.getElementById('checkbox_n').setAttribute("checked", true);
	//$("input[name='checkbox_n']").setAttribute("checked", true);
}

$("input[name='htmlBody']").val(escape($("#contents")[0].innerHTML.trim()));

this.document.getElementById("contentForm").submit();

</script>

</body>
</html>
<%--
**********************************************
* 메뉴 : 주문관리>장바구니>주문정보/배송정보
* 화면 : 주문정보/배송정보
* 기능 : 구매요청 전 최종 주문정보화 배송정보를 확인한다.
* 프로그램 ID : PG_06_B_008_00
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-06-02
**********************************************
--%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ include file="../../common/include/head.jspf"  %>
<%
DecimalFormat decFormat = new DecimalFormat("###,###");

String tot_price = request.getParameter("Extern_TOT_PRICE").replaceAll("\\,","");
System.out.println("tot_price : " + tot_price);

//int Itot_price = Integer.parseInt(tot_price.trim()) * 110/100; // 부가세 포함 총 금액
int tot_amt = Integer.parseInt(tot_price.trim());   // 부가세 별도 총 금액
int tot_vat = Integer.parseInt(tot_price.trim()) * 10/100; // 부가세
int Itot_price = tot_amt + tot_vat;

List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("qura_data");
System.out.println("qura_data : " + _gridList);

int rec_cnt = _gridList.size();	

String _url = request.getRequestURL().toString();
String _domain = _url.substring(0, _url.indexOf("/WEB-INF") );
_domain = _domain.replace("http://","https://");
String _callbackUrl = _domain + "/mpso/quratis_callback.do";

%>
<!DOCTYPE html>
<html>
<body>
<!-- start container -->

<div class="container" style="visibility:hidden;">
    <!-- 테스트 오피스 설정 -->
    <form
            action="https://office.hiworks.com/quratis.onhiworks.com/approval/popup/write"
            method="post"
            target="_self"
            name = "contentForm" 
            id="contentForm"
    >
        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">전자결재 기안하기</label>
            <div class="col-sm-10">
            POST   : https://office.hiworks.com/%고객 도메인%/approval/popup/write
            <br>
            폼 전송 -> 로그인 -> 기안
            </div>
        </div>
      
        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">제목 (subject)</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="subject"
                        id = "subject"
                        value= " ";
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">내용 (contents) - html 로 되어있는 내용</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="contents"
                        value='<div id="hw_dext_default_style"><div style="margin: 0px; padding: 0px; font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8;">
            <h1 style="text-align: center; padding: 30px 0px; font-size: 13px; font-family: &quot;맑은 고딕&quot;; line-height: 1.8;"> <%=request.getParameter("Extern_PR_NO")%> 관련하여 아래와 같이 품의 드리오니 재가하여 주시기 바랍니다. </h1>
        
            <h2 style="text-align: center; padding: 30px 0px; font-size: 13px; font-family: &quot;맑은 고딕&quot;; line-height: 1.8;"> - 아  래 - </h2>
            
            <p style="font-family: &quot;맑은 고딕&quot;; font-size: 12px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">1. 총 금액 : <%= decFormat.format(Itot_price) %> 원 (V.A.T 포함)</p>
            <br>
            
            <p style="font-family: &quot;맑은 고딕&quot;; font-size: 12px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">2. 구매사유 :</p>
            <br>
            
            <p style="font-family: &quot;맑은 고딕&quot;; font-size: 12px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">3. 상세내역</p>
            
            <table style="width: 100%;table-layout: fixed;border-collapse: collapse;border:1px solid #cdcdcd;margin:20px 0 0;padding:0">
            
             <tr>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 40px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">No.</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 90px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">품목코드</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 180px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">품목명</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 90px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">단가</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 60px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">단위</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 60px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">수량</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 100px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">발주금액<br>(V.A.T 별도)</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 120px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">계정명</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 100px;" >
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">제품번호</p>
	              </td>
              </tr>
              <% 
              Map<String,String> rowData = null;
              
              for (int j=0; j<rec_cnt; j++) { 
            	  rowData = _gridList.get(j);
              %>
              <tr>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 40px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= j+1 %></p>
	              </td>
	              <td style="padding: 10px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 90px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("BUYER_ITEM_NO") %></p>
	              </td>
	              <td style="padding: 10px; border: 1px solid rgb(205, 205, 205); text-align: center; width: 180px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("DESCRIPTION") %></p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 90px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("TARGET_PRICE") %> 원</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 60px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("UNIT_MEASURE") %></p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 60px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("TARGET_QTY") %></p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 100px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("TOTAL_AMT") %> 원</p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 120px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("REF_PR_NO") %></p>
	              </td>
	              <td style="padding: 10px 0px; border: 1px solid rgb(205, 205, 205); text-align: center;  width: 100px;">
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><%= rowData.get("MAKER_PART_NO") %></p>
	              </td>
              </tr>
              <% } %>
              <tr>
              	<td style="padding: 10px 0px; padding-left: 50px; border: 1px solid rgb(205, 205, 205); text-align: right; " colspan="9">
             
	               <p style="font-family: &quot;맑은 고딕&quot;; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;"><strong><%=decFormat.format(tot_amt)%>원 (총 공급가액) + <%=decFormat.format(tot_vat)%>원 (부가세) = <%= decFormat.format(Itot_price) %> 원 (총 금액)</strong>&nbsp;&nbsp;&nbsp;</p>
	            
	            </td>
              </tr>
            </table>
            <br>
             <p style="font-family: &quot;맑은 고딕&quot;; font-size: 12px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;">4. 기타사항 :</p>
            <br>
            
            
          </div></div>'
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label"
            >양식 고유 아이디 (form_id) - 양식함 관리에 있는 N_XXX </label
            >
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="form_id"
                        value="N_22"
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label"
            >문서 상태값을 수신하는 URL(callback_url)</label
            >
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="callback_url"
                        value="<%=_callbackUrl %>"
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label">검증 및 관리 용도로 제공되는 State값 (state) Callback URL 호출 시 해당 state값을 그대로 전달</label>
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="state"
                        value= '<%=request.getParameter("Extern_BUYER")%>^<%=request.getParameter("Extern_PR_NO")%>'
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label"
            >기안 문서의 내용 수정 가능 여부를 설정 (modify_contents_flag) - Y/N</label
            >
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="modify_contents_flag"
                        value="Y"
                />
            </div>
        </div>

        <div class="form-group row">
            <label for="inputWriter" class="col-sm-2 col-form-label"
            >기안 문서의 파일 수정 가능 여부를 설정 (modify_files_flag)  - Y/N</label
            >
            <div class="col-sm-10">
                <input
                        type="text"
                        class="form-control"
                        name="modify_files_flag"
                        value="Y"
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

this.document.getElementById("contentForm").submit();

</script>
</body>
</html>
<%--
**********************************************
* 메뉴 : 발주관리>발주진행관리 excel 다운로드
* 화면 : 발주진행관리
* 기능 : 구매발주 내역을 조회하고 진행상태를 확인할 수 있다.
* 프로그램 ID : PG_06_B_019_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-08-11
**********************************************
--%> 
<%@ page contentType="application/vnd.ms-excel; charset=utf-8" %> 
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head> 
<META HTTP-EQUIVE="CONTENT-TYPE" CONTENT="TEXT/HTML; CHARSET=utf-8">
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
 
	
	String total_cnt = "";
	if (_gridList != null){
		total_cnt = String.valueOf(_gridList.size());
	}
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String v_size = total_cnt;
	String st_from_date = (String) request.getParameter("st_from_date"); 
	String st_to_date = (String) request.getParameter("st_to_date");
	String st_group_mng_flag = CommonUtil.nvl((String) request.getParameter("st_group_mng_flag"), "N");

	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String SessionComCode = "";
	String SessionComName = "";
	if (sessionInfo != null){ 
 
		SessionComName = sessionInfo.getComNameLoc();
		SessionComCode = sessionInfo.getComCode();
	}
    
    Map<String,String> rowData =  null;
    
    try{

        response.reset();

        response.setHeader("Content-Disposition", "attachment;filename=" +java.net.URLEncoder.encode("발주진행관리.xls", "UTF-8"));
        response.setHeader("Content-Description", "JSP Generated Data");
        response.setContentType("application/vnd.ms-excel;charset=utf-8");


        out.println("<table width=\"100%\" border=\"0\">  \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"center\">&nbsp;</td>  \n");
        out.println("  </tr>    \n");
        out.println("</table>   \n");

        out.println("<table width=\"100%\" border=\"0\">  \n"); 
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" height=\"7\">&nbsp;</td>  \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"right\" style=\"font-size:11px;font-family:굴림\">"+st_from_date+"&nbsp;&nbsp;"+st_to_date+"</td>  \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" height=\"5\">&nbsp;</td>  \n");
        out.println("  </tr>    \n");
        out.println("</table>   \n");
 
        out.println("<table width=\"100%\" border=\"1\" style=\"font-size:12px;font-family:굴림\">    \n");
        out.println("  <tr>     \n");
        if(st_group_mng_flag.equals("Y")){
       		out.println("    <td align=\"center\" width=\"8%\">고객사코드</td>      \n");	
        }
        out.println("    <td align=\"center\" width=\"4%\">발주번호</td>      \n");
        out.println("    <td align=\"center\" width=\"10%\">품목코드</td> \n");
        out.println("    <td align=\"center\" width=\"18%\">품목명</td>     \n");
        out.println("    <td align=\"center\" width=\"18%\">발주일</td>     \n");
        out.println("    <td align=\"center\" width=\"9%\">납기요청일</td>      \n");
        out.println("    <td align=\"center\" width=\"7%\">주문수량</td>      \n");
        out.println("    <td align=\"center\" width=\"7%\">단위</td>      \n");
        out.println("    <td align=\"center\" width=\"9%\">협력사</td>      \n");
        out.println("    <td align=\"center\" width=\"13%\">송장수량</td>     \n");
        out.println("    <td align=\"center\" width=\"12%\">관리번호</td>  \n");
        out.println("    <td align=\"center\" width=\"12%\">구매요청결재경로</td>  \n");
        out.println("    <td align=\"center\" width=\"12%\">구매발주결재경로</td>  \n");
        if(SessionComCode.equals("KRDUPO0001")) {  
        out.println("    <td align=\"center\" width=\"12%\">요청부서코드</td>  \n");
        out.println("    <td align=\"center\" width=\"12%\">COST CENTER CODE</td>  \n");
        out.println("    <td align=\"center\" width=\"12%\">ACCOUNT CODE</td>  \n");
        }
        out.println("    <td align=\"center\" width=\"10%\">제조사</td> \n");
        out.println("  </tr>     \n");
        out.println("  <tr>     \n");
        if(st_group_mng_flag.equals("Y")){
       		out.println("    <td align=\"center\" width=\"8%\">고객사명</td>      \n");	
        }
        out.println("    <td align=\"center\" width=\"4%\">주문번호</td>      \n");
        out.println("    <td align=\"center\" width=\"10%\">진행상태</td> \n");
        out.println("    <td align=\"center\"  colspan=\"2\" width=\"18%\">규격</td>     \n");
        out.println("    <td align=\"center\" width=\"18%\">납품예정일</td>     \n");
        out.println("    <td align=\"center\" colspan=\"2\" width=\"9%\">단가</td>      \n");
        out.println("    <td align=\"center\" width=\"7%\">금액</td>      \n");
        out.println("    <td align=\"center\" width=\"9%\">납품수량</td>      \n");
        out.println("    <td align=\"center\" width=\"13%\">요청부서</td>     \n");
        out.println("    <td align=\"center\" colspan=\"2\" width=\"12%\">비고</td>  \n");
        if(SessionComCode.equals("KRDUPO0001")) {  
        out.println("    <td align=\"center\" width=\"12%\">요청부서명</td>  \n");
        out.println("    <td align=\"center\" width=\"12%\">COST CENTER NAME</td>  \n");
        out.println("    <td align=\"center\" width=\"12%\">ACCOUNT NAME</td>  \n");
       }  
        out.println("    <td align=\"center\" width=\"10%\">발주자</td> \n");
        out.println("  </tr>     \n");

        for(int y=0; y<Integer.parseInt(v_size); y++)
        {
            out.println("  <tr>       \n"); 
            		rowData =  _gridList.get(y); 
            		if(st_group_mng_flag.equals("Y")){
            			out.println("    <td align=\"center\" width=\"10%\">"+ rowData.get("BUYER") + "</td>   \n");	
                    }
                    out.println("    <td align=\"center\" width=\"10%\">"+ rowData.get("PO_NO") + "</td>   \n");
                    out.println("    <td align=\"left\" width=\"18%\">"  + rowData.get("BUYER_ITEM_NO") + "</td>   \n");
                    out.println("    <td align=\"left\" width=\"18%\">"  + rowData.get("DESCRIPTION") + "</td>   \n");
                    out.println("    <td align=\"center\" width=\"9%\">"  + CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE")) + "</td>   \n");
                    out.println("    <td align=\"center\" width=\"7%\">" + CommonUtil.formatStrinigDate(rowData.get("RD_DATE")) + "</td>   \n");
                    out.println("    <td align=\"right\" width=\"9%\">"  + CommonUtil.formatNumber(rowData.get("RECV_QTY"),true,0,3)+ "</td>   \n");
                    out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("UNIT_MEASURE") + "</td>   \n");
                    out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("COM_NAME_LOC") + "</td>   \n");
                    out.println("    <td align=\"right\" width=\"9%\">"  + CommonUtil.formatNumber(rowData.get("IV_QTY"),true,0,3)+ "</td>   \n");
                    out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("REF_PR_NO") + "</td>   \n");
                    out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("PR_NO_APPROVAL_URL") + "</td>   \n");
                    out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("PX_NO_APPROVAL_URL") + "</td>   \n");
                    if(SessionComCode.equals("KRDUPO0001")) {  
                        out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("REQ_DEPT") + "</td>   \n");
                        out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("ACCOUNT_CODE") + "</td>   \n");
                        out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("COST_CENTER_CODE") + "</td>   \n");
                   } 
                    out.println("    <td align=\"center\" width=\"10%\">" + rowData.get("MAKER_NAME") + "</td>   \n");
            out.println("  </tr>  \n");
            out.println("  <tr>       \n");  
            if(st_group_mng_flag.equals("Y")){
    			out.println("    <td align=\"left\" width=\"10%\">"+ rowData.get("BUYER_NAME") + "</td>   \n");	
            }
            out.println("    <td align=\"center\" width=\"10%\">"+ rowData.get("REF_NO") + "</td>   \n");
            out.println("    <td align=\"left\" width=\"18%\">"  + rowData.get("PO_STR") + "</td>   \n");
            out.println("    <td align=\"left\" colspan=\"2\" width=\"18%\">"  + rowData.get("SPECIFICATION") + "</td>   \n");
            out.println("    <td align=\"right\" width=\"9%\">"  + CommonUtil.formatStrinigDate(rowData.get("DS_DATE")) + "</td>   \n"); 
            out.println("    <td align=\"right\" colspan=\"2\" width=\"9%\">"  + CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)+ "</td>   \n"); 
            out.println("    <td align=\"right\" width=\"9%\">"  + CommonUtil.formatNumber(rowData.get("TARGET_SUM_PRICE"),true,0,3)+ "</td>   \n");
            out.println("    <td align=\"right\" width=\"9%\">"  + CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)+ "</td>   \n");
            out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("REQ_DEPT_NAME") + "</td>   \n");
            out.println("    <td align=\"left\" colspan=\"2\"  width=\"7%\">" + rowData.get("REMARK") +"&nbsp;"+  rowData.get("REQ_DEPT_NAME")  +"&nbsp;"+  rowData.get("CHANGE_USER_NAME")  +"&nbsp;("+  rowData.get("CHANGE_USER_TEL")  + ")</td>   \n");
            if(SessionComCode.equals("KRDUPO0001")) {  
                out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("REQ_DEPT_NAME") + "</td>   \n");
                out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("ACCOUNT_TEXT") + "</td>   \n");
                out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("COST_CENTER_TEXT") + "</td>   \n");
            } 
            out.println("    <td align=\"center\" width=\"10%\">" + rowData.get("PURCHASER_NAME") + "</td>   \n");
   			out.println("  </tr>  \n");            
        }
 
        out.println("</table>   \n");
 
    }catch(Exception ex){
            System.out.println(ex);
    }
    
%>    

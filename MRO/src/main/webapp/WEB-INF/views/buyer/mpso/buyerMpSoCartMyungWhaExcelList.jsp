<%--
**********************************************
* 메뉴 : 주문관리>장바구니(명화용)
* 화면 : 장바구니(명화용)
* 기능 : 명화용 장바구니
* 프로그램 ID : PG_06_B_009_00  -- EOKWON
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-16
**********************************************
--%> 
<%@ page contentType="application/vnd.ms-excel; charset=utf-8" %> 
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head> 
<META HTTP-EQUIVE="CONTENT-TYPE" CONTENT="TEXT/HTML; CHARSET=KSC5601">
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
 
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,""); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String req_date			  = CommonUtil.formatDateNoDateGubun(new Date(),1);
	
	//System.out.println("req_date  " +req_date);
	
	String select_yy				=  req_date.substring(0,4);
	String select_mm			=  req_date.substring(4,6);
	String select_dd				=  req_date.substring(6,8); 

	int v_size = 0;
	int cnt = 0;
	
	if (_gridList != null){
	    v_size = _gridList.size();
	    cnt = 0;
	    if(v_size < 23)
	        cnt = 22;
	    else
	        cnt = v_size;
	}
    
    
    Map<String,String> rowData =  null;
    
    try{

        response.reset();

        response.setHeader("Content-Disposition", "attachment;filename=" +java.net.URLEncoder.encode("물품구매품의서.xls", "UTF-8"));
        response.setHeader("Content-Description", "JSP Generated Data");
        response.setContentType("application/vnd.ms-excel;charset=utf-8");


        out.println("<table width=\"100%\" border=\"0\">  \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"center\">&nbsp;</td>  \n");
        out.println("  </tr>    \n");
        out.println("</table>   \n");

        out.println("<table width=\"100%\" border=\"0\">  \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"center\" style=\"font-size:16px;font-family:굴림\"><b>(&nbsp;&nbsp;&nbsp;&nbsp;)월 물품구매품의서</b></td>  \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" height=\"7\">&nbsp;</td>  \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"right\" style=\"font-size:11px;font-family:굴림\">생성일 : " + select_yy + "/" + select_mm + "/" + select_dd + "</td>  \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" height=\"5\">&nbsp;</td>  \n");
        out.println("  </tr>    \n");
        out.println("</table>   \n");
        out.println("<table width=\"100%\" border=\"1\">  \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"2\" align=\"center\" bgcolor=\"#ebebeb\" style=\"font-size:13px;font-family:굴림\">계정과목</td>  \n");
        out.println("    <td colspan=\"2\">&nbsp;</td>  \n");
        out.println("    <td colspan=\"2\" align=\"center\" bgcolor=\"#ebebeb\" style=\"font-size:13px;font-family:굴림\">청구부서</td>  \n");
        out.println("    <td colspan=\"3\">&nbsp;</td>  \n");
        out.println("  </tr>    \n");
        out.println("</table>   \n");

        out.println("<table width=\"100%\" border=\"0\">  \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" height=\"5\">&nbsp;</td>      \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"center\" style=\"font-size:11px;font-family:굴림\">아래의 품목에 대한 구입을 희망하오니 본 품의서의 재가를 바랍니다.</td>  \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" height=\"7\">&nbsp;</td>      \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"left\" style=\"font-size:12px;font-family:굴림\"><b>총 품목수 : " + v_size+ "</b></td>  \n");
        out.println("  </tr>    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" height=\"3\">&nbsp;</td>      \n");
        out.println("  </tr>    \n");
        out.println("</table>   \n");

        out.println("<table width=\"100%\" border=\"1\" style=\"font-size:12px;font-family:굴림\">    \n");
        out.println("  <tr>     \n");
        out.println("    <td align=\"center\" width=\"4%\">순번</td>      \n");
        out.println("    <td align=\"center\" width=\"10%\">품목코드</td> \n");
        out.println("    <td align=\"center\" width=\"18%\">품목명</td>     \n");
        out.println("    <td align=\"center\" width=\"18%\">규격</td>     \n");
        out.println("    <td align=\"center\" width=\"9%\">수량</td>      \n");
        out.println("    <td align=\"center\" width=\"7%\">단위</td>      \n");
        out.println("    <td align=\"center\" width=\"9%\">단가</td>      \n");
        out.println("    <td align=\"center\" width=\"13%\">금액</td>     \n");
        out.println("    <td align=\"center\" width=\"12%\">납기요청일</td>  \n");
        out.println("  </tr>     \n");

        for(int y=0; y<cnt; y++)
        {
            out.println("  <tr>       \n");

            if(y<v_size)
            {
            		rowData =  _gridList.get(y);
                    out.println("    <td align=\"center\" width=\"4%\">" + (y+1) + "</td>   \n");
                    out.println("    <td align=\"center\" width=\"10%\">"+ rowData.get("BUYER_ITEM_NO") + "</td>   \n");
                    out.println("    <td align=\"left\" width=\"18%\">"  + rowData.get("DESCRIPTION_LOC") + "</td>   \n");
                    out.println("    <td align=\"left\" width=\"18%\">"  + rowData.get("SPECIFICATION") + "</td>   \n");
                    out.println("    <td align=\"right\" width=\"9%\">"  + rowData.get("CART_QTY") + "</td>   \n");
                    out.println("    <td align=\"center\" width=\"7%\">" + rowData.get("UNIT_MEASURE") + "</td>   \n");
                    out.println("    <td align=\"right\" width=\"9%\">"  + CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)+ "</td>   \n");
                    out.println("    <td align=\"right\" width=\"13%\">" + CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)+ "</td>   \n");
                    out.println("    <td align=\"center\" width=\"12%\">&nbsp;</td>  \n");
            }else{
                    out.println("    <td align=\"center\" width=\"4%\">" + (y+1) + "</td>  \n");
                    out.println("    <td align=\"center\" width=\"10%\">&nbsp;</td>  \n");
                    out.println("    <td align=\"left\" width=\"18%\">&nbsp;</td>    \n");
                    out.println("    <td align=\"left\" width=\"18%\">&nbsp;</td>    \n");
                    out.println("    <td align=\"right\" width=\"9%\">&nbsp;</td>    \n");
                    out.println("    <td align=\"center\" width=\"7%\">&nbsp;</td>   \n");
                    out.println("    <td align=\"right\" width=\"9%\">&nbsp;</td>    \n");
                    out.println("    <td align=\"right\" width=\"13%\">&nbsp;</td>   \n");
                    out.println("    <td align=\"center\" width=\"12%\">&nbsp;</td>  \n");
            }
            out.println("  </tr>  \n");
        }

        out.println("<table width=\"100%\" border=\"0\">    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\">&nbsp;</td>      \n");
        out.println("  </tr>     \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\">&nbsp;</td>      \n");
        out.println("  </tr>     \n");
        out.println("</table>   \n");

        out.println("<table width=\"100%\" border=\"1\" style=\"font-size:13px;font-family:굴림\">    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"4\" align=\"center\">합&nbsp;&nbsp;&nbsp;&nbsp;계</td>      \n");
        out.println("    <td colspan=\"5\" align=\"right\">&nbsp;(V.A.T 별도)</td>      \n");
        out.println("  </tr>     \n");
        out.println("</table>   \n");

        out.println("<table width=\"100%\" border=\"0\">    \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\">&nbsp;</td>      \n");
        out.println("  </tr>     \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\">&nbsp;</td>      \n");
        out.println("  </tr>     \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"center\" style=\"font-size:16px;font-family:굴림\"><b>코오롱유화(주)김천공장</td>  \n");
        out.println("  </tr>     \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"center\" height=\"5\" bgcolor=\"#CCCCCC\"></td>  \n");
        out.println("  </tr>     \n");
        out.println("  <tr>     \n");
        out.println("    <td colspan=\"9\" align=\"left\" style=\"font-size:11px;font-family:굴림\">이 문서는 전자 인증을 받았으므로 실제 문서와 같은 효력을 발생합니다.</td>  \n");
        out.println("  </tr>     \n");
        out.println("</table>   \n");

    }catch(Exception ex){
            System.out.println(ex);
    }
    
%>    

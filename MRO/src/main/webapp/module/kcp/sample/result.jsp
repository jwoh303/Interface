<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%
    /* ============================================================================== */
    /* =   PAGE : 결제 결과 출력 PAGE                                               = */
    /* = -------------------------------------------------------------------------- = */
    /* =   pp_ax_hub.jsp 파일에서 처리된 결과값을 출력하는 페이지입니다.            = */
    /* = -------------------------------------------------------------------------- = */
    /* =   연동시 오류가 발생하는 경우 아래의 주소로 접속하셔서 확인하시기 바랍니다.= */
    /* =   접속 주소 : http://testpay.kcp.co.kr/pgsample/FAQ/search_error.jsp       = */
    /* = -------------------------------------------------------------------------- = */
    /* =   Copyright (c)  2010.02   KCP Inc.   All Rights Reserved.                 = */
    /* ============================================================================== */
%>
<%!
    /* ============================================================================== */
    /* =   null 값을 처리하는 메소드                                                = */
    /* = -------------------------------------------------------------------------- = */
        public String f_get_parm( String val )
        {
          if ( val == null ) val = "";
          return  val;
        }
    /* ============================================================================== */
%>
<%
	request.setCharacterEncoding("utf-8") ;
    /* ============================================================================== */
    /* =   지불 결과                                                                = */
    /* = -------------------------------------------------------------------------- = */
    String pr_no			= f_get_parm( request.getParameter( "pr_no"		 ) );      // pr_no
    
	String site_cd			= f_get_parm( request.getParameter( "site_cd"		 ) );      // 사이트 코드
    String req_tx           = f_get_parm( request.getParameter( "req_tx"         ) );      // 요청 구분(승인/취소)
    String use_pay_method   = f_get_parm( request.getParameter( "use_pay_method" ) );      // 사용 결제 수단
    String bSucc            = f_get_parm( request.getParameter( "bSucc"          ) );      // 업체 DB 정상처리 완료 여부
    /* = -------------------------------------------------------------------------- = */
    String res_cd           = f_get_parm( request.getParameter( "res_cd"         ) );      // 결과 코드
    String res_msg          = f_get_parm( request.getParameter( "res_msg"        ) );      // 결과 메시지
	String res_msg_bsucc    = "";
    /* = -------------------------------------------------------------------------- = */
    String ordr_idxx        = f_get_parm( request.getParameter( "ordr_idxx"      ) );      // 주문번호
    String tno              = f_get_parm( request.getParameter( "tno"            ) );      // KCP 거래번호
    String good_mny         = f_get_parm( request.getParameter( "good_mny"       ) );      // 결제 금액
    String good_name        = f_get_parm( request.getParameter( "good_name"      ) );      // 품목명
    String buyr_name        = f_get_parm( request.getParameter( "buyr_name"      ) );      // 구매자명
    String buyr_tel1        = f_get_parm( request.getParameter( "buyr_tel1"      ) );      // 구매자 전화번호
    String buyr_tel2        = f_get_parm( request.getParameter( "buyr_tel2"      ) );      // 구매자 휴대폰번호
    String buyr_mail        = f_get_parm( request.getParameter( "buyr_mail"      ) );      // 구매자 E-Mail
    /* = -------------------------------------------------------------------------- = */
	// 공통
	String pnt_issue        = f_get_parm( request.getParameter( "pnt_issue"      ) );      // 포인트 서비스사
    String app_time         = f_get_parm( request.getParameter( "app_time"       ) );      // 승인시간 (공통)
	/* = -------------------------------------------------------------------------- = */
    // 신용카드
    String card_cd          = f_get_parm( request.getParameter( "card_cd"        ) );      // 카드 코드
    String card_name        = f_get_parm( request.getParameter( "card_name"      ) );      // 카드명
	String noinf			= f_get_parm( request.getParameter( "noinf"			 ) );      // 무이자 여부
    String quota            = f_get_parm( request.getParameter( "quota"          ) );      // 할부개월
	String app_no           = f_get_parm( request.getParameter( "app_no"         ) );      // 승인번호
    /* = -------------------------------------------------------------------------- = */
    // 계좌이체
    String bank_name        = f_get_parm( request.getParameter( "bank_name"      ) );      // 은행명
	String bank_code        = f_get_parm( request.getParameter( "bank_code"      ) );      // 은행코드
    /* = -------------------------------------------------------------------------- = */
    // 가상계좌
    String bankname         = f_get_parm( request.getParameter( "bankname"       ) );      // 입금할 은행
    String depositor        = f_get_parm( request.getParameter( "depositor"      ) );      // 입금할 계좌 예금주
    String account          = f_get_parm( request.getParameter( "account"        ) );      // 입금할 계좌 번호
    String va_date          = f_get_parm( request.getParameter( "va_date"        ) );      // 가상계좌 입금마감시간
    /* = -------------------------------------------------------------------------- = */
    // 포인트
    String pt_idno			= f_get_parm( request.getParameter( "pt_idno"		 ) );	   // 결제 및 인증 아이디
	String add_pnt          = f_get_parm( request.getParameter( "add_pnt"        ) );      // 발생 포인트
    String use_pnt          = f_get_parm( request.getParameter( "use_pnt"        ) );      // 사용가능 포인트
    String rsv_pnt          = f_get_parm( request.getParameter( "rsv_pnt"        ) );      // 적립 포인트
    String pnt_app_time     = f_get_parm( request.getParameter( "pnt_app_time"   ) );      // 승인시간
    String pnt_app_no       = f_get_parm( request.getParameter( "pnt_app_no"     ) );      // 승인번호
    String pnt_amount       = f_get_parm( request.getParameter( "pnt_amount"     ) );      // 적립금액 or 사용금액
    /* = -------------------------------------------------------------------------- = */
	//휴대폰
	String commid			= f_get_parm( request.getParameter( "commid"		 ) );      // 통신사 코드
	String mobile_no		= f_get_parm( request.getParameter( "mobile_no"      ) );      // 휴대폰 번호
	/* = -------------------------------------------------------------------------- = */
	//상품권
	String tk_van_code      = f_get_parm( request.getParameter( "tk_van_code"    ) );      // 발급사 코드
	String tk_app_no        = f_get_parm( request.getParameter( "tk_app_no"      ) );      // 승인 번호
	/* = -------------------------------------------------------------------------- = */
    // 현금영수증
    String cash_yn          = f_get_parm( request.getParameter( "cash_yn"        ) );      // 현금 영수증 등록 여부
    String cash_authno      = f_get_parm( request.getParameter( "cash_authno"    ) );      // 현금 영수증 승인 번호
    String cash_tr_code     = f_get_parm( request.getParameter( "cash_tr_code"   ) );      // 현금 영수증 발행 구분
    String cash_id_info     = f_get_parm( request.getParameter( "cash_id_info"   ) );      // 현금 영수증 등록 번호
	/* ============================================================================== */

    String req_tx_name = "";

    if     ( req_tx.equals( "pay" ) ) 
	{ 
		req_tx_name = "지불" ;
	}
    else if( req_tx.equals( "mod" ) )
	{ 
		req_tx_name = "취소/매입" ;
	}

    /* ============================================================================== */
    /* =   가맹점 측 DB 처리 실패시 상세 결과 메시지 설정                           = */
    /* = -------------------------------------------------------------------------- = */

    if ( "pay".equals ( req_tx ) )
    {
        // 업체 DB 처리 실패
        if ( "false".equals ( bSucc ) )
        {
            if ( "0000".equals ( res_cd ) )
			{
                res_msg_bsucc = "결제는 정상적으로 이루어졌지만 쇼핑몰에서 결제 결과를 처리하는 중 오류가 발생하여 시스템에서 자동으로 취소 요청을 하였습니다. <br> 쇼핑몰로 전화하여 확인하시기 바랍니다." ;
			}
            else
			{
				res_msg_bsucc = "결제는 정상적으로 이루어졌지만 쇼핑몰에서 결제 결과를 처리하는 중 오류가 발생하여 시스템에서 자동으로 취소 요청을 하였으나, <br> <b>취소가 실패 되었습니다.</b><br> 쇼핑몰로 전화하여 확인하시기 바랍니다." ;
			}
		}
    }

    /* = -------------------------------------------------------------------------- = */
    /* =   가맹점 측 DB 처리 실패시 상세 결과 메시지 설정 끝                        = */
    /* ============================================================================== */

%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >

<head>
    <title>*** KCP [AX-HUB Version] ***</title>
    <link href="css/sample.css" rel="stylesheet" type="text/css">
    <script type="text/javascript">
     
        /* 신용카드 영수증 연동 스크립트 */
        function receiptView(tno)
        {
            receiptWin = "https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no=" + tno ;
            window.open(receiptWin , "" , "width=470, height=815") ;
        }

		/* 현금영수증 연동 스크립트 */
        function receiptView2( site_cd, order_id, bill_yn, auth_no )
        {
        	receiptWin2 = "https://admin.kcp.co.kr/Modules/Service/Cash/Cash_Bill_Common_View.jsp";
        	receiptWin2 += "?";
        	receiptWin2 += "term_id=PGNW" + site_cd + "&";
        	receiptWin2 += "orderid=" + order_id + "&";
        	receiptWin2 += "bill_yn=" + bill_yn + "&";
        	receiptWin2 += "authno=" + auth_no ;

        	window.open(receiptWin2 , "" , "width=360, height=645");
        }
        function toMainResult(){
          //  opener.setCreate_Results('<%=pr_no%>');
          //  self.close();
        }
    </script>
</head>

<body>
    <div align="center">
        <table style="width:590px"  >
        <tr style="height:14px"><td style="background-image:url('./img/boxtop589.gif')"></td></tr>
        <tr>
			<td style="background-image:url('./img/boxbg589.gif') " align="center">
				<table style="width:551px"  >
                <tr style="height:17px">
                    <td style="background-image:url('./img/ttbg551.gif');border:0px " class="white">
                        <span class="bold big">[결과출력]</span> 이 페이지는 결제 결과를 출력하는 샘플(예시) 페이지입니다.
                    </td>
                </tr>
                <tr>
                    <td style="background-image:url('./img/boxbg551.gif') ;text-align:left;" >
                        요청 결과를 출력하는 페이지 입니다.<br/>
                        요청이 정상적으로 처리된 경우 결과코드(res_cd)값이 0000으로 표시됩니다.
                    </td>
                </tr>
                <tr style="height:11px"><td style="background:url('./img/boxbtm551.gif') no-repeat;"></td></tr>
                </table>
<%
    /* ============================================================================== */
    /* =   결제 결과 코드 및 메시지 출력(결과페이지에 반드시 출력해주시기 바랍니다.)= */
    /* = -------------------------------------------------------------------------- = */
    /* =   결제 정상 : res_cd값이 0000으로 설정됩니다.                              = */
    /* =   결제 실패 : res_cd값이 0000이외의 값으로 설정됩니다.                     = */
    /* = -------------------------------------------------------------------------- = */
%>
                 <table style="width:527px"   class="margin_top_20">
					<tr><td colspan="2"  class="title">처리 결과</td></tr>
					<!-- 결과 코드 -->
                    <tr><td class="sub_title1">결과 코드</td><td class="sub_content1 bold"><%=res_cd%></td></tr>
                    <!-- 결과 메시지 -->
                    <tr><td class="sub_title1">결과 메세지</td><td class="sub_content1 bold"><%=res_msg%></td></tr>
<%
    // 처리 페이지(pp_ax_hub.jsp)에서 가맹점 DB처리 작업이 실패한 경우 상세메시지를 출력합니다.
    if( !"".equals ( res_msg_bsucc ) )
    {
%>
					<tr><td class="sub_title1">결과 상세 메세지</td><td><%=res_msg_bsucc%></td></tr>
                 </table>

<%
    }
%>
<%
    /* = -------------------------------------------------------------------------- = */
    /* =   결제 결과 코드 및 메시지 출력 끝                                         = */
    /* ============================================================================== */
%>

<%
    /* ============================================================================== */
    /* =   01. 결제 결과 출력                                                       = */
    /* = -------------------------------------------------------------------------- = */
    if ( "pay".equals ( req_tx ) )
    {
        /* ============================================================================== */
        /* =   01-1. 업체 DB 처리 정상(bSucc값이 false가 아닌 경우)                     = */
        /* = -------------------------------------------------------------------------- = */
        if ( ! "false".equals ( bSucc ) )
        {
            /* ============================================================================== */
            /* =   01-1-1. 정상 결제시 결제 결과 출력 ( res_cd값이 0000인 경우)             = */
            /* = -------------------------------------------------------------------------- = */
            if ( "0000".equals ( res_cd ) )
            {
%>
                 <table width="85%" align="center" border="0" cellpadding="0" cellspacing="1" class="margin_top_10">
                     <tr><td colspan="2"  class="title">주 문 정 보</td></tr>
                     <!-- 요청번호 -->
                     <tr><td class="sub_title1">요청 번호</td><td class="sub_content1"><%= pr_no %></td></tr>
                     <!-- 주문번호 -->
                     <tr><td class="sub_title1">주문 번호</td><td class="sub_content1"><%= ordr_idxx %></td></tr>
                     <!-- KCP 거래번호 -->
                     <tr><td class="sub_title1">KCP 거래번호</td><td class="sub_content1"><%= tno %></td></tr>
                     <!-- 결제금액 -->
                     <tr><td class="sub_title1">결제 금액</td><td class="sub_content1"><%= good_mny %>원</td></tr>
                     <!-- 상품명(good_name) -->
                     <tr><td class="sub_title1">품목명</td><td class="sub_content1"><%= good_name %></td></tr>
                     <!-- 주문자명 -->
                     <tr><td class="sub_title1">주문자명</td><td class="sub_content1"><%= buyr_name %></td></tr>
                     <!-- 주문자 전화번호 -->
                     <tr><td class="sub_title1">주문자 전화번호</td><td class="sub_content1"><%= buyr_tel1 %></td></tr>
                     <!-- 주문자 휴대폰번호 -->
                     <tr><td class="sub_title1">주문자 휴대폰번호</td><td class="sub_content1"><%= buyr_tel2 %></td></tr>
                     <!-- 주문자 E-mail -->
                     <tr><td class="sub_title1">주문자 E-mail</td><td class="sub_content1"><%= buyr_mail %></td></tr>
                 </table>
<%
                /* ============================================================================== */
                /* =   신용카드 결제 결과 출력                                             = */
                /* = -------------------------------------------------------------------------- = */
                if ( use_pay_method.equals("100000000000") )
                {
%>
				 <table style="width:527px"  class="margin_top_20">
					<tr><td colspan="2" class="title">신용카드 정보</td></tr>
                    <!-- 결제수단 : 신용카드 -->
                    <tr><td class="sub_title1">결제 수단</td><td class="sub_content1">신용카드</td></tr>
                    <!-- 결제 카드 -->
                    <tr><td class="sub_title1">결제 카드</td><td class="sub_content1"><%=card_cd%> / <%=card_name%></td></tr>
                    <!-- 승인시간 -->
                    <tr><td class="sub_title1">승인 시간</td><td class="sub_content1"><%=app_time%></td></tr>
                    <!-- 승인번호 -->
                    <tr><td class="sub_title1">승인 번호</td><td class="sub_content1"><%=app_no%></td></tr>
                    <!-- 할부개월 -->
                    <tr><td class="sub_title1">할부 개월</td><td class="sub_content1"><%=quota%></td></tr>
                    <!-- 무이자 여부 -->
                    <tr><td class="sub_title1">무이자 여부</td><td class="sub_content1"><%=noinf%></td></tr>
<%
                    /* = -------------------------------------------------------------- = */
                    /* =   복합결제(포인트+신용카드) 승인 결과 처리                     = */
                    /* = -------------------------------------------------------------- = */
                     if ( pnt_issue.equals("SCSK") || pnt_issue.equals( "SCWB" ) )
                    {
%>
                </table>
                <table style="width:527px"   class="margin_top_20">
                    <tr><td colspan="2" class="title">포인트 정보</td></tr>
                    <!-- 포인트사 -->
                    <tr><td class="sub_title1">포인트사</td><td class="sub_content1"><%= pnt_issue %></td></tr>
					<!-- 결제 및 인증 아이디 -->
                    <tr><td class="sub_title1">결제 및 인증 아이디</td><td class="sub_content1"><%= pt_idno %></td></tr>
                    <!-- 포인트 승인 시간 -->
  	                <tr><td class="sub_title1">포인트 승인시간</td><td class="sub_content1"><%=pnt_app_time%></td></tr>
                    <!-- 포인트 승인번호 -->
	                <tr><td class="sub_title1">포인트 승인번호</td><td class="sub_content1"><%=pnt_app_no%></td></tr>
	                <!-- 적립금액 or 사용금액 -->
                    <tr><td class="sub_title1">적립금액 or 사용금액</td><td class="sub_content1"><%=pnt_amount%></td></tr>
                    <!-- 발생 포인트 -->
                    <tr><td class="sub_title1">발생 포인트</td><td class="sub_content1"><%=add_pnt%></td></tr>
                    <!-- 사용가능 포인트 -->
                    <tr><td class="sub_title1">사용가능 포인트</td><td class="sub_content1"><%=use_pnt%></td></tr>
					<!-- 총 누적 포인트 -->
                    <tr><td class="sub_title1">총 누적 포인트</td><td class="sub_content1"><%=rsv_pnt%></td></tr>
<%                  }
				    /* ============================================================================== */
                    /* =   신용카드 영수증 출력                                                     = */
                    /* = -------------------------------------------------------------------------- = */
                    /* =   실제 거래건에 대해서 영수증을 출력할 수 있습니다.                        = */
                    /* = -------------------------------------------------------------------------- = */
%>
                    <tr>
                        <td class="sub_title1">영수증 확인</td>
                        <td class="sub_content1"><a href="javascript:receiptView('<%=tno%>')"><img src="./img/btn_receipt.gif" alt="영수증을 확인합니다." />
                    </td>
                    <tr><td colspan="2">※ 영수증 확인은 실제결제의 경우에만 가능합니다.</td></tr>
                    <tr class="line2"><td colspan="2" bgcolor="#bbcbdb"></td></tr>
                </table>
<%				}
				/* ============================================================================== */
                /* =   계좌이체 결제 결과 출력                                                  = */
                /* = -------------------------------------------------------------------------- = */
				else if (use_pay_method.equals("010000000000"))       // 계좌이체
                {
%>
                <table style="width:527px"   class="margin_top_20">
                    <tr><td colspan="2" class="title">계좌이체 정보</td></tr>
                    <!-- 결제수단 : 계좌이체 -->
                    <tr><td class="sub_title1">결제 수단</td><td class="sub_content1">계좌이체</td></tr>
                    <!-- 이체 은행 -->
                    <tr><td class="sub_title1">이체 은행</td><td class="sub_content1"><%= bank_name %></td></tr>
                    <!-- 이체 은행 코드 -->
                    <tr><td class="sub_title1">이체 은행코드</td><td class="sub_content1"><%= bank_code %></td></tr>
                    <!-- 승인시간 -->
                    <tr><td class="sub_title1">승인 시간</td><td class="sub_content1"><%= app_time %></td></tr>
                </table>
<%
                }
				/* ============================================================================== */
                /* =   가상계좌 결제 결과 출력                                                  = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.equals("001000000000"))       
                {
%>
                <table style="width:527px"   class="margin_top_20">
                    <tr><td colspan="2" class="title">가상계좌 정보</td></tr>
                    <!-- 결제수단 : 가상계좌 -->
                    <tr><td class="sub_title1">결제 수단 </td><td class="sub_content1">가상계좌</td></tr>
                    <!-- 입금은행 -->
                    <tr><td class="sub_title1">입금 은행</td><td class="sub_content1"><%= bankname %></td></tr>
                    <!-- 입금계좌 예금주 -->
                    <tr><td class="sub_title1">입금할 계좌 예금주</td><td class="sub_content1"><%= depositor %></td></tr>
                    <!-- 입금계좌 번호 -->
                    <tr><td class="sub_title1">입금할 계좌 번호</td><td class="sub_content1"><%= account %></td></tr>
					<!-- 가상계좌 입금마감시간 -->
                    <tr><td class="sub_title1">가상계좌 입금마감시간</td><td class="sub_content1"><%= va_date %></td></tr>
                </table>
<%
				}
				/* ============================================================================== */
                /* =   포인트 결제 결과 출력                                                    = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.equals("000100000000"))       
                {
%>
                <table style="width:527px"   class="margin_top_20">
                    <tr><td colspan="2" class="title">포인트 정보</td></tr>
                    <!-- 결제수단 : 포인트 -->
                    <tr><td class="sub_title1">결제수단 </td><td class="sub_content1">포 인 트</td></tr>
                    <!-- 포인트사 -->
                    <tr><td class="sub_title1">포인트사</td><td class="sub_content1"><%= pnt_issue %></td></tr>
					<!-- 결제 및 인증 아이디 -->
                    <tr><td class="sub_title1">결제 및 인증 아이디</td><td class="sub_content1"><%= pt_idno %></td></tr>
                    <!-- 포인트 승인시간 -->
                    <tr><td class="sub_title1">포인트 승인시간</td><td class="sub_content1"><%= pnt_app_time %></td></tr>
                    <!-- 포인트 승인번호 -->
                    <tr><td class="sub_title1">포인트 승인번호</td><td class="sub_content1"><%= pnt_app_no %></td></tr>
                    <!-- 적립금액 or 사용금액 -->
                    <tr><td class="sub_title1">적립금액 or 사용금액</td><td class="sub_content1"><%= pnt_amount %></td></tr>
                    <!-- 발생 포인트 -->
                    <tr><td class="sub_title1">발생 포인트</td><td class="sub_content1"><%= add_pnt %></td></tr>
                    <!-- 사용가능 포인트 -->
                    <tr><td class="sub_title1">사용가능 포인트</td><td class="sub_content1"><%= use_pnt %></td></tr>
					<!-- 총 누적 포인트 -->
                    <tr><td class="sub_title1">총 누적 포인트</td><td class="sub_content1"><%=rsv_pnt%></td></tr>
                </table>
<%
                }
				/* ============================================================================== */
                /* =   휴대폰 결제 결과 출력                                                    = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.equals("000010000000"))
                {
%>
                <table style="width:527px"   class="margin_top_20">
                    <tr><td colspan="2" class="title">휴대폰 정보</td></tr>
                    <!-- 결제수단 : 휴대폰 -->
                    <tr><td class="sub_title1">결제 수단 </td><td class="sub_content1">휴 대 폰</td></tr>
                    <!-- 승인시간 -->
                    <tr><td class="sub_title1">승인 시간</td><td class="sub_content1"><%= app_time %></td></tr>
                    <!-- 통신사코드 -->
                    <tr><td class="sub_title1">통신사 코드</td><td class="sub_content1"><%= commid %></td></tr>
                    <!-- 승인시간 -->
                    <tr><td class="sub_title1">휴대폰 번호</td><td class="sub_content1"><%= mobile_no %></td></tr>
                </table>
<%
				}
				/* ============================================================================== */
                /* =   상품권 결제 결과 출력                                                    = */
                /* = -------------------------------------------------------------------------- = */
                else if (use_pay_method.equals("000000001000"))
                {
%>
                <table style="width:527px"   class="margin_top_20">
                    <tr><td colspan="2" class="title">상품권 정보</td></tr>
                    <!-- 결제수단 : 상품권 -->
                    <tr><td class="sub_title1">결제 수단 </td><td class="sub_content1">상 품 권</td></tr>
                    <!-- 발급사 코드 -->
                    <tr><td class="sub_title1">발급사 코드</td><td class="sub_content1"><%= tk_van_code %></td></tr>
                    <!-- 승인시간 -->
                    <tr><td class="sub_title1">승인 시간</td><td class="sub_content1"><%= app_time %></td></tr>
                    <!-- 승인번호 -->
                    <tr><td class="sub_title1">승인 번호</td><td class="sub_content1"><%= tk_app_no %></td></tr>
                </table>
<%
                }
                /* ============================================================================== */
                /* =   현금영수증 정보 출력                                                     = */
                /* = -------------------------------------------------------------------------- = */
                if( !"".equals ( cash_yn ) )
				{
%>
                <!-- 현금영수증 정보 출력-->
                <table style="width:527px"  class="margin_top_20">
                    <tr><td colspan="2" class="title">현금영수증 정보</td></tr>
                    <tr><td class="sub_title1">현금영수증 등록여부</td><td class="sub_content1"><%= cash_yn %></td></tr>
<%
                    //현금영수증이 등록된 경우 승인번호 값이 존재
                    if( !"".equals ( cash_authno ) )
					{
%>
                    <tr><td class="sub_title1">현금영수증 승인번호</td><td class="sub_content1"><%= cash_authno %></td></tr>
                    <tr>
                        <td class="sub_title1">영수증 확인</td>
                        <td class="sub_content1"><a href="javascript:receiptView2('<%=site_cd%>','<%= ordr_idxx %>', '<%= cash_yn %>', '<%= cash_authno %>')"><img src="./img/btn_receipt.gif" alt="현금영수증을  확인합니다." />
                    </td>
                    <tr><td colspan="2">※ 영수증 확인은 실제결제의 경우에만 가능합니다.</td></tr>
                    <tr class="line2"><td colspan="2" bgcolor="#bbcbdb"></td></tr>
<%
                    }
%>
                </table>
<%
				}
            }
            /* = -------------------------------------------------------------------------- = */
            /* =   01-1-1. 정상 결제시 결제 결과 출력 END                                   = */
            /* ============================================================================== */
        }
        /* = -------------------------------------------------------------------------- = */
        /* =   01-1. 업체 DB 처리 정상 END                                              = */
        /* ============================================================================== */
    }
    /* = -------------------------------------------------------------------------- = */
    /* =   01. 결제 결과 출력 END                                                   = */
    /* ============================================================================== */
%>
                <table style="width:527px"  class="margin_top_10">
                    <tr><td style="text-align:center"><a href="/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N"><img src="./img/btn_home.gif" width="108" height="37" alt="처음으로 이동합니다" /></a></td></tr>
                </table>
            </td>
        </tr>
        <tr><td><img src="./img/boxbtm589.gif" alt="Copyright(c) KCP Inc. All rights reserved."/></td></tr>
    </table>
    </div>
</body>
</html>


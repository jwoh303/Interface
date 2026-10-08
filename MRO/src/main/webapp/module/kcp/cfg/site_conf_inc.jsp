<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%
    /* ============================================================================== */
    /* =   PAGE : 결제 정보 환경 설정 PAGE                                          = */
    /* = -------------------------------------------------------------------------- = */
    /* =   연동시 오류가 발생하는 경우 아래의 주소로 접속하셔서 확인하시기 바랍니다.= */
    /* =   접속 주소 : http://testpay.kcp.co.kr/pgsample/FAQ/search_error.jsp       = */
    /* = -------------------------------------------------------------------------- = */
    /* =   Copyright (c)  2010.02   KCP Inc.   All Rights Reserved.                 = */
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   01. 지불 데이터 셋업 (업체에 맞게 수정)                                  = */
    /* = -------------------------------------------------------------------------- = */
    /* = ※ 주의 ※                                                                 = */
    /* = * g_conf_home_dir 변수 설정                                                = */
    /* =   BIN 절대 경로 입력 (bin전까지 설정						                = */
    /* = -------------------------------------------------------------------------- = */

    String g_conf_home_dir  = "/webContents/mro/module/kcp";       // BIN 절대경로 입력 (bin전까지) 
    
    /* ============================================================================== */
    /* =   02. 쇼핑몰 지불 정보 설정                                                = */
    /* = -------------------------------------------------------------------------- = */

    /* = -------------------------------------------------------------------------- = */
    /* =     02-1. 쇼핑몰 지불 필수 정보 설정(업체에 맞게 수정)                     = */
    /* = -------------------------------------------------------------------------- = */
    /* = ※ 주의 ※                                                                 = */
    /* = * g_conf_gw_url 설정                                                       = */
    /* =                                                                            = */
    /* = 테스트 시 : testpaygw.kcp.co.kr로 설정해 주십시오.                         = */
    /* = 실결제 시 : paygw.kcp.co.kr로 설정해 주십시오.                             = */
    /* =																			= */
    /* = * g_conf_js_url 설정                                                       = */
	/* = 테스트 시 : src="http://pay.kcp.co.kr/plugin/payplus_test.js"              = */
	/* =             src="https://pay.kcp.co.kr/plugin/payplus_test.js"             = */
    /* = 실결제 시 : src="http://pay.kcp.co.kr/plugin/payplus.js"                   = */
	/* =             src="https://pay.kcp.co.kr/plugin/payplus.js"                  = */
    /* =                                                                            = */
	/* = 테스트 시(UTF-8) : src="http://pay.kcp.co.kr/plugin/payplus_test_un.js"    = */
	/* =                    src="https://pay.kcp.co.kr/plugin/payplus_test_un.js"   = */
    /* = 실결제 시(UTF-8) : src="http://pay.kcp.co.kr/plugin/payplus_un.js"         = */
	/* =                    src="https://pay.kcp.co.kr/plugin/payplus_un.js"        = */
    /* =                                                                            = */
	/* =                                                                            = */
    /* = * g_conf_site_cd, g_conf_site_key 설정                                     = */
    /* = 실결제시 KCP에서 발급한 사이트코드(site_cd), 사이트키(site_key)를 반드시   = */
    /* =   변경해 주셔야 결제가 정상적으로 진행됩니다.                              = */
    /* =                                                                            = */
    /* = 테스트 시 : 사이트코드(T0000)와 사이트키(3grptw1.zW0GSo4PQdaGvsF__)로      = */
    /* =            설정해 주십시오.                                                = */
    /* = 실결제 시 : 반드시 KCP에서 발급한 사이트코드(site_cd)와 사이트키(site_key) = */
    /* =            로 설정해 주십시오.                                             = */
    /* =                                                                            = */
    /* =                                                                            = */
    /* = * g_conf_site_name 설정                                                    = */
    /* = 사이트명 설정(한글 불가) : Payplus Plugin에서 상점명 및 오른쪽 상단에      = */
	/* =                            표기되는 값입니다.                              = */
    /* =                            반드시 영문자로 설정하여 주시기 바랍니다.       = */
    /* = -------------------------------------------------------------------------- = */
 
    
   		String g_conf_gw_url    = ""; // 운영시 실서버로 변경해주세여  
	    String g_conf_js_url    =  "";  // 운영시 실서버로 변경해주세여  
	    String g_conf_site_cd   =  "";
	    String g_conf_site_key  =  "";
	    String g_conf_site_name = "";
 
		String flag = CommonUtil.getDevRealLocalFlag(request); // 0 로컬 1 개발 2 운영
		//System.out.println("0 lcoal 1 dev 2 prod " +flag);
		if ("2".equals(flag)){
 		     
             //g_conf_gw_url    = "203.238.36.136"; url 변경으로 인한 주석 처리 19년9월15일 테스트 이후 삭제. 현명환.
             g_conf_gw_url    = "paygw.kcp.co.kr";
		     g_conf_js_url    = "https://pay.kcp.co.kr/plugin/payplus.js";
		     g_conf_site_cd   = "H8669";
		     g_conf_site_key  = "46iI.cHFh6epxTSRYxpSO4Y__";
		     g_conf_site_name = "KoreaB2B"; 
/*		     
		     g_conf_gw_url    = "testpaygw.kcp.co.kr"; // 운영시 실서버로 변경해주세여  
		     g_conf_js_url    = "https://pay.kcp.co.kr/plugin/payplus_test.js";  // 운영시 실서버로 변경해주세여  
		     g_conf_site_cd   = "T0000";
		     g_conf_site_key  = "3grptw1.zW0GSo4PQdaGvsF__";
		     g_conf_site_name = "KCP TEST SHOP";	
*/		     
		}else{
		     g_conf_gw_url    = "testpaygw.kcp.co.kr"; // 운영시 실서버로 변경해주세여  
		     g_conf_js_url    = "https://pay.kcp.co.kr/plugin/payplus_test.js";  // 운영시 실서버로 변경해주세여  
		     g_conf_site_cd   = "T0000";
		     g_conf_site_key  = "3grptw1.zW0GSo4PQdaGvsF__";
		     g_conf_site_name = "KCP TEST SHOP";	
		}
	 
    
     
    /* ============================================================================== */


    /* = -------------------------------------------------------------------------- = */
    /* =     02-2. 지불 데이터 셋업 (변경 불가)                                     = */
    /* = -------------------------------------------------------------------------- = */

    String g_conf_gw_port   = "8090";        // 포트번호(변경불가)

    /* ============================================================================== */
%>

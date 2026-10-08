package com.kep.common;

import java.util.HashMap;
import java.util.Map;

public class CommonProperty {

	private static String DB_CONN	= "2";	// 0:개발, 2:운영
	
	private static String NeoOrgWsImplPort_address_live = "http://hwc.circle.hanwha.com/api/ss/org?type=";
	private static String NeoOrgWsImplPort_address_dev = "http://hwc.circle.hanwha.com/api/ss/org?type=";	// TODO : 오픈이후 개발주소로 일괄 변경
	
	private static String ModusignApiUrl_dev = "https://api.modusign.co.kr/documents";
	private static String ModusignApiUrl_live = "https://api.modusign.co.kr/documents";
	
	private static String ModusignAuthorization="Basic ZS1jb250cmFjdEBrb3JlYWIyYi5jb206WWpkbVpqSmxaREV0TURFNFpDMDBOalk1TFdJd09EVXRZVFUwWVRjME5tSTJaVEk0";
	
	private static String MM001_HTTP_url_live = "http://pxpscsvhost.kkpc.com:8080/XISOAPAdapter/MessageServlet?senderParty=&senderService=KEP_P&receiverParty=&receiverService=&interface=KEP_MM_001_SO&interfaceNamespace=http%3A%2F%2Fkkpc.com%2FKEP_MM_001";
	private static String MM001_HTTP_url_dev = "http://pxpscsvhost.kkpc.com:8080/XISOAPAdapter/MessageServlet?senderParty=&senderService=KEP_P&receiverParty=&receiverService=&interface=KEP_MM_001_SO&interfaceNamespace=http%3A%2F%2Fkkpc.com%2FKEP_MM_001";
	
	private static String MM002_HTTP_url_live = "http://pxpscsvhost.kkpc.com:8080/XISOAPAdapter/MessageServlet?senderParty=&senderService=KEP_P&receiverParty=&receiverService=&interface=KEP_MM_002_SO&interfaceNamespace=http%3A%2F%2Fkkpc.com%2FKEP_MM_002";
	private static String MM002_HTTP_url_dev = "http://pxpscsvhost.kkpc.com:8080/XISOAPAdapter/MessageServlet?senderParty=&senderService=KEP_P&receiverParty=&receiverService=&interface=KEP_MM_002_SO&interfaceNamespace=http%3A%2F%2Fkkpc.com%2FKEP_MM_002";
	
	private static String HUGEL_USER_NAME = "sb-e7d35d23-d096-420f-8058-dfe136a8bddf!b1458|it-rt-is-dev!b33";
	private static String HUGEL_USER_PWD = "c98bf9db-98c0-4eeb-a6be-3ecb9483dfea$JS7G_BJvDx1Ff2ogYu5jyBQT5CvhdBaXrSJycvIEpqI=";
	
	private static String AEKY_API_KEY = "a1d789ff7bd4a32092673e5cea1ca28493402d1299950527e2ca3e03686f572f";	
	
												// 0: 스마트잭 개발, 1: 이노엔 개발, 2: 이노엔 운영
	private static String HKINN_KEY = "1a601d609c5793afaf0e8e6fcf2114b8sm@rt$cke87dffef57a01ca5fa761b90eea1b62f";
	private static String HKINN_SECRET_KEY = "$2b$10$zkI9BiRFSojEcCifxPsRb.TroaDMfT48b8QuTkJ.v/i.mjp6UTETK";
	private static String SMILE_J_DEV_URL = "https://hk-mro.wp-dev.xyz/";
	private static String HKINN_DEV_URL = "http://218.238.95.119:8000/";
	private static String HKINN_LIVE_URL = "https://rms.inno-n.com/mroapi/";
	
	private static String SKMW_DEV_URL = "https://devif.emrocloud.com/rest/api/skmicroworks/custom/kep/";
	private static String SKMW_LIVE_URL = "https://if.emrocloud.com/rest/api/skmicroworks/custom/kep/";
	
												// 1: 피유코어 개발, 2: 피유코어 운영
	private static String SKPC_DEV_URL = "https://withus-dev.pucoreco.com/itf/kep/";
	private static String SKPC_LIVE_URL = "https://withus.pucoreco.com/itf/kep/";
	
	private static String HANSSEM_NO	= "2";	// 0: 한샘 개발, 1: 한샘 QA, 2: 한샘 운영
	private static String HANSSEM_DEV_URL = "https://eaidev.hanssem.com:8100/rest/hsko_kep.serv.source.";
	private static String HANSSEM_QA_URL = "https://eaidev.hanssem.com:8101/rest/hsko_kep.serv.source.";
	private static String HANSSEM_LIVE_URL = "https://eai.hanssem.com:8100/rest/hsko_kep.serv.source.";
	

												// 0: 아모레퍼시픽 DEV, 1: 아모레퍼시픽 STG, 2: 아모레퍼시픽 PRD
	private static String AMOREPACIFIC_DEV_URL = "http://3.35.204.235:5510/invoke/AP_FM_01.";
	private static String AMOREPACIFIC_STG_URL = "http://apollo-stg.apglobal.com:5510/invoke/AP_FM_01.";	
	private static String AMOREPACIFIC_PRD_URL = "http://apollo-prd.apglobal.com:5510/invoke/AP_FM_01.";
	

	private static String NEXE_DEV_URL = "http://211.206.105.36:8094/NEXEN/Projects/KEP_SRVON/";
	private static String NEXE_LIVE_URL = "http://211.206.105.42:8094/NEXEN/Projects/KEP_SRVON/";
	
	private static String DELIVERY_DEV_URL = "http://trace-api-dev.sweettracker.net:8102/add_invoice_list";	
	private static String DELIVERY_PRD_URL = "https://trace-api.sweettracker.net/add_invoice_list";
	private static String CALLBACK_DEV_URL = "http://eai.koreab2b.com:9192/delivery.do";	
	private static String CALLBACK_PRD_URL = "http://eai.koreab2b.com:9191/delivery.do";
	
	private static String PARCEL_DEV_URL = "https://apis.tracker.delivery/graphql";	
	private static String PARCEL_PRD_URL = "https://apis.tracker.delivery/graphql";
	
	private static String HANJIN_DEV_URL = "https://api-stg.hanjin.com";	
	private static String HANJIN_PRD_URL = "https://api.hanjin.com";
	private static String HANJIN_PRINT_PRD_URL = "https://ebbapp.hjt.co.kr/v1/wbl/KORB2B/print-wbl-sc";	
	private static String HANJIN_PRINT_DEV_URL = "https://ebbapd.hjt.co.kr/v1/wbl/KORB2B/print-wbl-sc";
	private static String HANJIN_CLIENT_ID = "KORB2B";
	private static String HANJIN_API_KEY = "5FIfXguzytQe3J19wPeQe1HC3m1wDv0UVsvbZvsDtDnpr6Oy";	
	
	private static String JWPH_HTTP_url_live = "https://jw-resellermall.jw-group.co.kr/v1/interface";
	private static String JWPH_HTTP_url_dev = "https://jw-resellermall.jw-group.co.kr/kep-mock/v1/interface";	
	
	private static String Hans_HTTP_url_live = "https://homedeco-wmedi.hansol.net:5543";
	private static String Hans_HTTP_url_dev = "https://homedeco-wmedi-dev.hansol.net:5543";	
	
	public static String getModusignApiUrl() {

		String ModusignApiUrl = "";
		if ("2".equals(DB_CONN)) {
			ModusignApiUrl = ModusignApiUrl_live;
		} else {
			ModusignApiUrl = ModusignApiUrl_dev;
		}
		return ModusignApiUrl;
	}
	
	public static String getModusignAuthorization() {
		return ModusignAuthorization;
	}

	public static String getDB_CONN() {
		return DB_CONN;
	}

	public static void setDB_CONN(String dB_CONN) {
		DB_CONN = dB_CONN;
	}

	public static String getNeoOrgWsImplPort_address() {
		String NeoOrgWsImplPort_address = "";
		if ("2".equals(DB_CONN)) {
			NeoOrgWsImplPort_address = NeoOrgWsImplPort_address_live;
		} else {
			NeoOrgWsImplPort_address = NeoOrgWsImplPort_address_dev;
		}
		return NeoOrgWsImplPort_address;
	}

	public static void setNeoOrgWsImplPort_address(String neoOrgWsImplPort_address) {
		if ("2".equals(DB_CONN)) {
			NeoOrgWsImplPort_address_live = neoOrgWsImplPort_address;	
		} else {
			NeoOrgWsImplPort_address_dev = neoOrgWsImplPort_address;	
		}
	}
	

	public static String getMM001_HTTP_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = MM001_HTTP_url_live;	// Live
		} else {
			url = MM001_HTTP_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getMM002_HTTP_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = MM002_HTTP_url_live;	// Live
		} else {
			url = MM002_HTTP_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getNEXE_URL() {
		String url = "";
		if ("0".equals(DB_CONN)) {
			url = NEXE_DEV_URL;		// Dev
		}else if ("7".equals(DB_CONN)) {
			url = NEXE_DEV_URL;		// Dev
		} else {
			url = NEXE_LIVE_URL;	// Live
		}
		return url;
	}
	
	public static String getHugelUserName() {
		return HUGEL_USER_NAME;
	}
	
	public static String getHugelUserPwd() {
		return HUGEL_USER_PWD;
	}
	
	public static String getAekyApiKey() {
		return AEKY_API_KEY;
	}
	
	public static String getHkInnKey() {
		return HKINN_KEY;
	}
	
	public static String getHkInnSecretKey() {
		return HKINN_SECRET_KEY;
	}
	
	public static String getHkInnUrl() {
		String url = "";
		if ("0".equals(DB_CONN)) {
			url = SMILE_J_DEV_URL;
		}else if("1".equals(DB_CONN)){
			url = HKINN_DEV_URL;
		}else {
			url = HKINN_LIVE_URL;
		}
		return url;
	}
	
	public static String getSmileJDevUrl() {
		return SMILE_J_DEV_URL;
	}
	
	public static String getHkInnDevUrl() {
		return HKINN_DEV_URL;
	}
	
	public static String getHkInnLiveUrl() {
		return HKINN_LIVE_URL;
	}
	
	public static String getSkMwDevUrl() {
		return SKMW_DEV_URL;
	}
	
	public static String getSkMwLiveUrl() {
		return SKMW_LIVE_URL;
	}
	
	public static String getSkPcUrl() {
		String url = "";
		if("2".equals(DB_CONN)){			
			url = SKPC_LIVE_URL;
		}else {
			url = SKPC_DEV_URL;
		}
		return url;
	}
	
	public static String getSkPcDevUrl() {
		return SKPC_DEV_URL;
	}
	
	public static String getSkPcLiveUrl() {
		return SKPC_LIVE_URL;
	}
	
	public static String getHanssemUrl() {
		String url = "";
		if("0".equals(DB_CONN)){
			url = HANSSEM_DEV_URL;
		}else if("1".equals(DB_CONN)){
			url = HANSSEM_QA_URL;
		}else {
			url = HANSSEM_LIVE_URL;
		}
		return url;
	}
	
	public static String getHanssemNo() {		
		return HANSSEM_NO;
	}
	
	public static String getAmorepacificUrl() {
		String url = "";
		if("0".equals(DB_CONN)){
			url = AMOREPACIFIC_DEV_URL;
		}else if("1".equals(DB_CONN)){
			url = AMOREPACIFIC_STG_URL;
		}else {
			url = AMOREPACIFIC_PRD_URL;
		}
		return url;
	}
	
	public static Map<String, Object> getDeliveryInfo() {		
		Map<String, Object> deliObj = new HashMap<String,Object>();
		if ("2".equals(DB_CONN)) {			
			deliObj.put("url", DELIVERY_PRD_URL);
			deliObj.put("callbackUrl", CALLBACK_PRD_URL);
		} else {
			deliObj.put("url", DELIVERY_DEV_URL);
			deliObj.put("callbackUrl", CALLBACK_DEV_URL);
		}
		return deliObj;
	}
	
	public static String getParcelUrl() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = PARCEL_PRD_URL;	// Live
		} else {
			url = PARCEL_DEV_URL;	// Dev
		}
		return url;
	}
	
	public static String getHanjinUrl() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = HANJIN_PRD_URL;	// Live
		} else {
			url = HANJIN_DEV_URL;	// Dev
		}
		return url;
	}
	
	public static String getHanjinPrintUrl() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = HANJIN_PRINT_PRD_URL;	// Live
		} else {
			url = HANJIN_PRINT_DEV_URL;	// Dev
		}
		return url;
	}
	
	public static String getHanjinApiKey() {
		return HANJIN_API_KEY;
	}
	
	public static String getHanjinClientId() {
		return HANJIN_CLIENT_ID;
	}

	public static String getJWPH_URL() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = JWPH_HTTP_url_live;	// Live
		} else {
			url = JWPH_HTTP_url_dev;	// Dev
		}
		return url;
	}

	public static String getHans_URL() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = Hans_HTTP_url_live;	// Live
		} else {
			url = Hans_HTTP_url_dev;	// Dev
		}
		return url;
	}
}
package com.koreab2b.common;

public class CommonProperty {

	private static String DB_CONN	= "0";	// 0:개발, 2:운영
	private static String username_live	= "IF_K2PKBB";
	private static String password_live	= "Interface!12";
	private static String username_dev	= "IF_K2PKBB";
	private static String password_dev	= "Interface!12";
	
	private static String SI_GRP_MM0710_url_live  = "https://eai.advancedfiber.co.kr/XISOAPAdapter/MessageServlet?senderParty=&senderService=K2P_KBB_PRD&receiverParty=&receiverService=&interface=SI_GRP_MM0710_SO&interfaceNamespace=http%3A%2F%2Fgrpeccmm.esp.com%2Fk2pkbb";
	private static String SI_GRP_MM0710_url_dev   = "https://deveai.advancedfiber.co.kr/XISOAPAdapter/MessageServlet?senderParty=&senderService=K2P_KBB_DEV&receiverParty=&receiverService=&interface=SI_GRP_MM0710_SO&interfaceNamespace=http%3A%2F%2Fgrpeccmm.esp.com%2Fk2pkbb";

	private static String SI_GRP_MM1200_url_live  = "https://eai.advancedfiber.co.kr/XISOAPAdapter/MessageServlet?senderParty=&senderService=K2P_KBB_PRD&receiverParty=&receiverService=&interface=SI_GRP_MM1200_SO&interfaceNamespace=http%3A%2F%2Fgrpeccmm.esp.com%2Fk2pkbb";
	private static String SI_GRP_MM1200_url_dev   = "https://deveai.advancedfiber.co.kr/XISOAPAdapter/MessageServlet?senderParty=&senderService=K2P_KBB_DEV&receiverParty=&receiverService=&interface=SI_GRP_MM1200_SO&interfaceNamespace=http%3A%2F%2Fgrpeccmm.esp.com%2Fk2pkbb";

	private static String SI_INFMPO0030_url_live  = "https://eai.advancedfiber.co.kr/XISOAPAdapter/MessageServlet?senderParty=&senderService=K2P_KBB_PRD&receiverParty=&receiverService=&interface=SI_INFMPO0030_SO&interfaceNamespace=http%3A%2F%2Finfmpo.esp.com%2Fk2pkbb";
	private static String SI_INFMPO0030_url_dev   = "https://deveai.advancedfiber.co.kr/XISOAPAdapter/MessageServlet?senderParty=&senderService=K2P_KBB_DEV&receiverParty=&receiverService=&interface=SI_INFMPO0030_SO&interfaceNamespace=http%3A%2F%2Finfmpo.esp.com%2Fk2pkbb";

	private static String KSI_GRP_MM0710_url_live = "https://eai-koreab2b.kolon.com/n_grpmm0710_action";
	private static String KSI_GRP_MM0710_url_qa   = "https://eai-koreab2b.kolon.com/pce_qa_grpmm0710_action";
	private static String KSI_GRP_MM0710_url_dev  = "https://eai-koreab2b.kolon.com/n_dev_grpmm0710_action";

	private static String KSI_GRP_MM1200_url_live = "https://eai-koreab2b.kolon.com/n_grpmm1200_action";
	private static String KSI_GRP_MM1200_url_qa   = "https://eai-koreab2b.kolon.com/n_qa_grpmm1200_action";
	private static String KSI_GRP_MM1200_url_dev  = "https://eai-koreab2b.kolon.com/n_dev_grpmm1200_action";

	private static String KSI_INFMPO0030_url_live = "https://eai-koreab2b.kolon.com/n_infmpo0030_action";
	private static String KSI_INFMPO0030_url_qa   = "https://eai-koreab2b.kolon.com/n_qa_infmpo0030_action";
	private static String KSI_INFMPO0030_url_dev  = "https://eai-koreab2b.kolon.com/n_dev_infmpo0030_action";
	
	private static String KSI_INFIPA0110_url_live = "https://eai-koreab2b.kolon.com/n_infipa0110_action";
	private static String KSI_INFIPA0110_url_qa   = "https://eai-koreab2b.kolon.com/n_qa_infipa0110_action";
	
	private static String MM50_HTTP_url_live = "http://15.164.23.131:51000/XISOAPAdapter/MessageServlet?senderParty=&senderService=MRO&receiverParty=&receiverService=&interface=MM50_REQ_SO&interfaceNamespace=http%3A%2F%2Fdongwha.co.kr%2FECC_MM%2FMM50";
	private static String MM50_HTTP_url_dev  = "http://xidev.dongwha.com:50000/XISOAPAdapter/MessageServlet?senderParty=&senderService=MRO&receiverParty=&receiverService=&interface=MM50_REQ_SO&interfaceNamespace=http%3A%2F%2Fdongwha.co.kr%2FECC_MM%2FMM50";
	private static String MM51_HTTP_url_live = "http://15.164.23.131:51000/XISOAPAdapter/MessageServlet?senderParty=&senderService=MRO&receiverParty=&receiverService=&interface=MM51_REQ_SO&interfaceNamespace=http%3A%2F%2Fdongwha.co.kr%2FECC_MM%2FMM51";
	private static String MM51_HTTP_url_dev  = "http://xidev.dongwha.com:50000/XISOAPAdapter/MessageServlet?senderParty=&senderService=MRO&receiverParty=&receiverService=&interface=MM51_REQ_SO&interfaceNamespace=http%3A%2F%2Fdongwha.co.kr%2FECC_MM%2FMM51";
	
	public static String getDB_CONN() {
		return DB_CONN;
	}

	public static void setDB_CONN(String dB_CONN) {
		DB_CONN = dB_CONN;
	}

	public static String getUsername() {
		String _username	= "";
		if ("2".equals(DB_CONN)) {
			_username = username_live;	// Live
		} else {
			_username = username_dev;	// Dev
		}
		return _username;
	}

	public static String getPassword() {
		String _password	= "";
		if ("2".equals(DB_CONN)) {
			_password = password_live;	// Live
		} else {
			_password = password_dev;	// Dev
		}
		return _password;
	}
	
	public static String getSI_GRP_MM0710_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = SI_GRP_MM0710_url_live;	// Live
		} else {
			url = SI_GRP_MM0710_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getSI_GRP_MM1200_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = SI_GRP_MM1200_url_live;	// Live
		} else {
			url = SI_GRP_MM1200_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getSI_INFMPO0030_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = SI_INFMPO0030_url_live;	// Live
		} else {
			url = SI_INFMPO0030_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getKSI_INFMPO0030_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = KSI_INFMPO0030_url_live;	// Live
		} else if ("1".equals(DB_CONN)) {
			url = KSI_INFMPO0030_url_qa;	// QA
		} else {
			url = KSI_INFMPO0030_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getKSI_INFIPA0110_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = KSI_INFIPA0110_url_live;	// Live
		} else {
			url = KSI_INFIPA0110_url_qa;	// QA
		}
		return url;
	}
	
	public static String getKSI_GRP_MM0710_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = KSI_GRP_MM0710_url_live;	// Live
		} else if ("1".equals(DB_CONN)) {
			url = KSI_GRP_MM0710_url_qa;	// QA
		} else {
			url = KSI_GRP_MM0710_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getKSI_GRP_MM1200_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = KSI_GRP_MM1200_url_live;	// Live
		} else if ("1".equals(DB_CONN)) {
			url = KSI_GRP_MM1200_url_qa;	// QA
		} else {
			url = KSI_GRP_MM1200_url_dev;	// Dev
		}
		return url;
	}
	
	public static String getMM50_HTTP_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = MM50_HTTP_url_live;	// Live
		} else {
			url = MM50_HTTP_url_dev;	// Dev
		}
		return url;
	}

	public static String getMM51_HTTP_url() {
		String url = "";
		if ("2".equals(DB_CONN)) {
			url = MM51_HTTP_url_live;	// Live
		} else {
			url = MM51_HTTP_url_dev;	// Dev
		}
		return url;
	}
}
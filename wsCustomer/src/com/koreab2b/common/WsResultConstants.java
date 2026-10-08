package com.koreab2b.common;

public class WsResultConstants {


	public static enum WS_RESULT {

		OK("S", "Success"),
		ERROR("E", "Error"),
		AUTH_ERROR("001", "인증실패"),
		SYSTEM_ERROR("002", "시스템 오류"),
		SERVER_ERROR("500", "Internal Server Error");
	
		private String zResultCd;
		private String zResultMsg;
	
		private WS_RESULT(String zResultCd, String zResultMsg){
	        this.zResultCd = zResultCd;
	        this.zResultMsg = zResultMsg;
	    }

		public String getzResultCd() {
			return zResultCd;
		}

		public String getzResultMsg() {
			return zResultMsg;
		}

		
	}

	public WsHeaderVO WsResult(WS_RESULT wsHeader){
		
		String resultCode = wsHeader.zResultCd;
		String resultMessage = wsHeader.zResultMsg;
		
		WsHeaderVO wsResultVO = new WsHeaderVO();
		wsResultVO.setzResultCd(resultCode);
		wsResultVO.setzResultMsg(resultMessage);
		return wsResultVO;
    }

}

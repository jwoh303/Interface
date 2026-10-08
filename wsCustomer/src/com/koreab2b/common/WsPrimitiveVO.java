package com.koreab2b.common;

import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class WsPrimitiveVO {

	private String returnString;

    private WsHeaderVO wsHeader;

	public String getReturnString() {
		return returnString;
	}

	public void setReturnString(String returnString) {
		this.returnString = returnString;
	}

	public WsHeaderVO getWsHeader() {
		if(wsHeader == null) {
			return new WsResultConstants().WsResult(WS_RESULT.OK);
		}
		return wsHeader;
	}

	public void setWsHeader(WsHeaderVO wsHeader) {
		this.wsHeader = wsHeader;
	}
}

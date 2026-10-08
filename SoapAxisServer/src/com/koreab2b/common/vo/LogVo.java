package com.koreab2b.common.vo;

public class LogVo {
	/* 인터페이스ID */
	private String INTERFACE_ID;
	/* WS MESSAGE */
	private String CONTENTS;
	/* 처리결과  */
	private String FLAG;
	/* 오류메세지 */
	private String ERROR_MSG;
	/* 참조값1 */
	private String DATA01;
	/* 참조값2 */
	private String DATA02;
	/* 참조값3 */
	private String DATA03;
	
	public String getINTERFACE_ID() {
		return INTERFACE_ID;
	}
	public void setINTERFACE_ID(String iNTERFACE_ID) {
		INTERFACE_ID = iNTERFACE_ID;
	}
	public String getCONTENTS() {
		return CONTENTS;
	}
	public void setCONTENTS(String cONTENTS) {
		CONTENTS = cONTENTS;
	}
	public String getFLAG() {
		return FLAG;
	}
	public void setFLAG(String fLAG) {
		FLAG = fLAG;
	}
	public String getERROR_MSG() {
		return ERROR_MSG;
	}
	public void setERROR_MSG(String eRROR_MSG) {
		ERROR_MSG = eRROR_MSG;
	}
	public String getDATA01() {
		return DATA01;
	}
	public void setDATA01(String dATA01) {
		DATA01 = dATA01;
	}
	public String getDATA02() {
		return DATA02;
	}
	public void setDATA02(String dATA02) {
		DATA02 = dATA02;
	}
	public String getDATA03() {
		return DATA03;
	}
	public void setDATA03(String dATA03) {
		DATA03 = dATA03;
	}
}

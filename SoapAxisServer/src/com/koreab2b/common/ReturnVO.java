package com.koreab2b.common;

public class ReturnVO {

	/**
	 * S:성공 , E:실패
	 */
	private String RESULT_FLAG;
	private String MESSAGE;
	private String TYPE;
	
	public String getRESULT_FLAG() {
		return RESULT_FLAG;
	}
	public void setRESULT_FLAG(String rESULT_FLAG) {
		RESULT_FLAG = rESULT_FLAG;
	}
	public String getMESSAGE() {
		return MESSAGE;
	}
	public void setMESSAGE(String mESSAGE) {
		MESSAGE = mESSAGE;
	}
	public String getTYPE() {
		return TYPE;
	}
	public void setTYPE(String tYPE) {
		TYPE = tYPE;
	}
}

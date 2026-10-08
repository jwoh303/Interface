package com.koreab2b.xica.vo;

public class xicaReturnVO {
	
	private String resultSt;    //결과값 (성공 : S, 실패 : F)
	private String errMsg;		//에러 메시지
	
	
	public String getResultSt() {
		return resultSt;
	}
	public void setResultSt(String resultSt) {
		this.resultSt = resultSt;
	}
	public String getErrMsg() {
		return errMsg;
	}
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}
	
	

}

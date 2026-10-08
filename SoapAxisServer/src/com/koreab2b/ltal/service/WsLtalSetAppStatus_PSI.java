package com.koreab2b.ltal.service;

import com.koreab2b.ltal.vo.ApprovalStatusVO;
import com.koreab2b.ltal.vo.ReturnVO;

public interface WsLtalSetAppStatus_PSI {

	public ReturnVO saveAppInfo(ApprovalStatusVO[] aprList) throws Exception;
	
	public void saveLog(ApprovalStatusVO[] aprList, ReturnVO rtn);
}

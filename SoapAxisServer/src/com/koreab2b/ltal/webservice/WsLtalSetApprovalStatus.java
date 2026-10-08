package com.koreab2b.ltal.webservice;

import com.koreab2b.ltal.vo.ApprovalStatusVO;
import com.koreab2b.ltal.vo.ReturnVO;

public interface WsLtalSetApprovalStatus {

	public ReturnVO saveApprovalStatus(ApprovalStatusVO[] aprList);
}
package com.koreab2b.ltal.dao;

import com.koreab2b.ltal.vo.ApprovalStatusVO;
import com.koreab2b.ltal.vo.ReturnVO;

public interface WsLtalSetAppStatus_Dao {

	public ReturnVO saveAppStatus(ApprovalStatusVO[] aprList) throws Exception;
}

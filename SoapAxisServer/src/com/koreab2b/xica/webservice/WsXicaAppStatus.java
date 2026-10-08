package com.koreab2b.xica.webservice;

import com.koreab2b.xica.vo.xicaAppStatusVO;
import com.koreab2b.xica.vo.xicaReturnVO;

public interface WsXicaAppStatus {
	
	public xicaReturnVO saveApprovalStatus(xicaAppStatusVO aprList) throws Exception;

}

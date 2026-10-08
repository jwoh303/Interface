package com.koreab2b.xica.service;

import com.koreab2b.xica.vo.xicaAppStatusVO;
import com.koreab2b.xica.vo.xicaReturnVO;

public interface WsXicaSetAppStatus_PSI {

	/**
	 * appr 인터페이스 처리
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public xicaReturnVO saveAppInfo(xicaAppStatusVO aprList) throws Exception;
	
	public void saveLog(xicaAppStatusVO aprList, xicaReturnVO rtn) throws Exception;
}

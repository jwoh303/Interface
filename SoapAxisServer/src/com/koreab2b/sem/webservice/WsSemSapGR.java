package com.koreab2b.sem.webservice;

import com.koreab2b.sem.vo.GdRcptVO;
import com.koreab2b.sem.vo.ReturnVO;

public interface WsSemSapGR {
	
	/**
	 * SEM GR Recv Provider
	 * @param gdRcptVO
	 * @return
	 * @throws Exception
	 */
	public ReturnVO gdRcptSnd(GdRcptVO[] gdRcptVO) throws Exception;
}

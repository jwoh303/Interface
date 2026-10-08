package com.koreab2b.sem.service;

import com.koreab2b.sem.vo.GdRcptVO;
import com.koreab2b.sem.vo.ReturnVO;

public interface WsSemSapGR_PSI {

	/**
	 * 입고정보 생성
	 * @param gdRcptVO
	 * @return
	 * @throws Exception
	 */
	public ReturnVO gdRcptSnd(GdRcptVO[] gdRcptVO) throws Exception;
	
	public void saveLog(GdRcptVO[] gdRcptVO, ReturnVO rtn);
}

package com.koreab2b.sem.dao;

import com.koreab2b.sem.vo.GdRcptVO;
import com.koreab2b.sem.vo.ReturnVO;

public interface WsSemSapGR_Dao {

	/**
	 * 입고정보 생성
	 * @param gdRcptVO
	 * @return
	 * @throws Exception
	 */
	public ReturnVO gdRcptSnd(GdRcptVO[] gdRcptVO) throws Exception;
}

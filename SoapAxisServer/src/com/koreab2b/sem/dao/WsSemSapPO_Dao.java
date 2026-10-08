package com.koreab2b.sem.dao;

import com.koreab2b.sem.vo.PcsOrdrDtlVO;
import com.koreab2b.sem.vo.PcsOrdrMasVO;
import com.koreab2b.sem.vo.ReturnVO;

public interface WsSemSapPO_Dao {

/**
 * 발주등록
 * @param pcsOrdrMasVO
 * @param pcsOrdrDtlVO
 * @return
 * @throws Exception
 */
	public void pcsOrdrSnd(PcsOrdrMasVO pcsOrdrMasVO, PcsOrdrDtlVO[] pcsOrdrDtlVO) throws Exception;
}

package com.koreab2b.sem.service;

import com.koreab2b.sem.vo.PcsOrdrDtlVO;
import com.koreab2b.sem.vo.PcsOrdrMasVO;
import com.koreab2b.sem.vo.ReturnVO;

public interface WsSemSapPO_PSI {

/**
 * 발주등록
 * @param pcsOrdrMasVO
 * @param pcsOrdrDtlVO
 * @return
 * @throws Exception
 */
	public void pcsOrdrSnd(PcsOrdrMasVO pcsOrdrMasVO, PcsOrdrDtlVO[] pcsOrdrDtlVO) throws Exception;
	
	public void saveLog(PcsOrdrMasVO pcsOrdrMasVO, PcsOrdrDtlVO[] pcsOrdrDtlVO, ReturnVO rtn);
}

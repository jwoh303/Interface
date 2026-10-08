package com.koreab2b.sem.webservice;

import com.koreab2b.sem.vo.PcsOrdrDtlVO;
import com.koreab2b.sem.vo.PcsOrdrMasVO;
import com.koreab2b.sem.vo.ReturnVO;

public interface WsSemSapPO {

	/**
	 * SEM PO Recv Provider
	 * @param pcsOrdrMasVO
	 * @param pcsOrdrDtlVO
	 * @return
	 * @throws Exception
	 */
	public void pcsOrdrSnd(PcsOrdrMasVO pcsOrdrMasVO, PcsOrdrDtlVO[] pcsOrdrDtlVO) throws Exception;
}

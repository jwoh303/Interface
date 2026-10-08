package com.koreab2b.rfq.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.ItemConfirmVO;

public interface KEP_ITEM_CONFIRM_PSI {

	/**
	 * 단가승인 정보 수신 (BQMS --> KEP)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveItemConfirm(ItemConfirmVO[] arrVo) throws Exception;
	
	/**
	 * 단가승인 정보 수신 이력 저장.
	 * @param vo
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(ItemConfirmVO[] arrVo, WsPrimitiveVO rtn) throws Exception;
}

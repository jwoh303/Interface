package com.koreab2b.rfq.service;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.ItemRequestVO;

public interface KEP_ITEM_REQUEST_PSI {

	/**
	 * 신규 품목정보 요청 (BQMS --> KEP)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public WsPrimitiveVO saveItemRequest(ItemRequestVO[] arrVo) throws Exception;
	
	/**
	 * 신규 품목정보 요청 이력 저장.
	 * @param vo
	 * @param rtn
	 * @throws Exception
	 */
	public void saveLog(ItemRequestVO[] arrVo, WsPrimitiveVO rtn) throws Exception;
}

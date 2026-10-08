package com.koreab2b.rfq.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.ItemConfirmVO;

public interface KEP_ITEM_CONFIRM_WSI {

	/**
	 * 단가승인 저장
	 * @param ItemConfirmVO
	 * @return
	 */
	public WsPrimitiveVO saveItemConfirm(ItemConfirmVO[] arrVo);
}

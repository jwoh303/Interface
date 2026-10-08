package com.koreab2b.rfq.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.rfq.vo.ItemRequestVO;

public interface KEP_ITEM_REQUEST_WSI {

	/**
	 * 품목정보요청 저장
	 * @param ReturnOrderVO
	 * @return
	 */
	public WsPrimitiveVO saveItemRequest(ItemRequestVO[] arrVo);
}

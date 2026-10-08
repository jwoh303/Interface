package com.koreab2b.po.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.po.vo.ReturnOrderVO;

public interface KEP_RETURN_ORDER_WSI {

	/**
	 * 교환반품 저장
	 * @param ReturnOrderVO
	 * @return
	 */
	public WsPrimitiveVO saveReturnOrder(ReturnOrderVO[] arrVo);
}

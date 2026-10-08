package com.koreab2b.po.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.po.vo.PurchaseOrderVO;

public interface KEP_PURCHASE_ORDER_WSI {

	/**
	 * 발주정보 저장
	 * @param PurchaseOrderVO
	 * @return
	 */
	public WsPrimitiveVO savePurchaseOrder(PurchaseOrderVO[] arrVo);
}

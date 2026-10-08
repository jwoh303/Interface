package com.koreab2b.gr.webservice;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.gr.vo.GoodsReceiveVO;

public interface KEP_GOODS_RECEIVE_WSI {

	/**
	 * 입고정보 저장
	 * @param GoodsReceiveVO
	 * @return
	 */
	public WsPrimitiveVO saveGoodsReceive(GoodsReceiveVO[] arrVo);

}

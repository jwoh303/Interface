package com.koreab2b.ltal.webservice;

import com.koreab2b.ltal.vo.GoodsReceiveVO;
import com.koreab2b.ltal.vo.RequestVO;
import com.koreab2b.ltal.vo.ReturnVO;


public interface WsLtalSetGRInfo {

	public ReturnVO getGrInfo(GoodsReceiveVO[] goodsReceiveVOList);
	
}

package com.koreab2b.ltal.dao;

import com.koreab2b.ltal.vo.GoodsReceiveVO;
import com.koreab2b.ltal.vo.RequestVO;
import com.koreab2b.ltal.vo.ReturnVO;

public interface WsLtalSetGRInfo_Dao {

	public ReturnVO setGrInfo(GoodsReceiveVO[] goodsReceiveVOList) throws Exception;
	
}

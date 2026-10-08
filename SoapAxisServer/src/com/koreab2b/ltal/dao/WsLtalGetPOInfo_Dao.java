package com.koreab2b.ltal.dao;

import java.util.List;

import com.koreab2b.ltal.vo.PurchaseOrderVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetPOInfo_Dao {
	
	public List<PurchaseOrderVO> getPoInfo(RequestVO requestVO) throws Exception;
}

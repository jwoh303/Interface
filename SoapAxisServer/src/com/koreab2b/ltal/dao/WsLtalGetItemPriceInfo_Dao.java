package com.koreab2b.ltal.dao;

import java.util.List;

import com.koreab2b.ltal.vo.ItemPriceVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetItemPriceInfo_Dao {
	
	public List<ItemPriceVO> getItemPriceInfo(RequestVO requestVO) throws Exception;
	
}

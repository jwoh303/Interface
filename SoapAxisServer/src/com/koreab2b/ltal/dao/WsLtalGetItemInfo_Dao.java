package com.koreab2b.ltal.dao;

import java.util.List;

import com.koreab2b.ltal.vo.ItemVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetItemInfo_Dao {
	
	public List<ItemVO> getItemInfo(RequestVO requestVO) throws Exception;
	
}

package com.koreab2b.ltal.service;

import java.util.List;

import com.koreab2b.ltal.vo.ItemPriceVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetItemPriceInfo_PSI {

	public List<ItemPriceVO> getItemPriceInfo(RequestVO requestVO) throws Exception;

	public void saveLog() throws Exception;
	
}

package com.koreab2b.ltal.service;

import java.util.List;

import com.koreab2b.ltal.vo.ItemVO;
import com.koreab2b.ltal.vo.RequestVO;

public interface WsLtalGetItemInfo_PSI {

	public List<ItemVO> getItemInfo(RequestVO requestVO) throws Exception;

	public void saveLog() throws Exception;
	
}

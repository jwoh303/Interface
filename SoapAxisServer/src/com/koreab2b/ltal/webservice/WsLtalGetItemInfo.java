package com.koreab2b.ltal.webservice;

import com.koreab2b.ltal.vo.ItemMasterReturn;
import com.koreab2b.ltal.vo.RequestVO;


public interface WsLtalGetItemInfo {

	public ItemMasterReturn getItemInfo(RequestVO requestVO);
	
}

package com.koreab2b.ltal.webservice;

import com.koreab2b.ltal.vo.ItemPriceReturn;
import com.koreab2b.ltal.vo.RequestVO;


public interface WsLtalGetItemPriceInfo {

	public ItemPriceReturn getItemPriceInfo(RequestVO requestVO);
}
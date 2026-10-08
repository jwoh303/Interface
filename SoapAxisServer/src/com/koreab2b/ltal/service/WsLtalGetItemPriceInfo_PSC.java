package com.koreab2b.ltal.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import com.koreab2b.ltal.dao.WsLtalGetItemPriceInfo_Dao;
import com.koreab2b.ltal.dao.WsLtalGetItemPriceInfo_DaoImpl;
import com.koreab2b.ltal.vo.ItemPriceVO;
import com.koreab2b.ltal.vo.RequestVO;

public class WsLtalGetItemPriceInfo_PSC implements WsLtalGetItemPriceInfo_PSI {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public List<ItemPriceVO> getItemPriceInfo(RequestVO requestVO) throws Exception{
		List<ItemPriceVO> ret = new ArrayList<ItemPriceVO>();
		WsLtalGetItemPriceInfo_Dao dao = new WsLtalGetItemPriceInfo_DaoImpl();
		ret.addAll(dao.getItemPriceInfo(requestVO));
		return ret;
	}
	
	@Override
	public void saveLog() throws Exception {
		Date toDay = new Date();
		log.info(toDay + " - INTERFACE_ID : " + "WsLtalGetItemPriceInfo_PSC");
	}
}
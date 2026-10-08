package com.koreab2b.ltal.webservice;

import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.service.WsLtalGetItemPriceInfo_PSC;
import com.koreab2b.ltal.service.WsLtalGetItemPriceInfo_PSI;
import com.koreab2b.ltal.vo.ItemPriceReturn;
import com.koreab2b.ltal.vo.ItemPriceVO;
import com.koreab2b.ltal.vo.RequestVO;

@WebService(serviceName="WsLtalGetItemPriceInfo")
public class WsLtalGetItemPriceInfoImpl implements WsLtalGetItemPriceInfo {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public ItemPriceReturn getItemPriceInfo(RequestVO requestVO) {
		
		ItemPriceReturn rtn = new ItemPriceReturn();
		
		WsLtalGetItemPriceInfo_PSI service = new WsLtalGetItemPriceInfo_PSC();
		
		try {
			List<ItemPriceVO> ret = service.getItemPriceInfo(requestVO);
			rtn.setItemPriceList(ret);
		} catch (Exception e) {
			log.error("WsLtalGetItemPriceInfo Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLog();} catch (Exception e2) {}
		}
		
		return rtn;
	}
}

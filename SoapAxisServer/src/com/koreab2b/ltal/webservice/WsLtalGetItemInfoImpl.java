package com.koreab2b.ltal.webservice;

import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.service.WsLtalGetItemInfo_PSC;
import com.koreab2b.ltal.service.WsLtalGetItemInfo_PSI;
import com.koreab2b.ltal.vo.ItemMasterReturn;
import com.koreab2b.ltal.vo.ItemVO;
import com.koreab2b.ltal.vo.RequestVO;

@WebService(serviceName="WsLtalGetItemInfo")
public class WsLtalGetItemInfoImpl implements WsLtalGetItemInfo {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public ItemMasterReturn getItemInfo(RequestVO requestVO) {
		
		ItemMasterReturn rtn = new ItemMasterReturn();
		
		WsLtalGetItemInfo_PSI service = new WsLtalGetItemInfo_PSC();
		
		try {
			List<ItemVO> ret = service.getItemInfo(requestVO);
			rtn.setItemMasterList(ret);
		} catch (Exception e) {
			log.error("WsLtalGetItemInfo Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLog();} catch (Exception e2) {}
		}
		
		return rtn;
	}
}
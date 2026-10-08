package com.koreab2b.ltal.webservice;

import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.service.WsLtalGetPOInfo_PSC;
import com.koreab2b.ltal.service.WsLtalGetPOInfo_PSI;
import com.koreab2b.ltal.vo.PurchaseOrderReturn;
import com.koreab2b.ltal.vo.PurchaseOrderVO;
import com.koreab2b.ltal.vo.RequestVO;

@WebService(serviceName="WsLtalGetPOInfo")
public class WsLtalGetPOInfoImpl implements WsLtalGetPOInfo {

	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public PurchaseOrderReturn getPoInfo(RequestVO requestVO) {
		
		PurchaseOrderReturn rtn = new PurchaseOrderReturn();
		
		WsLtalGetPOInfo_PSI service = new WsLtalGetPOInfo_PSC();
		try {
			List<PurchaseOrderVO> ret = service.getPoInfo(requestVO);
			rtn.setPoList(ret);
		} catch (Exception e) {
			log.error("WsLtalGetPOInfo Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			try {service.saveLog();} catch (Exception e2) {}
		}
		
		return rtn;
	}
}

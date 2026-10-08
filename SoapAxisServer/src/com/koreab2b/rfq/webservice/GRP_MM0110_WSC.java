package com.koreab2b.rfq.webservice;

import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.rfq.service.GRP_MM0110_PSC;
import com.koreab2b.rfq.service.GRP_MM0110_PSI;
import com.koreab2b.rfq.vo.RfqVO;

@WebService(serviceName="GRP_MM0110_WSC")
public class GRP_MM0110_WSC implements GRP_MM0110_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());
	
	@Override
	public WsPrimitiveVO saveData(List<RfqVO> obj) throws Exception {
		
		GRP_MM0110_PSI pService	= new GRP_MM0110_PSC();
		WsPrimitiveVO	rtn		= null;
		
		try {
			rtn	= pService.saveData(obj);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			
			rtn	= new WsPrimitiveVO();
			rtn.setWsHeader(new WsResultConstants().WsResult(WS_RESULT.ERROR));
		} finally {
			try {pService.saveLog(obj,rtn);} catch (Exception e2) {} 
		}
		
		return rtn;
	}
}
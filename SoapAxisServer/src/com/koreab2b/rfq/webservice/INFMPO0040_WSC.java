package com.koreab2b.rfq.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.rfq.service.INFMPO0040_PSC;
import com.koreab2b.rfq.service.INFMPO0040_PSI;
import com.koreab2b.rfq.vo.RFQ_HEADER;

@WebService(serviceName="INFMPO0040_WSC")
public class INFMPO0040_WSC implements INFMPO0040_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO updateRFQ_HEADER(RFQ_HEADER obj) throws Exception {
		
		INFMPO0040_PSI	pService	= new INFMPO0040_PSC();
		WsPrimitiveVO	rtn		= null;

		try {
			rtn	= pService.updateRFQ_HEADER(obj);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			
			rtn	= new WsPrimitiveVO();
			rtn.setWsHeader(new WsResultConstants().WsResult(WS_RESULT.ERROR));
		}
		
		return rtn;
	}

}

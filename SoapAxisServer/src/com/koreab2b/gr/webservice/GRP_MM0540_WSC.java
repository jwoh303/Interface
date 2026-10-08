package com.koreab2b.gr.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.gr.service.GRP_MM0540_PSC;
import com.koreab2b.gr.service.GRP_MM0540_PSI;
import com.koreab2b.gr.vo.GrVO;

@WebService(serviceName="GRP_MM0540_WSC")
public class GRP_MM0540_WSC implements GRP_MM0540_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());


	@Override
	public WsPrimitiveVO saveData(GrVO obj) throws Exception {
		
		GRP_MM0540_PSI pService	= new GRP_MM0540_PSC();
		WsPrimitiveVO	rtn		= null;
		
		try {
			rtn	= pService.saveData(obj);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			
			rtn	= new WsPrimitiveVO();
			rtn.setWsHeader(new WsResultConstants().WsResult(WS_RESULT.ERROR));
		} finally {
			try {pService.saveLog(obj, rtn);} catch (Exception e2) {}
		}
		
		return rtn;
	}

}

package com.koreab2b.rfq.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.rfq.service.KEP_CTRL_ITEM_PSC;
import com.koreab2b.rfq.service.KEP_CTRL_ITEM_PSI;
import com.koreab2b.rfq.vo.CtrlItemVO;

@WebService(serviceName="KEP_CTRL_ITEM")
public class KEP_CTRL_ITEM_WSC implements KEP_CTRL_ITEM_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO saveCtrlItem(CtrlItemVO[] arrVo) {
		WsPrimitiveVO	rtn		= null;
		KEP_CTRL_ITEM_PSI service = new KEP_CTRL_ITEM_PSC();
		try {
			rtn	= service.saveCtrlItem(arrVo);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			
			rtn	= new WsPrimitiveVO();
			rtn.setWsHeader(new WsResultConstants().WsResult(WS_RESULT.ERROR));
		} finally {
			try {
				service.saveLog(arrVo, rtn);
			} catch (Exception e2) {}
		}
		return rtn;
	}

}

package com.koreab2b.iv.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.iv.service.KEP_DELIVERY_CONFIRM_PSC;
import com.koreab2b.iv.service.KEP_DELIVERY_CONFIRM_PSI;
import com.koreab2b.iv.vo.DeliveryConfirmVO;

@WebService(serviceName="KEP_DELIVERY_CONFIRM")
public class KEP_DELIVERY_CONFIRM_WSC implements KEP_DELIVERY_CONFIRM_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO saveDeliveryConfirm(DeliveryConfirmVO[] arrVo) {
		
		KEP_DELIVERY_CONFIRM_PSI	pService	= new KEP_DELIVERY_CONFIRM_PSC();
		WsPrimitiveVO	rtn		= null;

		try {
			rtn	= pService.saveDeliveryConfirm(arrVo);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			
			rtn	= new WsPrimitiveVO();
			rtn.setWsHeader(new WsResultConstants().WsResult(WS_RESULT.ERROR));
		} finally {
			try {pService.saveLog(arrVo, rtn);} catch (Exception e2) {}
		}
		
		return rtn;
	}
}

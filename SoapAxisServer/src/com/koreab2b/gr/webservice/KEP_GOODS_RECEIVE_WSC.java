package com.koreab2b.gr.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.gr.service.KEP_GOODS_RECEIVE_PSC;
import com.koreab2b.gr.service.KEP_GOODS_RECEIVE_PSI;
import com.koreab2b.gr.vo.GoodsReceiveVO;

@WebService(serviceName="KEP_GOODS_RECEIVE")
public class KEP_GOODS_RECEIVE_WSC implements KEP_GOODS_RECEIVE_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO saveGoodsReceive(GoodsReceiveVO[] arrVo) {
		
		KEP_GOODS_RECEIVE_PSI	pService	= new KEP_GOODS_RECEIVE_PSC();
		WsPrimitiveVO	rtn		= null;

		try {
			rtn	= pService.saveGoodsReceive(arrVo);
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

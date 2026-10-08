/**
 * 
 */
package com.koreab2b.rfq.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.rfq.service.KEP_ITEM_REQUEST_PSC;
import com.koreab2b.rfq.service.KEP_ITEM_REQUEST_PSI;
import com.koreab2b.rfq.vo.ItemRequestVO;

/**
 * @author jinsoo97
 *
 */
@WebService(serviceName="KEP_ITEM_REQUEST")
public class KEP_ITEM_REQUEST_WSC implements KEP_ITEM_REQUEST_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	/* (non-Javadoc)
	 * @see com.koreab2b.rfq.webservice.KEP_ITEM_REQUEST_WSI#saveItemRequest(com.koreab2b.rfq.vo.ItemRequestVO)
	 */
	@Override
	public WsPrimitiveVO saveItemRequest(ItemRequestVO[] arrVo) {

		KEP_ITEM_REQUEST_PSI	pService	= new KEP_ITEM_REQUEST_PSC();
		WsPrimitiveVO	rtn		= null;

		try {
			rtn	= pService.saveItemRequest(arrVo);
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

/**
 * 
 */
package com.koreab2b.po.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.po.service.KEP_RETURN_ORDER_PSC;
import com.koreab2b.po.service.KEP_RETURN_ORDER_PSI;
import com.koreab2b.po.vo.ReturnOrderVO;

/**
 * @author jinsoo97
 *
 */
@WebService(serviceName="KEP_RETURN_ORDER")
public class KEP_RETURN_ORDER_WSC implements KEP_RETURN_ORDER_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	/* (non-Javadoc)
	 * @see com.koreab2b.po.webservice.KEP_RETURN_ORDER_WSI#saveReturnOrder(com.koreab2b.po.vo.ReturnOrderVO)
	 */
	@Override
	public WsPrimitiveVO saveReturnOrder(ReturnOrderVO[] arrVo) {
		
		KEP_RETURN_ORDER_PSI	pService	= new KEP_RETURN_ORDER_PSC();
		WsPrimitiveVO	rtn		= null;

		try {
			rtn	= pService.saveReturnOrder(arrVo);
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

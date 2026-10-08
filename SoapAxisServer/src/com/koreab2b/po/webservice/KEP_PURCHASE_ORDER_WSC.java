/**
 * 
 */
package com.koreab2b.po.webservice;

import javax.jws.WebService;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.po.service.KEP_PURCHASE_ORDER_PSC;
import com.koreab2b.po.service.KEP_PURCHASE_ORDER_PSI;
import com.koreab2b.po.vo.PurchaseOrderVO;

/**
 * @author jinsoo97
 *
 */
@WebService(serviceName="KEP_PURCHASE_ORDER")
public class KEP_PURCHASE_ORDER_WSC implements KEP_PURCHASE_ORDER_WSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	/* (non-Javadoc)
	 * @see com.koreab2b.po.webservice.KEP_PURCHASE_ORDER_WSI#savePurchaseOrder(com.koreab2b.po.vo.PurchaseOrderVO)
	 */
	@Override
	public WsPrimitiveVO savePurchaseOrder(PurchaseOrderVO[] arrVo) {
		
		KEP_PURCHASE_ORDER_PSI	pService	= new KEP_PURCHASE_ORDER_PSC();
		WsPrimitiveVO	rtn		= null;

		try {
			rtn	= pService.savePurchaseOrder(arrVo);
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

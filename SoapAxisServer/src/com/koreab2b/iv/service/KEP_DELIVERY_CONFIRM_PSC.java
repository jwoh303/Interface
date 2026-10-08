package com.koreab2b.iv.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.iv.dao.KEP_DELIVERY_CONFIRM_Dao;
import com.koreab2b.iv.dao.KEP_DELIVERY_CONFIRM_DaoImpl;
import com.koreab2b.iv.vo.DeliveryConfirmVO;

public class KEP_DELIVERY_CONFIRM_PSC implements KEP_DELIVERY_CONFIRM_PSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO saveDeliveryConfirm(DeliveryConfirmVO[] arrVo) throws Exception {
		WsPrimitiveVO rtn	= new WsPrimitiveVO();
		WsHeaderVO wsHeader	= null;
		KEP_DELIVERY_CONFIRM_Dao dao	= new KEP_DELIVERY_CONFIRM_DaoImpl();
		
		try {
			dao.getSqlMapClient().startTransaction();
			for(int i = 0 ; i < arrVo.length ; i++) {
				dao.saveData(arrVo[i]);	
			}
			dao.getSqlMapClient().commitTransaction();

			wsHeader	= new WsResultConstants().WsResult(WS_RESULT.OK);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			wsHeader	= new WsResultConstants().WsResult(WS_RESULT.ERROR);
			rtn.setReturnString(e.getMessage());
		} finally {
			try {dao.getSqlMapClient().endTransaction();} catch (Exception e2) {e2.printStackTrace();}
		}

		rtn.setWsHeader(wsHeader);
		return rtn;
	}

	@Override
	public void saveLog(DeliveryConfirmVO[] arrVo, WsPrimitiveVO rtn) throws Exception {
		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveDeliveryConfirm>\n");
			
			for (int i = 0 ; i < arrVo.length ; i++) {
				xml.append(arrVo[i].getXml());	
			}
			
			xml.append("    </web:saveDeliveryConfirm>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("KEP_DELIVERY_CONFIRM");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getWsHeader().getzResultCd());
			logVo.setERROR_MSG(rtn.getReturnString());

			dao.saveLog(logVo);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

}

package com.koreab2b.po.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsPrimitiveVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.common.dao.CommonCHINADao;
import com.koreab2b.common.dao.CommonCHINADaoImpl;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.po.dao.GRP_MM0660_CHINA_Dao;
import com.koreab2b.po.dao.GRP_MM0660_CHINA_DaoImpl;
import com.koreab2b.po.dao.GRP_MM0660_Dao;
import com.koreab2b.po.dao.GRP_MM0660_DaoImpl;
import com.koreab2b.po.vo.EKET;
import com.koreab2b.po.vo.EKPO;
import com.koreab2b.po.vo.PoVO;
import com.koreab2b.rfq.vo.RfqVO;
import com.koreab2b.util.CommonUtil;

public class GRP_MM0660_PSC implements GRP_MM0660_PSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO saveData(PoVO obj) throws Exception {
		WsPrimitiveVO rtn	= new WsPrimitiveVO();
		WsHeaderVO wsHeader	= null;
		String resultStr	= "";
		int hdCnt	= 0;
		int dtCnt	= 1;
		String HD_SEQ	= "";
		String EBELN	= "";
		Map<String, String>	pMap	= new HashMap<String,String>();
		Map<String, String>	pMap2	= new HashMap<String,String>();

		GRP_MM0660_Dao dao	= new GRP_MM0660_DaoImpl();
		GRP_MM0660_CHINA_Dao daoChina	= new GRP_MM0660_CHINA_DaoImpl();
		
		try {
			dao.getSqlMapClient().startTransaction();
			daoChina.getSqlMapClient().startTransaction();
			
			if ("5111:5112:5110:".indexOf(obj.getPoDetail().get(0).getWERKS()) > -1) {
				hdCnt	= daoChina.savePoHeader(obj.getPoHeader());

				EBELN	= obj.getPoHeader().getEBELN();

				pMap.put("EBELN", EBELN);
				HD_SEQ	= Integer.toString(daoChina.selectEKKOSeq(pMap));

				pMap2.put("EBELN", EBELN);		// EBELN이 동일한 데이터 중에서 제일 큰 KEP_SEQ값을 가져온다.
				pMap2.put("HD_SEQ", HD_SEQ);	// EBELN이 동일한 데이터 중에서 제일 큰 KEP_SEQ값을 가져온다.
				
				for(EKPO tmp : obj.getPoDetail()) {
					dtCnt	= dtCnt * daoChina.savePoDetail(tmp);
				}
				
				daoChina.updateEKPOHdSeq(pMap2);	/* HD_SEQ UPDATE */
				
				if(obj.getPoDelyPlan() != null && !obj.getPoDelyPlan().isEmpty()) {
					for(EKET tmp : obj.getPoDelyPlan()) {
						daoChina.savePoDelyPlan(tmp);
					}
				}
				
				daoChina.updateEKETHdSeq(pMap2);	/* HD_SEQ UPDATE */
			} else {
				hdCnt	= dao.savePoHeader(obj.getPoHeader());

				EBELN	= obj.getPoHeader().getEBELN();

				pMap.put("EBELN", EBELN);
				HD_SEQ	= Integer.toString(dao.selectEKKOSeq(pMap));

				pMap2.put("EBELN", EBELN);		// EBELN이 동일한 데이터 중에서 제일 큰 KEP_SEQ값을 가져온다.
				pMap2.put("HD_SEQ", HD_SEQ);	// EBELN이 동일한 데이터 중에서 제일 큰 KEP_SEQ값을 가져온다.
				
				for(EKPO tmp : obj.getPoDetail()) {
					dtCnt	= dtCnt * dao.savePoDetail(tmp);
				}
				
				dao.updateEKPOHdSeq(pMap2);	/* HD_SEQ UPDATE */
				
				if(obj.getPoDelyPlan() != null && !obj.getPoDelyPlan().isEmpty()) {
					for(EKET tmp : obj.getPoDelyPlan()) {
						dao.savePoDelyPlan(tmp);
					}
				}
				
				dao.updateEKETHdSeq(pMap2);	/* HD_SEQ UPDATE */
			}
			
			if(hdCnt == 0) {
				resultStr	+= "헤더 정보 처리중 오류가 발생했습니다.";
			}
			
			if(dtCnt == 0) {
				resultStr	+= "품목 정보 처리중 오류가 발생했습니다.";
			}
			
			if(hdCnt != 0 && dtCnt != 0) {
				wsHeader	= new WsResultConstants().WsResult(WS_RESULT.OK);
				dao.getSqlMapClient().commitTransaction();
				daoChina.getSqlMapClient().commitTransaction();
			} else {
				throw new Exception(resultStr);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			rtn.setReturnString(e.getMessage());
			wsHeader	= new WsResultConstants().WsResult(WS_RESULT.ERROR);
		} finally {
			try {
				dao.getSqlMapClient().endTransaction();
				daoChina.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
				log.error(e2.getMessage());
			}
		}
		
		rtn.setWsHeader(wsHeader);
		
		return rtn;
	}

	@Override
	public void saveLog(PoVO obj, WsPrimitiveVO rtn) throws Exception {
		CommonDao dao	= new CommonDaoImpl();
		CommonCHINADao cDao	= new CommonCHINADaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.rfq.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveData>\n");
			
			xml.append(obj.getXml());
			
			xml.append("    </web:saveData>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("GRP_MM0660");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getWsHeader().getzResultCd());
			logVo.setERROR_MSG(rtn.getReturnString());

			if ("5111:5112:5110:".indexOf(obj.getPoDetail().get(0).getWERKS()) > -1) {
				cDao.getSqlMapClient().startTransaction();
				cDao.saveLog(logVo);
				cDao.getSqlMapClient().commitTransaction();
			} else {
				dao.getSqlMapClient().startTransaction();
				dao.saveLog(logVo);
				dao.getSqlMapClient().commitTransaction();
			}
			
		} catch (Exception e) {
			System.out.println(" MM0660 - WERKS : " + obj.getPoDetail().get(0).getWERKS() );
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				dao.getSqlMapClient().endTransaction();
				cDao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

}

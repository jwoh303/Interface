package com.koreab2b.gr.service;

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
import com.koreab2b.gr.dao.GRP_MM0540_CHINA_Dao;
import com.koreab2b.gr.dao.GRP_MM0540_CHINA_DaoImpl;
import com.koreab2b.gr.dao.GRP_MM0540_Dao;
import com.koreab2b.gr.dao.GRP_MM0540_DaoImpl;
import com.koreab2b.gr.vo.GrVO;
import com.koreab2b.gr.vo.MSEG;
import com.koreab2b.util.CommonUtil;

public class GRP_MM0540_PSC implements GRP_MM0540_PSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	@Override
	public WsPrimitiveVO saveData(GrVO obj) throws Exception {
		WsPrimitiveVO rtn	= new WsPrimitiveVO();
		WsHeaderVO wsHeader	= null;
		String resultStr	= "";
		
		int hdCnt	= 0;
		int dtCnt	= 1;
		
		String MBLNR	= "";
		String MJAHR	= "";
		String HD_SEQ	= "";
		
		Map<String,String> pMap		= new HashMap<String,String>();
		Map<String,String> pMap2	= new HashMap<String,String>();

		GRP_MM0540_Dao dao	= new GRP_MM0540_DaoImpl();
		GRP_MM0540_CHINA_Dao daoChina	= new GRP_MM0540_CHINA_DaoImpl();
				
		try {
			dao.getSqlMapClient().startTransaction();
			daoChina.getSqlMapClient().startTransaction();

			if ("5111:5112:5110:".indexOf( obj.getGrDetail().get(0).getWERKS() ) > -1) {
				hdCnt	= daoChina.saveGrHeader(obj.getGrHeader());
				
				MBLNR	= obj.getGrHeader().getMBLNR();
				MJAHR	= obj.getGrHeader().getMJAHR();

				pMap.put("MBLNR", MBLNR);
				pMap.put("MJAHR", MJAHR);
				HD_SEQ	= Integer.toString(daoChina.selectMKPFSeq(pMap));
				
				pMap2.put("MBLNR", MBLNR);
				pMap2.put("MJAHR", MJAHR);
				pMap2.put("HD_SEQ", HD_SEQ);
				
				for(MSEG tmp : obj.getGrDetail()) {
					dtCnt	 = dtCnt * daoChina.saveGrDetail(tmp);
				}
				
				daoChina.updateMSEGHdSeq(pMap2);
			} else {
				hdCnt	= dao.saveGrHeader(obj.getGrHeader());
				
				MBLNR	= obj.getGrHeader().getMBLNR();
				MJAHR	= obj.getGrHeader().getMJAHR();

				pMap.put("MBLNR", MBLNR);
				pMap.put("MJAHR", MJAHR);
				HD_SEQ	= Integer.toString(dao.selectMKPFSeq(pMap));
				
				pMap2.put("MBLNR", MBLNR);
				pMap2.put("MJAHR", MJAHR);
				pMap2.put("HD_SEQ", HD_SEQ);
				
				for(MSEG tmp : obj.getGrDetail()) {
					dtCnt	 = dtCnt * dao.saveGrDetail(tmp);
				}
				
				dao.updateMSEGHdSeq(pMap2);
			}
			
			if(hdCnt == 0) {
				resultStr	+= "헤더 정보 처리중 오류가 발생했습니다.";
			}
			
			if(dtCnt == 0) {
				resultStr	+= "상세 정보 처리중 오류가 발생했습니다.";
			}
			
			if (hdCnt != 0 && dtCnt != 0) {
				wsHeader	= new WsResultConstants().WsResult(WS_RESULT.OK);
				dao.getSqlMapClient().commitTransaction();
				daoChina.getSqlMapClient().commitTransaction();
			} else {
				throw new Exception(resultStr);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			resultStr = e.getMessage();
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
		
		rtn.setReturnString(resultStr);
		rtn.setWsHeader(wsHeader);
		
		return rtn;
	}

	@Override
	public void saveLog(GrVO obj, WsPrimitiveVO rtn) throws Exception {
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
			
			logVo.setINTERFACE_ID("GRP_MM0540");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getWsHeader().getzResultCd());
			logVo.setERROR_MSG(rtn.getReturnString());
			
			if ("5111:5112:5110:".indexOf( obj.getGrDetail().get(0).getWERKS() ) > -1) {
				cDao.getSqlMapClient().startTransaction();
				cDao.saveLog(logVo);
				cDao.getSqlMapClient().commitTransaction();
			} else {
				dao.getSqlMapClient().startTransaction();
				dao.saveLog(logVo);
				dao.getSqlMapClient().commitTransaction();
			}
			
		} catch (Exception e) {
			System.out.println(" MM0540 - WERKS : " + obj.getGrDetail().get(0).getWERKS() );
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

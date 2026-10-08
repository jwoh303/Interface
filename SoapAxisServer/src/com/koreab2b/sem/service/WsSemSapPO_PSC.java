package com.koreab2b.sem.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.dao.CommonCHINADao;
import com.koreab2b.common.dao.CommonCHINADaoImpl;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.sem.dao.WsSemSapPO_Dao;
import com.koreab2b.sem.dao.WsSemSapPO_DaoImpl;
import com.koreab2b.sem.vo.PcsOrdrDtlVO;
import com.koreab2b.sem.vo.PcsOrdrMasVO;
import com.koreab2b.sem.vo.ReturnVO;
import com.koreab2b.util.CommonUtil;

public class WsSemSapPO_PSC implements WsSemSapPO_PSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	private String gubun = "";
	
	public WsSemSapPO_PSC(String _gubun) {
		gubun = _gubun;
	}
	
	@Override
	public void pcsOrdrSnd(PcsOrdrMasVO pcsOrdrMasVO,
			PcsOrdrDtlVO[] pcsOrdrDtlVO) throws Exception {
		WsSemSapPO_Dao dao	= new WsSemSapPO_DaoImpl(gubun);
		dao.pcsOrdrSnd(pcsOrdrMasVO, pcsOrdrDtlVO);
	}

	@Override
	public void saveLog(PcsOrdrMasVO pcsOrdrMasVO, PcsOrdrDtlVO[] pcsOrdrDtlVO, ReturnVO rtn) {
		CommonDao dao	= new CommonDaoImpl();
		CommonCHINADao dao2 = new CommonCHINADaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.sem.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveData>\n");
			
			xml.append(pcsOrdrMasVO.getXml());
			
			for(int i = 0 ; i < pcsOrdrDtlVO.length ; i++) {
				xml.append(pcsOrdrDtlVO[i].getXml());	
			}
			
			xml.append("    </web:saveData>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			if ("KR".equals(this.gubun)) {
				logVo.setINTERFACE_ID("WsSemSapPO");	
			} else {
				logVo.setINTERFACE_ID("WsSemCNSapPO");
			}
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG(rtn.getResult());
			logVo.setERROR_MSG(rtn.getErr_msg());

			if ("KR".equals(this.gubun)) {
				dao.getSqlMapClient().startTransaction();
				dao.saveLog(logVo);
				dao.getSqlMapClient().commitTransaction();	
			} else {
				dao2.getSqlMapClient().startTransaction();
				dao2.saveLog(logVo);
				dao2.getSqlMapClient().commitTransaction();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
			try {
				dao2.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
}

package com.koreab2b.sem.service;

import org.apache.log4j.Logger;

import com.koreab2b.common.dao.CommonCHINADao;
import com.koreab2b.common.dao.CommonCHINADaoImpl;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.sem.dao.WsSemMroMall_Dao;
import com.koreab2b.sem.dao.WsSemMroMall_DaoImpl;
import com.koreab2b.sem.vo.ItmMapInfoVO;
import com.koreab2b.sem.vo.NewItmReqVO;
import com.koreab2b.sem.vo.RequotReqVO;
import com.koreab2b.sem.vo.ReturnVO;
import com.koreab2b.util.CommonUtil;

public class WsSemMroMall_PSC implements WsSemMroMall_PSI {
	
	private Logger log	= Logger.getLogger(this.getClass());

	private String gubun = "";
	
	public WsSemMroMall_PSC(String _gubun) {
		gubun = _gubun;
	}
	
	@Override
	public ReturnVO newItmReq(NewItmReqVO[] newItmReqVO) throws Exception {
		ReturnVO rtn	= null;
		WsSemMroMall_Dao dao	= new WsSemMroMall_DaoImpl(gubun);
		rtn	= dao.newItmReq(newItmReqVO);
		return rtn;
	}

	@Override
	public ReturnVO requotReq(RequotReqVO[] requotReqVO) throws Exception {
		ReturnVO rtn	= null;
		WsSemMroMall_Dao dao	= new WsSemMroMall_DaoImpl(gubun);
		rtn	= dao.requotReq(requotReqVO);
		return rtn;
	}

	@Override
	public ReturnVO itmMapInfoReg(ItmMapInfoVO[] itmMapInfoVO) throws Exception {
		ReturnVO rtn	= null;
		WsSemMroMall_Dao dao	= new WsSemMroMall_DaoImpl(gubun);
		rtn	= dao.itmMapInfoReg(itmMapInfoVO);
		return rtn;
	}
	
	@Override
	public void saveLogNewItmReq(NewItmReqVO[] newItmReqVO, ReturnVO rtn) {
		CommonDao dao	= new CommonDaoImpl();
		CommonCHINADao dao2	= new CommonCHINADaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.sem.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveData>\n");
			
			for(int i = 0 ; i < newItmReqVO.length ; i++) {
				xml.append(newItmReqVO[i].getXml());	
			}
			
			xml.append("    </web:saveData>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			if ("KR".equals(this.gubun)) {
				logVo.setINTERFACE_ID("newItmReq");	
			} else {
				logVo.setINTERFACE_ID("newItmCNReq");
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
	
	@Override
	public void saveLogRequotReq(RequotReqVO[] requotReqVO, ReturnVO rtn) {
		CommonDao dao	= new CommonDaoImpl();
		CommonCHINADao dao2	= new CommonCHINADaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.sem.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveData>\n");
			
			for(int i = 0 ; i < requotReqVO.length ; i++) {
				xml.append(requotReqVO[i].getXml());	
			}
			
			xml.append("    </web:saveData>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");

			if ("KR".equals(this.gubun)) {
				logVo.setINTERFACE_ID("requotReq");	
			} else {
				logVo.setINTERFACE_ID("requotCNReq");
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
	
	@Override
	public void saveLogItmMapInfoReg(ItmMapInfoVO[] itmMapInfoVO, ReturnVO rtn) {
		CommonDao dao	= new CommonDaoImpl();
		CommonCHINADao dao2	= new CommonCHINADaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.sem.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:saveData>\n");
			
			for(int i = 0 ; i < itmMapInfoVO.length ; i++) {
				xml.append(itmMapInfoVO[i].getXml());	
			}
			
			xml.append("    </web:saveData>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");

			if ("KR".equals(this.gubun)) {
				logVo.setINTERFACE_ID("itmMapInfoReg");	
			} else {
				logVo.setINTERFACE_ID("itmMapInfoCNReg");
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
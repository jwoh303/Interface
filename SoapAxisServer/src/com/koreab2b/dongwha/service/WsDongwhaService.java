
package com.koreab2b.dongwha.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.koreab2b.common.CommonUtil;
import com.koreab2b.common.dao.CommonDao;
import com.koreab2b.common.dao.CommonDaoImpl;
import com.koreab2b.common.vo.LogVo;
import com.koreab2b.dongwha.dao.WsDongWhaDao;
import com.koreab2b.dongwha.vo.AppSendCallVO;
import com.koreab2b.dongwha.vo.AppStatusVO;
import com.koreab2b.dongwha.vo.AssetVO;
import com.koreab2b.dongwha.vo.GrVO;
import com.koreab2b.dongwha.vo.ItemVO;
import com.koreab2b.dongwha.vo.CostCenterVO;
import com.koreab2b.dongwha.vo.PoVO;
import com.koreab2b.dongwha.vo.UserVO;

public class WsDongwhaService {
	private Logger log	= Logger.getLogger(this.getClass());
	WsDongWhaDao dao = new WsDongWhaDao();

	public void setPoList(List<PoVO> objs) throws Exception{
		
		for(PoVO i : objs) {
			
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			
			dao.insertPoList(tMaps);
		}
	}
	
	public void setGrList(List<GrVO> objs) throws Exception{
		
		for(GrVO i : objs) {
			
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			
			dao.insertGrList(tMaps);
		}
	}
	public void setItemList(List<ItemVO> objs) throws Exception{
		
		for(ItemVO i : objs) {
			
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			
			dao.insertItemList(tMaps);
		}
	}
	public void setAppSendCallList(List<AppSendCallVO> objs) throws Exception{
		
		for(AppSendCallVO i : objs) {
			
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			
			dao.insertAppSendCallList(tMaps);
		}
	}
	public void setAppStatusList(List<AppStatusVO> objs) throws Exception{
		
		for(AppStatusVO i : objs) {
			
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			
			dao.insertAppStatusList(tMaps);
		}
	}
	public void setCostCenterList(List<CostCenterVO> objs) throws Exception{
		
		for(CostCenterVO i : objs) {
			
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			
			dao.insertCostCenterList(tMaps);
		}
	}
	public void setAssetList(List<AssetVO> objs) throws Exception{
	
		for(AssetVO i : objs) {
		
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			
			dao.insertAssetList(tMaps);
		}
		
	}
	public void setUserList(List<UserVO> objs) throws Exception{
		
		
		for(UserVO i : objs) {
		
			Map<String,Object> tMaps = CommonUtil.convertVoToMap(i);
			dao.deleteUser(tMaps);
			dao.insertUserList(tMaps);
		}
	}
	public void setSavePoLog(List<PoVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setPo>\n");

			for(PoVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setPo>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_PO");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_PO");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	public void setSaveUserLog(List<UserVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setAppStatus>\n");

			for(UserVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setAppStatus>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_USER");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_USER");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	public void setSaveItemLog(List<ItemVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setAppStatus>\n");

			for(ItemVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setAppStatus>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_ITEM");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_ITEM");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	public void setSaveGrLog(List<GrVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setAppStatus>\n");

			for(GrVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setAppStatus>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_GR");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_GR");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	public void setSaveCostCenterLog(List<CostCenterVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setAppStatus>\n");

			for(CostCenterVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setAppStatus>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_CENTER");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_CENTER");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	public void setSaveAssetLog(List<AssetVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setAppStatus>\n");

			for(AssetVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setAppStatus>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_ASSET");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_ASSET");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	public void setSaveAppSendCallLog(List<AppSendCallVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setAppStatus>\n");

			for(AppSendCallVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setAppStatus>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_APPCALL");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_APPCALL");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	public void setSaveAppLog(List<AppStatusVO> objs) {

		CommonDao dao	= new CommonDaoImpl();
		StringBuffer xml	= new StringBuffer();
		LogVo logVo	= new LogVo();
		
		try {
			
			xml.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.dongwha.koreab2b.com/\">\n");
			xml.append("  <soapenv:Header/>\n");
			xml.append("  <soapenv:Body>\n");
			xml.append("    <web:setAppStatus>\n");

			for(AppStatusVO i : objs) {
				xml.append(i.getXml());
			}
			
			xml.append("    </web:setAppStatus>\n");
			xml.append("  </soapenv:Body>\n");
			xml.append("</soapenv:Envelope>\n");
			
			logVo.setINTERFACE_ID("DWHA_APP");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("Y");
			logVo.setERROR_MSG("SUCCESS");


		} catch (Exception e) {
			e.printStackTrace();
			logVo.setINTERFACE_ID("DWHA_APP");
			logVo.setCONTENTS(xml.toString());
			logVo.setFLAG("E");
			logVo.setERROR_MSG(CommonUtil.printStackTraceToString(e));

			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			
			try {
				dao.saveLog(logVo);
				
				dao.getSqlMapClient().endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
		
}

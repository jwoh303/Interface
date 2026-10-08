package com.koreab2b.mro.buyer.mpso.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.codec.binary.Base64;
import org.codehaus.jackson.map.ObjectMapper;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqUnitpriceAgrmntNegoReqDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.rfc.coway.controller.SapManager;
import com.koreab2b.mro.rfc.coway.controller.SapManager.SapRfcFunction;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.lottechilsung.InterfaceSoapProxy;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.ext.DestinationDataProvider;

@Repository("buyerMpSoExternalDao")
@Transactional
public class BuyerMpSoExternalDaoImpl implements BuyerMpSoExternalDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoExternalDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	@Autowired	
	private BuyerMpRqUnitpriceAgrmntNegoReqDao uyerMpRqUnitpriceAgrmntNegoReqDao;
	
	@Override
	public List<Map<String, String>> selectKwangdongGWList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectKwangdongGWList", pMap);
	}

	@SuppressWarnings("deprecation")
	@Override
	public String processKwangdongApproval(Map<String, String> pMap) {
		
		// 1:기안완료, 2:최종결재완료, 9:기안부서반송, 11:수신부서기안완료, 12:수신부서최종결재완료, 19:수신부서반송
		
		String msg	= "";
		String status	= pMap.get("status");
		String tDocnum	= pMap.get("docnum");
		String docnum	= "";
		String comCode	= "";
		String pxNo	= "";
		
		
		int rtnCnt	= 0;

		try {
			tDocnum	= tDocnum.replaceAll(" ", "+");
			docnum = new String(Base64.decodeBase64(tDocnum), "UTF-8");
			pMap.put("docnum", docnum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if ("12".equals(status)) {
			// 승인 : 2:최종결재완료, 12:수신부서최종결재완료
			
			try {
				comCode	=	pMap.get("st_buyer");
				pxNo	= buyerMpSoOrderInfoDao.getOrderNo(comCode, "PX");
				pMap.put("st_ref_no",pxNo);
				rtnCnt = sqlSessionTemplate.insert("buyer.mpso.updateApprovalConfirm", pMap);
				if (rtnCnt < 1) {
					throw new Exception("발주생성 오류.!!");
				}
				
				pMap.put("COMPANY", comCode);
				pMap.put("V_REF_NO", pxNo);
				
	      		rtnCnt = sqlSessionTemplate.insert("commonApproval.MAIL_GJSUBMIT_TRG11", pMap);
				if (rtnCnt < 1) {
					throw new Exception("발주생성 오류.!!");
				}
			} catch (Exception e) {
				rtnCnt	= -1;
			}
			
		} else if ("09".equals(status) || "19".equals(status)) {
			// 반려 : 9:기안부서반송, 19:수신부서반송

			pMap.put("st_app_flag","PR");
			rtnCnt = sqlSessionTemplate.insert("buyer.mpso.updateAppStatus", pMap);
		} else if ("02".equals(status) || "01".equals(status) || "11".equals(status)) {
			// 기안 : 1:기안완료, 11:수신부서기안완료
			
			pMap.put("st_app_flag","PS");
			rtnCnt = sqlSessionTemplate.insert("buyer.mpso.updateAppStatus", pMap);
		}
		
		if (rtnCnt > 0) {
			msg	= "0:OK";
		} else {
			msg	= "-1:Error";
		}

		return msg;
	}
	
	@Override
	public String saveMisumiCheckOut(Map<String, String> pMap) {
		String rtn 	= "";
		try {
			sqlSessionTemplate.update("buyer.mpso.mergeMisumiCheckOut", pMap);
			rtn	= "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
			rtn	= "ERROR";
		}
		
		return rtn;
	}

	@Override
	public String saveMisumiBuyerCheckOut(List<Map<String, String>> pMaps) {
		String _rtnMsg 	= "";
		String docNo	= "";
		try {
			// get doc_no RE
			docNo	= "";
			docNo = masterMpRqBuyerReqDao.nextVal(pMaps.get(0).get("st_buyer"), "RE");
			_rtnMsg = docNo + " 견적번호가 임시저장되었습니다.";
			for(Map<String, String> pMap : pMaps) {
				pMap.put("QUOTATION_NO", docNo);
				
				java.util.Iterator<String> it	= pMap.keySet().iterator();
				
				String mapStr	= "";
				while(it.hasNext()) {
					String key = (String)it.next();
					if ("".equals(mapStr)) {
						mapStr = key + "=["+pMap.get(key)+"]";
					} else {
						mapStr = mapStr + ", " + key + "=["+pMap.get(key)+"]";
					}
				}
				
				LOGGER.debug(mapStr);
				
				sqlSessionTemplate.update("buyer.mp.rq.insertQuotationReqStnd", pMap);
			}
			
			_rtnMsg = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
			_rtnMsg	= "ERROR";
		}
		
		return _rtnMsg;
	}

	@Override
	public Map<String, String> selectUserInfo(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("buyer.mpso.selectBuyerRfqUserInfo", pMap);
	}

	@Override
	public void saveGRCompareEvent(Map<String, String> pMap) {
		sqlSessionTemplate.update("buyer.mpso.mergeGRCompareEvent", pMap);
	}

	@Override
	public void saveYPZincCartEvent(Map<String, String> pMap) {
		List<Map<String, String>> rtnList	= null;
		SapManager ypSap = null;
        
		try {
			LOGGER.error("ypRfcPrCreateCall Check : ", pMap.get("st_server_mode") + " / " + pMap.get("st_buyer") );
			List<Map<String, String>> jco_prop = sqlSessionTemplate.selectList("common.mpif.selectRfcYPProperties", pMap);
			LOGGER.error("ypRfcPrCreateCall Check : ", jco_prop.get(0).get("JCO_CLIENT"));

			// 연결 생성
			ypSap = new SapManager("YP").newSapManagerBinder()
					.set(DestinationDataProvider.JCO_CLIENT, jco_prop.get(0).get("JCO_CLIENT"))
					.set(DestinationDataProvider.JCO_USER, jco_prop.get(0).get("JCO_USER"))
					.set(DestinationDataProvider.JCO_PASSWD, jco_prop.get(0).get("JCO_PASSWD"))
					.set(DestinationDataProvider.JCO_LANG, jco_prop.get(0).get("JCO_LANG"))
					.set(DestinationDataProvider.JCO_ASHOST, jco_prop.get(0).get("JCO_ASHOST"))
					.set(DestinationDataProvider.JCO_SYSNR, "00")
					.bind(true);
	        
			String functionName	= "ZMRO_REQ_SEND";
			SapRfcFunction rfc = ypSap.getRfcFunction(functionName);

	        JCoParameterList input = rfc.function.getImportParameterList();
	        input.setValue("I_REQNO",	pMap.get("st_reqno"));
	        input.setValue("I_ZGWID",	pMap.get("st_zgwid"));
	        
	        rfc.execute();
	        
			JCoTable output_table = rfc.function.getTableParameterList().getTable("T_LIST");
			rtnList = receiveTable(output_table);
			
			for(Map<String, String> iMap : rtnList ) {
				sqlSessionTemplate.insert("buyer.mpso.insertYPCartInfo", iMap);
			}
            
		} catch (Exception e) {
			LOGGER.error("ypRfcPrCreateCall ERROR : ", e);
			throw new RuntimeException(e.getMessage());
		}
	}
	
	public List<Map<String, String>> receiveTable(JCoTable tables) {

        int numberOfRows = tables.getNumRows();
        List<Map<String, String>> ret = new ArrayList<Map<String, String>>();
        
        try {
	        if (numberOfRows > 0) {
	        	do {
	        		Map<String, String> dataMap = new HashMap<String, String>();

					for (JCoFieldIterator e = tables.getFieldIterator(); e.hasNextField();) {
	        			JCoField field = e.nextField();

	        			dataMap.put(field.getName(), field.getString());

	        			LOGGER.debug("filedName : "+ field.getName() +", filedValue : "+field.getString());

		            }
	        		ret.add(dataMap);
	        	}
	        	while (tables.nextRow());
	        } else {
	        	LOGGER.debug( "Return:No results found!");
	        }
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error("buyerMpSoExternalDao receiveTable Error : " + e.getMessage());
		}

        return ret;
    }
	
	@Override
	public Map<String, String> selectLoginInfoForSGS(Map<String, String> pMap) {

		List<Map<String, String>> userInfo = new ArrayList<Map<String,String>>();
		Map<String, String> retMap = new HashMap<String, String>();
		String rtnStr = null;
		
		String xmlName = pMap.get("contactName");
		String contactEmail = pMap.get("contactEmail");
		String browserFormPosURL = pMap.get("browserFormPosURL");
		String buyerCookie = pMap.get("buyerCookie");
		
		for (Map.Entry<String,String> entry : pMap.entrySet()) {
			LOGGER.debug("pMap key : "+entry.getKey() + " , pMap value : "+ entry.getValue());
		}
		
		try {
			userInfo = sqlSessionTemplate.selectList("selectSgsUserInfo", pMap);
			
			if(userInfo.size() != 0 && userInfo.get(0).get("USER_ID") != null){
				
				retMap.put("USER_ID",userInfo.get(0).get("USER_ID"));
				retMap.put("COM_CODE",userInfo.get(0).get("COM_CODE"));
				retMap.put("LEGACY_USER_ID",userInfo.get(0).get("LEGACY_USER_ID"));
				retMap.put("URL", browserFormPosURL);
				retMap.put("BUYERCOOKIE", buyerCookie);
				
				String[] params = browserFormPosURL.split("\\?")[1].split("&");
				
				String OAFunc = "";
				for( String p : params) { if (p.indexOf("OAFunc") > -1) {OAFunc = p.split("=")[1]; break;} }
				String OAHP = "";
				for( String p : params) { if (p.indexOf("OAHP") > -1) {OAHP = p.split("=")[1]; break;} }
				String OASF = "";
				for( String p : params) { if (p.indexOf("OASF") > -1) {OASF = p.split("=")[1]; break;} }
				String transactionid = "";
				for( String p : params) { if (p.indexOf("transactionid") > -1) {transactionid = p.split("=")[1]; break;} }
				String operationkey = "";
				for( String p : params) { if (p.indexOf("operationkey") > -1) {operationkey = p.split("=")[1]; break;} }
				
				retMap.put("OAFUNC", OAFunc);
				retMap.put("OAHP", OAHP);
				retMap.put("OASF", OASF);
				retMap.put("TRANSACTIONID", transactionid);
				retMap.put("OPERATIONKEY", operationkey);
				
				if ("Y".equals(userInfo.get(0).get("PASS_CHG_FLAG")))
					sqlSessionTemplate.update("updatePassChangeDateSgsUser",retMap);
				sqlSessionTemplate.update("insertPoURLForSgsUser", retMap);
			}
			
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return retMap;
	}
	
	@Override
	public Map<String, String> selectLoginInfoForFAGB(Map<String, String> pMap) {

		List<Map<String, String>> userInfo = new ArrayList<Map<String,String>>();
		Map<String, String> retMap = new HashMap<String, String>();
		String rtnStr = null;
		
		String xmlName = pMap.get("contactName");
		String contactEmail = pMap.get("contactEmail");
		String browserFormPosURL = pMap.get("browserFormPosURL");
		String buyerCookie = pMap.get("buyerCookie");
		
		for (Map.Entry<String,String> entry : pMap.entrySet()) {
			LOGGER.debug("pMap key : "+entry.getKey() + " , pMap value : "+ entry.getValue());
		}
		
		try {
			userInfo = sqlSessionTemplate.selectList("selectFagbUserInfo", pMap);
			
			if(userInfo.size() != 0 && userInfo.get(0).get("USER_ID") != null){
				
				retMap.put("USER_ID",userInfo.get(0).get("USER_ID"));
				retMap.put("COM_CODE",userInfo.get(0).get("COM_CODE"));
				retMap.put("LEGACY_USER_ID",userInfo.get(0).get("LEGACY_USER_ID"));
				retMap.put("URL", browserFormPosURL);
				retMap.put("BUYERCOOKIE", buyerCookie);
				
				String[] params = browserFormPosURL.split("\\?")[1].split("&");
				
				String id = "";
				for( String p : params) { if (p.indexOf("id") > -1) {id = p.split("=")[1]; break;} }
				
				retMap.put("id", id);
				
				if ("Y".equals(userInfo.get(0).get("PASS_CHG_FLAG"))) {
					sqlSessionTemplate.update("updatePassChangeDateFagbUser",retMap);
				}					
				sqlSessionTemplate.update("insertPoURLForFagbUser", retMap);
			}
			
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return retMap;
	}
	
	@Override
	public Map<String, String> selectLoginInfoForPMK(Map<String, String> pMap) {
		List<Map<String, String>> userInfo = new ArrayList<Map<String,String>>();
		Map<String, String> retMap = new HashMap<String, String>();
		String rtnStr = null;
		
		String xmlName = pMap.get("contactName");
		String contactEmail = pMap.get("contactEmail");
		String browserFormPosURL = pMap.get("browserFormPosURL");
		String buyerCookie = pMap.get("buyerCookie");
		
		for (Map.Entry<String,String> entry : pMap.entrySet()) {
			LOGGER.debug("pMap key : "+entry.getKey() + " , pMap value : "+ entry.getValue());
		}
		
		try {
			userInfo = sqlSessionTemplate.selectList("selectPMKUserInfo", pMap);
			
			if(userInfo.size() != 0 && userInfo.get(0).get("USER_ID") != null){
				
				retMap.put("USER_ID",userInfo.get(0).get("USER_ID"));
				retMap.put("COM_CODE",userInfo.get(0).get("COM_CODE"));
				retMap.put("LEGACY_USER_ID",userInfo.get(0).get("LEGACY_USER_ID"));
				retMap.put("URL", browserFormPosURL);
				retMap.put("BUYERCOOKIE", buyerCookie);
				
				String[] params = browserFormPosURL.split("\\?")[1].split("&");
				
				String id = "";
				for( String p : params) { if (p.indexOf("id") > -1) {id = p.split("=")[1]; break;} }
				
				retMap.put("id", id);
				
				if ("Y".equals(userInfo.get(0).get("PASS_CHG_FLAG"))) {
					sqlSessionTemplate.update("updatePassChangeDateFagbUser",retMap);
				}					
				sqlSessionTemplate.update("insertPoURLForFagbUser", retMap);
			}
			
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return retMap;
	}
	
	@Override
	public Map<String, String> selectLoginInfoForYHKB(Map<String, String> pMap) {
		List<Map<String, String>> userInfo = new ArrayList<Map<String,String>>();
		Map<String, String> retMap = new HashMap<String, String>();
		String rtnStr = null;
		
		String xmlName = pMap.get("contactName");
		String contactEmail = pMap.get("contactEmail");
		String browserFormPosURL = pMap.get("browserFormPosURL");
		String buyerCookie = pMap.get("buyerCookie");
		
		for (Map.Entry<String,String> entry : pMap.entrySet()) {
			LOGGER.debug("pMap key : "+entry.getKey() + " , pMap value : "+ entry.getValue());
		}
		
		try {
			userInfo = sqlSessionTemplate.selectList("selectYHKBUserInfo", pMap);
			
			if(userInfo.size() != 0 && userInfo.get(0).get("USER_ID") != null){
				
				retMap.put("USER_ID",userInfo.get(0).get("USER_ID"));
				retMap.put("COM_CODE",userInfo.get(0).get("COM_CODE"));
				retMap.put("LEGACY_USER_ID",userInfo.get(0).get("LEGACY_USER_ID"));
				retMap.put("URL", browserFormPosURL);
				retMap.put("BUYERCOOKIE", buyerCookie);
				
				String[] params = browserFormPosURL.split("\\?")[1].split("&");
				
				String id = "";
				for( String p : params) { if (p.indexOf("id") > -1) {id = p.split("=")[1]; break;} }
				
				retMap.put("id", id);
				
				if ("Y".equals(userInfo.get(0).get("PASS_CHG_FLAG"))) {
					sqlSessionTemplate.update("updatePassChangeDateFagbUser",retMap);
				}					
				sqlSessionTemplate.update("insertPoURLForFagbUser", retMap);
			}
			
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		return retMap;
	}
	
	@Override
	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps) {
		String _rtnMsg 	= "";

		try {

			for(Map<String, String> pMap : pMaps) {	
				sqlSessionTemplate.update("buyer.mpso.insertSgsPo", pMap);
			}
			_rtnMsg = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
			_rtnMsg	= "ERROR";
		}
		
		return _rtnMsg;
	}
	
	@Override
	public void saveLog(Map<String, String> pMap) {
		sqlSessionTemplate.insert("buyer.mpso.insertWebServiceLog", pMap);
	}

	/**
	 * 펀치아웃 유큐브 버전 개발
	 * 1. 선택된 내역에 대해서 eai.if_ucube_pr_send에 저장.
	 * 		doc_no, doc_seq 생성이 필요함.
	 * 2. 저장이 완료되면 해당 품목을 장바구니 내역에서 삭제 처리함.
	 */
	@Override
	public String setPunchoutUcube(Map<String, String> formData) {

		String _st_update = formData.get("st_update").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString();
		String _legacy_user_id = formData.get("legacy_user_id").toString();
		Map<String,String> _data = null;
		String _doc_no	= "";
		List<Map<String, String>> _docNoInfo = new ArrayList<Map<String,String>>();
		
		try{
			 
			String  _ICOMCART[] = _st_update.split("\\|"); 
			if (_ICOMCART == null){
				LOGGER.debug("_ICOMCART 미존재 ");
			}else{
				// doc_no 채번
				_docNoInfo = sqlSessionTemplate.selectList("buyer.mpso.getIFDocNo", formData);
				_doc_no = _docNoInfo.get(0).get("DOC_NO");
				LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				if (_ICOMCART.length >0){
					for( int i=0 ; i < _ICOMCART.length; i++){ 
						String str[] =  _ICOMCART[i].split("@@",-1);  
				        
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    }
						
				        if (str != null && str.length >= 13){
				        	
				        	_data = new HashMap<String,String>() ;
					        _data.put("buyer", _buyer);
					        _data.put("user_id", _user_id);
					        _data.put("doc_no", _doc_no);
					        _data.put("legacy_user_id", _legacy_user_id);
						        
					        _data.put("st_item_no", str[0]);
					        _data.put("st_order_qty", str[1]);
					        _data.put("st_ref_pr_no", str[2]);
					        _data.put("st_contract_no", str[3]);
					        _data.put("st_contract_seq", str[4]);
					        _data.put("st_fixed_price_flag", str[5]); 
					        _data.put("st_order_price", str[6]);
					        _data.put("st_account_type", str[7]); 
					        _data.put("st_budget_dept", str[8]); 
					        _data.put("remark", str[9]); 
					        _data.put("ref_pr_dept", str[10]); 
					        _data.put("mg_code", str[11]);
					        _data.put("mg_note", str[12]); 
					        
					        if(str.length == 14){
					        	_data.put("st_cart_seq", str[13]);
					        }else{
					        	_data.put("st_cart_seq", str[15]);
					        }
					        sqlSessionTemplate.insert("buyer.mpso.insertPunchoutUcubeSend",_data);
					        sqlSessionTemplate.delete("buyer.mpso.removeIcomcart",_data);
				        }
					}
					
					HashMap<String, String> pMap = new HashMap<String, String>();
					pMap.put("buyer", _buyer);
					pMap.put("doc_no", _doc_no);
					sqlSessionTemplate.insert("buyer.mpso.updatePunchoutUcubeFlag", pMap);
				}
			}
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("펀치아웃 - 유큐브 저장에 실패했습니다.");
		}
		return null;
	}
	
	@Override
	public List<Map<String, String>> selectWhaninPrList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectWhaninPrList", pMap);
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, String>> selectNCCHAppReqList(Map<String, String> pMap) {
		
		List<Map<String, String>> appHdInfo = sqlSessionTemplate.selectList("buyer.mpso.selectNCCHAppHeader", pMap);
		List<Map<String, String>> appDtInfo = sqlSessionTemplate.selectList("buyer.mpso.selectNCCHPrList", pMap);
		
		StringBuffer body = new StringBuffer();
		String tot_cnt	= "";
		String tot_amt	= "";

		body.append("<style>");
		body.append("  table {");
		body.append("    width: 800px;");
		body.append("    border: 1px solid #444444;");
		body.append("    border-collapse: collapse;");
		body.append("  }");
		body.append("  th, td {");
		body.append("    border: 1px solid #444444;");
		body.append("    text-align: center;");
		body.append("  }");
		body.append("</style>");
		
		body.append("<table>");	//  style='width:90%; border-width:1px; text-align:center; cellpadding:5px; cellspacing:5px; border-collapse:collapse; border-spacing:0px;'
		body.append("<tr>");
		body.append("<th width='20%' height='30px'>자재코드</th>");
		body.append("<th width='40%'>품명</th>");
		body.append("<th width='10%'>단위</th>");
		body.append("<th width='10%'>수량</th>");
		body.append("<th width='10%'>단가</th>");
		body.append("<th width='10%'>금액</th>");
		body.append("</tr>");
		for( Map<String, String> iMap : appDtInfo ) {
			body.append("<tr>");
			body.append("<td>"+iMap.get("BUYER_ITEM_NO")+"</td>");
			body.append("<td>" +iMap.get("DESCRIPTION")+ "</td>");
			body.append("<td>" +iMap.get("UNIT_MEASURE")+ "</td>");
			body.append("<td>" +iMap.get("QTY")+ "</td>");
			body.append("<td>" +iMap.get("PRICE")+ "</td>");
			body.append("<td>" +iMap.get("AMOUNT")+ "</td>");
			body.append("</tr>");
			
			tot_cnt	= iMap.get("CNT");
			tot_amt	= iMap.get("AMT");
		}
		body.append("<tr>");
		body.append("<td colspan='2'>&nbsp;</td>");
		body.append("<td>품목수</td>");
		body.append("<td>" + tot_cnt + "</td>");
		body.append("<td>총금액</td>");
		body.append("<td>" + tot_amt + "</td>");
		body.append("</tr>");
		body.append("</table>");

		appHdInfo.get(0).put("ID_TYPE", "A");
		appHdInfo.get(0).put("LOCALE", "KO");
		appHdInfo.get(0).put("AP_ITEM", "MM1");
		appHdInfo.get(0).put("DOC_TITLE", "MRO 구매 신청서");
		appHdInfo.get(0).put("DOC_CONTENTS", body.toString());
		appHdInfo.get(0).put("IS_URGENT", appHdInfo.get(0).get("IS_URGENT"));

		if ( "2".equals(pMap.get("opFlag")) )
			appHdInfo.get(0).put("CALL_OUT_URL1", "https://www.koreab2b.com/mpso/setExternNCCHApproval.do?st_buyer="+pMap.get("buyer"));
		else 
			appHdInfo.get(0).put("CALL_OUT_URL1", "https://kepdev.koreab2b.com/mpso/setExternNCCHApproval.do?st_buyer="+pMap.get("buyer"));

		appHdInfo.get(0).put("KEP_YEAR", "99");
		
		return appHdInfo;
	}

	@Override
	public String processNCCHExternApproval(Map<String, String> pMap) {
		String msg	= "";
		String buyer	= "";
		String legacyUserId	= "";
		String pxNo	= "";
		String prNo	= "";
		String status	= "";
		String app_flag	= "";
		String[] arrAppStatus = null;
		Map<String, String> slgMap	= null;
		
		int rtnCnt	= 0;
		
		/**
		 * 특수로직 체크
		 * 고객사별 결재 처리 코드를 KEP 기준으로 변경.
		 * 
		 */
		
		Set<?> set = pMap.keySet();
		Iterator<?> it = set.iterator();
		System.out.println("------------------------------------------------------------\n");
		while(it.hasNext()){
			String key = (String)it.next();
			if(key != null){
				System.out.println("key = "+key+",\t\t\t value = "+pMap.get(key)+"\n");
			}
		}
		System.out.println("------------------------------------------------------------\n");
		
		String AP_FORM_NO = pMap.get("AP_FORM_NO");
		app_flag = pMap.get("BTN_FLAG");
		legacyUserId = pMap.get("AP_USER_ID");	// 발주자ID parameter
		
		buyer = AP_FORM_NO.substring(0, 10);
		prNo = AP_FORM_NO.substring(10, 20);
		pMap.put("st_buyer", buyer);

		System.out.println("key = AP_FORM_NO,\t\t\t value = "+AP_FORM_NO+"\n");
		System.out.println("key = app_flag,\t\t\t value = "+app_flag+"\n");
		System.out.println("key = legacyUserId,\t\t\t value = "+legacyUserId+"\n");
		System.out.println("key = buyer,\t\t\t value = "+buyer+"\n");
		System.out.println("key = prNo,\t\t\t value = "+prNo+"\n");
		
		if ( !"".equals(buyer) || buyer != null ) {
			arrAppStatus = "1:PX,0:PR,9:PS,F:PD".split(",");
			pMap.put("st_pr_no", prNo);
			
			for(int i = 0 ; i < arrAppStatus.length ; i++) {
				String[] arrAppDt = arrAppStatus[i].split(":");
				
				if ( app_flag.equals(arrAppDt[0])) {
					status = arrAppDt[1];
					break;
				}
			}
			pMap.put("st_user_id", legacyUserId);
		}
		
		if ("PX".equals(status)) {
			// 승인
			try {
				pxNo	= buyerMpSoOrderInfoDao.getOrderNo(buyer, "PX");
				pMap.put("st_ref_no",pxNo);
				rtnCnt = sqlSessionTemplate.insert("buyer.mpso.updateExternApprovalConfirm", pMap);
				if (rtnCnt < 1) {
					throw new Exception("발주생성 오류.!!");
				}
				
				pMap.put("COMPANY", buyer);
				pMap.put("V_REF_NO", pxNo);
				
	      		rtnCnt = sqlSessionTemplate.insert("commonApproval.MAIL_GJSUBMIT_TRG11", pMap);
				if (rtnCnt < 1) {
					throw new Exception("발주생성 오류.!!");
				}
			} catch (Exception e) {
				rtnCnt	= -1;
			}
			
		} else if ("PR".equals(status)) {
			// 반려
			pMap.put("recv_flag","PR");
			rtnCnt = sqlSessionTemplate.insert("buyer.mpso.updateExternAppStatus", pMap);
		} else if ("PS".equals(status)) {
			// 기안
			pMap.put("recv_flag","PS");
			rtnCnt = sqlSessionTemplate.insert("buyer.mpso.updateExternAppStatus", pMap);
		} else if ("PD".equals(status)) {
			// 상신취소, 회수
			pMap.put("recv_flag","PD");
			rtnCnt = sqlSessionTemplate.insert("buyer.mpso.updateExternAppStatus", pMap);
		}
		
		if (rtnCnt > 0) {
			msg	= "0:OK";
		} else {
			msg	= "-1:Error";
		}

		return msg;
	}

	@Override
	public void processQuratisCallbackList(Map<String,String> pMap) {
		
		String status = pMap.get("state");
		
		if ("complete".equals(status)) {
			pMap.put("RECV_FLAG", "PS");
			
			Map<String,String> iMap = sqlSessionTemplate.selectOne("buyer.mpso.getPxNum", pMap);
			
			pMap.put("REF_NO", iMap.get("REF_NO"));
			
			sqlSessionTemplate.update("buyer.mpso.InsertExternIfProgress", pMap);
			
		} else if ("progress".equals(status)){
			pMap.put("RECV_FLAG", "PS");
		} else if ("rejected".equals(status)){
			pMap.put("RECV_FLAG", "PR");
		} else {
			pMap.put("RECV_FLAG", "PD");
		}
//		System.out.println("pMap : " + pMap);
		sqlSessionTemplate.update("buyer.mpso.ExternCallbackList", pMap);
		sqlSessionTemplate.update("buyer.mpso.updateExternAppStatusHD", pMap);
	}
	
	
	@Override
	public void processQuratisBizboxCallbackList(Map<String, String> pMap) throws Exception {
		/* STATUS : 10/임시보관, 20/상신, 30/진행, 100/반려, 90/종결 */
		
		String status = (String)pMap.get("STATUS");
		if ("90".equals(status)) {
			pMap.put("RECV_FLAG", "PS");
			sqlSessionTemplate.update("buyer.mpso.InsertExternIfProgressPRDT", pMap);
		} else if ("100".equals(status) || "10".equals(status) || "999".equals(status)){
			pMap.put("RECV_FLAG", "PR");
		} else if ("20".equals(status) || "30".equals(status)){ // 20,30 결재중으로 처리한다.
			pMap.put("RECV_FLAG", "PS");
		}

		System.out.println("pMap : " + pMap);
		if ( !"".equals(pMap.get("RECV_FLAG") ) ) {
			sqlSessionTemplate.update("buyer.mpso.ExternCallbackList", pMap);
			sqlSessionTemplate.update("buyer.mpso.updateExternAppStatusHD", pMap);
		} else {
			System.out.println("status : " + status);
		}
	}

	@Override
	public void processHongIkCallbackList(Map<String,String> pMap) {
		
		String status = pMap.get("st_status");
		pMap.put("approval_id","");
		if ("D1".equals(status) || "R1".equals(status)) {
			
			pMap.put("RECV_FLAG", "PS");
			
		} else if ("D4".equals(status) || "R4".equals(status)){
			pMap.put("RECV_FLAG", "PR");
		} else if ("R5".equals(status)){
			
			pMap.put("RECV_FLAG", "PS");
			
			Map<String,String> iMap = sqlSessionTemplate.selectOne("buyer.mpso.getPxNum", pMap);
			
			pMap.put("REF_NO", iMap.get("REF_NO"));
			
			sqlSessionTemplate.update("buyer.mpso.InsertExternIfProgress", pMap);
		} else {
			pMap.put("RECV_FLAG", "PS");
		}
		
//		System.out.println("pMap : " + pMap);
		
		sqlSessionTemplate.update("buyer.mpso.ExternCallbackList", pMap);
		sqlSessionTemplate.update("buyer.mpso.updateExternAppStatusHD", pMap);
		
	}
	
	@Override
	public List<Map<String, String>> processLnfAppSendList(Map<String, String> pMap){
		
		List<Map<String,String>> rtn = sqlSessionTemplate.selectList("buyer.mpso.selectLnfAppSendList", pMap);
		
		int i = 0;
		String str = "";
		int len = rtn.size();
		for ( Map<String,String> iMap : rtn) {
			if(i == 0) {
				if (len == 1) {
					str = "[MRO] " + iMap.get("TEXT1") + " " + iMap.get("DESCRIPTION")+ "(" + iMap.get("BUYER_ITEM_NO") +")" + " " + len + "품목 구입의 건";
				} else {
					str = "[MRO] " + iMap.get("TEXT1") + " " + iMap.get("DESCRIPTION")+ "(" + iMap.get("BUYER_ITEM_NO") +")" + " 등 " + len + "품목 구입의 건";
				}
			}
			iMap.put("SUBJECT",str);
			i++;
		}
		
		return rtn;
	}
	
	@Override
	public void processLnfCallbackList(Map<String, String> pMap) {
		
//		'S' - 최초 기안자가 결재 진행시 호출
//		‘E’ - 최종 결재자(수신선)가 결재 완료시 호출
//		‘C’ - 최초 기안자가 상신 취소
//		‘B’ - 결재가 결재반려"	
		String st_status = pMap.get("APP_STATUS");
		pMap.put("approval_id","");
		if ("E".equals(st_status)) {
			pMap.put("RECV_FLAG","PS");
			
			Map<String,String> iMap = sqlSessionTemplate.selectOne("buyer.mpso.getPxNum", pMap);
			
			pMap.put("REF_NO", iMap.get("REF_NO"));
			
			sqlSessionTemplate.update("buyer.mpso.InsertExternIfProgress", pMap);
		//	sqlSessionTemplate.update("buyer.mpso.updateExternAppStatusHD_LNF", pMap);
			
		} else if ("C".equals(st_status) || "B".equals(st_status)) {
			
			pMap.put("RECV_FLAG","PR");
			
		} else {
			pMap.put("RECV_FLAG","PS");
		}
//		System.out.println("pMap : " + pMap);
		
		sqlSessionTemplate.update("buyer.mpso.ExternCallbackList", pMap);
		sqlSessionTemplate.update("buyer.mpso.updateExternAppStatusHD", pMap);
	}
	
	@Override
	public Map<String, String> mergetHanwhaUser(Map<String, String> pMap) {
		//직급코드 확인
		String positionVal = "";
		
		positionVal = (String)sqlSessionTemplate.selectOne("buyer.mpso.selectMasterPositionCodeManageCheck", pMap);
		if ("".equals(CommonUtil.nvl(positionVal))) {
			sqlSessionTemplate.update("buyer.mpso.insertMasterPositionCode", pMap);
		}
		
		sqlSessionTemplate.update("buyer.mpso.mergetHanwhaUser", pMap);
		/**
		 * 한화 사용자 정보 추가 생성 ( ICOMLUSR )
		 * 부서는 '001'로 통일, 비밀번호는 RANDOM STRING
		 */
		int cnt = (Integer)sqlSessionTemplate.selectOne("buyer.mpso.selectHanwhaUserCnt", pMap);
		if (cnt > 0) {
			sqlSessionTemplate.update("buyer.mpso.updateHanwhaUser", pMap);
		} else {
			pMap.put("EMAIL", "aaa@bbb.com");
			sqlSessionTemplate.update("buyer.mpso.insertHanwhaUser", pMap);
		}

		Map<String, String> rMap = null;
		try {
			rMap = sqlSessionTemplate.selectOne("buyer.mpso.selectHanwhaAppUser", pMap);
		} catch (Exception e) {
			LOGGER.error("selectHanwhaAppUser Error : " + e.getMessage());
		}
		return rMap;
	}

	@Override
	public List<Map<String, String>> selectHanwhaAppUserList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectHanwhaAppUserList", pMap);
	}
	@Override
	public void processAeKyAppStatus(Map<String, Object> aMap, String type) {		 
		 String MAN_SEND = "0";      //결재유형 - 기안자
		 String MAN_PASS = "1";  	// 결재유형 - 결재자
		 String MAN_REFER = "2"; 	// 결재유형 - 참조자
		// 결재상태
		 String STATUS_TEMP = "9";   // 임시 저장
		 String STATUS_PING = "0";   // 결재상태 - 결재중
		 String STATUS_RET = "1";    // 결재상태 - 반려
		 String STATUS_RING = "2";   // 결재상태 - 참조진행
		 String STATUS_COMP = "3";   // 결재상태 - 결재완료
		// 결재종류
		 String KIND_SEND = "0";     // 결재종류 - 기안
		 String KIND_PASS = "1";     // 결재종류 - 결재
		 String KIND_REFER = "2";    // 결재종류 - 참조
		 String KIND_RET = "3";      // 결재종류 - 반려
		 String appType = type;
		 System.out.println("## type : " + type);
		 System.out.println("## aMap : " + aMap);
		 
		 try {
			Map<String,Object> pMap = new ObjectMapper().readValue(aMap.get("apprData").toString(), Map.class);
	//		 Map<String,Object> pMap = new ObjectMapper().readValue("{\"gw_status\": \"3\",\"gw_doc_id\" : \"00000000000001225264\",\"kyulHeadId\" : \"KRTEST0018PR22000146\",\"gw_man\" :[{\"sequence\": \"1\",\"processed\": \"20221006163202\" ,\"activity\": \"0\",\"actionType\":\"0\",\"userId\": \"10100186\",\"aprStatus\": \"1\" },{\"sequence\": \"2\",\"processed\": \"\" ,\"activity\": \"1\",\"actionType\":\"0\",\"userId\": \"10700245\",\"aprStatus\": \"1\" }]}}", Map.class);
			
			Map <String,String> iMap = new HashMap<String, String>();
			if("RQ".equals(appType)) {
				String gwNo = pMap.get("kyulHeadId").toString().substring(10);
				pMap.put("gwNo", gwNo); // type: PR = PR번호, RQ = GW번호
				System.out.println("## gwNo : " + gwNo);
				iMap = sqlSessionTemplate.selectOne("buyer.mpso.selectAeKyRqAppList", pMap);				
			}else {				
				iMap = sqlSessionTemplate.selectOne("buyer.mpso.selectAeKyaAppList", pMap);	
			}
			iMap.put("gw_doc_id",pMap.get("gw_doc_id").toString());
			String apprDocStatusCd = pMap.get("gw_status").toString();
			List<Map<String,String>> gw_mans = (List<Map<String, String>>) pMap.get("gw_man");
			
			String apprLineStatusCd	= null; //0 : 미결, 1 : 승인, 2: 반려, 3 : 전결
			String passStatus	= null;
			String passProgress	= null;
			String passKn		= null;
			String cur_order_no	= null;
			String change_yn = null;
			
			try {
				
				if("2, 3, 4".indexOf(apprDocStatusCd) > -1) {
					
					for (Map<String,String> g_map : gw_mans) {
						Map<String, String> tMap	= new HashMap<String, String>();
						passStatus	= STATUS_PING;
						passKn		= null;
						cur_order_no	= null;						
						iMap.put("USERID",g_map.get("userId"));
						tMap	= sqlSessionTemplate.selectOne("buyer.mpso.AeKygetAppInfo", iMap);
						if(tMap != null) {
							apprLineStatusCd = g_map.get("aprStatus");
							tMap.put("APPRLINESTATUSCD",apprLineStatusCd);
							
							if ("1".indexOf(apprLineStatusCd) > -1) { // 1.승인 , 3. 전결
								passKn = KIND_PASS; //승인
							}else if ("2".indexOf(apprLineStatusCd) > -1) { // 2.반려								
								passKn = KIND_RET; //반려
							}
						}
						if(passKn != null) {
							tMap.put("PASS_KN", passKn);
							
							if ( KIND_PASS.equals(passKn) ) {
	//							
								sqlSessionTemplate.insert("AeKymodifyICOGPASSLN", tMap);
								tMap.put("PASS_TP", MAN_PASS);	// 결재								
								
								List<Map<String, String>> nextAppLine	= sqlSessionTemplate.selectList("buyer.mpso.AeKygetICOGPASSLNOrderNo", tMap);
								
								if (nextAppLine != null && nextAppLine.size() > 0) {
									
									Map<String, String> _cur_order	= nextAppLine.get(0);
									
									if (_cur_order == null) {
										passStatus	= STATUS_COMP;	// 최종 결재
									} else {
										cur_order_no	= _cur_order.get("ORDER_NO");
										
										if( "".equals(cur_order_no) ) {
											passStatus	= STATUS_COMP;	// 최종 결재										
										}
									}
								} else {
									passStatus	= STATUS_COMP;	//	최종 결재
								}								
							} else if (KIND_RET.equals(passKn)) {
								
								sqlSessionTemplate.insert("buyer.mpso.AeKymodifyICOGPASSLN", tMap);								
								passStatus = STATUS_RET;
								Map<String, String> tList = new HashMap<String, String>();
								if("RQ".equals(appType)) {
									tList = sqlSessionTemplate.selectOne("buyer.mpso.AeKyselectRqCancelInfoList", iMap);									
									tList.put("RECV_FLAG", "GA");
									sqlSessionTemplate.insert("buyer.mpso.AeKyupdateRqCancel", tList);									
								}else {									
									tList = sqlSessionTemplate.selectOne("buyer.mpso.AeKyselectPrCancelInfoList", iMap);
									tList.put("RECV_FLAG", "PR");
									sqlSessionTemplate.insert("buyer.mpso.AeKyupdatePrCancel", tList);
								}								
							}
							tMap.put("PASS_STATUS", passStatus);
							tMap.put("CUR_ORDER_NO", cur_order_no);
							
							sqlSessionTemplate.insert("buyer.mpso.AeKymodifyAPL", tMap);
							
							if ( STATUS_PING.equals(passStatus) ) {
								// 진행중.
								sqlSessionTemplate.insert("buyer.mpso.AeKymodifyICOGDOCU2", tMap);								
							}
						}
					} // for 문 끝
					
					if ( "3,4".indexOf(apprDocStatusCd) > -1) {
						iMap.put("RTN_MSG", apprDocStatusCd);
						iMap.put("RTN_FLAG", "Y");
						
						sqlSessionTemplate.insert("buyer.mpso.AeKyupdateHwinAppStatus", iMap);						
						if ("3".equals(apprDocStatusCd)) { // 승인
							iMap.put("PASS_STATUS", STATUS_COMP);							
							sqlSessionTemplate.insert("buyer.mpso.AeKyAllPassICOGPASSLN", iMap); // 결재현황보기 -> 결재여부 모두 결재로 변경
							if("RQ".equals(appType)) {										
								Map<String, String> nsMap = new HashMap<String, String>();
								nsMap.put("COMPANY", iMap.get("COMPANY"));
								nsMap.put("USER_ID", iMap.get("USERID"));
								nsMap.put("KEY_1", iMap.get("KEY_1"));
								uyerMpRqUnitpriceAgrmntNegoReqDao.nsApproval(nsMap);	// KEPRQDT/RECV_FLAG: CM 변경										
							}
							
						} else {  // 반려
							iMap.put("PASS_STATUS", STATUS_RET);
						}
						sqlSessionTemplate.insert("buyer.mpso.AeKyupdateAppFinal2", iMap);						
					} 
					
				} else if("5".equals(apprDocStatusCd)) { // 상신취소
					
					if ("5".equals(apprDocStatusCd)) {
						pMap.put("PASS_ADD", "상신취소");
					}
					
					sqlSessionTemplate.insert("buyer.mpso.AeKymodifyICOGDOCU_PASSSTATUS", iMap);
					sqlSessionTemplate.insert("buyer.mpso.AeKymodifyICOGPASSLN_PASSKN", iMap);
					
					Map<String, String> tList = new HashMap<String, String>();
					
					if("RQ".equals(appType)) {
						tList = sqlSessionTemplate.selectOne("buyer.mpso.AeKyselectRqCancelInfoList", iMap);
						tList.put("RECV_FLAG", "GA");
						sqlSessionTemplate.insert("buyer.mpso.AeKyupdateRqCancel", tList);						
					}else {									
						tList = sqlSessionTemplate.selectOne("buyer.mpso.AeKyselectPrCancelInfoList", iMap);
						tList.put("RECV_FLAG", "PD");
						sqlSessionTemplate.insert("buyer.mpso.AeKyupdatePrCancel", tList);
					}
					
					iMap.put("RTN_MSG", apprDocStatusCd);
					iMap.put("RTN_FLAG", "Y");
					
					sqlSessionTemplate.insert("buyer.mpso.AeKyupdateHwinAppStatus", iMap);					
				}
				
			} catch (Exception e) {				
				e.printStackTrace();
			}
		
		 }catch (Exception e) {			 
			 e.printStackTrace();
		 }
	}

	
	/**
	 * 롯데 결재 연동  
	 * @param pMap
	 */
	@Override
	public Map<String, Object> processLotteMpRqAppSend(Map<String, Object> pMap) throws Exception{
		Map<String, Object> returnMap = new HashMap<String, Object>();

		try {
			 
		   LOGGER.info("pMap ::::::::" + pMap);
			  
		  //견적단가합의 or 입고등록 link 테이블에 insert
		  String mode = (String) pMap.get("moduleId");
		  String key_no = (String)pMap.get("keyvalue");
		  Map<String, String> modeMap = new HashMap<String, String>();
		  String grDate = (String)pMap.get("grDate");
		  
		  
		  if(mode.equals("WAREHOUSING")) { //입고 
			  modeMap.put("key_no", key_no); 
			  modeMap.put("ori_gr_date", grDate.replaceAll(" ", "")); 
			  sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrAppSendDBlinkList", modeMap); 
			  LOGGER.info("pMap :::::::: WAREHOUSING");
		  }else if(mode.equals("ORDER")){ //견적단가 
			  modeMap.put("key_no", key_no);
			  sqlSessionTemplate.update("buyer.mprq.updateRqdtAppSendDBlinkList", modeMap);
			  LOGGER.info("pMap :::::::: ORDER");
		  }

		  LOGGER.info("before proxy :::::::: before proxy!!");
		  InterfaceSoapProxy proxy = new InterfaceSoapProxy();
		  String callback = proxy.requestDraft((String)pMap.get("domain_code"),(String)pMap.get("id"), (String)pMap.get("systemid"), (String)pMap.get("keyvalue"), (String)pMap.get("moduleId"), (String)pMap.get("formAlias"), (String)pMap.get("mode"), (String)pMap.get("xmlData"));
		
		  returnMap.put("resultUrl", callback);
		  
		} catch (Exception e) {
			returnMap.put("resultCode", "FAIL"); 
			e.printStackTrace();
			LOGGER.error("processLotteMpRqAppSend Error : " + e.getMessage());
		}
		
		return returnMap;
	}

	@Override
	public String saveFagbPurchaseOrder(List<Map<String, String>> pMaps) {
		String _rtnMsg 	= "";

		try {

			for(Map<String, String> pMap : pMaps) {	
				sqlSessionTemplate.update("buyer.mpso.insertFagbPo", pMap);
			}
			_rtnMsg = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
			_rtnMsg	= "ERROR";
		}
		
		return _rtnMsg; 		
	}

	@Override
	public String savePMKPurchaseOrder(List<Map<String, String>> pMaps) {
		String _rtnMsg 	= "";

		try {

			for(Map<String, String> pMap : pMaps) {	
				sqlSessionTemplate.update("buyer.mpso.insertPMKPo", pMap);
			}
			_rtnMsg = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
			_rtnMsg	= "ERROR";
		}
		
		return _rtnMsg; 	
	}
	
	@Override
	public String saveYHKBPurchaseOrder(List<Map<String, String>> pMaps) {
		String _rtnMsg 	= "";

		try {

			for(Map<String, String> pMap : pMaps) {	
				sqlSessionTemplate.update("buyer.mpso.insertYHKBPo", pMap);
			}
			_rtnMsg = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
			_rtnMsg	= "ERROR";
		}
		
		return _rtnMsg; 	
	}

	@Override
	public void setSoulbrainMsdsStatus(Map<String, String> pMap) {
		sqlSessionTemplate.update("buyer.mpso.InsertMsdsStatus", pMap);
	}

	@Override
	public String saveYhkbSignUp(Map<String, String> pMap) {
		String _rtnMsg 	= "";
		Map<String, String> cookieMap = new HashMap<String, String>();
		try {
			cookieMap = sqlSessionTemplate.selectOne("buyer.mpso.selectYhkbSignUp", pMap);
			if(cookieMap.size() != 0) { // 펀치아웃을 통해 들어온 경우
				pMap.put("returnValue", "");
				sqlSessionTemplate.selectOne("buyer.mpso.saveYhkbSignUp", pMap);
				if(!pMap.get("returnValue").equals("ERROR")) {
					
						
					pMap.put("USER_ID",pMap.get("returnValue"));
					pMap.put("COM_CODE",pMap.get("st_buyer"));
					pMap.put("LEGACY_USER_ID",pMap.get("st_legacy_user_id"));
					pMap.put("URL", cookieMap.get("browserFormPosURL"));
					pMap.put("BUYERCOOKIE", cookieMap.get("buyerCookie"));
						
						String[] params = pMap.get("URL").split("\\?")[1].split("&");
						
						String id = "";
						for( String p : params) { if (p.indexOf("id") > -1) {id = p.split("=")[1]; break;} }
						
						pMap.put("id", id);			
											
						sqlSessionTemplate.update("insertPoURLForFagbUser", pMap);
					
					
					return "OK";
				} else {
					return "ERROR";
				}
			}
			return "ERROR";
			
		} catch (Exception e) {
			e.printStackTrace();
			_rtnMsg	= "ERROR";
		}
		
		return _rtnMsg; 	
	}
	
	
}
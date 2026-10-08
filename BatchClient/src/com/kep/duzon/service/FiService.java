package com.kep.duzon.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonUtil;
import com.kep.duzon.dao.ErpDuzonDao;
import com.kep.duzon.dao.ErpKepconDao;
import com.kep.duzon.dao.ErpKepmpDao;
import com.kep.duzon.dao.ErpPrmtDao;

public class FiService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public void sendFiDocu() {
		
		ErpKepmpDao mpDao	= new ErpKepmpDao();
		ErpDuzonDao dzDao	= new ErpDuzonDao();
		String rtnFlag = "";
		String rtnMsg  = "";
		int cnt = 0;
		
		try {
			List<Map<String, String>> fiList = mpDao.selectFiDocu();
			
			if (fiList.size() > 0) {
				for (Map<String, String> iMap : fiList ) {
					
					cnt++;
					try {
						dzDao.insertFiDocu(iMap);
						rtnFlag = "Y";
						rtnMsg = "SUCCESS.";
					} catch (Exception e) {
						rtnFlag = "E";
						rtnMsg = CommonUtil.printStackTraceToString(e);
						log.error("insertFiDocu["+iMap.get("IF_SYSTEM")+"]["+iMap.get("ROW_ID")+"]Error : " + rtnMsg);
					}
					iMap.put("IF_FLAG", rtnFlag);
					iMap.put("IF_MSG", rtnMsg);
					
					mpDao.updateFiDocu(iMap);
					
					if (cnt%100 == 0 && cnt > 0) {
						log.info(cnt);
					}
				}
				log.info(cnt);
			}
		} catch (Exception e) {
			this.log.error("sendFiDocu Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void recvFiDocu() {
		
		ErpKepmpDao mpDao	= new ErpKepmpDao();
		ErpDuzonDao dzDao	= new ErpDuzonDao();
		String rtnFlag = "";
		String rtnMsg  = "";
		int cnt = 0;

		try {
			List<Map<String, String>> fiCancelList = dzDao.selectFiDocuR();
			
			for(Map<String, String> iMap : fiCancelList) {
				try {

					cnt++;
					mpDao.insertErpFiEpdocuR(iMap);
					rtnFlag = "Y";
					rtnMsg = "SUCCESS.";
				} catch (Exception e) {
					log.error("iMap : " + iMap);
					log.error("insertErpFiEpdocuR : " + CommonUtil.printStackTraceToString(e));
					rtnFlag = "E";
					rtnMsg = CommonUtil.printStackTraceToString(e);
				}

				iMap.put("TR_FLAG", rtnFlag);
				iMap.put("TR_ERROR", rtnMsg);
				dzDao.updateFiDocuR(iMap);
				
				if (cnt%100 == 0) {
					log.info("CNT" + cnt);
				}
			}
		} catch (Exception e) {
			this.log.error("recvFiDocu Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void recvNoDocu() {
		ErpKepmpDao mpDao	= new ErpKepmpDao();
		ErpDuzonDao dzDao	= new ErpDuzonDao();
		String rtnFlag = "";
		String rtnMsg  = "";
		int cnt = 0;
		try {
			Map<String, String> pMap = new HashMap<String, String>();
			pMap.put("IF_SYSTEM","PA");
			List<Map<String,String>> noDocuList = dzDao.selectNoDocu(pMap);
			
			if (noDocuList.size() > 0) {
				for(Map<String, String> iMap : noDocuList) {
					try {
						int rtn = mpDao.updateNoDocu(iMap);
						if (rtn > 0) {
							rtnFlag = "Y";
						} else {
							rtnFlag = "E";
						}	
					} catch (Exception e) {
						rtnFlag = "E";
						log.error("recvNoDocu : " + CommonUtil.printStackTraceToString(e));
					}
					iMap.put("RTN_FLAG",rtnFlag);
					dzDao.udpateNoDocuRtnFlag(iMap);
				}
			}
			
		} catch (Exception e) {
			log.error("recvNoDocu:" + CommonUtil.printStackTraceToString(e));
		}
		
	}

	/**
	 * 구매대행 매출 생성
	 */
	public void createArKepmp() {
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		String ifSendFlag = "";
		int IF_SEQ = 1;
		Map<String,String> pMap = new HashMap<String,String>();
		
		try {
			List<Map<String, String>> arList = mpDao.selectArKepmpList();
			
			if (arList.size() > 0) {
				pMap.clear();
				pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_KA");
				String IF_ID = mpDao.selectIfId(pMap);
				
				for(Map<String, String> iMap : arList) {
					ifSendFlag = "N";
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					
					try {
						mpDao.insertErpFiEpdocu(iMap);
						ifSendFlag = "Y";
					} catch (Exception e) {
						ifSendFlag = "E";
						log.error("insertErpFiEpdocu : " + CommonUtil.printStackTraceToString(e));
					}
					iMap.put("IF_SEND_FLAG", ifSendFlag);
					mpDao.updateArKepmp(iMap);
					
					if ((IF_SEQ-1)%100 == 0 && IF_SEQ > 0) {
						log.info("CNT:"+(IF_SEQ-1));
					}
				}
				log.info("CNT:"+(IF_SEQ-1));
			}
		} catch (Exception e) {
			log.error("createArKepmp : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 건설/유통 매출 생성
	 */
	public void createArKepcon() {
		
		ErpKepconDao conDao = new ErpKepconDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String, String>();
		String ifSendFlag = "";
		String IF_SYSTEM = "";
		String IF_ID = "";
		int IF_SEQ = 1;
		
		try {
			List<Map<String, String>> arList = conDao.selectArKepconList();
			
			if (arList.size() > 0) {
				for (Map<String, String> iMap : arList) {
					if ( !IF_SYSTEM.equals(iMap.get("IF_SYSTEM")) ) {
						
						IF_SYSTEM = iMap.get("IF_SYSTEM");
						pMap.clear();
						pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_" + IF_SYSTEM);
						IF_ID = mpDao.selectIfId(pMap);
						IF_SEQ = 1;
					}
					
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					
					try {
						mpDao.insertErpFiEpdocu(iMap);
						ifSendFlag = "Y";
					} catch (Exception e) {
						log.error("insertErpFiEpdocu Error : " + CommonUtil.printStackTraceToString(e));
						ifSendFlag = "E";
					}
					iMap.put("IF_SEND_FLAG", ifSendFlag);
					conDao.updateArKepcon(iMap);
					
					if ((IF_SEQ-1)%100 == 0 && IF_SEQ > 0) {
						log.info("CNT["+IF_SYSTEM+"]:"+(IF_SEQ-1));
					}
				}
				log.info("CNT["+IF_SYSTEM+"]:"+(IF_SEQ-1));	
			}
		} catch (Exception e) {
			log.error("createArKepmp : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 구매대행 매출 취소
	 */
	public void cancelArKepmp() {
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		int cnt = 0;
		
		try {
			pMap.clear();
			pMap.put("IF_SYSTEM","KA");
			pMap.put("TYPE","AR");
			
			List<Map<String, String>> cancelList = mpDao.selectFiDocuR(pMap);
			
			if (cancelList.size() > 0) {
				for(Map<String,String> iMap : cancelList) {
					cnt++;
					mpDao.deleteARCloseConfirm(iMap);
					List<Map<String, String>> closeUserList = mpDao.selectArBillCloseUser(iMap);
					mpDao.updateArBillCloseUserKepmp(closeUserList);
					mpDao.updateCancelArKepmp(iMap);
					iMap.put("IF_FLAG", "Y");
					mpDao.updateFiDocuR(iMap);
					
					if (cnt%100 == 0) {
						log.info("CNT:"+cnt);
					}
				}
				log.info("CNT:"+cnt);	
			}

		} catch (Exception e) {
			log.error("cancelArKepmp" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 건설/유통 매출 취소
	 */
	public void cancelArKepcon() {
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpKepconDao conDao = new ErpKepconDao();
		Map<String, String> pMap = new HashMap<String,String>();
		String[] tList = {"KW", "SA", "IT"};
		
		try {
			for (int i = 0 ; i < tList.length ; i++) {

				pMap.clear();
				pMap.put("IF_SYSTEM",tList[i]);
				pMap.put("TYPE","AR");
				
				List<Map<String, String>> cancelList = mpDao.selectFiDocuR(pMap);
				
				if (cancelList.size()>0) {
					int cnt = 0;
					
					for(Map<String,String> iMap : cancelList) {
						conDao.updateCancelArKepcon(iMap);
						iMap.put("IF_FLAG", "Y");
						mpDao.updateFiDocuR(iMap);
						
						if (cnt%100 == 0) {
							log.info("CNT:"+cnt);
						}
						log.info("CNT:"+cnt);
					}
				}
			}
		} catch (Exception e) {
			log.error("cancelArKepcon:" + CommonUtil.printStackTraceToString(e));
		}
	}

	public void createApKepmp() {
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		String ifSendFlag = "";
		int IF_SEQ = 1;
		Map<String,String> pMap = new HashMap<String,String>();
		
		try {
			List<Map<String, String>> apList = mpDao.selectApKepmpList();
			
			if (apList.size() > 0) {
				pMap.clear();
				pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_KA");
				String IF_ID = mpDao.selectIfId(pMap);
				
				for(Map<String, String> iMap : apList) {
					ifSendFlag = "N";
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					try {
						mpDao.insertErpFiEpdocu(iMap);
						ifSendFlag = "Y";
					} catch (Exception e) {
						ifSendFlag = "E";
					}
					iMap.put("IF_SEND_FLAG", ifSendFlag);
					mpDao.updateApKepmp(iMap);
					
					if ((IF_SEQ-1)%100 == 0) {
						log.info("CNT:"+(IF_SEQ-1));
					}
				}
				log.info("CNT:"+(IF_SEQ-1));
			}
		} catch (Exception e) {
			log.error("createApKepmp : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void createApKepcon() {
		
		ErpKepconDao conDao = new ErpKepconDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String, String>();
		String ifSendFlag = "";
		String IF_SYSTEM = "";
		String IF_ID = "";
		int IF_SEQ = 1;
		
		try {
			List<Map<String, String>> apList = conDao.selectApKepconList();
			
			if (apList.size() > 0) {
				
				for (Map<String, String> iMap : apList) {
					if ( !IF_SYSTEM.equals(iMap.get("IF_SYSTEM")) ) {
						if (IF_SEQ > 1 ) {
							log.info("CNT["+IF_SYSTEM+"]:"+(IF_SEQ-1));
						}
						IF_SYSTEM = iMap.get("IF_SYSTEM");
						pMap.clear();
						pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_" + IF_SYSTEM);
						IF_ID = mpDao.selectIfId(pMap);
						IF_SEQ = 1;
					}
					
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					
					try {
						mpDao.insertErpFiEpdocu(iMap);
						ifSendFlag = "Y";
					} catch (Exception e) {
						log.error(CommonUtil.printStackTraceToString(e));
						ifSendFlag = "E";
					}
					iMap.put("IF_SEND_FLAG", ifSendFlag);
					conDao.updateApKepcon(iMap);
					
					if ((IF_SEQ-1)%100 == 0) {
						log.info("CNT["+IF_SYSTEM+"]:"+(IF_SEQ-1));
					}
				}
				log.info("CNT["+IF_SYSTEM+"]:"+(IF_SEQ-1));
			}
		} catch (Exception e) {
			log.error("createApKepcon:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void cancelApKepmp() {
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		int cnt=0;
		
		try {
			pMap.clear();
			pMap.put("IF_SYSTEM","KA");
			pMap.put("TYPE","AP");
			
			List<Map<String, String>> cancelList = mpDao.selectFiDocuR(pMap);
			
			if (cancelList.size() > 0) {
				for(Map<String,String> iMap : cancelList) {
					cnt++;
					mpDao.deleteAPCloseConfirm(iMap);
					List<Map<String, String>> closeUserList = mpDao.selectApBillCloseUser(iMap);
					mpDao.updateApBillCloseUserKepmp(closeUserList);
					mpDao.updateCancelApKepmp(iMap);
					iMap.put("IF_FLAG", "Y");
					mpDao.updateFiDocuR(iMap);
					
					if(cnt%100==0) {
						log.info("CNT[KA]:"+cnt);
					}
				}
				log.info("CNT[KA]:"+cnt);
			}

		} catch (Exception e) {
			log.error("cancelApKepmp:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void cancelApKepcon() {
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpKepconDao conDao = new ErpKepconDao();
		Map<String, String> pMap = new HashMap<String,String>();
		String[] tList = {"KW", "SA", "IT"};
		
		try {
			for (int i = 0 ; i < tList.length ; i++) {
				int cnt=0;

				pMap.clear();
				pMap.put("IF_SYSTEM",tList[i]);
				pMap.put("TYPE","AP");
				
				List<Map<String, String>> cancelList = mpDao.selectFiDocuR(pMap);

				if (cancelList.size() > 0) {
					for(Map<String,String> iMap : cancelList) {
						cnt++;
						conDao.updateCancelApKepcon(iMap);
						iMap.put("IF_FLAG", "Y");
						mpDao.updateFiDocuR(iMap);
						
						if(cnt%100==0 && cnt > 0) {
							log.info("CNT["+tList[i]+"]:"+cnt);
						}
					}
					log.info("CNT["+tList[i]+"]:"+cnt);
				}
			}
		} catch (Exception e) {
			log.error("cancelApKepcon:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 매출원가 생성 (구매대행)
	 */
	public void createSaleCostKepmp() {

		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String, String>();
		String YYYYMM = "";
		String CD_CC = "";
		String IF_ID = "";
		int IF_SEQ = 1;
		
		try {
			List<Map<String,String>> list = mpDao.selectSaleCost();
			
			if (list.size() > 0) {
				for (Map<String, String> iMap : list ) {
					if ( !YYYYMM.equals( iMap.get("YYYYMM") ) ) {
						
						YYYYMM = iMap.get("YYYYMM");
						pMap.clear();
						pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_KA");
						IF_ID = mpDao.selectIfId(pMap);
						IF_SEQ = 1;
						CD_CC = iMap.get("CD_CC");

						pMap.put("YYYYMM", YYYYMM);
						pMap.put("FLAG", "Y");
						mpDao.updateSaleCost(pMap);	// 조회 후 완료 처리.
					}
					
					if (!CD_CC.equals(iMap.get("CD_CC")) && CD_CC != null ) {
						if (IF_SEQ > 1) {
							log.info("CNT[KA:"+CD_CC+"]:"+(IF_SEQ-1));
						}
						CD_CC = iMap.get("CD_CC");
						pMap.clear();
						pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_KA");
						IF_ID = mpDao.selectIfId(pMap);
						IF_SEQ = 1;
					}
					
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					
					iMap.put("ROW_ID", IF_ID);
					iMap.put("SEQ", Integer.toString(IF_SEQ));
					
					mpDao.insertErpFiEpdocu(iMap);
					
					if ((IF_SEQ-1)%100 == 0) {
						log.info("CNT[KA:"+CD_CC+"]:"+(IF_SEQ-1));
					}
				}
				log.info("CNT[KA:"+CD_CC+"]:"+(IF_SEQ-1));
			}
		} catch (Exception e) {
			log.error("createSaleCost:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void createSaleCostKepcon() {

		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpKepconDao conDao = new ErpKepconDao();
		Map<String, String> pMap = new HashMap<String, String>();
		String IF_ID = "";
		int IF_SEQ = 1;
		int cnt = 0;
		String YYYYMM = "";
		
		try {

			// 1. 건설
			List<Map<String,String>> listSA = conDao.selectSaleCostSA();
			if(listSA.size() > 0) {
				pMap.clear();
				pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_SA");
				IF_ID = mpDao.selectIfId(pMap);
				IF_SEQ = 1;
				cnt = 0;

				pMap.put("YYYYMM", listSA.get(0).get("YYYYMM"));
				pMap.put("TARGET", "SA");
				pMap.put("FLAG", "Y");
				conDao.updateSaleCostKepcon(pMap);	// 조회 후 완료 처리.
				
				for(Map<String,String> iMap : listSA ) {
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					iMap.put("ROW_ID", IF_ID);
					iMap.put("SEQ", Integer.toString(IF_SEQ));
					cnt ++;
					mpDao.insertErpFiEpdocu(iMap);
				}
				
				if (cnt > 0 ) {
					log.info("CNT[SA]:" + cnt);
				}
			}
			// 2. 유통
			List<Map<String,String>> listKW = conDao.selectSaleCostKW();
			if (listKW.size() > 0 ) {
				pMap.clear();
				pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_KW");
				IF_ID = mpDao.selectIfId(pMap);
				IF_SEQ = 1;
				cnt = 0;

				pMap.put("YYYYMM", listKW.get(0).get("YYYYMM"));
				pMap.put("TARGET", "KW");
				pMap.put("FLAG", "Y");
				conDao.updateSaleCostKepcon(pMap);	// 조회 후 완료 처리.
				for(Map<String,String> iMap : listKW ) {
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					iMap.put("ROW_ID", IF_ID);
					iMap.put("SEQ", Integer.toString(IF_SEQ));
					cnt ++;
					mpDao.insertErpFiEpdocu(iMap);
				}
				
				if (cnt > 0 ) {
					log.info("CNT[KW]:" + cnt);
				}
			}
		} catch (Exception e) {
			log.error("createSaleCostKepcon:" + CommonUtil.printStackTraceToString(e));
		}
	}

	/**
	 * 판촉몰 매출 생성
	 */
	public void createArPromotion() {
		
		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		int IF_SEQ = 1;
		String ifSendFlag = "";
		String taxBillNo = "";
		String IF_ID = "";
		Map<String,String> pMap = new HashMap<String,String>();
		
		try {
			List<Map<String, String>> arList = pmDao.selectArPrmtList();
			if (arList.size() > 0) {

				for(Map<String, String> iMap : arList) {

					if (!taxBillNo.equals(iMap.get("TAX_BILL_NO"))) {
						pMap.clear();
						pMap.put("SEQ_ID","MAX_ERP_MNG_NO_PA");
						IF_ID = mpDao.selectIfId(pMap);	
						IF_SEQ = 1;
						taxBillNo = iMap.get("TAX_BILL_NO");
					}
					
					ifSendFlag = "N";
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					iMap.put("CD_COMPANY", pmDao._CD_COMPANY);	// 개발:TEST, 운영:1000
					
					try {
						mpDao.insertErpFiEpdocu(iMap);
						ifSendFlag = "Y";
					} catch (Exception e) {
						ifSendFlag = "E";
						log.error("insertErpFiEpdocu:" + CommonUtil.printStackTraceToString(e));
					}
					iMap.put("IF_SEND_FLAG", ifSendFlag);
					int rtnCnt = pmDao.updateArPrmt(iMap);
					
					if ((IF_SEQ-1)%100 == 0 && IF_SEQ > 0) {
						log.info("CNT:"+(IF_SEQ-1));
					}
				}
				log.info("CNT:"+(IF_SEQ-1));
			}
		} catch (Exception e) {
			log.error("createArPromotion:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 판촉몰 매출 FiNo 수정.
	 */
	public void updateArPromotionFiNo() {

		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		int cnt = 0;

		try {
			pMap.clear();
			pMap.put("IF_SYSTEM","PA");
			pMap.put("TYPE","AR");
			
			List<Map<String,String>> paFiList = mpDao.selectArPrmtFiNoList(pMap);
			
			if (paFiList.size() > 0) {
				for (Map<String,String> iMap : paFiList) {
					try {
						int rtnCnt = pmDao.updateArPrmtFiNo(iMap);
						iMap.put("RTN_FLAG", "Y");	
					} catch (Exception e) {
						iMap.put("RTN_FLAG", "E");
						log.error("updateArPromotionFiNo:" + CommonUtil.printStackTraceToString(e));
					}
					mpDao.updateArPrmtFiNoRtnFlag(iMap);
				}
			}

		} catch (Exception e) {
			log.error("updateArPromotionFiNo:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 판촉몰 매출 취소
	 */
	public void cancelArPromotion() {

		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		int cnt = 0;
		
		try {
			pMap.clear();
			pMap.put("IF_SYSTEM","PA");
			pMap.put("TYPE","AR");
			
			List<Map<String, String>> cancelList = mpDao.selectFiDocuR(pMap);
			
			if (cancelList.size() > 0) {
				for(Map<String,String> iMap : cancelList) {
					cnt++;
					int rtn = pmDao.updateCancelArPrmt(iMap);
					
					if (rtn > 0) {
						iMap.put("IF_FLAG", "Y");	
					} else {
						log.info("iMap : " + iMap);
						iMap.put("IF_FLAG", "E");
					}
					mpDao.updateFiDocuR(iMap);
					
					if (cnt%100 == 0) {
						log.info("CNT[PA]:"+cnt);
					}
				}
				log.info("CNT[PA]:"+cnt);
			}

		} catch (Exception e) {
			log.error("cancelArPromotion:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 판촉몰 매입 생성
	 */
	public void createApPromotion() {
		
		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		int IF_SEQ = 1;
		String ifSendFlag = "";
		String taxBillNo = "";
		String IF_ID = "";
		Map<String,String> pMap = new HashMap<String,String>();
		try {
			List<Map<String, String>> arList = pmDao.selectApPrmtList();
			if (arList.size() > 0) {

				for(Map<String, String> iMap : arList) {

					if (!taxBillNo.equals(iMap.get("TAX_BILL_NO"))) {
						pMap.clear();
						pMap.put("SEQ_ID","MAX_ERP_MNG_NO_PA");
						IF_ID = mpDao.selectIfId(pMap);	
						IF_SEQ = 1;
						taxBillNo = iMap.get("TAX_BILL_NO");
					}
					
					ifSendFlag = "N";
					iMap.put("IF_ID", IF_ID);
					iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
					
					try {
						mpDao.insertErpFiEpdocu(iMap);
						ifSendFlag = "Y";
					} catch (Exception e) {
						ifSendFlag = "E";
						log.error("insertErpFiEpdocu:" + CommonUtil.printStackTraceToString(e));
					}
					iMap.put("IF_SEND_FLAG", ifSendFlag);
					pmDao.updateApPrmt(iMap);
					
					if ((IF_SEQ-1)%100 == 0 && IF_SEQ > 0) {
						log.info("CNT:"+(IF_SEQ-1));
					}
				}
				log.info("CNT:"+(IF_SEQ-1));
			}
		} catch (Exception e) {
			log.error("createApPromotion:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 판촉몰 매입 취소
	 */
	public void cancelApPromotion() {

		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		int cnt = 0;
		
		try {
			pMap.clear();
			pMap.put("IF_SYSTEM","PA");
			pMap.put("TYPE","AP");
			
			List<Map<String, String>> cancelList = mpDao.selectFiDocuR(pMap);
			
			if (cancelList.size() > 0) {
				for(Map<String,String> iMap : cancelList) {
					cnt++;
					pmDao.updateCancelApPrmt(iMap);
					iMap.put("IF_FLAG", "Y");
					mpDao.updateFiDocuR(iMap);
					
					if (cnt%100 == 0) {
						log.info("CNT[PA]:"+cnt);
					}
				}
				log.info("CNT[PA]:"+cnt);
			}

		} catch (Exception e) {
			log.error("cancelApPromotion:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void savePromotionNoDocu( ) {

		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		int cnt = 0;
		String RTN_FLAG = "";
		int rtn = 0;
		
		try {
			pMap.put("IF_SYSTEM","PA");
			List<Map<String,String>> noDocuList = mpDao.selectFiNoDocu(pMap);
			
			if (noDocuList.size() > 0) {
				for(Map<String, String> iMap : noDocuList) {
					if (iMap.get("TAX_BILL_NO").indexOf("PG") > -1) {
						// 입금전표 no_docu 전달
						rtn = pmDao.updateErpCreditFiNo(iMap);
					} else {
						// 매출전표 no_docu 전달
						rtn = pmDao.updateErpFiNo(iMap);
					}

					if (rtn > 0) RTN_FLAG = "Y";
					else  RTN_FLAG = "E";
					iMap.put("RTN_FLAG", RTN_FLAG);
					mpDao.updateFiNoDocuResult(iMap);
				}
			}
		} catch (Exception e) {
			log.error("savePromotionNoDocu:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 판촉몰 PG사 입금내역 처리 및 입금전표 처리.
	 */
	public void createPgCreditInfo() {
		/**
		 * select eai.pg_credit_list
		 * insert prmt.pg_credit_list(입금내역)
		 * insert eai.fidocu(입금전표)
		 * update eai.pg_credit_list.if_flag
		 */

		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		String IF_ID = "";
		int IF_SEQ = 1;
		
		String C_IF_ID = "";
		int C_IF_SEQ = 1;
		
		String PG_EPCODE = "";
		String PC_EPCODE = "";
		
		try {
			List<Map<String, String>> pgList = mpDao.selectPgCreditList();
			
			if (pgList.size() > 0) {
				pMap.clear();
				pMap.put("SEQ_ID","MAX_ERP_MNG_NO_PG");
				IF_ID = mpDao.selectIfId(pMap);
				
				for ( Map<String, String> iMap : pgList) {
					
					Map<String, String> cMap = new HashMap<String, String>();
					
					cMap.putAll(iMap);
					
					try {
						// 입금내역 판촉몰로 전송
						iMap.put("TRADE_GUBUN", "C");	// 카드 입금내역 구분값 입력. 나중에 무통장 입금내역이 있으면 이에 대한 구분값 입력 필수
						pmDao.insertPgCreditList(iMap);
						
						List<Map<String, String>> pointChk = pmDao.selectAdvancedPointChk(iMap);
						if ( pointChk.size() > 0) {
							// 선수금
							PG_EPCODE = "4020";
							PC_EPCODE = "1040";
						} else {
							// 상품매출
							PG_EPCODE = "4010";
							PC_EPCODE = "1030";
						}

						// 입금내역 데이터 생성
						pMap.clear();
						pMap.put("SEQ_ID","MAX_ERP_MNG_NO_PG");
						IF_ID = mpDao.selectIfId(pMap);
						IF_SEQ = 1;
						
						iMap.put("IF_ID", IF_ID);
						iMap.put("IF_SEQ", Integer.toString(IF_SEQ));
						iMap.put("ROW_ID", IF_ID);
						iMap.put("SEQ", Integer.toString(IF_SEQ++));
						iMap.put("CD_EPCODE", PG_EPCODE);
						iMap.put("AM_TAXSTD", iMap.get("ERP_ACCOUNT"));
						mpDao.insertErpFiEpdocu(iMap);

						// 수수료 데이터 생성
						pMap.clear();
						pMap.put("SEQ_ID","MAX_ERP_MNG_NO_PC");
						C_IF_ID = mpDao.selectIfId(pMap);
						C_IF_SEQ = 1;
						
						iMap.put("IF_ID", C_IF_ID);
						iMap.put("IF_SEQ", Integer.toString(C_IF_SEQ));
						iMap.put("ROW_ID", C_IF_ID);
						iMap.put("SEQ", Integer.toString(C_IF_SEQ++));
						iMap.put("CD_EPCODE", PC_EPCODE);
						iMap.put("AM_TAXSTD", iMap.get("ERP_CHARGE"));
						iMap.put("NM_NOTE", "판촉몰 수수료");

						iMap.put("CD_DEPOSIT", "");
						iMap.put("CD_BANK", "");
						
						mpDao.insertErpFiEpdocu(iMap);
						
						iMap.put("IF_FLAG","Y");
					} catch (Exception e) {
						iMap.put("IF_FLAG","E");
						iMap.put("IF_MSG", e.getMessage());
						log.error("createPgCreditInfo Insert:" + CommonUtil.printStackTraceToString(e));
					}
					mpDao.updatePgCreditResult(iMap);
				}
			}

		} catch (Exception e) {
			log.error("createPgCreditInfo:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void cancelPgCreditInfo() {
		/**
		 * ERP에서 취소한 입금전표에 대해서 판촉몰 디비에서 전표번호를 삭제 처리한다.
		 * fi번호를 지운다.
		 */

		ErpPrmtDao pmDao = new ErpPrmtDao();
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String,String>();
		int cnt = 0;
		
		try {
			pMap.clear();
			pMap.put("IF_SYSTEM","PA");
			
			List<Map<String, String>> cancelList = mpDao.selectPGFiNoDocuR(pMap);
			
			if (cancelList.size() > 0) {
				for(Map<String,String> iMap : cancelList) {
					cnt++;
					pmDao.updateErpCreditFiNo(iMap);
					iMap.put("IF_FLAG", "Y");
					mpDao.updateFiDocuR(iMap);
					
					if (cnt%100 == 0) {
						log.info("CNT[PG]:"+cnt);
					}
				}
				log.info("CNT[PG]:"+cnt);
			}

		} catch (Exception e) {
			log.error("cancelPgCreditInfo:" + CommonUtil.printStackTraceToString(e));
		}
	}
}
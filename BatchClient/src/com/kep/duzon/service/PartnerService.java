package com.kep.duzon.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.AWSKMSAlgorithmUtil;
import com.kep.common.CommonUtil;
import com.kep.common.SeedCbcAlgorithmUtil;
import com.kep.duzon.dao.ErpDuzonDao;
import com.kep.duzon.dao.ErpKepconDao;
import com.kep.duzon.dao.ErpKepmpDao;

public class PartnerService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	/**
	 * 구매대행(KA)에서 신규 등록된 거래처 일반정보를 EAI에 저장한다.
	 */
	public void createPartnerTempKepmp() {
		String IF_ID = "";
		int IF_SEQ = 1;
		String ifSendFlag = "";
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String, String>();
		
		try {
			List<Map<String, String>> partners = mpDao.selectPartnerTempKepmp();
			
			if ( partners.size() > 0 ) {
				pMap.clear();
				pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_KA");
				IF_ID = mpDao.selectIfId(pMap);
				
				for (Map<String,String> iMap : partners) {
					
					int chkPartner = mpDao.checkPartnerTemp(iMap);
					
					if ( chkPartner == 0 ) {
						try {
							iMap.put("IF_ID", IF_ID);
							iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
							iMap.put("IF_SYSTEM", "KA");
							
							mpDao.insertPartnerTemp(iMap);
							
							if ( "002".equals(iMap.get("CLS_PARTNER")) ) {
								ifSendFlag = "Y";
							} else {
								ifSendFlag = "T";	
							}
							
						} catch (Exception e) {
							ifSendFlag = "E1";
							log.error("insertPartnerTempKepmp : " + CommonUtil.printStackTraceToString(e));
							throw new Exception("Error");
						}	
					} else {
						log.info("Partner["+iMap.get("CD_PARTNER")+"] is duplicated.");
						ifSendFlag = "D";
					}

					iMap.put("IF_SEND_FLAG", ifSendFlag);
					mpDao.updatePartnerTempKepmp(iMap);
				}
			}
		} catch (Exception e) {
			log.error("createPartnerTempKepmp Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 구매대행(KA)에서 신규 등록된 거래처 은행정보를 EAI에 저장한다.
	 */
	public void createPartnerDepositKepmp() {
		String IF_ID = "";
		int IF_SEQ = 1;
		String ifSendFlag = "";
		ErpKepmpDao mpDao = new ErpKepmpDao();
		Map<String, String> pMap = new HashMap<String, String>();
		String plainTextStr = "";
		
		try {
			List<Map<String,String>> deposits = mpDao.selectPartnerDepositKepmp();
			if (deposits.size() > 0) {

				pMap.clear();
				pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_KA");
				IF_ID = mpDao.selectIfId(pMap);

				for (Map<String,String> iMap : deposits) {

					try {
						iMap.put("IF_ID", IF_ID);
						iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
						/*
						byte[] decrAccount_no = SeedCbcAlgorithmUtil.getBytes(iMap.get("BANK_ACCOUNT_NO"));
						byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrAccount_no, 0, decrAccount_no.length);
						plainTextStr = null;
						if (cbcAlgorithm != null) {
							plainTextStr = new String(cbcAlgorithm).replaceAll("-", "");
						}
						*/
						
						plainTextStr = AWSKMSAlgorithmUtil.decrypt(iMap.get("BANK_ACCOUNT_NO"));
						
						
						if ( !"".equals(plainTextStr) && plainTextStr != null ) {
							iMap.put("NO_DEPOSIT", plainTextStr);
							mpDao.insertPartnerDeposit(iMap);
							ifSendFlag = "Y";
						} else {
							log.error("NO_DEPOSIT is null : ["+iMap.get("SUPPLIER")+"]");
							ifSendFlag = "E";
						}
						
					} catch (Exception e) {
						ifSendFlag = "E2";
						log.error("insertPartnerDepositKepmp : " + CommonUtil.printStackTraceToString(e));
					}

					iMap.put("IF_SEND_FLAG", ifSendFlag);
					mpDao.updatePartnerDepositKepmp(iMap);
				}
			}
		} catch (Exception e) {
			log.error("createPartnerDepositKepmp Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 영업시스템에서 신규로 등록된 거래처 일반정보를  EAI -> ERP 로 전송한다.
	 */
	public void sendPartnerTemp() {
		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpDuzonDao dzDao = new ErpDuzonDao();
		String rtnFlag = "";
		String rtnMsg  = "";
		
		try {
			List<Map<String, String>> partnerTempList = mpDao.selectPartnerTemp();
			
			for (Map<String, String> iMap : partnerTempList) {
				try {
					dzDao.insertPartnerTemp(iMap);	
					rtnFlag = "Y";
					rtnMsg = "SUCCESS.";
				} catch (Exception e) {
					rtnFlag = "E";
					rtnMsg = CommonUtil.printStackTraceToString(e);
				}
				iMap.put("IF_FLAG", rtnFlag);
				iMap.put("IF_MSG", rtnMsg);
				
				mpDao.updatePartnerTemp(iMap);
			}
		} catch (Exception e) {
			log.error("sendPartnerTemp Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * 영업시스템에서 신규로 등록된 거래처 은행정보를  EAI -> ERP 로 전송한다.
	 */
	public void sendPartnerDeposit() {
		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpDuzonDao dzDao = new ErpDuzonDao();
		String rtnFlag = "";
		String rtnMsg  = "";
		
		try {
			List<Map<String, String>> partnerDepositList = mpDao.selectPartnerDeposit();
			
			for (Map<String, String> iMap : partnerDepositList) {
				try {
					dzDao.insertPartnerDeposit(iMap);	
					rtnFlag = "Y";
					rtnMsg = "SUCCESS.";
				} catch (Exception e) {
					rtnFlag = "E";
					rtnMsg = CommonUtil.printStackTraceToString(e);
				}
				iMap.put("IF_FLAG", rtnFlag);
				iMap.put("IF_MSG", rtnMsg);
				
				mpDao.updatePartnerDeposit(iMap);
			}
		} catch (Exception e) {
			log.error("sendPartnerDeposit Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	/**
	 * ERP에서 거래처 은행정보 변경이력이 있을 경우 EAI로 전송한다.
	 */
	public void recvPartnerDepositR() {
		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpDuzonDao dzDao = new ErpDuzonDao();
		String rtnFlag = "";
		
		try {
			List<Map<String, String>> partnerDepositList = dzDao.selectPartnerDepositR();
			
			if (partnerDepositList.size() > 0) {
				for (Map<String,String> iMap : partnerDepositList) {
					try {
						mpDao.insertPartnerDepositR(iMap);	
						rtnFlag = "Y";
					} catch (Exception e) {
						rtnFlag = "E";
						log.debug("Error : " + CommonUtil.printStackTraceToString(e));
					}
					iMap.put("RTN_FLAG", rtnFlag);
					int rtn = dzDao.updatePartnerDepositR(iMap);
					log.debug(rtn);
				}
			}
		} catch (Exception e) {
			log.error("recvPartnerDepositR Error : " + CommonUtil.printStackTraceToString(e));
		}
	}

	/**
	 * ERP에서 변경된 거래처 은행정보를 구매대행 테이블에 반영한다.
	 */
	public void setPartnerDepositR() {
		ErpKepmpDao mpDao = new ErpKepmpDao();
		String rtnFlag = "";
		String st_bank_account_no = "";
		String st_bank_cd = "";
		String st_depositor = "";
		String st_error_msg = "";
		try {
			List<Map<String,String>> partnerDepositRList = mpDao.selectPartnerDepositRKepmp();
			if( partnerDepositRList.size() > 0 ) {
				for(Map<String,String> iMap : partnerDepositRList) {
					
					if ( "I".equals(iMap.get("CD_JOB"))) {
						st_bank_account_no = iMap.get("NO_DEPOSIT");
						st_bank_cd = iMap.get("CD_BANK");
						st_depositor = iMap.get("NM_DEPOSIT");
					} else if ( "U".equals(iMap.get("CD_JOB"))) {
						st_bank_account_no = iMap.get("NO_DEPOSIT_N");
						st_bank_cd = iMap.get("CD_BANK_N");
						st_depositor = iMap.get("NM_DEPOSIT_N");
					}
					
					/*
					byte[] plainText = st_bank_account_no.getBytes();
					byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
					String bszst_bank_account_no = SeedCbcAlgorithmUtil.getString(bszDigest);
					*/
					String bszst_bank_account_no = AWSKMSAlgorithmUtil.encrypt(st_bank_account_no);
					
					iMap.put("BANK_ACCOUNT_NO", bszst_bank_account_no);
					iMap.put("BANK_CD", st_bank_cd);
					iMap.put("DEPOSITOR", st_depositor);
					try {
						int rtn = mpDao.updateACNTSUPL(iMap);
						if (rtn > 0) {
							rtnFlag = "Y";
							st_error_msg = "SUCCESS.";		
						}
						else {
							rtnFlag = "E";
							st_error_msg = "NO_DATA.";
						}
					} catch (Exception e) {
						rtnFlag = "E";
						st_error_msg = e.getMessage();
					}
					iMap.put("IF_FLAG", rtnFlag);
					mpDao.updatePartnerDepositRKepmp(iMap);
				}
			}
		} catch (Exception e) {
			log.error("setPartnerDepositR Error : " + CommonUtil.printStackTraceToString(e));
		}
	}

	/**
	 * 회신받은지 1일 이상 지난 데이터를 삭제한다.
	 */
	public void deletePartnerDepositR() {
		ErpKepmpDao mpDao = new ErpKepmpDao();
		
		try {
			mpDao.deletePartnerDepositRKepmp();
		} catch (Exception e) {
			// TODO: handle exception
			log.error("deletePartnerDepositR:" + CommonUtil.printStackTraceToString(e));
		}
	}

	/**
	 * 건설(SA), 유통(KW) 시스템에서 신규 등록된 거래처 일반정보를 EAI에 저장한다.
	 */
	public void createPartnerTempKepcon() {

		String IF_ID = "";
		int IF_SEQ = 1;
		String ifSendFlag = "";
		String IF_SYSTEM = "";
		
		ErpKepmpDao mpDao = new ErpKepmpDao();
		ErpKepconDao conDao = new ErpKepconDao();
		Map<String, String> pMap = new HashMap<String, String>();
		
		try {
			List<Map<String, String>> partners = conDao.selectPartnerTempKepcon();
			
			if ( partners.size() > 0 ) {
				
				for (Map<String,String> iMap : partners) {

					int chkPartner = mpDao.checkPartnerTemp(iMap);
					
					if ( chkPartner == 0 ) {

						if ( !IF_SYSTEM.equals(iMap.get("IF_SYSTEM")) ) {
							IF_SYSTEM = iMap.get("IF_SYSTEM");
							pMap.clear();
							pMap.put("SEQ_ID", "MAX_ERP_MNG_NO_" + IF_SYSTEM);
							IF_ID = mpDao.selectIfId(pMap);
						}
						
						try {
							iMap.put("IF_ID", IF_ID);
							iMap.put("IF_SEQ", Integer.toString(IF_SEQ++));
							iMap.put("IF_SYSTEM", IF_SYSTEM);
							
							mpDao.insertPartnerTemp(iMap);
							ifSendFlag = "Y";
						} catch (Exception e) {
							ifSendFlag = "E1";
							log.error("createPartnerTempKepcon : " + CommonUtil.printStackTraceToString(e));
							throw new Exception("Error");
						}	
					} else {
						ifSendFlag = "D";
					}

					iMap.put("IF_SEND_FLAG", ifSendFlag);
					conDao.updatePartnerTempKepcon(iMap);
				}
			}
		} catch (Exception e) {
			log.error("createPartnerTempKepmp Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
}
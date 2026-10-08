package com.kep.monthclosing.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

@SuppressWarnings("unchecked")
public class MonthClosingDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	private SqlMapClient sqlMap_kepmp;
	private SqlMapClient sqlMap_kepcon;
	private SqlMapClient sqlMap_khrm;

	public MonthClosingDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			log.debug("DB1 Connection Starting");
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMap_kepmp = SqlMapClientBuilder.buildSqlMapClient(reader);
			log.debug("DB1 Connection Finishing");

			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_KEPCON_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_KEPCON_Dev.xml";
			}
			log.debug("DB2 Connection Starting");
			Reader reader1 = Resources.getResourceAsReader(source);
			this.sqlMap_kepcon = SqlMapClientBuilder.buildSqlMapClient(reader1);
			log.debug("DB3 Connection Finishing");

			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Erp.xml";
			} else {
				source	= "conf/SqlMapConfig_Erp_Dev.xml";
			}
			log.debug("DB3 Connection Starting");
			Reader reader2 = Resources.getResourceAsReader(source);
			this.sqlMap_khrm = SqlMapClientBuilder.buildSqlMapClient(reader2);
			log.debug("DB3 Connection Finishing");
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public void arCreateKepmp() {
		
		List<Map<String, String>> arList = null;
		
		try {
			
//			sqlMap_kepmp.startTransaction();
//			sqlMap_khrm.startTransaction();

			arList = this.sqlMap_kepmp.queryForList("kepmpArCreateList");
			
			for( Map<String, String> iMap : arList ) {
				
				List<Map<String, Object>> arChk = this.sqlMap_khrm.queryForList("khrmArCount", iMap);
				int ar_cnt = (Integer)arChk.get(0).get("CNT");
				
				if (ar_cnt > 0) {
					iMap.put("CNT", Integer.toString(ar_cnt));
					this.sqlMap_khrm.update("khrmArUpdateForHistory", iMap);
				}
				
				try {
					
					this.sqlMap_khrm.insert("khrmArInsertFromKepmp", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPMP-AR]"+iMap.get("INVOICE_NO")+" is sending.");
				} catch (Exception e2) {
					iMap.put("IF_SEND_FLAG", "E");
					log.error("KhrmDao.arCreateKepmp : " + CommonUtil.printStackTraceToString(e2));
				}
				int cnt = this.sqlMap_kepmp.update("kepmpArUpdateResult", iMap);
				log.debug("arCreateKepmp result : " + cnt + " / " + iMap.get("INVOICE_NO") + " / " + iMap.get("DEPT_CODE")  );
			}
			
//			sqlMap_khrm.commitTransaction();
//			sqlMap_kepmp.commitTransaction();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.arCreateKepmp : " + CommonUtil.printStackTraceToString(e));
//		} finally {
//			try {
//				sqlMap_khrm.endTransaction();
//				sqlMap_kepmp.endTransaction();
//			} catch (Exception e2) {}
		}
	}

	public void arCreateKepcon() {
		
		List<Map<String, String>> arList = null;
		
		try {
			
//			sqlMap_kepcon.startTransaction();
//			sqlMap_khrm.startTransaction();

			arList = this.sqlMap_kepcon.queryForList("kepconArCreateList");
			
			for( Map<String, String> iMap : arList ) {
				/**
				 * 1. check dup data 
				 *  1-1. update data exist and not process then update history
				 *  1-2. update 
				 * 2. insert khrm
				 * 3. update kepcon
				 */
				
				List<Map<String, Object>> arChk = this.sqlMap_khrm.queryForList("khrmArCount", iMap);
				int ar_cnt = (Integer)arChk.get(0).get("CNT");
				
				if (ar_cnt > 0) {
					iMap.put("CNT", Integer.toString(ar_cnt));
					this.sqlMap_khrm.update("khrmArUpdateForHistory", iMap);
				}
				
				try {
					this.sqlMap_khrm.insert("khrmArInsertFromKepcon", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPCON-AR]"+iMap.get("INVOICE_NO")+" is sending.");
				} catch (Exception e2) {
					iMap.put("IF_SEND_FLAG", "E");
					log.error("KhrmDao.arCreateKepcon : " + CommonUtil.printStackTraceToString(e2));
				}
				
				this.sqlMap_kepcon.update("kepconArUpdateResult", iMap);
			}
			
//			sqlMap_khrm.commitTransaction();
//			sqlMap_kepcon.commitTransaction();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.arCreateKepcon : " + CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				sqlMap_khrm.endTransaction();
				sqlMap_kepcon.endTransaction();
			} catch (Exception e2) {}
		}
	}

	public void arCreatePRMT() {
		
		List<Map<String, String>> arList = null;
		
		try {

			arList	= this.sqlMap_kepmp.queryForList("prmtArCreateList");
			
			for( Map<String, String> iMap : arList ) {
				
				List<Map<String, Object>> arChk = this.sqlMap_khrm.queryForList("khrmArCount", iMap);
				int ar_cnt = (Integer)arChk.get(0).get("CNT");
				
				if (ar_cnt > 0) {
					iMap.put("CNT", Integer.toString(ar_cnt));
					this.sqlMap_khrm.update("khrmArUpdateForHistory", iMap);
				}
				
				try {
					this.sqlMap_khrm.insert("khrmArInsertFromPRMT", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[PRMT-AR]"+iMap.get("INVOICE_NO")+" is sending.");
				} catch (Exception e2) {
					iMap.put("IF_SEND_FLAG", "E");
					log.error("KhrmDao.arCreatePRMT : " + CommonUtil.printStackTraceToString(e2));
				}
				int cnt = this.sqlMap_kepmp.update("prmtArUpdateResult", iMap);
				log.debug("arCreatePRMT result : " + cnt + " / " + iMap.get("INVOICE_NO") + " / " + iMap.get("DEPT_CODE")  );
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.arCreatePRMT : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void apCreateKepmp() {
		List<Map<String, String>> apList = null;
		int idx	= 0;
		
		try {
			
//			sqlMap_kepmp.startTransaction();
//			sqlMap_khrm.startTransaction();

			apList = this.sqlMap_kepmp.queryForList("kepmpApCreateList");
			
			for( Map<String, String> iMap : apList ) {
				idx++;
				/**
				 * 1. check dup data 
				 *  1-1. update data exist and not process then update history
				 *  1-2. update 
				 * 2. insert khrm
				 * 3. update kepmp
				 */
				
				List<Map<String, Object>> apChk = this.sqlMap_khrm.queryForList("khrmApCount", iMap);
				int ap_cnt = (Integer)apChk.get(0).get("CNT");
				
				if (ap_cnt > 0) {
					iMap.put("CNT", Integer.toString(ap_cnt));
					this.sqlMap_khrm.update("khrmApUpdateForHistory", iMap);
				}
				
				try {
					this.sqlMap_khrm.insert("khrmApInsertFromKepmp", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPMP-AP-"+idx+"]"+iMap.get("INVOICE_NO")+" is sending.");
				} catch (Exception e2) {
					iMap.put("IF_SEND_FLAG", "E");
					log.error("KhrmDao.apCreate[kepmp] : " + CommonUtil.printStackTraceToString(e2));
				}
				
				this.sqlMap_kepmp.update("kepmpApUpdateResult", iMap);
				
			}
			
//			sqlMap_kepmp.commitTransaction();
//			sqlMap_khrm.commitTransaction();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.apCreateKepmp : " + CommonUtil.printStackTraceToString(e));
//		} finally {
//			try {
//				sqlMap_kepmp.endTransaction();
//				sqlMap_khrm.endTransaction();
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
		}
	}
	
	public void apCreateKepcon() {
		
		List<Map<String, String>> apList = null;
		
		try {
			
//			sqlMap_kepcon.startTransaction();
//			sqlMap_khrm.startTransaction();

			apList = this.sqlMap_kepcon.queryForList("kepconApCreateList");
			
			for( Map<String, String> iMap : apList ) {
				/**
				 * 1. check dup data 
				 *  1-1. update data exist and not process then update history
				 *  1-2. update 
				 * 2. insert khrm
				 * 3. update kepcon
				 */
				
				List<Map<String, Object>> apChk = this.sqlMap_khrm.queryForList("khrmApCount", iMap);
				int ap_cnt = (Integer)apChk.get(0).get("CNT");
				
				if (ap_cnt > 0) {
					iMap.put("CNT", Integer.toString(ap_cnt));
					this.sqlMap_khrm.update("khrmApUpdateForHistory", iMap);
				}
				
				try {
					this.sqlMap_khrm.insert("khrmApInsertFromKepcon", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPCON-AP]"+iMap.get("INVOICE_NO")+" is sending.");
				} catch (Exception e2) {
					iMap.put("IF_SEND_FLAG", "E");
					log.error("KhrmDao.apCreateKepcon[kepcon] : " + iMap.get("INVOICE_NO") +"\n" + CommonUtil.printStackTraceToString(e2));
				}				
				
				this.sqlMap_kepcon.update("kepconApUpdateResult", iMap);
			}
			
//			sqlMap_kepcon.commitTransaction();
//			sqlMap_khrm.commitTransaction();
			
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.apCreateKepcon : " + CommonUtil.printStackTraceToString(e));
//		} finally {
//			try {
//				sqlMap_kepcon.endTransaction();
//				sqlMap_khrm.endTransaction();
//			} catch (Exception e2) { }
		}
	}

	public void apCreatePRMT() {
		
		List<Map<String, String>> apList = null;
		
		try {

			apList = this.sqlMap_kepmp.queryForList("kepmpApCreateList");
			
			for( Map<String, String> iMap : apList ) {
				/**
				 * 1. check dup data 
				 *  1-1. update data exist and not process then update history
				 *  1-2. update 
				 * 2. insert khrm
				 * 3. update kepmp
				 */
				
				List<Map<String, Object>> apChk = this.sqlMap_khrm.queryForList("khrmApCount", iMap);
				int ap_cnt = (Integer)apChk.get(0).get("CNT");
				
				if (ap_cnt > 0) {
					iMap.put("CNT", Integer.toString(ap_cnt));
					this.sqlMap_khrm.update("khrmApUpdateForHistory", iMap);
				}
				
				try {
					this.sqlMap_khrm.insert("khrmApInsertFromPRMT", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPMP-AP]"+iMap.get("INVOICE_NO")+" is sending.");
				} catch (Exception e2) {
					iMap.put("IF_SEND_FLAG", "E");
					log.error("KhrmDao.apCreatePRMT[kepmp] : " + CommonUtil.printStackTraceToString(e2));
				}
				
				this.sqlMap_kepmp.update("prmtApUpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.apCreatePRMT : " + CommonUtil.printStackTraceToString(e));
		}
	}

	public void arCancelKepmp() {
		
		List<Map<String, String>> arCancelList = null;
		
		try {

			arCancelList	= sqlMap_khrm.queryForList("khrmArCancelListForKepmp");
			
			for(Map<String, String> iMap : arCancelList) {
				try {				
					sqlMap_kepmp.update("kepmpArUpdateCancel", iMap);
					iMap.put("IF_SEND_RESULT", "OK");
					log.info("[KEPMP-AR]"+iMap.get("INVOICE_NO")+" is canceled.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_RESULT", "FAIL");
					e1.printStackTrace();
					log.error("KhrmDao.arCancelKepmp : " + CommonUtil.printStackTraceToString(e1));
				}
				sqlMap_khrm.update("khrmArUpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.arCancelKepmp : " + CommonUtil.printStackTraceToString(e));
		}
	}

	public void arCancelKepcon() {
		
		List<Map<String, String>> arCancelList = null;
		
		try {
			
			arCancelList	= sqlMap_khrm.queryForList("khrmArCancelListForKepcon");
			
			for(Map<String, String> iMap : arCancelList) {
				try {
					sqlMap_kepcon.update("kepconArUpdateCancel", iMap);
					iMap.put("IF_SEND_RESULT", "OK");
					log.info("[KEPCON-TS]"+iMap.get("INVOICE_NO")+" is canceled.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_RESULT", "FAIL");
					e1.printStackTrace();
					log.error("KhrmDao.arCancelKepcon : " + CommonUtil.printStackTraceToString(e1));
				}
				sqlMap_khrm.update("khrmArUpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.arCancelKepcon : " + CommonUtil.printStackTraceToString(e));
		}
	}

	public void arCancelPRMT() {
		
		List<Map<String, String>> arCancelList = null;
		
		try {
			
			arCancelList	= sqlMap_khrm.queryForList("khrmArCancelListForPRMT");
			
			for(Map<String, String> iMap : arCancelList) {
				try {				
					sqlMap_kepmp.update("prmtArUpdateCancel", iMap);
					iMap.put("IF_SEND_RESULT", "OK");
					log.info("[PRMT-PR]"+iMap.get("INVOICE_NO")+" is canceled.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_RESULT", "FAIL");
					e1.printStackTrace();
					log.error("KhrmDao.arCancelPRMT : " + CommonUtil.printStackTraceToString(e1));
				}
				sqlMap_khrm.update("khrmArUpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.arCancelPRMT : " + CommonUtil.printStackTraceToString(e));
		}
	}

	public void apCancelKepmp() {

		List<Map<String, String>> apCancelList = null;
		
		try {
			
			apCancelList	= sqlMap_khrm.queryForList("khrmApCancelListForKepmp");
			
			for(Map<String, String> iMap : apCancelList) {
				try {
					sqlMap_kepmp.update("kepmpApUpdateCancel", iMap);
					iMap.put("IF_SEND_RESULT", "OK");
					log.info("[KEPMP-AP]"+iMap.get("INVOICE_NO")+" is canceled.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_RESULT", "FAIL");
					e1.printStackTrace();
					log.error("KhrmDao.apCancelKepmp : " + CommonUtil.printStackTraceToString(e1));
				}
				sqlMap_khrm.update("khrmApUpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.apCancelKepmp : " + CommonUtil.printStackTraceToString(e));
		}
	}

	public void apCancelKepcon() {

		List<Map<String, String>> apCancelList = null;
		
		try {
			
			apCancelList	= sqlMap_khrm.queryForList("khrmApCancelListForKepcon");
			
			for(Map<String, String> iMap : apCancelList) {
				try {
					sqlMap_kepcon.update("kepconApUpdateCancel", iMap);
					iMap.put("IF_SEND_RESULT", "OK");
					log.info("[KEPCON-TP]"+iMap.get("INVOICE_NO")+" is canceled.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_RESULT", "FAIL");
					e1.printStackTrace();
					log.error("KhrmDao.apCancelKepcon : " + CommonUtil.printStackTraceToString(e1));
				}
				sqlMap_khrm.update("khrmApUpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.apCancelKepcon : " + CommonUtil.printStackTraceToString(e));
		}
	}

	public void apCancelPRMT() {

		List<Map<String, String>> apCancelList = null;
		
		try {
			
			apCancelList	= sqlMap_khrm.queryForList("khrmApCancelListForPRMT");
			
			for(Map<String, String> iMap : apCancelList) {
				try {
					sqlMap_kepmp.update("prmtApUpdateCancel", iMap);
					iMap.put("IF_SEND_RESULT", "OK");
					log.info("[PRMT-PP]"+iMap.get("INVOICE_NO")+" is canceled.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_RESULT", "FAIL");
					e1.printStackTrace();
					log.error("KhrmDao.apCancelPRMT : " + CommonUtil.printStackTraceToString(e1));
				}
				sqlMap_khrm.update("khrmApUpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.apCancelPRMT : " + CommonUtil.printStackTraceToString(e));
		}
	}

	public void sendTaccount() {
		
		List<Map<String, Object>> ta1List	= null;
		List<Map<String, Object>> ta2List	= null;
		
		try {
			ta1List = sqlMap_khrm.queryForList("khrmTAccountHis1List");
			
			for(Map<String, Object> iMap : ta1List) {

				try {
					sqlMap_kepmp.insert("kepmpTAccountHis1Insert", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPMP-TA1]"+iMap.get("HIS_ID")+" / "+iMap.get("ACCOUNT_NO")+" is sending.");   
				} catch (Exception e1) {
					iMap.put("IF_SEND_FLAG", "E");
					e1.printStackTrace();
					log.error("KhrmDao.sendTaccount[TA1] : " + CommonUtil.printStackTraceToString(e1));
				}
				
				sqlMap_khrm.update("khrmTAccountHis1UpdateResult", iMap);
			}
			
			ta2List	= sqlMap_khrm.queryForList("khrmTAccountHis2List");
			
			for(Map<String, Object> iMap : ta2List) {

				try {
					sqlMap_kepmp.insert("kepmpTAccountHis2Insert", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPMP-TA2]"+iMap.get("HIS_ID")+" / "+iMap.get("ACCOUNT_NO")+" is sending.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_FLAG", "E");
					e1.printStackTrace();
					log.error("KhrmDao.sendTaccount[TA2] : " + CommonUtil.printStackTraceToString(e1));
				}
				
				sqlMap_khrm.update("khrmTAccountHis2UpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.sendTaccount" + CommonUtil.printStackTraceToString(e));
		}
	}

	public void sendTbill() {
		
		List<Map<String, Object>> tb1List	= null;
		List<Map<String, Object>> tb2List	= null;
		
		try {
			tb1List = sqlMap_khrm.queryForList("khrmTBillHis1List");
			
			for(Map<String, Object> iMap : tb1List) {

				try {
					sqlMap_kepmp.insert("kepmpTBillHis1Insert", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPMP-TB1]"+iMap.get("HIS_ID")+" / "+iMap.get("ORIGINAL_ACCOUNT_NO")+" is sending.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_FLAG", "E");
					e1.printStackTrace();
					log.error("KhrmDao.sendTbill[TB1] : " + CommonUtil.printStackTraceToString(e1));
				}
				
				sqlMap_khrm.update("khrmTBillHis1UpdateResult", iMap);
			}
			
			tb2List	= sqlMap_khrm.queryForList("khrmTBillHis2List");
			
			for(Map<String, Object> iMap : tb2List) {

				try {
					sqlMap_kepmp.insert("kepmpTBillHis2Insert", iMap);
					iMap.put("IF_SEND_FLAG", "Y");
					log.info("[KEPMP-TB2]"+iMap.get("HIS_ID")+" / "+iMap.get("ORIGINAL_ACCOUNT_NO")+" is sending.");
				} catch (Exception e1) {
					iMap.put("IF_SEND_FLAG", "E");
					e1.printStackTrace();
					log.error("KhrmDao.sendTbill[TB1] : " + CommonUtil.printStackTraceToString(e1));
				}
				
				sqlMap_khrm.update("khrmTBillHis2UpdateResult", iMap);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.sendTbill" + CommonUtil.printStackTraceToString(e));
		}
	}

	public void sendCode() {
		
		List<Map<String,String>> c24List = null;
		List<Map<String,String>> c25List = null;
		List<Map<String,String>> etList = null;
		List<Map<String,String>> prtnList = null;
		
		try {

			c24List	= sqlMap_khrm.queryForList("khrmC24List");
			for(Map<String, String> iMap : c24List) {
				iMap.put("CODE_NO","H024");
				try {
					sqlMap_kepcon.update("kepconCodeMergeInfo", iMap);
					log.info("H024 : " + iMap.get("V_CODE"));
				} catch (Exception e1) {
					log.error("KhrmDao.sendCode[H024] : " + CommonUtil.printStackTraceToString(e1));
				}
			}
			
			c25List	= sqlMap_khrm.queryForList("khrmC25List");
			for(Map<String, String> iMap : c25List) {
				iMap.put("CODE_NO","H025");
				try {
					sqlMap_kepcon.update("kepconCodeMergeInfo", iMap);
					log.info("H025 : " + iMap.get("V_CODE"));
				} catch (Exception e1) {
					log.error("KhrmDao.sendCode[H025] : " + CommonUtil.printStackTraceToString(e1));
				}
			}
			
			etList	= sqlMap_khrm.queryForList("khrmETList");
			for(Map<String, String> iMap : etList) {
				try {
					sqlMap_kepcon.update("kepconETMergeInfo", iMap);
					log.info("ET : " + iMap.get("V_PAY_CND_CD") + " / " + iMap.get("V_SITE_NM") + " / " + iMap.get("V_CSTMR_NM"));
				} catch (Exception e1) {
					log.error("KhrmDao.sendCode[ET] : " + CommonUtil.printStackTraceToString(e1));
				}
			}
			
			prtnList	= sqlMap_khrm.queryForList("khrmPRTNList");
			for(Map<String, String> iMap : prtnList) {
				try {
					sqlMap_kepcon.update("kepconPRTNMergeInfo", iMap);
					log.info("PRTN : " + iMap.get("V_PARTNER_ID") + " / " + iMap.get("V_PAYMENT_TERM"));
				} catch (Exception e1) {
					log.error("KhrmDao.sendCode[PRTN] : " + CommonUtil.printStackTraceToString(e1));
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("KhrmDao.sendCode" + CommonUtil.printStackTraceToString(e));
		}
	}
}

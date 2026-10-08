package com.kep.josu.service;

import java.math.BigDecimal;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.amazonaws.auth.policy.Statement;
import com.amazonaws.services.athena.model.ResultSet;
import com.amazonaws.services.codestarconnections.model.Connection;
import com.kep.josu.dao.JosuBudgetDao;
import com.kep.josu.dao.JosuBudgetDaoImpl;
import com.kep.josu.dao.JosuKepmpDao;
import com.kep.josu.dao.JosuKepmpDaoImpl;
import com.kep.josu.dao.JosuPoDao;
import com.kep.josu.dao.JosuPoDaoImpl;

public class BudgetSendServiceImpl implements BudgetSendService {

	private Logger log = Logger.getLogger(this.getClass().getName());

	@Override
	public void execute() {
		JosuPoDao josuPoDao = new JosuPoDaoImpl();
		JosuKepmpDao kepDao = new JosuKepmpDaoImpl();

		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMdd");
		Calendar c1 = Calendar.getInstance();
		String TODAYDATE = dFormat.format(c1.getTime());
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());

		java.sql.Connection con =null;
		CallableStatement pstmt = null;
		ResultSet re= null;
		try {
			List<Map<String, Object>> bdgtHdList = kepDao.selectbdgtSendListHd();
			if (bdgtHdList != null && bdgtHdList.size() > 0) {
				for (int i = 0; i < bdgtHdList.size(); i++) {
					String status = (String) bdgtHdList.get(i).get("STATUS");
					List<Map<String, Object>> bdgtList = kepDao.selectbdgtSendList(bdgtHdList.get(i));
					if (bdgtList != null && bdgtList.size() > 0) {
						for (int j = 0; j < bdgtList.size(); j++) {
							try {
								int AMT = Integer.parseInt(bdgtList.get(j).get("ITEM_AMT").toString());
								int UNITPRICE = Integer.parseInt(bdgtList.get(j).get("UNIT_PRICE").toString());
								int PRSEQ = Integer.parseInt(bdgtList.get(j).get("PR_SEQ").toString());
								int ITEMQTY = Integer.parseInt(bdgtList.get(j).get("ITEM_QTY").toString());
								int result = 0;
								String msg ="";
								BigDecimal oexeAmt = BigDecimal.valueOf(0);
								BigDecimal octlAmt = BigDecimal.valueOf(0);
								BigDecimal ovirAmt = BigDecimal.valueOf(0);
								
								try {
									Class.forName("com.ibm.as400.access.AS400JDBCDriver").newInstance();
									con = DriverManager.getConnection("jdbc:as400://174.100.87.41:8471/AFIS","kep","a123123");
									pstmt = con.prepareCall("{CALL SP_BGT_UPDATE_BUY(?,?,?,?,?,?,?,?,?,?,?) }");
									
									pstmt.setString(1, (String) bdgtList.get(j).get("PLANT"));
									pstmt.setString(2, (String) bdgtList.get(j).get("IBGT_YM"));
									pstmt.setString(3, (String) bdgtList.get(j).get("BUDGET_DEPT"));
									pstmt.setString(4, (String) bdgtList.get(j).get("ACCOUNT_TYPE"));
									pstmt.setInt(5, AMT);
								
									pstmt.registerOutParameter(6, Types.CHAR);
									pstmt.registerOutParameter(7, Types.DECIMAL);
									pstmt.registerOutParameter(8, Types.DECIMAL);
									pstmt.registerOutParameter(9, Types.DECIMAL);
									pstmt.registerOutParameter(10, Types.INTEGER);
									pstmt.registerOutParameter(11, Types.VARCHAR);
									
									boolean flag = pstmt.execute();
									log.info("pstmt"+"OSTND"+pstmt.getString(6)+"OEXE_AMT"+pstmt.getBigDecimal(7)+"OCTL_AMT"+pstmt.getBigDecimal(8)+"OVIR_AMT"+pstmt.getBigDecimal(9)+"ORTN_VAL"+pstmt.getInt(10)+"ORTN_MSG"+pstmt.getString(11));
									result = pstmt.getInt(10);
									msg = pstmt.getString(11);
									oexeAmt = pstmt.getBigDecimal(7);
									octlAmt  = pstmt.getBigDecimal(8);
									ovirAmt  = pstmt.getBigDecimal(9);
								}catch (Exception e) {
									con.rollback();
									pstmt.close();
									bdgtList.get(j).put("IF_FLAG", "E");
									bdgtList.get(j).put("IF_MSG", "조선호텔 프로시져 호출 중 오류");
									kepDao.updateIfFlag(bdgtList.get(j));
									e.printStackTrace();
								} finally {
									con.commit();
									if(pstmt != null) {
										pstmt.close();
										
									}
									if(con != null) {
										con.close();
									}
								}
								
								if (result == 1) { //성공 
									bdgtList.get(j).put("IF_MSG", "조선호텔 PODT 생성 중 오류");
									if (bdgtList.get(j).get("STATUS").equals("C")) { //생성 
										bdgtList.get(j).put("IAMT", AMT);
										bdgtList.get(j).put("IAMTTEX", Math.round(AMT*0.1));
										bdgtList.get(j).put("UNITPRICE", UNITPRICE);
										bdgtList.get(j).put("POSTT", "41");
										bdgtList.get(j).put("PRSEQ", PRSEQ);
										bdgtList.get(j).put("ITEMQTY", ITEMQTY);
										bdgtList.get(j).put("TODAY", TODAYDATE);
										josuPoDao.insertPodt(bdgtList.get(j));
					
										if(bdgtList.size() == j+1) {
											bdgtList.get(j).put("IF_MSG", "조선호텔 POHD 생성 중 오류");
											josuPoDao.insertPohd(bdgtList.get(j));
										}
										
									} else if (bdgtList.get(j).get("STATUS").equals("D")) { //삭제 
										bdgtList.get(j).put("IF_MSG", "조선호텔 PODT 업데이터 중 오류");
										bdgtList.get(j).put("POSTT", "89");
										bdgtList.get(j).put("IAMT", AMT);
										bdgtList.get(j).put("PRSEQ", PRSEQ);
										bdgtList.get(j).put("UNITPRICE", UNITPRICE);
										
										josuPoDao.updatePodt(bdgtList.get(j));
									
										int totCnt = josuPoDao.selectPoCnt(bdgtList.get(j));
										if(totCnt == 0) {
											bdgtList.get(j).put("IF_MSG", "조선호텔 POHD 업데이터 중 오류");
											josuPoDao.updatePohd(bdgtList.get(j));
										}
									}
									bdgtList.get(j).put("IF_FLAG", "Y");
									bdgtList.get(j).put("IF_MSG", "");
								}else if(result == -1) { 
									bdgtList.get(j).put("IF_FLAG", "E");
									bdgtList.get(j).put("IF_MSG", "예산 초과 오류");
								}else { 
									bdgtList.get(j).put("IF_FLAG", "E");
									bdgtList.get(j).put("IF_MSG", "조선호텔 프로시져 호출 중 오류");
								}
								bdgtList.get(j).put("RESULT_FLAG", result);
								bdgtList.get(j).put("RESULT_MSG", msg);
								bdgtList.get(j).put("AMT01", oexeAmt);
								bdgtList.get(j).put("AMT02", octlAmt);
								bdgtList.get(j).put("AMT03", ovirAmt);
								
								kepDao.updateIfFlag(bdgtList.get(j));
					
							}catch (Exception e) {
								bdgtList.get(j).put("IF_FLAG", "E");
								kepDao.updateIfFlag(bdgtList.get(j));
								e.printStackTrace();
								log.error("josun errr!!!! : " + e.getMessage());
							}
						}
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("josun !!!! db conn errr!!!! : " + e.getMessage());
		}

	}

}

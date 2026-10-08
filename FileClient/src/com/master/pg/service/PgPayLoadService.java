package com.master.pg.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.master.pg.dao.PgPayDao;

public class PgPayLoadService extends FileService implements Runnable  {
	private PgPayDao dao = new PgPayDao();
	@Override
	public void run() {
		boolean isBreak = false;
		
		try {
			System.out.println("kep_start!!!!!!");
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			List<String> fList = fUtil.getFileList(path, prefix);
			
			if (fList.size() > 0) {
				for(String fName : fList) {
					try {
						logInfo("file info : " + path + "/" + fName);
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						int lineCnt = 0;
						int totCnt = 0;
						int t_gr_amt = 0;
						int tot_amt = 0;
						this.rMaps.clear();
						
						for(String line : fContent) {
							Map<String, String> iMap = convertStringToMap_PG_PGPay(line);
							String gubun = iMap.get("RECORD_SECT");
							logDebug("Kep!!!!!! " + gubun );
							if("D".equals(gubun)) {
								lineCnt++;
								
								Map<String, String> tMap = new HashMap<String,String>();
								tMap.put("TRADE_DT",iMap.get("TRADE_DT"));
								tMap.put("ORI_TRADE_DT",iMap.get("ORI_TRADE_DT"));
								tMap.put("GUBUN",iMap.get("GUBUN"));
								tMap.put("KCP_TRADE_NO",iMap.get("KCP_TRADE_NO"));
								tMap.put("ORDER_NO",iMap.get("ORDER_NO"));
								tMap.put("PAYMENT_AMT",iMap.get("PAYMENT_AMT"));
								tMap.put("CHARGE",iMap.get("CHARGE"));
								tMap.put("CHARGE_NO_INTEREST",iMap.get("CHARGE_NO_INTEREST"));
								tMap.put("TAX_AMT",iMap.get("TAX_AMT"));
								tMap.put("ESCRO_CHARGE",iMap.get("ESCRO_CHARGE"));
								tMap.put("ESCRO_TAX",iMap.get("ESCRO_TAX"));
								tMap.put("ACCOUNT_AMT",iMap.get("ACCOUNT_AMT"));
								tMap.put("CLOSE_DT",iMap.get("CLOSE_DT"));
								tMap.put("ACCOUNT_DT",iMap.get("ACCOUNT_DT"));
								tMap.put("MONTH_INSTALLMENT_CNT",iMap.get("MONTH_INSTALLMENT_CNT"));
								tMap.put("CONFIRM_NO",iMap.get("CONFIRM_NO"));
								tMap.put("CARD_COM_CODE",iMap.get("CARD_COM_CODE"));
								tMap.put("BRANCH_NO",iMap.get("BRANCH_NO"));
								tMap.put("ITEM_NO",iMap.get("ITEM_NO"));
								tMap.put("CARD_PAY_AMT",iMap.get("CARD_PAY_AMT"));
								tMap.put("CARD_PAY_CHARGE",iMap.get("CARD_PAY_CHARGE"));
								tMap.put("PAYCO_PAY_AMT",iMap.get("PAYCO_PAY_AMT"));
								tMap.put("PAYCO_PAY_CHARGE",iMap.get("PAYCO_PAY_CHARGE"));
								tMap.put("CARD_POINT_PAY_AMT",iMap.get("CARD_POINT_PAY_AMT"));
								tMap.put("CARD_POINT_PAY_CHARGE",iMap.get("CARD_POINT_PAY_CHARGE"));
								tMap.put("POINT_CHARGE",iMap.get("POINT_CHARGE"));
								tMap.put("SIMPLE_PAY_GUBUN",iMap.get("SIMPLE_PAY_GUBUN"));
								tMap.put("SIMPLE_PAY_CHARGE",iMap.get("SIMPLE_PAY_CHARGE"));
								tMap.put("PARCIAL_CANCEL_SEQ",iMap.get("PARCIAL_CANCEL_SEQ"));
								tMap.put("CHARGE_BACK_FLAG",iMap.get("CHARGE_BACK_FLAG"));
								tMap.put("NO_INTEREST_INSTALLMENT_FLAG",iMap.get("NO_INTEREST_INSTALLMENT_FLAG"));
								tMap.put("EX_1",iMap.get("EX_1"));
								tMap.put("EX_2",iMap.get("EX_2"));
								tMap.put("EX_3",iMap.get("EX_3"));
								tMap.put("EX_3",iMap.get("EX_3"));
								
	//							tot_amt += Integer.parseInt(iMap.get("GR_AMT"));
								
								this.rMaps.add(tMap);
							} else {
	//							totCnt = Integer.parseInt(iMap.get("TOT_CNT").trim());
	//							t_gr_amt = Integer.parseInt(iMap.get("T_GR_AMT").trim());
							}
						}
						
						if (lineCnt > 0) {
							// 정상 처리
							for(Map<String,String> item : this.rMaps) {
								dao.insertPGCreditList(item);
							}
						} else {
							// 비정상 처리.
							// logWrite 기능 추가 여부 확인...
							logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
							isBreak = true;
						}
						// move back
						fUtil.moveBack(path, fName);
						logInfo("file Success : " + fName);
						// 정지여부.
						if (isBreak) break;
					} catch (Exception e) {
						logError(CommonUtil.printStackTraceToString(e));
						logInfo(CommonUtil.printStackTraceToString(e));
					}
				}
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			logInfo(CommonUtil.printStackTraceToString(e));
		}
	}
}

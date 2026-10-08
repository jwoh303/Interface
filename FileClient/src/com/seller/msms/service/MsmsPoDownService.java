package com.seller.msms.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.seller.msms.dao.MsmsPoDao;

public class MsmsPoDownService extends FileService implements Runnable {
	private MsmsPoDao dao = new MsmsPoDao();
	
	@Override
	public void run() {
		
		try {	
			int cnt = dao.DBDispatcher();
			
			if (cnt > 0) {
				
				List<Map<String, String>> trxl = dao.TRXL_Select();
				List<String> fData = new ArrayList<String>();
				
				for( Map<String, String> tMap : trxl) {
					try {
						List<Map<String, String>> pohd = dao.POHD_Select(tMap);
						dao.POHD_SendUpdate(tMap);
						dao.TRXL_Delete(tMap);
						
						String filename = "";
						String filenameP = "";
						int linecnt = 0 ;
						fData.clear();
						
						for (Map<String, String> iMap : pohd) {
							linecnt++;
							System.out.println("iMap = " + iMap);
							iMap.put("GUBUN","D");
							iMap.put("ITEM_QTY", String.valueOf(iMap.get("ITEM_QTY")));
							iMap.put("AGENT_PRICE", String.valueOf(iMap.get("AGENT_PRICE")));
							iMap.put("UNIT_PRICE", String.valueOf(iMap.get("UNIT_PRICE")));
							
							if (linecnt == 1) {
								
								SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
								Date time = new Date();
								String ntime = dFormat.format(time);
						
								filename = hdInfo.get("PREFIX") + iMap.get("BUYER") + iMap.get("PO_NO") + ntime + ".txt" ;
								filenameP= "P" + hdInfo.get("PREFIX") + iMap.get("BUYER") + iMap.get("PO_NO") + ntime + ".txt" ;
							}
							
							Map<String,String> pMap = dao.REQ_Info(iMap);
							
							if (pMap == null) {
								iMap.put("REQ_DEPT"," ");
								iMap.put("REQ_MOB", " ");
							} else {
								iMap.put("REQ_DEPT",pMap.get("REQ_DEPT"));
								iMap.put("REQ_MOB",pMap.get("REQ_MOB"));
							}
							
							Map<String,String> pMap2 = dao.ADD_Info(iMap);
							
							iMap.put("V_CNT",pMap2.get("V_CNT"));
							iMap.put("ADD_ZIP",pMap2.get("ADD_ZIP"));
							iMap.put("ADD_NAME",pMap2.get("ADD_NAME"));
							
							if("KRHITE0003".equals(iMap.get("BUYER")) || "KRHITE0004".equals(iMap.get("BUYER")) || "KRHITE0005".equals(iMap.get("BUYER")) || 
							   "KRHITE0006".equals(iMap.get("BUYER")) || "KRDOOS0009".equals(iMap.get("BUYER")) || "FKL10".equals(iMap.get("PUR_ID"))) {
								Map<String,String> pMap3 = dao.COM_Info_IRS(iMap);
								iMap.put("COM_IRS_NO", pMap3.get("COM_IRS_NO"));
								iMap.put("COM_NAME", pMap3.get("COM_NAME"));
								iMap.put("COM_CEO", pMap3.get("COM_CEO"));
								iMap.put("COM_ZIP", pMap3.get("COM_ZIP"));
								iMap.put("COM_ADD", pMap3.get("COM_ADD"));
								iMap.put("COM_INDUSTRY", pMap3.get("COM_INDUSTRY"));
								iMap.put("COM_BUSINESS", pMap3.get("COM_BUSINESS"));
							} else {
								Map<String,String> pMap3 = dao.COM_Info(iMap);
								iMap.put("COM_IRS_NO", pMap3.get("COM_IRS_NO"));
								iMap.put("COM_NAME", pMap3.get("COM_NAME"));
								iMap.put("COM_CEO", pMap3.get("COM_CEO"));
								iMap.put("COM_ZIP", pMap3.get("COM_ZIP"));
								iMap.put("COM_ADD", pMap3.get("COM_ADD"));
								iMap.put("COM_INDUSTRY", pMap3.get("COM_INDUSTRY"));
								iMap.put("COM_BUSINESS", pMap3.get("COM_BUSINESS"));
							}
							
							Map<String,String> pMap4 = dao.getReq(iMap);
							
							iMap.put("REQ_NAME", pMap4.get("REQ_NAME"));
							iMap.put("REQ_TEL", pMap4.get("REQ_TEL"));
							iMap.put("REQ_USER_INFO", pMap4.get("REQ_USER_INFO"));
							
							if("2".equals(iMap.get("PROCESS_TYPE"))) {
								Map<String,String> pMap5 = dao.getHub(iMap);
								iMap.put("HUB_NAME",pMap5.get("HUB_NAME"));
								iMap.put("HUB_ZIP",pMap5.get("HUB_ZIP"));
								iMap.put("HUB_ADD",pMap5.get("HUB_ADD"));
							}
							
							Map<String,String> pMap6 = dao.getKEP(iMap);
							iMap.put("KEP_PM_DEPT_NM", pMap6.get("KEP_PM_DEPT_NM"));
							iMap.put("KEP_PM_PM_NAME", pMap6.get("KEP_PM_NAME"));
							iMap.put("KEP_PM_TEL", pMap6.get("KEP_PM_TEL"));
							iMap.put("KEP_PM_EMAIL", pMap6.get("KEP_PM_EMAIL"));
							
							if("D".equals(iMap.get("STATUS"))) {
								iMap.put("ITEM_QTY", "0");
							}
							iMap.put("KEP_COM_NAME","코리아이플랫폼(주)");
							
							dao.PODT_SendUpdate(iMap);
							
							System.out.println("iMap2 = " + iMap);
							log.info("iMap ::::" + iMap);
							String lData = convertMaptoString_MSMS(iMap);
							fData.add(lData);
							
							//신규 고객사 발생 시 메일 전송 
							int buyerCnt = dao.getBuyerInfo(iMap);
							if(buyerCnt == 0) {
								List<Map<String, String>> mailList = dao.getMailContent(iMap);
								Map<String,String> mailMap =  new HashMap<String,String>();
								log.info("mailMap ::::" + mailMap);
								if (mailList.size() > 0) { //고객사 정보 조회
									String str = "";
									str += "고객 정보 등록 시 필요한 내용 송부해 드립니다.";
									str += "<br><br><br>1. Kep 고객사 코드 : ";
									str += mailList.get(0).get("COM_CODE");
									str += "<br>2. 고객사명(국문/영문) : ";
									str += mailList.get(0).get("COM_NAME");
									str += "<br>3. 사업자 번호: ";
									str += mailList.get(0).get("IRS_NO");
									str += "<br>4. 판매 펀치아웃 적용 유무 : Y";
									str += "<br>5. 담당자: ";
									for (Map<String, String> paramMap : mailList) {
										str +=  paramMap.get("POSITION_GROUP");
										str += ":";
										str +=  paramMap.get("KEP_NAME");
										str += " ";
									}
									mailMap.put("MAIL_CONTENT",str);
									
									dao.insertMail(mailMap);
									dao.insertCode(iMap);
								}
							}
						}
						
						String tail = "T" + hdInfo.get("SPLIT_TYPE") + fData.size() + hdInfo.get("SPLIT_TYPE");
						fData.add(tail);
						
						String charset [] = hdInfo.get("CHARSET").split(",");
						
						fUtil.setFileContent(this.tmpDir, filenameP, fData, charset[0], System.getProperty("line.separator"));
						fUtil.setFileContent(this.tmpDir, filename, fData, charset[1], System.getProperty("line.separator"));
						
						
						boolean isSuccessP = fUtil.moveutil(this.tmpDir + "/" + filenameP , hdInfo.get("FOLDER") + "/" + filenameP);
						boolean isSuccess = fUtil.moveutil(this.tmpDir + "/" + filename , hdInfo.get("FOLDER") + "/BACK/" + filename);
						if (!isSuccess || !isSuccessP)  {
							// 에러 처리.
							logError("File Create Error ["+filename+"]" );
						}
						logInfo("file Success : " + filenameP + "/" + filename );
					} catch (Exception e) {
						logError(CommonUtil.printStackTraceToString(e));
						e.printStackTrace();
					}
				}
				
			}
			
		} catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			e.printStackTrace();
		}
	}
}

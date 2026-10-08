package com.kep.hans.service;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.hans.dao.HansDao;
import com.kep.hans.dao.HansDaoImpl;

public class HansPrSubmitServiceImpl implements HansPrSubmitService {

	private Logger log = Logger.getLogger(this.getClass().getName());

	@Override
	public void execute() throws Exception {
		String apiUrl = CommonProperty.getHans_URL() + "/MRO_SAP_RECV_PO_CREATE";
		HansDao dao = new HansDaoImpl(); 
		HttpURLConnection httpUrlConn = null;

		List<Map<String,Object>> map = dao.selectHansPrTargetList();

		if (map != null && map.size() > 0) {
			for (int i = 0; i < map.size(); i++) {
				
				String ifFlag = "E";
				String ifMsg = "";
				String sendMail = "Y";
				String strContent = "";
				String strEmail = "";
				String strName = "";
				
				List<Map<String,Object>> successList = new ArrayList<Map<String,Object>>();
				//x 로 추가
				try {
					JSONObject jsonObj2 = new JSONObject();
					JSONArray ZKEP_PO = new JSONArray();
					List<Map<String,Object>> pMaps = dao.selectPrList(map.get(i));
					
					int size = pMaps.size();
					if(size > 0) {
						for ( Map<String,Object> iMap : pMaps) {
							JSONObject jsonObj = new JSONObject();
							String userEmail = (String) iMap.get("EMAIL");
							String key = String.valueOf(iMap.get("KEY"));
							log.info("iMap" + iMap.toString());
							
							if(userEmail != null && !strEmail.contains(userEmail) && !userEmail.isEmpty()){
								strEmail += iMap.get("EMAIL")+";";
								strName += iMap.get("REQ_USER_NAME")+";";
							}
							
							String[] arr = key.split("\\^");
							iMap.put("GL_ACCOUT", arr[0]);
							iMap.put("COST_CENTER", arr[1]);
							iMap.put("STORAGE_YN", arr[2]);
							
							jsonObj.put("ZDOC_NUM",iMap.get("ZDOC_NUM"));           //MRO 문서번호
							jsonObj.put("ZDOC_SEQ",iMap.get("ZDOC_SEQ"));			//MRO 문서품목번호
							jsonObj.put("MATNR",iMap.get("MATNR"));        			//자재
							jsonObj.put("TXZ01",iMap.get("TXZ01")); 				//자재내역
							jsonObj.put("MENGE",iMap.get("MENGE"));                 //수량  
							jsonObj.put("MEINS",iMap.get("MEINS"));    				//단위
							jsonObj.put("EEIND",iMap.get("EEIND"));                 //납품예정일
							jsonObj.put("NETPR",iMap.get("NETPR"));     			//단가
							jsonObj.put("PEINH","1");						   		//가격단위
							jsonObj.put("MATKL",iMap.get("MATKL"));					//자재그룹
							jsonObj.put("LGORT","7000");					   		//저장위치 고정값 
							jsonObj.put("AFNAM",iMap.get("AFNAM"));   				//요청자
							jsonObj.put("BEDNR",iMap.get("BEDNR"));          		//추적번호(부서코드)
							
							if("K".equals(arr[2])) {
								jsonObj.put("SAKTO",arr[0]); //GL계정
								jsonObj.put("KOSTL",arr[1]); //코스트센터
								jsonObj.put("KNTTP","K"); //고정값
								jsonObj.put("IDNLF",""); //고정값
							}else if("X".equals(arr[2])) {
								jsonObj.put("SAKTO",arr[0]); //GL계정
								jsonObj.put("KOSTL",arr[1]); //코스트센터
								jsonObj.put("KNTTP","K"); //고정값
								jsonObj.put("IDNLF","포장비"); //고정값
							}else if("Z".equals(arr[2])) {
								jsonObj.put("SAKTO",""); //GL계정
								jsonObj.put("KOSTL",""); //코스트센터
								jsonObj.put("IDNLF","저장품"); //고정값
								jsonObj.put("KNTTP",""); //고정값
							}
							
							
							ZKEP_PO.add(jsonObj);
							
							strContent += "<TR>";
							strContent += "<TD>";
							strContent += iMap.get("BUYER");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("PR_NO");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("PR_SEQ");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("MATNR");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("MEINS");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += String.valueOf(iMap.get("MENGE"));
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += String.valueOf(iMap.get("NETPR"));
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("ACCTASSCAT");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("GL_ACCOUNT");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("COSTCENTER");
							strContent += "</TD>";
							strContent += "</TR>";
							
						}
					}
					
					jsonObj2.put("IT_ITEM", ZKEP_PO);
					
					URL url = new URL(apiUrl);
					httpUrlConn = (HttpURLConnection)url.openConnection();
					
					httpUrlConn.setRequestMethod("POST");
					httpUrlConn.setRequestProperty("Content-Type","application/json; charset=UTF-8");
					httpUrlConn.setDoOutput(true);
					httpUrlConn.setDoInput(true);
					httpUrlConn.setUseCaches(false);
					httpUrlConn.setConnectTimeout(10000); 
					httpUrlConn.setReadTimeout(10000);
					
					OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8");
					wr.write(jsonObj2.toString());
					wr.flush();
					wr.close();
					
					int responseCode = httpUrlConn.getResponseCode();
					StringBuilder sb = new StringBuilder();
					BufferedReader br = null;

					if (responseCode == HttpURLConnection.HTTP_OK) {
						 br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(),"utf-8"));
					} else {
						 br = new BufferedReader(new InputStreamReader(httpUrlConn.getErrorStream(), "utf-8"));

					}	
						
					 String line;
				     while ((line = br.readLine()) != null) {sb.append(line);}
				     br.close();
				     log.info("Hansol Response : " + sb.toString());

				    
				    if (responseCode != HttpURLConnection.HTTP_OK) {throw new Exception(sb.toString());}
				    JSONParser parser = new JSONParser();
				    JSONObject root = (JSONObject) parser.parse(sb.toString());
				    JSONArray etPo = (JSONArray) root.get("ET_PO");
				    JSONArray etReturn = (JSONArray) root.get("ET_RETURN");

				    if (etReturn != null && !etReturn.isEmpty()) {

				        StringBuilder msgBuilder = new StringBuilder();

				        // 첫번째 TYPE으로 성공/실패 판단
				        JSONObject firstItem = (JSONObject) etReturn.get(0);
				        ifFlag = String.valueOf(firstItem.get("TYPE"));

				        for (Object obj : etReturn) {

				            JSONObject item = (JSONObject) obj;

				            if (msgBuilder.length() > 0) {
				                msgBuilder.append(" / ");
				            }

				            msgBuilder.append(String.valueOf(item.get("MESSAGE")));
				        }

				        ifMsg = msgBuilder.toString();
				    }

				    // 성공인 경우에만 PO 정보 저장
				    if ("S".equals(ifFlag) && etPo != null && !etPo.isEmpty()) {

				        for (Object obj : etPo) {

				            JSONObject po = (JSONObject) obj;

				            Map<String,Object> resultMap = new HashMap<String,Object>();

				            resultMap.put("DOC_NO", po.get("ZDOC_NUM"));
				            resultMap.put("DOC_SEQ", po.get("ZDOC_SEQ"));
				            resultMap.put("LEGACY_PO_NO", po.get("EBELN"));
				            resultMap.put("LEGACY_PO_SEQ", po.get("EBELP"));

				            successList.add(resultMap);
				        }
				    }

			} catch (Exception e) {
				  ifFlag = "E";
				  sendMail = "N";
				  if (ifMsg == null || "".equals(ifMsg)) {
					  ifMsg = e.getMessage();
			      }
			      log.error( "Hans PR Interface Error", e);
			} finally {
			        try {
			        	if ("S".equals(ifFlag)) {
			                for (Map<String,Object> resultMap : successList) {
			                	resultMap.put("IF_FLAG", "Y");
			                	resultMap.put("IF_MSG", ifMsg);
			                	resultMap.put("BUYER", "KRHANS0320");
			                    dao.updatePrResult(resultMap);
			                }
			                dao.updateIfProgress(successList);
			            } else {
			                Map<String,Object> errorMap = new HashMap<String,Object>();
			                errorMap.put("DOC_NO", map.get(i).get("DOC_NO"));
			                errorMap.put("IF_FLAG","E");
			                errorMap.put("IF_MSG", ifMsg);
			                errorMap.put("BUYER", "KRHANS0320");
			                dao.updatePrError(errorMap);
			                
			                if("Y".equals(sendMail)) {
			                	List<Map<String,String>> mailMaps = dao.selectMailInfo(errorMap);
								if (mailMaps != null && mailMaps.size() > 0) {
									strName += mailMaps.get(0).get("NAME");
									strEmail += mailMaps.get(0).get("EMAIL");
								}
								String str = "";
								str += "<br><BODY><TABLE border='1'><TR>";
								str += "<TH>고객사</TH>";
								str += "<TH>주문번호</TH>";
								str += "<TH>주문순번</TH>";
								str += "<TH>품목코드(MATNR)</TH>";
								str += "<TH>품목단위(MEINS)</TH>";
								str += "<TH>수량(MENGE)</TH>";
								str += "<TH>단가(NETPR)</TH>";
								str += "<TH>구매종류</TH>";
								str += "<TH>계정(GL_ACCOUNT)</TH>";
								str += "<TH>코스트센터(COSTCENTER)</TH>";
								str += "</TR>";
								str += strContent;
								str += "<TR>";
								str += "<TD>오류내역</TD>";
								str += "<TD colspan = '9'>";
								str += ifMsg;
								str += "</TD>";
								str += "</TR></TABLE></BODY>";
								str += "<br><br>주문 데이터 (주)한솔홈데코 SAP로 전송 시 오류 발생 하였습니다. 확인 부탁드립니다.";
							
								errorMap.put("MAIL_CONTENT", str);
								errorMap.put("MAIL_EMAIL", strEmail);
								errorMap.put("MAIL_NAME", strName);
								
								dao.insertHansMail(errorMap);
			                }
			            }
			        } catch (Exception e) {
			            log.error("DB Update Error", e);
			        } finally {
			            if (httpUrlConn != null) {
			                httpUrlConn.disconnect();
			            }
			        }
			    }
			}
		}	
	}
}
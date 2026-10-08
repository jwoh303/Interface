package com.kep.gsenc.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.gsenc.dao.GsencAppDao;

public class GsencAppService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@SuppressWarnings("unchecked")
	public void execute() {
		GsencAppDao dao = new GsencAppDao();
		
		try {
			
			if ("2".contentEquals(CommonProperty.getDB_CONN())) {
				List<Map<String, String>> appList = dao.selectGsencAppHeaderList();
				
				if (appList.size() > 0) {
					for (Map<String, String> iMap : appList ) {
						
						JSONObject appObj	= new JSONObject();
						JSONObject sUser	= new JSONObject();
						JSONArray aUserArry = new JSONArray();
						JSONObject aUser	= new JSONObject();
						JSONArray formFieldArry = new JSONArray();
						JSONObject formField	= new JSONObject();
						
						List<Map<String, String>> appPathList = dao.selectGsencAppPathList(iMap);
						List<Map<String, Object>> appContentsList = dao.selectGsencAppContentsList(iMap);
						List<Map<String, Object>> appAttachList	= dao.selectGsencAppAttachList(iMap);
						if ( appPathList.size() > 0) {
							
							aUserArry.clear();
							for(Map<String, String> apMap : appPathList) {
								aUser	= new JSONObject();
								aUser.put("UserId",apMap.get("EMP_NO"));
								aUser.put("UserName","");
								aUser.put("DeptId",apMap.get("DEPT_CODE"));
								aUser.put("DeptName","");
								aUser.put("TaskType","1");
								aUser.put("TaskCaption","");
								aUser.put("DegreeId","");
								aUser.put("DegreeName","");
								aUser.put("BizKind",apMap.get("BIZ_KIND"));
								aUser.put("GroupId","1");
								aUser.put("DupId","0");
								aUser.put("TaskOrder","0");
								
								
								if ("1".equals(apMap.get("BIZ_KIND"))) {
									sUser	= new JSONObject();
									sUser.put("UserId", apMap.get("EMP_NO"));
									sUser.put("UserName", "");
									sUser.put("DeptId", apMap.get("DEPT_CODE"));
									sUser.put("DeptName", "");
									sUser.put("DegreeId", "");
									sUser.put("DegreeName", "");
									
									aUser.put("TaskId","100");
								} else if ( "11".equals(apMap.get("BIZ_KIND")) && "Y".equals(apMap.get("LAST_STEP"))) {

									// EVENT_2_0
									formField	= new JSONObject();
									formField.put("FormField", "EVENT_2_0");
									formField.put("Name", "EVENT_2_0");
									formField.put("Value", "https://safety.koreab2b.com:444/login/gsInterfaceApproval2.do?apr_no="+iMap.get("APR_NO")+"&cstmr_id="+iMap.get("CSTMR_ID"));
									formFieldArry.add(formField);
									
									// EVENT_3_0
									formField	= new JSONObject();
									formField.put("FormField", "EVENT_3_0");
									formField.put("Name", "EVENT_3_0");
									formField.put("Value", "https://safety.koreab2b.com:444/login/gsInterfaceApproval2.do?apr_no="+iMap.get("APR_NO")+"&cstmr_id="+iMap.get("CSTMR_ID"));
									formFieldArry.add(formField);

									// EVENT_5_0
									formField	= new JSONObject();
									formField.put("FormField", "EVENT_5_0");
									formField.put("Name", "EVENT_5_0");
									formField.put("Value", "https://safety.koreab2b.com:444/login/gsInterfaceApproval2.do?apr_no="+iMap.get("APR_NO")+"&cstmr_id="+iMap.get("CSTMR_ID"));
									formFieldArry.add(formField);
									
									aUser.put("TaskId","102");
								} else {
									
									aUser.put("TaskId","101");
								}
								
								aUserArry.add(aUser);
							}
							
							String totAmtStt	= "";
							StringBuffer bodys = new StringBuffer();
							bodys.append("<body>");
							bodys.append("<STYLE TYPE='text/css'>table {font-size: 10pt}</STYLE>");
							bodys.append("<table cellPadding='1' cellspacing='0' border='1' width='100%' style='padding:0 0 0 0px ; rules:all ;border:0px; bordercolor:#ffffff;TABLE-LAYOUT: fixed;BORDER-COLLAPSE:collapse;'>"); 
							bodys.append("<tr>");
							bodys.append("<td align=center width='10%' bgcolor='#D3D3D3'><b>No.</td>");
							bodys.append("<td align=center width='50%' bgcolor='#D3D3D3'><b>상품명</td>");
							bodys.append("<td align=center width='15%' bgcolor='#D3D3D3'><b>단가</td>");
							bodys.append("<td align=center width='10%' bgcolor='#D3D3D3'><b>발주수량</td>");
							bodys.append("<td align=center width='15%' bgcolor='#D3D3D3'><b>금액</td>");
							bodys.append("</tr>");
							for(Map<String, Object> bMap : appContentsList) {
								bodys.append("<tr>");
								bodys.append("<td align=center bgcolor='#FFFFFF'><b>"+bMap.get("SEQ")+"</td>");
								bodys.append("<td align=left bgcolor='#FFFFFF'>"+bMap.get("ITEM_DESCRIPTION")+"</td>");
								bodys.append("<td align=right bgcolor='#FFFFFF'>"+bMap.get("UNIT_PRICE")+"</td>");
								bodys.append("<td align=center bgcolor='#FFFFFF'>"+bMap.get("ORDER_QTY")+"</td>");
								bodys.append("<td align=right bgcolor='#FFFFFF'>"+bMap.get("AMOUNT")+"</td>");
								bodys.append("</tr>");
								
								totAmtStt = (String) bMap.get("TOT_AMT");
							}
							bodys.append("<tr>");
							bodys.append("<td align=center width='10%' bgcolor='#D3D3D3'><b>총금액</td>");		
							bodys.append("<td bgcolor='#FFFFFF' colspan = '4' align=right >"+totAmtStt+"</td>");
							bodys.append("</tr>");

							bodys.append("<tr>");
							bodys.append("<td align=center width='10%' bgcolor='#D3D3D3'><b>상신의견</td>");
							bodys.append("<td bgcolor='#FFFFFF' colspan = '4' align=left >"+iMap.get("UP_REMARK")+"</td>");	
							bodys.append("</tr>");
							
							if (appAttachList.size() > 0) {
								int fIdx = 0;
								for(Map<String, Object> fMap : appAttachList) {
									if (fIdx == 0) {
										bodys.append("<tr>");
										bodys.append("<td align=center width='10%' bgcolor='#D3D3D3' rowspan='"+appAttachList.size()+"'><b>첨부파일</td>");
										bodys.append("<td bgcolor='#FFFFFF' colspan = '4' align=left > <a href='https://safety.koreab2b.com:444/main/file/download.do?DOC_NO="+fMap.get("DOC_NO")+"&DOC_SEQ="+fMap.get("DOC_SEQ")+"&TYPE=TEMP'>"+fMap.get("FILENM")+"</a></td>");
										bodys.append("</tr>");		
									} else {
										bodys.append("<tr>");
										bodys.append("<td bgcolor='#FFFFFF' colspan = '4' align=left > <a href='https://safety.koreab2b.com:444/main/file/download.do?DOC_NO="+fMap.get("DOC_NO")+"&DOC_SEQ="+fMap.get("DOC_SEQ")+"&TYPE=TEMP'>"+fMap.get("FILENM")+"</a></td>");
										bodys.append("</tr>");
									}
									fIdx++;
								}
							}
							bodys.append("</table></body>");

							// frfld_DOCBODYNAMES_00
							formField	= new JSONObject();
							formField.put("FormField", "frfld_DOCBODYNAMES_00");
							formField.put("Name", "frfld_DOCBODYNAMES_00");
							formField.put("Value", "소모품 신청현황(KeP)");
							formFieldArry.add(formField);

							// frfld_DOCBODYVALUES_00
							formField	= new JSONObject();
							formField.put("FormField", "frfld_DOCBODYVALUES_00");
							formField.put("Name", "frfld_DOCBODYVALUES_00");
							formField.put("Value", bodys.toString() );
							formFieldArry.add(formField);
							
							// frfld_FormName
							formField	= new JSONObject();
							formField.put("FormField", "frfld_FormName");
							formField.put("Name", "frfld_FormName");
							formField.put("Value", "소모품 신청현황(KeP)");
							formFieldArry.add(formField);
							
							// frfld_Url
							formField	= new JSONObject();
							formField.put("FormField", "frfld_Url");
							formField.put("Name", "frfld_Url");
							formField.put("Value", "");
							formFieldArry.add(formField);
						
//							appObj.put("FormId","REA1-180718102155");
							appObj.put("FormId","REA1-060904111759251");
							appObj.put("Id", "");
							appObj.put("Subject", iMap.get("SUBJECT"));
							appObj.put("FormName", "");
							appObj.put("SystemType", 32);
							appObj.put("TypeStr", "");
							appObj.put("Comment", "");
							appObj.put("SubmitUser", sUser);
							appObj.put("ApprovalUser", aUserArry.toString());
							appObj.put("FormFields", formFieldArry.toString());
							appObj.put("AttachFiles", "[null]");	// new JSONArray()
							appObj.put("ReferenceDocuments", "[null]");
							appObj.put("AttachBodys", "[null]");
							appObj.put("DocumentSettings", "[null]");
							appObj.put("LocaleKey", "ko");

							String appStr	= appObj.toJSONString();
							appStr	= appStr.replaceAll("\"\\[\\{", "\\[\\{");
							appStr	= appStr.replaceAll("\\}\\]\"", "\\}\\]");
							appStr	= appStr.replaceAll("\"\\[null\\]\"", "\\[null\\]");
							appStr	= appStr.replaceAll("\\\\", "");
							
							log.error("appStr Real : " + appStr);
							
							String _url = "http://newiea.gsconst.co.kr/RealEA.API/api/Approval/ApprovalSubmit";
							DefaultHttpClient client = new DefaultHttpClient();
							HttpPost post = new HttpPost(_url);

					        List<NameValuePair> params = new ArrayList<NameValuePair>(); 
					        params.add(new BasicNameValuePair("json", appStr));
							post.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
					        
					        HttpResponse resp = client.execute(post);
					        int rc = resp.getStatusLine().getStatusCode();
				        	HttpEntity entity = resp.getEntity();
				        	String str = EntityUtils.toString(entity);
					        
					        JSONParser jParser = new JSONParser();
					        JSONObject jObj = (JSONObject) jParser.parse(str);

					        log.debug("StatusCode : " + rc);
					        log.debug("ResultCode : " + jObj.get("ResultCode"));
					        log.debug("ResultMessage : " + jObj.get("ResultMessage"));
					        log.debug("DcumentId : " + jObj.get("DcumentId"));
					        
							iMap.put("RESULT_FLAG", "Y");
						} else {
							iMap.put("RESULT_FLAG", "E");
							log.error("GsencAppService Error : ["+iMap.get("ORDR_NO")+"]");
						}
						dao.updateGsencAppResult(iMap);
					}
				}
			} else {
				log.info("WARNING!!! - Error......");
			}
		} catch (Exception e) {
			log.error("GsencAppService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
}
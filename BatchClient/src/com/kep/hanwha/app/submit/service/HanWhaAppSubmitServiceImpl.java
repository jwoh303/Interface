package com.kep.hanwha.app.submit.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.Clob;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.activation.FileDataSource;

import org.apache.log4j.Logger;

import com.hanwha.neo.branch.ss.approval.axisws.ApprovalServiceProxy;
import com.hanwha.neo.branch.ss.approval.vo.WsApAttachFile;
import com.kep.common.CommonUtil;
import com.kep.common.CommonAwsS3;
import com.kep.common.CommonProperty;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.hanwha.app.submit.dao.AppSubmitDao;
import com.kep.hanwha.app.submit.dao.AppSubmitDaoImpl;

public class HanWhaAppSubmitServiceImpl implements HanWhaAppSubmitService{

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@Override
	public void execute() {
		
		AppSubmitDao dao = new AppSubmitDaoImpl();
		
		try {
		
			List<Map<String, String>> targetList	= dao.selectIFTargetList();
			
			if (targetList.size() > 0) {
			
				for (Map<String,String> target : targetList) {
					
					try {
						
						List<Map<String, String>> prList	= dao.selectIFAppPrList(target); // contentbody
						
						Map<String, String> appData	= dao.selectIFAppInfo(target);  // 결재header
						
						List<Map<String,String>> AtchList = dao.selectAtchList(appData); // 첨부파일
						
						//com.hanwhaEagle.neo.branch.ss.approval.vo.WsApAttachFile[] EagleWsAtchList = new com.hanwhaEagle.neo.branch.ss.approval.vo.WsApAttachFile[AtchList.size()];
						com.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile[] cleverseWsAtchList= new com.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile[AtchList.size()];
						
						WsApAttachFile [] WsAtchList = new WsApAttachFile[AtchList.size()];
						
						int j = 0;
						// 첨부파일 구성
						for (Map<String,String> _map : AtchList) {
							String _filename = _map.get("DES_FILE_NAME").toString();
							String _orgFilename = _map.get("SRC_FILE_NAME").toString();
							String _type = _map.get("TYPE").toString();
							String _del_file_dir = _map.get("DES_FILE_DIR").toString();
							String _file_size = String.valueOf(_map.get("FILE_SIZE"));
							String _path = "";
							String img_yn = "N";
							java.io.File file = null;
							FileInputStream fis = null;
							FileOutputStream fos = null;
							
							if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
								_path = CommonUtil.getUploadTypePath(_type, img_yn)+ "/";
							}else{
								_path = CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir+ "/";
							}
							
							if (CommonAwsS3.doesFileExists(_path + _filename)) {
								
								WsApAttachFile atchfile = new WsApAttachFile();
								//com.hanwhaEagle.neo.branch.ss.approval.vo.WsApAttachFile EagleAtchFile = new com.hanwhaEagle.neo.branch.ss.approval.vo.WsApAttachFile();
								com.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile cleverseAtchFile = new com.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile();
								
								if("501".equals(target.get("COMPANYID"))) {
									cleverseAtchFile.setFileName(_orgFilename);
									cleverseAtchFile.setSeqID(j);
									
									File srcFile = CommonAwsS3.download(_path + _filename, _filename);
									
									FileDataSource fds = new FileDataSource(srcFile);
									javax.activation.DataHandler dh = new javax.activation.DataHandler(fds);
									
									cleverseAtchFile.setFileInfo(dh);
									cleverseAtchFile.setFileSize(srcFile.length() + "");
									cleverseWsAtchList[j] = cleverseAtchFile;
									
								} else {
									atchfile.setFileName(_orgFilename);
									atchfile.setSeqID(j);
									
									File srcFile = CommonAwsS3.download(_path + _filename, _filename);
									
									FileDataSource fds = new FileDataSource(srcFile);
									javax.activation.DataHandler dh = new javax.activation.DataHandler(fds);
									
									atchfile.setFileInfo(dh);
									atchfile.setFileSize(srcFile.length() + "");
									
									WsAtchList[j] = atchfile;									
								}
								
							} else {
								log.error("fileCopyS3 : File Not Found [" +_path + _filename + "]");
							}
							j++;
						}
						
						String contents = "";
						// contents header 구성
						String bgcolor = "#D3D3D3";
						
						if("410".equals(target.get("COMPANYID"))) {
							contents = getXml_410(prList,appData);
							appData.put("CONTENTS",contents);
						} else {
							contents = getXml(prList,appData);	
							appData.put("CONTENTS",contents);
						}
						
						dao.insertIfAplSend(appData);
						dao.insertIfApmSend(appData);
						
						Map<String, Object> apmData	= dao.selectAppsendList(appData);
						
						List<Map<String, String>> aplList	= dao.selectAppPassList(apmData);
						List<Map<String, String>> aplList_r	= dao.selectAppPassList_refer(apmData);
						
						//결재선 info
						com.hanwha.neo.branch.ss.approval.vo.SignerInfo[] SignerInfoList = new com.hanwha.neo.branch.ss.approval.vo.SignerInfo[aplList.size()];
						//com.hanwhaEagle.neo.branch.ss.approval.vo.SignerInfo[] EagleSignerInfoList = new com.hanwhaEagle.neo.branch.ss.approval.vo.SignerInfo[aplList.size()];
						com.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo[] cleverseSignerInfoList = new com.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo[aplList.size()];
						
						// 결재선 정보 입력
						if("501".equals(target.get("COMPANYID"))) {
							for(int i = 0 ; i < aplList.size() ; i++) {
								//com.hanwhaEagle.neo.branch.ss.approval.vo.SignerInfo EagleSignerInfo = new com.hanwhaEagle.neo.branch.ss.approval.vo.SignerInfo();
								com.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo cleverseSignerInfo = new com.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo();
								Map<String, String> tMap	= aplList.get(i);
								
								cleverseSignerInfo.setAssignType(Integer.parseInt(tMap.get("APPRACTIONCD"))); //참여자 형대
								cleverseSignerInfo.setSequence(Integer.parseInt(tMap.get("APPRSEQ"))); // 결재순번
								//SignerInfo.setUserkey(tMap.get("USERKEY")); //Circle의 userKey
								cleverseSignerInfo.setUserId(tMap.get("USER_ID")); //Circle의 userID
							
								cleverseSignerInfoList[i] = cleverseSignerInfo;
									
							}
						} else {
							for(int i = 0 ; i < aplList.size() ; i++) {
								com.hanwha.neo.branch.ss.approval.vo.SignerInfo SignerInfo = new com.hanwha.neo.branch.ss.approval.vo.SignerInfo();
								Map<String, String> tMap	= aplList.get(i);
								
								SignerInfo.setAssignType(Integer.parseInt(tMap.get("APPRACTIONCD"))); //참여자 형대
								SignerInfo.setSequence(Integer.parseInt(tMap.get("APPRSEQ"))); // 결재순번
								//SignerInfo.setUserkey(tMap.get("USERKEY")); //Circle의 userKey
								SignerInfo.setUserId(tMap.get("USER_ID")); //Circle의 userID
							
								SignerInfoList[i] = SignerInfo;
									
							}
						}
						
						
						// 결재 정보
						com.hanwha.neo.branch.ss.approval.vo.ApprovalDocument ApprovalDocument = new com.hanwha.neo.branch.ss.approval.vo.ApprovalDocument();
						//com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocument EagleApprovalDocument = new com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocument();
						com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocument cleverseApprovalDocument = new com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocument();
						if("501".equals(target.get("COMPANYID"))) {
							cleverseApprovalDocument.setBodyContent(contents); // 결재본문
							cleverseApprovalDocument.setBodyContentType(1); // 결재타입
							cleverseApprovalDocument.setTitle(prList.get(0).get("LEGACY_PO_NO") + " "+ (String)apmData.get("SUBJECT"));  // 결재제목							
							cleverseApprovalDocument.setMisDocId((String)apmData.get("APPRID"));  // 결재ID
							cleverseApprovalDocument.setSystemId((String)apmData.get("SYSTEMID"));  // systemID
							cleverseApprovalDocument.setFlowCase("customized");  
							cleverseApprovalDocument.setAttachfiles(cleverseWsAtchList); // 첨부파일 정보 
							cleverseApprovalDocument.setCompanyId((String)apmData.get("COMPANYID"));  // 회사ID
							cleverseApprovalDocument.setFormCode((String)apmData.get("FORMCODE"));  // systemID
							cleverseApprovalDocument.setSignerInfos(cleverseSignerInfoList);  // 결재 경로 객체 배열
							if(aplList_r.size() > 0) {
								//com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo[] ReceiverInfoList = new com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo[aplList_r.size()];
								com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo[] cleverseReceiverInfoList = new com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo[aplList_r.size()];
								// 참조 정보 입력
								for(int i = 0 ; i < aplList_r.size() ; i++) {
									//com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo ReceiverInfo = new com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo();
									com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo cleverseReceiverInfo = new com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo();
									Map<String, String> tMap	= aplList_r.get(i);
									
									cleverseReceiverInfo.setRoleType("referer");
									cleverseReceiverInfo.setReceiverId(tMap.get("USER_ID"));
									
									cleverseReceiverInfoList[i] = cleverseReceiverInfo;
									
								}
								
								cleverseApprovalDocument.setReceiverInfos(cleverseReceiverInfoList); // 결재 참조 경로 객체 배열
							}
						} else {
							ApprovalDocument.setBodyContent(contents); // 결재본문
							ApprovalDocument.setBodyContentType(1); // 결재타입
							if("410".equals(target.get("COMPANYID"))) {
								ApprovalDocument.setTitle((String)apmData.get("SUBJECT"));  // 결재제목
							} else {
								ApprovalDocument.setTitle(prList.get(0).get("LEGACY_PO_NO") + " "+ (String)apmData.get("SUBJECT"));  // 결재제목
							}
							ApprovalDocument.setMisDocId((String)apmData.get("APPRID"));  // 결재ID
							ApprovalDocument.setSystemId((String)apmData.get("SYSTEMID"));  // systemID
							ApprovalDocument.setFlowCase("customized");  
							ApprovalDocument.setAttachfiles(WsAtchList); // 첨부파일 정보
							ApprovalDocument.setCompanyId((String)apmData.get("COMPANYID"));  // 회사ID
							ApprovalDocument.setFormCode((String)apmData.get("FORMCODE"));  // systemID
							ApprovalDocument.setSignerInfos(SignerInfoList);  // 결재 경로 객체 배열
							if(aplList_r.size() > 0) {
								com.hanwha.neo.branch.ss.approval.vo.ReceiverInfo[] ReceiverInfoList = new com.hanwha.neo.branch.ss.approval.vo.ReceiverInfo[aplList_r.size()];
								
								// 참조 정보 입력
								for(int i = 0 ; i < aplList_r.size() ; i++) {
									com.hanwha.neo.branch.ss.approval.vo.ReceiverInfo ReceiverInfo = new com.hanwha.neo.branch.ss.approval.vo.ReceiverInfo();
									Map<String, String> tMap	= aplList_r.get(i);
									
									ReceiverInfo.setRoleType("referer");
									ReceiverInfo.setReceiverId(tMap.get("USER_ID"));
									
									ReceiverInfoList[i] = ReceiverInfo;
									
								}
								
								ApprovalDocument.setReceiverInfos(ReceiverInfoList); // 결재 참조 경로 객체 배열
							}
						}
						
						if("501".equals(target.get("COMPANYID"))) {
							try {
								//com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalServiceProxy EagleProxy = new com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalServiceProxy(CommonProperty.getDB_CONN());
								com.hanwhaCleverse.neo.branch.ss.approval.axisws.ApprovalServiceProxy cleverseProxy = new com.hanwhaCleverse.neo.branch.ss.approval.axisws.ApprovalServiceProxy(CommonProperty.getDB_CONN());
								String rtn = cleverseProxy.submitApprovalUseUserId(cleverseApprovalDocument);
								
								apmData.put("RTN_MSG", rtn);
								apmData.put("STATUS2", "01");
								
								if (rtn.equals("SUCCESS")) {
									apmData.put("RTN_FLAG", "Y");
									target.put("RTN_FLAG", "Y");
								} else {
									apmData.put("RTN_FLAG", "E");
									target.put("RTN_FLAG", "E");
								}
								
								dao.updateAppSubmitResult(apmData);
								dao.updateAppSubmitTrxlResult(target);
									
								if(!"KRHANW0107".equals(target.get("BUYER"))) {
								//	com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly [] EagleApprovalDocumentStatusOnly = new com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[1];
								//	com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey [] Eaglemiskeylist = new com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey[1];
									com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly [] cleverseApprovalDocumentStatusOnly = new com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[1];
									com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey [] cleverseMiskeylist = new com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey[1];
									
									
									cleverseMiskeylist[0] = new com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey();
									
									cleverseMiskeylist[0].setMisDocId((String)apmData.get("APPRID"));
									cleverseMiskeylist[0].setSystemId((String)apmData.get("SYSTEMID"));
									
									cleverseApprovalDocumentStatusOnly = cleverseProxy.getProcessIdByBulkMisId(cleverseMiskeylist);
									
									String instanceId = cleverseApprovalDocumentStatusOnly[0].getInstanceId();
									
									apmData.put("instanceId",instanceId);
									
									dao.updateHanWhaIfApmSend(apmData);
									dao.insertTrxl(apmData);
								}
								
							} catch (Exception e) {
								log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
								apmData.put("RTN_MSG", "E");
								apmData.put("RTN_FLAG", "E");
								target.put("RTN_FLAG", "E");
								
								dao.updateAppSubmitResult(apmData);
								dao.updateAppSubmitTrxlResult(target);
								
								String str = "";
								
								str += "<br><BODY><TABLE border='1'><TR>";
								str += "<TH>고객사</TH>";
								str += "<TH>주문 번호</TH>";
								
								str += "<TR>";
								str += "<TD>";
								str += target.get("BUYER");
								str += "</TD>";
								str += "<TD align='right'>";
								str += target.get("PR_NO");
								str += "</TD>";
								str += "</TR></TABLE></BODY>";
								
								target.put("MAIL_CONTENT",str);
								
								dao.insertMail(target);
							}
						} else {
								try {
									ApprovalServiceProxy proxy = new ApprovalServiceProxy(CommonProperty.getDB_CONN());
									
									String rtn = proxy.submitApprovalUseUserId(ApprovalDocument);
									
									apmData.put("RTN_MSG", rtn);
									apmData.put("STATUS2", "01");
									
									if (rtn.equals("SUCCESS")) {
										apmData.put("RTN_FLAG", "Y");
										target.put("RTN_FLAG", "Y");
									} else {
										apmData.put("RTN_FLAG", "E");
										target.put("RTN_FLAG", "E");
									}
									
									dao.updateAppSubmitResult(apmData);
									dao.updateAppSubmitTrxlResult(target);
									
									if("402".equals((String)apmData.get("COMPANYID")) || "403".equals((String)apmData.get("COMPANYID"))) {
										
										com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly [] ApprovalDocumentStatusOnly = new com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[1];
										com.hanwha.neo.branch.ss.approval.vo.MisKey [] miskeylist = new com.hanwha.neo.branch.ss.approval.vo.MisKey[1];
										
										miskeylist[0] = new com.hanwha.neo.branch.ss.approval.vo.MisKey();
										
										miskeylist[0].setMisDocId((String)apmData.get("APPRID"));
										miskeylist[0].setSystemId((String)apmData.get("SYSTEMID"));
										
										ApprovalDocumentStatusOnly = proxy.getProcessIdByBulkMisId(miskeylist);
										
										String instanceId = ApprovalDocumentStatusOnly[0].getInstanceId();
										
										apmData.put("instanceId",instanceId);
										
										dao.updateHanWhaIfApmSend(apmData);
										dao.insertTrxl(apmData);
									}
								} catch (Exception e) {
									log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
									apmData.put("RTN_MSG", "E");
									apmData.put("RTN_FLAG", "E");
									target.put("RTN_FLAG", "E");
									
									dao.updateAppSubmitResult(apmData);
									dao.updateAppSubmitTrxlResult(target);
									
									String str = "";
									
									str += "<br><BODY><TABLE border='1'><TR>";
									str += "<TH>고객사</TH>";
									str += "<TH>주문 번호</TH>";
									
									str += "<TR>";
									str += "<TD>";
									str += target.get("BUYER");
									str += "</TD>";
									str += "<TD align='right'>";
									str += target.get("PR_NO");
									str += "</TD>";
									str += "</TR></TABLE></BODY>";
									
									target.put("MAIL_CONTENT",str);
									
									dao.insertMail(target);
								}
							}
						}
						 catch (Exception e) {
						e.printStackTrace();
						log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
					}
				} 
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
		} 
	}
	
	
	public String getXml_410(List<Map<String, String>> prList, Map<String, String> appData) {
		
		StringBuffer contents	= new StringBuffer();
		
		contents.append("<pre align='center' style='font-size:30px'>");
		contents.append("MRO 구매결의");
		contents.append("</pre>");
		contents.append("<br><hr><br>\n");
		contents.append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>\n");
		contents.append("<html>\n");
		contents.append("<head>\n");
		contents.append("<meta http-equiv='Content-Type' content='text/html; charset=euc-kr'>\n");
		contents.append("</head>\n");
		contents.append("<body leftmargin='10' topmargin='10' marginwidth='0' marginheight='0'>\n");
		
		contents.append("<table class='MsoTableGrid' border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none'>");
		contents.append("<tbody>");
		contents.append("<tr height = '50'>");
		contents.append("<td width='85' bgcolor='#D3D3D3' style='border:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>사업장</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='200' style='border:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>"  + prList.get(0).get("COM_NAME_LOC") +  "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='140' style='border:none;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='84' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문번호</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>(KeP Mall)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='180' style=';border:1px solid;border-left:none;'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'>" + prList.get(0).get("BUYER") + prList.get(0).get("PR_NO") + "<o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("<tr height = '50'>");
		contents.append("<td width='85' bgcolor='#D3D3D3' style=';border:1px solid;border-top:none;'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문자</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='200' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.get(0).get("USER_NAME_LOC") + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='140' style='border:none;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='84' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>대금지급 조건</strong><span lang='EN-US'><o:p></o:p></span></p>");
		//contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>(PO)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='180' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + "전자채권 90일" + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		contents.append("</tbody>");
		contents.append("</table>");

		contents.append("<p class='MsoNormal'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");

		contents.append("<table class='MsoTableGrid' border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none'>");
		contents.append("<tbody>");
		contents.append("<tr height = '50'>");
		contents.append("<td width='37' bgcolor='#D3D3D3' style='border:1px solid;border-left:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>No</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='132' colspan='2' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>품목코드</strong><span lang='EN-US'><strong>(KeP mall)</strong><o:p></o:p></span></p>");
//					contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>자재코드</strong><span lang='EN-US'><strong>(ERP)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='210' colspan='3' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>내 역</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>규 격</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='77' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>수량</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>단위</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='131' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>단 가</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>금 액</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='143' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>희망납기</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		for (int i = 0 ; i < prList.size() ; i++) {
		
			Map<String, String> tMap	= prList.get(i);
				
			contents.append("<tr height = '30'>");
			contents.append("<td width='37' rowspan='2' style='border:1px solid;border-left:1px solid;border-top:none'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'>" + (i+1) + "<o:p></o:p></span></p>");
			contents.append("</td>");
			contents.append("<td width='132' rowspan='2' colspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" + tMap.get("BUYER_ITEM_NO") + "</p>");
			contents.append("</td>");
			contents.append("<td width='191' colspan='3' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center;padding-right:5px;padding-left:5px'>" + tMap.get("DESCRIPTION") + "</p>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center;padding-right:5px;padding-left:5px'>" + tMap.get("SPECIFICATION")+ "</p>");
			contents.append("</td>");
			contents.append("<td width='77' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + tMap.get("TARGET_QTY") + "</p>");
			contents.append("</td>");
			contents.append("<td width='131' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;padding-right:8px'>");
			contents.append("<p class='MsoNormal' align='right' style='text-align:right'>" +tMap.get("PRICE") + "</p>");
			contents.append("</td>");
			contents.append("<td width='143' align='center' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal'>" + tMap.get("RD_DATE") + "</p>");
			contents.append("</td>");
			contents.append("</tr>");
			contents.append("<tr height = '30'>");
			contents.append("<td width='77' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + tMap.get("UNIT_MEASURE") + "</p>");
			contents.append("</td>");
			contents.append("<td width='131' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;padding-right:8px'>");
			contents.append("<p class='MsoNormal' align='right' style='text-align:right'>" + tMap.get("AMT") + "</p>");
			contents.append("</td>");
			contents.append("</tr>");
		}

		contents.append("<tr height = '30'>");
		contents.append("<td width='83' colspan='2' rowspan='2' bgcolor='#D3D3D3' style='border:1px solid;border-left:1px solid;border-bottom:1px solid;border-right:1px solid;border-top:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문 일자</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='86' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" +prList.get(0).get("ADD_DATE")+ "</p>");
		contents.append("</td>");
		contents.append("<td width='85' rowspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문 건수</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='66' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.size() + "</p>");
		contents.append("</td>");
		contents.append("<td width='85' colspan='2' rowspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>금액 합계</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='131' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid;padding-right:8px'>");
		contents.append("<p class='MsoNormal' align='right' style='text-align:right'><strong>" + prList.get(0).get("AMT_TOTAL") + "</strong></p>");
		contents.append("</td>");
		contents.append("<td width='143' colspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>공급사명</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("<tr height = '30'>");
		contents.append("<td width='110' colspan='2'  style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center'> " + prList.get(0).get("AGENT_NAME") + " </p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("<tr height='0'>");
		contents.append("<td width='37' style='border:none'></td>");
		contents.append("<td width='46' style='border:none'></td>");
		contents.append("<td width='86' style='border:none'></td>");
		contents.append("<td width='85' style='border:none'></td>");
		contents.append("<td width='66' style='border:none'></td>");
		contents.append("<td width='40' style='border:none'></td>");
		contents.append("<td width='45' style='border:none'></td>");
		contents.append("<td width='98' style='border:none'></td>");
		contents.append("<td width='110' style='border:none'></td>");
		contents.append("</tr>");
		contents.append("</tbody>");
		contents.append("</table>");
		
		contents.append("<p class='MsoNormal'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		
		contents.append("<table>");
		contents.append("<tr height = '80'>");
		contents.append("<td width='780' style='border:1px solid;border-left:1px solid;padding-left:8px'>");
		contents.append("<p>" + appData.get("DOCU_CONT") + "</p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("</table>");
		
		contents.append("</body>\n");
		contents.append("</html>\n");
		
		return contents.toString();
	}
	
	public String getXml(List<Map<String, String>> prList, Map<String, String> appData) {
		
		StringBuffer contents	= new StringBuffer();
		
		contents.append("<pre align='center' style='font-size:30px'>");
		contents.append("MRO 구매결의");
		contents.append("</pre>");
		contents.append("<br><hr><br>\n");
		contents.append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>\n");
		contents.append("<html>\n");
		contents.append("<head>\n");
		contents.append("<meta http-equiv='Content-Type' content='text/html; charset=euc-kr'>\n");
		contents.append("</head>\n");
		contents.append("<body leftmargin='10' topmargin='10' marginwidth='0' marginheight='0'>\n");
		
		contents.append("<table class='MsoTableGrid' border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none'>");
		contents.append("<tbody>");
		contents.append("<tr height = '50'>");
		contents.append("<td width='85' bgcolor='#D3D3D3' style='border:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>사업장</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='200' style='border:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>"  + prList.get(0).get("COM_NAME_LOC") +  "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='140' style='border:none;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='84' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문번호</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>(KeP Mall)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='190' style=';border:1px solid;border-left:none;'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'>" + prList.get(0).get("BUYER") + prList.get(0).get("PR_NO") + "<o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		contents.append("<tr height = '50'>");
		contents.append("<td width='85' bgcolor='#D3D3D3' style=';border:1px solid;border-top:none;'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문자</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='200' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.get(0).get("USER_NAME_LOC") + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='140' style='border:none;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='110' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>발주번호</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>(PO)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='201' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.get(0).get("LEGACY_PO_NO") + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		contents.append("<tr height = '50' style='border:none'>");
		contents.append("<td width='85' style='border:none;border-left:none;border-bottom:none;border-right:none'>");
		contents.append("</td>");
		contents.append("<td width='170' style='border:none;border-left:none;border-bottom:none;border-right:none'>");
		contents.append("</td>");
		contents.append("<td width='170' style='border:none;border-left:none;border-bottom:none;border-top:none'>");
		contents.append("</td>");
		contents.append("<td width='110' bgcolor='#D3D3D3' style='border-top:none;border-left:1px solid;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>대금지급 조건</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='201' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + "전자채권 90일" + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		contents.append("</tbody>");
		contents.append("</table>");

		contents.append("<p class='MsoNormal'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");

		contents.append("<table class='MsoTableGrid' border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none'>");
		contents.append("<tbody>");
		contents.append("<tr height = '50'>");
		contents.append("<td width='37' bgcolor='#D3D3D3' style='border:1px solid;border-left:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>No</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='132' colspan='2' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>품목코드</strong><span lang='EN-US'><strong>(KeP mall)</strong><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>자재코드</strong><span lang='EN-US'><strong>(ERP)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='210' colspan='3' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>내 역</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>규 격</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='45' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>수량</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>단위</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='98' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>단 가</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>금 액</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='145' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>코스트 센터</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>G/L 계정</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='110' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>희망납기</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		for (int i = 0 ; i < prList.size() ; i++) {
		
			Map<String, String> tMap	= prList.get(i);
				
			contents.append("<tr height = '30'>");
			contents.append("<td width='37' rowspan='2' style='border:1px solid;border-left:1px solid;border-top:none'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'>" + (i+1) + "<o:p></o:p></span></p>");
			contents.append("</td>");
			contents.append("<td width='132' colspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" + tMap.get("BUYER_ITEM_NO") + "</p>");
			contents.append("</td>");
			contents.append("<td width='191' colspan='3' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center;padding-right:5px;padding-left:5px'>" + tMap.get("DESCRIPTION") + "</p>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center;padding-right:5px;padding-left:5px'>" + tMap.get("SPECIFICATION")+ "</p>");
			contents.append("</td>");
			contents.append("<td width='45' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + tMap.get("TARGET_QTY") + "</p>");
			contents.append("</td>");
			contents.append("<td width='98' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;padding-right:8px'>");
			contents.append("<p class='MsoNormal' align='right' style='text-align:right'>" +tMap.get("PRICE") + "</p>");
			contents.append("</td>");
			contents.append("<td width='145' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" +tMap.get("BUDGET_DEPT") + "</p>");
			contents.append("</td>");
			contents.append("<td width='110' align='center' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal'>" + tMap.get("RD_DATE") + "</p>");
			contents.append("</td>");
			contents.append("</tr>");
			contents.append("<tr height = '30'>");
			contents.append("<td width='132' colspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" + tMap.get("ERP_ITEM_NO")  + "</p>");        // 수정요망
			contents.append("</td>");
			contents.append("<td width='45' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + tMap.get("UNIT_MEASURE") + "</p>");
			contents.append("</td>");
			contents.append("<td width='98' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;padding-right:8px'>");
			contents.append("<p class='MsoNormal' align='right' style='text-align:right'>" + tMap.get("AMT") + "</p>");
			contents.append("</td>");
			contents.append("<td width='145' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" + tMap.get("ACCOUNT_TYPE") + "</p>");
			contents.append("</td>");
			contents.append("</tr>");
		}

		contents.append("<tr height = '30'>");
		contents.append("<td width='83' colspan='2' rowspan='2' bgcolor='#D3D3D3' style='border:1px solid;border-left:1px solid;border-bottom:1px solid;border-right:1px solid;border-top:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문 일자</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='86' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" +prList.get(0).get("ADD_DATE")+ "</p>");
		contents.append("</td>");
		contents.append("<td width='85' rowspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문 건수</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='66' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.size() + "</p>");
		contents.append("</td>");
		contents.append("<td width='85' colspan='2' rowspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>금액 합계</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='98' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid;padding-right:8px'>");
		contents.append("<p class='MsoNormal' align='right' style='text-align:right'><strong>" + prList.get(0).get("AMT_TOTAL") + "</strong></p>");
		contents.append("</td>");
		contents.append("<td width='110' colspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>공급사명</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("<tr height = '30'>");
		contents.append("<td width='132' colspan='2'  style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center'> " + prList.get(0).get("AGENT_NAME") + " </p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("<tr height='0'>");
		contents.append("<td width='37' style='border:none'></td>");
		contents.append("<td width='46' style='border:none'></td>");
		contents.append("<td width='86' style='border:none'></td>");
		contents.append("<td width='85' style='border:none'></td>");
		contents.append("<td width='66' style='border:none'></td>");
		contents.append("<td width='40' style='border:none'></td>");
		contents.append("<td width='45' style='border:none'></td>");
		contents.append("<td width='98' style='border:none'></td>");
		contents.append("<td width='110' style='border:none'></td>");
		contents.append("</tr>");
		contents.append("</tbody>");
		contents.append("</table>");
		
		contents.append("<p class='MsoNormal'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		
		contents.append("<table>");
		contents.append("<tr height = '80'>");
		contents.append("<td width='780' style='border:1px solid;border-left:1px solid;padding-left:8px'>");
		contents.append("<p>" + appData.get("DOCU_CONT") + "</p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("</table>");
		
		contents.append("</body>\n");
		contents.append("</html>\n");
		
		return contents.toString();
	}
}

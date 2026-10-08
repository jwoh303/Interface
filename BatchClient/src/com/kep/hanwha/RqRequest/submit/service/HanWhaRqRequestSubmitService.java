package com.kep.hanwha.RqRequest.submit.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import javax.activation.FileDataSource;

import org.apache.log4j.Logger;

import com.hanwha.neo.branch.ss.approval.axisws.ApprovalServiceProxy;
import com.hanwha.neo.branch.ss.approval.vo.WsApAttachFile;
import com.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo;
import com.kep.common.CommonAwsS3;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.hanwha.RqRequest.submit.dao.HanWhaRqRequestSubmitDao;

public class HanWhaRqRequestSubmitService {

private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@SuppressWarnings("unchecked")
	public void execute() {
		
		HanWhaRqRequestSubmitDao dao = new HanWhaRqRequestSubmitDao();
		
		try {
		
			List<Map<String, String>> targetList	= dao.selectIFTargetList();
			System.out.println("targetList : " + targetList);
			
			if(targetList.size() > 0) {
				
				for (Map<String,String> target : targetList) {
				
					List<Map<String, String>> RqLists = dao.selectRqList(target);
				
					List<Map<String,String>> AtchList = dao.selectAtchList(target); // 첨부파일
				
					com.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile[] cleverseWsAtchList = new com.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile[AtchList.size()];
				//	com.hanwhaEagle.neo.branch.ss.approval.vo.WsApAttachFile[] EagleWsAtchList = new com.hanwhaEagle.neo.branch.ss.approval.vo.WsApAttachFile[AtchList.size()];
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
					
					contents = getXml(RqLists, target);
					
					target.put("CONTENTS",contents);
					
					dao.insertIfAplSend(target);
					dao.insertIfApmSend(target);
					
					Map<String, Object> apmData	= dao.selectAppsendList(target);
					
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
							cleverseSignerInfo.setUserId(tMap.get("USER_ID")); //EagleOffice의 userID						
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
						cleverseApprovalDocument.setTitle((String)apmData.get("SUBJECT"));  // 결재제목
						cleverseApprovalDocument.setMisDocId((String)apmData.get("APPRID"));  // 결재ID
						cleverseApprovalDocument.setSystemId((String)apmData.get("SYSTEMID"));  // systemID
						cleverseApprovalDocument.setFlowCase("customized");  
						cleverseApprovalDocument.setAttachfiles(cleverseWsAtchList); // 첨부파일 정보
						cleverseApprovalDocument.setCompanyId((String)apmData.get("COMPANYID"));  // 회사ID
						cleverseApprovalDocument.setFormCode((String)apmData.get("FORMCODE"));  // systemID
						cleverseApprovalDocument.setSignerInfos(cleverseSignerInfoList);  // 결재 경로 객체 배열
						if(aplList_r.size() > 0) {
							//com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo[] EagleReceiverInfoList = new com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo[aplList_r.size()];
							com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo[] cleverseReceiverInfoList = new com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo[aplList_r.size()];
							
							// 참조 정보 입력
							for(int i = 0 ; i < aplList_r.size() ; i++) {
								//com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo EagleReceiverInfo = new com.hanwhaEagle.neo.branch.ss.approval.vo.ReceiverInfo();
								com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo cleverseReceiverInfo  = new com.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo();
								
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
						
						ApprovalDocument.setTitle((String)apmData.get("SUBJECT"));  // 결재제목
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
							
							if (rtn.equals("SUCCESS")) {
								apmData.put("RTN_FLAG", "Y");
							} else {
								apmData.put("RTN_FLAG", "E");
							}
							dao.updateAppSubmitResult(apmData);
							
							try {	// 결재선 저장 기능 개발
								int appCnt = dao.selectHanwhaApptCnt(apmData);	// 결재선 마스터 건수 확인.
								if (appCnt == 0) {
									dao.insertHanwhaAppt(apmData);	// 결재선 마스터 생성
								}
								dao.deleteHanwhaApse(apmData);	// 결재선 경로 삭제
								dao.insertHanwhaApse(apmData);	// 결재선 경로 생성
							} catch (Exception e) {
								log.error("결재선구성 오류:"+CommonUtil.printStackTraceToString(e));
							}
						} catch (Exception e) {
							apmData.put("RTN_MSG", "E");
							apmData.put("RTN_FLAG", "E");
							
							dao.updateAppSubmitResult(apmData);
							
							String str = "";
							
							str += "<br><br><BODY><TABLE border='1'><TR>";
							str += "<TH>고객사코드</TH>";
							str += "<TH>고객사명</TH>";
							str += "<TH>결재번호</TH>";
							str += "<TH>사용자 ID</TH>";
							str += "<TH>사용자명</TH>";
							
							str += "<TR>";
							str += "<TD>";
							str += apmData.get("BUYER");
							str += "</TD>";
							str += "<TD>";
							str += apmData.get("MAIL_COM_NAME_LOC");
							str += "</TD>";
							str += "<TD align='right'>";
							str += apmData.get("DOC_NO");
							str += "</TD>";
							str += "<TD align='right'>";
							str += apmData.get("MAIL_USER_ID");
							str += "</TD>";
							str += "<TD align='right'>";
							str += apmData.get("MAIL_USER_NAME");
							str += "</TD>";
							str += "</TR></TABLE></BODY>";
							str += "<br><br>신규견적 결재 오류 발생 하였습니다.";
							str += "<br>사용자정보에 기입되어 있는 한화 그룹웨어 아이디 확인 부탁드립니다.";
							
							apmData.put("MAIL_CONTENT",str);
							
							dao.insertMail(apmData);
							
							log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
						}
					} else {
						try {
							ApprovalServiceProxy proxy = new ApprovalServiceProxy(CommonProperty.getDB_CONN());
							String rtn = proxy.submitApprovalUseUserId(ApprovalDocument);
							
							apmData.put("RTN_MSG", rtn);
							
							if (rtn.equals("SUCCESS")) {
								apmData.put("RTN_FLAG", "Y");
							} else {
								apmData.put("RTN_FLAG", "E");
							}
							dao.updateAppSubmitResult(apmData);
							
							try {	// 결재선 저장 기능 개발
								int appCnt = dao.selectHanwhaApptCnt(apmData);	// 결재선 마스터 건수 확인.
								if (appCnt == 0) {
									dao.insertHanwhaAppt(apmData);	// 결재선 마스터 생성
								}
								dao.deleteHanwhaApse(apmData);	// 결재선 경로 삭제
								dao.insertHanwhaApse(apmData);	// 결재선 경로 생성
							} catch (Exception e) {
								log.error("결재선구성 오류:"+CommonUtil.printStackTraceToString(e));
							}
						} catch (Exception e) {
							apmData.put("RTN_MSG", "E");
							apmData.put("RTN_FLAG", "E");
							
							dao.updateAppSubmitResult(apmData);
							
							String str = "";
							
							str += "<br><BODY><TABLE border='1'><TR>";
							str += "<TH>고객사</TH>";
							str += "<TH>결재 번호</TH>";
							
							str += "<TR>";
							str += "<TD>";
							str += apmData.get("BUYER");
							str += "</TD>";
							str += "<TD align='right'>";
							str += apmData.get("DOC_NO");
							str += "</TD>";
							str += "</TR></TABLE></BODY>";
							
							apmData.put("MAIL_CONTENT",str);
							
							dao.insertMail(apmData);
							
							log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
						}
					}					
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public String getXml (List<Map<String, String>> RqLists, Map<String,String> target) {
		
		StringBuffer contents	= new StringBuffer();
		
		String bgcolor = "";
		
		contents.append("<pre align='center' style='font-size:30px'>");
		contents.append("MRO 신규견적");
		contents.append("</pre>");
		contents.append("<br><hr><br>\n");
		contents.append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>\n");
		contents.append("<html>\n");
		contents.append("<head>\n");
		contents.append("<meta http-equiv='Content-Type' content='text/html; charset=euc-kr'>\n");
		contents.append("</head>\n");
		contents.append("<body leftmargin='10' topmargin='10' marginwidth='0' marginheight='0'>\n");
		
		contents.append("<table width='950' border='1' cellspacing='0' cellpadding='0'>");
		contents.append("<colgroup>");

		contents.append("<col width='5%'>");
		contents.append("<col width='35%'>");
		contents.append("<col width='10%'>");
		contents.append("<col width='20%'>");
		contents.append("<col width='7%'>");
		contents.append("<col width='13%'>");
		contents.append("<col width='10%'>");
		contents.append("</colgroup>");
		contents.append("<thead height = '60'>");
		contents.append("<tr>");

		contents.append("<th rowspan='2' bgcolor='#D3D3D3'>번호</th>");	

		contents.append("<th bgcolor='#D3D3D3'><strong>품목명</strong></th>");	
		contents.append("<th bgcolor='#D3D3D3'><strong>단가구분</strong></th>");	
		contents.append("<th bgcolor='#D3D3D3'><strong>요청단가</strong></th>");	
		contents.append("<th bgcolor='#D3D3D3'><strong>단위</strong></th>");
		contents.append("<th bgcolor='#D3D3D3'><strong>제조사</strong></th>");
		contents.append("<th bgcolor='#D3D3D3'><strong>원산지</strong></th>");
		contents.append("</tr>");
		contents.append("<tr>");
		contents.append("<th bgcolor='#D3D3D3'><strong>규격</strong></th>");
		contents.append("<th bgcolor='#D3D3D3'><strong>회신요청일</strong></th>");
		contents.append("<th bgcolor='#D3D3D3'><strong>기존협력사</strong></th>");
		contents.append("<th bgcolor='#D3D3D3'><strong>수량</strong></th>");	
		contents.append("<th bgcolor='#D3D3D3' colspan='2'><strong>비고</strong></th>");
		contents.append("</tr> ");
		contents.append("</thead>");
		contents.append("<tbody height = '100'>");

			for (int i = 0 ; i < RqLists.size() ; i++) {
				
				Map<String, String> tMap	= RqLists.get(i);
				if (i%2 == 0) bgcolor	= "#ffffff";
				else bgcolor	= "#F5F5F5";
				
				contents.append("<tr bgcolor="+bgcolor+" height = '40'>");
				contents.append("<td align='center' rowspan='2'>" + (i+1) + "</th>");	
				contents.append("<td align='center'>" +tMap.get("DESCRIPTION")+ "</td>");
				contents.append("<td align='center'>" +tMap.get("REQ_PRICE_TYPE")+ "</td>");
				contents.append("<td align='right' style='padding-right:8px'>" +tMap.get("BUYER_TARGET_PRICE")+ "</td>");
				contents.append("<td align='center'>" +tMap.get("UNIT_MEASURE")+ "</td>");
				contents.append("<td align='center'>" +tMap.get("MAKER_NAME")+ "</td>");
				contents.append("<td align='center'>" +tMap.get("ORIGIN_NAME")+ "</td>");
				contents.append("</tr>");
				
				contents.append("<tr bgcolor="+bgcolor+" height = '60'>");
				contents.append("<td align='center'>" +tMap.get("SPECIFICATION")+ "</td>");
				contents.append("<td align='center'>" +tMap.get("BTOA_END_DATE")+ "</td>");
				contents.append("<td align='center'>" +tMap.get("AGENT_NAME")+ "</td>");
				contents.append("<td align='center'>" + tMap.get("ITEM_QTY") + "</td>");
				contents.append("<td align='center' colspan='2'>" +tMap.get("BTOA_REMARK")+ "</td>");
				contents.append("</tr>");
			}

		contents.append("</tbody>");
		contents.append("</table>");
		
		contents.append("<p class='MsoNormal'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		
		contents.append("<table>");
		contents.append("<tr height = '80'>");
		contents.append("<td width='940' style='border:1px solid;border-left:1px solid;padding-left:8px;padding-right:8px'>");
		contents.append("<p>" + target.get("DOCU_CONT") + "</p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("</table>");
		
		contents.append("</body>\n");
		contents.append("</html>\n");
		
		return contents.toString();
	}
}

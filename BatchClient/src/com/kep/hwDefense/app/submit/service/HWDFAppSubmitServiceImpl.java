package com.kep.hwDefense.app.submit.service;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Clob;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.axis.utils.ByteArrayOutputStream;
import org.apache.log4j.Logger;

import com.kep.common.CommonAwsS3;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.hwDefense.app.submit.dao.AppSubmitDao;
import com.kep.hwDefense.app.submit.dao.AppSubmitDaoImpl;

import hdli.cs.ws.server.WSKP001WebServiceProxy;

public class HWDFAppSubmitServiceImpl implements HWDFAppSubmitService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void execute() {
		
		AppSubmitDao dao = new AppSubmitDaoImpl();

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		
		// 파일 첨부 처리용 변수 선언.
		InputStream is = null;
		BufferedInputStream bis = null;
		ByteArrayOutputStream arrayBuff = null;
		int MAX_BUF_BYTE	= 1024000;	// 1MB
		String osName = System.getProperty("os.name");	// 환경에 따른 설정을 변경하기 위함.
		
		try {
			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));

			List<Map<String, Object>> reSendList	= dao.selectAppResendList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( reSendList.size() ));
			
			for(Map<String, Object> apmData : reSendList ) {
				
				Map<String, String> iMap = new HashMap<String, String>();
				iMap.put("BUYER", (String)apmData.get("BUYER"));
				iMap.put("DOC_NO", (String)apmData.get("DOC_NO"));
				List<Map<String, String>> aplList	= dao.selectAppPassList(iMap);
				
				hdli.cs.ws.server.T_APPR_OUT_STEP[]	apprOut	= new hdli.cs.ws.server.T_APPR_OUT_STEP[1];
				// 결재선 정보 객체 생성.
				hdli.cs.ws.server.T_APPR_LINE_OUT_STEP[]	apprLineOut	= new hdli.cs.ws.server.T_APPR_LINE_OUT_STEP[aplList.size()];

				List<Map<String, String>> appFileList	= null;
				// 첨부파일 리스트 조회 3. SELECT ICOMATCH DATA
				if (apmData.get("IMAGE_KEY") != null && !"".equals(apmData.get("IMAGE_KEY"))) {
					appFileList	= dao.selectHanhwaAttFileList(apmData);
				}
				
				// 결재선 정보 입력
				for(int i = 0 ; i < aplList.size() ; i++) {
					hdli.cs.ws.server.T_APPR_LINE_OUT_STEP tApprLine	= new hdli.cs.ws.server.T_APPR_LINE_OUT_STEP();
					Map<String, String> tMap	= aplList.get(i);
					
					tApprLine.setAPPRID(tMap.get("APPRID"));
					tApprLine.setAPPRSEQ(tMap.get("APPRSEQ"));
					tApprLine.setAPPRACTIONCD(tMap.get("APPRACTIONCD"));
					tApprLine.setAPPRSTATUSCD("0");	// 0
					tApprLine.setAPPRUID(tMap.get("LEGACY_USER_ID"));
					tApprLine.setAPPRNM(tMap.get("USER_NAME_LOC"));
					tApprLine.setAPPRDEPTNM(tMap.get("APPRDEPTNM"));
//					APPRCONFIRMDT	-- 불필요 필드로 예상
//					APPRGRDNM	-- 불필요 필드로 예상
//					APPROPINION	-- 불필요 필드로 예상
					tApprLine.setINSERTUID((String)apmData.get("LEGACY_USER_ID"));
					tApprLine.setUPDATEUID((String)apmData.get("LEGACY_USER_ID"));

					apprLineOut[i]	= tApprLine;
				}
				
				// 결재정보 입력
				hdli.cs.ws.server.T_APPR_OUT_STEP tApprOut	= new hdli.cs.ws.server.T_APPR_OUT_STEP();
				tApprOut.setSYSID("506EQ0001");	// 설비관리 : 506EQ0001
				tApprOut.setAPPRID((String)apmData.get("APPRID"));
				tApprOut.setAPPRTYPEID("3");	// 일반문서 : 3
				tApprOut.setAPPRTITLE((String)apmData.get("SUBJECT"));
				
				Clob _contents = (Clob)apmData.get("CONTENTS");
				String contents = _contents.getSubString(1, (int)_contents.length());
				
				tApprOut.setAPPRCONTENTSCLOB(contents);
				tApprOut.setAPPRCONTENTSCD("1");	// ( 1 : html, 2 : mht )
				tApprOut.setCOMPANYID("506");		// 한화디펜스 : 506
				tApprOut.setINSERTUID((String)apmData.get("LEGACY_USER_ID"));
				tApprOut.setUPDATEUID((String)apmData.get("LEGACY_USER_ID"));
				tApprOut.setAPPRSUBMITDT((String)apmData.get("ADD_DATE"));	// MM/DD/YYYY HH24:MI:SS
				tApprOut.setAPPRSTATUSCD("0");	// 0:상신중
				tApprOut.setT_APPR_LINE_OUT_STEP(apprLineOut);

				
				// 첨부파일 로딩 객체 생성.
				if ( appFileList != null && appFileList.size() > 0) {
					log.error("hwdefense.appFileList Start ::: " + appFileList);
					hdli.cs.ws.server.WsApAttachFile[] attFiles = new hdli.cs.ws.server.WsApAttachFile[appFileList.size()];
					for(int i = 0 ; i < appFileList.size() ; i++) {
						Map<String, String> fMap	= appFileList.get(i);
						hdli.cs.ws.server.WsApAttachFile tFile	= new hdli.cs.ws.server.WsApAttachFile();

						String _filename	= (String)fMap.get("DES_FILE_NAME");
						String _orgFilename	= (String)fMap.get("SRC_FILE_NAME");
						String _type = (String)fMap.get("TYPE").toString();
						String _path = "";
						String _del_file_dir = (String)fMap.get("DES_FILE_DIR").toString();
						
						if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
							_path = CommonUtil.getUploadTypePath(_type, "N")+ "/";
						}else{
							_path = CommonUtil.getUploadTypePath(_type, "N") + "/" +_del_file_dir+ "/";
						}

						try {
							System.out.println(" _path + _filename : " + _path + _filename);
							if (CommonAwsS3.doesFileExists(_path + _filename)) {
								byte[] buffer = new byte[MAX_BUF_BYTE];
								is = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));
								bis = new BufferedInputStream(is);
								arrayBuff = new ByteArrayOutputStream();
							    int len = 0;
							    while ((len = bis.read(buffer)) >= 0) {
							        arrayBuff.write(buffer, 0, len);
							    }
								tFile.setFileId("KEY_001_0000" + (String)fMap.get("DOC_NO"));
								tFile.setSeqID(Integer.valueOf(fMap.get("DOC_SEQ")));
								tFile.setFileName(_orgFilename);
								tFile.setFileSize(arrayBuff.toByteArray().length);
								tFile.setFileInfo(arrayBuff.toByteArray());
							}
						} catch (Exception e) {
							log.error(CommonUtil.printStackTraceToString(e));
						} finally {
							try {is.close();} catch (Exception e2) {}
							try {bis.close();} catch (Exception e2) {}
							try {arrayBuff.close();} catch (Exception e2) {}
						}				
						
						attFiles[i]	= tFile;
						tApprOut.setATTACHFILES(attFiles);
					}
					log.error("hwdefense.appFileList End ::: ");
				}
				apprOut[0]	= tApprOut;
				
				// Call Web Service
				try {

					WSKP001WebServiceProxy proxy1	= new WSKP001WebServiceProxy(CommonProperty.getDB_CONN());
					hdli.cs.ws.server.T_APPR_RETURN[] rtnArr = proxy1.process(apprOut);
					
					System.out.println("hwdefense.T_APPR_RETURN : " + rtnArr.length);
					log.error("hwdefense.T_APPR_RETURN : " + rtnArr.length);
					
					for(int i = 0 ; i < rtnArr.length ; i++ ) {
						rtnArr[i].getERRORDESC4();
						rtnArr[i].getAPPRID();
						rtnArr[i].getAPPRSTATUSCD();
						log.error("hwdefense.T_APPR_RETURN["+i+"] : " + rtnArr[i].getAPPRID() + " / " + rtnArr[i].getAPPRSTATUSCD() + " / " + rtnArr[i].getERRORDESC4() + " / " + apmData.get("COMPANY") + " / " + apmData.get("DOCU_NO"));
						
						Map<String, String> rMap = new HashMap<String, String>();
						rMap.put("KEY_NO", (String)apmData.get("APPRID"));
						rMap.put("RESULT_FLAG", rtnArr[i].getAPPRSTATUSCD());
						rMap.put("RESULT_MSG", rtnArr[i].getERRORDESC4());
						rMap.put("BUYER", (String)apmData.get("BUYER"));
						rMap.put("DOC_NO", (String)apmData.get("DOC_NO"));
						
						dao.updateAppSubmitResult(rMap);
						
						if ( rtnArr[i].getT_APPR_LINE_RETURN() != null ) {
							hdli.cs.ws.server.T_APPR_LINE_RETURN[] rtnArrLine = rtnArr[i].getT_APPR_LINE_RETURN();
							for(int j = 0 ; j < rtnArrLine.length ; j++) {
								log.error("hwdefense.T_APPR_LINE_RETURN["+i+"]["+j+"] : " + rtnArrLine[j].getERRORDESC4());
							}
						}
					}		
				} catch (Exception e2) {
					e2.printStackTrace();
					log.error("" + CommonUtil.printStackTraceToString(e2));
				}				
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("AppSubmitService : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
}

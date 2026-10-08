package com.koreab2b.mro.master.cmcl.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetIssueRegDao;
import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetIssueRegDaoImpl;
import com.koreab2b.mro.master.cmcl.dao.MasterCmClSmartBillUploadingCreationDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.AesCryptoAlgorithmUtil;

@Service("masterCmClSalesTaxsheetIssueRegService")
public class MasterCmClSalesTaxsheetIssueRegServiceImpl implements MasterCmClSalesTaxsheetIssueRegService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetIssueRegDaoImpl.class);
	
	@Autowired
	private MasterCmClSalesTaxsheetIssueRegDao masterCmClSalesTaxsheetIssueRegDao;
	@Autowired
	private MasterCmClSmartBillUploadingCreationDao masterCmClSmartBillUploadingCreationDao;
	

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClSalesTaxsheetIssueRegDao.selectList(param);
	}	

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetIssueRegDao.updateSelectedData(formData, gridData);
	}	
	
	// 전송
	@SuppressWarnings("unchecked")
	public String updateARsendData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "";
		boolean _errFlagSave = true;
		int _sucCountSave = 0;
		int _errCountSave = 0;
//		int _sucCountSAP = 0;
//		int _errCountSAP = 0;
		
		for ( int i=0; i < gridData.size(); i++ ) {
//			formData.putAll((Map<String, String>)gridData.get(i));
			String _ifSendFlag = CommonUtil.nvl(((Map<String, String>)gridData.get(i)).get("IF_SEND_FLAG"));
			formData.put("GRP_CD", String.valueOf("0000"));
			formData.put("TAX_BILL_NO", ((Map<String, String>)gridData.get(i)).get("TAX_BILL_NO"));
			formData.put("KEP_IRS_NO", String.valueOf(((Map<String, String>)gridData.get(i)).get("KEP_IRS_NO")));
			formData.put("EMAIL", String.valueOf(((Map<String, String>)gridData.get(i)).get("EMAIL")));
			formData.put("USER_NAME", String.valueOf(((Map<String, String>)gridData.get(i)).get("USER_NAME")));
			formData.put("ZZ_RREE_TXT1_TEMP", String.valueOf(((Map<String, String>)gridData.get(i)).get("USER_NAME")));
			LOGGER.debug("#################### ( {} ) ####################", i);
			LOGGER.debug("_ifSendFlag : {}", _ifSendFlag);
			LOGGER.debug("GRP_CD : {}", formData.get("GRP_CD"));
			LOGGER.debug("TAX_BILL_NO : {}", formData.get("TAX_BILL_NO"));
			LOGGER.debug("KEP_IRS_NO : {}", formData.get("KEP_IRS_NO"));
			LOGGER.debug("EMAIL : {}", formData.get("EMAIL"));
			LOGGER.debug("USER_NAME : {}", formData.get("USER_NAME"));
			LOGGER.debug("############################################");

			// 전송 - IF 저장
			try {
				// 미전송만 처리
				if ( "".equals(_ifSendFlag) ) {
					// 기존 I/F 오류내역 처리 방법 설정
					formData.put("processType", "N");
					LOGGER.debug("processType : {}", formData.get("processType"));
					
					// I/F 테이블 신규 생성
					masterCmClSalesTaxsheetIssueRegDao.saveARsendData(formData);
				}
				else {
					// 전송오류 처리
					if ( "E".equals(_ifSendFlag) ) {
						// 기존 I/F 오류내역 처리 방법 설정
						formData.put("processType", "D");
						LOGGER.debug("processType : {}", formData.get("processType"));
							
						// I/F 테이블 신규 생성
						masterCmClSalesTaxsheetIssueRegDao.saveARsendData(formData);
					}
					// 전송취소완료 처리
					else if ( "C".equals(_ifSendFlag) ) {
						// 기존 I/F 오류내역 처리 방법 설정
						formData.put("processType", "B");
						LOGGER.debug("processType : {}", formData.get("processType"));
						
						// I/F 테이블 신규 생성
						masterCmClSalesTaxsheetIssueRegDao.saveARsendData(formData);
					}
				}
			} catch(Exception e) {
				_errFlagSave = false;
				_errCountSave++;
				LOGGER.debug("##### _errCountSave : {} #####", _errCountSave);
				LOGGER.error("SQL ERROR : ", e);
			}
				
			if ( _errFlagSave ) {
				_sucCountSave++;
			}
			
			// SAP 전송 - 데몬에서 처리(2014.10.20)
//			try {
//				if ( _errFlagSave ) {
//					String _tempMsg = masterCmClSalesTaxsheetIssueRegDao.sendARsendData(formData);
//					
//					if ( "success".equals(_tempMsg) ) {
//						_sucCountSAP++;
//					} else if ( "error".equals(_tempMsg) || "fail".equals(_tempMsg) ) {
//						_errCountSAP++;
//					}
//				}
//			} catch(Exception e) {
//				_errCountSAP++;
//				LOGGER.debug("##### _errCountSAP : {} #####", _errCountSAP);
//				LOGGER.error("SQL ERROR : ", e);
//			}
			
			_errFlagSave = true;
		}
		
		_rtnMsg = "세금계산서 전송이 완료 되었습니다." 
				+ "\n\n- IF 저장 [ 총 " + gridData.size() + " 건 / 성공 " +_sucCountSave + " 건 / 실패 " + + _errCountSave + " 건 ] -";
//				+ "\n\n- IF 저장 [ 총 " + gridData.size() + " 건 / 성공 " +_sucCountSave + " 건 / 실패 " + + _errCountSave + " 건 / 제외 " + ( gridData.size() - ( _sucCountSave + _errCountSave ) ) + " 건 ] -"
//				+ "\n\n- SAP 전송 [ 총 " + ( _sucCountSAP + _errCountSAP ) + " 건 / 성공 " + _sucCountSAP + " 건 / 실패 " + _errCountSAP + " 건 ] -";
		
		return _rtnMsg;
	}
	
	// 전송취소
	@SuppressWarnings("unchecked")
	public String updateARreverseData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "";
		boolean _errFlagSave = true;
		int _sucCountSave = 0;
		int _errCountSave = 0;
//		int _sucCountSAP = 0;
//		int _errCountSAP = 0;
		
		for ( int i=0; i < gridData.size(); i++ ) {
//			formData.putAll((Map<String, String>)gridData.get(i));
			String _ifSendFlag = CommonUtil.nvl(((Map<String, String>)gridData.get(i)).get("IF_SEND_FLAG"));
			formData.put("TAX_BILL_NO", String.valueOf(((Map<String, String>)gridData.get(i)).get("TAX_BILL_NO")));
			formData.put("KEP_IRS_NO", String.valueOf(((Map<String, String>)gridData.get(i)).get("KEP_IRS_NO")));
			LOGGER.debug("#################### ( i ) ####################");
			LOGGER.debug("_ifSendFlag : {}", _ifSendFlag);
			LOGGER.debug("TAX_BILL_NO : {}", formData.get("TAX_BILL_NO"));
			LOGGER.debug("KEP_IRS_NO : {}", formData.get("KEP_IRS_NO"));
			LOGGER.debug("############################################");
			
			// 전송완료만 처리
			if ( "Y".equals(_ifSendFlag) ) {
				// 전송취소 - IF 저장
				try {
					masterCmClSalesTaxsheetIssueRegDao.saveARreverseData(formData);
				} catch(Exception e) {
					_errFlagSave = false;
					_errCountSave++;
					LOGGER.debug("##### _errCountSave : {} #####", _errCountSave);
					LOGGER.error("SQL ERROR : ", e);
				}
				
				if ( _errFlagSave ) {
					_sucCountSave++;
				}
			}
			
			
			// SAP 전송취소
//			try {
//				if ( _errFlagSave ) {
//					String _tempMsg = masterCmClSalesTaxsheetIssueRegDao.sendARreverseData(formData);
//					
//					if ( "success".equals(_tempMsg) ) {
//						_sucCountSAP++;
//					}
//					else if ( "error".equals(_tempMsg) || "fail".equals(_tempMsg) ) {
//						_errCountSAP++;
//					}
//				}
//			} catch(Exception e) {
//				_errCountSAP++;
//				LOGGER.debug("##### _errCountSAP : {} #####", _errCountSAP);
//				LOGGER.error("SQL ERROR : ", e);
//			}
			
			_errFlagSave = true;
		}
		
		_rtnMsg = "세금계산서 전송취소가 완료 되었습니다." 
				+ "\n\n- IF 저장 [ 총 " + gridData.size() + " 건 / 성공 " +_sucCountSave + " 건 / 실패 " + + _errCountSave + " 건 ] -";
//				+ "\n\n- IF 저장 [ 총 " + gridData.size() + " 건 / 성공 " +_sucCountSave + " 건 / 실패 " + + _errCountSave + " 건 / 제외 " + ( gridData.size() - ( _sucCountSave + _errCountSave ) ) + " 건 ] -"
//				+ "\n\n- SAP 전송취소 [ 총 " + ( _sucCountSAP + _errCountSAP ) + " 건 / 성공 " + _sucCountSAP + " 건 / 실패 " + _errCountSAP + " 건 ] -";
		
		return _rtnMsg;
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetIssueRegDao.deleteSelectedData(formData, gridData);
	}
	@Transactional
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetIssueRegDao.deleteSelectedData_v2(formData, gridData);
	}
	// 세금계산서 삭제
	@Transactional
	public String delSelectedSbData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetIssueRegDao.delSelectedSbData(formData, gridData);
	}	
	// 전송
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueRegList(Map<String,String>  formData, HttpServletRequest req, HttpServletResponse pResponse) {
		return masterCmClSmartBillUploadingCreationDao.SendARMasterCmClSalesTaxsheetIssueRegList(formData,req,pResponse);
	
	}	
	// 전송양식 생성
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueFormat(Map<String,String> formData) {
		return masterCmClSalesTaxsheetIssueRegDao.SendARMasterCmClSalesTaxsheetIssueFormat(formData);
	}

	
}

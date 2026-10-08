package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClPurchaseTaxsheetIssueRegDao;
import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetIssueRegDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Service("masterCmClPurchaseTaxsheetIssueRegService")
public class MasterCmClPurchaseTaxsheetIssueRegServiceImpl implements MasterCmClPurchaseTaxsheetIssueRegService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetIssueRegDaoImpl.class);
	
	@Autowired
	private MasterCmClPurchaseTaxsheetIssueRegDao masterCmClPurchaseTaxsheetIssueRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClPurchaseTaxsheetIssueRegDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClPurchaseTaxsheetIssueRegDao.updateSelectedData(formData, gridData);
	}	
	@Transactional
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClPurchaseTaxsheetIssueRegDao.updateSelectedData_v2(formData, gridData);
	}
	
	// 전송
	@SuppressWarnings("unchecked")
	public String updateAPsendData(Map<String,String>  formData, List<Object> gridData) {
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
			formData.put("TAX_BILL_NO", String.valueOf(((Map<String, String>)gridData.get(i)).get("TAX_BILL_NO")));
			formData.put("KEP_IRS_NO", String.valueOf(((Map<String, String>)gridData.get(i)).get("KEP_IRS_NO")));
			formData.put("PAY_TERMS", String.valueOf(((Map<String, String>)gridData.get(i)).get("PAY_TERMS")));
			formData.put("EMAIL", String.valueOf(((Map<String, String>)gridData.get(i)).get("EMAIL")));
			LOGGER.debug("#################### ( {} ) ####################", i);
			LOGGER.debug("_ifSendFlag : {}", _ifSendFlag);
			LOGGER.debug("GRP_CD : {}", formData.get("GRP_CD"));
			LOGGER.debug("TAX_BILL_NO : {}", formData.get("TAX_BILL_NO"));
			LOGGER.debug("KEP_IRS_NO : {}", formData.get("KEP_IRS_NO"));
			LOGGER.debug("PAY_TERMS : {}", formData.get("PAY_TERMS"));
			LOGGER.debug("EMAIL : {}", formData.get("EMAIL"));
			LOGGER.debug("############################################");
			
			// 전송 - IF 저장
			try {
				// 미전송 처리
				if ( "".equals(_ifSendFlag) ) {
					// 기존 I/F 오류내역 처리 방법 설정
					formData.put("processType", "N");
					LOGGER.debug("processType : {}", formData.get("processType"));
					
					// I/F 테이블 신규 생성 ( 결제조건, 결제유형 update )
					masterCmClPurchaseTaxsheetIssueRegDao.saveAPsendData(formData);
				}
				else {
					// 전송오류 처리
					if ( "E".equals(_ifSendFlag) ) {
						// 기존 I/F 오류내역 처리 방법 설정
						formData.put("processType", "D");
						LOGGER.debug("processType : {}", formData.get("processType"));
						
						// I/F 테이블 신규 생성 ( 결제조건, 결제유형 update )
						masterCmClPurchaseTaxsheetIssueRegDao.saveAPsendData(formData);
					}
					// 전송취소완료 처리
					else if ( "C".equals(_ifSendFlag) ) {
						// 기존 I/F 오류내역 처리 방법 설정
						formData.put("processType", "B");
						LOGGER.debug("processType : {}", formData.get("processType"));
						
						// I/F 테이블 신규 생성 ( 결제조건, 결제유형 update )
						masterCmClPurchaseTaxsheetIssueRegDao.saveAPsendData(formData);
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
			
			// 전송 - SAP 전송 - 데몬에서 처리(2014.10.20)
//			try {
//				if ( _errFlagSave ) {
//					String _tempMsg = masterCmClPurchaseTaxsheetIssueRegDao.sendAPsendData(formData);
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
	public String updateAPreverseData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "";
		boolean _errFlagSave = true;
		int _sucCountSave = 0;
		int _errCountSave = 0;
//		int _sucCountSAP = 0;
//		int _errCountSAP = 0;
		
		for ( int i=0; i < gridData.size(); i++ ) {
//			formData.putAll((Map<String, String>)gridData.get(i));
			String _ifSendFlag = CommonUtil.nvl(((Map<String, String>)gridData.get(i)).get("IF_SEND_FLAG"));
			formData.put("TAX_BILL_NO", ((Map<String, String>)gridData.get(i)).get("TAX_BILL_NO"));
			formData.put("KEP_IRS_NO", String.valueOf(((Map<String, String>)gridData.get(i)).get("KEP_IRS_NO")));
			LOGGER.debug("#################### ( {} ) ####################", i);
			LOGGER.debug("_ifSendFlag : {}", _ifSendFlag);
			LOGGER.debug("TAX_BILL_NO : {}", formData.get("TAX_BILL_NO"));
			LOGGER.debug("KEP_IRS_NO : {}", formData.get("KEP_IRS_NO"));
			LOGGER.debug("############################################");
			
			// 전송완료만 처리
			if ( "Y".equals(_ifSendFlag) ) {
				// 전송취소 - IF 저장
				try {
					masterCmClPurchaseTaxsheetIssueRegDao.saveAPreverseData(formData);
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
			
			// 전송취소 - SAP 전송 - 데몬에서 처리(2014.10.20)
//			try {
//				if ( _errFlagSave ) {
//					String _tempMsg = masterCmClPurchaseTaxsheetIssueRegDao.sendAPreverseData(formData);
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
		return masterCmClPurchaseTaxsheetIssueRegDao.deleteSelectedData(formData, gridData);
	}@Transactional
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClPurchaseTaxsheetIssueRegDao.deleteSelectedData_v2(formData, gridData);
	}
	
	// 역발행요청삭제
	@Transactional
	public String delApMasterCmClPurchaseTaxsheetIssueRegList(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClPurchaseTaxsheetIssueRegDao.delApMasterCmClPurchaseTaxsheetIssueRegList(formData, gridData);
	}
	
	// 전송
	@Transactional
	public String sendApSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClPurchaseTaxsheetIssueRegDao.sendApSelectedData(formData, gridData);
	}
	
	// 정발행 메일 요청
	@Transactional
	public String sendApMailSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClPurchaseTaxsheetIssueRegDao.sendApMailSelectedData(formData, gridData);
	}
	
	// 역발행 메일 요청
	public List<Map<String,String>> getMasterCmClsendApRMailPop(Map<String,String> formData) {
		return masterCmClPurchaseTaxsheetIssueRegDao.selectMasterCmClsendApRMailPop(formData);
	}
}

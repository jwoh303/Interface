package com.koreab2b.mro.master.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("masterMpRqQuotationReceiptSendDao")
@Transactional
public class MasterMpRqQuotationReceiptSendDaoImpl implements MasterMpRqQuotationReceiptSendDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationReceiptSendDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqQuotationReceiptSendList", param);
	}

	// 조회
	public List<Map<String,String>> getListHd(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selecMasterMpRqQuoSendHd", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqQuotationReceiptSend", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 네고
	@SuppressWarnings("unchecked")
	public Map<String,String> negoQuotationReceiptSend(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 Nego제출 되었습니다.";
		
		int _passflag = 0;
		String _pm_no = "N";
		int _pm_seq = 1;
		Map<String, String>  pMap = new HashMap<String, String>();
//		List<Map<String,String>> _belowFlag = null;
//		Map<String,String> _belowComorgFlag = null;
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 네고접수 화면에서 수정한 내용 반영(고객사제출비고,선입고,파일첨부)
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqNegoInfoKEPRQDT", formData);
				if (formData.get("PM_FLAG").equals("Y")){
					_rtnMsg = "정상적으로 네고제출되었으며 일부품목은 품의상신 하여야 합니다.";
					
					if (_passflag < 1){
						
						// KEPMGPHD, KEPMGPDT - 임시 상신 데이터 삭제
						sqlSessionTemplate.update("common.mprq.deleteKEPMGPHD", formData);
						//sqlSessionTemplate.update("common.mprq.deleteKEPMGPDT", formData);
						
						_pm_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM");
						
						_passflag++;
						formData.put("PM_NO", _pm_no);
						sqlSessionTemplate.update("master.mprq.insertNegoKEPMGPHD", formData);
					}
					formData.put("PM_NO", _pm_no);
					formData.put("PM_SEQ", String.valueOf(_pm_seq));
					// STEP3
					sqlSessionTemplate.update("master.mprq.insertNegoKEPMGPDT", formData);
					// STEP4
					_pm_seq++;
					
					formData.put("P_BUYER", formData.get("BUYER"));
					
					// ICOMBYIT_ADD - 임시 생성 데이터 삭제 (결재 시 생성된 데이터 있을 수 있음) - S, K (신규, 기등록만)
					sqlSessionTemplate.update("common.mprq.deleteICOMBYIT_ADD", formData);
					
					sqlSessionTemplate.update("master.mprq.saveIcombyitAdd2", formData);
					/*
					if (formData.get("INIT_BELOW_COMORG_CODE").equals("ALL")){
						
						_belowFlag =  sqlSessionTemplate.selectList("common.mprq.selectComorgcode", formData);
						
						for(int inx= 0; inx < _belowFlag.size() ; inx++){
							_belowComorgFlag = _belowFlag.get(inx);
							formData.put("P_BUYER", _belowComorgFlag.get("COMORG_CODE"));
							sqlSessionTemplate.update("master.mprq.saveIcombyitAdd2", formData);
						}
					} else {
						formData.put("P_BUYER", formData.get("BUYER"));
						sqlSessionTemplate.update("master.mprq.saveIcombyitAdd2", formData);
					}
					*/
				} else {
					// STEP1
					sqlSessionTemplate.update("master.mprq.updateNegoKEPRQDT", formData);
					// STEP2
					sqlSessionTemplate.update("master.mprq.updateNegoKETQTDT", formData);
					// STEP3 고객사로 부터 네고요청 들어온 건에 대해 운영자가 바로 고객사 네고 견적 제출
					sqlSessionTemplate.update("master.mprq.updateNegoICOMCQDT", formData);
					// STEP4
					sqlSessionTemplate.update("master.mprq.updateNegoICOMBYIT", formData);
					// STEP5
					sqlSessionTemplate.update("master.mprq.insertNegoHistory", formData);
					
				}
				
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		
		return pMap;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 견적취소 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqQuotationReceiptSend", formData);
				LOGGER.error("deleteMasterMpRqQuotationReceiptSend 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적을 취소하던중 오류가 발생하였습니다.\n\n관리자에게 문의바랍니다.");
		}

		return _rtnMsg;		
		
	}	

	// 네고 결재 요청 후 처리(SO)
	public String negoRequest(Map<String,String> formData){
		
		List<Map<String,String>> _result = sqlSessionTemplate.selectList("master.mprq.selectNegoApprovalRequestList", formData);
		if(_result.size() >0){
			for(int i=0 ; i<_result.size() ; i++){
				Map<String, String> _pMap = _result.get(i);
				_pMap.put("KEY_2", formData.get("KEY_2")); // BUYER
				_pMap.put("KEY_1", formData.get("KEY_1")); // PM_NO
				_pMap.put("COMPANY", formData.get("COMPANY")); // COMPANY
				_pMap.put("DOCU_NO", formData.get("DOCU_NO")); // PM_NO
				// STEP1
				sqlSessionTemplate.update("master.mprq.updateNegoKETQTDT", _pMap);
				// STEP2
				sqlSessionTemplate.update("master.mprq.updateNegoKEPRQDT2", _pMap);
				if (i == 0) {
					// STEP3 - SMS전송
					sqlSessionTemplate.update("master.mprq.insertArreoSms", _pMap);
					// STEP4 - MAIL전송 PM_SUBMIT_MM
					//sqlSessionTemplate.update("master.mprq.insertMailSend", _pMap);
				}
				// STEP3
//				sqlSessionTemplate.update("master.mprq.updateNegoICOMBYIT_ADD", _pMap);
			}
		}
        
		return "OK";
	}
	
	// 네고 결재 상신취소 후 처리(SO)
	public String negoCancel(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		
		_pMap.put("STATUS", "D");
        
		// STEP0
		sqlSessionTemplate.update("master.mprq.updateCancelICOMBYIT_ADD", _pMap);
		// STEP1
		sqlSessionTemplate.update("master.mprq.updateCancelKEPRQDT", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPHD", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPDT", _pMap);
        
		return "OK";
	}
	
	// 네고 결재 승인 후 처리(SO)
	public String negoApproval(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "A");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
        _pMap.put("KEY_2", formData.get("KEY_2")); // BUYER
		_pMap.put("KEY_1", formData.get("KEY_1")); // PM_NO
		
		// STEP0
		sqlSessionTemplate.update("master.mprq.updateNegoICOMBYIT_ADD", _pMap);
		//nego이력 적재
		sqlSessionTemplate.update("master.mprq.updateApprovalNegoHistory", _pMap);
		// STEP1 - Q 네고 UPDATE
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPRQDTNego", _pMap);

//		String _comorgCode = sqlSessionTemplate.selectOne("master.mprq.getComorgcode",_pMap);
//		
//		if (_comorgCode.equals("ALL")){
//			List<Map<String,String>> _belowFlag = null;
//			Map<String,String> _belowComorgFlag = null;
//			Map<String, String>  _cMap = new HashMap<String, String>();
//			_cMap.put("BUYER", _pMap.get("KEY_2"));
//			_belowFlag =  sqlSessionTemplate.selectList("common.mprq.selectComorgcode", _cMap);
//			
//			for(int inx= 0; inx < _belowFlag.size() ; inx++){
//				_belowComorgFlag = _belowFlag.get(inx);
//				_cMap.put("KEY_2", _belowComorgFlag.get("COMORG_CODE"));
//				_cMap.put("KEY_1", _pMap.get("KEY_1"));
//				
//				// STEP2 - 고객사로 부터 네고요청 들어온 건에 대해 운영자가 바로 고객사 네고 견적 제출		
//				sqlSessionTemplate.update("master.mprq.updateApprovalICOMCQDTAbove", _cMap);
//				// STEP3
//				sqlSessionTemplate.update("master.mprq.updateApprovalICOMBYITAbove", _cMap);
//			}
//		} else {
			// STEP2 - 고객사로 부터 네고요청 들어온 건에 대해 운영자가 바로 고객사 네고 견적 제출		
//			sqlSessionTemplate.update("master.mprq.updateApprovalICOMCQDT", _pMap);
			// STEP3
//			sqlSessionTemplate.update("master.mprq.updateApprovalICOMBYIT", _pMap);			
//		}

		// STEP2 - K 기등록 UPDATE
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPRQDT2", _pMap);
		// STEP3 - 신규등록 품명,규격 UPDATE
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPRQDT3", _pMap);
		// STEP4
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP5
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
		// STEP6 - MAIL(PM_CONFIRM_MM)
		sqlSessionTemplate.update("master.mprq.updateRcApprovalConfirmMail", _pMap);
		
		return "OK";
	}
	
	// 네고 결재 반려 후 처리(SO)
	public String negoReject(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "B");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        
        // STEP0
 		sqlSessionTemplate.update("master.mprq.updateCancelICOMBYIT_ADD", _pMap);
        
		// STEP1
        sqlSessionTemplate.update("master.mprq.updateCancelKEPRQDT", _pMap);
		// STEP2
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPHD", _pMap);
		// STEP3
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPDT", _pMap);
		
		return "OK";
	}
	
	public List<Map<String,String>> negoResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectNegoResultList", param);
		
	}
}

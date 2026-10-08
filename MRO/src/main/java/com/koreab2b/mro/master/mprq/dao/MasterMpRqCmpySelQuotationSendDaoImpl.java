package com.koreab2b.mro.master.mprq.dao;

import java.util.ArrayList;
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

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("masterMpRqCmpySelQuotationSendDao")
@Transactional
public class MasterMpRqCmpySelQuotationSendDaoImpl implements MasterMpRqCmpySelQuotationSendDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqCmpySelQuotationSendList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqCmpySelQuotationSendList", param);
		}
		return resultList;
		
	}

	// 팝업
	public List<Map<String,String>> getMasterMpRqReqUserSelPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqReqUserSelPop", param);
		
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "견적을 취소 하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_2", formData);
				LOGGER.error("deleteMasterMpRqReqQuotReceipt_2 실행 완료");

				// 물질정보제출 취소 처리
				formData.put("st_cancel_note", "견적취소");
				formData.put("USR_ID", formData.get("st_user_id"));
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3", formData);
				LOGGER.error("deleteMasterMpRqReqQuotReceipt_3 실행 완료");
				
				/* 견적 취소 메일 전송 (고객사 특수로직 관리) */
				boolean qt_cancel_mail_flag = CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P04-4056-01");
				
				if(qt_cancel_mail_flag == true){
					sqlSessionTemplate.update("master.mprq.insertMasterMpRqQtCancelMail", formData); //Mail Send
				}
				
				/*프로시저 실행*/
				sqlSessionTemplate.selectList("master.mprq.procQtItemCatalogDelete", formData);
				LOGGER.error("procQtItemCatalogDelete 실행 완료");
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 취소에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "견적을 저장 하였습니다.";		
		//String gplChk ="Y";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				sqlSessionTemplate.update("master.mprq.saveCmpySend", formData);
				
				//GPL 품목 여부 확인									
				//gplChk = (String) sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqGplChk", formData);	
				//if(gplChk.equals("Y")) {
				//	sqlSessionTemplate.update("master.mprq.saveCmpySend", formData);
				//} else {
				//	throw new RuntimeException((i+1) +"번째 행 선정 협력사의 GPL카탈로그가 삭제되어 있습니다.");
				//} 
				
				
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 저장에 실패하였습니다.");
			
		}
		
		return _rtnMsg;		
		
	}	

	// 초기화
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public Map<String,String> initSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "품의상신 하여햐 합니다.";
		String _pm_no = null;
		int _pm_seq = 1;
		Map<String, String> pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				if (i == 0){
					
					_pm_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM");
					formData.put("PM_NO", _pm_no);
					sqlSessionTemplate.update("master.mprq.insertRcKEPMGPHD", formData);
				}
				formData.put("PM_NO", _pm_no);
				formData.put("PM_SEQ", String.valueOf(_pm_seq));
				sqlSessionTemplate.update("master.mprq.insertRcKEPMGPDT", formData);
				_pm_seq++;
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 초기화에 실패하였습니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		
		return pMap;
		
	}	
	
	// 견적초기화 결재 요청 후 처리(RC)
	public String rcRequest(Map<String,String> formData){
		
		List<Map<String,String>> _result = sqlSessionTemplate.selectList("master.mprq.selectNegoApprovalRequestList", formData);
		if(_result.size() >0){
			for(int i=0 ; i<_result.size() ; i++){
				Map<String, String> _pMap = _result.get(i);
				_pMap.put("KEY_2", formData.get("KEY_2")); // BUYER
				_pMap.put("KEY_1", formData.get("KEY_1")); // PM_NO
				_pMap.put("COMPANY", formData.get("COMPANY")); // COMPANY
				_pMap.put("DOCU_NO", formData.get("DOCU_NO")); // PM_NO
				
				// STEP1
				sqlSessionTemplate.update("master.mprq.updateInitKETRQDT", _pMap);
				if (i == 0) {
					// STEP2 - SMS전송
					sqlSessionTemplate.update("master.mprq.insertArreoSms", _pMap);
					// STEP3 - MAIL전송 PM_SUBMIT_MM
					//sqlSessionTemplate.update("master.mprq.insertMailSend", _pMap);
				}
			}
		}
        
		return "OK";
	}
	
	// 견적초기화 결재 상신취소 후 처리(RC)
	public String rcCancel(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		
		_pMap.put("STATUS", "D");
        
		// STEP1
		sqlSessionTemplate.update("master.mprq.updateCancelKEPRQDT", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPHD", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPDT", _pMap);
        
		return "OK";
	}
	
	// 견적초기화 결재 승인 후 처리(RC)
	public String rcApproval(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "A");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
        _pMap.put("KEY_2", formData.get("KEY_2")); // BUYER
		_pMap.put("KEY_1", formData.get("KEY_1")); // PM_NO
        
		// STEP1
		sqlSessionTemplate.update("master.mprq.inseretRcApprovalKEPQTDT_R", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.deleteRcApprovalKETQTDT", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateRcApprovalKEPRQDT", _pMap);
		// STEP4
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP5
		sqlSessionTemplate.update("master.mprq.updateRcApprovalKEPMGPDT", _pMap);
		// STEP6 - MAIL(PM_CONFIRM_MM)
		sqlSessionTemplate.update("master.mprq.updateRcApprovalConfirmMail", _pMap);
		return "OK";
	}
	
	// 견적초기화 결재 반려 후 처리(RC)
	public String rcReject(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "B");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        
		// STEP1
        sqlSessionTemplate.update("master.mprq.updateCancelKEPRQDT", _pMap);
		// STEP2
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPHD", _pMap);
		// STEP3
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPDT", _pMap);
		
		return "OK";
	}
	public List<Map<String,String>> rcResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectRcResultList", param);
	}
	
	// 추가정비 요청
	@SuppressWarnings("unchecked")
	public String updateAfterItemChgReqData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "요청되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqAfterItemChgReq", formData);
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqKepAfterItemMdReq", formData);//추가정비 요청 이력 기존 데이터 삭제
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepAfterItemMdReq", formData);//추가정비 요청 이력 신규 등록
				
				//품목정비요청 운영특이사항 입력.
				formData.put("ADMIN_REMARK", "[추가정비요청] " + formData.get("AFTER_ITEM_CHG_REQ_NOTE"));
				formData.put("st_image_key", formData.get("AFTER_ITEM_CHG_REQ_IMAGE_KEY"));
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
				
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepAfterItemMdReqKepMail", formData);//고객사 담당 운영자에게 메일 발송
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("요청 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 추가정비 제출
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqAfterItmCheSend(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//KEPRQDT 추가정비 제출자 업데이트
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqAfterItmCheSend", formData);
				//KEP_AFTER_ITEM_MD_REQ 추가정비 제출자 이력 업데이트
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqAfterItmMdSend", formData);
				//추가제출 운영특이사항 입력.
				formData.put("st_image_key", "");
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 견적초기화(결재 X)
	@SuppressWarnings("unchecked")
	public Map<String,String> initNewSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "견적 초기화 되었습니다.";
		Map<String, String> pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 견적제출 여부 확인
				int count = 0;
				count = sqlSessionTemplate.selectOne("master.mprq.selectInitKETRQDT", formData);
				
				if(count > 0) {
					// 견적제출 상태이면 초기화 불가(ATOB_UNIT_PRICE 체크)
					throw new RuntimeException("견적제출된 견적건은 초기화가 불가능합니다.");					
				}
				sqlSessionTemplate.update("master.mprq.inseretInitKEPQTDT_R", formData);
				sqlSessionTemplate.update("master.mprq.deleteInitKETQTDT", formData);
				sqlSessionTemplate.update("master.mprq.updateInitKEPRQDT", formData);
				
				// 물질정보제출 취소 처리
				formData.put("st_cancel_note", "견적초기화");
				formData.put("USR_ID", formData.get("st_user_id"));
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 초기화에 실패하였습니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		
		return pMap;
	}	
}

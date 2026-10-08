package com.koreab2b.mro.buyer.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("buyerMpRqRequestForQuotationDao")
@Transactional
public class BuyerMpRqRequestForQuotationDaoImpl implements BuyerMpRqRequestForQuotationDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqRequestForQuotationList", formData);
	}
	
	// 견적생성
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		String _qNo = "";
		Integer _qSeq = 1;
		String _gwNo = "";
		Map<String, String> _pMap = new HashMap<String, String>();
		Map<String, String> _pMap2 = new HashMap<String, String>();
		String _passflag = "N";
		
		try{
			_pMap2.put("st_buyer", formData.get("st_buyer2"));
			
			String passCheck = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassCheck", _pMap2);

			if (passCheck.equals("0")) { // 결재-N
				
			} else { // 결재-Y
				
				String passFlag = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassFlag", _pMap2);
				if (passFlag.equals("N")){
					_passflag = "C";
				} else {
					_passflag = "Y";
				}
			}
			
			if (_passflag == "N" || _passflag == "Y"){
			
				for(int i=0; i < gridData.size(); i++){
					
					formData.putAll((Map<String, String>)gridData.get(i));		
					if (i == 0){
						_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer2"), "RE");
						_rtnMsg = _qNo + " 견적번호가 생성되었습니다.";
						
						if (_passflag == "Y"){
							_gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer2"), "NG");
						}
					}
					formData.put("QUOTATION_NO", _qNo);
					formData.put("QUOTATION_SEQ", _qSeq.toString());
					
					if (_passflag == "N"){
						formData.put("RECV_FLAG", "NW");
					} else {
						formData.put("RECV_FLAG", "NG");
					}
					
					formData.put("GW_NO", _gwNo);
					sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReq", formData);
					sqlSessionTemplate.update("buyer.mp.rq.updateQuotationReq",formData);
					
					if (_passflag == "N"){
						sqlSessionTemplate.update("buyer.mp.rq.updateQuotationReqEndFlag",formData);
					}
					_qSeq++;
					//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					formData.put("DOC_NO", formData.get("st_image_key"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}
			}
				
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		_pMap.put("MSG", _rtnMsg);
		_pMap.put("GW_NO", _gwNo);	
		_pMap.put("passflag", _passflag);
		
		return _pMap;
		
	}
	
	// 결재N
	@SuppressWarnings("unchecked")
	public String updateSelectedDataNoPass(Map<String,String> formData, List<Object> gridData){
		String _rtnMsg = "";
		String _qNo = "";
		Integer _qSeq = 1;
		String _gwNo = "";
		
		try{
			
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String, String>)gridData.get(i));		
				if (i == 0){
					_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer2"), "RE");
					_rtnMsg = _qNo + " 견적번호가 생성되었습니다.";
					
				}
				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				formData.put("RECV_FLAG", "NW");
				
				formData.put("GW_NO", _gwNo);
				sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReq", formData);
				sqlSessionTemplate.update("buyer.mp.rq.updateQuotationReq",formData);
			
				sqlSessionTemplate.update("buyer.mp.rq.updateQuotationReqEndFlag",formData);
				_qSeq++;
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
				
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	
	// 결재Y
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedDataPass(Map<String,String> formData, List<Object> gridData){
		String _rtnMsg = "";
		String _qNo = "";
		Integer _qSeq = 1;
		String _gwNo = "";
		Map<String, String> _pMap = new HashMap<String, String>();
		
		try{
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String, String>)gridData.get(i));		
				if (i == 0){
					_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer2"), "RE");
					_rtnMsg = _qNo + " 견적번호가 생성되었습니다.";
					
					_gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer2"), "NG");
				}
				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				
				formData.put("RECV_FLAG", "NG");
				
				formData.put("GW_NO", _gwNo);
				sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReq", formData);
				sqlSessionTemplate.update("buyer.mp.rq.updateQuotationReq",formData);
				
				_qSeq++;
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
				
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
		_pMap.put("MSG", _rtnMsg);
		_pMap.put("GW_NO", _gwNo);	
		
		return _pMap;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	public String delReqQuotation(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "삭제가 성공적으로 이루어 졌습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("buyer.mp.rq.delReqQuotation",formData);
			}
		}catch(Exception e){
			_rtnMsg = "삭제가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.";
			throw new RuntimeException(_rtnMsg);
//			return _rtnMsg;
		}
		return _rtnMsg;
		
	}
	// 견적의뢰 결재 요청 후 처리(NG)
	public String ngRequest(Map<String,String> formData){
		sqlSessionTemplate.update("buyer.mp.rq.updateNgRequest",formData);
		return "OK";
	}
	
	// 견적의뢰 결재 상신취소 후 처리(NG)
	public String ngCancel(Map<String,String> formData){
        
		return "OK";
	}
	
	// 견적의뢰 결재 승인 후 처리(NG)
	public String ngApproval(Map<String,String> formData){
		
		// STEP1
		sqlSessionTemplate.update("buyer.mp.rq.updateNgApproval", formData);
		return "OK";
	}
	
	// 견적의뢰 결재 반려 후 처리(NG)
	public String ngReject(Map<String,String> formData){

		// STEP1
        sqlSessionTemplate.update("buyer.mp.rq.updateNgReject", formData);
		
		return "OK";
	}
	public String ngReject_v2(Map<String,String> formData){

		// STEP1
        sqlSessionTemplate.update("buyer.mp.rq.updateNgReject_v2", formData);
		
		return "OK";
	}
	
	public List<Map<String,String>> ngResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("buyer.mp.rq.selectNgResultList", param);
	}	
	public List<Map<String,String>> ngResultList_v2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("buyer.mp.rq.selectNgResultList_v2", param);
	}
}

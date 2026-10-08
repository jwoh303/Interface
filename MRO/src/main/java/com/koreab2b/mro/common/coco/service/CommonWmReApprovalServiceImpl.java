package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonWmReApprovalDao;
import com.koreab2b.mro.common.coco.dao.CommonApprovalDao;


@Service("CommonWmReApprovalService")
@Transactional
public class CommonWmReApprovalServiceImpl implements CommonWmReApprovalService {
 
	@Autowired
	private CommonApprovalDao commonApprovalDao;  
	@Autowired
	private CommonWmReApprovalDao CommonWmReApprovalDao;  
 
	 public String approval(Map<String, String> _pMap) {
		 
		 /**  
		@return 
		"9";   // 임시 저장
		"0";   // 결재상태 - 결재중
	 	"1";    // 결재상태 - 반려
		"2";   // 결재상태 - 참조진행
		"3";   // 결재상태 - 결재완료
		  */
		 String   pass_status = commonApprovalDao.approval(_pMap); // 결재,반려 공통
		 
		 String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입		 

		 if ( "3".equals(pass_status)) { // 결재 완료
			 if (DOC_TYPE.equals("REC")||DOC_TYPE.equals("REE")||DOC_TYPE.equals("REM")) { // 반품발주
				 _pMap.put("STATUS", "A");
				CommonWmReApprovalDao.wmreApprovalA(_pMap);
			}
		 }else if ("1".equals(pass_status)){ // 반려 <-- 결재취소
			 if (DOC_TYPE.equals("REC")||DOC_TYPE.equals("REE")||DOC_TYPE.equals("REM")) { // 반품발주
				 _pMap.put("STATUS", "B");
				CommonWmReApprovalDao.wmreApprovalB(_pMap);
			}			 
		 }
		 return "OK";
	 }
  
		public String cancel(Map<String, String> _pMap) { 
			
			String   status =  "";
			String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입
			status = commonApprovalDao.cancel(_pMap); // 상신 취소 공통
			
			if (DOC_TYPE.equals("REC")||DOC_TYPE.equals("REE")||DOC_TYPE.equals("REM")) { // 반품발주
				_pMap.put("STATUS", "D");
				CommonWmReApprovalDao.wmreCancle(_pMap);
			}			
			 return status;
		 }
	
	public String request(Map<String, String> _pMap) {
		 /** 
			업무처리후 필요한값을 _pMap 에 넣어 호출
		  */
		String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입

		_pMap.put("KEY_2", _pMap.get("PARAM1"));
		_pMap.put("KEY_3", _pMap.get("PARAM2")); 
		String DOCU_NO =  commonApprovalDao.request(_pMap); // 상신  공통 <- 구현필요
		/*if (DOC_TYPE.equals("REC")) { // 반품발주취소.
			CommonWmReApprovalDao.wmreRecRequest(_pMap);
		}*/
		return DOCU_NO;
	 }
	//결재화면조회
	public List<Map<String,String>>   approvalWmReListPop(Map<String,String>  _pMap){
		return CommonWmReApprovalDao.approvalWmReListPop(_pMap);
	} 
	// 오류재실행
	public String runlWmReListPop(Map<String,String>  formData){
		return CommonWmReApprovalDao.runlWmReListPop(formData);
	}	 

}

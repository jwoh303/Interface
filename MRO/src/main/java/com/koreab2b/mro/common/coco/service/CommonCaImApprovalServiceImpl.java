package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonApprovalDao;
import com.koreab2b.mro.common.coco.dao.CommonCaImApprovalDao;


@Service("CommonCaImApprovalService")
@Transactional
public class CommonCaImApprovalServiceImpl implements CommonCaImApprovalService {

	@Autowired
	private CommonApprovalDao commonApprovalDao;  
	@Autowired
	private CommonCaImApprovalDao commonCaImApprovalDao;  
	
	// 결재 승인
	public String approval(Map<String, String> _pMap) {
		 
		 /**  
		DOC_TYPE : 
		NG	견적의뢰
		NS	소상합의
		PA	단가승인
		PR	구매요청
		PX	구매발주
		RC	견적초기화
		NCA	신규카탈로그등록
		CA	카탈로그변경
		SR   S/R 신규요청
		DL  자료다운로드
		IM	카탈로그 정보 일괄변경
			
		@return 
		"9";   // 임시 저장
		"0";   // 결재상태 - 결재중
	 	"1";    // 결재상태 - 반려
		"2";   // 결재상태 - 참조진행
		"3";   // 결재상태 - 결재완료
		  */
		 String   pass_status = commonApprovalDao.approval(_pMap); // 결재,반려 공통
		 
		 if ( "3".equals(pass_status)) { // 결재 완료
			///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			 commonCaImApprovalDao.imApproval(_pMap);
		 }else if ("1".equals(pass_status)){ // 반려 <-- 결재취소
			 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			 commonCaImApprovalDao.imReject(_pMap);
		 }
		 return "OK";
	 }
  
	// 상신취소
	public String cancel(Map<String, String> _pMap) { 
			
		String   status =  "";
		status = commonApprovalDao.cancel(_pMap); // 상신 취소 공통
		 if ("OK".equals(status)){
			 commonCaImApprovalDao.imCancel(_pMap);
		 }
		 return status;
	 }
	
	// 품의상신
	public String request(Map<String, String> _pMap) {
		 /** 
			업무처리후 필요한값을 _pMap 에 넣어 호출
		  */
		String DOCU_NO =  commonApprovalDao.request(_pMap); // 상신  공통 <- 구현필요

		commonCaImApprovalDao.imRequest(_pMap);
		return DOCU_NO;
	}
	
	public List<Map<String,String>>   approvalImListPop(Map<String,String>  _pMap) {
		return commonCaImApprovalDao.imResultList(_pMap);
	}
}

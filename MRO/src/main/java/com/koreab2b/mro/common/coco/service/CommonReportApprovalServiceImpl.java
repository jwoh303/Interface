package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonApprovalDao;
import com.koreab2b.mro.common.coco.dao.CommonReportApprovalDao;


@Service("CommonReportApprovalService")
@Transactional
public class CommonReportApprovalServiceImpl implements CommonReportApprovalService {

	@Autowired
	private CommonApprovalDao commonApprovalDao;  
	@Autowired
	private CommonReportApprovalDao commonReportApprovalDao;  
	
	// 결재 승인
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
		 
		 if ( "3".equals(pass_status)) { // 결재 완료
			///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			 commonReportApprovalDao.rptApproval(_pMap);
		 }else if ("1".equals(pass_status)){ // 반려 <-- 결재취소
			 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			 commonReportApprovalDao.rptReject(_pMap);
		 }
		 return "OK";
	 }
  
	// 상신취소
	public String cancel(Map<String, String> _pMap) { 
			
		String   status =  "";
		status = commonApprovalDao.cancel(_pMap); // 상신 취소 공통
		 if ("OK".equals(status)){
			 commonReportApprovalDao.rptCancel(_pMap);
		 }
		 return status;
	 }
	
	// 품의상신
	public String request(Map<String, String> _pMap) {
		 /** 
			업무처리후 필요한값을 _pMap 에 넣어 호출
		  */
		String DOCU_NO =  commonApprovalDao.request(_pMap); // 상신  공통 <- 구현필요

		commonReportApprovalDao.rptRequest(_pMap);
		return DOCU_NO;
	}
	
	public List<Map<String,String>>   approvalReportListPop(Map<String,String>  _pMap) {
		return commonReportApprovalDao.approvalReportListPop(_pMap);
	}
}

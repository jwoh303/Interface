package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonApprovalDao;

@Service("commonApprovalService")
@Transactional
public class CommonApprovalServiceImpl implements CommonApprovalService {

	@Autowired
	private CommonApprovalDao commonApprovalDao;  
	
	public List<Map<String,String>> buyerNewPassRecvList(Map<String,String>  _pMap){
		return commonApprovalDao.buyerNewPassRecvList(_pMap);
	}
	public List<Map<String,String>> buyerNewPassCompleteList(Map<String,String>  _pMap){
		return commonApprovalDao.buyerNewPassCompleteList(_pMap);
	}
	public List<Map<String,String>>  buyerNewPassSendList(Map<String,String>  _pMap){
		return commonApprovalDao.buyerNewPassSendList(_pMap);
	}
	public List<Map<String,String>> buyerNewPassList_v2(Map<String,Object>  _pMap){
		return commonApprovalDao.buyerNewPassList_v2(_pMap);
	}
	
	 public List<Map<String,String>>  getCommonApprovalListPop(Map<String,String>  _pMap) {
		 return commonApprovalDao.getCommonApprovalListPop(_pMap);
	 }
	 public List<Map<String,String>>  getCommonApprovalListPop_v2(Map<String,Object>  _pMap) {
		 return commonApprovalDao.getCommonApprovalListPop_v2(_pMap);
	 }
	 
	 public Map<String,Object>  getBuyerCommonMyPagePop(Map<String,String>  _pMap) {
		 return commonApprovalDao.getBuyerCommonMyPagePop(_pMap);
	 }
	 public Map<String,Object>  getBuyerCommonPrPxData(Map<String,String>  _pMap) {
		 return commonApprovalDao.getBuyerCommonPrPxData(_pMap);
	 }
	 public Map<String,Object>  getBuyerCommonNgNsData(Map<String,String>  _pMap) {
		 return commonApprovalDao.getBuyerCommonNgNsData(_pMap);
	 }
	 
	public List<Map<String,String>>   getApprovalLine(Map<String,String>  _pMap){
		 return commonApprovalDao.getApprovalLine(_pMap);
	 }
	public List<Map<String,String>>   getApprovalLine_v2(Map<String,String>  _pMap){
		 return commonApprovalDao.getApprovalLine_v2(_pMap);
	 }
	public Map<String,Object>  getApprovalInfo(Map<String,String>  _pMap){
		 return commonApprovalDao.getApprovalInfo(_pMap);
	 }

	public List<Map<String,String>>   getCateApprovalLine(Map<String,String>  _pMap){
		 return commonApprovalDao.getCateApprovalLine(_pMap);
	 }

	public List<Map<String,String>>   getMultiPassLine(Map<String,String>  _pMap){
		 return commonApprovalDao.getMultiPassLine(_pMap);
	 }
	public List<Map<String,String>>   getMultiPassLine_v2(Map<String,Object>  _pMap){
		 return commonApprovalDao.getMultiPassLine_v2(_pMap);
	 }
	
	public List<Map<String,String>>   getCurrentPassLine_v2(Map<String,Object>  _pMap){
		 return commonApprovalDao.getCurrentPassLine_v2(_pMap);
	 }
	
		
	 public String approval(Map<String, String> _pMap) {
		 
		 /**
		  * 견적의뢰
			소상합의
			단가승인
			주문요청
			구매발주
			--> 각업무별 다른 파일로 결재승인 해당업무구현 후
			아래의 공통함수 반드시 호출필요
			
			
		@return 
		"9";   // 임시 저장
		"0";   // 결재상태 - 결재중
	 	"1";    // 결재상태 - 반려
		"2";   // 결재상태 - 참조진행
		"3";   // 결재상태 - 결재완료
		  */
		 return commonApprovalDao.approval(_pMap); // 결재,반려 공통
	 }
	 //메일재발송
	public String commonApprovalMailSend(Map<String, String> _pMap) {
		 return commonApprovalDao.commonApprovalMailSend(_pMap);
	 } 
	public String updateContent(Map<String, String> _pMap) {
		 return commonApprovalDao.updateContent(_pMap);
	 }
	public String updateContent_v2(Map<String, String> _pMap) {
		 return commonApprovalDao.updateContent_v2(_pMap);
	 }
	public String cancel(Map<String, String> _pMap) {
		 /**
		  * 견적의뢰
			소상합의
			단가승인
			주문요청
			구매발주
			--> 각업무별 다른 파일로 상신취소 해당업무구현 후
			아래의 공통함수 반드시 호출필요
		  */
		 return commonApprovalDao.cancel(_pMap); // 상신 취소 공통
	 }
	
	public String request(Map<String, String> _pMap) {
		 /**
		  * 견적의뢰
			소상합의
			단가승인
			주문요청
			구매발주
			--> 각업무별 다른 파일로  상신 해당업무구현 후
			아래의 공통함수 반드시 호출필요
			
			@param BIZ_KEY : 업무에서 만든키 넣을것
		  */
		 return commonApprovalDao.request(_pMap); // 상신  공통 <- 구현필요
	 }
	
	public String request_temp(Map<String, String> _pMap) {
		 /**
		  * 견적의뢰
			소상합의
			단가승인
			주문요청
			구매발주
			--> 각업무별 다른 파일로  상신 해당업무구현 후
			아래의 공통함수 반드시 호출필요
		  */
		 return commonApprovalDao.request_temp(_pMap); // 상신  공통 <- 구현필요
	 }
	
	public String reject(Map<String, String> _pMap) {
		 /**
		  * 견적의뢰
			소상합의
			단가승인
			주문요청
			구매발주
			--> 각업무별 다른 파일로  결재 반려  해당업무구현 후
			아래의 공통함수 반드시 호출필요
		  */
		return commonApprovalDao.approval(_pMap); // 결재반려 공통
	 }
	
	
	public void test(Map<String, String> _pMap) {
		 commonApprovalDao.test(_pMap);
		 commonApprovalDao.test1(_pMap);
	}
	
	public void test1(Map<String, String> _pMap) {
		 commonApprovalDao.test1(_pMap);
	}
	
	/**
	 * 구매요청 발주조회
	 */
	public List<Map<String,String>>   approvalPrListPop(Map<String,String>  _pMap){
		 return commonApprovalDao.approvalPrListPop(_pMap);
	}
	public List<Map<String,String>>   approvalPrListPop_v2(Map<String,Object>  _pMap){
		 return commonApprovalDao.approvalPrListPop_v2(_pMap);
	}
	/**
	 * 구매발주 발주조회
	 */
	public List<Map<String,String>>   approvalPxListPop(Map<String,String>  _pMap){
		 return commonApprovalDao.approvalPxListPop(_pMap);
	} 
	public List<Map<String,String>>   approvalPxListPop_v2(Map<String,Object>  _pMap){
		 return commonApprovalDao.approvalPxListPop_v2(_pMap);
	} 
	public List<Map<String,String>>   approvalPxListPop2(Map<String,String>  _pMap){
		 return commonApprovalDao.approvalPxListPop2(_pMap);
	} 	
	public  List<Map<String,String>> getIcomTrgwList(Map<String, String> _pMap) {
		 return commonApprovalDao.getIcomTrgwList(_pMap);
	}
	
	public List<Map<String,String>>   approvalOeListPop(Map<String,String>  _pMap){
		 return commonApprovalDao.approvalOeListPop(_pMap);
	} 
	public List<Map<String,String>>   approvalOfListPop(Map<String,String>  _pMap) {
		 return commonApprovalDao.approvalOfListPop(_pMap);
	} 
	// 바로주문
	public String rejectPrListPop(Map<String,String>  formData){
		return commonApprovalDao.rejectPrListPop(formData);
	}
	public String rejectPrListPop_v2(Map<String,String>  formData){
		return commonApprovalDao.rejectPrListPop_v2(formData);
	}
	public String rejectNgNsListPop_v2(Map<String,String>  formData){
		return commonApprovalDao.rejectNgNsListPop_v2(formData);
	}
	
	// 중앙대 전용 결재대상조회
	public List<Map<String,String>> buyerCauNewPassRecvList(Map<String,String>  _pMap){
		return commonApprovalDao.buyerCauNewPassRecvList(_pMap);
	}
	// 중앙대 전용 결재대상조회 엑셀다운로드
	public List<Map<String,String>> buyerCauNewPassRecvExcelList(Map<String,String>  _pMap){
		return commonApprovalDao.buyerCauNewPassRecvExcelList(_pMap);
	}
	// 중앙대 전용 결재문서 상세 아이비시트 사용
	public List<Map<String,String>> getBuyerCauCommonMyPagePopPrList(Map<String,Object>  param) {
		return commonApprovalDao.getBuyerCauCommonMyPagePopPrList(param);
	}
	// 중앙대 전용 결재문서 상세 팝업 조회
	public Map<String,Object>  getBuyerCauCommonMyPagePop(Map<String,String>  _pMap) {
		 return commonApprovalDao.getBuyerCauCommonMyPagePop(_pMap);
	}
	//고객사 주문 결재 일괄 반려처리
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return commonApprovalDao.updateSelectedData(formData, gridData);
	}
	
	// 고객사 별 결재 포함 필수
	@Override
	public List<Map<String, String>> getBuyerApprovalLine(Map<String, String> pMap) {
		return commonApprovalDao.getBuyerApprovalLine(pMap);
	}
	
	// 카탈로그 계약변경 일괄수정(엑셀다운로드)
	public List<Map<String, String>> getExcelDownCamList(Map<String, String> pMap) {
		return commonApprovalDao.getExcelDownCamList(pMap);
	}
	
	@Transactional
	public String updatePassLine_v2(Map<String,String>  formData, List<Object> gridData) {
		return commonApprovalDao.updatePassLine_v2(formData, gridData);
	}
	@Transactional
	public String updatePassLine_v3(Map<String,String>  formData, List<Object> gridData) {
		return commonApprovalDao.updatePassLine_v3(formData, gridData);
	}
	
	@Transactional
	public String insertAppPath_v2(Map<String,String>  formData, List<Object> gridData) {
		return commonApprovalDao.insertAppPath_v2(formData, gridData);
	}
	
	public String deleteMyPassLine_v2(Map<String, String> _pMap) {
		 return commonApprovalDao.deleteMyPassLine_v2(_pMap);
	 }
	
	
}

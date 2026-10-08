package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqRequestForQuotationDao;
import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqRequestQuotationTempDao;
import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqUnitpriceAgrmntNegoReqDao;
import com.koreab2b.mro.common.coco.dao.CommonApprovalDao;
import com.koreab2b.mro.common.mdcm.dao.MasterMdCmBuyerCatalogAlterPopDao;
import com.koreab2b.mro.common.mdsr.dao.MasterMdSrSrDetailPopDao;
import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogAlterDao;
import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogRegDao;
import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogRegProgressDao;
import com.koreab2b.mro.master.mdsr.dao.MasterMdSrSrNewReqDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqQuotationReceiptSendDao;


@Service("CommonNgNsRcPaApprovalService")
@Transactional
public class CommonNgNsRcPaApprovalServiceImpl implements CommonNgNsRcPaApprovalService {

	@Autowired
	private CommonApprovalDao commonApprovalDao;  
	@Autowired
	private MasterMpRqQuotationReceiptSendDao masterMpRqQuotationReceiptSendDao;  
	@Autowired
	private MasterMpRqCmpySelQuotationSendDao masterMpRqCmpySelQuotationSendDao;  
	@Autowired
	private MasterMdCmCatalogRegDao masterMdCmCatalogRegDao;  
	@Autowired
	private MasterMdCmBuyerCatalogAlterPopDao masterMdCmBuyerCatalogAlterPopDao;  
	@Autowired
	private MasterMdSrSrNewReqDao masterMdSrSrNewReqDao;
	@Autowired
	private BuyerMpRqUnitpriceAgrmntNegoReqDao buyerMpRqUnitpriceAgrmntNegoReqDao;  
	@Autowired
	private BuyerMpRqRequestForQuotationDao buyerMpRqRequestForQuotationDao;  
	@Autowired
	private MasterMdCmCatalogAlterDao masterMdCmCatalogAlterDao;
	@Autowired
	private MasterMdSrSrDetailPopDao masterMdSrSrDetailPopDao;
	@Autowired
	private BuyerMpRqRequestQuotationTempDao buyerMpRqRequestQuotationTempDao;
	@Autowired
	private MasterMdCmCatalogRegProgressDao masterMdCmCatalogRegProgressDao;
	
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
			
		@return 
		"9";   // 임시 저장
		"0";   // 결재상태 - 결재중
	 	"1";    // 결재상태 - 반려
		"2";   // 결재상태 - 참조진행
		"3";   // 결재상태 - 결재완료
		  */
		 String   pass_status = commonApprovalDao.approval(_pMap); // 결재,반려 공통
		 
		 String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입
		 String KEY_1 = _pMap.get("KEY_1").toString(); // 업무의키		 
		 String DOCU_NO = _pMap.get("DOCU_NO").toString(); // 결재의키
		 if ( "3".equals(pass_status)) { // 결재 완료
			 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			if (DOC_TYPE.equals("SO")) { // 신규소싱
				masterMpRqQuotationReceiptSendDao.negoApproval(_pMap);
			} else if (DOC_TYPE.equals("RC")) { // 견적초기화
				masterMpRqCmpySelQuotationSendDao.rcApproval(_pMap);
			} else if (DOC_TYPE.equals("NS")) { // 소싱합의
				buyerMpRqUnitpriceAgrmntNegoReqDao.nsApproval(_pMap);
			} else if (DOC_TYPE.equals("NG")) { // 견적의뢰
				buyerMpRqRequestForQuotationDao.ngApproval(_pMap);
			} else if (DOC_TYPE.equals("NCA")) { // 신규카탈로그등록
				masterMdCmCatalogRegDao.ncaApproval(_pMap);
			} else if (DOC_TYPE.equals("CA")) { // 카탈로그변경
				masterMdCmBuyerCatalogAlterPopDao.caApproval(_pMap);
			} else if (DOC_TYPE.equals("SR")) { //S/R 신규요청
				masterMdSrSrNewReqDao.srApproval(_pMap);
			}else if (DOC_TYPE.equals("CAM")) { // 카탈로그변경 (일괄)
				masterMdCmCatalogAlterDao.approvalMasterMdCmCatalogSearchPop(_pMap);
			}else if (DOC_TYPE.equals("CCA")) { // 계약추가
				masterMdCmBuyerCatalogAlterPopDao.approvalAppendCqdt(_pMap);
			}else if (DOC_TYPE.equals("IF")) { // IF단가변경
				masterMdCmBuyerCatalogAlterPopDao.approvalIfPrice(_pMap);
			}else if (DOC_TYPE.equals("DL")) { // IF단가변경
				masterMdSrSrNewReqDao.srDataApproval(_pMap);
			} else if (DOC_TYPE.equals("RCT")) { // 재계약
				masterMdCmBuyerCatalogAlterPopDao.rctApproval(_pMap);
			} else if (DOC_TYPE.equals("CRS")) { // 카탈로그등록요청 소싱제출
				masterMdCmCatalogRegProgressDao.crsApproval(_pMap);
			} else if (DOC_TYPE.equals("CRU")) { // 카탈로그등록요청 판가제출
				masterMdCmCatalogRegProgressDao.cruApproval(_pMap);
			} else if (DOC_TYPE.equals("CAST")) { // 카탈로그상태 변경
				masterMdCmBuyerCatalogAlterPopDao.caStApproval(_pMap);
			}
		 }else if ("1".equals(pass_status)){ // 반려 <-- 결재취소
			 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			if (DOC_TYPE.equals("SO")) { // 신규소싱
				masterMpRqQuotationReceiptSendDao.negoReject(_pMap);
			} else if (DOC_TYPE.equals("RC")) { // 견적초기화
				masterMpRqCmpySelQuotationSendDao.rcReject(_pMap);
			} else if (DOC_TYPE.equals("NS")) { // 소싱합의
				buyerMpRqUnitpriceAgrmntNegoReqDao.nsReject(_pMap);
			} else if (DOC_TYPE.equals("NG")) { // 견적의회
				buyerMpRqRequestForQuotationDao.ngReject(_pMap);
			} else if (DOC_TYPE.equals("NCA")) { // 신규카탈로그등록
				masterMdCmCatalogRegDao.ncaReject(_pMap);
			} else if (DOC_TYPE.equals("CA") || DOC_TYPE.equals("CAM")|| DOC_TYPE.equals("CAST")) { // 카탈로그변경 , (일괄)
				masterMdCmBuyerCatalogAlterPopDao.caReject(_pMap);
			} else if (DOC_TYPE.equals("SR")) { //S/R 신규요청
				masterMdSrSrNewReqDao.srReject(_pMap);
			} else if (DOC_TYPE.equals("CCA")) { //S/R 신규요청
				masterMdCmBuyerCatalogAlterPopDao.caReject(_pMap);
			} else if (DOC_TYPE.equals("DL")) { //S/R 신규요청
				masterMdSrSrNewReqDao.srReject(_pMap);
			} else if (DOC_TYPE.equals("RCT")) { // 재계약
				masterMdCmBuyerCatalogAlterPopDao.rctReject(_pMap);
			} else if (DOC_TYPE.equals("CRS")) { // 카탈로그등록요청 소싱제출
				masterMdCmCatalogRegProgressDao.crsReject(_pMap);
			} else if (DOC_TYPE.equals("CRU")) { // 카탈로그등록요청 판가제출
				masterMdCmCatalogRegProgressDao.cruReject(_pMap);
			}
			 
		 }
		 return "OK";
	 }
	public String approval_v2(Map<String, String> _pMap) {
		 
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
			
		@return 
		"9";   // 임시 저장
		"0";   // 결재상태 - 결재중
	 	"1";    // 결재상태 - 반려
		"2";   // 결재상태 - 참조진행
		"3";   // 결재상태 - 결재완료
		  */
		 String   pass_status = commonApprovalDao.approval(_pMap); // 결재,반려 공통
		 
		 String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입
		 String KEY_1 = _pMap.get("KEY_1").toString(); // 업무의키		 
		 String DOCU_NO = _pMap.get("DOCU_NO").toString(); // 결재의키
		 if ( "3".equals(pass_status)) { // 결재 완료
			 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			if (DOC_TYPE.equals("SO")) { // 신규소싱
				masterMpRqQuotationReceiptSendDao.negoApproval(_pMap);
			} else if (DOC_TYPE.equals("RC")) { // 견적초기화
				masterMpRqCmpySelQuotationSendDao.rcApproval(_pMap);
			} else if (DOC_TYPE.equals("NS")) { // 소싱합의
				buyerMpRqUnitpriceAgrmntNegoReqDao.nsApproval(_pMap);
			} else if (DOC_TYPE.equals("NG")) { // 견적의뢰
				buyerMpRqRequestForQuotationDao.ngApproval(_pMap);
			} else if (DOC_TYPE.equals("NCA")) { // 신규카탈로그등록
				masterMdCmCatalogRegDao.ncaApproval(_pMap);
			} else if (DOC_TYPE.equals("CA")) { // 카탈로그변경
				masterMdCmBuyerCatalogAlterPopDao.caApproval(_pMap);
			} else if (DOC_TYPE.equals("SR")) { //S/R 신규요청
				masterMdSrSrNewReqDao.srApproval(_pMap);
			}else if (DOC_TYPE.equals("CAM")) { // 카탈로그변경 (일괄)
				masterMdCmCatalogAlterDao.approvalMasterMdCmCatalogSearchPop(_pMap);
			}else if (DOC_TYPE.equals("CCA")) { // 계약추가
				masterMdCmBuyerCatalogAlterPopDao.approvalAppendCqdt(_pMap);
			}else if (DOC_TYPE.equals("IF")) { // IF단가변경
				masterMdCmBuyerCatalogAlterPopDao.approvalIfPrice(_pMap);
			}else if (DOC_TYPE.equals("DL")) { // IF단가변경
				masterMdSrSrNewReqDao.srDataApproval(_pMap);
			} else if (DOC_TYPE.equals("RCT")) { // 재계약
				masterMdCmBuyerCatalogAlterPopDao.rctApproval(_pMap);
			} else if (DOC_TYPE.equals("CRS")) { // 카탈로그등록요청 소싱제출
				masterMdCmCatalogRegProgressDao.crsApproval(_pMap);
			} else if (DOC_TYPE.equals("CRU")) { // 카탈로그등록요청 판가제출
				masterMdCmCatalogRegProgressDao.cruApproval(_pMap);
			} else if (DOC_TYPE.equals("CAST")) { // 카탈로그상태 변경
				masterMdCmBuyerCatalogAlterPopDao.caStApproval(_pMap);
			}
		 }else if ("1".equals(pass_status)){ // 반려 <-- 결재취소
			 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
			if (DOC_TYPE.equals("SO")) { // 신규소싱
				masterMpRqQuotationReceiptSendDao.negoReject(_pMap);
			} else if (DOC_TYPE.equals("RC")) { // 견적초기화
				masterMpRqCmpySelQuotationSendDao.rcReject(_pMap);
			} else if (DOC_TYPE.equals("NS")) { // 소싱합의
				buyerMpRqUnitpriceAgrmntNegoReqDao.nsReject(_pMap);
			} else if (DOC_TYPE.equals("NG")) { // 견적의회
				buyerMpRqRequestForQuotationDao.ngReject_v2(_pMap);
			} else if (DOC_TYPE.equals("NCA")) { // 신규카탈로그등록
				masterMdCmCatalogRegDao.ncaReject(_pMap);
			} else if (DOC_TYPE.equals("CA") || DOC_TYPE.equals("CAM")|| DOC_TYPE.equals("CAST")) { // 카탈로그변경 , (일괄)
				masterMdCmBuyerCatalogAlterPopDao.caReject(_pMap);
			} else if (DOC_TYPE.equals("SR")) { //S/R 신규요청
				masterMdSrSrNewReqDao.srReject(_pMap);
			} else if (DOC_TYPE.equals("CCA")) { //S/R 신규요청
				masterMdCmBuyerCatalogAlterPopDao.caReject(_pMap);
			} else if (DOC_TYPE.equals("DL")) { //S/R 신규요청
				masterMdSrSrNewReqDao.srReject(_pMap);
			} else if (DOC_TYPE.equals("RCT")) { // 재계약
				masterMdCmBuyerCatalogAlterPopDao.rctReject(_pMap);
			} else if (DOC_TYPE.equals("CRS")) { // 카탈로그등록요청 소싱제출
				masterMdCmCatalogRegProgressDao.crsReject(_pMap);
			} else if (DOC_TYPE.equals("CRU")) { // 카탈로그등록요청 판가제출
				masterMdCmCatalogRegProgressDao.cruReject(_pMap);
			}
			 
		 }
		 return "OK";
	 }
  
		public String cancel(Map<String, String> _pMap) { 
			
			String   status =  "";
			status = commonApprovalDao.cancel(_pMap); // 상신 취소 공통
			 if ("OK".equals(status)){
				 
				 String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입
				 String KEY_1 = _pMap.get("KEY_1").toString(); // 업무의키		 
				 String DOCU_NO = _pMap.get("DOCU_NO").toString(); // 결재의키 
 
				if (DOC_TYPE.equals("SO")) { // 신규소싱
					masterMpRqQuotationReceiptSendDao.negoCancel(_pMap);
				} else if (DOC_TYPE.equals("RC")) { // 견적초기화
					masterMpRqCmpySelQuotationSendDao.rcCancel(_pMap);
				} else if (DOC_TYPE.equals("NS")) { // 소싱합의
					buyerMpRqUnitpriceAgrmntNegoReqDao.nsCancel(_pMap);
				} else if (DOC_TYPE.equals("NG")) { // 견적의뢰
					buyerMpRqRequestForQuotationDao.ngCancel(_pMap);
				} else if (DOC_TYPE.equals("NCA")) { // 신규카탈로그등록
					masterMdCmCatalogRegDao.ncaCancel(_pMap);
				} else if (DOC_TYPE.equals("CA") || DOC_TYPE.equals("CAM")|| DOC_TYPE.equals("CAST")) { // 카탈로그변경 , (일괄), 카탈로그 상태변경
					masterMdCmBuyerCatalogAlterPopDao.caCancel(_pMap);
				} else if (DOC_TYPE.equals("SR")) { //S/R 신규요청
					masterMdSrSrNewReqDao.srCancel(_pMap);
				} else if (DOC_TYPE.equals("RCT")) { //재계약처리
					masterMdCmCatalogRegDao.rctCancel(_pMap);
				} else if (DOC_TYPE.equals("CRS")) { //카탈로그등록요청 소싱제출
					masterMdCmCatalogRegProgressDao.crsCancel(_pMap);
				} else if (DOC_TYPE.equals("CRU")) { //카탈로그등록요청 판가제출
					masterMdCmCatalogRegProgressDao.cruCancel(_pMap);
				}
				 
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

		if (DOC_TYPE.equals("SO")) { // 신규소싱
			masterMpRqQuotationReceiptSendDao.negoRequest(_pMap);
		} else if (DOC_TYPE.equals("RC")) { // 견적초기화
			masterMpRqCmpySelQuotationSendDao.rcRequest(_pMap);
		} else if (DOC_TYPE.equals("NS")) { // 소싱합의
			buyerMpRqUnitpriceAgrmntNegoReqDao.nsRequest(_pMap);
		} else if (DOC_TYPE.equals("NG")) { // 견적의뢰
			buyerMpRqRequestForQuotationDao.ngRequest(_pMap);
		} else if (DOC_TYPE.equals("NCA")) { // 신규카탈로그등록
			masterMdCmCatalogRegDao.ncaRequest(_pMap);
		} else if (DOC_TYPE.equals("CA") || DOC_TYPE.equals("CAM") || DOC_TYPE.equals("CAST")) { // 카탈로그변경, 카탈로그 상태변경
			masterMdCmBuyerCatalogAlterPopDao.caRequest(_pMap);
		} else if (DOC_TYPE.equals("SR")) { //S/R 신규요청
			masterMdSrSrNewReqDao.srRequest(_pMap);
		} else if (DOC_TYPE.equals("RCT")) { //재계약
			masterMdCmBuyerCatalogAlterPopDao.rctRequest(_pMap);
		} else if (DOC_TYPE.equals("CRS")) { //카탈로그등록요청 소싱제출
			masterMdCmCatalogRegProgressDao.crsRequest(_pMap);
		} else if (DOC_TYPE.equals("CRU")) { //카탈로그등록요청 판가제출
			masterMdCmCatalogRegProgressDao.cruRequest(_pMap);
		}
		return DOCU_NO;
	 }
	
	/**
	 * 임시용 PR - PX 는 사용
	 */
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
	
	
	public List<Map<String,String>>   approvalNgListPop(Map<String,String>  _pMap) {
		return buyerMpRqRequestForQuotationDao.ngResultList(_pMap);   
	}
	public List<Map<String,String>>   approvalNsListPop(Map<String,String>  _pMap) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.nsResultList(_pMap);
	}
	public List<Map<String,String>>   approvalNgListPop_v2(Map<String,Object>  _pMap) {
		return buyerMpRqRequestForQuotationDao.ngResultList_v2(_pMap);   
	}
	public List<Map<String,String>>   approvalNsListPop_v2(Map<String,Object>  _pMap) {
		return buyerMpRqUnitpriceAgrmntNegoReqDao.nsResultList_v2(_pMap);
	}
	public List<Map<String,String>>   approvalPaListPop(Map<String,String>  _pMap) {
		return null; // 구현   
	}
	public List<Map<String,String>>   approvalRcListPop(Map<String,String>  _pMap) {
		return masterMpRqCmpySelQuotationSendDao.rcResultList(_pMap);
	}
	public List<Map<String,String>>   approvalSoListPop(Map<String,String>  _pMap) {
		return masterMpRqQuotationReceiptSendDao.negoResultList(_pMap);
	}
	public List<Map<String,String>>   approvalNcaListPop(Map<String,String>  _pMap) {
		return masterMdCmCatalogRegDao.ncaResultList(_pMap);    
	}
	public List<Map<String,String>>   approvalScaListPop(Map<String,String>  _pMap) {
		return masterMdCmCatalogRegDao.scaResultList(_pMap);    
	}
	public List<Map<String,String>>   approvalCaListPop(Map<String,String>  _pMap) {
		return masterMdCmBuyerCatalogAlterPopDao.caResultList(_pMap);    
	}
	public List<Map<String,String>>   approvalSrListPop(Map<String,String>  _pMap) {
		return masterMdSrSrDetailPopDao.srResultList(_pMap);
	}
	public String setRqdtRecvFlagToNg(Map<String,String>  formData){
		return buyerMpRqRequestQuotationTempDao.setRqdtRecvFlagToNg(formData);
	}
	public List<Map<String,String>>   approvalRctListPop(Map<String,String>  _pMap) {
		return masterMdCmBuyerCatalogAlterPopDao.approvalRctListPop(_pMap);
	}
	public List<Map<String,String>>   approvalCaRqListPop(Map<String,String>  _pMap) {
		return masterMdCmCatalogRegProgressDao.caRqResultList(_pMap);    
	}
	public List<Map<String,String>>   approvalCaStListPop(Map<String,String>  _pMap) {
		return masterMdCmBuyerCatalogAlterPopDao.caStResultList(_pMap);    
	}
}

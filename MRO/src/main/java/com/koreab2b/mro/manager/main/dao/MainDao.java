package com.koreab2b.mro.manager.main.dao;

import java.util.List;
import java.util.Map;

public interface MainDao {
	
	List<Map<String,String>> getIdFindSome(Map<String,String>  pMap);
	
	void insertLog(Map<String,String>  pMap);
	
	String insertOtp(Map<String,String>  pMap);
	
	String getOtpAuhen(Map<String,String>  pMap);
	
	String getPwFindCheck(Map<String,String>  pMap);
	
	String setNewPw(Map<String,String>  pMap);
	
	List<Map<String,String>> getNewAgentHomeFindTotal(Map<String,String>  pMap);
	List<Map<String,String>> getNewAgentHomeFindTotal_v2(Map<String,String>  pMap);
	
	List<Map<String,String>> getNewAgentHomeboardSelList(Map<String,String>  pMap);
	List<Map<String,String>> getNewAgentHomeboardSelList_v2(Map<String,String>  pMap);
	
	List<Map<String,String>> getNewAgentHomePoMngTotal_v2(Map<String,String>  pMap);

	// 협력사 메인 공지사항 분리 (ICOMBOARD_NOTICE 기반)
	List<Map<String,String>> getCommonNoticeList_v2(Map<String,String>  pMap);		// [공통 공지사항]
	List<Map<String,String>> getCompanyNoticeList_v2(Map<String,String>  pMap);		// [거래사별 공지사항]
	Map<String,Object> getUnreadNoticeCount_v2(Map<String,String>  pMap);			// [미확인 공지 건수]

	List<Map<String,String>> getNewExportHomeboardSelList(Map<String,String>  pMap);
	//게시판
	List<Map<String,String>> getB2bBoardList(Map<String,String>  pMap);
	//고객도우미
	List<Map<String,String>> getBuyerVocUserSql(Map<String,String>  pMap);
	//BM정보
	List<Map<String,String>> getBuyerBmUserSql(Map<String,String>  pMap);	
	//장바구니,상품주문,결재상신,결재대상,신규상품요청,발주대상
	List<Map<String,String>> getBuyerStatusCountMainSql(Map<String,String>  pMap);
	List<Map<String,String>> getBuyerStatusCountMainSql_v2(Map<String,String>  pMap);
	//예산조회
	List<Map<String,String>> getBuyerBdgtAmt_v2(Map<String,String>  pMap);
	//펀치아웃메인
	List<Map<String,String>> getBuyerStatusCountPCOMainSql(Map<String,String>  pMap);
	
	//결재여부
	List<Map<String,String>> getCompanyPass(Map<String,String>  pMap);
	
	//사용자의 결재 유효성 체크
	List<Map<String,String>> getUserGwPass(Map<String,String>  pMap);

	//메뉴얼
	List<Map<String,String>> getManualInfo(Map<String,String>  pMap);
	
	//MRO 바로가기
	List<Map<String,String>> getShortCutSso(Map<String,String>  pMap);
	
	//VOC 요청
	String CreateSrReq(Map<String,String>  pMap);
	//VOC 결과보기
	List<Map<String,String>> getCustomerCenterList(Map<String,String>  pMap);
	List<Map<String,String>> getCustomerCenterList_v2(Map<String,Object>  pMap);
	 
	//마이페이지 주문정보
	List<Map<String,String>> getCustomerOrderInfo_v2(Map<String,String>  pMap);
	
	String setCustomerRubUpdate(Map<String,String>  pMap);
	String vocCancel_v2(Map<String,String>  pMap); 
	List<Map<String,String>> getCustomerCenterPop(Map<String,String>  pMap);
	

	List<Map<String,String>> getMasterMainInfo(Map<String,String>  pMap);
	
	List<Map<String,String>> getNoticeList(Map<String,String>  pMap);
	
	List<Map<String,String>> getNoticeDetailList(Map<String,String>  pMap);

	List<Map<String,String>> getBuyerSmsCertList(Map<String,String>  pMap);
	
	// 수출시스템 메인화면 차트데이터
	List<Map<String,String>> getExportHomeChartList(Map<String,String>  pMap);
	
	List<Map<String,String>> getMypage1List(Map<String,String>  pMap);
	List<Map<String,String>> getMypage2List(Map<String,String>  pMap);
	// 패스워드 확인 후 개인정보로 이동
	public Map<String, String> getSubPwInsert(Map<String,String> pMap);
}

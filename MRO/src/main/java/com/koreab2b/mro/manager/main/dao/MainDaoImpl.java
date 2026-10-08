package com.koreab2b.mro.manager.main.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SecurHashAlgorithmUtil;

@Repository("mainDao")
public class MainDaoImpl implements MainDao {
	private static final Logger logger = LoggerFactory.getLogger(MainDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	private String _rtnMsg = "";
	
	public List<Map<String,String>> getB2bBoardList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getB2bBoardList", pMap);
	};
	
	public List<Map<String,String>> getIdFindSome(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getIdFindSome", pMap);
	};
	
	public void insertLog(Map<String,String>  pMap){
		sqlSessionTemplate.update("main.insertLog", pMap);
	}
	
	// 인증번호 발송
	public String insertOtp(Map<String,String>  pMap) {
		_rtnMsg = "인증번호를 정상으로 발송 하였습니다.";

		try{
			//난수발생
			String otp = sqlSessionTemplate.selectOne("main.selectNoAuth");
			pMap.put("OTP", otp);
			
			//인증번호 insert 수행
			sqlSessionTemplate.insert("main.insertOtp", pMap);
			//SMS 전송
			sqlSessionTemplate.update("main.insertSMS", pMap);
			//LOG 삽입
			sqlSessionTemplate.update("main.insertOtpLog", pMap);
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("인증번호 발송에 실패 하였습니다.\n\n다시 확인 후 진행 바랍니다.");
		}
		return _rtnMsg;
	}
	
	public String getOtpAuhen(Map<String,String>  pMap) {
		String status = sqlSessionTemplate.selectOne("main.selectAuhenOtp", pMap);
		
		if(!("".equals(status) || status == null)){
			sqlSessionTemplate.insert("main.insertIdAllOpenLog", pMap);
		}else{
			status = "NO_AUHEN"; 
		}
		
		return status;
	}
	
	public String getPwFindCheck(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectOne("main.getPwFindCheck", pMap);
	}
	
	// 비밀번호 재발급
	public String setNewPw(Map<String,String>  pMap) {
		_rtnMsg = "정상적으로 발송 되었습니다.";

		try{
			//난수발생
//			String newPw = sqlSessionTemplate.selectOne("main.selectNewPw");
			// 임시비밀번호 6자리로 변경
			String newPw = numberGen(6);
			String strPassword =newPw;
			byte[] hashPassword_2 = strPassword.getBytes();
			byte[] bszDigest = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
			String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
			pMap.put("NEW_PW", toHashpassword);
			pMap.put("NEW_PASSWORD", newPw);
			//NEW_PASSWORD UPDATE
			sqlSessionTemplate.insert("main.setNewPw", pMap);
			
			String type = pMap.get("st_type");
			if("email".equals(type)){
				//이메일 전송
				sqlSessionTemplate.update("main.insertPwdEMAIL", pMap);
			}else if("sms".equals(type)){
				//SMS 전송
				sqlSessionTemplate.update("main.insertPwdSMS", pMap);
			}
			
			//LOG 삽입
			sqlSessionTemplate.update("main.insertPwdLog", pMap);
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("처리중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
	public String numberGen(int len) {
		Random ran = new Random();
		String result = "";
		
		for(int i = 0; i < len; i++) {
			String num = Integer.toString(ran.nextInt(10)); // 0~9 난수
			
			if(!result.contains(num)) { // 중복 없는 경우
				result += num;
			} else { // 중복인 경우
				i-=1;
			}
		}
		return result;
		
	}
	
	public List<Map<String,String>> getNewAgentHomeFindTotal(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNewAgentHomeFindTotal", pMap);
	}
	public List<Map<String,String>> getNewAgentHomeFindTotal_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNewAgentHomeFindTotal_v2", pMap);
	}
	
	
	public List<Map<String,String>> getNewAgentHomeboardSelList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNewAgentHomeboardSelList", pMap);
	}
	public List<Map<String,String>> getNewAgentHomeboardSelList_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNewAgentHomeboardSelList_v2", pMap);
	}
	
	
	public List<Map<String,String>> getNewAgentHomePoMngTotal_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNewAgentHomePoMngTotal_v2", pMap);
	}

	// 협력사 메인 공지사항 분리 (ICOMBOARD_NOTICE 기반)
	public List<Map<String,String>> getCommonNoticeList_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getCommonNoticeList_v2", pMap);
	}
	public List<Map<String,String>> getCompanyNoticeList_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getCompanyNoticeList_v2", pMap);
	}
	public Map<String,Object> getUnreadNoticeCount_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("main.getUnreadNoticeCount_v2", pMap);
	}

	public List<Map<String,String>> getNewExportHomeboardSelList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNewExportHomeboardSelList", pMap);
	}
	/**
	 * 고객사메인 사용 함수
	 */
	//고객도우미
	public List<Map<String,String>> getBuyerVocUserSql(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getBuyerVocUserSql", pMap);
	}
	//BM정보
	public List<Map<String,String>> getBuyerBmUserSql(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getBuyerBmUserSql", pMap);
	}
	//장바구니,상품주문,결재상신,결재대상,신규상품요청,발주대상
	public List<Map<String,String>> getBuyerStatusCountMainSql(Map<String,String>  pMap){
		
		boolean p060000052 = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"),"P06-0000052");
		
		// 고객사 견적 예외사항 체크
		String buyer_exception_type	= "";
		boolean buyer_exception_yn = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10"); // 권한특수로직
		if (buyer_exception_yn) {
			buyer_exception_type = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10", "COL01_DATA");
		}
		
		pMap.put("RQDT_TYPE", buyer_exception_type);
		
		// 일반적인 단가합의 기능을 사용하지 않는 사용자(ex 깨끗한나라 화학물질 담당자)
		String msds_search_flag = "N";
		boolean msds_user_flag = CommonUtil.getCode2CheckReturn("MSDSBUSR", pMap.get("USER_ID"), pMap.get("BUYER"));
		if(msds_user_flag == true){
			msds_search_flag = "Y";
		}
		
		pMap.put("MSDS_USER", msds_search_flag);
		
		if(p060000052 == true){
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountPCOMainSql", pMap);
		}else{
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountMainSql", pMap);
		}
	}
	
	public List<Map<String,String>> getBuyerStatusCountMainSql_v2(Map<String,String>  pMap){
		
		boolean p060000052 = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"),"P06-0000052");
		
		// 고객사 견적 예외사항 체크
		String buyer_exception_type	= "";
		boolean buyer_exception_yn = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10"); // 권한특수로직
		if (buyer_exception_yn) {
			buyer_exception_type = CommonUtil.getSpecialCheckReturn(pMap.get("BUYER"), "P04-4027-10", "COL01_DATA");
		}
		
		pMap.put("RQDT_TYPE", buyer_exception_type);
		
		// 일반적인 단가합의 기능을 사용하지 않는 사용자(ex 깨끗한나라 화학물질 담당자)
		String msds_search_flag = "N";
		boolean msds_user_flag = CommonUtil.getCode2CheckReturn("MSDSBUSR", pMap.get("USER_ID"), pMap.get("BUYER"));
		if(msds_user_flag == true){
			msds_search_flag = "Y";
		}
		
		pMap.put("MSDS_USER", msds_search_flag);
		
		if(p060000052 == true){
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountPCOMainSql", pMap);
		}else{
			return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountMainSql_v2", pMap);
		}
	}
	
	//예산조회
	public List<Map<String,String>> getBuyerBdgtAmt_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getBuyerBdgtAmt_v2", pMap);
	}
	
	//펀치아웃메인
	public List<Map<String,String>> getBuyerStatusCountPCOMainSql(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getBuyerStatusCountPCOMainSql", pMap);
	}
	//결재여부
	public List<Map<String,String>> getCompanyPass(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getCompanyPass", pMap);
	}
	//사용자 결재 유효성 체크
	public List<Map<String,String>> getUserGwPass(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getUserGwPass", pMap);
	}
	//메뉴얼
	public List<Map<String,String>> getManualInfo(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getManualInfo", pMap);
	}
	//MRO 바로가기
	public List<Map<String,String>> getShortCutSso(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getShortCutSso", pMap);
	}
	//VOC 요청
	public String CreateSrReq(Map<String,String>  pMap){
		String VC_NO  = "";
		try {
			VC_NO  = buyerMpSoOrderInfoDao.getOrderNo( "KRKORE0001", "VC");
			pMap.put("VC_NO", VC_NO);
			pMap.put("RECV_FLAG", "DC"); // RECV_FLAG  DC:접수완료, PS:진행중, PA:처리완료, FB:F/B완료
			
			sqlSessionTemplate.update("buyerMain.CreateSrReq", pMap);
		
		
		}catch(Exception e){ 
			throw new RuntimeException("VOC 요청 실패하였습니다.");
		}
	
		return VC_NO;
	}
	//VOC 결과보기
	public List<Map<String,String>> getCustomerCenterList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getCustomerCenterList", pMap);
	}
	public List<Map<String,String>> getCustomerCenterList_v2(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getCustomerCenterList_v2", pMap);
	}
	
	//마이페이지 주문정보
	public List<Map<String,String>> getCustomerOrderInfo_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getCustomerOrderInfo_v2", pMap);
	}
	
	//VOC 결과팝업
	public List<Map<String,String>> getCustomerCenterPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("buyerMain.getCustomerCenterPop", pMap);
	}
	//만족도 평가가
	public String setCustomerRubUpdate(Map<String,String>  pMap){
		String VC_NO  = "";
		try {
 
			String query		    = pMap.get("st_query");
			String check_str[]		=    CommonUtil.StrToArray(query , "^||^");
			
			logger.debug("setCustomerRubUpdate check_str : {} ", check_str.length);
			
			for(int i=0 ; i < check_str.length; i++){	
				String str[]		=     check_str[i].split("@@" , -1);  
				logger.debug("setCustomerRubUpdate check_str[i] : {} ",check_str[i]);
				logger.debug("setCustomerRubUpdate str : {} ", str.length);
				
				Map<String,String>  dataMap = new HashMap<String,String>();
				dataMap.put("RUB_TYPE",str[3]);
				dataMap.put("BUYER",str[0]);
				dataMap.put("VC_NO",str[1]);
				dataMap.put("REQ_USER_ID",str[2]);
				
				logger.debug("setCustomerRubUpdate dataMap : {} ",dataMap);
				sqlSessionTemplate.update("buyerMain.setCustomerRubUpdate", dataMap);
			}
		
		
		}catch(Exception e){ 
			throw new RuntimeException("만족도 평가가 실패하였습니다.");
		}
	
		return VC_NO;
	}
	
	//고객 voc 취소
	public String vocCancel_v2(Map<String,String>  pMap){
		String msg  = "CREATE_OK";
		try {
 
			pMap.put("CANCEL_NOTE", "고객 취소");
			int cnt = sqlSessionTemplate.update("buyerMain.setCustomerVocCancel_v2", pMap);
			if(cnt != 1){
				msg = "문의 취소가 실패하였습니다.";
			}
		
		
		}catch(Exception e){ 
			throw new RuntimeException("문의 취소가 실패하였습니다.");
		}
	
		return msg;
	}

	public List<Map<String,String>> getMasterMainInfo(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("main.getMasterMainInfo", pMap);
	}
	
	public List<Map<String,String>> getNoticeList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNoticeList", pMap);
	}
	
	public List<Map<String,String>> getNoticeDetailList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getNoticeDetail", pMap);
	}
	
	public List<Map<String,String>> getBuyerSmsCertList(Map<String,String>  pMap){
		// 인증번호 생성
		Random rand = new Random();
        String numStr = "";
        
        for(int i=0;i<6;i++) {
            
            //0~9 까지 난수 생성
            String ran = Integer.toString(rand.nextInt(10));
            numStr += ran;
        }
        pMap.put("TWO_FACTOR_SMS", numStr);
        
        // 인증번호 저장
		sqlSessionTemplate.update("main.setBuyerSmsCertUpdate", pMap);
		// SMS 전송
		sqlSessionTemplate.update("main.insertBuyerCertSms", pMap);
		
		return sqlSessionTemplate.selectList("main.getBuyerSmsCertList", pMap);
	}
	
	// 수출시스템 메인화면 차트데이터
	public List<Map<String,String>> getExportHomeChartList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("main.getExportHomeChartList", pMap);
	}
	
	public List<Map<String,String>> getMypage1List(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage1", pMap);
	}
	public List<Map<String,String>> getMypage2List(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage2", pMap);
	}
	
	// 패스워드 확인 후 개인정보로 이동
	public Map<String,String> getSubPwInsert(Map<String,String> pMap) {
		String strPassword = pMap.get("password");
		byte[] hashPassword_2 = strPassword.getBytes();
		byte[] bszDigest = new byte[32];
		SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
		String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
		pMap.put("NEW_PW", toHashpassword);
		
		return sqlSessionTemplate.selectOne("main.getSubPwInsert", pMap);
	}
}

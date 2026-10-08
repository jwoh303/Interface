package com.koreab2b.mro.manager.main.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.manager.main.controller.MainController;
import com.koreab2b.mro.manager.main.dao.MainDao;
import com.koreab2b.mro.util.PopupAuthenticator;

@Service("mainService")
public class MainServiceImpl implements MainService {
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	private MainDao mainDao;

	
	public List<Map<String,String>> getIdFindSome(Map<String,String>  pMap){
		return mainDao.getIdFindSome(pMap);
	};
	
	public void insertLog(Map<String,String>  pMap){
		mainDao.insertLog(pMap);
	};
	
	//인증번호 발송
	@Transactional
	public String insertOtp(Map<String,String>  pMap) {
		return mainDao.insertOtp(pMap);
	}
	
	public String getOtpAuhen(Map<String,String>  pMap){
		return mainDao.getOtpAuhen(pMap);
	};
	
	public String getPwFindCheck(Map<String,String>  pMap){
		return mainDao.getPwFindCheck(pMap);
	};
	
	//비밀번호 재발급
	@Transactional
	public String setNewPw(Map<String,String>  pMap) {
		return mainDao.setNewPw(pMap);
	}
	
	public List<Map<String,String>> getNewAgentHomeFindTotal(Map<String,String>  pMap){
		return mainDao.getNewAgentHomeFindTotal(pMap);
	}
	public List<Map<String,String>> getNewAgentHomeFindTotal_v2(Map<String,String>  pMap){
		return mainDao.getNewAgentHomeFindTotal_v2(pMap);
	}
	
	
	public List<Map<String,String>> getNewAgentHomeboardSelList(Map<String,String>  pMap){
		return mainDao.getNewAgentHomeboardSelList(pMap);
	}
	public List<Map<String,String>> getNewAgentHomeboardSelList_v2(Map<String,String>  pMap){
		return mainDao.getNewAgentHomeboardSelList_v2(pMap);
	}
	
	public List<Map<String,String>> getNewAgentHomePoMngTotal_v2(Map<String,String>  pMap){
		return mainDao.getNewAgentHomePoMngTotal_v2(pMap);
	}

	// 협력사 메인 공지사항 분리 (ICOMBOARD_NOTICE 기반)
	public List<Map<String,String>> getCommonNoticeList_v2(Map<String,String>  pMap){
		return mainDao.getCommonNoticeList_v2(pMap);
	}
	public List<Map<String,String>> getCompanyNoticeList_v2(Map<String,String>  pMap){
		return mainDao.getCompanyNoticeList_v2(pMap);
	}
	public Map<String,Object> getUnreadNoticeCount_v2(Map<String,String>  pMap){
		return mainDao.getUnreadNoticeCount_v2(pMap);
	}

	public List<Map<String,String>> getNewExportHomeboardSelList(Map<String,String>  pMap){
		return mainDao.getNewExportHomeboardSelList(pMap);
	}
	
	public List<Map<String,String>> getNoticeList(Map<String,String>  pMap){
		return mainDao.getNoticeList(pMap);
	}
	
	public List<Map<String,String>> getNoticeDetailList(Map<String,String>  pMap){
		return mainDao.getNoticeDetailList(pMap);
	}
	
	public String sendMail(Map<String,String>  pMap){
		String from_name	=  pMap.get("st_user_name");	// 송신자 이름
		String to_email		= "comanche@koreab2b.com";
		String mailsubj		= from_name+" 로 부터 문의메일이 도착하였습니다.";
		String rtnMsg 			= "문의 메일이 전송 완료 되었습니다.\n\n(담당자 : 심광우대리, 02-3016-8252)";
		try {
			//Create session
			Properties mailProps = new Properties();
			mailProps.put("mail.transport.protocol", "smtp");
			mailProps.put("mail.smtp.host", "10.100.2.7");
			mailProps.put("mail.smtp.port", "25");
			mailProps.put("mail.smtp.auth", "true");
			
			//   Setup mail server
			Authenticator auth = new PopupAuthenticator("master","poi098");
			
			Session mailSession = Session.getInstance(mailProps, auth);
			
			InternetAddress toAddrs = new InternetAddress(to_email);
			InternetAddress fromAddr = new InternetAddress(pMap.get("st_email"), from_name);
			
			//Create and initialize message
			Message message = new MimeMessage(mailSession);
			message.setFrom(fromAddr);
			message.setRecipient(Message.RecipientType.TO, toAddrs);
			message.setSubject(mailsubj);
			message.setSentDate(new Date());
			message.setContent(pMap.get("st_content"), "text/html; charset=utf-8");
	
			Transport.send(message);
		
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("메일 전송중 에러가 발생하였습니다. 운영자에게 문의 하십시요");
		}
		return rtnMsg;
	};
	
	// 수출시스템 메인화면 차트데이터
	public List<Map<String,String>> getExportHomeChartList(Map<String,String>  pMap){
		return mainDao.getExportHomeChartList(pMap);
	}
	
	
	
	
	
	
	
	
	/**
	 * 고객사메인 사용 함수
	 */
	public List<Map<String,String>> getB2bBoardList(Map<String,String>  pMap){
		return mainDao.getB2bBoardList(pMap);
	};
	//고객도우미
	public List<Map<String,String>> getBuyerVocUserSql(Map<String,String>  pMap){
		return mainDao.getBuyerVocUserSql(pMap);
	}
	//BM정보
	public List<Map<String,String>> getBuyerBmUserSql(Map<String,String>  pMap){
		return mainDao.getBuyerBmUserSql(pMap);
	}
	//장바구니,상품주문,결재상신,결재대상,신규상품요청,발주대상
	public List<Map<String,String>> getBuyerStatusCountMainSql(Map<String,String>  pMap){
		return mainDao.getBuyerStatusCountMainSql(pMap);
	}
	public List<Map<String,String>> getBuyerStatusCountMainSql_v2(Map<String,String>  pMap){
		return mainDao.getBuyerStatusCountMainSql_v2(pMap);
	}
	//예산조회
	public List<Map<String,String>> getBuyerBdgtAmt_v2(Map<String,String>  pMap){
		return mainDao.getBuyerBdgtAmt_v2(pMap);
	}
	//펀치아웃메인
	public List<Map<String,String>> getBuyerStatusCountPCOMainSql(Map<String,String>  pMap){
		return mainDao.getBuyerStatusCountPCOMainSql(pMap);
	}
	//결재여부
	public List<Map<String,String>> getCompanyPass(Map<String,String>  pMap){
		return mainDao.getCompanyPass(pMap);
	}
	//사용자의 결재유효성 체크
	public List<Map<String,String>> getUserGwPass(Map<String,String>  pMap){
		return mainDao.getUserGwPass(pMap);
	}
	//메뉴얼
	public List<Map<String,String>> getManualInfo(Map<String,String>  pMap){
		return mainDao.getManualInfo(pMap);
	}
	//MRO 바로가기
	public List<Map<String,String>> getShortCutSso(Map<String,String>  pMap){
		return mainDao.getShortCutSso(pMap);
	}
	//VOC 요청
	public String CreateSrReq(Map<String,String>  pMap){
		return mainDao.CreateSrReq(pMap);
	}
	//VOC 결과보기
	public List<Map<String,String>> getCustomerCenterList(Map<String,String>  pMap){
		return mainDao.getCustomerCenterList(pMap);
	}
	public List<Map<String,String>> getCustomerCenterList_v2(Map<String,Object>  pMap){
		return mainDao.getCustomerCenterList_v2(pMap);
	}
	
	//마이페이지 주문정보
	public List<Map<String,String>> getCustomerOrderInfo_v2(Map<String,String>  pMap){
		return mainDao.getCustomerOrderInfo_v2(pMap);
	}
	
	// 고객사 SMS 추가인증 확인용
	public List<Map<String,String>> getBuyerSmsCertList(Map<String,String>  pMap){
		return mainDao.getBuyerSmsCertList(pMap);
	}
	public String setCustomerRubUpdate(Map<String,String>  pMap) {
		return mainDao.setCustomerRubUpdate(pMap);
	} 
	public String vocCancel_v2(Map<String,String>  pMap) {
		return mainDao.vocCancel_v2(pMap);
	} 
	public List<Map<String,String>> getCustomerCenterPop(Map<String,String>  pMap) {
		return mainDao.getCustomerCenterPop(pMap);
	} 
	public List<Map<String,String>> getMasterMainInfo(Map<String,String>  pMap) {
		return mainDao.getMasterMainInfo(pMap);
	}
	public List<Map<String,String>> getMypage1List(Map<String,String>  pMap){
		return mainDao.getMypage1List(pMap);
	}
	public List<Map<String,String>> getMypage2List(Map<String,String>  pMap){
		return mainDao.getMypage2List(pMap);
	}
	// 패스워드 확인 후 개인정보로 이동
	public Map<String,String> getSubPwInsert(Map<String,String> pMap){
		return mainDao.getSubPwInsert(pMap);
	}
}

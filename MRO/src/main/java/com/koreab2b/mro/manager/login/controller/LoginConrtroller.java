package com.koreab2b.mro.manager.login.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.koreab2b.mro.common.none.service.CommonNoNeBuyerMyMenuPopService;
import com.koreab2b.mro.common.none.service.CommonNoNeMyMenuPopService;
import com.koreab2b.mro.manager.login.domain.Login;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.manager.login.service.LoginService;
import com.koreab2b.mro.manager.login.valid.LoginValidator;
import com.koreab2b.mro.master.mpif.service.MasterMpifExternService;
import com.koreab2b.mro.seller.mdct.service.SellerMdCtMbrCmpyInfoService;
import com.koreab2b.mro.util.AES256Cipher;
import com.koreab2b.mro.util.AWSKMSAlgorithmUtil;
import com.koreab2b.mro.util.CipherDec;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.LotteTripleDESCrypt;
import com.koreab2b.mro.util.SecurHashAlgorithmUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;
import com.koreab2b.mro.webservice.hanwha.neo.branch.common.sso.service.NeoSloWsProxy;
import com.koreab2b.mro.webservice.kumh.EzRSAEncSoapProxy;

@Controller("loginConrtroller")
public class LoginConrtroller {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginConrtroller.class);

	@Autowired
	private MessageSource messageSource;

	@Autowired
	private LoginValidator loginValidator;
	
	@Autowired
	private MasterMpifExternService externService;
	
	@Autowired
	private LoginService loginService;
	
	@Autowired
	private CommonNoNeBuyerMyMenuPopService commonNoNeBuyerMyMenuPopService;
	
	@Autowired
	private CommonNoNeMyMenuPopService commonNoNeMyMenuPopService;
	@Autowired
	private SellerMdCtMbrCmpyInfoService sellerMdCtMbrCmpyInfoService;
	
	@RequestMapping(value = "/login/login.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String login(HttpServletRequest request, @ModelAttribute("login") Login pLogin, BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) throws UnsupportedEncodingException {

		///////////////////////////////////////////////////////////////////////////////////////
		// UI 버전 선택값을 세션에 저장 (기존 세션 값 보존)
		String uiVersionParam = (String) request.getParameter("uiVersion");
		String currentUIVersion = (String) request.getSession().getAttribute("uiVersion");
		String uiVersion;
		
		if (uiVersionParam != null) {
			// 새로운 UI 버전이 파라미터로 전달된 경우 업데이트
			uiVersion = uiVersionParam;
		} else if (currentUIVersion != null) {
			// 기존 세션에 UI 버전이 있으면 유지
			uiVersion = currentUIVersion;
		} else {
			// 둘 다 없으면 기본값
			uiVersion = "original";
		}
		
		request.getSession().setAttribute("uiVersion", uiVersion);
		LOGGER.debug("로그인 시 UI 버전 - 파라미터: " + uiVersionParam + ", 기존세션: " + currentUIVersion + ", 최종설정: " + uiVersion);
		///////////////////////////////////////////////////////////////////////////////////////
		/// ///////////////////////////////////////////////////////////////////////////////////////
		


		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			request.getSession().removeAttribute("sessionInfo");
//			return "main/sub_login_logout";
		}
		
		String sslurl = CommonUtil.getSslURL(request, "http");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		String param_code = "";
		
		//(IKEN SSO) FlashMap에 저장되어 전달된 값을 가져온다.
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);  
		if(flashMap !=null) {  
			String userId = (String)flashMap.get("userId");
			pLogin.setUserId(userId);
			pLogin.setPassword((String)flashMap.get("password"));
			//FlashMap에 전달할 값을 저장한다.  
			FlashMap fm = RequestContextUtils.getOutputFlashMap(request);  
			fm.put("sessionkey", (String)flashMap.get("sessionkey"));
		}else{
			/*hash 암호화*/
			String strPassword = pLogin.getPassword();
			param_code = pLogin.getPassword();
			byte[] hashPassword_2 = strPassword.getBytes();
			byte[] bszDigest = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
			String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
			pLogin.setPassword(toHashpassword);	
		}
		//테스트 위해 주석
//		loginValidator.validate(pLogin, result);

		if (result.hasErrors()) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("잘못된 값이 입력 되었습니다.", null, "잘못된 값이 입력 되었습니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		if (result.hasErrors()) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("잘못된 값이 입력 되었습니다.", null, "잘못된 값이 입력 되었습니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}

		Login _afterLogin = loginService.getLogin(pLogin.getUserId());
		
		if(_afterLogin == null){
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("아이디 또는 패스워드가 일치하지 않습니다.", null, "아이디 또는 패스워드가 일치하지 않습니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";			
		}
		String mainLogin = CommonUtil.nvl((String) request.getParameter("mainLogin"),"");
		String com_code = _afterLogin.getComCode();
		String com_type = _afterLogin.getComType();
		String p01103201 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1032-01","COL01_DATA");
		
		if("S".equals(_afterLogin.getBusinessCond())) { //협력사만 리뉴얼 적용
			//해당 협력사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 협력사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		}else if("B".equals(_afterLogin.getBusinessCond())){ //고객사 리뉴얼 적용
//			//해당 고객사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 고객사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(_afterLogin.getComCode(),"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		}
		
		
		String pass_ok = "N";
		float logInErrorCnt = Float.parseFloat(CommonUtil.nvl(_afterLogin.getLogInErrorCnt(),"0"));
		String st_userType = CommonUtil.nvl(_afterLogin.getUserType(),"");
		
		if (!"".equals(p01103201)){
			String grant[] = p01103201.split("\\^");
			if (grant != null){
				if (grant.length>0){
					for (int i=0; i<grant.length; i++){
						if (pLogin.getUserId().equals(grant[i])){
							pass_ok = "Y";
						}
					}
				}
			}
		}
		
		/**
		 * 로컬 및 개발서버에서는 임직원 체크를 하지 않는다.
		 */
		String RequestURL 	= request.getRequestURL().toString();
		if (RequestURL.indexOf("http://localhost:8080/") > -1) {
			pass_ok = "Y";
		}
		StringBuffer url = (StringBuffer)request.getRequestURL();
		String urlStr = url.toString();
		
		//System.out.println("urlStr urlStr urlStr urlStr : " + urlStr);
		if (urlStr.indexOf("dev")>0){
			pass_ok = "Y";
		}else if(urlStr.indexOf("http://10.20.104.11:8081/")>0){
			pass_ok = "Y";
		}
		if ("KOREAB2B".equals(mainLogin)) {
			pass_ok = "Y";
		}
		


		//메인 화면에서 접속한 임직원 체크로직 
		if("M".equals(com_type) && "KRKORE0001".equals(com_code)){
			if(!"Y".equals(pass_ok)){
				redirectAttributes.addFlashAttribute("message", messageSource.getMessage("임직원은 그룹웨어로만 접속 가능합니다.", null, "임직원은 그룹웨어로만 접속 가능합니다.", request.getLocale()));
				return "redirect:"+sslurl+"/main.do";
			}
		}		

		// 로그인 실패 횟수 5회 초과 시 전체 막음.		
		if(logInErrorCnt > 4){
			if("M".equals(com_type) && "KRKORE0001".equals(com_code)) { // 운영사의 경우 시스템팀에 문의 하도록 메시지 발생
				redirectAttributes.addFlashAttribute("message", messageSource.getMessage("현재 사용자계정이 잠겨있습니다. 시스템관리자에게 문의하시기 바랍니다.", null, "현재 사용자계정이 잠겨있습니다. 시스템관리자에게 문의하시기 바랍니다.", request.getLocale()));	
			}else {
				redirectAttributes.addFlashAttribute("message", messageSource.getMessage("로그인 실패 횟수 5회 초과되어 계정이 잠겼습니다. ID/PW찾기 통해 진행 바랍니다.", null, "로그인 실패 횟수 5회 초과되어 계정이 잠겼습니다. ID/PW찾기 통해 진행 바랍니다.", request.getLocale()));
			}
			return "redirect:"+sslurl+"/main.do";				
		}
		
		if (!pLogin.comfirmUserId(_afterLogin)) {
			//로그인 실패시 실패 카운트 저장
			Map<String, String> dataLogin = new HashMap<String, String>();
			dataLogin.put("LOGIN_USER_ID", pLogin.getUserId());
			loginService.saveLoginErrorCnt(dataLogin);
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("아이디 또는 패스워드가 일치하지 않습니다.", null, "아이디 또는 패스워드가 일치하지 않습니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if (!pLogin.comfirmPassword(_afterLogin)) {
			//로그인 실패시 실패 카운트 저장
			Map<String, String> dataLogin = new HashMap<String, String>();
			dataLogin.put("LOGIN_USER_ID", pLogin.getUserId());
			loginService.saveLoginErrorCnt(dataLogin);
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("아이디 또는 패스워드가 일치하지 않습니다.", null, "아이디 또는 패스워드가 일치하지 않습니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if ("G".equals(_afterLogin.getCmpy_status())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("전자계약 미완료 상태입니다. 전자계약 완료 후 진행 가능하오니 전자계약담당자 이메일을 확인하여 계약 진행 바랍니다. 문의사항 있을 경우 협력사 관리자(02-3016-7251)에게 연락 바랍니다.", null, "전자계약 미완료 상태입니다. 전자계약 완료 후 진행 가능하오니 전자계약담당자 이메일을 확인하여 계약 진행 바랍니다. 문의사항 있을 경우 협력사 관리자(02-3016-7251)에게 연락 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		// 납기관리개선 한시적 운영 (2023.11.22) 시작
		if( "S".equals(_afterLogin.getBusinessCond()) || "B".equals(_afterLogin.getBusinessCond()) ) {
			String info_update_yn = CommonUtil.getInfoUpdateReturn(pLogin.getUserId(),"INFO_UPDATE_YN");
			
			if(info_update_yn.equals("Z")){ // 대상자 구분자는 Z로 합시다(의미 없음)
				Map<String, String> pMap = new HashMap<String, String>();
				pMap.put("st_user_id", pLogin.getUserId());
				
				//List<Map<String, String>> _data = loginService.getLoginInfoList(pMap);
				List<Map<String, String>> _data = loginService.getLoginInfoImsiList(pMap);
				pModel.addAttribute("data", CommonUtil.getListNvl(_data));
				pModel.addAttribute("userId", pLogin.getUserId());
				pModel.addAttribute("password", pLogin.getPassword());
				
				if("S".equals(_afterLogin.getBusinessCond())){
					return "main/sub_login_info_update_imsi_agent";	
				}else {
					return "main/sub_login_info_update_imsi_buyer";
				}
			}else{ 
			}
		}
		// 납기관리개선 한시적 운영 (2023.11.22) 끝
		
		if("S".equals(_afterLogin.getBusinessCond())){
			String info_agree_yn = CommonUtil.getInfoAgreeReturn(pLogin.getUserId(),"INFO_AGREE_YN");
			
			if(info_agree_yn.equals("X")){
				pModel.addAttribute("userId", pLogin.getUserId());
				pModel.addAttribute("password", pLogin.getPassword());
				return "main/sub_login_info";			
			}

			String info_update_yn = CommonUtil.getInfoUpdateReturn(pLogin.getUserId(),"INFO_UPDATE_YN");

			Map<String, String> pMap = new HashMap<String, String>();
			
			if(info_update_yn.equals("X")){
				pMap.put("st_user_id", pLogin.getUserId());
				
				List<Map<String, String>> _data = loginService.getLoginInfoList(pMap);
				for (int i = 0; i < _data.size(); i++) {
					String bank_account_no = _data.get(i).get("BANK_ACCOUNT_NO").trim();
					// SeedCbcAlgorithmUtil 복호화
					if(bank_account_no != null){
						
						/* 기존 SEED_CBC복호화
						
						String pszAccount_no = bank_account_no;
						byte[] decrAccount_no = SeedCbcAlgorithmUtil.getBytes(pszAccount_no);
						//byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_DecryptCbc(decrAccount_no, 0, decrAccount_no.length); 파일읽기 오류 현명환
						byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrAccount_no, 0, decrAccount_no.length);
						String plainTextStr = null;
						if (cbcAlgorithm != null) {
							plainTextStr = new String(cbcAlgorithm);
						}
						
						*/
						
						//신규 KMS 복호화
						String pszAccount_no = bank_account_no;
						String plainTextStr = AWSKMSAlgorithmUtil.decrypt(pszAccount_no);
						
						_data.get(i).put("BANK_ACCOUNT_NO", plainTextStr);
					}
				}
				pModel.addAttribute("data", CommonUtil.getListNvl(_data));
				
				pModel.addAttribute("userId", pLogin.getUserId());
				pModel.addAttribute("password", pLogin.getPassword());
				return "main/sub_login_info_update";
			}
			LOGGER.debug("getDelyArea : {}", _afterLogin.getDelyArea());
			if("X".equals(_afterLogin.getDelyArea())){
				List<Map<String, String>> _dataDelyArea = sellerMdCtMbrCmpyInfoService.getDelyAreaList(pMap);
				pModel.addAttribute("dataDelyArea", CommonUtil.getListNvl(_dataDelyArea)); //납품가능지역
				pModel.addAttribute("userId", pLogin.getUserId());
				pModel.addAttribute("password", pLogin.getPassword());
				return "main/sub_login_delyArea";
			}
			
		}
		if("A".equals(st_userType) && !"KRKORE0001".equals(com_code)){ // KEP 아닌 관리자 계정(일반사용자 해당 안됨)
			pModel.addAttribute("userId", pLogin.getUserId());
			if("X".equals(_afterLogin.getTwoFactorYn())){ // 추가인증 여부 미선택 시
				if("B".equals(_afterLogin.getBusinessCond())){ // 고객사
					if("renewal".equals(uiVersion)){
						return "main/sub_login_addi_cert_info_buyer_v2";
					}else{
						return "main/sub_login_addi_cert_info_buyer";
					}
				}else if("S".equals(_afterLogin.getBusinessCond())){ // 협력사
					return "main/sub_login_addi_cert_info_agent";
				}
			}else if("Y".equals(_afterLogin.getTwoFactorYn())){
				if("B".equals(_afterLogin.getBusinessCond())){ // 고객사
					request.getSession().setAttribute("session_user_id",CommonUtil.nvl(pLogin.getUserId()));
					return "redirect:"+sslurl2+"/main/sub_buyer_sms_cert.do";
				}
			}
		}
		
		request.getSession().setAttribute("session_sso_login_type", "A"); // 로그인 타입(A: SITE, B: SSO, C: 메일)
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		  //SeedCbcAlgorithmUtil 암호화
		String pszUserid = pLogin.getUserId();
		byte[] plainText = pszUserid.getBytes();
		byte[] bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
		
		// 2023-06-19 로그인 브라우저 기록으로 로그인 접속 막기
		Cookie cookie = null;

		// 현재 도메인에서 사용중인 쿠키 정보 배열 가져오기
		Cookie cookies [] = request.getCookies();

		if(cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				cookie = cookies[i];
		        //System.out.println("쿠키 이름 : " + cookie.getName());
		        //System.out.println("쿠키 값 : " + cookie.getValue());
		        if(cookie.getName().equals("JSESSIONID")) {
		        	CommonUtil.setJID(cookie.getValue());
		        }  
		    }
		}
		
		//20250531 비밀번호 변경화면에서 새로고침 시 로그인 되는 것 방지
		String user_id = _afterLogin.getUserId();
		String biz_type = _afterLogin.getBusinessCond();
		String pwd_status = _afterLogin.getPwd_status();
		
		//패스워드 관련 페이지 분기처리(임시패스워드, 3개월 초과)
		//PASSWORD_TYPE='S'인 사용자는 초기패스워드 발급자이며, 패스워드를 변경해야 로그인 가능.
		String _passwordType = CommonUtil.nvl(_afterLogin.getPassword_type(),"");
		if(_passwordType.equals("S")){
			redirectAttributes.addAttribute("pageGbn", pwd_status);
			redirectAttributes.addAttribute("userId", user_id);
			redirectAttributes.addAttribute("comCode", com_code);
			return "redirect:"+sslurl2+"/main/sub_buyer_pw_change.do";
		}
		//3개월 초과시 운영사 패스워드 강제 변경.
		if("M".equals(biz_type)){
			if( "OLD".equals(pwd_status)){
				redirectAttributes.addAttribute("pageGbn", pwd_status);
				redirectAttributes.addAttribute("userId", user_id);
				redirectAttributes.addAttribute("comCode", com_code);
				return "redirect:"+sslurl2+"/main/sub_login_pw_change.do";
			}
		}
		
		String nexttime_yn = CommonUtil.nvl(request.getParameter("nextTimeYN"),"");
		
		if(!nexttime_yn.equals("Y")) { // 다음에 변경하기로 다시 로그인 과정 진행 시 다시 비밀번호 변경화면으로 넘어가는 것 방지
			if (user_id.length()>4){
				if(("IMSI".equals(pwd_status) || "OLD".equals(pwd_status)) && !"OKEP".equals(user_id.substring(0, 4))){
					redirectAttributes.addAttribute("pageGbn", pwd_status);
					redirectAttributes.addAttribute("userId", user_id);
					redirectAttributes.addAttribute("comCode", com_code);
					redirectAttributes.addAttribute("tempPw", param_code);
					return "redirect:"+sslurl2+"/main/sub_pw_change.do";
				}
			}else{
				if(("IMSI".equals(pwd_status) || "OLD".equals(pwd_status)) && !"OKEP".startsWith(user_id)){
					redirectAttributes.addAttribute("pageGbn", pwd_status);
					redirectAttributes.addAttribute("userId", user_id);
					redirectAttributes.addAttribute("comCode", com_code);
					redirectAttributes.addAttribute("tempPw", param_code);
					return "redirect:"+sslurl2+"/main/sub_pw_change.do";
				}
			}
		}
				
		return "redirect:"+sslurl+"/securityCheck.do?userId=" + bszUserid;
		
	}

	@RequestMapping(value = "/login/logincertificate.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String logincertificate(HttpServletRequest request, @ModelAttribute("login") Login pLogin, BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes, @RequestParam Map<String, String> pMap) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			request.getSession().removeAttribute("sessionInfo");
		}
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		//개인정보 동의
		String infoAgreeYn = CommonUtil.nvl((String) request.getParameter("infoAgreeYn"),"");
		if(!infoAgreeYn.equals("")){
			Map<String, String> dataLogin = new HashMap<String, String>();
			dataLogin.put("userId", pLogin.getUserId());
			dataLogin.put("info_agree_yn", infoAgreeYn);
			loginService.saveInfoAgree(dataLogin);			
		}
		// 회사_개인정보 갱신
		String infoUpdateYn = CommonUtil.nvl((String) request.getParameter("infoUpdateYn"),"");
		if(!infoUpdateYn.equals("")){
			loginService.saveInfoUpdate(pMap);			
		}
		// 납기관리개선 정보 수집(일시적 운영)
		String infoImsiUpdateYn = CommonUtil.nvl((String) request.getParameter("infoImsiUpdateYn"),"");
		if(!infoImsiUpdateYn.equals("")){
			loginService.saveInfoImsiUpdate(pMap);
		}
		//로그인 추가인증 설정
		String loginAddiCertYn = CommonUtil.nvl((String) request.getParameter("loginAddiCertYn"),"");
		if(!loginAddiCertYn.equals("")){
			Map<String, String> dataLogin = new HashMap<String, String>();
			dataLogin.put("userId", pLogin.getUserId());
			dataLogin.put("info_login_cert_yn", loginAddiCertYn);
			loginService.saveLoginAddiCertAgree(dataLogin);			
		}
		//협력사 납품가능지역 설정
		String delyArea = CommonUtil.nvl((String) request.getParameter("delyArea"),"");
		if(!delyArea.equals("")){
			Map<String, String> dataLogin = new HashMap<String, String>();
			dataLogin.put("userId", pLogin.getUserId());
			dataLogin.put("dely_area", delyArea);
			loginService.saveDelyArea(dataLogin);			
		}
		//SeedCbcAlgorithmUtil 암호화
		String pszUserid = pLogin.getUserId();
		byte[] plainText = pszUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);		 
		return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
	}

	@RequestMapping(value = "/login/login2.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String login2(HttpServletRequest request, @ModelAttribute("login") Login pLogin, BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			request.getSession().removeAttribute("sessionInfo");
//			return "redirect:http://211.233.33.42:7004/";
		}
		
		String sslurl = CommonUtil.getSslURL(request, "http");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		
		//(IKEN SSO) FlashMap에 저장되어 전달된 값을 가져온다.
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);  
		if(flashMap !=null) {  
			String userId = (String)flashMap.get("userId");
			pLogin.setUserId(userId);
			pLogin.setPassword((String)flashMap.get("password"));
		}else{
			/*hash 암호화*/
			String strPassword = pLogin.getPassword();
			byte[] hashPassword_2 = strPassword.getBytes();
			byte[] bszDigest = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
			String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);
			pLogin.setPassword(toHashpassword);	
		}
		
		loginValidator.validate(pLogin, result);

		if (result.hasErrors()) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("잘못된 값이 입력 되었습니다.", null, "잘못된 값이 입력 되었습니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}

//		LOGGER.debug("로그인 사용자 아이디 : {}", pLogin.getUserId());
//		LOGGER.debug("로그인 사용자 패스워드 : {}", pLogin.getPassword());

		Login _afterLogin = loginService.getLogin(pLogin.getUserId());

		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if (!pLogin.comfirmPassword(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("패스워드가 일치 하지 않습니다", null, "패스워드가 일치 하지 않습니다", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		  //SeedCbcAlgorithmUtil 암호화
		String pszUserid = pLogin.getUserId();
		byte[] plainText = pszUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);		 
		return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
	}

	
	@RequestMapping(value = "/login/process.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String process(HttpServletRequest request, ModelMap pModel) {
		LOGGER.debug("로그인 완료 후 처리!");
		String sslurl = CommonUtil.getSslURL(request, "http");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		String session_st_gw_no = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gw_no"),""); // 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴
		LOGGER.debug(" getMainList 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴 session_st_gw_no {} ",session_st_gw_no);

		Authentication _auth = SecurityContextHolder.getContext().getAuthentication();

		LOGGER.debug("시큐리티 사용자 아이디 : {}", _auth.getName());
		
		WebAuthenticationDetails details = (WebAuthenticationDetails) _auth.getDetails();
		
		//System.out.println("details session Id : " + details.getSessionId());
		
		HttpSession _session = request.getSession(false);
		
		//System.out.println("세션JID : " + CommonUtil.getJID());	
		//System.out.println("세션ID : " + request.getSession().getId());	
		//System.out.println("CommonUtil.getSESSION_PASS_FLAG() : " + CommonUtil.getSESSION_PASS_FLAG());

		if(!("Y".equals(CommonUtil.getSESSION_PASS_FLAG()))) {
			CommonUtil.setSESSION_PASS_FLAG("N");
			if(CommonUtil.getJID().equals("") || !(details.getSessionId()).equals(CommonUtil.getJID()) ) {
				pModel.addAttribute("start_msg", "Y");
				return "redirect:"+sslurl2+"/main.do";
			}	
		}
		
		SessionInfo _sessionInfo = loginService.getSessionInfo(_auth.getName());
		//(IKEN SSO) FlashMap에 저장되어 전달된 값을 가져온다.
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);  
		if(flashMap !=null) {  
			_sessionInfo.setIkenSessionkey((String)flashMap.get("sessionkey"));
		}  

		if("S".equals(_sessionInfo.getBusinessCond())) { //협력사만 리뉴얼 적용
			//해당 협력사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 협력사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		}else if("B".equals(_sessionInfo.getBusinessCond())){ //고객사 리뉴얼 적용
//			//해당 고객사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 고객사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		} else {
			if(_sessionInfo.getOwnOfficeYn().equals("Y")) { //사무용품 계정은 리뉴얼
				request.getSession().setAttribute("uiVersion", "renewal");
			}else {
				request.getSession().setAttribute("uiVersion", "original");
			}
		}
		
		// 고객사 : 나의 메뉴 지정 정보 조회 후 세션 정보에 저장
		if("B".equals(_sessionInfo.getBusinessCond()) || "S".equals(_sessionInfo.getBusinessCond())){
			String uiVersionTemp = (String) request.getSession().getAttribute("uiVersion");
			if(uiVersionTemp.equals("renewal")) {
				Map<String, Object> pMap2 = new HashMap<String, Object>();
				pMap2.put("st_user_id", _sessionInfo.getUserId());
				pMap2.put("st_com_type", _sessionInfo.getBusinessCond());
				_sessionInfo.setMyMenuList(commonNoNeMyMenuPopService.getCommonNoNeMyMenuList(pMap2));
			}else {
				Map<String, String> pMap = new HashMap<String, String>();
				pMap.put("st_user_id", _sessionInfo.getUserId());
				_sessionInfo.setMyMenuList(commonNoNeBuyerMyMenuPopService.getMyMenuList(pMap));
			}
			
			
		}
		_session.setAttribute("sessionInfo", _sessionInfo);
				

		List<String> _authList = new ArrayList<String>();
		for (GrantedAuthority _tmpAuth : _auth.getAuthorities()) {
			_authList.add(_tmpAuth.getAuthority());
		}
		_session.setAttribute("authInfo", _authList);
		
		_session.setAttribute("roleInfo", loginService.getRoleIdsByUserId(_sessionInfo.getUserId()));
		
		/**
		 * 로컬 및 개발서버에서는 로그인 이력을 기록 하지 않는다.
		 */
		String RequestURL = request.getRequestURL().toString();
		if (RequestURL.indexOf("http://localhost:8080/") > -1) {
			//성공로그인 이력
			Map<String, String> histLogin = new HashMap<String, String>();
			String session_sso_login_type = CommonUtil.nvl((String)request.getSession().getAttribute("session_sso_login_type"),"L"); // 사이트 로그인 A 외 SSO로 판단 B 설정 (로컬접속 : L로 남김)

			histLogin.put("USER_ID", _sessionInfo.getUserId());
			histLogin.put("IP", CommonUtil.nvl(request.getHeader("x-forwarded-for")));
			histLogin.put("IP2", CommonUtil.nvl(request.getRemoteAddr()));
			histLogin.put("LOGIN_TYPE", session_sso_login_type);
			histLogin.put("TWO_FACTOR_YN", _sessionInfo.getTwoFactorYn());
			loginService.saveLoginHist(histLogin);
		}else {
			//로그인시간 기록.
			Map<String, String> dataLogin = new HashMap<String, String>();
			dataLogin.put("LAST_LOGIN_ID", _sessionInfo.getUserId());
			loginService.saveLogintime(dataLogin);
			
			//성공로그인 이력
			Map<String, String> histLogin = new HashMap<String, String>();
			String session_sso_login_type = CommonUtil.nvl((String)request.getSession().getAttribute("session_sso_login_type"),"B"); // 사이트 로그인 A 외 SSO로 판단 B 설정

			histLogin.put("USER_ID", _sessionInfo.getUserId());
			histLogin.put("IP", CommonUtil.nvl(request.getHeader("x-forwarded-for")));
			histLogin.put("IP2", CommonUtil.nvl(request.getRemoteAddr()));
			histLogin.put("LOGIN_TYPE", session_sso_login_type);
			histLogin.put("TWO_FACTOR_YN", _sessionInfo.getTwoFactorYn());
			loginService.saveLoginHist(histLogin);
		}
		
		// 그리드옵션
		_session.setAttribute("notnullColor", "#D1E7F3"); // 필수
		_session.setAttribute("whiteColor", "#FFFFFF"); // 
		_session.setAttribute("redColor", "#F55F5F"); //
		_session.setAttribute("blueColor", "#383FF5"); //
		_session.setAttribute("grayColor", "#FAFAFA"); // 
		_session.setAttribute("optColor", "#FFFFDC"); // 선택입력
		_session.setAttribute("amtFormat", "#,###.##"); // 합계
		_session.setAttribute("priceFormat", "#,###.####"); // 가격
		_session.setAttribute("qtyFormat", "#,###.###"); // 수량
		_session.setAttribute("rateFormat", "#,###.##%");// 비율
		_session.setAttribute("priceFormat2", "#,##0.####"); // 가격
		
		String uiVersion = CommonUtil.nvl((String) request.getSession().getAttribute("uiVersion"));
		if(uiVersion.equals("renewal")){ //리뉴얼에선 첫 화면 특수로직 안씀
			
		}else{
			//특수로직 (P07-0000020) 사용자별 redirect url
			//패스워드 변경페이지에서 다음에변경하기 클릭시 redirect하기 위해 미리 수행.
			String _redirectUrl = CommonUtil.nvl(loginService.getRedirectUrlByUserId(_sessionInfo.getUserId(), _sessionInfo.getComCode()));
			if ("".equals(session_st_gw_no)){ // 결재바로보기에서 온게 아니고 정상로그인 했을경우에만
				//redirectUrl이 null이 아니면 해당하는 url로 redirect시킴.
				if(_redirectUrl != null && !"".equals(_redirectUrl)){
					return "redirect:"+sslurl +_redirectUrl;
				}
			}
		}
		
		
		String session_st_gj_type = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gj_type"),"");
		
		//문자전송 페이지.
		if(session_st_gw_no.equals("SMS_SSO_LOGIN")){
			return "redirect:"+sslurl+"/main/sms_sendList.do";
		
		// 결재 메일 결재 결과 페이지
		}else if(session_st_gj_type.equals("APRV") || session_st_gj_type.equals("RJCT")){
			
			pModel.addAttribute("gw_no", session_st_gw_no);
			
			if("S".equals(CommonUtil.nvl(_sessionInfo.getPasswordType(),""))){
				pModel.addAttribute("old_password", CommonUtil.nvl((String)request.getSession().getAttribute("session_st_password"),""));
				pModel.addAttribute("new_password", CommonUtil.nvl((String)request.getSession().getAttribute("session_st_new_password"),""));	
			}
			
			// PASS_KN, PASS_ADD 결재 과정 중 필수 필요
			if(session_st_gj_type.equals("APRV")){
				pModel.addAttribute("PASS_KN", "1");
				pModel.addAttribute("PASS_ADD", "결재메일 승인");
			}else{
				pModel.addAttribute("PASS_KN", "3");
				pModel.addAttribute("PASS_ADD", "결재메일 반려");
			}
						
			return "redirect:"+sslurl+"/main/sub_mail_aprv.do";
		}else{
			//LOGGER.debug("로그인 사용자 _main_url {}", _main_url);
			return "redirect:"+sslurl+"/main.do";			
		}
	}

	@RequestMapping(value = "/login/logout.do", method = RequestMethod.POST)
	public String logout(HttpServletRequest request, ModelMap pModel) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String redirectUrl = "";
		if (_sessionInfo != null) {
			if(_sessionInfo.getLang().equals("EN")){
				redirectUrl = "main/en/main_en";
			}else{
				redirectUrl = "redirect:/main.do";
			}
			request.getSession().removeAttribute("sessionInfo");
		}
		request.getSession().invalidate();

		// 로그아웃 시 세션 관련 정보 비우기
		CommonUtil.setJID("");
		CommonUtil.setSESSION_PASS_FLAG("N");
		
		return redirectUrl;
	}

	@RequestMapping(value = "/login/logout2.do", method = RequestMethod.POST)
	public String logout2(HttpServletRequest request, ModelMap pModel) {

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		if (_sessionInfo != null ) {
			LOGGER.debug("로그 아웃 사용자 아이디 : {}", _sessionInfo.getUserId());
			request.getSession().removeAttribute("sessionInfo");
		}
		
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 로그아웃이므로 빈값으로 넣는다		
		//request.getSession().invalidate();
		CommonUtil.setSESSION_PASS_FLAG("N");
		
		return "redirect:http://www.koreab2b.com/";
	}

	/**
	 * 고객사 SSO 로그인 처리.
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/office_login.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String office_login(HttpServletRequest request, @ModelAttribute("login") Login pLogin,  BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String sslurl = CommonUtil.getSslURL(request, "http");
		if (_sessionInfo != null) {
			LOGGER.debug("로그 아웃 사용자 아이디 : {}", _sessionInfo.getUserId());
			LOGGER.debug("로그 아웃 사용자 아이디 : {}", _sessionInfo.getUserId());
			request.getSession().removeAttribute("sessionInfo");
		}
		request.getSession().invalidate();
		

	  //SeedCbcAlgorithmUtil 복호화
		String pszUserid = pLogin.getUserId();
	    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid);    
	    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);

	    String  plainTextStr =  new String(cbcAlgorithm);
	    pLogin.setUserId(plainTextStr);
	    
		//(IKEN SSO) FlashMap에 저장되어 전달된 값을 가져온다.
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);  
		if(flashMap !=null) {  
			pLogin.setUserId((String)flashMap.get("userId"));
		}  
		Login _afterLogin = loginService.getLogin(pLogin.getUserId());
		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}

		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if("S".equals(_afterLogin.getBusinessCond())){ //협력사만 리뉴얼 적용
			//해당 협력사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 협력사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(_afterLogin.getComCode(),"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		}else if("B".equals(_afterLogin.getBusinessCond())){ //고객사 리뉴얼 적용
//			//해당 고객사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 고객사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(_afterLogin.getComCode(),"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		}

		if("A".equals(_afterLogin.getUserType()) && !"KRKORE0001".equals(_afterLogin.getComCode())){ // KEP 아닌 관리자 계정(일반사용자 해당 안됨)
			pModel.addAttribute("userId", pLogin.getUserId());
			
			if("X".equals(_afterLogin.getTwoFactorYn())){ // 추가인증 여부 미선택 시
				if("S".equals(_afterLogin.getBusinessCond())){ // 협력사
					return "main/sub_login_addi_cert_info_agent";
				}
			}
		}
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		  //SeedCbcAlgorithmUtil 암호화
		String pszEnUserid = pLogin.getUserId();
		byte[] plainText = pszEnUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
		return "redirect:/securityCheck.do?userId=" + bszUserid;
	}

	
	@RequestMapping(value = "/login/cowaySsoLogin.do", method = RequestMethod.POST)
	public String cowaySsoLogin(HttpServletRequest request, @ModelAttribute("login") Login pLogin,  BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String sslurl = CommonUtil.getSslURL(request, "http");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		if (_sessionInfo != null) {
			LOGGER.debug("로그 아웃 사용자 아이디 : {}", _sessionInfo.getUserId());
			request.getSession().removeAttribute("sessionInfo");
		}
		request.getSession().invalidate();
		
		//(IKEN SSO) FlashMap에 저장되어 전달된 값을 가져온다.
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);  
		if(flashMap !=null) {  
			pLogin.setUserId((String)flashMap.get("userId"));
			pLogin.setPassword((String)flashMap.get("password"));
		}  
		if(pLogin.getPassword() != null){
			/*hash 암호화*/
			String strPassword = pLogin.getPassword();
			byte[] hashPassword_2 = strPassword.getBytes();
			byte[] bszDigest = new byte[32];
			SecurHashAlgorithmUtil.SHA256_Encrpyt(hashPassword_2,hashPassword_2.length,bszDigest);
			String toHashpassword = SecurHashAlgorithmUtil.getString(bszDigest);	
			pLogin.setPassword(toHashpassword);	
		}
		loginValidator.validate(pLogin, result);

		if (result.hasErrors()) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("잘못된 값이 입력 되었습니다.", null, "잘못된 값이 입력 되었습니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}

//		LOGGER.debug("로그인 사용자 아이디 : {}", pLogin.getUserId());
//		LOGGER.debug("로그인 사용자 패스워드 : {}", pLogin.getPassword());

		Login _afterLogin = loginService.getLogin(pLogin.getUserId());

		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if (!pLogin.comfirmPassword(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("패스워드가 일치 하지 않습니다", null, "패스워드가 일치 하지 않습니다", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		  //SeedCbcAlgorithmUtil 암호화
		String pszEnUserid = pLogin.getUserId();
		byte[] plainText = pszEnUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);		 
		return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
	}
	
	@RequestMapping(value = "/login/getIRSNo.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getIRSNo(@RequestParam Map<String, String> pMap) {
		// 사업자 번호
		String strIrsNo	= CommonUtil.nvl(loginService.getIRSNo(pMap));
		//원문 data
		String strOriginData	= CommonUtil.nvl(loginService.getHashData());
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String,String> rtnMap = new HashMap<String,String>();
		rtnMap.put("IRS_NO", strIrsNo);
		rtnMap.put("ORIGIN_DATA", strOriginData);
		_response.put("data", rtnMap);
		
		return _response;
	}
	
	/**
	 * 인증서 유효성 검사
	 * 
	 * @param signData, getR, ssn
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/certValidate.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCertValidate(String signedData, String getR, String ssn, String userId) throws Exception {
		Map<String, String> result = loginService.getCertValidate(signedData, getR, ssn);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//유효한 인증서면 password  return
		if("0000".equals(result.get("errorCode").toString())){
			System.out.print("certValidate===============0");
			String pwd = CommonUtil.nvl(loginService.getPWD(userId),"");
			System.out.print("certValidate===============1");
			  //SeedCbcAlgorithmUtil 암호화
			String pszUserid = userId;
			byte[] plainText = pszUserid.getBytes();
			System.out.print("certValidate===============2");
			byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
			System.out.print("certValidate===============3");
			String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
			System.out.print("certValidate===============4");
			result.put("pwd", pwd);
			result.put("userId", bszUserid);
			System.out.print("certValidate===============5");
		}
		_response.put("data", result);
		
		return _response;
	}
	
	/**
	 * 현재 패스워드 일치여부 검사
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/getOldPasswordCheck.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getOldPasswordCheck(@RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("flag", CommonUtil.nvl(loginService.getOldPasswordCheck(pMap)));
		
		return _response;
	}
	
	@RequestMapping(value = "/login/getOldCertSmsCheck.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getOldCertSmsCheck(@RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("flag", CommonUtil.nvl(loginService.getOldCertSmsCheck(pMap)));
		
		return _response;
	}
	
	@RequestMapping(value = "/login/setUserPwdUpdate.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setUserPwdUpdate(@RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = loginService.setUserPwdUpdate(pMap);
		_response.put("msg", flag);
		
		return _response;
	}
	/**
	 * IKEN SSO 로그인 처리.
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/iken_sso_login.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String ssoLogin(HttpServletRequest request, ModelMap pModel, RedirectAttributes redirectAttributes) {
		String emp_no = CommonUtil.nvl((String) request.getParameter("st_emp_no"),"");
	  //SeedCbcAlgorithmUtil 복호화
		String pszUserid = emp_no;
	    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid);    
	    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);

	    String  plainTextStr =  new String(cbcAlgorithm);
	    emp_no = plainTextStr;
		String sessionkey = CommonUtil.nvl((String) request.getParameter("sessionkey"),"");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		String com_code = "KRKORE0001";
		String kita_id  = loginService.setIkenSsoId(com_code,emp_no);
		//hash 암호화
		String kita_pw  = loginService.setIkenSsoPw(com_code,kita_id);
		loginService.setSessionkey(sessionkey,kita_id);	
		
		//FlashMap에 전달할 값을 저장한다.  
		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);  
		fm.put("userId", kita_id); 
		fm.put("password", kita_pw);
		fm.put("sessionkey", sessionkey);
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다

		return "redirect:"+sslurl2+"/login/login.do";
	}
	
	/**
	 * 그룹웨어 SSO 로그인 처리.
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/gw_sso_login.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String gw_sso_login(HttpServletRequest request, ModelMap pModel, RedirectAttributes redirectAttributes) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			request.getSession().removeAttribute("sessionInfo");
			
			request.getSession().invalidate();

			// 로그아웃 시 세션 관련 정보 비우기
			CommonUtil.setJID("");
			CommonUtil.setSESSION_PASS_FLAG("N");
		}

		String emp_no = CommonUtil.nvl((String) request.getParameter("st_emp_no"),"");
	  //SeedCbcAlgorithmUtil 복호화
		String pszUserid = emp_no;
	    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid);    
	    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);
	    String sslurl2 = CommonUtil.getSslURL(request, "https");
	    String  plainTextStr =  new String(cbcAlgorithm);
	    emp_no = plainTextStr;
		String sessionkey = CommonUtil.nvl((String) request.getParameter("sessionkey"),"");
		String com_code = "KRKORE0001";
		String kita_id  = loginService.setIkenSsoId(com_code,emp_no);
		String kita_nm  = loginService.setIkenSsoNm(com_code,emp_no);
		loginService.setSessionkey(sessionkey,kita_id);	
		request.getSession().setAttribute("session_st_emp_no",kita_id);
		request.getSession().setAttribute("session_st_emp_nm",kita_nm); 
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		//return "main/sub_pw_insert";
		return "redirect:"+sslurl2+"/main/sub_pw_insert.do";
	}
	
	@RequestMapping(value = "/login/punchout_login.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String punchout_login(HttpServletRequest request, ModelMap pModel, RedirectAttributes redirectAttributes) {

		String returnURL = CommonUtil.nvl((String) request.getParameter("returnURL"),"");
		String appUserName = CommonUtil.nvl((String) request.getParameter("appUserName"),"");
		String userName = CommonUtil.nvl((String) request.getParameter("userName"),"");
		String userEmail = CommonUtil.nvl((String) request.getParameter("userEmail"),"");
		String password = CommonUtil.nvl((String) request.getParameter("password"),"");
		String gbn = CommonUtil.nvl((String) request.getParameter("gbn"),"");
		String redirectUrl	= CommonUtil.nvl((String) request.getParameter("returnURL"),"");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		
		
		String referer	= request.getHeader("REFERER");
		
	

		//ID기준으로 고객사코드 체크
		String getComCode	= CommonUtil.nvl(loginService.getComCode(appUserName));
		
		//코드가 없을경우 고객사기준으로 Default 셋팅
		if(getComCode.equals("")){
			if(gbn.equals("DO")){//두산중공업
				getComCode = "KRDOOD0001";
			}else if(gbn.equals("DE")){//두산엔진
				getComCode = "KRHSDE0003";
			}
		}
		//펀치아웃 ID유무체크
		String getLusrYn	   = CommonUtil.nvl(loginService.getLusrYn(appUserName,getComCode));
//		List<Map<String, String>> domainList	= loginService.getSsoDomainList(getComCode);
		
//		LOGGER.debug("domainList : {}", domainList);
		LOGGER.debug("referer : " + referer);
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("returnURL",returnURL);
		pMap.put("appUserName",appUserName);
		pMap.put("userName",userName);
		pMap.put("userEmail",userEmail);
		pMap.put("password",password);
		pMap.put("comcode",getComCode);
		pMap.put("redirectUrl",redirectUrl);
		
		
		//사용자정보 셋팅
		if(getLusrYn.equals("Y")){
			 loginService.setPunchoutUserUpdate(pMap);
		}else{
			 loginService.setPunchoutUserInsert(pMap);
		}
		//권한삭제
		loginService.setPunchoutRollDel(pMap);
		//메뉴관리자권한 체크
		String getRollYn	   = CommonUtil.nvl(loginService.getRollYn(pMap));
		
		//메뉴권한 Insert
		if(getRollYn.equals("Y")){
			//권한INSERT
			loginService.setPunchoutAdminRollInsert(pMap);
		}else{
			loginService.setPunchoutRollInsert(pMap);
		}
		boolean ssoChk	= false;
		/*		
		for(String tmp : domainList) {
			
			 //Referer 체크로직
			 // 1. domain이 null이면 체크하지 않고 로그인 진행
			 // 2. referer가 not null이고  domain이 referer에 포함되어 있으면 로그인 진행
			if ( tmp == null || referer != null && referer.indexOf(tmp) > -1){
				ssoChk	= true;
				break;
			}
			
		}
		 */
		
		//if (page_flag != null && page_flag.equals("TEST") && referer.equals("localhost")) {
			ssoChk	= true;
		//}
		
		//FlashMap에 전달할 값을 저장한다.  
		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);  
		fm.put("userId", appUserName);
		fm.put("password", password);
		fm.put("sessionkey", redirectUrl);
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		
		if (ssoChk)
			redirectUrl	= "redirect:"+sslurl2+"/login/login.do";
		else 
			redirectUrl	= "sso_error";
		
		return redirectUrl;
	}
	/**
	 * 고객사 SSO 로그인 처리.
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/sso_login.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String testssoLogin(HttpServletRequest request, @ModelAttribute("login") Login pLogin, BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {
		CommonUtil.setSESSION_PASS_FLAG("Y");		
		String com_code		= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
		String st_buyer		= com_code;		
		String st_buyer2	= "";
		String st_buyer_kcte = "";
		String emp_no		= CommonUtil.nvl((String) request.getParameter("st_user_id"),"");
		String page_flag	= CommonUtil.nvl((String) request.getParameter("st_page_flag"),"");
		String sslurl		= CommonUtil.getSslURL(request, "http");
		String sslurl2		= CommonUtil.getSslURL(request, "https");
		String referer		= request.getHeader("REFERER");
		String charSet 		= "utf-8";
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			request.getSession().removeAttribute("sessionInfo");			
		}
		
		// 롯데그룹 키값이 확인안되어 앞 2글자 비교함.
		if ( !com_code.substring(0, 2).equals("KR")) 
		{
			try 
			{
				st_buyer_kcte = AES256Cipher.Base64Decrypt(com_code);
				LotteTripleDESCrypt crypt2 = new LotteTripleDESCrypt("ssopublickey", charSet);
				st_buyer2 = crypt2.hexDecrypt(com_code, charSet);
				if(!"KRLOTTG004".equals(st_buyer2))
				{
					com_code = "KRLOTTG001";
				} else {
					com_code = st_buyer2;
				}
				if("KRKCTE0003".equals(st_buyer_kcte)) {
					com_code = st_buyer_kcte;
				}
			}
			catch (Exception e) 
			{
				com_code = "KRLOTTG001";
				LOGGER.error(CommonUtil.printStackTraceToString(e));
			}
		}
		
		String emp_no2	= null;
		
		List<Map<String, String>> domainList	= loginService.getSsoDomainList(com_code);
		
		LOGGER.debug("domainList : {}", domainList);
		LOGGER.debug("referer : " + referer);
		
		boolean ssoChk	= false;
		
		for(Map<String, String> tMap : domainList) {
			/**
			 * Referer 체크로직
			 * 1. domain이 null이면 체크하지 않고 로그인 진행
			 * 2. referer가 not null이고  domain이 referer에 포함되어 있으면 로그인 진행
			 */
			String tmp	= tMap.get("DOMAIN");
			
			if("ORACLE_ENC".equals(tmp) ) {
				emp_no2	= CommonUtil.nvl((String) URLEncoder.encode(request.getParameter("st_user_id")),"");
				emp_no	= CommonUtil.nvl(loginService.getEncryptedEmpNo(emp_no2), " ");

				ssoChk	= true;
				break;
			}
			else if("BASE64_ENC".equals(tmp)) {
				
				byte[] decode_id_arr	= Base64.decodeBase64(emp_no);
				emp_no	= new String(decode_id_arr);
				
				ssoChk	= true;
				break;

			}
			else if ("HANWHA_SLO".equals(tmp)) {

				String WS_TARGET	= "KEP";
				String END_POINT	= tMap.get("ATTR1");
				String SEED			= tMap.get("ATTR2");
				
				emp_no2	= emp_no;
				
				try {
					com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.common.sso.service.NeoSloWsProxy cleverseProxy =new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.common.sso.service.NeoSloWsProxy();
					cleverseProxy.setEndpoint(END_POINT);
					String encUserInfo	= cleverseProxy.login(emp_no2, WS_TARGET);
					emp_no	= hanwha.neo.slo.SLODecrypt4AES.decrypt(encUserInfo, SEED);
					ssoChk	= true;
					
				} catch (Exception e) {

					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", emp_no2);
					pMap.put("ATTR_03", "");
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}
			else if ("HANWHA_SLO2".equals(tmp)) {
				// 한화 테크윈 민수망 전황에 따른 추가.
				String WS_TARGET	= "KEP";
				String END_POINT	= tMap.get("ATTR1");
				String SEED			= tMap.get("ATTR2");
				
				emp_no2	= emp_no;
				
				try {
					NeoSloWsProxy proxy	= new NeoSloWsProxy();
					proxy.setEndpoint(END_POINT);
					
					String encUserInfo	= proxy.login(emp_no2, WS_TARGET);
					emp_no	= hanwha.neo.slo.SLODecrypt4AES.decrypt(encUserInfo, SEED);
					ssoChk	= true;
					com_code = "KRHANHG001";
				} catch (Exception e) {

					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", emp_no2);
					pMap.put("ATTR_03", "");
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}else if ("hanwhaCle01".equals(tmp)) {
				// 한화비전 KRHANW0057 
				String WS_TARGET	= "KEP";
				String END_POINT	= tMap.get("ATTR1");
				String SEED			= tMap.get("ATTR2");
				
				emp_no2	= emp_no;
				
				try {
					com.koreab2b.mro.webservice.epCleverseLogin.neo.branch.common.sso.service.NeoSloWsProxy epProxy	= new com.koreab2b.mro.webservice.epCleverseLogin.neo.branch.common.sso.service.NeoSloWsProxy();
					epProxy.setEndpoint(END_POINT);
					
					String encUserInfo	= epProxy.login(emp_no2, WS_TARGET);
					
					System.out.println("encUserInfo !!!" + encUserInfo);
					
					emp_no	= hanwha.neo.slo.SLODecrypt4AES.decrypt(encUserInfo, SEED);
					ssoChk	= true;
				} catch (Exception e) {

					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", emp_no2);
					pMap.put("ATTR_03", "");
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}else if ("hanwhaCle02".equals(tmp)) {
				// 한화세미텍 KRHANW0057 
				String WS_TARGET	= "ERP";
				String END_POINT	= tMap.get("ATTR1");
				String SEED			= tMap.get("ATTR2");
				
				emp_no2	= emp_no;
				
				try {
					com.koreab2b.mro.webservice.epCleverseLogin.neo.branch.common.sso.service.NeoSloWsProxy epProxy	= new com.koreab2b.mro.webservice.epCleverseLogin.neo.branch.common.sso.service.NeoSloWsProxy();
					epProxy.setEndpoint(END_POINT);
					
					String encUserInfo	= epProxy.login(emp_no2, WS_TARGET);
					
					System.out.println("encUserInfo !!!" + encUserInfo);
					
					emp_no	= hanwha.neo.slo.SLODecrypt4AES.decrypt(encUserInfo, SEED);
					System.out.println("encUserInfo after!!!" + encUserInfo);
					ssoChk	= true;
					
				} catch (Exception e) {

					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", emp_no2);
					pMap.put("ATTR_03", "");
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}
			else if ("HANWHA_SLO3".equals(tmp)) {
				// (주)한화 [기계/글로벌/방산]		KRHANWG002
				String WS_TARGET	= "KEP";
				String END_POINT	= tMap.get("ATTR1");
				String SEED			= tMap.get("ATTR2");
				
				emp_no2	= emp_no;	// st_user_id
				
				try {
					NeoSloWsProxy proxy	= new NeoSloWsProxy();
					proxy.setEndpoint(END_POINT);
					
					String encUserInfo	= proxy.login(emp_no2, WS_TARGET);
					emp_no	= hanwha.neo.slo.SLODecrypt4AES.decrypt(encUserInfo, SEED);
					ssoChk	= true;
				} catch (Exception e) {

					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", emp_no2);
					pMap.put("ATTR_03", "");
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}else if ("HANWHA_SLO4".equals(tmp)) {
				//한화에어로스페이스 클래버스로 진입
				String WS_TARGET	= "KEP";
				String END_POINT	= tMap.get("ATTR1");
				String SEED			= tMap.get("ATTR2");
				
				emp_no2	= emp_no;	// st_user_id
				
				try {
					com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.common.sso.service.NeoSloWsProxy cleverseProxy =new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.common.sso.service.NeoSloWsProxy();
					cleverseProxy.setEndpoint(END_POINT);
					String encUserInfo	= cleverseProxy.login(emp_no2, WS_TARGET);
					emp_no	= hanwha.neo.slo.SLODecrypt4AES.decrypt(encUserInfo, SEED);
					ssoChk	= true;
				} catch (Exception e) {

					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", emp_no2);
					pMap.put("ATTR_03", "");
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}else if ("HANWHA_SLO5".equals(tmp)) {
				//한화에어로스페이스 클래버스로 진입
				String WS_TARGET	= "KEP";
				String END_POINT	= tMap.get("ATTR1");
				String SEED			= tMap.get("ATTR2");
				
				emp_no2	= emp_no;	// st_user_id
				
				try {
					com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.common.sso.service.NeoSloWsProxy cleverseProxy =new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.common.sso.service.NeoSloWsProxy();
					cleverseProxy.setEndpoint(END_POINT);
					String encUserInfo	= cleverseProxy.login(emp_no2, WS_TARGET);
					emp_no	= hanwha.neo.slo.SLODecrypt4AES.decrypt(encUserInfo, SEED);
					ssoChk	= true;
				} catch (Exception e) {

					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", emp_no2);
					pMap.put("ATTR_03", "");
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2229042");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			} else if ("LOTTE_ENC".equals(tmp)) {
				try {

					LotteTripleDESCrypt crypt = new LotteTripleDESCrypt("ssopublickey", charSet);
					
					emp_no2	= emp_no;
					
					emp_no = crypt.hexDecrypt(emp_no2, charSet);
					st_buyer2 = crypt.hexDecrypt(st_buyer, charSet);
					
					ssoChk	= true;
				} catch (Exception e) {
					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", st_buyer + " / " + st_buyer2 + " / " + emp_no2 + " / " + emp_no);
					pMap.put("ATTR_03", CommonUtil.nvl(referer, "No Referer!"));
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}
			else if ("LOTTE_ENC2".equals(tmp)) {
				try {
					String key = "MOIN0KOREABLASTER17010120051010A";
					emp_no2	= emp_no;
					
					emp_no = AES256Cipher.AES_Base64_Decode(emp_no2, key);
					
					com.org.json.JSONObject jObj = new com.org.json.JSONObject(emp_no);
					
					emp_no = (String) jObj.get("employee_num");
					
					ssoChk	= true;
				} catch (Exception e) {
					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", com_code + " / " + emp_no2 + " / " + emp_no);
					pMap.put("ATTR_03", CommonUtil.nvl(referer, "No Referer!"));
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}
			else if ("CAU_ENC".equals(tmp)) {
				try {
					emp_no2 = emp_no;
					Map<String, String> pMap = new HashMap<String, String>();
					pMap.put("st_server_mode",CommonUtil.getDevRealLocalFlag(request));
					pMap.put("st_com_code",com_code);
					pMap.put("st_user_id", emp_no2);
					
					emp_no = externService.getCAULoginCheck(pMap);
					
					if ( "FAIL".equals(emp_no) || "error".equals(emp_no)) {
						throw new Exception("중앙대학교 사용자 인증 실패");
					}
					ssoChk	= true;
					
				} catch (Exception e) {
					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", st_buyer + " / " + emp_no2 + " / " + emp_no );
					pMap.put("ATTR_03", CommonUtil.nvl(referer, "No Referer!"));
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			} else if ("KUMH".equals(tmp)) {
				try {
					EzRSAEncSoapProxy ezProxy = new EzRSAEncSoapProxy();
					emp_no = ezProxy.decryptString(emp_no);
					ssoChk	= true;
					LOGGER.debug("EzRSAEncSoapProxy emp_no : " + emp_no);
				} catch (Exception e) {
					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", st_buyer + " / " + st_buyer2 + " / " + emp_no2 + " / " + emp_no);
					pMap.put("ATTR_03", CommonUtil.nvl(referer, "No Referer!"));
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			} else if ("INNO".equals(tmp)) {
				String keyStr = "HCKOLMARKEY";	
				try {
					emp_no  = CipherDec.decrypt(emp_no, keyStr);
					ssoChk	= true;
				} catch (Exception e) {
					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", st_buyer + " / " + emp_no );
					pMap.put("ATTR_03", CommonUtil.nvl(referer, "No Referer!"));
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}else if ("KCTE".equals(tmp)) { // KCTE SSO 추가 수정 필요
				try {
					emp_no2	= emp_no;		
					st_buyer = st_buyer_kcte;
					emp_no = AES256Cipher.Base64Decrypt(emp_no2);						
					ssoChk	= true;
				} catch (Exception e) {
					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", st_buyer + " / " + emp_no2 + " / " + emp_no );
					pMap.put("ATTR_03", CommonUtil.nvl(referer, "No Referer!"));
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			}else if ("HANS".equals(tmp)) { // 한샘 SSO 로그인
				try {
					Map<String, String> tokenMap = new HashMap<String, String>();
					Map<String, String> resultMap = new HashMap<String, String>();
					
					tokenMap.put("st_com_code",com_code);
					tokenMap.put("buyer_token",emp_no);
					tokenMap.put("buyerUrl",tMap.get("ATTR1"));
					
					resultMap = externService.getHansLoginCheck(tokenMap);
					
					if ( "FAIL".equals(resultMap.get("FLAG"))) {
						throw new Exception("한샘 토큰 인증 실패입니다.");
					}
					
					emp_no = resultMap.get("empNo");
					ssoChk	= true;
				} catch (Exception e) {
					Map<String, Object> pMap	= new HashMap<String, Object>();
					pMap.put("SYSTEM", "KOREAB2B");
					pMap.put("MENU", "SSO");
					pMap.put("LOG_TYPE", "ERROR");
					pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
					pMap.put("ATTR_02", st_buyer + " / " + emp_no2 + " / " + emp_no );
					pMap.put("ATTR_03", CommonUtil.nvl(referer, "No Referer!"));
					pMap.put("REG_IP", "");
					pMap.put("REG_ID", "KEP2129191");
					loginService.saveLog(pMap);
					
					emp_no	= "XXX";
					ssoChk	= false;
				}
			} else if ( tmp == null || referer != null && referer.indexOf(tmp) > -1){
				ssoChk	= true;
				break;
			}
		}

		String user_id	= CommonUtil.nvl(loginService.setIkenSsoId(com_code,emp_no), " ");
		
		if ( "KRCOWA0003".equals(com_code) ) {
			// TODO : 코웨이 CS의 경우 모바일앱에서 접속함. 이 때문에 로그인에 REFERER값이 없음.
			ssoChk	= true;
		}

		if (!ssoChk) {
			try {
				Map<String, Object> pMap	= new HashMap<String, Object>();
				pMap.put("SYSTEM", "KOREAB2B");
				pMap.put("MENU", "SSO");
				pMap.put("LOG_TYPE", "DEBUG");
				pMap.put("ATTR_01", CommonUtil.nvl(referer, "No Referer!"));
				pMap.put("ATTR_02", com_code + "/" + emp_no + "/" + user_id + "/" + emp_no2);
				pMap.put("ATTR_03", ssoChk);
				pMap.put("REG_IP", "");
				pMap.put("REG_ID", "KEP2129191");
				loginService.saveLog(pMap);
			} catch (Exception e) {
				Map<String, Object> pMap	= new HashMap<String, Object>();
				pMap.put("SYSTEM", "KOREAB2B");
				pMap.put("MENU", "SSO");
				pMap.put("LOG_TYPE", "ERROR");
				pMap.put("ATTR_01", CommonUtil.printStackTraceToString(e));
				pMap.put("ATTR_02", ".");
				pMap.put("ATTR_03", ".");
				pMap.put("REG_IP", "");
				pMap.put("REG_ID", "KEP2129191");
				loginService.saveLog(pMap);
			}
			
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("허용되지 않은 접근입니다.", null, "허용되지 않은 접근입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		Login _afterLogin = loginService.getLogin(user_id);
		
		if (_afterLogin == null) {

			try {
				Map<String, Object> pMap	= new HashMap<String, Object>();
				pMap.put("SYSTEM", "KOREAB2B");
				pMap.put("MENU", "SSO");
				pMap.put("LOG_TYPE", "ERROR");
				pMap.put("ATTR_01", com_code + "/" + emp_no + "/" + user_id);
				pMap.put("ATTR_02", ".");
				pMap.put("ATTR_03", ".");
				pMap.put("REG_IP", "");
				pMap.put("REG_ID", "KEP2129191");
				loginService.saveLog(pMap);
			} catch (Exception e) {
				LOGGER.error(CommonUtil.printStackTraceToString(e));
			}
			
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		pLogin.setUserId(_afterLogin.getUserId());
		
		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		} 
		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		if("B".equals(_afterLogin.getBusinessCond())){ //고객사 리뉴얼 적용
//			//해당 고객사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 고객사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(_afterLogin.getComCode(),"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		}
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다

		String pszUserid	= pLogin.getUserId();
		byte[] plainText	= pszUserid.getBytes();
		byte[] bszDigest	= SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid	= SeedCbcAlgorithmUtil.getString(bszDigest);
		
		return "redirect:"+sslurl+"/securityCheck.do?userId=" + bszUserid;
	}
	
	@RequestMapping(value = "/login/mailLogin.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String mailLogin(HttpServletRequest request, @ModelAttribute("login") Login pLogin, BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			request.getSession().removeAttribute("sessionInfo");			
//			return "main/sub_login_logout";
		}
		
		String sslurl = CommonUtil.getSslURL(request, "http");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		String st_gj_user_id = pLogin.getSt_gj_user_id();		
		//SeedCbcAlgorithmUtil 복호화
		String pszUserid1 = st_gj_user_id;
	    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid1);    
	    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);
	    String  plainTextStr =  new String(cbcAlgorithm);
		pLogin.setSt_gj_user_id(plainTextStr);
		
		if ("".equals(CommonUtil.nvl(pLogin.getSt_gj_user_id()))){
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		  
		Login _afterLogin = loginService.getLogin(pLogin.getSt_gj_user_id());
		
		if (_afterLogin == null) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		} 
		
		pLogin.setUserId(_afterLogin.getUserId());
		
		if(!pLogin.getSt_gw_no().equals("LOGIN_RE")){
			if ("".equals(CommonUtil.nvl(pLogin.getSt_gw_no()))){
				redirectAttributes.addFlashAttribute("message", messageSource.getMessage("결재 상신 번호가 없습니다.", null, "결재 상신 번호가 없습니다.", request.getLocale()));
				return "redirect:"+sslurl+"/main.do";
			}
		}
		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		} 
		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		if("B".equals(_afterLogin.getBusinessCond())){ //고객사 리뉴얼 적용
//			//해당 고객사 리스트는 가오픈으로 강제 리뉴얼 -> 여기에 들어간 고객사들은 이전 화면으로 강제
			boolean p01103204 = CommonUtil.getSpecialCheckReturn(_afterLogin.getComCode(),"P01-1032-04");
			if(p01103204){ 
				request.getSession().setAttribute("uiVersion", "original");
			}else {
				request.getSession().setAttribute("uiVersion", "renewal");
			}
		}

		request.getSession().setAttribute("session_sso_login_type", "C"); // 로그인 타입(A: SITE, B: SSO, C: 메일)
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",CommonUtil.nvl(pLogin.getSt_gw_no())); // 결재상신 메일 관련 sso 처리
		request.getSession().setAttribute("session_st_gubun",CommonUtil.nvl(pLogin.getSt_gubun())); // 결재상신 메일 관련(참조메일)
		  //SeedCbcAlgorithmUtil 암호화
		String pszUserid = pLogin.getUserId();
		byte[] plainText = pszUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);		 
		return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
	}

	/**
	 * 개선제안 로그인 처리.
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/pp_sso_login.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String pp_sso_login(HttpServletRequest request, ModelMap pModel, RedirectAttributes redirectAttributes) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		String emp_no = CommonUtil.nvl((String) request.getParameter("st_emp_no"),"");

	  //SeedCbcAlgorithmUtil 복호화
		String pszUserid = emp_no;
	    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid);    
	    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);

	    String  plainTextStr =  new String(cbcAlgorithm);
	    emp_no = plainTextStr;
		String sessionkey = CommonUtil.nvl((String) request.getParameter("sessionkey"),"");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		String com_code = "KRKORE0001";
		String kita_id  = loginService.setIkenSsoId(com_code,emp_no);
		//hash 암호화
		String kita_pw  = loginService.setIkenSsoPw(com_code,kita_id);
		loginService.setSessionkey(sessionkey,kita_id);	
		
		//FlashMap에 전달할 값을 저장한다.  
		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);  
		fm.put("userId", kita_id); 
		fm.put("password", kita_pw);
		fm.put("sessionkey", sessionkey);
		
		request.getSession().setAttribute("session_st_gw_no","pp_sso_login"); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		  //SeedCbcAlgorithmUtil 암호화
		String pszCbcUserid = kita_id;
		byte[] plainText = pszCbcUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
		return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
	}

	/**
	 *SMS 로그인 처리.
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/sms_sso_login.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String sms_sso_login(HttpServletRequest request, ModelMap pModel, RedirectAttributes redirectAttributes) {
			CommonUtil.setSESSION_PASS_FLAG("Y");
			
			String emp_no = CommonUtil.nvl((String) request.getParameter("st_emp_no"),"");

		  //SeedCbcAlgorithmUtil 복호화
			String pszUserid = emp_no;
		    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid);    
		    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);

		    String  plainTextStr =  new String(cbcAlgorithm);
		    emp_no = plainTextStr;
			String sessionkey = CommonUtil.nvl((String) request.getParameter("sessionkey"),"");
			String sslurl2 = CommonUtil.getSslURL(request, "https");
			String com_code = "KRKORE0001";
			String kita_id  = loginService.setIkenSsoId(com_code,emp_no);
			//hash 암호화
			String kita_pw  = loginService.setIkenSsoPw(com_code,kita_id);
			loginService.setSessionkey(sessionkey,kita_id);	
			
			//FlashMap에 전달할 값을 저장한다.  
			FlashMap fm = RequestContextUtils.getOutputFlashMap(request);  
			fm.put("userId", kita_id); 
			fm.put("password", kita_pw);
			fm.put("sessionkey", sessionkey);
			
			request.getSession().setAttribute("session_st_gw_no","SMS_SSO_LOGIN"); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
			  //SeedCbcAlgorithmUtil 암호화
			String pszCbcUserid = kita_id;
			byte[] plainText = pszCbcUserid.getBytes();
			byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
			String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
			return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
	}

	/**
	 *update_password
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/updatePasswordSha.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String updatePasswordSha(HttpServletRequest request, ModelMap pModel, RedirectAttributes redirectAttributes) {

		String emp_no = CommonUtil.nvl((String) request.getParameter("st_emp_no"),"");
		String com_code = "KRKORE0001";
		String kita_id  = loginService.updatePasswordSha(com_code,emp_no);

		return "";
	}

	/**
	 * 고객사 SSO 로그인 처리.30
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
/*	
	@RequestMapping(value = "/login/office_login_1.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String office_login_2(HttpServletRequest request, @ModelAttribute("login") Login pLogin,  BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String sslurl = CommonUtil.getSslURL(request, "http");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		if (_sessionInfo != null) {
			LOGGER.debug("로그 아웃 사용자 아이디 : {}", _sessionInfo.getUserId());
			request.getSession().removeAttribute("sessionInfo");
		}

		request.getSession().invalidate();
		
		// UI 버전 선택값을 세션에 저장 (기존 세션 값 보존)
		String uiVersionParam = (String) request.getParameter("uiVersion");
		String currentUIVersion = (String) request.getSession().getAttribute("uiVersion");
		String uiVersion;
		
		if (uiVersionParam != null) {
		// 새로운 UI 버전이 파라미터로 전달된 경우 업데이트
		uiVersion = uiVersionParam;
		} else if (currentUIVersion != null) {
		// 기존 세션에 UI 버전이 있으면 유지
		uiVersion = currentUIVersion;
		} else {
		// 둘 다 없으면 기본값
		uiVersion = "original";
		}
		
		request.getSession().setAttribute("uiVersion", uiVersion);
		
		//(IKEN SSO) FlashMap에 저장되어 전달된 값을 가져온다.
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);  
		if(flashMap !=null) {  
			pLogin.setUserId((String)flashMap.get("userId"));
		}  

		Login _afterLogin = loginService.getLogin(pLogin.getUserId());

		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}

		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
		//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		  //SeedCbcAlgorithmUtil 암호화
		String pszEnUserid = pLogin.getUserId();
		byte[] plainText = pszEnUserid.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);		 
		return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
	}
*/
	
	/**
	 * 결재 메일 상 로그인 확인, 승인 및 반려 처리
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/mailLoginPwCheck.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String mailLoginPwCheck(HttpServletRequest request, @ModelAttribute("login") Login pLogin, BindingResult result, ModelMap pModel, RedirectAttributes redirectAttributes) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			request.getSession().removeAttribute("sessionInfo");			
		}
		
		String sslurl = CommonUtil.getSslURL(request, "http");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		String st_gj_user_id = pLogin.getSt_gj_user_id();
		
		  //SeedCbcAlgorithmUtil 복호화
		String pszUserid1 = st_gj_user_id;
	    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid1);    
	    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);
	    String  plainTextStr =  new String(cbcAlgorithm);
		pLogin.setSt_gj_user_id(plainTextStr);
		
		if ("".equals(CommonUtil.nvl(pLogin.getSt_gj_user_id()))){
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		  
		Login _afterLogin = loginService.getLogin(pLogin.getSt_gj_user_id());
		
		if (_afterLogin == null) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		} 
		
		pLogin.setUserId(_afterLogin.getUserId());
		
		if(!pLogin.getSt_gw_no().equals("LOGIN_RE")){
			if ("".equals(CommonUtil.nvl(pLogin.getSt_gw_no()))){
				redirectAttributes.addFlashAttribute("message", messageSource.getMessage("결재 상신 번호가 없습니다.", null, "결재 상신 번호가 없습니다.", request.getLocale()));
				return "redirect:"+sslurl+"/main.do";
			}
		}
		if (!pLogin.comfirmUserId(_afterLogin)) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("등록되지 않은 사용자 입니다.", null, "등록되지 않은 사용자 입니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		} 
		if ("S".equals(_afterLogin.getStatus())) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("승인되지 않은 ID입니다. 관리자에게 문의 바랍니다.", null, "승인되지 않은 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}		
		if ("A".equals(_afterLogin.getStatus()) && "A".equals(_afterLogin.getUserType()) && "A".equals(_afterLogin.getChangeUserType()) ) {
			redirectAttributes.addFlashAttribute("message", messageSource.getMessage("관리자권한 승인 거절된 ID입니다. 관리자에게 문의 바랍니다.", null, "관리자권한 승인 거절된 ID입니다 관리자에게 문의 바랍니다.", request.getLocale()));
			return "redirect:"+sslurl+"/main.do";
		}
		
		request.getSession().setAttribute("session_st_gw_no",CommonUtil.nvl(pLogin.getSt_gw_no())); // 결재상신 메일 관련 sso 처리
		request.getSession().setAttribute("session_st_gj_user_id",CommonUtil.nvl(pLogin.getUserId())); // 결재상신 메일 관련 sso 처리
		request.getSession().setAttribute("session_st_gj_type",CommonUtil.nvl(pLogin.getSt_gj_type())); // 결재상신 메일 관련 sso 처리
		request.getSession().setAttribute("session_st_password_type", _afterLogin.getPassword_type()); // 비밀번호 변경 필수 여부
		return "redirect:"+sslurl2+"/main/sub_pw_insert_mail.do";
	}
	
	/**
	 * 아이디 유효성 검사
	 * 
	 * @param @RequestParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/getIdValidCheck.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getIdValidCheck(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		CommonUtil.setSESSION_PASS_FLAG("Y");
		
		String flag = CommonUtil.nvl(loginService.getIdValidCheck(pMap),"");
		String gw_no = CommonUtil.nvl(pMap.get("gw_no"),"");
		String user_id = CommonUtil.nvl(pMap.get("userId"),"");
		String gj_type = CommonUtil.nvl(pMap.get("gj_type"),"");
		String sslurl2 = CommonUtil.getSslURL(request, "https");
		String old_password = CommonUtil.nvl(pMap.get("password_old"),"");
		String new_password = CommonUtil.nvl(pMap.get("password_confirm"),"");
		
		pModel.addAttribute("flag", flag);
		pModel.addAttribute("session_st_gw_no", gw_no);
		pModel.addAttribute("session_st_gj_user_id", user_id);
		pModel.addAttribute("session_st_gj_type", gj_type);
		
		if(flag.equals("Y")){
			request.getSession().setAttribute("session_st_gw_no", gw_no); // 결재번호
			request.getSession().setAttribute("session_st_gj_type", gj_type); // 결재타입
			request.getSession().setAttribute("session_st_password", old_password); // 현재 비밀번호
			request.getSession().setAttribute("session_st_new_password", new_password); // 신규 비밀번호
			
			//SeedCbcAlgorithmUtil 암호화
			String pszUserid = user_id;
			byte[] plainText = pszUserid.getBytes();
			byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
			String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
			return "redirect:"+sslurl2+"/securityCheck.do?userId=" + bszUserid;
		}else if(flag.equals("N") || flag.equals("G")){
			request.getSession().removeAttribute("sessionInfo");
			request.getSession().removeAttribute("session_st_gw_no");
			request.getSession().removeAttribute("session_st_gj_user_id");
			request.getSession().removeAttribute("session_st_gj_type");
			request.getSession().removeAttribute("session_st_password");
			request.getSession().removeAttribute("session_st_new_password");
			request.getSession().invalidate();
			return "/main/sub_pw_insert_mail";
		}else{
			return "/main/sub_pw_insert_mail";
		}
	}
	
	@RequestMapping(value = "/login/getTwoFactorInfo.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getTwoFactorInfo(@RequestParam Map<String, String> pMap) {
		// 추가인증 여부(미리 세팅된 정보 확인)
		String strTwoFactorYn	= CommonUtil.nvl(loginService.getTwoFactorYn(pMap));
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String,String> rtnMap = new HashMap<String,String>();
		rtnMap.put("TWO_FACTOR_YN", strTwoFactorYn);
		_response.put("data", rtnMap);
		
		return _response;
	}
	
	@RequestMapping(value = "/login/setCertSmsResend.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setCertSmsResend(@RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("flag", CommonUtil.nvl(loginService.setCertSmsResend(pMap)));
		
		return _response;
	}
	//사업자번호 조회
	@RequestMapping(value = "/login/getNxTSPKIIRSNo.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getNxTSPKIIRSNo(@RequestParam Map<String, String> pMap) {
		// 사업자 번호
		String strIrsNo	= CommonUtil.nvl(loginService.getIRSNo(pMap));
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String,String> rtnMap = new HashMap<String,String>();
		rtnMap.put("IRS_NO", strIrsNo);
		_response.put("data", rtnMap);
		
		return _response;
	}
}

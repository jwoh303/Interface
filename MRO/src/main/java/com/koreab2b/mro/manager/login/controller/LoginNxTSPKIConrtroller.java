package com.koreab2b.mro.manager.login.controller;


import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;
import tradesign.crypto.provider.*;
import tradesign.pki.pkix.X509Certificate;
import tradesign.pki.pkix.X509CRL;
import tradesign.pki.pkix.Login;

@Controller("LoginNxTSPKIConrtroller")
public class LoginNxTSPKIConrtroller {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginNxTSPKIConrtroller.class);


	/**
	 * KTNET 인증서 유효성 검사
	 * 
	 * @param loginData, st_user_id
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login/certKtnetValidate.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> certKtnetValidate(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		Map<String, String> result =new  HashMap<String, String>();
		Map<String, Object> _response = new HashMap<String, Object>();
		
		try{
				String osName1 = System.getProperty("os.name");
				if (osName1.indexOf("Win") > -1){//로컬
					JeTS.installProvider("D:/data/config/tradesign3280.properties");
				} else {//개발, 운영
					JeTS.installProvider("/webContents/nxtspki/data/config/tradesign3280.properties");
				}
				String st_user_id = new String(CommonUtil.nvl(pMap.get("st_user_id"),""));
				String message = new String(CommonUtil.nvl(pMap.get("loginData"),""));
				//String ssnumber = new String(request.getParameter("cSSN").getBytes("ISO-8859-1"));
				
				// 클라이언트에서 보내온 로그인메시지를 base64디코딩하여 login_request에 저장한다.
				byte[] login_request = tradesign.pki.util.JetsUtil.base64ToBytes(message);
				
				// Login객체 생성
				Login login1 = new Login(login_request);

				login1.setupCipher(JeTS.getServerkmCert(0), JeTS.getServerkmPriKey(0), JeTS.getServerKmKeyPassword(0));
				login1.parseLoginData(true);
				
				// 클라이언트에서 보내온 로그인메시지에서 사용자데이터영역을 userdata에 저장한다.	
				String userdata = new String(login1.getUserData());	
				String ssnumber = new String(login1.getSsn());

				// 클라이언트에서 보내온 로그인메시지에서 로그인을 시도한 사용자의 인증서를 읽는다.
				X509Certificate[] certs = login1.getSignerCerts();

				String SubjectDNStr[] = null; 
				String NotBeforeStr[] = null;
				String NotAfterStr[] = null; 
				String SerialNumber[] = null;
				String IssuerDNStr[] = null; 
				String SignatureAlgorithm[] = null;
				if (certs != null)
				{		
					SubjectDNStr  = new String[certs.length];
					NotBeforeStr  = new String[certs.length];
					NotAfterStr  = new String[certs.length];
					SerialNumber  = new String[certs.length];
					IssuerDNStr  = new String[certs.length];
					SignatureAlgorithm  = new String[certs.length];						
					
					for (int i = 0; i < certs.length; i++)
					{
						SubjectDNStr[i] = certs[i].getSubjectDNStr();
						NotBeforeStr[i] = certs[i].getNotBefore().toString();
						NotAfterStr[i] = certs[i].getNotAfter().toString();
						SerialNumber[i] = certs[i].getSerialNumber().toString();
						IssuerDNStr[i] = certs[i].getIssuerDNStr();
						SignatureAlgorithm[i] = certs[i].getSignatureAlgorithm().toString();
					}
				}
				X509Certificate cert = certs[0];
				boolean ret = cert.VerifyIDN(ssnumber, login1.getRandom());
				
				String idconfirm="";
				if (ret)
					result.put("error", "no_error");
				else
					result.put("error", "선택한 인증서의 사업자번호와 일치하지 않습니다.\n해당 인증기관에 문의하시길 바랍니다.");
				
				String strUserData ="", strRandom = "", strTrId = "";
				
				
					
				strUserData = new String(login1.getUserData());
				strRandom = new String(login1.getRandom());
				strTrId = new String(login1.gettid());					
				
				_response.put("data", result);
				 //SeedCbcAlgorithmUtil 암호화
				String pszUserid = st_user_id;
				byte[] plainText = pszUserid.getBytes();
				byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);
				String bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
				result.put("userId", bszUserid);
				
		} catch(Exception e) {
			e.printStackTrace();
			result.put("error", e.getMessage());
		}
		_response.put("data", result);
		return _response;
	}
}

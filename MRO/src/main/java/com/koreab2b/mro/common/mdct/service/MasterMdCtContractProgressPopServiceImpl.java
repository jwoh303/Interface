package com.koreab2b.mro.common.mdct.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.MasterMdCtContractProgressPopDao;

import crosscert.Base64;
import crosscert.PrivateKey;
import crosscert.Signer;

@Service("masterMdCtContractProgressPopService")
public class MasterMdCtContractProgressPopServiceImpl implements MasterMdCtContractProgressPopService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtContractProgressPopServiceImpl.class);
	
	@Autowired
	private MasterMdCtContractProgressPopDao masterMdCtContractProgressPopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return masterMdCtContractProgressPopDao.selectList(formData);
	}
	
	// 저장
	public String updateReasonData(Map<String,String> formData) {
		return masterMdCtContractProgressPopDao.updateReasonData(formData);
	}
	
	// 저장
	public String updateVendorData(Map<String,String> formData) {
		return masterMdCtContractProgressPopDao.updateVendorData(formData);
	}
	
	// 저장
	public String updateMasterData(Map<String,String> formData) {
		return masterMdCtContractProgressPopDao.updateMasterData(formData);
	}
	
	/**
	 * 전자서명
	 * 
	 * @param content
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("resource")
	public String signValue(String signSource) {
		String signData = ""; // 서명값

		int nPrilen = 0, nCertlen = 0, nRet;
		InputStream inPri = null;
		InputStream inCert = null;

		byte[] Prifilebuf;
		byte[] Certfilebuf;

		String CertPath = "/usr/local/CrossCertLIB/package/Cert/";															//개발서버에 올릴경우 PropertiesManager.getString("wisef.contract.signCert.path");
		//String CertPath = "C:/MRO_PJT/workspace/MRO/src/main/webapp/module/crosscert/package/Cert/";		//로컬 테스트시 경로

		String sInput = signSource;

		try {
			inPri = new FileInputStream(new File(CertPath + "signPri.key"));
			inCert = new FileInputStream(new File(CertPath + "signCert.der"));
		} catch (Exception e1) {
			e1.printStackTrace();
			signData = "ERROR";
			LOGGER.error("FileInputStream ERROR : ", e1);
			throw new RuntimeException("경로에 인증서 파일을 찾을 수 없습니다.");
		}

		try {
			nPrilen = inPri.available();
			Prifilebuf = new byte[nPrilen];

			nRet = inPri.read(Prifilebuf);

			// 개인키 추출
			PrivateKey privateKey = new PrivateKey();
			//개발												String pwd = "88888888";//PropertiesManager.getString("wisef.contract.signCert.pwd");
			//운영(11, 12)									String pwd = "koreab2b";//PropertiesManager.getString("wisef.contract.signCert.pwd");
			String pwd = "88888888";						//PropertiesManager.getString("wisef.contract.signCert.pwd");
			nRet = privateKey.DecryptPriKey(pwd, Prifilebuf, nPrilen);

			if (nRet != 0) {
				signData = "ERROR";
			} else {
				nCertlen = inCert.available();
				Certfilebuf = new byte[nCertlen];

				nRet = inCert.read(Certfilebuf);

				// 전자서명
				Signer signer = new Signer();
				nRet = signer.GetSignedData(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen,
						sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);

				if (nRet != 0) {
					signData = "ERROR";
				}
				Base64 CBase64 = new Base64();

				// 바이트 배열 //바이트 배열길이
				nRet = CBase64.Encode(signer.signedbuf, signer.signedlen);
				if (nRet == 0) {
					signData = new String(CBase64.contentbuf);
				} else {
					/*
					 * out.println("서명값 Base64 Decode 결과 : 실패<br>");
					 * out.println("에러내용 : " + signer.errmessage + "<br>");
					 * out.println("에러코드 : " + CBase64.errcode + "<br>");
					 */
					signData = "ERROR";
				}
			}
		} catch (IOException e1) {
			signData = "ERROR";
			LOGGER.error("IOException ERROR : ", e1);
			throw new RuntimeException("인증서 파일 OPEN에 실패하였습니다.");
		}
		return signData;
	}

}

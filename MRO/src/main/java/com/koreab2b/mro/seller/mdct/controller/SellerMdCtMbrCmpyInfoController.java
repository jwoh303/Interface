package com.koreab2b.mro.seller.mdct.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.mdct.service.SellerMdCtMbrCmpyInfoService;
import com.koreab2b.mro.util.AWSKMSAlgorithmUtil;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Controller("sellerMdCtMbrCmpyInfoController")
public class SellerMdCtMbrCmpyInfoController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtMbrCmpyInfoController.class);

	@Autowired
	private SellerMdCtMbrCmpyInfoService sellerMdCtMbrCmpyInfoService;

	// 조회 (리뉴얼용 JSON API)
	@RequestMapping(value = "/mdct/getSellerMdCtMbrCmpyInfoJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMdCtMbrCmpyInfoJson(@RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getSellerMdCtMbrCmpyInfoJson.do 요청 파라미터 : {}", pMap);

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			List<Map<String, String>> _data = sellerMdCtMbrCmpyInfoService.getList(pMap);
			List<Map<String, String>> _dataDelyArea = sellerMdCtMbrCmpyInfoService.getDelyAreaList(pMap);

		for (int i = 0; i < _data.size(); i++) {
			String bank_account_no = _data.get(i).get("BANK_ACCOUNT_NO");

			// Null/empty check
			if (bank_account_no == null || bank_account_no.trim().isEmpty()) {
				continue;
			}

			bank_account_no = bank_account_no.trim();
			String plainTextStr = bank_account_no; // Default to original value
			boolean decryptionSuccess = false;

			try {
				// Attempt AWS KMS decryption (expects base64)
				plainTextStr = AWSKMSAlgorithmUtil.decrypt(bank_account_no);
				decryptionSuccess = true;
			} catch (com.amazonaws.encryptionsdk.exception.BadCiphertextException e) {
				// Not KMS encrypted - try legacy SEED_CBC or use as-is
				logger.debug("계좌번호 KMS 복호화 실패 (레거시 데이터 가능성): {}", e.getMessage());

				try {
					// Attempt legacy SEED_CBC decryption
					byte[] decrAccount_no = SeedCbcAlgorithmUtil.getBytes(bank_account_no);
					byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrAccount_no, 0, decrAccount_no.length);
					if (cbcAlgorithm != null) {
						plainTextStr = new String(cbcAlgorithm);
						decryptionSuccess = true;
					}
				} catch (Exception seedEx) {
					// Not SEED encrypted either - 빈 값 처리 (마스킹 안 함)
					logger.warn("계좌번호 복호화 실패 - 빈 값 처리: {}", seedEx.getMessage());
					plainTextStr = "";
				}
			} catch (Exception e) {
				logger.error("계좌번호 복호화 중 예상치 못한 오류 - 빈 값 처리: {}", e.getMessage());
				plainTextStr = "";
			}

			_data.get(i).put("BANK_ACCOUNT_NO", plainTextStr);
		}

			result.put("data", CommonUtil.getListNvl(_data));
			result.put("dataDelyArea", CommonUtil.getListNvl(_dataDelyArea));

		} catch (Exception ex) {
			logger.error("회원사 정보 조회 중 예외 발생 - 빈 데이터 리턴", ex);
			// 예외 발생 시에도 빈 리스트로 정상 응답 (HTTP 200 OK)
			result.put("data", new java.util.ArrayList<Map<String, String>>());
			result.put("dataDelyArea", new java.util.ArrayList<Map<String, String>>());
		}

		return result;
	}

	// 조회
		@RequestMapping(value = "/mdct/getSellerMdCtMbrCmpyInfoList.do", method = RequestMethod.POST)
		public String getSellerMdCtMbrCmpyInfoList(ModelMap pModel ,@RequestParam Map<String, String> pMap) throws UnsupportedEncodingException {		
			
			logger.debug("/mdct/getSellerMdCtMbrCmpyInfoList.do 요청 파라미터 : {}", pMap);
			List<Map<String, String>> _data = sellerMdCtMbrCmpyInfoService.getList(pMap);
			List<Map<String, String>> _dataDelyArea = sellerMdCtMbrCmpyInfoService.getDelyAreaList(pMap);
			for (int i = 0; i < _data.size(); i++) {
				String bank_account_no = _data.get(i).get("BANK_ACCOUNT_NO").trim();
				
				/* 기존 SEED_CBC 복호화
				// SeedCbcAlgorithmUtil 복호화
				String pszAccount_no = bank_account_no;
				byte[] decrAccount_no = SeedCbcAlgorithmUtil.getBytes(pszAccount_no);
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
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			pModel.addAttribute("dataDelyArea", CommonUtil.getListNvl(_dataDelyArea)); //납품가능지역
			
			return "seller/mdct/sellerMdCtMbrCmpyInfoList";
		}


	// 저장 (레거시)
	@RequestMapping(value = "/mdct/saveSellerMdCtMbrCmpyInfoList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdCtMbrCmpyInfo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/saveSellerMdCtMbrCmpyInfoList.do MultiValueMap 요청 파라미터 : formData {}", pMap);

		String flag = sellerMdCtMbrCmpyInfoService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}

	// 저장 (리뉴얼)
	@RequestMapping(value = "/mdct/saveSellerMdCtMbrCmpyInfoList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdCtMbrCmpyInfo_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		logger.debug("/mdct/saveSellerMdCtMbrCmpyInfoList_v2.do MultiValueMap 요청 파라미터 : formData {}", pMap);

		String flag = sellerMdCtMbrCmpyInfoService.updateSelectedData_v2(pMap);
		_response.put("msg", flag);

		return  _response;
	}
}

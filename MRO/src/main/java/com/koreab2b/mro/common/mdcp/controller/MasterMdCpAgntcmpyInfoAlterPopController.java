package com.koreab2b.mro.common.mdcp.controller;

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

import com.koreab2b.mro.common.mdcp.service.MasterMdCpAgntcmpyInfoAlterPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.AWSKMSAlgorithmUtil;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Controller("masterMdCpAgntcmpyInfoAlterPopController")
public class MasterMdCpAgntcmpyInfoAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpAgntcmpyInfoAlterPopController.class);

	@Autowired
	private MasterMdCpAgntcmpyInfoAlterPopService masterMdCpAgntcmpyInfoAlterPopService;

	/**
	 * 협력사정보 수정 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getMasterMdCpAgntcmpyInfoAlterPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) throws UnsupportedEncodingException {
		logger.debug("/mdcp/getMasterMdCpAgntcmpyInfoAlterPop.do 요청 파라미터 for jsp : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		/* 로그관련 셋팅 시작 */
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		/* 로그관련 셋팅 끝 */
		
		pMap.put("st_user_id", _sessionInfo.getUserId());
		Map<String, String> tmp_bank_accoutn_no = new HashMap<String, String>();
		List<Map<String, String>> _data = masterMdCpAgntcmpyInfoAlterPopService.getList(pMap);
		List<Map<String, String>> _dataDelyArea = masterMdCpAgntcmpyInfoAlterPopService.getDelyAreaList(pMap);
				
		for (int i = 0; i < _data.size(); i++) {
			String bank_account_no = _data.get(i).get("BANK_ACCOUNT_NO").trim();
			
			if(bank_account_no != null){
				/* 기존 SEED_CBC 복호화
				// SeedCbcAlgorithmUtil 복호화
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
				
				//////////////////////////잠시 테스트///////////////////
				if(_sessionInfo.getUserId().equals("KEP2159512") || _sessionInfo.getUserId().equals("KEP2209002")) {
					//KMS - cck_temp에 임시저장 한 데이터가지고 복호화진행
					String plainTextStrTest = "";
					//cck_temp 에 해당 값이 있는지 select 없으면 ""로
					String cipherText = masterMdCpAgntcmpyInfoAlterPopService.getEncryptText(pMap);
					if(cipherText != null) {
						plainTextStrTest = AWSKMSAlgorithmUtil.decrypt(cipherText);
					}else {
						plainTextStrTest = "";
					}
					_data.get(i).put("BANK_ACCOUNT_NO_TEST", plainTextStrTest);
				}
				
				//////////////////////////잠시 테스트///////////////////
				
				_data.get(i).put("BANK_ACCOUNT_NO", plainTextStr);
			}
		}
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("dataDelyArea", CommonUtil.getListNvl(_dataDelyArea)); //납품가능지역
		return "common/popup/mdcp/masterMdCpAgntcmpyInfoAlterPop";
	}

	// 저장
	@RequestMapping(value = "/mdcp/saveMasterMdCpAgntcmpyInfoAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpAgntcmpyInfoAlterPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		// logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcp/saveMasterMdCpAgntcmpyInfoAlterPop.do Map 요청 파라미터 : formData {}", pMap);

		/* 로그관련 셋팅 시작 */
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		/* 로그관련 셋팅 끝 */
		
		String flag = masterMdCpAgntcmpyInfoAlterPopService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return _response;
	}

	// 저장
	@RequestMapping(value = "/mdcp/saveMasterMdCpAgntcmpyInfoAlterPopAvl.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpAgntcmpyInfoAlterPopAvl(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		// logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcp/saveMasterMdCpAgntcmpyInfoAlterPop.do Map 요청 파라미터 : formData {}", pMap);

		String flag = masterMdCpAgntcmpyInfoAlterPopService.updateSelectedDataAvl(pMap);
		_response.put("msg", flag);

		return _response;
	}

	// 삭제
	@RequestMapping(value = "/mdcp/deleteMasterMdCpAgntcmpyInfoAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCpAgntcmpyInfoAlterPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		// logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcp/deleteMasterMdCpAgntcmpyInfoAlterPop.do Map 요청 파라미터 : formData {}", pMap);

		String flag = masterMdCpAgntcmpyInfoAlterPopService.deleteSelectedData(pMap);
		_response.put("msg", flag);

		return _response;
	}

}

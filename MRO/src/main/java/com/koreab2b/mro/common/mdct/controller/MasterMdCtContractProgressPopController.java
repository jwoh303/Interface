package com.koreab2b.mro.common.mdct.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mdct.service.MasterMdCtContractProgressPopService;
import com.koreab2b.mro.manager.login.service.LoginService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtContractProgressPopController")
public class MasterMdCtContractProgressPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtContractProgressPopController.class);

	@Autowired
	private MasterMdCtContractProgressPopService masterMdCtContractProgressPopService;
	
	@Autowired
	private LoginService loginService;
	
	/**
	 * 표준계약서 조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showMasterMdCtContractProgressPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtContractProgressPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getMasterMdCtContractProgressPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, String> _data = masterMdCtContractProgressPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getMapNvl(_data)); 
		return "common/popup/mdct/masterMdCtContractProgressPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtContractProgressPopReason.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtContractProgressPopReason(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_name", _sessionInfo.getUserNameLoc() );
		
		if (pMap.get("st_mode").equals("contWithdraw")) {						// 계약 회수
			pMap.put("nextContStatus", "DRP");
			pMap.put("st_rj_type", "OBK");
			pMap.put("contStatus", "DRP");
		} else if (pMap.get("st_mode").equals("contReject")) {					// 계약 반려
			if (pMap.get("st_cont_status").equals("CS1")) {						// 회원사 서명대기 상태에서 반려
				pMap.put("nextContStatus", "DRP");
				pMap.put("st_rj_type", "CRT");
				pMap.put("contStatus", "DRP");
			} else if (pMap.get("st_cont_status").equals("CS2")) {				// 회원사 취소서명 대기에서 반려
				pMap.put("nextContStatus", "OS1");
				pMap.put("st_rj_type", "CCR");
				pMap.put("contStatus", "OS1");
			}
		} else if (pMap.get("st_mode").equals("contRevoke")) {					// 계약 취소
			pMap.put("nextContStatus", "CS2");
			pMap.put("st_rj_type", "OSC");
			pMap.put("contStatus", "CS2");
		} else if (pMap.get("st_mode").equals("contCancel")) {						// 계약 해지
			pMap.put("nextContStatus", "FNL");
			pMap.put("st_rj_type", "OCF");
			pMap.put("contStatus", "FNL");
		}

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/saveMasterMdCtContractProgressPopReason.do Map 요청 파라미터 : formData", pMap); 

		String flag = masterMdCtContractProgressPopService.updateReasonData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtContractProgressPopVendor.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtContractProgressPopVendor(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_name", _sessionInfo.getUserNameLoc() );
		
		if (pMap.get("st_cont_status").equals("CS1")) {						// 회원사 서명대기 상태에서 반려
			pMap.put("nextContStatus", "OS1");
			pMap.put("contStatus", "OS1");
		} else if (pMap.get("st_cont_status").equals("CS2")) {				// 회원사 취소서명 대기에서 반려
			pMap.put("nextContStatus", "OS2");
			pMap.put("contStatus", "OS2");
		}
		
		pMap.put("st_sign_value", CommonUtil.nvl(pMap.get("st_sign_value"), " "));

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/saveMasterMdCtContractProgressPopReason.do Map 요청 파라미터 : formData", pMap); 

		String flag = masterMdCtContractProgressPopService.updateVendorData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtContractProgressPopMaster.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtContractProgressPopMaster(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_name", _sessionInfo.getUserNameLoc() );
		
		pMap.put("st_sign_value", CommonUtil.nvl(pMap.get("st_sign_value"), " "));
		pMap.put("nextContStatus", "END");
		pMap.put("contStatus", "END");
		
		if (pMap.get("st_cont_status").equals("OS2")) {
			pMap.put("st_rj_type", "OSC");
			pMap.put("contStatus", "DRP");
		}
		if (pMap.get("st_cont_status").equals("OS1")  && pMap.get("st_cont_chg_type").equals("M")) {
			pMap.put("st_rj_type", "OCC");
			pMap.put("contStatus", "END");
		}
		
		String _signData = masterMdCtContractProgressPopService.signValue(pMap.get("st_sign_source"));
		
		if (_signData.equals("ERROR")) {
			_response.put("msg", "cert");
		} else {
			pMap.put("st_sign_value", _signData);
			
			//logger.debug("요청 파라미터 : _list", _list);
			logger.debug("/mdct/saveMasterMdCtContractProgressPopMaster.do Map 요청 파라미터 : formData", pMap); 
	
			String flag = masterMdCtContractProgressPopService.updateMasterData(pMap);
			_response.put("msg", flag);
		}
		return  _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdct/getMasterMdCtContractProgressPopCertValidate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMasterMdCtContractProgressPopCertValidate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/getMasterMdCtContractProgressPopCertValidate.do Map 요청 파라미터 : formData {} ", pMap);

		Map<String, String> _result = loginService.getCertValidate(pMap.get("st_sign_value"), pMap.get("getR"), pMap.get("st_irs_no"));
		_response.put("data", _result);

		return  _response;
	}

}

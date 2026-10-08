package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.master.mdcm.service.MasterMdCmSellerCmpyMultiSelPopService;

// 구매정보 조회 및 관리 - 협력사 복수선택 팝업.
// 기존 단건 팝업(masterMdCmSellerCmpyChoicePop)과 공용 팝업(/common/icomcmpyPop.do)은 그대로 두고 새로 만든 것이라 SQL 도 공유하지 않는다.
// 페이징 없이 JSON 으로 내리고, 협력사가 많아(운영 17,916건) 협력사명 2글자 이상 + 앞 300건으로 제한한다.
@Controller("masterMdCmSellerCmpyMultiSelPopController")
public class MasterMdCmSellerCmpyMultiSelPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmSellerCmpyMultiSelPopController.class);

	@Autowired
	private MasterMdCmSellerCmpyMultiSelPopService masterMdCmSellerCmpyMultiSelPopService;

	@RequestMapping(value = "/mdcm/getMasterMdCmSellerCmpyMultiSelPopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmSellerCmpyMultiSelPopList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getMasterMdCmSellerCmpyMultiSelPopList.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmSellerCmpyMultiSelPopService.getList(pMap);
		_response.put("data", _data);
		return _response;
	}

}

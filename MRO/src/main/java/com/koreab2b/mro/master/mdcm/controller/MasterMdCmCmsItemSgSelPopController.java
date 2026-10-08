package com.koreab2b.mro.master.mdcm.controller;

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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemSgSelPopService;

// 상품정보 조회 및 관리 - 카테고리(KEPSGMG, 구 SG) 복수선택 팝업.
// 표준DB 전용으로 새로 만든 것이라 공용 팝업(mprq)과 SQL 도 공유하지 않는다. 페이징 없이 전량을 JSON 으로 내린다.
@Controller("masterMdCmCmsItemSgSelPopController")
public class MasterMdCmCmsItemSgSelPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCmsItemSgSelPopController.class);

	@Autowired
	private MasterMdCmCmsItemSgSelPopService masterMdCmCmsItemSgSelPopService;

	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemSgSelPopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemSgSelPopList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("/mdcm/getMasterMdCmCmsItemSgSelPopList.do 요청 파라미터 : {}", pMap);
		pMap.remove("st_my_user_id");
		if ("Y".equals(pMap.get("st_my_sg_yn"))) {
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("st_my_user_id", _sessionInfo.getUserId());
		}
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmCmsItemSgSelPopService.getList(pMap);
		_response.put("data", _data);
		return _response;
	}

}

package com.koreab2b.mro.master.mprq.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqDailySourcingBuyerSelPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqDailySourcingBuyerSelPopController")
public class MasterMpRqDailySourcingBuyerSelPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDailySourcingBuyerSelPopController.class);

	private static final int MAX_CODE_CNT = 1000;

	@Autowired
	private MasterMpRqDailySourcingBuyerSelPopService masterMpRqDailySourcingBuyerSelPopService;

	@RequestMapping(value = "/mprq/getMasterMpRqDailySourcingBuyerSelPopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqDailySourcingBuyerSelPopList(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("/mprq/getMasterMpRqDailySourcingBuyerSelPopList.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		List<String> _codeList = new ArrayList<String>();
		String[] _codes = CommonUtil.nvl(pMap.get("st_com_code_multi")).split("@");
		for (int i = 0; i < _codes.length; i++) {
			String _code = _codes[i].trim().toUpperCase();
			if (!"".equals(_code) && !_codeList.contains(_code)) {
				_codeList.add(_code);
			}
		}
		if (_codeList.size() > MAX_CODE_CNT) {
			_response.put("errMsg", "고객사코드는 한 번에 " + MAX_CODE_CNT + "건까지 조회할 수 있습니다.");
			_response.put("data", new ArrayList<Map<String, String>>());
			return _response;
		}

		String _comorgType = CommonUtil.nvl(pMap.get("st_comorg_type"), "ALL");
		if (!"RESP".equals(_comorgType) && !"MNG".equals(_comorgType)) {
			_comorgType = "ALL";
		}

		Map<String, Object> _param = new HashMap<String, Object>();
		_param.put("st_comorg_type", _comorgType);
		_param.put("st_com_name_loc", CommonUtil.nvl(pMap.get("st_com_name_loc")).trim());
		_param.put("st_comorg_name", CommonUtil.nvl(pMap.get("st_comorg_name")).trim());
		_param.put("st_com_code_list", _codeList);
		_param.put("st_user_id", _sessionInfo.getUserId());
		_param.put("st_dept", _sessionInfo.getDepartment());

		_response.put("data", masterMpRqDailySourcingBuyerSelPopService.getList(_param));
		return _response;
	}

}

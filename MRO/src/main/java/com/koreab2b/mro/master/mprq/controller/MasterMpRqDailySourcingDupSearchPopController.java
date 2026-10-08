package com.koreab2b.mro.master.mprq.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mprq.service.MasterMpRqDailySourcingDupSearchPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqDailySourcingDupSearchPopController")
public class MasterMpRqDailySourcingDupSearchPopController {

	@Autowired
	private MasterMpRqDailySourcingDupSearchPopService masterMpRqDailySourcingDupSearchPopService;

	@RequestMapping(value = "/mprq/searchMasterMpRqDailySourcingDupCatList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqDailySourcingDupCatList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		setSearchCond(pMap);

		List<Map<String,String>> _data = new ArrayList<Map<String,String>>();
		if (!"".equals(pMap.get("st_buyer")) && (!"".equals(pMap.get("st_item_no")) || hasSearchCond(pMap))) {
			_data = masterMpRqDailySourcingDupSearchPopService.getCatList(pMap);
		}
		return IBSheetUtil.addResut(req, _data, pMap);
	}

	@RequestMapping(value = "/mprq/searchMasterMpRqDailySourcingDupStdList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqDailySourcingDupStdList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		setSearchCond(pMap);

		List<Map<String,String>> _data = new ArrayList<Map<String,String>>();
		if (!"".equals(pMap.get("st_cms_code")) || hasSearchCond(pMap)) {
			_data = masterMpRqDailySourcingDupSearchPopService.getStdList(pMap);
		}
		return IBSheetUtil.addResut(req, _data, pMap);
	}

	private void setSearchCond(Map<String, Object> pMap) {
		pMap.put("st_buyer", trimUpper(pMap.get("st_buyer")));
		pMap.put("st_item_no", trimUpper(pMap.get("st_item_no")));
		pMap.put("st_cms_code", trimUpper(pMap.get("st_cms_code")));
		pMap.put("st_description", toLike(pMap.get("st_description"), false));
		pMap.put("st_maker_part_no", toLike(pMap.get("st_maker_part_no"), false));
		pMap.put("st_specification", toLike(pMap.get("st_specification"), true));
		pMap.put("st_maker_name", toLike(pMap.get("st_maker_name"), false));
		pMap.put("st_unit_measure", trimUpper(pMap.get("st_unit_measure")));

		pMap.remove("st_sgArr");
		List<String> _sgList = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("st_sg_id_multi")), "@");
		if (_sgList.size() > 0) {
			pMap.put("st_sgArr", _sgList);
		}
	}

	private boolean hasSearchCond(Map<String, Object> pMap) {
		return !"".equals(pMap.get("st_description")) || !"".equals(pMap.get("st_maker_part_no"))
				|| !"".equals(pMap.get("st_specification")) || !"".equals(pMap.get("st_maker_name"));
	}

	private String trimUpper(Object value) {
		return CommonUtil.nvl((String) value).trim().toUpperCase();
	}

	private String toLike(Object value, boolean splitCaret) {
		String _value = trimUpper(value);
		if ("".equals(_value)) {
			return "";
		}
		if (splitCaret) {
			_value = _value.replace("^^", "%");
		}
		return "%" + _value + "%";
	}

}

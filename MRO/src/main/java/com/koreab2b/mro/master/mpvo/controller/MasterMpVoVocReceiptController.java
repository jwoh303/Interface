package com.koreab2b.mro.master.mpvo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.master.mpvo.service.MasterMpVoVocReceiptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocReceiptController")
public class MasterMpVoVocReceiptController {
	
	@Autowired
	private MasterMpVoVocReceiptService masterMpVoVocReceiptService;
	
	// 저장
	@RequestMapping(value = "/mpvo/saveMasterMpVoVocReceiptList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpVoVocReceiptList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpVoVocReceiptService.saveMasterMpVoVocReceiptList(pMap);
		_response.put("msg", _result);
		return _response;
	}
	/**
	 * VOC등록 팝
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/showMasterMpVoVocRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpVoVocRegPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		if(pMap.get("st_type").equals("PO")) {
			List<Map<String, String>> _data = masterMpVoVocReceiptService.getMasterMpVoVocRegPop(pMap);
			pModel.addAttribute("data_po", CommonUtil.getListNvl(_data).get(0));			
		}
		return  "master/mpvo/masterMpVoVocRegPop";
	}
}

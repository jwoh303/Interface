package com.koreab2b.mro.seller.mpiv.controller;

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

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.mpds.service.SellerMpDsPckpaprDesignCropProtectManagePopService;
import com.koreab2b.mro.seller.mpiv.service.SellerMpIvMkImScheduleRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvMkImScheduleRegController")
public class SellerMpIvMkImScheduleRegController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvMkImScheduleRegController.class);

	@Autowired
	private CommonInfoService commonInfoService;

	@Autowired
	private SellerMpIvMkImScheduleRegService sellerMpIvMkImScheduleRegService;

	@Autowired
	private SellerMpDsPckpaprDesignCropProtectManagePopService sellerMpDsPckpaprDesignCropProtectManagePopService;

	/**
	 * 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpIvMkImScheduleRegList.do", method = { RequestMethod.POST,
			RequestMethod.GET })
	public String getSellerMpIvMkImScheduleRegList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvMkImScheduleRegList.do 요청 파라미터 : {}", pMap);
		pMap = CommonUtil.PagingPrc(pMap);
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = sellerMpIvMkImScheduleRegService.getList(formData);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(formData);

		return "seller/mpiv/sellerMpIvMkImScheduleRegList";
	}

	/**
	 * 수주접수 상세 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpIvMkImScheduleRegDetailPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String getSellerMpIvMkImScheduleRegDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvMkImScheduleRegDetailPop.do 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _data = sellerMpIvMkImScheduleRegService.getPopupList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);

		return "common/popup/mpiv/sellerMpIvMkImScheduleRegDetailPop";
	}

	/**
	 * 일정등록
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpiv/saveSellerMkImScheduleReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMkImScheduleReg(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest request) {
		logger.debug("saveMkImScheduleReg 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		int _ret = sellerMpIvMkImScheduleRegService.saveMkImScheduleReg(formData);
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return _response;
	}

	/**
	 * 일정추가
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpiv/saveSellerMkImScheduleUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMkImScheduleUpdate(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest request) {
		logger.debug("saveMkImScheduleUpdate 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		int rtnCnt = sellerMpIvMkImScheduleRegService.saveMkImScheduleUpdate(formData);
		_response.put("msg", rtnCnt);
		logger.debug("_response " + _response);
		return _response;
	}

}

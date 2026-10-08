package com.koreab2b.mro.seller.mdct.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;
import com.koreab2b.mro.common.mdct.service.SellerMdCtPrivateInfoPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mdct.service.SellerMdCtUserSearchService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtUserSearchController")
public class SellerMdCtUserSearchController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtUserSearchController.class);

	@Autowired
	private SellerMdCtUserSearchService sellerMdCtUserSearchService;

	@Autowired
	private SellerMdCtPrivateInfoPopService sellerMdCtPrivateInfoPopService;
	
	// 조회
	@RequestMapping(value = "/mdct/getSellerMdCtUserSearchList.do", method = RequestMethod.POST)
	public String getSellerMdCtUserSearchList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		//logger.debug("/mdct/getSellerMdCtUserSearchList.do 요청 파라미터 : {}", pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);

		// 화면 조회
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		List<Map<String, String>> _data = sellerMdCtUserSearchService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "seller/mdct/sellerMdCtUserSearchList";
	}

	// 리뉴얼용 조회 (페이징 없음)
	@RequestMapping(value = "/mdct/getSellerMdCtUserSearchList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMdCtUserSearchList_v2(
		HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_com_code", _sessionInfo.getComCode());

		List<Map<String, String>> _data = sellerMdCtUserSearchService.getList_v2(pMap);

		// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
		return IBSheetResponseUtil.createSuccessResponse(_data);
	}

	// 삭제
	@RequestMapping(value = "/mdct/deleteSellerMdCtUserSearchList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdCtUserSearch(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		logger.debug("/mdct/deleteSellerMdCtUserSearchList.do MultiValueMap 요청 파라미터 : formData == {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap.put("st_com_code", _sessionInfo.getComCode());

		String flag = sellerMdCtUserSearchService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}

	/**
	 * 사용자 상세정보 조회 (JSON API for 리뉴얼)
	 * @param req
	 * @param pMap
	 * @return JSON 형식의 사용자 상세정보
	 */
	@RequestMapping(value = "/mdct/getUserDetailJson.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getUserDetailJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		logger.debug("/mdct/getUserDetailJson.do 요청 파라미터 : {}", pMap);

		Map<String, Object> response = new HashMap<String, Object>();

		try {
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("st_com_code", _sessionInfo.getComCode());

			// 기존 Service 재사용
			List<Map<String, String>> _data = sellerMdCtPrivateInfoPopService.getList(pMap);

			if (_data != null && !_data.isEmpty()) {
				Map<String, String> userData = _data.get(0);
				response.put("success", true);
				response.put("data", userData);
				logger.debug("[사용자 상세] 조회 성공 - USER_ID: {}", pMap.get("st_user_id"));
			} else {
				response.put("success", false);
				response.put("message", "사용자 정보를 찾을 수 없습니다.");
				logger.warn("[사용자 상세] 조회 실패 - 데이터 없음, USER_ID: {}", pMap.get("st_user_id"));
			}

		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "사용자 정보 조회 중 오류가 발생했습니다.");
			logger.error("[사용자 상세] 조회 오류", e);
		}

		return response;
	}
}

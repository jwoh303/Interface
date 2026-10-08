package com.koreab2b.mro.common.mpso.controller;

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

import com.koreab2b.mro.common.mpso.service.BuyerMpSoNameCardInfoPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
@Controller("buyerMpSoNameCardInfoPopController")
public class BuyerMpSoNameCardInfoPopController {
	@Autowired
	private BuyerMpSoNameCardInfoPopService buyerMpSoNameCardInfoPopService;
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoNameCardInfoPopController.class);
	// 조회(영업점)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);
		
		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoNameCardPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoNameCardPop";
		}
	}

	// 조회(클린킹_가전에어컨)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardCkAcPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardCkAcPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);
		
		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoNameCardCkAcPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoNameCardCkAcPop";
		}
	}
	
	// 조회(본사_홀딩스)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardHdQtPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardHdQtPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);
		
		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoNameCardHdQtPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoNameCardHdQtPop";
		}
	}
	
	// 조회(홈닥터)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardHmDtPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardHmDtPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);
		
		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}
		
		return "common/popup/mpso/buyerMpSoNameCardHmDtPop";
	}
	
	// 조회(점장)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardBrMgPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardBrMgPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);
		
		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoNameCardBrMgPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoNameCardBrMgPop";
		}
	}
	
	// 조회(솔라엣지)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardSolaPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardSolaPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);
		
		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}
		
		return "common/popup/mpso/buyerMpSoNameCardSolaPop";
	}
	
	// 조회(한샘)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardHansPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardHansPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);
		
		Map<String, String> _user_data = buyerMpSoNameCardInfoPopService.getUserInfoList(pMap);
		pModel.addAttribute("user_data", _user_data);

		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoNameCardHansPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoNameCardHansPop";
		}
	}
	
	// 조회(LS오토모티브)
	@RequestMapping(value = "/mpso/getBuyerMpSoNameCardLsatPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoNameCardLsatPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_id",_sessionInfo.getUserId());

		List<Map<String, String>> _data = buyerMpSoNameCardInfoPopService.getList(pMap);

		if (_data != null && _data.size() > 0) {
			pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
		}else{
			pModel.addAttribute("data", null);
		}

		// LSAT - 국/영문 양면 명함 1개 상품, 팝업 하나에서 양쪽 언어 항목을 모두 입력받음
		String st_type = CommonUtil.nvl(req.getParameter("st_type"), "LSAT");
		pModel.addAttribute("st_type", st_type);

		return "common/popup/mpso/buyerMpSoNameCardLsatPop_v2";
	}

	// 한샘 직위/직급 자동판별(POST/LEVL, TEXT1 매칭)뿐 아니라, LSAT 근무지 주소 미리보기(WKPL, CODE2 매칭)도
	// 이 엔드포인트를 그대로 재사용한다 - st_code2를 넘기면 stPosition 대신 CODE2로 매칭해서 TEXT2/TEXT3(주소)까지 같이 내려줌.
	@RequestMapping("/mpso/getNameCardPositionType.do")
    @ResponseBody
    public Map<String, Object> getNameCardPositionType(
            @RequestParam(value = "st_buyer", required = false) String stBuyer,
            @RequestParam(value = "st_position", required = false) String stPosition,
            @RequestParam(value = "st_code2", required = false) String stCode2,
            @RequestParam(value = "type", required = false, defaultValue = "NCIF") String type,
            @RequestParam(value = "code1Csv", required = false, defaultValue = "POST,LEVL") String code1Csv,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<String, Object>();

        try {
            String[] code1List = code1Csv.split(",");

            Map<String, Object> param = new HashMap<String, Object>();
            param.put("stBuyer", stBuyer == null ? "" : stBuyer);
            param.put("stPosition", stPosition == null ? "" : stPosition);
            param.put("stCode2", stCode2 == null ? "" : stCode2);
            param.put("type", type == null ? "" : type);
            param.put("code1List", code1List);

            Map<String, Object> columnInfo = buyerMpSoNameCardInfoPopService.getCardColumnInfoList(param);

            result.put("columnInfo", columnInfo);
            result.put("result", "success");
        } catch (Exception e) {
            result.put("columnInfo", null);
            result.put("result", "fail");
            result.put("message", e.getMessage());
        }

        return result;
    }
	
	
	
	// 저장
	@RequestMapping(value = "/mpso/saveBuyerMpSoCartRemarkNameCard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpSoCartRemarkNameCard(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String _rtnMsg = buyerMpSoNameCardInfoPopService.saveBuyerMpSoCartRemarkNameCard(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
	}
}

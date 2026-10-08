package com.koreab2b.mro.buyer.mdam.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

/*
 * 메뉴(고객사) : 관리자설정관리 > 마스터코드관리 (도착지/직급/부서/계정/관리 5탭 통합)
 * 진입 URL    : /mdam/showBuyerMdAmMasterCodeManage.do
 * 데이터 4개 엔드포인트는 master 모듈(MasterMdAmMasterCodeManageController) 재사용.
 *   - /mdam/getMasterMdAmMasterCodeManageList.do  (조회)
 *   - /mdam/saveMasterMdAmMasterCodeManageList.do (저장)
 *   - /mdam/delMasterMdAmMasterCodeManageList.do  (삭제)
 * 탭 권한은 KX_MENUINFO depth-3 노드 + KX_MENUAUTH 매핑으로 동적 필터링.
 */
@Controller("buyerMdAmMasterCodeManageController")
public class BuyerMdAmMasterCodeManageController {

	@RequestMapping(value = "/mdam/showBuyerMdAmMasterCodeManage.do",
			method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmMasterCodeManage(HttpServletRequest req, ModelMap pModel,
			@RequestParam Map<String, String> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		// KX_MENUINFO + KX_MENUAUTH 기반 탭 권한 필터링
		String menuId = CommonUtil.nvl(pMap.get("menuId"), "br00503000000");
		String userId = (_sessionInfo != null) ? _sessionInfo.getUserId() : "";
		List<Map<String, String>> _tabData = CommonUtil.getMenuTabInfo_v2(menuId, userId);
		pModel.addAttribute("tab_data", _tabData);

		// 리뉴얼 모드 분기 — buyer 리뉴얼이 정착되어 본 화면은 _v2 유일 진입
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "buyer/mdam/buyerMdAmMasterCodeManageList_v2";
		}
		return "buyer/mdam/buyerMdAmMasterCodeManageList_v2";
	}
}

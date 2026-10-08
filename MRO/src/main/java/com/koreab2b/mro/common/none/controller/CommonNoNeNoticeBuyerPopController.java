package com.koreab2b.mro.common.none.controller;

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

import com.koreab2b.mro.common.none.service.CommonNoNeNoticeBuyerPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonNoNeNoticeBuyerPopController")
public class CommonNoNeNoticeBuyerPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonNoNeNoticeBuyerPopController.class);

	@Autowired
	private CommonNoNeNoticeBuyerPopService commonNoNeNoticeBuyerPopService;

	/**
	 * 공지사항 고객사 선택 (다건) 팝업
	 * - 사업자번호, 대표자명 포함
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/none/getCommonNoNeNoticeBuyerPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonNoNeNoticeBuyerPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/none/getCommonNoNeNoticeBuyerPop.do 요청 파라미터 for jsp : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		pMap.put("st_comorg_type", CommonUtil.nvl(pMap.get("st_comorg_type"), "ALL"));
		pMap.put("st_user_id", CommonUtil.nvl(pMap.get("st_user_id"), _sessionInfo.getUserId()));
		pMap.put("st_dept", CommonUtil.nvl(pMap.get("st_dept"), _sessionInfo.getDepartment()));

		// 조회 버튼 클릭 시에만 데이터 조회 (searchYn=Y)
		String searchYn = CommonUtil.nvl(pMap.get("searchYn"), "N");
		if ("Y".equals(searchYn)) {
			List<Map<String, String>> _data = commonNoNeNoticeBuyerPopService.getCommonNoNeNoticeBuyerPop(pMap);
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		}
		return "common/popup/none/commonNoNeNoticeBuyerPop";
	}

}

package com.koreab2b.mro.buyer.mpso.controller;

import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartCowayService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoDlvryInfoService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderInfoService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderProgressService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoCartCowayController")
public class BuyerMpSoCartCowayController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartCowayController.class);

	@Autowired
	private BuyerMpSoCartCowayService buyerMpSoCartCowayService;
	@Autowired
	private BuyerMpSoOrderInfoService buyerMpSoOrderInfoService;
	@Autowired
	private BuyerMpSoDlvryInfoService buyerMpSoDlvryInfoService;
	@Autowired
	private BuyerMpSoOrderProgressService buyerMpSoOrderProgressService;

	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoCartCowayList.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMpSoCartCowayList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		// logger.debug("/mpso/getBuyerMpSoCartCowayList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		String buyer = _sessionInfo.getComCode();
		pMap.put("st_user_id", _sessionInfo.getUserId());
		// pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_dept", _sessionInfo.getDepartment());

		String listQuery = "2";
		/*
		 * if(buyer.equals("KRCOWA0001")|| buyer.equals("KRCOWA0002")|| buyer.equals("KRCOWA0003")||
		 * buyer.equals("KRCOWA0004")|| buyer.equals("KRCOWA0005")|| buyer.equals("KRCOWA0006")){ listQuery = "1"; }
		 */
		// SLOGIC-BEGIN(P06-0000036)
		// 코웨이일경우
		String p060000036 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL03_DATA"); // 권한특수로직
		if ("COWAY".equals(p060000036)) {
			listQuery = "1";
		}
		// SLOGIC-END

		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow"), "10"));
		pMap.put("st_verif_num", CommonUtil.onvl(pMap.get("st_verif_num"), ""));
		pMap.put("st_query_cart", CommonUtil.onvl(pMap.get("st_query_cart"), "ALL"));
		pMap.put("st_listQuery", CommonUtil.onvl(pMap.get("st_listQuery"), listQuery));
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun"), "c_date"));

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = buyerMpSoCartCowayService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "buyer/mpso/buyerMpSoCartCowayList";
	}

	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoCartCowayClcsList.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMpSoCartCowayClcsList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String buyer = _sessionInfo.getComCode();
		String listQuery = "2";
		// SLOGIC-BEGIN(P06-0000036)
		String p060000036 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL03_DATA"); // 권한특수로직
		if ("COWAY".equals(p060000036)) {
			listQuery = "1";
		}
		// SLOGIC-END
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_dept", _sessionInfo.getDepartment());
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow"), "10"));
		pMap.put("st_verif_num", CommonUtil.onvl(pMap.get("st_verif_num"), ""));
		pMap.put("st_query_cart", CommonUtil.onvl(pMap.get("st_query_cart"), "ALL"));
		pMap.put("st_listQuery", CommonUtil.onvl(pMap.get("st_listQuery"), listQuery));
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun"), "c_date"));
		pMap.put("st_ji_gubun", CommonUtil.nvl(pMap.get("st_ji_gubun"), ""));
		pMap.put("st_sin_gubun", CommonUtil.nvl(pMap.get("st_sin_gubun"), ""));

		pMap = CommonUtil.PagingPrc(pMap);
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = buyerMpSoCartCowayService.getClcsList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "buyer/mpso/buyerMpSoCartCowayClcsList";
	}

	// 조회 PG_06_B_010_01 비용부서조회
	@RequestMapping(value = "/mpso/getBuyerUserCowayBudgetOrderListPop.do", method = RequestMethod.POST)
	public String getBuyerUserCowayBudgetOrderListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		// //logger.debug("/mpso/getBuyerUserCowayBudgetOrderListPop.do 요청 파라미터 : {}", pMap);

		List<Map<String, String>> _data = buyerMpSoCartCowayService.getBuyerUserCowayBudgetOrderListPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "common/popup/mpso/buyerUserCowayBudgetOrderListPop";
	}

	// 조회 PG_06_B_010_02 계정조회
	@RequestMapping(value = "/mpso/getBuyerUserCowayBudgetAccountListPop.do", method = RequestMethod.POST)
	public String getBuyerUserCowayBudgetAccountListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		// logger.debug("/mpso/getBuyerUserCowayBudgetAccountListPop.do 요청 파라미터 : {}", pMap);

		List<Map<String, String>> _data = buyerMpSoCartCowayService.getBuyerUserCowayBudgetAccountListPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "common/popup/mpso/buyerUserCowayBudgetAccountListPop";
	}

	// 조회 PG_06_B_010_03 부서예산조회
	@RequestMapping(value = "/mpso/getBuyerCowayUserBudgetAccountListPop.do", method = RequestMethod.POST)
	public String getBuyerCowayUserBudgetAccountListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		// logger.debug("/mpso/getBuyerCowayUserBudgetAccountListPop.do 요청 파라미터 : {}", pMap);

		List<Map<String, String>> _data = buyerMpSoCartCowayService.getBuyerCowayUserBudgetAccountListPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "common/popup/mpso/buyerCowayUserBudgetAccountListPop";
	}

	/**
	 * 상조용품 조회 /kr/coway_buyer/shopping_cart/buyer_shoppingcart_sangjoitem_search.jsp
	 */
	@RequestMapping(value = "/mpso/getBuyerShoppingcartSangjoitemSearch.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerShoppingcartSangjoitemSearch(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		String msg = buyerMpSoCartCowayService.getK005List(pMap);

		_msg.put("MSG", msg);
		_response.put("msg", _msg);
		return _response;
	}

	/**
	 * 조회 /kr/coway_buyer/main/home/search_buyer_cart_qty.jsp
	 */
	@RequestMapping(value = "/mpso/getSearchBuyerCartQty.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSearchBuyerCartQty(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		String msg = buyerMpSoCartCowayService.getBuyerCartQty(pMap);

		_msg.put("MSG", msg);
		_response.put("msg", _msg);
		return _response;
	}

	/**
	 * 첨부파일저장 /kr/coway_buyer/shopping_cart/buyer_shoppingcart_list_attach_update.jsp
	 */
	@RequestMapping(value = "/mpso/getBuyerShoppingcartListAttachUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerShoppingcartListAttachUpdate(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		String msg = buyerMpSoCartCowayService.updateAttatch(pMap);

		_msg.put("MSG", msg);
		_response.put("msg", _msg);
		return _response;
	}

	// 조회 PG_06_B_010_06 -- 코웨이용 상조용 주문 화면
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderInfoSangjoList.do", method = RequestMethod.POST)
	public String getBuyerMpSoOrderInfoSangjoList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		// //logger.debug("/mpso/getBuyerMpSoOrderInfoSangjoList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		// logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());
		pMap.put("byca_comorg_code", _sessionInfo.getBycaComorgCode());

		// 화면 조회
		pMap.put("paging", "0");

		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		} else {
			LOGGER.debug(pMap.get("st_query_cart"));
		}

		// logger.debug(pMap.toString());

		List<Map<String, String>> _data = buyerMpSoOrderInfoService.getList(pMap);
		// 선입고발주 제외대상 업체 조회
		String pre_goods_count = buyerMpSoOrderInfoService.getNotPreGoodsCompany(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("pre_goods_count", pre_goods_count);
		pModel.addAttribute("Hdata", "");

		return "buyer/mpso/buyerMpSoOrderInfoSangjoList";
	}

	// 코웨이용 주문 PG_06_B_010_05
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderInfoCowayList.do", method = RequestMethod.POST)
	public String getBuyerMpSoOrderInfoCowayList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		// //logger.debug("/mpso/getBuyerMpSoOrderInfoCowayList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		// logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());
		pMap.put("byca_comorg_code", _sessionInfo.getBycaComorgCode());

		// 화면 조회
		pMap.put("paging", "0");

		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		} else {
			LOGGER.debug(pMap.get("st_query_cart"));
		}

		// logger.debug(pMap.toString());

		List<Map<String, String>> _data = buyerMpSoOrderInfoService.getList(pMap);
		// 선입고발주 제외대상 업체 조회
		String pre_goods_count = buyerMpSoOrderInfoService.getNotPreGoodsCompany(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("pre_goods_count", pre_goods_count);
		pModel.addAttribute("Hdata", "");

		return "buyer/mpso/buyerMpSoOrderInfoCowayList";
	}

	/**
	 * cowayBuyerAdminBdgtTempCheck
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/coway_buyer/proxybuy/bdgt/coway_buyer_admin_bdgt_temp_check.jsp
	 */
	@RequestMapping(value = "/mpso/coway_cowayBuyerAdminBdgtTempCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> coway_cowayBuyerAdminBdgtTempCheck(@RequestParam Map<String, String> pMap,
			HttpServletRequest req) {
		// logger.debug("cowayBuyerAdminBdgtTempCheck 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		// logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());

		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		} else {
			LOGGER.debug(pMap.get("st_query_cart"));
		}

		List<Map<String, String>> _data = buyerMpSoCartCowayService.cowayBuyerAdminBdgtTempCheck(pMap);
		// _msgList.addAll(_msg);
		// System.out.println("_data " +_data);
		_response.put("data", _data);
		// System.out.println("_response " +_response);
		return _response;
	}

	// 배송정보
	@RequestMapping(value = "/mpso/getBuyerMpSoDlvryInfoCowayList.do", method = RequestMethod.POST)
	public String getBuyerMpSoDlvryInfoCowayList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		// logger.debug("/mpso/getBuyerMpSoDlvryInfo.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		if (pMap.get("NEW_DOCTOR") == null) {
			pMap.put("st_user_id", _sessionInfo.getUserId());
			pMap.put("st_user_dept", _sessionInfo.getDepartment());
		}
		List<Map<String, String>> _data = buyerMpSoDlvryInfoService.getList(pMap);

		pModel.addAttribute("data", _data);

		return "buyer/mpso/buyerMpSoDlvryInfoCowayList";
	}

	// 조회 예산조회
	@RequestMapping(value = "/mpso/getBuyerMpSoCartBudgetCoway.do", method = RequestMethod.POST)
	public String getBuyerMpSoCartBudgetCoway(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		List<Map<String, String>> _data = buyerMpSoCartCowayService.getBuyerCowayUserBudgetAccountListPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "buyer/mpso/buyerMpSoCartCowayBudgetList";
	}

	@RequestMapping(value = "/mpso/setDeleteTempCart.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setDeleteTempCart(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());

		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		} else {
			LOGGER.debug(pMap.get("st_query_cart"));
		}

		String _data = buyerMpSoCartCowayService.setDeleteTempCart(pMap);
		_response.put("data", _data);
		return _response;
	}

	/**
	 * 공동구매 신청내역
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoGroupPurchaseOrderProgressList.do", method = { RequestMethod.POST,
			RequestMethod.GET })
	public String getBuyerMpSoGroupPurchaseOrderProgressList(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_type", _sessionInfo.getUserType());
		pMap.put("st_user_dept", _sessionInfo.getDepartment());
		String row_cnt = _sessionInfo.getRowCnt();
		String st_unit_part = CommonUtil.onvl(pMap.get("st_unit_part"), "ST_USER_ID");
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow"), row_cnt));
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate"), CommonUtil.addDate(new Date(), "M", -1, 1)));
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate"), CommonUtil.formatDateNoDateGubun(new Date(), 1)));
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no"), ""));
		pMap.put("st_ref_no", CommonUtil.onvl(pMap.get("st_ref_no"), ""));
		pMap.put("st_search_no", CommonUtil.onvl(pMap.get("st_search_no"), ""));
		pMap.put("st_search_type", CommonUtil.onvl(pMap.get("st_search_type"), ""));
		pMap.put("st_status", CommonUtil.onvl(pMap.get("st_status"), "ALL"));
		pMap.put("st_sortType", CommonUtil.onvl(pMap.get("st_sortType"), "DESC"));
		pMap.put("st_unit_part", st_unit_part);
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no"), ""));
		if (!st_unit_part.equals("ALL"))
			if (st_unit_part.equals("ST_USER_ID"))
				pMap.put("st_userid", _sessionInfo.getUserId());
			else
				pMap.put("st_userid", st_unit_part);
		else
			pMap.put("st_userid", _sessionInfo.getUserId());

		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate", _st_from_date);
		pMap.put("toDate", _st_to_date);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getBuyerMpSoGroupPurchaseOrderProgressList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "buyer/mpso/buyerMpSoGroupPurchaseOrderProgressList";
	}

	/**
	 * 품목 신청내역(cl, cs, h, w)
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoClcsOrderProgressList.do", method = { RequestMethod.POST,
			RequestMethod.GET })
	public String getBuyerMpSoClcsOrderProgressList(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("st_user_dept", _sessionInfo.getDepartment());
		String row_cnt = _sessionInfo.getRowCnt();
		String st_unit_part = CommonUtil.onvl(pMap.get("st_unit_part"), "ST_USER_ID");
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow"), row_cnt));
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate"), CommonUtil.addDate(new Date(), "M", -1, 1)));
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate"), CommonUtil.formatDateNoDateGubun(new Date(), 1)));
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no"), ""));
		pMap.put("st_ref_no", CommonUtil.onvl(pMap.get("st_ref_no"), ""));
		pMap.put("st_search_no", CommonUtil.onvl(pMap.get("st_search_no"), ""));
		pMap.put("st_search_type", CommonUtil.onvl(pMap.get("st_search_type"), ""));
		pMap.put("st_status", CommonUtil.onvl(pMap.get("st_status"), "ALL"));
		pMap.put("st_sortType", CommonUtil.onvl(pMap.get("st_sortType"), "DESC"));
		pMap.put("st_unit_part", st_unit_part);
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no"), ""));
		if (!st_unit_part.equals("ALL"))
			if (st_unit_part.equals("ST_USER_ID"))
				pMap.put("st_userid", _sessionInfo.getUserId());
			else
				pMap.put("st_userid", st_unit_part);
		else
			pMap.put("st_userid", _sessionInfo.getUserId());

		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate", _st_from_date);
		pMap.put("toDate", _st_to_date);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getBuyerMpSoClcsOrderProgressList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "buyer/mpso/buyerMpSoClcsOrderProgressList";
	}

	// EXCEL 다운로드
	@RequestMapping(value = "/mpso/excelBuyerMpSoGroupPurchaseOrderProgressList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoOrderProgress(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest req, HttpServletResponse response, OutputStream outputStream) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("st_user_dept", _sessionInfo.getDepartment());
		String row_cnt = _sessionInfo.getRowCnt();
		String st_unit_part = CommonUtil.onvl(pMap.get("st_unit_part"), "ST_USER_ID");
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow"), row_cnt));
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate"), CommonUtil.addDate(new Date(), "M", -1, 1)));
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate"), CommonUtil.formatDateNoDateGubun(new Date(), 1)));
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no"), ""));
		pMap.put("st_ref_no", CommonUtil.onvl(pMap.get("st_ref_no"), ""));
		pMap.put("st_search_no", CommonUtil.onvl(pMap.get("st_search_no"), ""));
		pMap.put("st_search_type", CommonUtil.onvl(pMap.get("st_search_type"), ""));
		pMap.put("st_status", CommonUtil.onvl(pMap.get("st_status"), "ALL"));
		pMap.put("st_sortType", CommonUtil.onvl(pMap.get("st_sortType"), "DESC"));
		pMap.put("st_unit_part", st_unit_part);
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no"), ""));
		if (!st_unit_part.equals("ALL"))
			if (st_unit_part.equals("ST_USER_ID"))
				pMap.put("st_userid", _sessionInfo.getUserId());
			else
				pMap.put("st_userid", st_unit_part);
		else
			pMap.put("st_userid", _sessionInfo.getUserId());

		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate", _st_from_date);
		pMap.put("toDate", _st_to_date);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		// Excel Down을 위한 구분
		pMap.put("paging", "0");

		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getBuyerMpSoGroupPurchaseOrderProgressList(pMap);

		String title = "소속|이름|사번|수량|단가|공급금액|주문일|상품코드|품목명|규격|배송지|전화번호|";
		String headers = "DEPARTMENT_NAME|ADD_USER_NAME|ADD_LEGACY_USER_ID|TARGET_QTY|UNIT_PRICE|ITEM_AMT|ADD_DATE|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|DELY_TO_LOCATION_TEXT|PHONE_NUMBER|";

		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "공동구매신청내역.xls");

	}
	/**
	 * 저장
	 * /kr/customer/shopping_cart/buyer_shoppingcart_qty_update.jsp
	 */
	@RequestMapping(value = "/mpso/delBuyerMpsoCowayCart.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBuyerMpsoCowayCart(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();

		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoOrderProgressService.delBuyerMpsoCowayCart(pMap);
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}

	/**
	 * 판매인등록증 신청내역
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoSellerRegProgressList.do", method = { RequestMethod.POST,
			RequestMethod.GET })
	public String getBuyerMpSoSellerRegProgressList(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_type", _sessionInfo.getUserType());
		pMap.put("st_user_dept", _sessionInfo.getDepartment());
		String row_cnt = _sessionInfo.getRowCnt();
		String st_unit_part = CommonUtil.onvl(pMap.get("st_unit_part"), "ST_USER_ID");
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow"), row_cnt));
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate"), CommonUtil.addDate(new Date(), "M", -1, 1)));
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate"), CommonUtil.formatDateNoDateGubun(new Date(), 1)));
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no"), ""));
		pMap.put("st_ref_no", CommonUtil.onvl(pMap.get("st_ref_no"), ""));
		pMap.put("st_search_no", CommonUtil.onvl(pMap.get("st_search_no"), ""));
		pMap.put("st_search_type", CommonUtil.onvl(pMap.get("st_search_type"), ""));
		pMap.put("st_status", CommonUtil.onvl(pMap.get("st_status"), "ALL"));
		pMap.put("st_sortType", CommonUtil.onvl(pMap.get("st_sortType"), "DESC"));
		pMap.put("st_unit_part", st_unit_part);
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no"), ""));
		if (!st_unit_part.equals("ALL"))
			if (st_unit_part.equals("ST_USER_ID"))
				pMap.put("st_userid", _sessionInfo.getUserId());
			else
				pMap.put("st_userid", st_unit_part);
		else
			pMap.put("st_userid", _sessionInfo.getUserId());

		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate", _st_from_date);
		pMap.put("toDate", _st_to_date);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getBuyerMpSoSellerRegProgressList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "buyer/mpso/buyerMpSoSellerRegProgressList";
	}
	/**
	 * 주문요청 상세조회 조회 PG_06_M_900_01
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoSellerInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoSellerInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getBuyerMpSoSellerInfoPop(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "buyer/mpso/buyerMpSoSellerRegProgressPop";
	}	 
	/**
	 * 저장
	 * /kr/customer/shopping_cart/buyer_shoppingcart_qty_update.jsp
	 */
	@RequestMapping(value = "/mpso/saveBuyerMpSoSellerRegProgressList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpSoSellerRegProgressList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();

		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoOrderProgressService.saveBuyerMpSoSellerRegProgressList(pMap);
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}

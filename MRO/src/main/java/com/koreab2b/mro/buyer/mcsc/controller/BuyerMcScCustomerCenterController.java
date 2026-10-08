package com.koreab2b.mro.buyer.mcsc.controller;

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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.buyer.mcsc.service.BuyerMcScCustomerCenterService;
import com.koreab2b.mro.manager.main.service.MainService;

@Controller("BuyerMcScCustomerCenterController")
public class BuyerMcScCustomerCenterController {

	@Autowired
	private BuyerMcScCustomerCenterService buyerMcScCustomerCenterService;

	@Autowired
	private MainService mainService;

	/**
	 * 고객센터 메인 화면 (부모 페이지 - 탭)
	 */
	@RequestMapping(value = "/mcsc/showBuyerMcScCustomerCenter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMcScCustomerCenter(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		return "buyer/mcsc/buyerMcScCustomerCenter_v2";
	}

	/**
	 * 1:1 문의(VOC) 등록 화면
	 */
	@RequestMapping(value = "/mcsc/showBuyerMcScInquiryWrite.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMcScInquiryWrite(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		// VOC 유형 코드 목록 전달 (ICOMCOD1 TYPE='VC03')
		List<Map<String, String>> qtypeList = buyerMcScCustomerCenterService.getQtypeCodeList(pMap);
		pModel.addAttribute("qtypeList", qtypeList);
		return "buyer/mcsc/buyerMcScInquiryWrite_v2";
	}

	/**
	 * 공지사항 등록/수정 화면 (관리자)
	 */
	@RequestMapping(value = "/mcsc/showBuyerMcScNoticeWrite.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMcScNoticeWrite(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		// 수정 모드: st_bid 파라미터가 있으면 상세 조회
		String bid = pMap.get("st_bid");
		if (bid != null && !"".equals(bid)) {
			pModel.addAttribute("mode", "edit");
			Map<String, String> detail = buyerMcScCustomerCenterService.getNoticeDetail(pMap);
			pModel.addAttribute("detail", detail);
		} else {
			pModel.addAttribute("mode", "write");
		}
		return "buyer/mcsc/buyerMcScNoticeWrite_v2";
	}

	// ========================================
	// JSON API - 공지사항
	// ========================================

	/**
	 * 공지사항 목록 조회 (JSON)
	 * notice_type: COMMON(전체 공지), COMPANY(거래사별)
	 */
	@RequestMapping(value = "/mcsc/getBuyerNoticeListJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerNoticeListJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("st_company", sessionInfo.getComCode());
			pMap.put("st_user_id", sessionInfo.getUserId());

			String noticeType = pMap.get("notice_type");
			List<Map<String, String>> dataList;

			if ("COMMON".equals(noticeType)) {
				dataList = buyerMcScCustomerCenterService.getNoticeListCommon(pMap);
			} else if ("COMPANY".equals(noticeType)) {
				dataList = buyerMcScCustomerCenterService.getNoticeListCompany(pMap);
			} else {
				// 기본: 전체+거래사별 합쳐서 반환
				List<Map<String, String>> commonList = buyerMcScCustomerCenterService.getNoticeListCommon(pMap);
				List<Map<String, String>> companyList = buyerMcScCustomerCenterService.getNoticeListCompany(pMap);
				commonList.addAll(companyList);
				dataList = commonList;
			}

			result.put("success", true);
			result.put("data", dataList);
			result.put("totalCount", dataList != null ? dataList.size() : 0);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 공지사항 상세 조회 (JSON)
	 */
	@RequestMapping(value = "/mcsc/getBuyerNoticeDetailJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerNoticeDetailJson(@RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Map<String, String> detail = buyerMcScCustomerCenterService.getNoticeDetail(pMap);
			result.put("success", true);
			result.put("data", detail);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 공지사항 읽음 처리 (JSON)
	 */
	@RequestMapping(value = "/mcsc/markBuyerNoticeAsRead.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> markBuyerNoticeAsRead(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("comCode", sessionInfo.getComCode());
				pMap.put("userId", sessionInfo.getUserId());
			}
			buyerMcScCustomerCenterService.markNoticeAsRead(pMap);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "읽음 처리 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 공지사항 등록 (JSON, 관리자)
	 */
	@RequestMapping(value = "/mcsc/registerBuyerNoticeJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> registerBuyerNoticeJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("COMPANY", sessionInfo.getComCode());
				pMap.put("REG_USER_ID", sessionInfo.getUserId());
				pMap.put("REG_USER_NAME", sessionInfo.getUserNameLoc());
				pMap.put("REG_DEP", sessionInfo.getDepartment());
				pMap.put("REG_DEP_NAME", sessionInfo.getDepartmentName());
			}
			buyerMcScCustomerCenterService.registerNotice(pMap);
			result.put("success", true);
			result.put("message", "공지사항이 등록되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "등록 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 공지사항 삭제 (JSON, 관리자)
	 */
	@RequestMapping(value = "/mcsc/deleteBuyerNoticeJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteBuyerNoticeJson(@RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			// 다건 삭제 지원 (BID를 콤마로 구분)
			String bidStr = pMap.get("BID");
			if (bidStr != null && bidStr.contains(",")) {
				String[] bids = bidStr.split(",");
				for (String bid : bids) {
					Map<String, String> delMap = new HashMap<String, String>();
					delMap.put("BID", bid.trim());
					delMap.put("BTYPE", pMap.get("BTYPE") != null ? pMap.get("BTYPE") : "NT");
					buyerMcScCustomerCenterService.deleteNotice(delMap);
				}
			} else {
				pMap.put("BTYPE", pMap.get("BTYPE") != null ? pMap.get("BTYPE") : "NT");
				buyerMcScCustomerCenterService.deleteNotice(pMap);
			}
			result.put("success", true);
			result.put("message", "공지사항이 삭제되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "삭제 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	// ========================================
	// JSON API - 1:1 문의
	// ========================================

	/**
	 * VOC 문의 목록 조회 (JSON)
	 */
	@RequestMapping(value = "/mcsc/getBuyerInquiryListJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerInquiryListJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
				pMap.put("st_user_id", sessionInfo.getUserId());
			}
			List<Map<String, String>> dataList = buyerMcScCustomerCenterService.getInquiryList(pMap);
			result.put("success", true);
			result.put("data", dataList);
			result.put("totalCount", dataList != null ? dataList.size() : 0);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * VOC 문의 상세 조회 (JSON)
	 */
	@RequestMapping(value = "/mcsc/getBuyerInquiryDetailJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerInquiryDetailJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
			}
			Map<String, String> data = buyerMcScCustomerCenterService.getInquiryDetail(pMap);
			result.put("success", true);
			result.put("data", data);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의 상세 조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * VOC 유형 코드 조회 (JSON) - ICOMCOD1 TYPE='VC03'
	 */
	@RequestMapping(value = "/mcsc/getBuyerQtypeCodeListJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerQtypeCodeListJson(@RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			List<Map<String, String>> dataList = buyerMcScCustomerCenterService.getQtypeCodeList(pMap);
			result.put("success", true);
			result.put("data", dataList);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의유형 코드 조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * VOC 문의 등록 (JSON) - 기존 mainService.CreateSrReq() 사용
	 */
	@RequestMapping(value = "/mcsc/registerBuyerInquiryJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> registerBuyerInquiryJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("userid", sessionInfo.getUserId());
				pMap.put("buyer", sessionInfo.getComCode());
				pMap.put("tel", sessionInfo.getTel());
				pMap.put("userNameLoc", sessionInfo.getUserNameLoc());
			}
			String vcNo = mainService.CreateSrReq(pMap);
			result.put("success", true);
			result.put("message", "문의가 접수되었습니다. (접수번호: " + vcNo + ")");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의 등록 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * VOC 문의 취소 (JSON) - RECV_FLAG='DC'인 건만 삭제
	 */
	@RequestMapping(value = "/mcsc/cancelBuyerInquiryJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancelBuyerInquiryJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
			}
			int cnt = buyerMcScCustomerCenterService.cancelInquiry(pMap);
			if (cnt > 0) {
				result.put("success", true);
				result.put("message", "문의가 취소되었습니다.");
			} else {
				result.put("success", false);
				result.put("message", "이미 접수된 문의는 취소할 수 없습니다.");
			}
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의 취소 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 1:1 문의 답변 확인 처리 (JSON) - KEPAVCDT.ANSWER_READ_DATE 갱신
	 */
	@RequestMapping(value = "/mcsc/markBuyerInquiryAsRead.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> markBuyerInquiryAsRead(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
				pMap.put("st_user_id", sessionInfo.getUserId());
			}
			buyerMcScCustomerCenterService.markInquiryAsRead(pMap);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "확인 처리 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	// ========================================
	// 내부 공지사항 (BUYERBOARD)
	// ========================================

	/**
	 * 내부 공지사항 등록/수정 화면
	 */
	@RequestMapping(value = "/mcsc/showBuyerMcScInternalNoticeWrite.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMcScInternalNoticeWrite(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		String bid = pMap.get("st_bid");
		if (bid != null && !"".equals(bid)) {
			pModel.addAttribute("mode", "edit");
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_byca_comorg_code", sessionInfo.getBycaComorgCode());
			}
			pMap.put("BID", bid);
			Map<String, String> detail = buyerMcScCustomerCenterService.getInternalNoticeDetail(pMap);
			if (detail != null) {
				detail.remove("CONTEXT"); // CONTEXT는 AJAX로 별도 로드 (대용량 HTML/base64 이미지 대응)
			}
			pModel.addAttribute("detail", detail);
		} else {
			pModel.addAttribute("mode", "write");
		}
		return "buyer/mcsc/buyerMcScInternalNoticeWrite_v2";
	}

	/**
	 * 내부 공지사항 상세 조회 (JSON) - CONTEXT 포함
	 */
	@RequestMapping(value = "/mcsc/getBuyerInternalNoticeDetailJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerInternalNoticeDetailJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_byca_comorg_code", sessionInfo.getBycaComorgCode());
			}
			Map<String, String> detail = buyerMcScCustomerCenterService.getInternalNoticeDetail(pMap);
			result.put("success", true);
			result.put("data", detail);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 내부 공지사항 목록 조회 (JSON)
	 */
	@RequestMapping(value = "/mcsc/getBuyerInternalNoticeListJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerInternalNoticeListJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_byca_comorg_code", sessionInfo.getBycaComorgCode());
				pMap.put("st_company", sessionInfo.getComCode());
				pMap.put("st_user_id", sessionInfo.getUserId());
				String role = sessionInfo.getRole() != null ? sessionInfo.getRole() : "";
				pMap.put("isAdmin", (role.indexOf("A") > -1 || role.indexOf("M") > -1) ? "Y" : "N");
			}
			List<Map<String, String>> dataList = buyerMcScCustomerCenterService.getInternalNoticeList(pMap);
			result.put("success", true);
			result.put("data", dataList);
			result.put("totalCount", dataList != null ? dataList.size() : 0);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "조회 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 내부 공지사항 등록 (JSON, 관리자)
	 */
	@RequestMapping(value = "/mcsc/registerBuyerInternalNoticeJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> registerBuyerInternalNoticeJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("COM_CODE", sessionInfo.getComCode());
				pMap.put("BYCA_COMORG_CODE", sessionInfo.getBycaComorgCode());
				pMap.put("REG_USER_ID", sessionInfo.getUserId());
				pMap.put("REG_DEP", sessionInfo.getDepartment());
				pMap.put("REG_DEP_NAME", sessionInfo.getDepartmentName());
			}
			buyerMcScCustomerCenterService.registerInternalNotice(pMap);
			result.put("success", true);
			result.put("message", "내부 공지사항이 등록되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "등록 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 내부 공지사항 수정 (JSON, 관리자)
	 */
	@RequestMapping(value = "/mcsc/updateBuyerInternalNoticeJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerInternalNoticeJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_byca_comorg_code", sessionInfo.getBycaComorgCode());
			}
			buyerMcScCustomerCenterService.updateInternalNotice(pMap);
			result.put("success", true);
			result.put("message", "내부 공지사항이 수정되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "수정 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 내부 공지사항 읽음 처리 (JSON)
	 */
	@RequestMapping(value = "/mcsc/markBuyerInternalNoticeAsRead.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> markBuyerInternalNoticeAsRead(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("comCode", sessionInfo.getComCode());
				pMap.put("userId", sessionInfo.getUserId());
			}
			buyerMcScCustomerCenterService.markInternalNoticeAsRead(pMap);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "읽음 처리 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

	/**
	 * 내부 공지사항 삭제 (JSON, 관리자)
	 */
	@RequestMapping(value = "/mcsc/deleteBuyerInternalNoticeJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteBuyerInternalNoticeJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_byca_comorg_code", sessionInfo.getBycaComorgCode());
			}
			String bidStr = pMap.get("BID");
			if (bidStr != null && bidStr.contains(",")) {
				String[] bids = bidStr.split(",");
				for (String bid : bids) {
					Map<String, String> delMap = new HashMap<String, String>();
					delMap.put("BID", bid.trim());
					delMap.put("st_byca_comorg_code", pMap.get("st_byca_comorg_code"));
					buyerMcScCustomerCenterService.deleteInternalNotice(delMap);
				}
			} else {
				buyerMcScCustomerCenterService.deleteInternalNotice(pMap);
			}
			result.put("success", true);
			result.put("message", "내부 공지사항이 삭제되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "삭제 중 오류가 발생했습니다: " + e.getMessage());
		}
		return result;
	}

}

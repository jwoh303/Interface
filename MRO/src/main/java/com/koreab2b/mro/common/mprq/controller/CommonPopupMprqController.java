package com.koreab2b.mro.common.mprq.controller;

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

import com.koreab2b.mro.common.coco.service.CommonPopupService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.server.CommonPopupMprqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonPopupMprqController")
public class CommonPopupMprqController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonPopupMprqController.class);

	@Autowired
	private CommonPopupMprqService commonPopupMprqService;
	@Autowired
	private CommonPopupService commonPopupService;
	
	/**
	 * 견적 상세 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/quotationReDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String quotationReDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("quotationReDetailPop 요청 파라미터 for jsp : {}", pMap); 
		Map<String,String> _data1 = commonPopupMprqService.quotationReDetailPopHd(pMap); 
		List<Map<String, String>> _data2 = commonPopupMprqService.quotationReDetailPopDt(pMap); 
		pModel.addAttribute("data1", _data1); 
		pModel.addAttribute("data2", _data2); 
		
		return "common/popup/mprq/quotationReDetailPop";
	}	 

	
	/**
	 * 신규고객사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/newSourcingBuyerList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> newSourcingBuyerList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("newSourcingBuyerList 요청 파라미터 for jsp : {}", pMap); 
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String, String>> _data = commonPopupMprqService.getNewSourcingBuyerList(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}	 

	/**
	 * 신규Nego의뢰 고객사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/newSourcingNegoBuyerList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> newSourcingNegoBuyerList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("newSourcingNegoBuyerList 요청 파라미터 for jsp : {}", pMap); 
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String, String>> _data = commonPopupMprqService.getNewSourcingNegoBuyerList(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}	 
	
	
	/**
	 * 재견적요청협력사선정
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/reAgentSelectPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> reAgentSelectPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("reAgentSelectPop 요청 파라미터 for jsp : {}", pMap); 
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String, String>> _data = commonPopupMprqService.getNewSourcingBuyerList(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 업체선정사유
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBidSucessCodePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBidSucessCodePop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("reAgentSelectPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = commonPopupMprqService.getBidSucessCodePop(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 노마진/역마진 사유
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMarginReSelectPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMarginReSelectPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("reAgentSelectPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = commonPopupMprqService.getMarginReSelectPop(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 협력사선정
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getSellerChoice4Pop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerChoice4Pop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("reAgentSelectPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = commonPopupMprqService.getSellerChoice4Pop(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 폼 조회
	@RequestMapping(value = "/mprq/getSellerChoice4CntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerChoice4CntPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = commonPopupMprqService.getSellerChoice4CntPop(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	/**
	 * 품의서출력
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getPumPrintPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getPumPrintPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("reAgentSelectPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = commonPopupMprqService.getPumPrintPop(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 신규고객사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getQuotationInitList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getQuotationInitList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("newSourcingBuyerList 요청 파라미터 for jsp : {}", pMap); 
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String, String>> _data = commonPopupMprqService.getQuotationInitList(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 제출견적 단가 이력
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getSellerUnitPriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerUnitPriceHistoryPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("quotationReDetailPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupMprqService.getSellerUnitPriceHistoryPop(pMap); 
		pModel.addAttribute("data", _data); 
		
		return "common/popup/mprq/sellerMpRqUnitPriceHistoryPop";
	}	 
	/**
	 * 단가 합의 및 Nego 요청
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMprqNegoViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMprqNegoViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("quotationReDetailPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupMprqService.getNegoview(pMap); 
		pModel.addAttribute("data", _data); 
		
		return "common/popup/mprq/buyerMpRqNegoViewPop";
	}	 
	
	// 단가합의
	@RequestMapping(value = "/mprq/saveScmRemark.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveScmRemark(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : {}", pMap);
		String rtnMsg = commonPopupMprqService.saveScmRemark(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/**
	 * SG선택
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqSgChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpRqSgChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		pMap.put("onepagerow", CommonUtil.nvl(pMap.get("onepagerow"), "10")); 
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String, String>> _data = commonPopupMprqService.getMasterMpRqSgChoicePop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mprq/masterMpRqSgChoicePop";
	}
	
	/**
	 * 단가 합의 및 Nego 요청(삼양사)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMprqSamyangNegoViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMprqSamyangNegoViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("quotationReDetailPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupMprqService.getSamyangNegoview(pMap); 
		pModel.addAttribute("data", _data); 
		
		return "common/popup/mprq/buyerMpRqSamyangNegoViewPop";
	}
	
	/**
	 * 고객사제출비고 팝업(ICOMCOD2.TYPE=ASRMGD 포함)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/remarkAtoB2Pop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String remarkAtoB2Pop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("remarkAtoB2Pop 요청 파라미터 for jsp : {}", pMap); 
		Map<String,String> _data = commonPopupMprqService.getRemarkAtoB2PopHd(pMap); 
		pModel.addAttribute("data", _data); 
		
		return "common/popup/mprq/remarkAtoB2Pop";
	}
	
	/**
	 * 제출견적 단가 이력 - 리뉴얼
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getSellerMpRqUnitPriceHistoryPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpRqUnitPriceHistoryPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("newSourcingBuyerList 요청 파라미터 for jsp : {}", pMap); 
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String, String>> _data = commonPopupMprqService.getSellerMpRqUnitPriceHistoryPop_v2(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}	 
	
	/**
	 * 견적상세팝업 - 리뉴얼
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getSellerMpRqQuotaDetailPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpRqQuotaDetailPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getSellerMpRqQuotaDetailPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = commonPopupMprqService.getSellerMpRqQuotaDetailPop_v2(pMap); 
		
//		if(_data.get(0).get("AGENT_SOURCING_STATUS").equals("재견적요청")){ //재견적요청인 경우
//			pMap.put("re_flag", "Y");
//			try {
//				int tempAgentRevision = Integer.parseInt(pMap.get("st_agent_revision"));
//				tempAgentRevision = tempAgentRevision - 1; //그 전 값을 가져오도록
//				pMap.put("st_agent_revision_re", String.valueOf(tempAgentRevision));
//				
//				_data = commonPopupMprqService.getSellerMpRqQuotaDetailPop_v2(pMap);
//			} catch (Exception e) {
//				
//			}
//			
//		}else{
//			pMap.put("re_flag", "N");
//		}
		
		pModel.addAttribute("data", _data);
		
//		if(pMap.get("re_flag").equals("Y")){ //재견적요청인 경우 첨부파일 가져가야함
//			if(_data.get(0).get("SELLER_IMAGE_KEY") != null){
//				pMap.put("docNo", _data.get(0).get("SELLER_IMAGE_KEY"));
//				List<Map<String, String>> fileData = commonPopupMprqService.getSellerMpRqFile_v2(pMap);
//				pModel.addAttribute("fileData", fileData);
//			}
//		}
		//납품지역 리스트
		pMap.put("st_com_code", pMap.get("st_buyer"));
		List<Map<String, String>> sellerArea = commonPopupService.getDeliAreaList(pMap);
		pModel.addAttribute("sellerArea", CommonUtil.getListNvl(sellerArea));
		
		return "common/popup/mprq/sellerMpRqQuotaDetailPop_v2";
	}
	/**
	 * 일괄등록 - 리뉴얼
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mprq/getSellerMpRqQuotMultiPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpRqQuotMultiPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		return "common/popup/mprq/sellerMpRqQuotMultiPop_v2";
	}
	
	@RequestMapping(value = "/mprq/quotUserInfoDisplayPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String quotUserInfoDisplayPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, String> _data =commonPopupService.kepManagerPop(pMap);
		pModel.addAttribute("data",_data); 
		
		return "common/popup/mprq/quotUserInfoDisplayPop_v2";
	}
	
	/**
	 * 프로젝트 견적 일괄등록 - 리뉴얼
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mprq/getSellerMpRqBulkQuotMultiPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpRqBulkQuotMultiPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		return "common/popup/mprq/sellerMpRqBulkQuotMultiPop_v2";
	}
	
}

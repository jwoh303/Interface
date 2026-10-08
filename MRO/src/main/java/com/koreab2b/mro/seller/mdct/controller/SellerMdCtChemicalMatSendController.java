package com.koreab2b.mro.seller.mdct.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mdct.service.SellerMdCtChemicalMatSendService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtChemicalMatSendController")
public class SellerMdCtChemicalMatSendController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(SellerMdCtChemicalMatSendController.class);

	@Autowired
	private SellerMdCtChemicalMatSendService sellerMdCtChemicalMatSendService;

	@Autowired
	private CommonInfoService commonInfoService;
	
	// 조회
	@RequestMapping(value = "/mdct/getSellerMdCtChemicalMatSendList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMdCtChemicalMatSendList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMdCtChemicalMatSendList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMdCtChemicalMatSendService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장
	@RequestMapping(value = "/mdct/saveSellerMdCtChemicalMatSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMdCtChemicalMatSendList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("saveSellerMdCtChemicalMatSendList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("saveSellerMdCtChemicalMatSendList 요청 파라미터 : formData {}", formData);
		String rtnMsg = sellerMdCtChemicalMatSendService.updateSelectedData(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 물질정보 상세 팝업 조성정보 조회
	@RequestMapping(value = "/mdct/getSellerMdCtChemicalMatRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMdCtChemicalMatRegPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMdCtChemicalMatSendService.getSellerMdCtChemicalMatRegPop(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 물질정보 상세 팝업 조성정보 조회
	@RequestMapping(value = "/mdct/getSellerMdCtChemicalMatRegPopHd.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtNewCustomerManageDetailList(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_id", _sessionInfo.getUserId());
		LOGGER.debug("getSellerMdCtChemicalMatRegPop 요청 파라미터 : {}", pMap);		
		List<Map<String, String>> _data = sellerMdCtChemicalMatSendService.getSellerMdCtChemicalMatRegPopHd(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdct/sellerMdCtChemicalMatRegPop";
	}
	// 물질정보 오분류
	@RequestMapping(value = "/mdct/returnSellerMdCtChemicalMatSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> returnSellerMdCtChemicalMatSendList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("returnSellerMdCtChemicalMatSendList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("returnSellerMdCtChemicalMatSendList 요청 파라미터 : formData {}", formData);
		String rtnMsg = sellerMdCtChemicalMatSendService.returnSellerMdCtChemicalMatSendList(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 발주 후 제출(협력사)
	@RequestMapping(value = "/mdct/afterSellerMdCtChemicalMatSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> afterSellerMdCtChemicalMatSendList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("afterSellerMdCtChemicalMatSendList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("afterSellerMdCtChemicalMatSendList 요청 파라미터 : formData {}", formData);
		String rtnMsg = sellerMdCtChemicalMatSendService.afterSellerMdCtChemicalMatSendList(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);

		return _response;
	}

	/**
	 * 물질정보 상세 팝업 헤더 조회 - 리뉴얼 화면용 JSON API
	 * 기존 getMasterMdCtNewCustomerManageDetailList()의 JSON 응답 버전
	 * 레거시 JSP 화면에는 영향 없음
	 */
	@RequestMapping(value = "/mdct/getSellerMdCtChemicalMatRegPopHdV2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMdCtChemicalMatRegPopHdV2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getSellerMdCtChemicalMatRegPopHdV2 요청 파라미터 : {}", pMap);

		// 세션 정보 추가
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_id", _sessionInfo.getUserId());

		// 기존 Service 로직 재사용
		List<Map<String, String>> _data = sellerMdCtChemicalMatSendService.getSellerMdCtChemicalMatRegPopHd(pMap);

		// JSON 응답 구성
		Map<String, Object> response = new HashMap<String, Object>();

		if (_data != null && _data.size() > 0) {
			Map<String, String> rowData = _data.get(0);

			// 견적정보 기반 조건 계산
			String quotationNo = CommonUtil.nvl(pMap.get("st_quotation_no"), "");
			String sg118Yn = CommonUtil.nvl(rowData.get("SG118_YN"), "");
			String buyer = CommonUtil.nvl(rowData.get("BUYER"), "");

			// p070000033 체크 (보관조건 필수 대상 고객사)
			String p070000033 = "";
			Map<String, String> p070000033Map = CommonUtil.getSpecialCheckReturnMap(buyer, "P07-0000033");
			if (p070000033Map != null) {
				p070000033 = CommonUtil.nvl(p070000033Map.get("COL01_DATA"), "");
			}

			// 조건 객체 생성
			// 주의: QUOTATION_NO가 있으면 "견적 단계", 없으면 "발주 단계"
			// - 견적 단계 (QUOTATION_NO 있음): 보관조건 숨김
			// - 발주 단계 (QUOTATION_NO 없음): 보관조건 표시
			Map<String, Object> conditions = new HashMap<String, Object>();
			conditions.put("hasQuotation", !quotationNo.isEmpty());
			conditions.put("showStorageCondition", "Y".equals(sg118Yn) && quotationNo.isEmpty());
			conditions.put("showAfterOrderButton", !quotationNo.isEmpty());
			conditions.put("requireStorageValidation", "Y".equals(sg118Yn) && !p070000033.isEmpty() && quotationNo.isEmpty());

			// 🆕 첨부파일 목록 조회 (MSDS_NO_FILEKEY가 있을 경우에만)
			String fileKey = CommonUtil.nvl(rowData.get("MSDS_NO_FILEKEY"), "");
			List<Map<String, String>> fileList = new ArrayList<Map<String, String>>();

			if (!fileKey.isEmpty()) {
				try {
					// 파일 조회 파라미터 설정
					Map<String, String> fileParams = new HashMap<String, String>();
					fileParams.put("DOC_NO", fileKey);
					fileParams.put("TYPE", "MSDS");
					fileParams.put("IMG_YN", "N");

					// CommonInfoService를 통해 파일 목록 조회
					fileList = commonInfoService.getFileUploadList(fileParams);

					LOGGER.debug("getSellerMdCtChemicalMatRegPopHdV2 첨부파일 조회 성공 - fileKey: {}, 파일 개수: {}", fileKey, fileList.size());
				} catch (Exception e) {
					// 파일 조회 실패 시에도 MSDS 데이터는 반환 (files는 빈 배열)
					LOGGER.error("getSellerMdCtChemicalMatRegPopHdV2 첨부파일 조회 실패 - fileKey: {}", fileKey, e);
				}
			}

			response.put("success", true);
			response.put("data", rowData);
			response.put("conditions", conditions);
			response.put("files", fileList); // 첨부파일 목록 추가 (빈 배열 또는 파일 목록)
		} else {
			response.put("success", false);
			response.put("message", "데이터를 찾을 수 없습니다.");
		}

		return response;
	}

	/**
	 * 리뉴얼: MSDS 물질정보 제출 (JSON 기반)
	 * @param req HttpServletRequest
	 * @param pMap 요청 파라미터 (JSON)
	 * @return 저장 결과
	 */
	@RequestMapping(value = "/mdct/saveSellerMdCtChemicalMatSendListV2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMdCtChemicalMatSendListV2(HttpServletRequest req, @RequestBody Map<String, String> pMap) {
		LOGGER.debug("saveSellerMdCtChemicalMatSendListV2 요청 파라미터 : {}", pMap);

		Map<String, Object> response = new HashMap<String, Object>();

		try {
			// 세션 정보 추가
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("st_session_id", _sessionInfo.getUserId());
			pMap.put("USER_ID", _sessionInfo.getUserId());

			// gridData는 빈 리스트로 전달 (V2 API는 formData만 사용)
			List<Object> emptyGridData = new java.util.ArrayList<Object>();

			// 미대상품목 여부 확인 (st_kep_note가 있으면 미대상품목)
			String kepNoteValue = CommonUtil.nvl(pMap.get("st_kep_note"), "");
			boolean isNonTargetItem = !kepNoteValue.isEmpty();

			// 발주 후 제출 여부 확인
			String afterOrderFlag = CommonUtil.nvl(pMap.get("st_after_order"), "");
			boolean isAfterOrderSubmit = "Y".equals(afterOrderFlag);

			String rtnMsg = "";

			if (isNonTargetItem) {
				// 미대상품목: returnSellerMdCtChemicalMatSendListV2 호출 (REQ_STATUS = 'P' - 오분류)
				LOGGER.debug("미대상품목 처리 - returnSellerMdCtChemicalMatSendListV2 호출");
				rtnMsg = sellerMdCtChemicalMatSendService.returnSellerMdCtChemicalMatSendListV2(pMap, emptyGridData);
			} else if (isAfterOrderSubmit) {
				// 발주 후 제출: afterSellerMdCtChemicalMatSendListV2 호출 (REQ_STATUS = 'A' - 발주 후 제출)
				LOGGER.debug("발주 후 제출 처리 - afterSellerMdCtChemicalMatSendListV2 호출");
				rtnMsg = sellerMdCtChemicalMatSendService.afterSellerMdCtChemicalMatSendListV2(pMap, emptyGridData);
			} else {
				// 정상 제출: updateSelectedDataV2 호출 (REQ_STATUS = 'S' - 제출완료)
				LOGGER.debug("정상 제출 처리 - updateSelectedDataV2 호출");
				rtnMsg = sellerMdCtChemicalMatSendService.updateSelectedDataV2(pMap, emptyGridData);
			}

			response.put("success", true);
			response.put("message", rtnMsg);
			response.put("code", 1);

		} catch (Exception e) {
			LOGGER.error("saveSellerMdCtChemicalMatSendListV2 오류 발생", e);
			response.put("success", false);
			response.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
			response.put("code", 0);
		}

		return response;
	}
}

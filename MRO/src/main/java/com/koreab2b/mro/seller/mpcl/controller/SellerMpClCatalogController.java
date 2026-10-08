package com.koreab2b.mro.seller.mpcl.controller;

import java.io.OutputStream;
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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mpcl.service.SellerMpClCatalogService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClCatalogController")
public class SellerMpClCatalogController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpClCatalogController.class);

	@Autowired
	private SellerMpClCatalogService sellerMpClCatalogService;
	
	// 조회
	@RequestMapping(value = "/mpcl/getSellerMpClCatalogList.do", method = RequestMethod.POST)
	public String getSellerMpClCatalogList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpClCatalogService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpcl/sellerMpClCatalogList";
	}
	
	// 재고등록
	@RequestMapping(value = "/mpcl/saveSellerMpClCatalogList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpClCatalog(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = sellerMpClCatalogService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpcl/excelSellerMpClCatalogList.do", method = RequestMethod.POST)
	public void excelBuyerMpPoOrderReqReceiptList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		
		List<Map<String, String>> _data = sellerMpClCatalogService.getExcelList(pMap);  
		
		String title = "카탈로그관리명|고객사명|고객사품목코드|품목명|규격|단위|계약단가|제조사|제조사NO|원산지|등록일|수정일|판매사제품코드|카탈로그관리코드|BUYER|BELOW_COMORG_CODE|계약서번호|계약서항번|";
		String headers = "COMORG_NAME|BUYER_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|LIST_PRICE|MAKER_NAME|MAKER_PART_NO|ORIGIN_NAME|ADD_DATE|CHANGE_DATE|SELLER_ITEM_NO|COMORG_CODE|BUYER|BELOW_COMORG_CODE|CONTRACT_NO|CONTRACT_SEQ|";
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"카탈로그조회목록.xls");
		 
	}
	/**
	 * saveSellerMpClCatalogImg
	 * 
	 * @param pMap
	 * @return
	 * 
	 */
	@RequestMapping(value = "/mpcl/saveSellerMpClCatalogImg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpClCatalogImg(@ModelAttribute("uploadForm") FileUploadForm uploadForm, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
	
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("agentUserid", _sessionInfo.getUserId());
		pMap.put("agentComCode", _sessionInfo.getComCode());

		String msg = sellerMpClCatalogService.saveSellerMpClCatalogImg(uploadForm,pMap);
		_response.put("msg", msg);

		return _response;
	}
	/**
	 * 이미지 첨부
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpcl/saveSellerMpClCatalogImgFile.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String saveSellerMpClCatalogImgFile(HttpServletRequest req,
												ModelMap pModel,
												@ModelAttribute("uploadForm") FileUploadForm uploadForm,
												@RequestParam Map<String, String> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("agentUserid", _sessionInfo.getUserId());
		pMap.put("agentComCode", _sessionInfo.getComCode());
		String msg = sellerMpClCatalogService.saveSellerMpClCatalogImgFile(uploadForm,pMap);
		pModel.addAttribute("msg", msg);
		return  "seller/mpcl/sellerMpClCatalogResult";
	}

	/**
	 * 이미지 첨부 (리뉴얼 v2 - JSON 응답)
	 * @param req HttpServletRequest
	 * @param uploadForm 업로드 폼
	 * @param pMap 파라미터
	 * @return JSON 응답 (파일 경로 정보)
	 */
	@RequestMapping(value = "/mpcl/saveSellerMpClCatalogImgFile_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpClCatalogImgFileV2(HttpServletRequest req,
												@ModelAttribute("uploadForm") FileUploadForm uploadForm,
												@RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("agentUserid", _sessionInfo.getUserId());
		pMap.put("agentComCode", _sessionInfo.getComCode());

		String msg = sellerMpClCatalogService.saveSellerMpClCatalogImgFile(uploadForm,pMap);
		_response.put("msg", msg);

		return _response;
	}
	/**
	 * 이미지 상세 첨부 (레거시)
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpcl/saveSellerMpClCatalogDetailImgFile.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String saveSellerMpClCatalogDetailImgFile(HttpServletRequest req,
											ModelMap pModel,
											@ModelAttribute("uploadForm") FileUploadForm uploadForm,
											@RequestParam Map<String, String> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("agentUserid", _sessionInfo.getUserId());
		pMap.put("agentComCode", _sessionInfo.getComCode());
		String msg = sellerMpClCatalogService.saveSellerMpClCatalogDetailImgFile(uploadForm,pMap);
		pModel.addAttribute("msg", msg);
		return  "seller/mpcl/sellerMpClCatalogResult";
	}

	/**
	 * 상세이미지 첨부 (리뉴얼 v2 - JSON 응답)
	 * @param req HttpServletRequest
	 * @param uploadForm 업로드 폼
	 * @param pMap 파라미터
	 * @return JSON 응답 (파일 경로 정보)
	 */
	@RequestMapping(value = "/mpcl/saveSellerMpClCatalogDetailImgFile_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpClCatalogDetailImgFileV2(HttpServletRequest req,
												@ModelAttribute("uploadForm") FileUploadForm uploadForm,
												@RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("agentUserid", _sessionInfo.getUserId());
		pMap.put("agentComCode", _sessionInfo.getComCode());

		String msg = sellerMpClCatalogService.saveSellerMpClCatalogDetailImgFile(uploadForm,pMap);
		_response.put("msg", msg);

		return _response;
	}
	/**
	 * 이미지등록 요청 리스트
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpcl/getSellerMpClCatalogImgPopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpClCatalogImgPopList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		// 수주접수 상세정보 조회
		List<Map<String, String>> detailList = sellerMpClCatalogService.getSellerMpClCatalogImgPopList(pMap);
		pModel.addAttribute("detailList", CommonUtil.getListNvl(detailList));

		return "common/popup/mpcl/sellerMpClCatalogImgPopList";
	}

	/**
	 * 거래품목 조회 (리뉴얼 - v2)
	 * - 페이징 지원 (무한 스크롤)
	 * - IBSheetResponseUtil 사용
	 * - 새로운 검색 조건 (imageStatus, origin, manufacturer, itemName, specification)
	 *
	 * @param req HttpServletRequest (세션 정보 추출용)
	 * @param pMap 검색 파라미터 (buyerCode, imageStatus, origin, manufacturer, itemName, specification, pageIndex, pageSize)
	 * @return IBSheet DoSearch 표준 JSON 응답 (Data, Total 포함)
	 */
	@RequestMapping(value = "/mpcl/getSellerMpClCatalogListData_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMpClCatalogListDataV2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		try {
			// 세션 정보 추출 (리뉴얼)
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("st_com_code", _sessionInfo.getComCode());
			pMap.put("st_user_id", _sessionInfo.getUserId());

			List<Map<String, String>> data;
			int totalCount = 0;

			// 페이징 파라미터 확인 (무한 스크롤)
			String pageIndexStr = pMap.get("pageIndex");
			String pageSizeStr = pMap.get("pageSize");

			if (pageIndexStr != null && !pageIndexStr.isEmpty() && pageSizeStr != null && !pageSizeStr.isEmpty()) {
				// 페이징 모드 (무한 스크롤)
				int pageIndex = Integer.parseInt(pageIndexStr);
				int pageSize = Integer.parseInt(pageSizeStr);
				int startRow = (pageIndex - 1) * pageSize;
				int endRow = pageIndex * pageSize;

				pMap.put("startRow", String.valueOf(startRow));
				pMap.put("endRow", String.valueOf(endRow));

				// 페이징 서비스 호출
				data = sellerMpClCatalogService.getListV2Paging(pMap);
				totalCount = sellerMpClCatalogService.getListV2Count(pMap);
			} else {
				// 기존 모드 (전체 조회)
				data = sellerMpClCatalogService.getListV2(pMap);
				totalCount = data.size();
			}

			// 이미지 URL 생성 로직 추가 (리뉴얼 - 상품이미지/상세이미지)
			for (Map<String, String> item : data) {
				// PRODUCT_IMAGE URL 생성
				String imgDir = CommonUtil.nvl(item.get("IMGFILE_DIR"));
				String imgName = CommonUtil.nvl(item.get("IMGFILE_NAME"));
				if (!"".equals(imgDir) && !"".equals(imgName)) {
					item.put("PRODUCT_IMAGE", CommonUtil.realImgS3UploadPath + "/" + imgDir + "/" + imgName);
				} else {
					item.put("PRODUCT_IMAGE", "/resources/images/noimage.gif");
				}

				// DETAIL_IMAGE URL 생성
				String detailImgDir = CommonUtil.nvl(item.get("DETAIL_IMGFILE_DIR"));
				String detailImgName = CommonUtil.nvl(item.get("DETAIL_IMGFILE_NAME"));
				if (!"".equals(detailImgDir) && !"".equals(detailImgName)) {
					item.put("DETAIL_IMAGE", CommonUtil.realImgS3UploadPath + "/" + detailImgDir + "/" + detailImgName);
				} else {
					item.put("DETAIL_IMAGE", "/resources/images/noimage.gif");
				}
			}

			// IBSheetResponseUtil로 표준 응답 생성 (리뉴얼) + Total 추가
			Map<String, Object> response = IBSheetResponseUtil.createSuccessResponse(data, "거래품목 조회가 완료되었습니다.");
			response.put("Total", totalCount);
			return response;

		} catch (Exception e) {
			// 에러 로깅 (리뉴얼)
			logger.error("[리뉴얼] 거래품목 조회 v2 에러: ", e);

			// 에러 응답 생성 (리뉴얼)
			return IBSheetResponseUtil.createErrorResponse("거래품목 조회 중 오류가 발생했습니다.");
		}
	}
}

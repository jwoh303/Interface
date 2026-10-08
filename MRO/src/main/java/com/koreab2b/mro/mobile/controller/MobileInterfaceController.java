package com.koreab2b.mro.mobile.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.koreab2b.mro.common.coco.controller.CommonMdCmBasePriceApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonMdCmBuyPriceApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonMdCmStndApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonNgNsRcPaApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonPrPxApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonWmReApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonReportApprovalController;
import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.mpiv.controller.SellerMpIvObtnodrReceiptDetailPopController;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.manager.login.service.LoginService;
import com.koreab2b.mro.seller.mpiv.controller.SellerMpIvDeliveryRecordRegController;
import com.koreab2b.mro.seller.mprq.controller.SellerMpRqEstiReqController;
import com.koreab2b.mro.util.CommonUtil;

@Controller("mobileInterfaceController")
public class MobileInterfaceController {
	private static final Logger logger = LoggerFactory.getLogger(MobileInterfaceController.class);

	int maxSizeFile = (10) * 1024 * 1024;
	int factorySizeThreshold = (10) * 1024 * 1024;

	@Autowired
	private LoginService loginService;

	@Autowired
	CommonNgNsRcPaApprovalController commonNgNsRcPaApprovalController;
	@Autowired
	CommonMdCmStndApprovalController commonMdCmStndApprovalController;
	@Autowired
	CommonWmReApprovalController commonWmReApprovalController;
	@Autowired
	CommonPrPxApprovalController commonPrPxApprovalController;
	@Autowired
	CommonReportApprovalController commonReportApprovalController;
	@Autowired
	CommonMdCmBasePriceApprovalController commonMdCmBasePriceApprovalController;
	@Autowired
	CommonMdCmBuyPriceApprovalController commonMdCmBuyPriceApprovalController;
	
	@Autowired
	SellerMpIvObtnodrReceiptDetailPopController sellerMpIvObtnodrReceiptDetailPopController;

	@Autowired
	SellerMpRqEstiReqController sellerMpRqEstiReqController;

	@Autowired
	SellerMpIvDeliveryRecordRegController sellerMpIvDeliveryRecordRegController;

	@Autowired
	CommonInfoService commonInfoService;

	/**
	 * 모바일 서버에서 transaction 처리 호출 인터페이스
	 */
	@RequestMapping(value = "/mobile/callMobileInterface.do", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> callMobileInterface(@RequestParam HashMap<String, Object> ifParamMap, ModelMap model,
			HttpServletRequest req, HttpServletRequest res) throws Exception {
		System.out.println("callMobileInterface!!!!");
		String userId = (String) ifParamMap.get("userId");
		// String passowrd = (String) ifParamMap.get("password");
		String callUrl = (String) ifParamMap.get("callUrl");
		String jsonData = (String) ifParamMap.get("jsonData");
		logger.debug("*** mobile interface Call!!!!!");
		logger.debug("*** userId : " + userId);
		logger.debug("*** callUrl : " + callUrl);
		logger.debug("*** jsonData : " + jsonData);
		ObjectMapper objectMapper = new ObjectMapper();
		@SuppressWarnings("unchecked")
		Map<String, String> param = objectMapper.readValue(jsonData, HashMap.class);
		logger.debug("*** param : " + param);

		HttpSession _session = req.getSession(true);
		SessionInfo _sessionInfo = loginService.getSessionInfo(userId);
		_session.setAttribute("sessionInfo", _sessionInfo);
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo);
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/**
		 * 3. URL에 따라 해당하는 컨트롤러 요청
		 */
		if (callUrl.startsWith("/common/approval/NgNsRcPaCommonApproval.do")) {
			/**
			 * 결재 승인
			 */
			logger.debug("commonNgNsRcPaApprovalController.commonApproval call!!!!");
			rtnMap = commonNgNsRcPaApprovalController.commonApproval(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/NgNsRcPaCommonCancel.do")) {
			/**
			 * 결재 반려
			 */
			logger.debug("commonNgNsRcPaApprovalController.commonCancel call!!!!");
			rtnMap = commonNgNsRcPaApprovalController.commonCancel(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/PrPxCommonApproval.do")) {
			/**
			 * 결재 승인
			 */
			logger.debug("commonPrPxApprovalController.commonApproval call!!!!");
			rtnMap = commonPrPxApprovalController.commonApproval(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/PrPxCommonCancel.do")) {
			/**
			 * 결재 반려
			 */
			logger.debug("commonPrPxApprovalController.commonCancel call!!!!");
			rtnMap = commonPrPxApprovalController.commonCancel(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/MdCmStndCommonApproval.do")) {
			/**
			 * 표준카탈로그 결재 승인
			 */
			logger.debug(" commonMdCmStndApprovalController.commonApproval call!!!!");
			rtnMap = commonMdCmStndApprovalController.commonApproval(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/MdCmStndCommonCancel.do")) {
			/**
			 * 표준카탈로그 결재 반려
			 */
			logger.debug("commonMdCmStndApprovalController.commonCancel call!!!!");
			rtnMap = commonMdCmStndApprovalController.commonCancel(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/MdCmBasePriceCommonApproval.do")) {
			/**
			 * 표준DB 기준가 인하 결재 승인 (BP 단건 / BPM 일괄)
			 */
			logger.debug(" commonMdCmBasePriceApprovalController.commonApproval call!!!!");
			rtnMap = commonMdCmBasePriceApprovalController.commonApproval(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/MdCmBasePriceCommonCancel.do")) {
			/**
			 * 표준DB 기준가 인하 결재 반려 (BP 단건 / BPM 일괄)
			 */
			logger.debug("commonMdCmBasePriceApprovalController.commonCancel call!!!!");
			rtnMap = commonMdCmBasePriceApprovalController.commonCancel(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/MdCmBuyPriceCommonApproval.do")) {
			/**
			 * 표준DB 매입단가 인상 결재 승인 (SP 단건 / SPM 일괄)
			 */
			logger.debug(" commonMdCmBuyPriceApprovalController.commonApproval call!!!!");
			rtnMap = commonMdCmBuyPriceApprovalController.commonApproval(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/MdCmBuyPriceCommonCancel.do")) {
			/**
			 * 표준DB 매입단가 인상 결재 반려 (SP 단건 / SPM 일괄)
			 */
			logger.debug("commonMdCmBuyPriceApprovalController.commonCancel call!!!!");
			rtnMap = commonMdCmBuyPriceApprovalController.commonCancel(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/WmReCommonApproval.do")) {
			/**
			 * 
			 *  반품 결재 승인
			 */
			logger.debug(" commonWmReApprovalController.commonApproval call!!!!");
			rtnMap = commonWmReApprovalController.commonApproval(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/WmReCommonCancel.do")) {
			/**
			 * 반품 결재 반려
			 */
			logger.debug("commonWmReApprovalController.commonCancel call!!!!");
			rtnMap = commonWmReApprovalController.commonCancel(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do")) {
			logger.debug("saveSellerMpIvObtnodrReceiptDetailPop call!!!!");
			@SuppressWarnings("unchecked")
			Map<String, Object> obtrParam = objectMapper.readValue(jsonData, HashMap.class);
			logger.debug("*** param : " + obtrParam);
			/**
			 * 수주 접수
			 */

			// List paramList = objectMapper.readValue(param.get("LIST"), List.class);
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> paramList = (ArrayList<Map<String, Object>>) obtrParam.get("list");
			MultiValueMap<String, String> paramMap = covertListToMultiValueMap(paramList);
			paramMap.add("s_SAVENAME", String.valueOf(obtrParam.get("s_SAVENAME")));
			rtnMap = sellerMpIvObtnodrReceiptDetailPopController.saveSellerMpIvObtnodrReceiptDetailPop(model, req,
					paramMap);
			rtnMap.put("status", "true");
			
			
			
			
		} else if (callUrl.startsWith("/common/approval/ReportCommonApproval.do")) {
			/**
			 * 
			 *  리포트 승인(TEST)
			 */
			logger.debug(" commonReportApprovalController.commonApproval call!!!!");
			rtnMap = commonReportApprovalController.commonApproval(model, param, req);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/common/approval/ReportCommonCancel.do")) {
			/**
			 * 리포트 반려(TEST)
			 */
			logger.debug("commonReportApprovalController.commonCancel call!!!!");
			rtnMap = commonReportApprovalController.commonCancel(model, param, req);
			rtnMap.put("status", "true");
			
			
			
			
			
		} else if (callUrl.startsWith("/mprq/sellerMpRqEstiReqAgentHandout.do")) {
			/**
			 * 협력사 견적 제출
			 */
			@SuppressWarnings("unchecked")
			Map<String, Object> obtrParam = objectMapper.readValue(jsonData, HashMap.class);
			logger.debug("*** param : " + obtrParam);
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> paramList = (ArrayList<Map<String, Object>>) obtrParam.get("list");
			MultiValueMap<String, String> paramMap = covertListToMultiValueMap(paramList);
			paramMap.add("s_SAVENAME", String.valueOf(obtrParam.get("s_SAVENAME")));
			rtnMap = sellerMpRqEstiReqController.sellerMpRqEstiReqAgentHandout(model, req, paramMap);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/mprq/sellerMpRqEstiReqGiveUp.do")) {
			/**
			 * 협력사 견적 포기
			 */
			@SuppressWarnings("unchecked")
			Map<String, Object> obtrParam = objectMapper.readValue(jsonData, HashMap.class);
			logger.debug("*** param : " + obtrParam);
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> paramList = (ArrayList<Map<String, Object>>) obtrParam.get("list");
			MultiValueMap<String, String> paramMap = covertListToMultiValueMap(paramList);
			paramMap.add("s_SAVENAME", String.valueOf(obtrParam.get("s_SAVENAME")));
			rtnMap = sellerMpRqEstiReqController.sellerMpRqEstiReqGiveUp(model, req, paramMap);
			rtnMap.put("status", "true");
		} else if (callUrl.startsWith("/mpiv/saveSellerMpIvDeliveryRecordRegList.do")) {
			logger.debug("모바일 > 협력사 > 납품실적등록!");
			/**
			 * 협력사 > 납품실적 > 등록
			 */
			rtnMap = sellerMpIvDeliveryRecordRegController.updateSellerMpIvDeliveryRecordReg(model, param);
			rtnMap.put("status", "true");
		} else {
			rtnMap.put("status", "false");
		}
		return rtnMap;
	}

	/**
	 * 모바일 서버에서 transaction 처리 호출 인터페이스
	 */
	@RequestMapping(value = "/mobile/callFileInterface.do", method = { RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> callFileInterface(MultipartHttpServletRequest req, HttpServletRequest res)
			throws Exception {
		System.out.println("callMobileInterface!!!!");
		String userId = (String) req.getParameter("userId");
		String jsonData = (String) req.getParameter("jsonData");
		logger.debug("*** mobile interface Call!!!!!");
		logger.debug("*** userId : " + userId);
		logger.debug("*** jsonData : " + jsonData);
		ObjectMapper objectMapper = new ObjectMapper();
		@SuppressWarnings("unchecked")
		Map<String, String> param = objectMapper.readValue(jsonData, HashMap.class);
		logger.debug("*** param : " + param);
		HttpSession _session = req.getSession(true);
		SessionInfo _sessionInfo = loginService.getSessionInfo(userId);
		_session.setAttribute("sessionInfo", _sessionInfo);
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo);
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());
		Map<String, Object> rtnMap = null;
		final Map<String, MultipartFile> files = req.getFileMap();
		logger.debug("files : " + files);
		logger.debug("files : " + files.size());
		FileUploadForm uploadForm = new FileUploadForm();
		List<MultipartFile> fileList = new ArrayList<MultipartFile>();
		fileList.add(files.get("file"));
		uploadForm.setFiles(fileList);
		param.put("COM_CODE", _sessionInfo.getComCode());
		param.put("USER_ID", _sessionInfo.getUserId());
		param.put("USER_NAME_LOC", _sessionInfo.getUserNameLoc());
				
		String docNo = "";
		if(param.containsKey("TYPE")){
			if("IV".equals(param.get("TYPE"))){
				if("SIGN".equals(param.get("CLS"))){ // 서명 첨부시
					docNo = commonInfoService.imageFileUpload(uploadForm, param);
				}else{ // 증빙 등록시
					docNo = commonInfoService.imageFileUpload(uploadForm, param);	
				}
			} else {
				docNo = commonInfoService.fileUpload(uploadForm, param);
			}
		} else {
			docNo = commonInfoService.fileUpload(uploadForm, param);
		}

		rtnMap = new HashMap<String, Object>();
		rtnMap.put("docNo", docNo);
		rtnMap.put("status", "true");
		return rtnMap;
	}

	public List<MultipartFile> getMultiPart(MultipartHttpServletRequest request) throws Exception {
		InputStream stream = null;
		FileOutputStream fout = null;
		logger.debug("getContentLength : " + request.getContentLength());
		List<MultipartFile> result = new ArrayList<MultipartFile>();
		try {
			String repositoryPath = CommonUtil.localUploadPath;
			File repository = new File(repositoryPath);
			// Create a factory for disk-based file items
			DiskFileItemFactory factory = new DiskFileItemFactory();
			// Configure a repository (to ensure a secure temp location is used)
			factory.setSizeThreshold(factorySizeThreshold);
			factory.setRepository(repository);
			// Create a new file upload handler
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setSizeMax(maxSizeFile);
			// final Part filePart = request.getPart("file");
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			if (ServletFileUpload.isMultipartContent(request)) {
				ServletFileUpload fileUpload = new ServletFileUpload();
				FileItemIterator items = fileUpload.getItemIterator(request);
				logger.debug("items : " + items);
				while (items.hasNext()) {
					FileItemStream item = items.next();
					logger.debug(" - item : " + item);
					if (!item.isFormField()) {
						// is = item.openStream();
					}
				}
			}
			Map<String, List<FileItem>> param = upload.parseParameterMap(request);
			logger.debug("maxSize : " + upload.getFileSizeMax());
			logger.debug("isMultipart : " + isMultipart);
			logger.debug("param : " + param);
			// Parse the request
			List<FileItem> items = upload.parseRequest(request);
			upload.setHeaderEncoding("utf-8");
			logger.debug("items : " + items);
			Iterator<FileItem> iter = items.iterator();
			while (iter.hasNext()) {
				FileItem item = iter.next();
				logger.debug(" - item : " + item);
				if (item.isFormField()) {
					continue;
				}
				MultipartFile mFile = new CommonsMultipartFile(item);
				result.add(mFile);
			}
		} catch (FileUploadBase.SizeLimitExceededException e) {
			logger.error(e.getMessage());
			throw new Exception("파일사이즈가 초과되었습니다.(업로드 사이즈 :" + e.getActualSize() + ",업로드 가능한 사이즈 : "
					+ e.getPermittedSize());
		} catch (FileUploadException e) {
			logger.error(e.getMessage());
			throw new Exception(e.getMessage());
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new Exception(e.getMessage());
		} finally {
			if (stream != null)
				stream.close();
			if (fout != null)
				fout.close();
		}
		return result;
	}

	public MultiValueMap<String, String> covertListToMultiValueMap(List<Map<String, Object>> param) {
		MultiValueMap<String, String> multiMap = new LinkedMultiValueMap<String, String>();
		Iterator<Map<String, Object>> it = param.iterator();
		while (it.hasNext()) {
			Map<String, Object> item = (Map<String, Object>) it.next();
			System.out.println(item);
			Iterator<String> mapIt = item.keySet().iterator();
			while (mapIt.hasNext()) {
				String key = (String) mapIt.next();
				multiMap.add(key, String.valueOf(item.get(key)));
			}
		}
		return multiMap;
	}
}

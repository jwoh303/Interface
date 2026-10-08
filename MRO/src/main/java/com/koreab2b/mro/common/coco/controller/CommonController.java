package com.koreab2b.mro.common.coco.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.googlecode.ehcache.annotations.TriggersRemove;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.CommonAwsS3;

@Controller("CommonController")
public class CommonController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonController.class);

	@Autowired
	private CommonInfoService commonInfoService;
	
	@RequestMapping(value = "/common/clearCache.do", method = RequestMethod.GET)
	@TriggersRemove(cacheName = "commonCache", removeAll=true)
	public void clearCache() {
	}
 
	/**
	 * ajax 
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/loginAjaxProcess.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loginAjaxProcess(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("loginAjaxProcess 요청 파라미터 : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = commonInfoService.loginProcess(pMap);
		_msg.put("ERRORMSG1", "메시지테스트1");
		_msg.put("ERRORMSG2", "메시지테스트2");
		_msg.put("ERRORMSG3", "메시지테스트3");
		_msg.put("ERRORMSG4", "메시지테스트4");
		// _msgList.addAll(_msg);
		// LOGGER.debug("_data " +_data);
		_response.put("data", _data);
		_response.put("message1", _msg);
		// LOGGER.debug("_response " +_response);
		return _response;
	}

	/**
	 * ajax combo
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/ajaxCombo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> ajaxCombo(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("ajaxCombo 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = commonInfoService.ajaxCombo(pMap);
		// _msgList.addAll(_msg);
		// LOGGER.debug("_data " +_data);
		_response.put("data", _data);
		// LOGGER.debug("_response " +_response);
		return _response;
	}
	
	/**
	 * ajax combo
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/ajaxQueryIdCombo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> ajaxQueryIdCombo(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("ajaxQueryIdCombo 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = commonInfoService.ajaxQueryIdCombo( pMap);
		// _msgList.addAll(_msg);
		// LOGGER.debug("_data " +_data);
		_response.put("data", _data);
		// LOGGER.debug("_response " +_response);
		return _response;
	}

	/**
	 * ajax combo (No Cache)
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/ajaxQueryIdComboNoCache.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> ajaxQueryIdComboNoCache(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("ajaxQueryIdComboNoCache 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = commonInfoService.ajaxQueryIdComboNoCache( pMap);
		// _msgList.addAll(_msg);
		// LOGGER.debug("_data " +_data);
		_response.put("data", _data);
		// LOGGER.debug("_response " +_response);
		return _response;
	}
	
	/**
	 * ajax combo
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/ajaxQueryIdSearchCombo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> ajaxQueryIdSearchCombo(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("ajaxQueryIdSearchCombo 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = commonInfoService.ajaxQueryIdCombo(pMap);
		// _msgList.addAll(_msg);
		// LOGGER.debug("_data " +_data);
		_response.put("data", _data);
		// LOGGER.debug("_response " +_response);
		return _response;
	}

	/**
	 * jsp 
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/loginProcess.do", method = RequestMethod.POST)
	public String loginProcess(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("loginProcess 요청 파라미터 for jsp : {}", pMap);

		List<Map<String, String>> _data = commonInfoService.loginProcess(pMap);
		pModel.addAttribute("data", _data);

		return "main/main";
	}
	
	/**
	 * voc유형별 담당자
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getVOCUser.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> getVOCUser(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("getVOCUser 요청 파라미터 for jsp : {}", pMap);
		Map<String,String> _data = commonInfoService.getVOCUser(pMap);
		return _data;
	}	

	/**
	 * 파일업로드 
	 * @param pModel
	 * @param uploadForm
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/fileUpload.do", method = RequestMethod.POST) 
	public String  fileUpload(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap) {
		LOGGER.debug("fileUpload 요청 파라미터 for jsp : {}", pMap);
		
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = commonInfoService.fileUpload(uploadForm, pMap);
		
		if(docNo.contains(".")) { //허용되지 않은 확장자
			pModel.addAttribute("result", "E");
			String extCheck = docNo.substring(docNo.lastIndexOf("."), docNo.length());
			pModel.addAttribute("EXT_CHECK", extCheck);

		}else { //허용된 확장자의 경우 정상 업로드 처리
			pModel.addAttribute("result", "U");			
			pModel.addAttribute("DOC_NO_UP", docNo);
		}
		return "/common/popup/fileUploadPop";

	}
	/**
	 * 파일업로드 
	 * @param pModel
	 * @param uploadForm
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/fileUpload_v2.do", method = RequestMethod.POST) 
	public String  fileUpload_v2(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap) {
		LOGGER.debug("fileUpload 요청 파라미터 for jsp : {}", pMap);
		
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = commonInfoService.fileUpload(uploadForm, pMap);
		
		if(docNo.contains(".")) { //허용되지 않은 확장자
			pModel.addAttribute("result", "E");
			String extCheck = docNo.substring(docNo.lastIndexOf("."), docNo.length());
			pModel.addAttribute("extCheck", extCheck);

		}else { //허용된 확장자의 경우 정상 업로드 처리
			pModel.addAttribute("result", "U");			
			pModel.addAttribute("docNo", docNo);
			pModel.addAttribute("key", pMap.get("key"));
		}
		return "/common/popup/commonFileUploadResultPop";

	}
	/**
	 * 파일업로드 v2 (JSON 응답) - 리뉴얼 화면 전용
	 * @param request
	 * @param uploadForm
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/fileUploadAjax_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> fileUpload_v2(HttpServletRequest request,
			@ModelAttribute("uploadForm") FileUploadForm uploadForm,
			@RequestParam Map<String, String> pMap) {
		LOGGER.debug("fileUpload_v2 요청 파라미터 (JSON 응답) : {}", pMap);

		Map<String, Object> response = new HashMap<String, Object>();

		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);

		String docNo = commonInfoService.fileUpload(uploadForm, pMap);

		if(docNo.contains(".")) { //허용되지 않은 확장자
			response.put("result", "E");
			String extCheck = docNo.substring(docNo.lastIndexOf("."), docNo.length());
			response.put("extCheck", extCheck);
			response.put("message", extCheck + " 파일은 첨부할 수 없는 파일입니다.");

		}else { //허용된 확장자의 경우 정상 업로드 처리
			response.put("result", "U");
			response.put("docNo", docNo);
			response.put("fileKey", docNo);  // fileKey 필드 추가
			response.put("key", pMap.get("key"));
			response.put("message", "파일 업로드 성공");
		}

		return response;
	}

	/**
	 * 파일업로드 AJAX (JSON 응답) - 리뉴얼 화면 전용
	 * @param request
	 * @param uploadForm
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/fileUploadAjax.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> fileUploadAjax(HttpServletRequest request,
			@ModelAttribute("uploadForm") FileUploadForm uploadForm,
			@RequestParam Map<String, String> pMap) {
		LOGGER.debug("fileUploadAjax 요청 파라미터 for ajax : {}", pMap);

		Map<String, Object> response = new HashMap<String, Object>();

		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);

		String docNo = commonInfoService.fileUpload(uploadForm, pMap);

		if(docNo.contains(".")) { //허용되지 않은 확장자
			response.put("result", "E");
			String extCheck = docNo.substring(docNo.lastIndexOf("."), docNo.length());
			response.put("extCheck", extCheck);
			response.put("message", extCheck + " 파일은 첨부할 수 없는 파일입니다.");

		}else { //허용된 확장자의 경우 정상 업로드 처리
			response.put("result", "U");
			response.put("docNo", docNo);
			response.put("fileKey", docNo);  // fileKey 필드 추가
			response.put("key", pMap.get("key"));
			response.put("message", "파일 업로드 성공");
		}

		return response;
	}

	/**
	 * 다중 파일 업로드 Ajax (JSON 응답) - 리뉴얼 화면 전용
	 * - files[0], files[1], ... 형태로 여러 파일을 받아서 순차적으로 업로드
	 * - 첫 번째 파일은 새로운 DOC_NO 생성, 나머지는 동일 DOC_NO 재사용
	 *
	 * @param request HttpServletRequest
	 * @param uploadForm FileUploadForm (다중 파일 포함)
	 * @param pMap 요청 파라미터
	 * @return JSON 응답 {success, fileKey, uploadedCount, failedFiles}
	 */
	@RequestMapping(value = "/common/multiFileUploadAjax_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> multiFileUploadAjax_v2(HttpServletRequest request,
			@ModelAttribute("uploadForm") FileUploadForm uploadForm,
			@RequestParam Map<String, String> pMap) {
		LOGGER.debug("multiFileUploadAjax_v2 요청 파라미터 : {}", pMap);

		Map<String, Object> response = new HashMap<String, Object>();
		List<Map<String, String>> uploadedFiles = new ArrayList<Map<String, String>>();
		List<String> failedFiles = new ArrayList<String>();

		try {
			// 세션 정보 가져오기
			pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);

			// 업로드할 파일 목록 가져오기
			List<MultipartFile> files = uploadForm.getFiles();

			if (files == null || files.isEmpty()) {
				response.put("success", false);
				response.put("message", "업로드할 파일이 없습니다.");
				return response;
			}

			LOGGER.debug("multiFileUploadAjax_v2 - 업로드할 파일 개수: {}", files.size());

			// 프론트엔드에서 보낸 기존 DOC_NO 확인 (기존 파일 그룹에 추가하는 경우)
		String existingDocNo = pMap.get("DOC_NO");
		String sharedFileKey = existingDocNo; // 기존 DOC_NO가 있으면 사용, 없으면 null

			// 각 파일을 순차적으로 업로드 (for문 사용)
			for (int i = 0; i < files.size(); i++) {
				MultipartFile file = files.get(i);
				String originalFilename = file.getOriginalFilename();

				LOGGER.debug("multiFileUploadAjax_v2 - 파일[{}] 업로드 시작: {}", i, originalFilename);

				try {
					// FileUploadForm에 현재 파일만 설정 (단일 파일 업로드 서비스 호출)
					FileUploadForm singleFileForm = new FileUploadForm();
					List<MultipartFile> singleFileList = new ArrayList<MultipartFile>();
					singleFileList.add(file);
					singleFileForm.setFiles(singleFileList);

					// DOC_NO 파라미터 설정 (재사용 여부 결정)
					if (sharedFileKey != null) {
						pMap.put("DOC_NO", sharedFileKey); // 두 번째 파일부터는 동일 DOC_NO 사용
						LOGGER.debug("multiFileUploadAjax_v2 - 기존 fileKey 재사용: {}", sharedFileKey);
					} else {
						pMap.remove("DOC_NO"); // 첫 번째 파일은 새로운 DOC_NO 생성
						LOGGER.debug("multiFileUploadAjax_v2 - 새로운 fileKey 생성");
					}

					// 개별 파일 업로드 (commonInfoService.fileUpload 호출)
					String docNo = commonInfoService.fileUpload(singleFileForm, pMap);

					// 업로드 결과 검증
					if (docNo.contains(".")) {
						// 허용되지 않은 확장자
						String extCheck = docNo.substring(docNo.lastIndexOf("."), docNo.length());
						LOGGER.warn("multiFileUploadAjax_v2 - 파일[" + i + "] 업로드 실패 (허용되지 않은 확장자: " + extCheck + "): " + originalFilename);
						failedFiles.add(originalFilename + " (" + extCheck + " 확장자는 허용되지 않음)");
					} else {
						// 업로드 성공
						if (sharedFileKey == null) {
							// 첫 번째 파일 업로드 성공 시 fileKey 저장
							sharedFileKey = docNo;
							LOGGER.info("multiFileUploadAjax_v2 - 공유 fileKey 설정: {}", sharedFileKey);
						}

						// 업로드 성공 파일 정보 저장
						Map<String, String> fileInfo = new HashMap<String, String>();
						fileInfo.put("fileName", originalFilename);
						fileInfo.put("fileKey", docNo);
						fileInfo.put("index", String.valueOf(i));
						uploadedFiles.add(fileInfo);

						LOGGER.info("multiFileUploadAjax_v2 - 파일[" + i + "] 업로드 성공 - fileKey: " + docNo + ", fileName: " + originalFilename);
					}

				} catch (Exception e) {
					// 개별 파일 업로드 실패 (예외 발생)
					LOGGER.error("multiFileUploadAjax_v2 - 파일[" + i + "] 업로드 중 오류 발생: " + originalFilename, e);
					failedFiles.add(originalFilename + " (오류: " + e.getMessage() + ")");
				}
			}

			// 응답 생성
			if (uploadedFiles.size() > 0) {
				response.put("success", true);
				response.put("fileKey", sharedFileKey); // 공유 fileKey (DOC_NO)
				response.put("uploadedFiles", uploadedFiles); // 업로드 성공 파일 목록
				response.put("uploadedCount", uploadedFiles.size()); // 성공한 파일 개수
				response.put("failedFiles", failedFiles); // 실패한 파일 목록
				response.put("failedCount", failedFiles.size()); // 실패한 파일 개수
				response.put("message", uploadedFiles.size() + "개 파일 업로드 성공" +
					(failedFiles.size() > 0 ? ", " + failedFiles.size() + "개 파일 실패" : ""));
			} else {
				response.put("success", false);
				response.put("fileKey", null);
				response.put("failedFiles", failedFiles);
				response.put("failedCount", failedFiles.size());
				response.put("message", "모든 파일 업로드 실패");
			}

			LOGGER.info("multiFileUploadAjax_v2 - 최종 결과 - 성공: " + uploadedFiles.size() +
				", 실패: " + failedFiles.size() + ", fileKey: " + sharedFileKey);

		} catch (Exception e) {
			LOGGER.error("multiFileUploadAjax_v2 - 전체 업로드 처리 중 오류 발생", e);
			response.put("success", false);
			response.put("message", "파일 업로드 처리 중 오류가 발생했습니다: " + e.getMessage());
		}

		return response;
	}
	
	/**
	 * 파일업로드 대상 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getFileUploadList.do", method = RequestMethod.POST)
	public String getFileUploadList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getFileUploadList 요청 파라미터 for jsp : {}", pMap);
		String docNoUp = pMap.get("DOC_NO_UP");
		if(!"".equals(docNoUp)){
			pMap.put("DOC_NO", docNoUp);
		}
		
		String osName = System.getProperty("os.name");
		String _path = "";
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		List<Map<String, String>> _data = commonInfoService.getFileUploadList(pMap);
		List<Map<String, String>> _data2 = new ArrayList<Map<String, String>>();
		
		java.io.File file = null;
		String img_yn =  pMap.get("IMG_YN");
		
		for (int i=0; i<_data.size(); i++){
			
			Map<String, String> _map =_data.get(i);
			String _filename = _map.get("DES_FILE_NAME").toString();
			String _orgFilename = _map.get("SRC_FILE_NAME").toString();
			String _type = _map.get("TYPE").toString();
			String _del_file_dir = _map.get("DES_FILE_DIR").toString();
			if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
				_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath : CommonUtil.getUploadTypePath(_type, img_yn);
			}else{
				_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath + "/" +_del_file_dir: CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir;
			}
			
			file = new java.io.File(_path + "/" + _filename);
			
			 
			if (file.isFile()) {			
				_map.put("FILEYN", "FILEOK"); 
			}else{
				_map.put("FILEYN", "FILENOT"); 
			}
			 
			_data2.add(_map);
		}
		
		 
		
		pModel.addAttribute("data", _data2);
		
		if(_data.size() > 0){
			pModel.addAttribute("DOC_NO_UP", _data.get(0).get("DOC_NO"));
		}
		
		pModel.addAttribute("result", "S");
		return "/common/popup/fileUploadPop";
	}
	
	/**
	 * 파일업로드 대상 조회 v2 (JSON 응답) - 리뉴얼 화면 전용
	 *
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getFileUploadList_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getFileUploadList_v2(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("getFileUploadList_v2 요청 파라미터 (JSON 응답) : {}", pMap);

		Map<String, Object> response = new HashMap<String, Object>();

		// DOC_NO_UP 파라미터 처리
		String docNoUp = pMap.get("DOC_NO_UP");
		if(docNoUp != null && !"".equals(docNoUp)){
			pMap.put("DOC_NO", docNoUp);
		}

		// IMG_YN 기본값 설정
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));

		// 파일 목록 조회
		List<Map<String, String>> fileList = commonInfoService.getFileUploadList(pMap);

		// V2 응답 형식으로 변환 (FILE_NAME 필드 추가)
		List<Map<String, Object>> v2FileList = new ArrayList<Map<String, Object>>();
		for (Map<String, String> fileInfo : fileList) {
			Map<String, Object> v2FileInfo = new HashMap<String, Object>();

			// 원본 필드 복사
			v2FileInfo.putAll(fileInfo);

			// FILE_NAME 필드 추가 (SRC_FILE_NAME과 동일)
			v2FileInfo.put("FILE_NAME", fileInfo.get("SRC_FILE_NAME"));
			v2FileInfo.put("fileName", fileInfo.get("SRC_FILE_NAME"));

			v2FileList.add(v2FileInfo);
		}

		response.put("data", v2FileList);
		response.put("success", true);
		response.put("count", v2FileList.size());

		return response;
	}

	/**
	 * 파일업로드 삭제
	 *
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/removeFileInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeFileInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("removeFileInfo 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		 
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		
		pMap.put("DOC_NO", pMap.get("D_DOC_NO"));
		pMap.put("DOC_SEQ", pMap.get("D_DOC_SEQ"));
	//	pMap.put("TYPE", pMap.get("D_TYPE"));
	//	String type = pMap.get("D_TYPE");
		String img_yn =  pMap.get("IMG_YN");
		
		Map<String, String> _map = commonInfoService.getFileUploadDetail(pMap);
		String _filename = _map.get("DES_FILE_NAME").toString();
		String _type = _map.get("TYPE").toString();
		String _del_file_dir = _map.get("DES_FILE_DIR").toString();
		String _path = "";
		
		String osName = System.getProperty("os.name");

		if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
			_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath : CommonUtil.getUploadTypePath(_type, img_yn);
		}else{
			_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath + "/" +_del_file_dir: CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir;
		}
		
		LOGGER.debug("file _path_path  {}",_path);
		File   file      = new File(_path + "/" + _filename);  // 파일 객체생성
		if( file.exists() ) file.delete();  
		
		commonInfoService.removeFileInfo(pMap); 
		pModel.addAttribute("result", "D");
		
		_response.put("key", pMap.get("D_DOC_SEQ")); //리뉴얼 화면에서 해당 key에 해당하는 html 지우기 위함
		
		return  _response;
	}	
	
	/**
	 * 파일다운로드 
	 * @param pModel
	 * @param response
	 * @param request
	 * @param pMap
	 */	
	@RequestMapping(value = "/common/download.do", method = {RequestMethod.GET , RequestMethod.POST })
	public void download(ModelMap pModel, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo"); 		
		
		LOGGER.debug("download 요청 파라미터 for jsp : {}", pMap);
		String osName = System.getProperty("os.name");		
		
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		String img_yn =  pMap.get("IMG_YN");
		
		Map<String, String> _map = commonInfoService.getFileUploadDetail(pMap);
		
		String _filename = _map.get("DES_FILE_NAME").toString();
		LOGGER.info("다운로드 파일명 정보  : {}", _filename);
		String _orgFilename = _map.get("SRC_FILE_NAME").toString();
		String _type = _map.get("TYPE").toString();
		String _del_file_dir = _map.get("DES_FILE_DIR").toString();
		String _path = "";
		int atYnCnt = 0;
		pMap.put("PTYPE", _type);
		atYnCnt = commonInfoService.getFileUploadAtYnCnt(pMap);
		
		if(atYnCnt == 0 || _sessionInfo != null) {
			LOGGER.info("다운로드 요청자ID 정보 아이디  : {}", _sessionInfo.getUserId());
		} else {
			LOGGER.info("Ptype ==== {} ", _type);
		}
		
		java.io.File file = null;
		ServletOutputStream outStream 	= null;
		FileInputStream inputStream 	= null;
		
		if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
			_path = CommonUtil.getUploadTypePath(_type, img_yn)+ "/";
		}else{
			_path = CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir+ "/";
		}

		LOGGER.debug("file _path_path  {}",_path);
		try {
			
			if (CommonAwsS3.doesFileExists(_path + _filename)) {
				byte b[] = new byte[4096];    
				outStream 	= null;
				inputStream 	= null;
		        outStream = response.getOutputStream();
		        inputStream = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));               
		        response.setContentType("application/octet-stream"); 
		        response.setHeader("Content-Disposition", "attachment;filename=\"" +  java.net.URLEncoder.encode(_orgFilename,"UTF-8") + "\"");

		        int leng = 0;
	        	while((leng = inputStream.read(b)) > 0){
		        	outStream.write(b, 0, leng);
		        }
			         
				inputStream.close();
			    outStream.flush();
			    outStream.close();
			}
			     
	 
		} catch (Exception e) {
			try {
				inputStream.close(); 
			    outStream.close();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			LOGGER.debug("download Exception {}",e); 
			//LOGGER.debug("Exception : {}", e.toString()); 
		} 

		/*
		 * try {
		 * 
		 * file = new java.io.File(_path + "/" + _filename);
		 * 
		 * LOGGER.debug("_filename 요청 파라미터 for jsp : {}", _filename);
		 * LOGGER.debug("_orgFilename 요청 파라미터 for jsp : {}", _orgFilename);
		 * LOGGER.debug("file.isFile() 요청 파라미터 for jsp : {}", file.isFile());
		 * 
		 * if (file.isFile()) { byte b[] = new byte[(int) file.length()];
		 * 
		 * outStream = null; inputStream = null;
		 * 
		 * 
		 * outStream = response.getOutputStream(); inputStream = new
		 * FileInputStream(file);
		 * 
		 * response.setContentType("application/octet-stream");
		 * response.setHeader("Content-Disposition", "attachment;filename=\"" +
		 * java.net.URLEncoder.encode(_orgFilename,"UTF-8") + "\"");
		 * 
		 * byte[] outByte = new byte[4096]; int leng = 0; //
		 * while(inputStream.read(outByte, 0, 4096) != -1){ while((leng =
		 * inputStream.read(b)) > 0){
		 * 
		 * outStream.write(b, 0, leng); }
		 * 
		 * inputStream.close(); outStream.flush(); outStream.close(); }
		 * 
		 * 
		 * } catch (Exception e) { try { inputStream.close(); outStream.close(); } catch
		 * (IOException e1) { // TODO Auto-generated catch block e1.printStackTrace(); }
		 * 
		 * LOGGER.debug("download Exception {}",e); //LOGGER.debug("Exception : {}",
		 * e.toString()); }
		 */

	}
	
	/**
	 * 파일다운로드 - 리뉴얼 
	 * @param pModel
	 * @param response
	 * @param request
	 * @param pMap
	 */
	@RequestMapping(value = "/common/download_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public void download_v2(ModelMap pModel, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("download 요청 파라미터 for jsp : {}", pMap);
		String osName = System.getProperty("os.name");		
		
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		String img_yn =  pMap.get("IMG_YN");
		
		if(img_yn.equals("Y")){ //이미지 파일 다운로드의 경우
			String _filename = pMap.get("IMGFILE_NAME").toString();
			String ext = _filename.substring(_filename.lastIndexOf("."), _filename.length()).toLowerCase();
			String _orgFilename = "Image"+ext; //Image라는 이름으로 다운로드
			String _path = pMap.get("IMGFILE_DIR").toString()+"/";
			java.io.File file = null;
			ServletOutputStream outStream 	= null;
			FileInputStream inputStream 	= null;
			
			LOGGER.debug("file _path_path  {}",_path);
			try {
				
				if (CommonAwsS3.doesFileExists(_path + _filename)) {
					byte b[] = new byte[4096];    
					outStream 	= null;
					inputStream 	= null;
			        outStream = response.getOutputStream();
			        inputStream = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));               
			        response.setContentType("application/octet-stream"); 
			        response.setHeader("Content-Disposition", "attachment;filename=\"" +  java.net.URLEncoder.encode(_orgFilename,"UTF-8") + "\"");

			        int leng = 0;
		        	while((leng = inputStream.read(b)) > 0){
			        	outStream.write(b, 0, leng);
			        }
				         
					inputStream.close();
				    outStream.flush();
				    outStream.close();
				}
			} catch (Exception e) {
				try {
					if(inputStream != null)
						inputStream.close(); 
					if(outStream != null)
						outStream.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				LOGGER.debug("download Exception {}",e); 
			}
		}else{
			pMap.put("DOC_SEQ", CommonUtil.onvl(pMap.get("DOC_SEQ"), ""));
			List<Map<String, String>> _mapList = commonInfoService.getFileUploadDetail_v2(pMap);
			if(_mapList.size() == 1){ //파일 1개일땐 원래 로직
				String _filename = _mapList.get(0).get("DES_FILE_NAME").toString();
				String _orgFilename = _mapList.get(0).get("SRC_FILE_NAME").toString();
				String _type = _mapList.get(0).get("TYPE").toString();
				String _del_file_dir = _mapList.get(0).get("DES_FILE_DIR").toString();
				String _path = "";
				java.io.File file = null;
				ServletOutputStream outStream 	= null;
				FileInputStream inputStream 	= null;
				
				if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
					_path = CommonUtil.getUploadTypePath(_type, img_yn)+ "/";
				}else{
					_path = CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir+ "/";
				}

				LOGGER.debug("file _path_path  {}",_path);
				try {
					
					if (CommonAwsS3.doesFileExists(_path + _filename)) {
						byte b[] = new byte[4096];    
						outStream 	= null;
						inputStream 	= null;
				        outStream = response.getOutputStream();
				        inputStream = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));               
				        response.setContentType("application/octet-stream"); 
				        response.setHeader("Content-Disposition", "attachment;filename=\"" +  java.net.URLEncoder.encode(_orgFilename,"UTF-8") + "\"");

				        int leng = 0;
			        	while((leng = inputStream.read(b)) > 0){
				        	outStream.write(b, 0, leng);
				        }
					         
						inputStream.close();
					    outStream.flush();
					    outStream.close();
					}
				} catch (Exception e) {
					try {
						if(inputStream != null)
							inputStream.close(); 
						if(outStream != null)
							outStream.close();
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}

					LOGGER.debug("download Exception {}",e); 
				}
			}else{
				// 파일명(SRC_FILE_NAME)이 동일한 첨부가 여러 개일 수 있으므로, S3에서 바로
				// zip으로 스트리밍하고 엔트리명은 중복되지 않게 (2),(3)...을 붙여 처리한다.
				java.util.Set<String> usedNames = new java.util.HashSet<String>();
				ZipOutputStream zos = null;
				try {
					response.setContentType("application/zip");
			        response.setHeader("Content-Disposition", "attachment;filename=\"" +  java.net.URLEncoder.encode("downLoad","UTF-8") + ".zip\"");

					zos = new ZipOutputStream(response.getOutputStream());
					byte b[] = new byte[4096];

					for(int i = 0; i<_mapList.size(); i++){
						String _filename = _mapList.get(i).get("DES_FILE_NAME").toString();
						String _orgFilename = _mapList.get(i).get("SRC_FILE_NAME").toString();
						String _type = _mapList.get(i).get("TYPE").toString();
						String _del_file_dir = _mapList.get(i).get("DES_FILE_DIR").toString();
						String _path = "";

						if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
							_path = CommonUtil.getUploadTypePath(_type, img_yn)+ "/";
						}else{
							_path = CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir+ "/";
						}

						LOGGER.debug("file _path_path  {}",_path);

						com.amazonaws.services.s3.model.S3Object obj = null;
						java.io.InputStream inputStream = null;
						try {
							obj = CommonAwsS3.getObject(_path + _filename);
							inputStream = obj.getObjectContent();
							String entryName = uniqueEntryName(_orgFilename, usedNames);
							zos.putNextEntry(new ZipEntry(entryName));
							int leng = 0;
							while((leng = inputStream.read(b)) > 0){
					        	zos.write(b, 0, leng);
					        }
							zos.closeEntry();
						} catch (Exception fe) {
							LOGGER.warn("download_v2 zip 첨부 스킵 {} - {}", _filename, fe.getMessage());
						} finally {
							if(inputStream != null){ try { inputStream.close(); } catch (IOException ignore) {} }
							if(obj != null){ try { obj.close(); } catch (IOException ignore) {} }
						}
					}
				} catch (IOException e) {
					LOGGER.error("download_v2 zip error", e);
				} finally {
					if(zos != null){ try { zos.close(); } catch (IOException ignore) {} }
				}
			}
		}
	}

	/**
	 * zip 엔트리명 중복 방지. 이미 사용한 이름이면 확장자 앞에 " (2)", " (3)" ... 를 붙여
	 * 유니크한 이름을 만들고 usedNames 에 등록한다.
	 */
	private static String uniqueEntryName(String name, java.util.Set<String> usedNames) {
		if (name == null || "".equals(name)) {
			name = "file";
		}
		if (!usedNames.contains(name)) {
			usedNames.add(name);
			return name;
		}
		int dot = name.lastIndexOf(".");
		String base = (dot > 0) ? name.substring(0, dot) : name;
		String ext  = (dot > 0) ? name.substring(dot) : "";
		int n = 2;
		String candidate;
		do {
			candidate = base + " (" + n + ")" + ext;
			n++;
		} while (usedNames.contains(candidate));
		usedNames.add(candidate);
		return candidate;
	}
	
	/**
	 * 파일다운로드 - 리뉴얼 -여러개의 doc_no를 한번에 download
	 * @param pModel
	 * @param response
	 * @param request
	 * @param pMap
	 */
	@RequestMapping(value = "/common/downloadMulti_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public void downloadMulti_v2(ModelMap pModel, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String, Object> pMap) {

		LOGGER.debug("download 요청 파라미터 for jsp : {}", pMap);
		String osName = System.getProperty("os.name");	
		
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		String img_yn =  (String)pMap.get("IMG_YN");
		
//		pMap.put("DOC_SEQ", CommonUtil.onvl(pMap.get("DOC_SEQ"), ""));
		List<Map<String, String>> _mapList = commonInfoService.getFileUploadDetailMulti_v2(pMap);
		List<File> fileList = new ArrayList<File>();
		
		for(int i = 0; i<_mapList.size(); i++){
			String _filename = _mapList.get(i).get("DES_FILE_NAME").toString();
			String _orgFilename = _mapList.get(i).get("SRC_FILE_NAME").toString();
			String _type = _mapList.get(i).get("TYPE").toString();
			String _del_file_dir = _mapList.get(i).get("DES_FILE_DIR").toString();
			String _path = "";
			
			if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
				_path = CommonUtil.getUploadTypePath(_type, img_yn)+ "/";
			}else{
				_path = CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir+ "/";
			}

			LOGGER.debug("file _path_path  {}",_path);
			try {
				
				if (CommonAwsS3.doesFileExists(_path + _filename)) {
			        fileList.add(CommonAwsS3.download(_path + _filename, _orgFilename));
				}
				     
		 
			} catch (Exception e) {

				LOGGER.debug("download Exception {}",e); 
			}
		}
		
        
		try {
			response.setContentType("application/octet-stream"); 
	        response.setHeader("Content-Disposition", "attachment;filename=\"" +  java.net.URLEncoder.encode("downLoad","UTF-8") + ".zip\"");
	        
			ZipOutputStream zos = new ZipOutputStream(response.getOutputStream());
			byte b[] = new byte[4096];
			for(File file : fileList){
				FileInputStream inputStream = new FileInputStream(file);
				zos.putNextEntry(new ZipEntry(file.getName()));
				int leng = 0;
				while((leng = inputStream.read(b)) > 0){
		        	zos.write(b, 0, leng);
		        }
				zos.closeEntry();
			}
			zos.finish();
	        
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		for(File file : fileList){
			file.delete();
		}
	}
	
	/**
	 * 파일다운로드 (KEY 추가)
	 * @param pModel
	 * @param response
	 * @param request
	 * @param pMap
	 */
	@RequestMapping(value = "/common/fileDwn.do", method = {RequestMethod.GET , RequestMethod.POST })
	public void fileDwn(ModelMap pModel, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("download 요청 파라미터 for jsp : {}", pMap);
		String osName = System.getProperty("os.name");		
		
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		String img_yn =  pMap.get("IMG_YN");
		
		Map<String, String> _map = commonInfoService.getFileUploadDetailMsds(pMap);
		String _filename = _map.get("DES_FILE_NAME").toString();
		String _orgFilename = _map.get("SRC_FILE_NAME").toString();
		String _type = _map.get("TYPE").toString();
		String _del_file_dir = _map.get("DES_FILE_DIR").toString();
		String _path = "";
		java.io.File file = null;
		ServletOutputStream outStream 	= null;
		FileInputStream inputStream 	= null;
		
		if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
			_path = CommonUtil.getUploadTypePath(_type, img_yn)+ "/";
		}else{
			_path = CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir+ "/";
		}

		LOGGER.debug("file _path_path  {}",_path);
		try {
			
			if (CommonAwsS3.doesFileExists(_path + _filename)) {
				byte b[] = new byte[4096];    
				outStream 	= null;
				inputStream 	= null;
		        outStream = response.getOutputStream();
		        inputStream = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));               
		        response.setContentType("application/octet-stream"); 
		        response.setHeader("Content-Disposition", "attachment;filename=\"" +  java.net.URLEncoder.encode(_orgFilename,"UTF-8") + "\"");

		        int leng = 0;
	        	while((leng = inputStream.read(b)) > 0){
		        	outStream.write(b, 0, leng);
		        }
			         
				inputStream.close();
			    outStream.flush();
			    outStream.close();
			}
			     
	 
		} catch (Exception e) {
			try {
				inputStream.close(); 
			    outStream.close();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			LOGGER.debug("download Exception {}",e); 
			//LOGGER.debug("Exception : {}", e.toString()); 
		} 
	}
	
	
	/**
	 * 첨부파일 정보를 화면으로 리턴한다.
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */  
	@RequestMapping(value = "/common/downloadCheck.do", method = {RequestMethod.GET , RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> getFileInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getFileInfogetFileInfo "); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		LOGGER.debug("downloadCheck 요청 파라미터 for jsp : {}", pMap);
		String osName = System.getProperty("os.name");		
		
	//	String type = pMap.get("TYPE");		

		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		String img_yn =  pMap.get("IMG_YN");
		
		Map<String, String> _map = commonInfoService.getFileUploadDetail(pMap);
		String _filename = _map.get("DES_FILE_NAME").toString();
		String _orgFilename = _map.get("SRC_FILE_NAME").toString();
		String _type = _map.get("TYPE").toString();
		String _del_file_dir = _map.get("DES_FILE_DIR").toString();
		String _path = "";
		
			if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
				_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath : CommonUtil.getUploadTypePath(_type, img_yn);
			}else{
				_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath + "/" +_del_file_dir: CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir;
			}
			try {
			java.io.File file = new java.io.File(_path + "/" + _filename);
		
			if (file.isFile()) {			
				_msg.put("MSG", "FILEOK"); 
			}else{
				_msg.put("MSG", "FILENOT"); 
			}
			
			
		} catch (Exception e) {
			
			LOGGER.debug("download Exception {}",e); 
			//LOGGER.debug("Exception : {}", e.toString()); 
		} 
		
		
		LOGGER.debug("downloadCheck _msg : {}", _msg);
		
		_response.put("msg", _msg);
		return  _response;
	}	
	
	
	/**
	 * Excel 업로드 
	 * @param pModel
	 * @param uploadForm
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/excelFileUpload.do", method = RequestMethod.POST) 
	public String  excelFileUpload(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap) {

		LOGGER.debug("Excel Upload 요청 파라미터 for jsp : {}", pMap);
		 
		String osName = System.getProperty("os.name");
		String _path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath : CommonUtil.realUploadPath;	
		String saveFileName = "";
		List<MultipartFile> _files = uploadForm.getFiles(); 
		if (null != _files && _files.size() > 0) {
			for (MultipartFile _multipartFile : _files) {
				String _fileName = _multipartFile.getOriginalFilename(); 

				try
				{
					
				 File _destFile = new File(_path + "/" + _fileName); 
				 FileUtils.writeByteArrayToFile(_destFile, _multipartFile.getBytes()); 
				 saveFileName = _path + "/" + _fileName;
				 
				 // Excel 처리
                 // Excel 97~2003(.xls)과 Excel 2007(.xlsx)은 각각 처리해야 한다.
                 if( saveFileName.indexOf(".xlsx") > -1 ) readExcel2007( saveFileName );
                 else if( saveFileName.indexOf(".xls") > -1 ) readExcel( saveFileName );

                 if( _destFile.exists() ) _destFile.delete();  
                 
				}
				catch(Exception e){
					LOGGER.error("엑셀 업로드 실패 : ",e);
				} 
			}
		}
		pModel.addAttribute("result", "U");
		return "/common/popup/excelUploadPop";

	}
	
	
	 // Excel 2007(.xlsx) 이상 파일처리
    public void readExcel2007( String excel ) throws IOException {
        // check file
        File file = new File( excel );
        if( !file.exists() || !file.isFile() || !file.canRead() ) {
            throw new IOException( excel );
        }
        
        StringBuilder sb = new StringBuilder();
        int j =0;

        // http://poi.apache.org/apidocs/index.html?overview-summary.html
        // http://poi.apache.org/apidocs/org/apache/poi/xssf/usermodel/XSSFWorkbook.html
        XSSFWorkbook wb = new XSSFWorkbook( new FileInputStream(file) );
        try {
            for( int i=0; i<wb.getNumberOfSheets(); i++ ) {            	
                for( Row row : wb.getSheetAt(i) ) {
                	sb.append("\n"+(j++) +"--------->");
                    for( Cell cell : row ) {
                        switch( cell.getCellType() ) {
                            case XSSFCell.CELL_TYPE_STRING:
                            	sb.append(cell.getRichStringCellValue().getString());
                            	sb.append("/");
                                break;
                            case XSSFCell.CELL_TYPE_NUMERIC:
                            	sb.append(Double.valueOf( cell.getNumericCellValue() ).intValue());
                            	sb.append("/");
                                break;
                            case XSSFCell.CELL_TYPE_FORMULA:
                            	sb.append(cell.getCellFormula());
                            	sb.append("/");
                                break;
                            case XSSFCell.CELL_TYPE_BOOLEAN:
                            	sb.append(cell.getBooleanCellValue());
                            	sb.append("/");
                                break;
                            case XSSFCell.CELL_TYPE_ERROR: 
                            	sb.append(cell.getErrorCellValue()); 
                                break;
                            case XSSFCell.CELL_TYPE_BLANK: 
                            	break;
                            default: 
                            	break;
                        }
                    }
                }
            }
                        
            
            LOGGER.debug("Excel Upload 결과 : {}", sb.toString());
        } catch( Exception ex ) {
            ex.printStackTrace();
        }
    }


    // Excel 97~2003(.xls) 파일처리
    public void readExcel( String excel ) throws IOException {
        // check file
        File file = new File( excel );
        if( !file.exists() || !file.isFile() || !file.canRead() ) {
            throw new IOException( excel );
        }
        
        StringBuilder sb = new StringBuilder();
        int j = 0;

        // http://poi.apache.org/apidocs/index.html?overview-summary.html
        // http://poi.apache.org/apidocs/org/apache/poi/hssf/usermodel/HSSFWorkbook.html
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(file));
        try {
            for( int i=0; i<wb.getNumberOfSheets(); i++ ) { 
                for( Row row : wb.getSheetAt(i) ) {
                	sb.append("\n"+(j++) +"--------->");
                    for( Cell cell : row ) {
                        switch( cell.getCellType() ) {
                            case HSSFCell.CELL_TYPE_STRING:
                            	sb.append(cell.getRichStringCellValue().getString()); 
                                sb.append("/");
                                break;
                            case HSSFCell.CELL_TYPE_NUMERIC: 
                            	sb.append(Double.valueOf( cell.getNumericCellValue() ).intValue()); 
                                sb.append("/");
                                break;
                            case HSSFCell.CELL_TYPE_FORMULA:
                            	sb.append(cell.getCellFormula());   
                                sb.append("/");
                                break;
                            case HSSFCell.CELL_TYPE_BOOLEAN:
                            	sb.append(cell.getBooleanCellValue()); 
                                sb.append("/");
                                break;
                            case HSSFCell.CELL_TYPE_ERROR:
                            	sb.append(cell.getErrorCellValue());  
                                sb.append("/");
                                break;
                            case HSSFCell.CELL_TYPE_BLANK: 
                            	break;
                            default: 
                            	break;
                        }
                    }
                }
            }
            LOGGER.debug("Excel Upload 결과 : {}", sb.toString());
        } catch( Exception ex ) {
            ex.printStackTrace();
        }
    }

	/**
	 * 이미지 파일업로드 대상 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getImageFileUploadList.do", method = RequestMethod.POST)
	public String getImageFileUploadList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getImageFileUploadList 요청 파라미터 for jsp : {}", pMap);
		String docNoUp = pMap.get("DOC_NO_UP");
		if(!"".equals(docNoUp)){
			pMap.put("DOC_NO", docNoUp);
		}
		
		String osName = System.getProperty("os.name");
		String _path = "";
		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		List<Map<String, String>> _data = commonInfoService.getFileUploadList(pMap);
		List<Map<String, String>> _data2 = new ArrayList<Map<String, String>>();
		
		java.io.File file = null;
		String img_yn =  pMap.get("IMG_YN");
		
		for (int i=0; i<_data.size(); i++){
			
			Map<String, String> _map =_data.get(i);
			String _filename = _map.get("DES_FILE_NAME").toString();
			String _orgFilename = _map.get("SRC_FILE_NAME").toString();
			String _type = _map.get("TYPE").toString();
			String _del_file_dir = _map.get("DES_FILE_DIR").toString();
			if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
				_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath : CommonUtil.getUploadTypePath(_type, img_yn);
			}else{
				_path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath + "/" +_del_file_dir: CommonUtil.getUploadTypePath(_type, img_yn) + "/" +_del_file_dir;
			}
			
			file = new java.io.File(_path + "/" + _filename);
			
			 
			if (file.isFile()) {			
				_map.put("FILEYN", "FILEOK"); 
			}else{
				_map.put("FILEYN", "FILENOT"); 
			}
			 
			_data2.add(_map);
		}
		
		 
		
		pModel.addAttribute("data", _data2);
		
		if(_data.size() > 0){
			pModel.addAttribute("DOC_NO_UP", _data.get(0).get("DOC_NO"));
		}
		
		pModel.addAttribute("result", "S");
		return "/common/popup/imageFileUploadPop";
	}

	/**
	 * 이미지 파일업로드 
	 * @param pModel
	 * @param uploadForm
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/imageFileUpload.do", method = RequestMethod.POST) 
	public String  imageFileUpload(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap) {
		LOGGER.debug("fileUpload 요청 파라미터 for jsp : {}", pMap);
		
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = commonInfoService.imageFileUpload(uploadForm, pMap);
 		pModel.addAttribute("result", "U");

 		pModel.addAttribute("DOC_NO_UP", docNo);
		return "/common/popup/imageFileUploadPop";

	}
	
	/**
	 * ICOMATCH 파일 즉시 삭제 (리뉴얼 화면 전용)
	 * - 파일 업로드 후 X 버튼 클릭 시 즉시 서버에서 삭제
	 * - DB에서 완전 삭제 (DELETE)
	 *
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/deleteIcomatchFile.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteIcomatchFile(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("deleteIcomatchFile 요청 파라미터 : {}", pMap);

		Map<String, Object> response = new HashMap<String, Object>();

		try {
			// D_DOC_NO와 D_DOC_SEQ 파라미터 검증
			String docNo = pMap.get("D_DOC_NO");
			String docSeq = pMap.get("D_DOC_SEQ");

			if (docNo == null || docNo.trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "DOC_NO가 누락되었습니다.");
				return response;
			}

			if (docSeq == null || docSeq.trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "DOC_SEQ가 누락되었습니다.");
				return response;
			}

			// 서비스 호출하여 DB에서 완전 삭제
			commonInfoService.removeIcomatch(pMap);

			response.put("success", true);
			response.put("message", "파일이 성공적으로 삭제되었습니다.");

			LOGGER.info("파일 즉시 삭제 완료 - DOC_NO: {}, DOC_SEQ: {}", docNo, docSeq);

		} catch (Exception e) {
			LOGGER.error("파일 즉시 삭제 중 오류 발생", e);
			response.put("success", false);
			response.put("message", "파일 삭제 중 오류가 발생했습니다: " + e.getMessage());
		}

		return response;
	}
}

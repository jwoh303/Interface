package com.koreab2b.mro.common.coco.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.ServletOutputStream;
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

import MarkAny.MaSaferJava.Madn;

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonDrmController")
public class CommonDrmController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonDrmController.class);

	@Autowired
	private CommonInfoService commonInfoService;

	/**
	 * 파일업로드
	 * 
	 * @param pModel
	 * @param uploadForm
	 * @param pMap
	 * @return
	 */
	// @RequestMapping(value = "/common/fileUpload.do", method =
	// RequestMethod.POST)
	// public String fileUpload(HttpServletRequest request,
	// ModelMap pModel,
	// @ModelAttribute("uploadForm") FileUploadForm uploadForm,
	// @RequestParam Map<String, String> pMap) {
	// LOGGER.debug("fileUpload 요청 파라미터 for jsp : {}", pMap);
	//
	// pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
	//
	// String docNo = commonInfoService.fileUpload(uploadForm, pMap);
	// pModel.addAttribute("result", "U");
	//
	// pModel.addAttribute("DOC_NO_UP", docNo);
	// return "/common/popup/fileUploadPop";
	//
	// }

	/**
	 * 파일다운로드
	 * 
	 * @param pModel
	 * @param response
	 * @param request
	 * @param pMap
	 */
	@RequestMapping(value = "/common/drmDownload.do", method = { RequestMethod.GET, RequestMethod.POST })
	public void download(ModelMap pModel, HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("download 요청 파라미터 for jsp : {}", pMap);
		String osName = System.getProperty("os.name");

		pMap.put("IMG_YN", CommonUtil.onvl(pMap.get("IMG_YN"), "N"));
		String img_yn = pMap.get("IMG_YN");
		String _comCode	= pMap.get("COM_CODE");

		Map<String, String> _map = commonInfoService.getFileUploadDetail(pMap);
		String _filename = _map.get("DES_FILE_NAME").toString();
		String _orgFilename = _map.get("SRC_FILE_NAME").toString();
		String _type = _map.get("TYPE").toString();
		String _del_file_dir = _map.get("DES_FILE_DIR").toString();
		String _path = "";
		java.io.File file = null;
		ServletOutputStream outStream = null;
		FileInputStream inputStream = null;
		
//		String ext	= _orgFilename.substring(_orgFilename.lastIndexOf(".") + 1, _orgFilename.length() );
		
		String encFileName	= _filename +"_"+_comCode+"_enc";

		if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)) {
			_path = (osName.indexOf("Win") > -1) ? CommonUtil.localUploadPath : CommonUtil.getUploadTypePath(_type, img_yn);
		} else {
			_path = (osName.indexOf("Win") > -1) ? CommonUtil.localUploadPath + "/" + _del_file_dir : CommonUtil.getUploadTypePath(_type, img_yn)
					+ "/" + _del_file_dir;
		}
		
		String encDir	= _path+"/ENC";
		File dir	= new File(encDir);
		
		if(!dir.isDirectory()) {
			dir.mkdirs();
		}
		
		LOGGER.error("_filename : {}",  _filename);
		LOGGER.error("_del_file_dir : {}", _del_file_dir);
		LOGGER.error("_filename : {}", _filename);

		LOGGER.error("_path  {}", _path);

		try {
	        boolean bRtn    = setFileEncryption(_path, _filename, encDir, encFileName, _orgFilename,
	        		_comCode, _comCode, request.getRemoteAddr(), _filename+"_"+_comCode);
	        
	        if (bRtn == false) {
	        	throw new Exception("File Encryption Failed.");
	        } else {
	        	_filename = encFileName;
	        	_path	= encDir;
	        }

			file = new java.io.File(_path + "/" + _filename);

			LOGGER.debug("_filename 요청 파라미터 for jsp : {}", _filename);
			LOGGER.debug("_orgFilename 요청 파라미터 for jsp : {}", _orgFilename);
			LOGGER.debug("file.isFile() 요청 파라미터 for jsp : {}", file.isFile());

			if (file.isFile()) {
				byte b[] = new byte[(int) file.length()];

				outStream = null;
				inputStream = null;

				outStream = response.getOutputStream();
				inputStream = new FileInputStream(file);

				response.setContentType("application/octet-stream");
				response.setHeader("Content-Disposition", "attachment;filename=\"" + java.net.URLEncoder.encode(_orgFilename, "UTF-8") + "\"");

				byte[] outByte = new byte[4096];
				int leng = 0;
	        	while((leng = inputStream.read(b)) > 0){
		        	
		        	outStream.write(b, 0, leng);
//
//				while (inputStream.read(outByte, 0, 4096) != -1) {
//
//					outStream.write(outByte, 0, 4096);
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
				e1.printStackTrace();
			}

			LOGGER.error("download Exception {}", e);
			// LOGGER.debug("Exception : {}", e.toString());
		}

	}

	/**
	 * KEPPROJECT
	 * 
	 * @author 최진수
	 * @remark 두산 인프라코어 견적 첨부 파일 DRM 적용
	 * @date 2014-05-19
	 */
	private boolean setFileEncryption(String sPath, String sFile, String dPath, String dFile, String originFileName, String userID, String userName,
			String userLocalIp, String fileID) {
		boolean bRtn = false;
		File fIn = null;
		File fOut = null;
		long OutFileLength = 0;

		InputStream is = null;
		OutputStream os = null;
		BufferedInputStream in = null;
		BufferedOutputStream out = null;

		try {
			LOGGER.error("Drm Encryption Start......");
			fIn = new File(sPath, sFile);
			fOut = new File(dPath, dFile);

			is = new FileInputStream(fIn);
			os = new FileOutputStream(fOut);
			os.flush();

			in = new BufferedInputStream(is);
			out = new BufferedOutputStream(os);

			long beforetime = System.currentTimeMillis();

			LOGGER.error("Drm Encryption Step 0 : read MarkAnyDrmInfo.dat before");
			Madn clMadn = new Madn("/weblogic/drm/SAFER/java/MarkAnyDrmInfo.dat");
			LOGGER.error("Drm Encryption Step 0 : read MarkAnyDrmInfo.dat after");

			int tempInt = -99;

	        int piAclFlag                   = 0;                            // 0 고정
	        String pstrDocLevel             = new String("0");              // 0 고정
	        String pstrUserId               = userID;                       // 다운로드사용자계정
	        String pstrFileName             = originFileName;               // 파일명(확장자포함)
	        long plFileSize                 = fIn.length();
	        String pstrOwnerId              = new String("");
	        String pstrCompanyId            = new String("KEP-2A0D-EB84-21BF"); // 고정
	        String pstrGroupId              = ("");
	        String pstrPositionId           = ("");
	        String pstrGrade                = ("");
	        String pstrFileId               = fileID;                   // 파일아이디
	        int piCanSave                   = 0;                        // 저장가능		0
	        int piCanEdit                   = 1;                        // 편집가능		0
	        int piBlockCopy                 = 0;                        // 블럭복사방지	
	        int piOpenCount                 = 3;                        // 열람횟수제한없음	3
	        int piPrintCount                = 3;                        // 인쇄횟수제한없음	3
	        int piValidPeriod               = 7;                        // 기간제한없음		7
	        int piSaveLog                   = 1;                        // 저장로그사용
	        int piPrintLog                  = 1;                        // 인쇄로그사용
	        int piOpenLog                   = 1;                        // 열람로그사용
	        int piVisualPrint               = 1;                        // 워터마크사용
	        int piImageSafer                = 1;                        // 캡쳐방지사용
	        int piRealTimeAcl               = 0;                        // 0
	        String pstrDocumentTitle        = new String("");
	        String pstrCompanyName          = new String("KEP");        // KEP
	        String pstrGroupName            = new String("");
	        String pstrPositionName         = new String("");
	        String pstrUserName             = userName;                 // 사용자명
	        String pstrUserIp               = userLocalIp;              // 사용자PC IP
	        String pstrServerOrigin         = new String("KOREAB2B");   // 시스템명
	        int piExchangePolicy            = 1;                        // 1 고정
	        int piDrmFlag                   = 0;                        // 0 고정
	        int iBlockSize                  = 0;
	        String  strMachineKey           = new String("");
	        String  strFileVersion          = new String("");
	        String  strMultiUserID          = new String("");
	        String  strMultiUserName        = new String("");
	        String  strEnterpriseID         = new String("KEPG-8E5C-495C-FF9D");    // 고정
	        String  strEnterpriseName       = new String("");
	        String  strDeptID               = new String("");
	        String  strDeptName             = new String("");
	        String  strPositionLevel        = new String("-99");
	        String  strSecurityLevel        = new String("-99");
	        String  strSecurityLevelName    = new String("");
	        String  strPgCode               = new String("");
	        String  strCipherBlockSize      = new String("16"); // 고정
	        String  strCreatorID            = new String("");
	        String  strCreatorName          = new String("");
	        String  strOnlineContorl        = new String("0");  // 고정
	        String  strOfflinePolicy        = new String("");
	        String  strValidPeriodType      = new String("");
	        String  strUsableAlways         = new String("0");  // 고정
	        String  strPriPubKey            = new String("");
	        String  pstrCreatorCompanyId    = new String("KEP-2A0D-EB84-21BF");     //(고정)
	        String  pstrCreatorDeptId       = new String("");                       // 싸이트 접속 하신 id의 부서 이름
	        String  pstrCreatorGroupId      = new String("KEP");                    // 싸이트 접속 하신 id의  groupid  == 해당 싸이트 :KEP
	        String  pstrCreatorPositionId   = new String("");                       // 싸이트 접속 하신 직책
	        String  pstrFileSize            = Long.toString(plFileSize);            // 파일 사이즈 암호화 안된 파일사이즈
	        String  pstrHeaderUpdateTime    = Long.toString(beforetime);            // 파일 다운로드 하시는 시간 (sysdate)
	        String  pstrReserved01          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved02          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved03          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved04          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved05          = new String("0");                      // 아무정보 넣어두됨  0
	        

			LOGGER.error("Drm Encryption Step 0 : clMadn.lGetEncryptFileSize before");
			OutFileLength = clMadn.lGetEncryptFileSize(piAclFlag, pstrDocLevel, pstrUserId, pstrFileName, plFileSize,

			pstrOwnerId, pstrCompanyId, pstrGroupId, pstrPositionId, pstrGrade, // 10

					pstrFileId, piCanSave, piCanEdit, piBlockCopy, piOpenCount,

					piPrintCount, piValidPeriod, piSaveLog, piPrintLog, piOpenLog, // 20

					piVisualPrint, piImageSafer, piRealTimeAcl, pstrDocumentTitle, pstrCompanyName,

					pstrGroupName, pstrPositionName, pstrUserName, pstrUserIp, pstrServerOrigin, // 30

					piExchangePolicy, piDrmFlag, iBlockSize, strMachineKey, strFileVersion,

					strMultiUserID, strMultiUserName, strEnterpriseID, strEnterpriseName, strDeptID, // 40

					strDeptName, strPositionLevel, strSecurityLevel, strSecurityLevelName, strPgCode,

					strCipherBlockSize, strCreatorID, strCreatorName, strOnlineContorl, strOfflinePolicy, // 50

					strValidPeriodType, strUsableAlways, strPriPubKey, pstrCreatorCompanyId, pstrCreatorDeptId,

					pstrCreatorGroupId, pstrCreatorPositionId, pstrFileSize, pstrHeaderUpdateTime, pstrReserved01, // 60

					pstrReserved02, pstrReserved03, pstrReserved04, pstrReserved05, in);
			LOGGER.error("Drm Encryption Step 0 : clMadn.lGetEncryptFileSize after");

			if (OutFileLength > 0) {
				String strRetCode = clMadn.strMadn(out);
				LOGGER.error("strRetCode    : " + strRetCode);
				LOGGER.error("OutFileLength : " + OutFileLength);
				bRtn = true;

			} else {
				String strErrorCode = clMadn.strGetErrorCode();
				LOGGER.error("[ErrorCode] " + strErrorCode + " [ErrorDescription] " + clMadn.strGetErrorMessage(strErrorCode));

				bRtn = false;
			}
			LOGGER.error("Drm Encryption End......");
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(e.getMessage());
		} finally {

			if (is != null)
				try {
					is.close();
				} catch (Exception e) {
				}
			;
			if (os != null)
				try {
					os.close();
				} catch (Exception e) {
				}
			;

			// is.flush();
			// os.flush();
		}

		return bRtn;
	}
}

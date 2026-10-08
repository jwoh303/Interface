<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.poi.ss.usermodel.Workbook" %>
<%@ page import="com.ibleaders.ibsheet7.ibsheet.excel.Down2Excel" %>
<%@ page import="MarkAny.MaSaferJava.Madn" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import= "com.ibleaders.ibsheet7.util.Common" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%!
/**
 * KEPPROJECT
 * 
 * @author 한승준
 * @remark 그리드 우클릭 엑셀파일저장 시 DRM 적용
 * @date 2015-10-02
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
		System.out.println("Drm Encryption Start......");
		fIn = new File(sPath, sFile);
		fOut = new File(dPath, dFile);
		
		is = new FileInputStream(fIn);
		os = new FileOutputStream(fOut);
		
		os.flush();

		in = new BufferedInputStream(is);
		out = new BufferedOutputStream(os);

		long beforetime = System.currentTimeMillis();

		System.out.println("Drm Encryption Step 0 : read MarkAnyDrmInfo.dat before");
		Madn clMadn = new Madn();
		
		String osName1 = System.getProperty("os.name");
		if (osName1.indexOf("Win") > -1){
			clMadn = new Madn("D:/project/MRO_PJT/workspace/MRO/src/main/webapp/resources/drm/MarkAnyDrmInfo.dat");
		} else {
			clMadn = new Madn("/webContents/mro/resources/drm/MarkAnyDrmInfo.dat");
		}
		
		System.out.println("Drm Encryption Step 0 : read MarkAnyDrmInfo.dat after");

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
        int piCanSave                   = 1;                        // 저장가능		0
        int piCanEdit                   = 1;                        // 편집가능		0
        int piBlockCopy                 = 1;                        // 블럭복사방지	
        int piOpenCount                 = -99;                        // 열람횟수제한없음	3
        int piPrintCount                = -99;                        // 인쇄횟수제한없음	3
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
        

		System.out.println("Drm Encryption Step 0 : clMadn.lGetEncryptFileSize before");
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
		System.out.println("Drm Encryption Step 0 : clMadn.lGetEncryptFileSize after");

		if (OutFileLength > 0) {
			String strRetCode = clMadn.strMadn(out);
			System.out.println("strRetCode    : " + strRetCode);
			System.out.println("OutFileLength : " + OutFileLength);
			bRtn = true;

		} else {
			String strErrorCode = clMadn.strGetErrorCode();
			System.out.println("[ErrorCode] " + strErrorCode + " [ErrorDescription] " + clMadn.strGetErrorMessage(strErrorCode));

			bRtn = false;
		}
		System.out.println("Drm Encryption End......");
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println(e.getMessage());
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
%>
<%
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String user_id = CommonUtil.nvl((String)_sessionInfo.getUserId());
	// DRM 예외 사용자 리스트(ex 물류센터 직원)
	String com_code = CommonUtil.nvl((String)_sessionInfo.getComCode());
	String p01103202 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1032-02","COL01_DATA");
	String pass_ok = "N";
	
	// 고객사, 협력사 그리드 이용 시 엑셀다운로드 DRM 제외
	String com_business_cond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
	if("S".equals(com_business_cond) || "B".equals(com_business_cond)){
		pass_ok = "Y";
	}
	
	
	
	//====================================================================================================
	// [ 사용자 환경 설정 #0 ]
	//====================================================================================================
	// 대용량 엑셀파일 다운로드를 하는 경우 메모리가 부족한 상황이 생긴다면 
	// Down2Excel ibExcel = new Down2Excel(true); //형식으로 사용해 주세요.
	// 메모리를 절약해서 엑셀파일을 생성합니다만 reportXML 사용이 제한됩니다.
	// 메모리 부족 사유가 없다면 옵션을 주지 않는 것이 좋습니다.
	//====================================================================================================
	Down2Excel ibExcel = new Down2Excel();
	ibExcel.setService(request, response);

	String _path = "";
	java.io.File file = null;
	ServletOutputStream outStream = null;
	FileInputStream inputStream = null;
	
	Common ibcomm = new Common();
	
	//System.out.println(com.ibleaders.ibsheet7.util.Version.getVersion());

	//====================================================================================================
	// [ 사용자 환경 설정 #1 ]
	//====================================================================================================
	// Html 페이지의 엔코딩이 utf-8 로 구성되어 있으면 "ibExcel.setPageEncoding("utf-8");" 로 설정하십시오.
	// 엑셀 문서의 한글이 깨지면 이 값을 공백("")으로 바꿔 보십시오.
	// LoadExcel.jsp 도 동일한 값으로 바꿔 주십시오.
	//====================================================================================================
	ibExcel.setPageEncoding("utf-8");


	//====================================================================================================
	// [ 사용자 환경 설정 #2 ]
	//====================================================================================================
	// 엑셀에 포함될 이미지의 URL 에 가상폴더를 사용할 경우가 조금이라도 있다면 웹루트를 아래 변수에 직접 지정해 주십시오.
	// 엑셀에 포함될 이미지에 가상폴더를 사용하지 않으면 설정하지 마세요.
	//====================================================================================================
	String osName = System.getProperty("os.name");
	String webRootPath = (osName.indexOf("Win") > -1)?"c:/temp" : "/webContents/tmp/";
	ibExcel.setWebRoot(webRootPath);
	ibExcel.setTempRoot(webRootPath);

	//====================================================================================================
	// [ 사용자 환경 설정 #3 ]
	//====================================================================================================
	// 트리 컬럼에서 레벨별로 … 를 덧붙여서 레벨별로 보기 좋게 만듭니다.
	// 만약 … 대신 다른 문자를 사용하기를 원하시면 아래 유니코드 \u2026 (16진수형태) 대신 다른 문자를 입력하십시오.
	// 트리 컬럼이 없으면 설정하지 마세요.
	//====================================================================================================
	ibExcel.setTreeChar("\u2026");

	//====================================================================================================
	// [ 사용자 환경 설정 #4 ]
	//====================================================================================================
	// 기본 폰트 이름과 폰트 크기를 설정합니다.
	// SheetDesign : 0 을 사용하는 경우에만 적용됩니다.
	//====================================================================================================
	ibExcel.setDefaultFontName("맑은고딕");
	ibExcel.setDefaultFontSize((short)10);

	//====================================================================================================
	// [ 사용자 환경 설정 #5 ]
	//====================================================================================================
	// IBSheet의 폰트 이름, 폰트 크기를 사용하지 않고 다음에서 설정한 값으로 강제적으로 적용합니다.
	// SheetDesign : 1, 2 를 사용하는 경우에만 적용됩니다.
	// 사용하지 않으시려면 주석처리 하세요.
	// 
	//ibExcel.setFontName("궁서");
	//ibExcel.setFontSize((short)15);

	//====================================================================================================
	// [ 사용자 환경 설정 #6 ]
	//====================================================================================================
	// 줄바꿈 설정을 다음에서 설정한 값으로 강제적으로 적용합니다.
	// 사용하지 않으시려면 주석처리 하세요.
	// 
	//ibExcel.setWordWrap(false);

	//====================================================================================================
	// [ 사용자 환경 설정 #7 ]
	//====================================================================================================
	// 엑셀에 포함될 이미지의 URL 이 다른 도메인에 있고 함께 다운로드 받으려면 다음을 설정합니다.
	// 기본값은 false 이며 다른 도메인에 존재하는 이미지는 다운로드 받지 않습니다.
	//ibExcel.setAllowDownloadRemoteImg(true);

	//====================================================================================================
	// [ 사용자 환경 설정 #8 ]
	//====================================================================================================
	// 엑셀에 포함될 이미지의 URL 이 같은 도메인에 있지만 "/image/imgDown.jsp?idx=365" 등과 같은 
	// 이미지 로딩 방식을 사용한다면 웹서버 도메인을 설정하세요.
	//ibExcel.setWebServerDomain("http://www.ibleaders.co.kr");
	
	//====================================================================================================
	// [ 사용자 환경 설정 #9 ]
	//====================================================================================================
	// 엑셀 다운로드 시 서버에 위치한 디자인 파일을 사용하는 경우 디자인 파일이 있는 폴더 위치를 설정하세요.
	// 디자인 파일을 사용하지 않는 경우 주석처리하세요.
	//====================================================================================================
	//String tempRoot = "D:/SVN/src/IBSheet7.TestPage";
	//ibExcel.setTempRoot(tempRoot);
	
	//====================================================================================================
	// [ 사용자 환경 설정 #10 ]
	//====================================================================================================
	// 엑셀 다운로드 시 헤더행의 글자색을 설정하고 싶은 경우에 설정하세요.
	// #3366FF 형태의 웹 컬러로 설정해주세요.
	// 설정을 원하지 않는 경우 주석처리해주세요.
	//====================================================================================================
	ibExcel.setHeaderFontColor("#3366FF");

	try {
		response.reset(); 

		// 파라메터 정보를 얻음
		String data = ibExcel.getData();

		// 파라메터 정보를 다시 설정함 (예, 암호화된 파라메터를 복호화 처리를 하여 다시 설정)
		ibExcel.setData(data);
		
		// ExtendParam 사용 가능
		//String exParam = ibExcel.getExtendParam();

		// 엑셀 워크북을 생성
		Workbook workbook = ibExcel.makeExcel();

		// 물류센터 직원들은 엑셀 다운 시 DRM 미설치로 암호화 제외
		if (!"".equals(p01103202)){
			String grant[] = p01103202.split("\\^");
			if (grant != null){
				if (grant.length>0){
					for (int i=0; i<grant.length; i++){
						if (user_id.equals(grant[i])){
							pass_ok = "Y";
						}
					}
				}
			}
		}
		
		// DRM 예외 사용자이면
		if("Y".equals(pass_ok)){
			
			// 다운로드 1. 생성된 엑셀 문서를 바로 다운로드 받음
			ServletOutputStream out2 = response.getOutputStream();
			workbook.write(out2);
			out2.flush();
		}
		// 물류센터 직원 제외 엑셀다운 시 DRM 적용
		else{
			// 다운로드 2. 생성된 엑셀 문서를 서버에 저장
			// 다운로드 받을 파일 이름을 얻음
			
			// 파일명에 시스템 시간 이용 시 사용
			long sysTime = System.currentTimeMillis();
			
			String fileName = user_id+"_"+sysTime+".xlsx";;
			
			// 확장자 추출(파일명 만들기 위하여)
			String inFileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
			
			FileOutputStream out2 = new FileOutputStream (webRootPath + "/" + fileName);
			workbook.write(out2);
			out2.close();
			
			String orgFile = webRootPath + "/" + fileName;
			String encDir	= webRootPath;
			
			// 최종 out파일명
			String encFileName = (fileName.substring(0, fileName.lastIndexOf(".")) + "_enc." + inFileExt);
			
			String _orgFilename	= ibExcel.getDownloadFileName();
			
			boolean bRtn    = setFileEncryption(webRootPath, fileName, encDir, encFileName, _orgFilename,
					user_id, user_id, request.getRemoteAddr(), encFileName);
	        
	        if (bRtn == false) {
	        	throw new Exception("File Encryption Failed.");
	        }    
			
			
	     // 생성된 엑셀 문서를 다운로드 받음 (예, 엑셀문서를 DRM 처리함)
	   		file = new File( encDir + "/" + encFileName );
			int fileLength = (int)file.length();

			response.setContentLength((int)file.length());

			try {
				if (file.isFile()) {
					byte[] outputByte = new byte[(int) file.length()];
					
					outStream = null;
					inputStream = null;
					
					inputStream = new FileInputStream(file);
					outStream = response.getOutputStream();
					
					int leng = 0;
		        	while((leng = inputStream.read(outputByte)) > 0){
		        		outStream.write(outputByte, 0, leng);
		        	}

		        	inputStream.close();
					outStream.flush();
					outStream.close();
				} 
			} finally {
				file.delete();
			}

			// DRM 암호화되지 않은 임시 생성파일은 삭제
				ibcomm.mDeleteFile(orgFile);
		}
		
		
		
		// 파일 정상 다운로드시 아래 구문을 실행하지 않으면 서버 Servlet에서  java.lang.IllegalStateException 이 발생한다.
		// 파일 최 하단에서 호출하도록 하면 다운로드 에러로 인한 Exception 메시지가 출력되지 않으므로 정상 다운시에만 처리하도록 한다.
		out.clear();
		out = pageContext.pushBody();
	} catch (Exception e) {
		out.println("<script>alert('엑셀 다운로드중 에러가 발생하였습니다.'); history.back();</script>");
		
		e.printStackTrace();
	} catch (Error e) {
		out.println("<script>alert('엑셀 다운로드중 에러가 발생하였습니다.'); history.back();</script>");

		e.printStackTrace();
	}
%>

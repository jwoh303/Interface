<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*" %>
<%@ page import="com.ibleaders.ibsheet7.ibsheet.excel.LoadExcel" %>
<%@ page import="com.ibleaders.ibsheet7.util.LoadExcelCallbackInterface" %>

<%@ page import="MarkAny.MaSaferJava.Madec" %>
<%@ page import="MarkAny.MaSaferJava.Madn" %>
<%@ page import= "com.ibleaders.ibsheet7.util.Common" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%!
public String setFileDecryption(String sPath) {
	
	BufferedInputStream in = null;
	BufferedOutputStream out = null;
	Madec clMadec = null;
	long lFileLen = 0;
	long OutFileLength = 0;
	
	// Sample Parameter
	String bRtn = "";

	// 확장자 추출
	String inFileExt = sPath.substring(sPath.lastIndexOf(".") + 1).toLowerCase();
	// System.out.println("inFileExt = " + inFileExt);
	
	// 최종 out파일명
	String outFileName = (sPath.substring(0, sPath.lastIndexOf(".")) + "_out." + inFileExt);
	// System.out.println("outFileName = " + outFileName);
	
	File FileSample = new File(sPath);
	File FileOut = new File(outFileName);
	
	// System.out.println("DBG streamDec_FileSample length = " + FileSample.length());
	
	if( FileSample.length() == 0 ) {
		/*
		System.out.println("ERR streamDec_FileSample length is zero.");
		System.out.println("ERR Terminate.");
		*/
	}
	
	try {
		in = new BufferedInputStream(new FileInputStream(FileSample));
		out = new BufferedOutputStream(new FileOutputStream(FileOut));
	} catch (Exception e) {
	}

	// create instance
	try {
		String osName1 = System.getProperty("os.name");
		if (osName1.indexOf("Win") > -1){
			clMadec = new Madec("D:/project/MRO_PJT/workspace/MRO/src/main/webapp/resources/drm/MarkAnyDrmInfo.dat");
		} else {
			clMadec = new Madec("/webContents/mro/resources/drm/MarkAnyDrmInfo.dat");
		}
		
	} catch (Exception e) {
	}

	lFileLen = FileSample.length();

	//long beforetime = System.currentTimeMillis();

	// only file
	OutFileLength = clMadec.lGetDecryptFileSize(sPath, lFileLen, in);
	
	// System.out.println("DBG OutFileLength = " + OutFileLength);

	if (OutFileLength > 0) {
		 
	//	System.out.println("DBG Decryption - Start!!!! \n ");
		String strRetCode = clMadec.strMadec(out);
	//	System.out.println("DBG return code = " + strRetCode);
	//	System.out.println("DBG Decryption - End!!!! \n ");
		
		bRtn = strRetCode;
		
	} else {
		String strErrorCode = clMadec.strGetErrorCode();
	/*	System.out.println("ERR [ErrorCode] " + strErrorCode
				+ " [ErrorDescription] "
				+ clMadec.strGetErrorMessage(strErrorCode));
	*/	
		bRtn = strErrorCode;
	}
	
	//String numberAsString = new DecimalFormat("0.00").format((System.currentTimeMillis() - beforetime) * 0.001);
	//System.out.println("DBG Decrypt time: " + numberAsString + "sec");

	try {
		if (in != null)
			in.close();
		if (out != null)
			out.close();
	} catch (Exception e) {
	}
	
	
	return outFileName;
}
%>
<%
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String user_id = CommonUtil.nvl((String)_sessionInfo.getUserId());
	String business_cond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());

	LoadExcel ibExcel = new LoadExcel();
	Common ibcomm = new Common();
	ibExcel.setService(request, response);

	System.out.println(com.ibleaders.ibsheet7.util.Version.getVersion());

    //====================================================================================================
    // [ 사용자 환경 설정 #1 ]
    //====================================================================================================
    // Html 페이지의 엔코딩이 utf-8 로 구성되어 있으면 "ibExcel.setPageEncoding("utf-8")" 로 설정하십시오.
    // 한글 헤더가 있는 그리드에서 엑셀 로딩이 동작하지 않으면 이 값을 바꿔 보십시오.
    // Down2Excel.jsp 에서의 설정값과 동일하게 바꿔주십시오.
    //====================================================================================================
	ibExcel.setPageEncoding("utf-8");

    //====================================================================================================
    // [ 사용자 환경 설정 #2 ]
	//====================================================================================================
	// LoadExcel 용도의 엑셀파일을 업로드하여 임시보관할 임시폴더경로를 지정해 주십시오.
	// 예 : "C:/tmp/"   "/usr/tmp/"
	//====================================================================================================
	String osName = System.getProperty("os.name");
	if (osName.indexOf("Win") > -1){
		ibExcel.setTempFolder("d:/");
	} else {
		ibExcel.setTempFolder("/webContents/tmp/");
	}
	
    //====================================================================================================
    // [ 사용자 환경 설정 #3 ]
	//====================================================================================================
	// LoadExcel 처리를 허용할 최대 행수를 설정한다.
	// 엑셀 데이터가 지정한 행 수보다 많은 경우 메시지를 출력하고 처리가 종료된다.
	//====================================================================================================
	ibExcel.setMaxRows(30000);

    //====================================================================================================
    // [ 사용자 환경 설정 #4 ]
	//====================================================================================================
	// HeaderMatch 사용 시 시트에 있는 헤더가 엑셀에 하나라도 존재하지 않는 경우 오류메시지를 출력하고 데이터를 로딩하지 않을지 여부.
	//====================================================================================================
	// ibExcel.setStrictHeaderMatch(true);	


	try {
		String frm = ibExcel.getLoadFrm();

		if ("".equals(frm)) {
			// 서버에 저장된 파일명
			String uploadFileName = ibExcel.getUploadFileName();

			//	System.out.println("uploadFileName : " + uploadFileName);
			//	System.out.println("user_id : " + user_id);
			
			String uploadFileNameOrg = "";
	     	String outFileName = "";		

	     	if(business_cond.equals("B") || business_cond.equals("S")){ // 고객사 장바구니 엑셀업로드를 위하여 DRM 미사용 20180219 HSJ, 협력사 엑셀 업로드 대비 추가 20201106 HSJ
	   				
	   				// System.out.println("uploadFileName : " + uploadFileName);

	   				// TODO
	   				// 업로드된 엑셀 파일을 가공함 (예, 엑셀문서를 DRM 처리함)

	   				// 사용자가 업로드한 파일명
	   				uploadFileNameOrg = ibExcel.getUploadFileNameOrg();

	   				out.print(ibExcel.LoadExcelFile());
	   				
	   		}else{
	   		// TODO
				// 업로드된 엑셀 파일을 가공함 (예, 엑셀문서를 DRM 처리함)
				outFileName = setFileDecryption(uploadFileName);

				// 업로드된 엑셀 파일을 가공함 (예, 엑셀문서를 DRM 처리함)
	            // 서버에 저장한 파일명을 리네임해서 리턴해 줌
	            //1. api 호출하면서 다은이름으로 저장 하고, 파일명 리턴
	            //2. ibExcel.setFileName(fullSaveFileName) -> 변경된 파일명 다시 셋팅
	            //3. 초기 아이비시트에서 만든 파일도 삭제 해줌(디렉토리/파일명)
	            
	            // DRM 복호화 된 out 파일 읽도록 세팅
				ibExcel.setFileName(outFileName);

	            // DRM 암호화 되어 있던 임시 생성파일은 삭제
	  			ibcomm.mDeleteFile(uploadFileName);
	            
				// 사용자가 업로드한 파일명
				uploadFileNameOrg = ibExcel.getUploadFileNameOrg();

				//	System.out.println("uploadFileNameOrg : " + uploadFileNameOrg);
				
				out.print(ibExcel.LoadExcelFile());
	   		}
		} else {
			out.print(frm);
		}
	} catch(Exception e) {
		out.println("<script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[0].LoadExcelError(); </script>");

		e.printStackTrace();
	} catch (Error e) {
		out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[0].LoadExcelError(); }catch(e){}</script>");

		e.printStackTrace();
	}
%>

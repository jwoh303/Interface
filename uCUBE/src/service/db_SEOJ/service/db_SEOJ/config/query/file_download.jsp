<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.Vector"%>
<%@ page import="Wisehub.Lib.FileUpload.*"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.naming.*;"%>
<%@ page import="javax.ejb.*;"%>
<%@ page import="java.rmi.RemoteException;"%>
<%@ page import="javax.rmi.PortableRemoteObject;"%>
<%@ page import="java.rmi.Remote;"%>
<%@ page import="java.util.*;"%>
<%@ page import="java.text.*;"%>
<%@ page import="javax.servlet.*;"%>
<%@ page import="java.sql.*"%>
<%@ page import="Wisehub.Lib.Utility.*;"%>
<%@ page import="Wisehub.Lib.String.*;"%>
<%@ page import="Wisehub.Lib.Date.*;"%>
<%@ page import="Wisehub.Lib.DataBase.*;"%>
<%@ page import="Wisehub.Lib.Context.*;"%>
<%@ page import="Wisehub.Lib.Properties.*;"%>
<%@ page import="Wisehub.Lib.Sql.*;"%>
<%@ page import="wisehub.lib.common.*;"%>

<%@ page import="java.text.DecimalFormat;"%>
<%@ page import="MarkAny.MaSaferJava.Madn;"%>

<% String WisehubNext =""; //반드시 선언한다.  %>
<%@ include file="/kr/buyer/common/include/WisehubSessionInfo.ini" %>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<jsp:useBean id="WiseConfig" scope="request" class="Wisehub.Lib.Properties.WisehubProperties" />

<%!

public String null2sp(String str) {
    if ( str == null || str == "" || str == "null" || str.equals("") || str.equals("null") || str.equals(null)) return "";
    else return str;
}

public Vector getAttfileName(String type, String doc_no, String doc_seq) throws RemoteException {
    Connection conn = null;
    ResultSet rs = null;
    PreparedStatement pstmt = null;

    String SQL = null;
    StringBuffer sbf = new StringBuffer();
    String value = null;
    Vector v = new Vector();

    try
    {
        conn = WisehubDBConnect.WisehubDBConnect("oracleDataSource");

        sbf.append("SELECT SRC_FILE_NAME FROM ICOMATCH  \n");
        sbf.append("WHERE TYPE='$'                      \n");
        sbf.append("AND DOC_NO='$'                      \n");
        sbf.append("AND DOC_SEQ='$'                     \n");

        String pFixstr[]  = { type, doc_no, doc_seq };
        String pVarstr[]  = { };

        SQL = WisehubSql.WiseSqlParse(sbf.toString(), pFixstr, pVarstr);
        //System.out.println(SQL);
        pstmt = conn.prepareStatement(SQL);
        rs = pstmt.executeQuery();

        ResultSetMetaData metadata = rs.getMetaData();
        int cln_cnt = metadata.getColumnCount();

        while(rs.next())
        {
            Object obj[] = new Object[cln_cnt];
            for(int i=0; i < cln_cnt; i++)
            {
                Object rsobj = null;
                rsobj = rs.getObject(i+1);

                value = String.valueOf(rsobj);

                if(value.equals(""))
                    value="";

                obj[i]=(Object)value;
            }

            v.addElement((Object[])obj);
        }

    }catch(java.lang.Exception e)
    {
        e.printStackTrace();
    }finally
    {
        try
        {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();

        }catch (Exception e)
        {
            e.printStackTrace();
        }

        return v;
    }
}

/**
 * 파일복사
 * 2014-03-25 최진수
 */
public void copyFile(String sPath, String sFile, String dPath, String dFile) {
	File fIn	= null;
	File fOut	= null;

	InputStream is	= null;
	OutputStream os	= null;

	try {
		fIn		= new File(sPath, sFile);
		fOut	= new File(dPath, dFile);

		is	= new FileInputStream(fIn);
		os	= new FileOutputStream(fOut);

		byte[] buf = new byte[1024];
		int len = 0;

		while((len = is.read(buf)) > 0){
			os.write(buf,0,len);
		}
	}
	catch(Exception e) {
		e.printStackTrace();
	}
	finally {
		if(is != null) try{is.close();}catch(Exception e){};
		if(os != null) try{os.close();}catch(Exception e){};
	}
}

/**
 * 암호화 함수
 * 2014-03-26 최진수
 * Return : 성공_true, 실패_false
 */
public boolean setFileEncryption(String sPath, String sFile,
								String dPath, String dFile,
								String originFileName, String userID, String userName,
								String userLocalIp, String fileID) {
	boolean bRtn		= false;
	File fIn			= null;
	File fOut			= null;
	long OutFileLength	= 0;

	InputStream is				= null;
	OutputStream os				= null;
	BufferedInputStream in		= null;
	BufferedOutputStream out	= null;

	try {
		fIn		= new File(sPath, sFile);
		fOut	= new File(dPath, dFile);

		is	= new FileInputStream(fIn);
		os	= new FileOutputStream(fOut);

		in	= new BufferedInputStream(is);
		out	= new BufferedOutputStream(os);

		long beforetime = System.currentTimeMillis();

		Madn clMadn		= new Madn("/weblogic/drm/SAFER/java/MarkAnyDrmInfo.dat");

		int piAclFlag					= 0; 							// 0 고정
		String pstrDocLevel				= new String("0");				// 0 고정
		String pstrUserId				= userID;						// 다운로드사용자계정
		String pstrFileName				= originFileName;				// 파일명(확장자포함)
		long plFileSize					= fIn.length();
		String pstrOwnerId				= new String("");
		String pstrCompanyId			= new String("KEP-2A0D-EB84-21BF");	// 고정
		String pstrGroupId				= ("");
		String pstrPositionId			= ("");
		String pstrGrade				= ("");
		String pstrFileId				= new String("20100804165120000");	// 파일아이디
		int piCanSave					= 1;						// 저장가능
		int piCanEdit					= 1;						// 편집가능
		int piBlockCopy					= 0;						// 블럭복사방지
		int piOpenCount					= 5;						// 열람횟수제한없음
		int piPrintCount				= 5;						// 인쇄횟수제한없음
		int piValidPeriod				= 5;						// 기간제한없음
		int piSaveLog					= 1;						// 저장로그사용
		int piPrintLog					= 1;						// 인쇄로그사용
		int piOpenLog					= 1;						// 열람로그사용
		int piVisualPrint				= 1;						// 워터마크사용
		int piImageSafer				= 1;						// 캡쳐방지사용
		int piRealTimeAcl				= 0; 						// 0
		String pstrDocumentTitle		= new String("");
		String pstrCompanyName			= new String("KEP");		// KEP
		String pstrGroupName			= new String("");
		String pstrPositionName			= new String("");
		String pstrUserName				= userName;					// 사용자명
		String pstrUserIp				= userLocalIp;				// 사용자PC IP
		String pstrServerOrigin			= new String("KOREAB2B");	// 시스템명
		int piExchangePolicy			= 1;						// 1 고정
		int piDrmFlag					= 0;						// 0 고정
		int	iBlockSize					= 0;
		String	strMachineKey			= new String("");
		String  strFileVersion			= new String("");
		String  strMultiUserID			= new String("");
		String  strMultiUserName		= new String("");
		String  strEnterpriseID			= new String("KEPG-8E5C-495C-FF9D");	// 고정
		String  strEnterpriseName		= new String("");
		String  strDeptID				= new String("");
		String  strDeptName				= new String("");
		String  strPositionLevel		= new String("");
		String  strSecurityLevel		= new String("");
		String  strSecurityLevelName	= new String("");
		String  strPgCode				= new String("");
		String  strCipherBlockSize		= new String("16");	// 고정
		String  strCreatorID			= new String("");
		String  strCreatorName			= new String("");
		String  strOnlineContorl		= new String("0");	// 고정
		String  strOfflinePolicy		= new String("");
		String  strValidPeriodType		= new String("");
		String  strUsableAlways			= new String("0");	// 고정
		String  strPriPubKey			= new String("");
		String  pstrCreatorCompanyId	= new String("KEP-2A0D-EB84-21BF");		//(고정)
		String  pstrCreatorDeptId		= new String("");						// 싸이트 접속 하신 id의 부서 이름
		String  pstrCreatorGroupId		= new String("KEP");					// 싸이트 접속 하신 id의  groupid  == 해당 싸이트 :KEP
		String  pstrCreatorPositionId	= new String("");						// 싸이트 접속 하신 직책
		String  pstrFileSize			= Long.toString(plFileSize);			// 파일 사이즈 암호화 안된 파일사이즈
		String  pstrHeaderUpdateTime	= Long.toString(beforetime);			// 파일 다운로드 하시는 시간 (sysdate)
		String  pstrReserved01			= new String("0");						// 아무정보 넣어두됨  0
		String  pstrReserved02			= new String("0");						// 아무정보 넣어두됨  0
		String  pstrReserved03			= new String("0");						// 아무정보 넣어두됨  0
		String  pstrReserved04			= new String("0");						// 아무정보 넣어두됨  0
		String  pstrReserved05			= new String("0");						// 아무정보 넣어두됨  0

		OutFileLength =
			clMadn.lGetEncryptFileSize
			(
			piAclFlag,
			pstrDocLevel,
			pstrUserId,
			pstrFileName,
			plFileSize,

			pstrOwnerId,
			pstrCompanyId,
			pstrGroupId,
			pstrPositionId,
			pstrGrade,			// 10

			pstrFileId,
			piCanSave,
			piCanEdit,
			piBlockCopy,
			piOpenCount,

			piPrintCount,
			piValidPeriod,
			piSaveLog,
			piPrintLog,
			piOpenLog,			// 20

			piVisualPrint,
			piImageSafer,
			piRealTimeAcl,
			pstrDocumentTitle,
			pstrCompanyName,

			pstrGroupName,
			pstrPositionName,
			pstrUserName,
			pstrUserIp,
			pstrServerOrigin,	// 30

			piExchangePolicy,
			piDrmFlag,
			iBlockSize,
			strMachineKey,
			strFileVersion,

			strMultiUserID,
			strMultiUserName,
			strEnterpriseID,
			strEnterpriseName,
			strDeptID,			// 40

			strDeptName,
			strPositionLevel,
			strSecurityLevel,
			strSecurityLevelName,
			strPgCode,

			strCipherBlockSize,
			strCreatorID,
			strCreatorName,
			strOnlineContorl,
			strOfflinePolicy,	// 50

			strValidPeriodType,
			strUsableAlways,
			strPriPubKey,
			pstrCreatorCompanyId,
			pstrCreatorDeptId,
			
			pstrCreatorGroupId,
			pstrCreatorPositionId,
			pstrFileSize,
			pstrHeaderUpdateTime,
			pstrReserved01,		// 60

			pstrReserved02,
			pstrReserved03,
			pstrReserved04,
			pstrReserved05,

			in
			);

		if (OutFileLength > 0) {
			String strRetCode = clMadn.strMadn(out);
			System.out.println(strRetCode);
			bRtn = true;

		} else {
			String strErrorCode = clMadn.strGetErrorCode();
			System.out.println("[ErrorCode] " + strErrorCode
					+ " [ErrorDescription] "
					+ clMadn.strGetErrorMessage(strErrorCode));

			bRtn = false;
		}
	}
	catch (Exception e) {
	}
	finally {
		if(is != null) try{is.close();}catch(Exception e){};
		if(os != null) try{os.close();}catch(Exception e){};
	}

	return bRtn;
}
%>

<%
    WisehubUpload Wiseupload		= null;
    WisehubProperties Properties	= new WisehubProperties();

    String viewloc	= request.getParameter("viewloc");	// SERVER에 저장된 파일명
    String type		= null2sp(request.getParameter("type"));
    String doc_no	= null2sp(request.getParameter("doc_no"));
    String doc_seq	= null2sp(request.getParameter("doc_seq"));
	String buyer	= null2sp(request.getParameter("buyer"));

    String down_root	=Properties.getNameValue("wisehub.attach.path."+request.getParameter("type"));	 // 다운로드 상위 디렉토리 경로

    Vector v				= getAttfileName(type, doc_no, doc_seq);
    Object[] rtobj			= (Object[])v.elementAt(0);
    String file_name		= String.valueOf(rtobj[0]);	// 원본파일명.
    String file_location	= down_root+"/"+viewloc;

    InputStream in			= null;
    OutputStream os			= null;

	String com_code	= Wsession.getCompanyCode();
	String userID	= Wsession.getUserId();
	String userName	= Wsession.getUserNameLoc();

    try
    {

		/**
		 * 2014-03-25 최진수
		 * DRM API 적용
		 */
		// DRM 적용대상
/*
System.out.println("com_code : " + com_code);
System.out.println("userID : " + userID);
System.out.println("userName : " + userName);
System.out.println("Remote Addr: " + request.getRemoteAddr());
System.out.println("Remote Host: " + request.getRemoteHost());
System.out.println("X-Forwarded-For: " + request.getHeader("x-forwarded-for"));

		System.out.println("tempFile     : " + tempFile);
		System.out.println("tempFileName : " + tempFileName);
		System.out.println("tempFileExt  : " + tempFileExt);
*/

		if("KRKEPB0004|".indexOf(buyer) > -1) {

			String encDir	= down_root+"/ENC";
			File dir		= new File(encDir);

			if(!dir.isDirectory()) {
				dir.mkdirs();
			}
			

			String encFileName	= "";
			String tempFile	= viewloc;
			String tempFileName	= tempFile.substring(0,tempFile.lastIndexOf("."));
			String tempFileExt	= tempFile.substring(tempFile.lastIndexOf(".")+1,tempFile.length());

			encFileName	= tempFileName+"_"+com_code+"_enc."+tempFileExt;

			boolean bRtn	= setFileEncryption(down_root, viewloc, encDir, encFileName, file_name,
												userID, userName, request.getRemoteAddr(), tempFileName+"_"+com_code);

			if(bRtn == false) {
				throw new Exception("File Encryption Failed.");
			}
			else {
				down_root	= encDir;
				viewloc		= encFileName;
			}
		}

        File file = new File(down_root, viewloc );
        in = new FileInputStream(file);

        response.reset() ;
        response.setContentType("application/smnet");
        response.setHeader ("Content-Disposition", "attachment; filename=\"" + new String(file_name.getBytes(),"ISO8859_1")+"\"" );
        response.setHeader ("Content-Length", ""+file.length() );
        os = response.getOutputStream();
        byte b[] = new byte[(int)file.length()];
        int leng = 0;
        while( (leng = in.read(b)) > 0 ){
            os.write(b,0,leng);
        }

    } catch(Exception e) {
        System.out.println(e);
		e.printStackTrace();
    }finally{
        if(in !=null)try{in.close();}catch(Exception e){}
        if(os !=null)try{os.close();}catch(Exception e){}
    }
%>
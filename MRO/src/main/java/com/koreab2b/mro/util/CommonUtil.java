package com.koreab2b.mro.util;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.nio.file.Files;
import java.security.MessageDigest;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.SimpleTimeZone;
import java.util.StringTokenizer;

import javax.imageio.ImageIO;
import javax.media.jai.JAI;
import javax.media.jai.RenderedOp;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.IOUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.MultiValueMap;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;


public class CommonUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonUtil.class);
	
	/**
	 * 파일업로드할 
	 */
	public static final String localUploadPath = "C:/kepFileUplad"; // 로컬 파일업로드 대상
	public static final String realUploadPath = "attfiles"; // 개발,리얼 파일업로드 대상 
	public static final String realImgUploadPath = ""; // 개발,리얼 상품이미지 대상
	public static final String realImgS3UploadPath = "https://keps3.koreab2b.com"; // 개발,리얼 상품이미지 대상
	public static final String realImgUploadRegisterPath = "ITEM_IMAGE"; // 개발,리얼 상품이미지 대상
	public static final String realCbcPath = "/resources/drm/kep"; // 개발,리얼 파일업로드 대상
	public static final String realImgUploadProfilePath = "BUYER_PROFILE"; // 개발,리얼 고객사 프로파일 첨부이미지
	
	public static final String dateGubun = "/";
	private static String JID="";
	private static String SESSION_PASS_FLAG="";
	/**
	 * 이미지파일 최상위 경로
	 */
	public static final String ImgRootlocal = "/resources/images";
	public static final String ImgRootServer = "/attfiles";
	/**
	 * DRM 복호화에 사용할 dat 파일경로 
	 */
	// DRM 일괄업로드 시 MarkAnyDrmInfo.dat 경로. 로컬은 다음 경로와 일치해야 합니다.
	public static final String DrmDatLocalPath = "d:/project/MRO_PJT/workspace/MRO/src/main/webapp/resources/drm/MarkAnyDrmInfo.dat";
	// DRM 일괄업로드 시 MarkAnyDrmInfo.dat 서버경로
	public static final String DrmDatServerPath = "/webContents/mro/resources/drm/MarkAnyDrmInfo.dat";
	/**
	 * 해당 타입의 업로드 폴더를 리턴한다.
	 * @param type
	 * @return
	 */
	public static String getUploadTypePath(String type, String img_yn){
		
		String folder = "";
		if ("Y".equals(img_yn)){
			folder = realImgUploadRegisterPath;
		}else{
			if ("PR".equals(type)){
				folder = realUploadPath +"/"+"PR"; ///myserver/kep/newdoc/attfiles/PR
			}else if ("RFQ".equals(type)){
				folder = realUploadPath +"/"+"RFQ"; // /myserver/kep/newdoc/attfiles/RFQ
			}else if ("AU".equals(type)){
				folder = realUploadPath +"/"+"AUCTION"; // /myserver/kep/newdoc/attfiles/AUCTION
			}else if ("RA".equals(type)){
				folder = realUploadPath +"/"+"RAUCTION"; // /myserver/kep/newdoc/attfiles/RAUCTION
			}else if ("TEMP".equals(type)){
				folder = realUploadPath +"/"+"TEMP"; // /myserver/kep/newdoc/attfiles/TEMP
			}else if ("BY".equals(type)){
				folder = realUploadPath +"/"+"BUYER_ITEM"; // /myserver/kep/newdoc/attfiles/BUYER_ITEM
			}else if ("PX".equals(type)){
				folder = realUploadPath +"/"+"PROXY"; // /myserver/kep/newdoc/attfiles/PROXY
			}else if ("CT".equals(type)){
				folder = realUploadPath +"/"+"CONTRACT"; // /myserver/kep/newdoc/attfiles/CONTRACT
			}else if ("BO".equals(type)){
				folder = realUploadPath +"/"+"BOARD"; // /myserver/kep/newdoc/attfiles/CONTRACT
			}else if ("QT".equals(type)){
				folder = realUploadPath +"/"+"QT"; // /myserver/kep/newdoc/attfiles/QT
			}else if ("PO".equals(type)){
				folder = realUploadPath +"/"+"PO"; // /myserver/kep/newdoc/attfiles/PO
			}else if ("KEP".equals(type)){
				folder = realUploadPath +"/"+"KEP";// /myserver/kep/newdoc/attfiles/KEP
			}else if ("KMS".equals(type)){
				folder = realUploadPath +"/"+"KMS";// /myserver/kep/newdoc/attfiles/KMS
			}else if ("BYCA".equals(type)){
				folder = realUploadPath +"/"+"ITEM_IMAGE/DIR_1";// /myserver/kep/newdoc/attfiles/ITEM_IMAGE/DIR_1
			}else if ("PASS".equals(type)){
				folder = realUploadPath +"/"+"PASS";// /myserver/kep/newdoc/attfiles/PASS
			} else if ("NOTICE".equals(type)){
				folder = realUploadPath +"/"+"NOTICE";// /myserver/kep/newdoc/attfiles/NOTICE
			} else if ("KEPMR".equals(type)){
				folder = realUploadPath +"/"+"KEPMR";// /myserver/kep/newdoc/attfiles/KEPMR
			} else if ("SHOPS".equals(type)){
				folder = realUploadPath +"/"+"SHOPS";// /myserver/kep/newdoc/attfiles/SHOPS
			} else if ("ITS".equals(type)){
				folder = realUploadPath +"/"+"ITS";	// /myserver/kep/newdoc/attfiles/ITS
			} else if ("DONGBU".equals(type)){
				folder = "/data/DONGBU"; //  /myserver/kep/newdoc/DONGBU // 추가디렉토리
			}  else if ("SR".equals(type)){
				folder = "attfile_sr" +"/"+"SR";  //  /myserver/kep/newdoc/attfile_sr/SR // 추가디렉토리
			} else if ("PROMOTE".equals(type)){
				folder = realUploadPath +"/"+"PROMOTE"; // /myserver/kep/newdoc/attfiles/PROMOTE
			} else if ("CMS".equals(type)){
				folder = realUploadPath +"/"+"CMS"; // /myserver/kep/newdoc/attfiles/CMS
			} else if ("DONG".equals(type)){
				folder = realUploadPath +"/"+"DONG"; // /myserver/kep/newdoc/attfiles/DONG
			} else if ("RFQ".equals(type)){
				folder = realUploadPath +"/"+"RFQ"; // /myserver/kep/newdoc/attfiles/RFQ
			} else if ("SU".equals(type)){
				folder = realUploadPath +"/"+"SU";  // /myserver/kep/newdoc/attfiles/SU
			} else if ("ITEM".equals(type)){
				folder = "/data/DONGBU/ITEM"; // /myserver/kep/newdoc/DONGBU/ITEM
			} else if ("WR".equals(type)){
				folder = realUploadPath +"/"+"WR";  // /myserver/kep/newdoc/attfiles/WR
			}else if ("MSDS".equals(type)){
				folder = realImgUploadRegisterPath +"/"+"MSDS";// /myserver/kep/newdoc/attfiles/ITEM_IMAGE/MSDS
			} else if ("IV".equals(type)){
				folder = realUploadPath +"/"+"IV";  // /myserver/kep/newdoc/attfiles/IV
			} else if ("EXP_BL".equals(type)){
				folder = realUploadPath +"/"+"EXP_BL";  // /myserver/kep/newdoc/attfiles/EXP_BL
			} else if ("EXP_CI".equals(type)){
				folder = realUploadPath +"/"+"EXP_CI";  // /myserver/kep/newdoc/attfiles/EXP_CI
			}else if ("CSTM".equals(type)){
				folder = realUploadPath +"/"+"CUSTOMER";
			}else if ("CMC".equals(type)){
				folder = realUploadPath +"/"+"CMC"; 
			} else if ("SEC".equals(type)){
				folder = realUploadPath +"/"+"SEC"; // /myserver/kep/newdoc/attfiles/SEC
			} else {
				folder = realUploadPath +"/"+"TEMP";  // /myserver/kep/newdoc/attfiles/TEMP
			} 
		}
		
		return folder;
	}

	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param code 공통코드의 키 
	 * @param gubun all,sel
	 * @return
	 * @throws Exception
	 * 
	 * ICOMCOD1 전용
	 */
	public static String getCodeComboList(String code,String gubun) throws Exception { 
		return getCodeComboList( code, gubun,"","","","");
	} 
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param code 공통코드의 키 
	 * @param gubun all,sel
	 * @param dataValue data 실제의값 selected 를 위한 
	 * @return
	 * @throws Exception
	 * 
	 * ICOMCOD1 전용
	 */
	public static String getCodeComboList(String code,String gubun,String dataValue) throws Exception { 
		return getCodeComboList( code, gubun,dataValue,"","","");
	} 
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param code 공통코드의 키 (공통테이블 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * @param gubun ALL,SEL 
	 * @param dataValue data 실제의값 selected 를 위한
	 * @param commonTableGubun (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getCodeComboList(String code,String gubun,String dataValue,String commonTableGubun,String optionCode,String optionValue) throws Exception {

		if ("".equals(commonTableGubun)){
			commonTableGubun = "ICOMCOD1";
		}
		if ("".equals(optionCode)){
			optionCode = "CODE";
		}
		if ("".equals(optionValue)){
			optionValue = "TEXT1";
		}
		
		//System.out.println("commonTableGubun 	" +commonTableGubun);
		//System.out.println("optionCode " +optionCode);
		//System.out.println("optionValue 	" +optionValue);
		//System.out.println("code 	" +code);
		//System.out.println("dataValue 	" +dataValue);
		
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", commonTableGubun);
		_pMap.put("TYPE", code);
		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		//System.out.println("_data 	" +_data);
		if (_data !=null){
			//System.out.println("_data.size() 	" +_data.size());
			for (int i=0; i<_data.size(); i++){				
				returnCode = nvl(_data.get(i).get(optionCode),"").trim();
				returnValue = nvl(_data.get(i).get(optionValue),"").trim();				
				if (returnCode.equals(dataValue)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	} 
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param code 공통코드의 키 (공통테이블 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * @param gubun ALL,SEL 
	 * @param dataValue data 실제의값 selected 를 위한
	 * @param commonTableGubun (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getCodeBComboList(String code,String gubun,String dataValue,String commonTableGubun,String optionCode,String optionValue) throws Exception {

		if ("".equals(commonTableGubun)){
			commonTableGubun = "ICOMCOD1";
		}
		/*
		if ("".equals(optionCode)){
			optionCode = "CODE";
		}
		if ("".equals(optionValue)){
			optionValue = "TEXT1";
		}
		 */
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", commonTableGubun);
		if(commonTableGubun.equals("ICOMCOD2")){
			_pMap.put("COM_CODE", code);
			_pMap.put("TYPE", dataValue);			
		}else{
			_pMap.put("TYPE", code);
		}

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}else if("REF_PR_SEL".equals(gubun)){
			_sb.append("<option value=''>관리번호 선택</option>");
		}
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){				
				returnCode = nvl(_data.get(i).get("CODE"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();				
				if (returnCode.equals(optionCode)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	} 
	//code-text가 아닌 code-code 로 만드는 select
	public static String getCodeBComboListCode(String code,String gubun,String dataValue,String commonTableGubun,String optionCode,String optionValue) throws Exception {

		if ("".equals(commonTableGubun)){
			commonTableGubun = "ICOMCOD1";
		}
		/*
		if ("".equals(optionCode)){
			optionCode = "CODE";
		}
		if ("".equals(optionValue)){
			optionValue = "TEXT1";
		}
		 */
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", commonTableGubun);
		if(commonTableGubun.equals("ICOMCOD2")){
			_pMap.put("COM_CODE", code);
			_pMap.put("TYPE", dataValue);			
		}else{
			_pMap.put("TYPE", code);
		}

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}else if("REF_PR_SEL".equals(gubun)){
			_sb.append("<option value=''>관리번호 선택</option>");
		}
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){				
				returnCode = nvl(_data.get(i).get("CODE"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();				
				if (returnCode.equals(optionCode)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnCode+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnCode+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	} 
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param code 공통코드의 키 (공통테이블 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * @param gubun ALL,SEL 
	 * @param dataValue data 실제의값 selected 를 위한
	 * @param commonTableGubun (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getTextComboList(String code,String gubun,String dataValue,String commonTableGubun,String optionCode,String optionValue) throws Exception {

		if ("".equals(commonTableGubun)){
			commonTableGubun = "ICOMCOD1";
		}
		/*
		if ("".equals(optionCode)){
			optionCode = "CODE";
		}
		if ("".equals(optionValue)){
			optionValue = "TEXT1";
		}
		 */
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", commonTableGubun);
		if(commonTableGubun.equals("ICOMCOD2")){
			_pMap.put("COM_CODE", code);
			_pMap.put("TYPE", dataValue);			
		}else{
			_pMap.put("TYPE", code);
		}

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){				
				returnCode = nvl(_data.get(i).get("CODE"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();				
				if (returnValue.equals(optionValue)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	}
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * value값도 text1에서 가져와서 세팅
	 * @param code 공통코드의 키 (공통테이블 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * @param gubun ALL,SEL 
	 * @param dataValue data 실제의값 selected 를 위한
	 * @param commonTableGubun (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getTextValueComboList(String code,String gubun,String dataValue,String commonTableGubun,String optionCode,String optionValue) throws Exception {

		if ("".equals(commonTableGubun)){
			commonTableGubun = "ICOMCOD1";
		}
		/*
		if ("".equals(optionCode)){
			optionCode = "CODE";
		}
		if ("".equals(optionValue)){
			optionValue = "TEXT1";
		}
		 */
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", commonTableGubun);
		if(commonTableGubun.equals("ICOMCOD2")){
			_pMap.put("COM_CODE", code);
			_pMap.put("TYPE", dataValue);			
		}else{
			_pMap.put("TYPE", code);
		}

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}else if("REF_PR_SEL".equals(gubun)){
			_sb.append("<option value=''>관리번호 선택</option>");
		}
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){				
				returnCode = nvl(_data.get(i).get("CODE"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();				
				if (returnValue.equals(optionValue)){
					_sb.append("<option value='"+returnValue+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnValue+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	}
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method/  IP카테고리정보 
	 * @param code 공통코드의 키 
	 * @param gubun ALL,SEL 
	 * @param dataValue data 실제의값 selected 를 위한
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getFolderInfoComboList(String code,String gubun,String dataValue,String commonTableGubun,String optionCode,String optionValue) throws Exception {


		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", commonTableGubun);
		_pMap.put("BUYER", code);
		_pMap.put("USER_ID", dataValue);
		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){
				returnCode = nvl(_data.get(i).get("CODE"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();				
				if (returnCode.equals(optionCode)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	} 
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param queryId sqlId
	 * @param gubun all,sel
	 * @return
	 * @throws Exception
	 */
	public static String getCodeComboQueryIdList(String queryId,String gubun) throws Exception { 
		return getCodeComboQueryIdList( queryId, gubun,null,"");
	} 
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param queryId sqlId
	 * @param gubun all,sel
	 * @param dataValue 실제의값	  
	 * @return
	 * @throws Exception
	 */
	public static String getCodeComboQueryIdList(String queryId,String gubun,String dataValue) throws Exception { 
		return getCodeComboQueryIdList( queryId, gubun,null,dataValue);
	} 
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param queryId queryId
	 * @param gubun ALL,SEL
	 * @param search 조회조건 Map<String, String> _map = new HashMap<String, String>();
	 * @param dataValue 실제의값 selected
	 * @return
	 * @throws Exception
	 */
	public static String getCodeComboQueryIdList(String queryId,String gubun,Map<String, String> search,String dataValue) throws Exception {
		 
		
		List<Map<String,String>> _data = null;
		if (search==null){
			_data = StaticContextAccessor.getBean(CommonCodeDao.class).codeQueryIdList(queryId);
		}else{
			_data = StaticContextAccessor.getBean(CommonCodeDao.class).codeQueryIdList(queryId,search);
		}		
		
		StringBuilder _sb = new StringBuilder();
		String returnCode = "";
		String returnValue = "";
		
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("NOSEL".equals(gubun)){
			_sb.append("<option value=''>미선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){
				returnCode = nvl(_data.get(i).get("CODE"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();				
				if (returnCode.equals(dataValue)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	} 
	
	
	
	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param queryId queryId
	 * @param gubun ALL,SEL
	 * @param search 조회조건 Map<String, String> _map = new HashMap<String, String>();
	 * @param dataValue select할 순서로 selected
	 * @return
	 * @throws Exception
	 */
	public static String getCodeComboQueryIdIndexSelList(String queryId,String gubun,Map<String, String> search,int dataValue) throws Exception {
		 
		
		List<Map<String,String>> _data = null;
		if (search==null){
			_data = StaticContextAccessor.getBean(CommonCodeDao.class).codeQueryIdList(queryId);
		}else{
			_data = StaticContextAccessor.getBean(CommonCodeDao.class).codeQueryIdList(queryId,search);
		}		
		int cnt = 0;
		
		StringBuilder _sb = new StringBuilder();
		String returnCode = "";
		String returnValue = "";
		
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		if (_data !=null){
			
			cnt = _data.size();
			for (int i=0; i<cnt; i++){
				returnCode = nvl(_data.get(i).get("CODE"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();			
				if (cnt == 1){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{
					if (i == dataValue){
						_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
					}else{ 
						_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
					}
				}
			}
		}
		 
		return _sb.toString();
	} 
	
	
	 
	
	
	
	
	/**
	 * ibsheet 용 콤보생성
	 * @param code 공통코드의 키 
	 * @return
	 * @throws Exception
	 */
	public static String getCodeIbsheetComboList(String code,String gubun) throws Exception {

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).codeList(code);
		
		StringBuilder _sb = new StringBuilder();
		StringBuilder _code = new StringBuilder();
		StringBuilder _text = new StringBuilder();
		String returnCode = "";
		String returnValue = "";
		
		
		if ("SEL".equals(gubun)){
			_text.append("선택");
		}else if ("ALL".equals(gubun)){
			_text.append("전체");
		} 
		for (int i=0; i<_data.size(); i++){ 
			
			returnCode = nvl(_data.get(i).get("CODE"),"").trim();
			returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();		
			
			_code.append("|").append(returnCode);
			_text.append("|").append(returnValue);
		}
		_sb.append("ComboCode : ");
		_sb.append(_code.toString());
		_sb.append(",ComboText : ");
		_sb.append(_text.toString());
		
		return _sb.toString();
	} 
	
	/**
	 * ibsheet 용 콤보생성
	 * @param code 공통코드의 키 
	 * @return
	 * @throws Exception
	 */
	public static String getCodeIbsheetComboQueryIdList(String queryId,String gubun) throws Exception {

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).codeQueryIdList(queryId);
		
		StringBuilder _sb = new StringBuilder();
		StringBuilder _code = new StringBuilder();
		StringBuilder _text = new StringBuilder();
		String returnCode = "";
		String returnValue = "";
		
		if ("SEL".equals(gubun)){
			_text.append("선택");
		}else if ("ALL".equals(gubun)){
			_text.append("전체");
		} 
		for (int i=0; i<_data.size(); i++){ 
			
			returnCode = nvl(_data.get(i).get("CODE"),"").trim();
			returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();		
			
			_code.append("|").append(returnCode);
			_text.append("|").append(returnValue);
		}
		_sb.append("ComboCode : ");
		_sb.append(_code.toString());
		_sb.append(",ComboText : ");
		_sb.append(_text.toString());
		
		return _sb.toString();
	} 	
	
	/**
	 * 페이징 후 between 을 위한 설정
	 * @param pMap
	 * @return
	 */
	public static Map<String, String>  PagingPrc(Map<String, String> pMap ) { 
				
		//Map<String, String> _map = new HashMap<String, String>();
		String _rowidx = nvl(pMap.get("curPage"),"1");  //현재가 몇번째 페이지
		String _onepagerow = nvl(pMap.get("onepagerow"),"10"); //한번에 몇건씩 가져올 것인지
		String _onepage = "0";
		 
		
		//처음 조회 하는 경우
		if(_rowidx==null || _rowidx=="" || "".equals(_rowidx)){ 
			 _rowidx="1";
		} 
		if(_onepagerow==null || _onepagerow == "" || "".equals(_onepagerow)){ 
			_onepage="1";
		} else{
			_onepage= _onepagerow;
		}
		int _startrow = 0;
		int _endrow = 0;
		 
		
		_startrow = (Integer.parseInt(_rowidx)-1) * Integer.parseInt(_onepage)+1;  
		_endrow = _startrow + (Integer.parseInt(_onepage)-1);  
		 
		pMap.put("startrow",String.valueOf(_startrow));
		pMap.put("endrow",String.valueOf(_endrow));
		
		return removeSlash(pMap);
	}

	/**
	 * 페이징 후 between 을 위한 설정
	 * @param pMap
	 * @return
	 */
	public static Map<String, String>  PagingPrc2(Map<String, String> pMap ) { 
		// 조회일 슬래시 제거
		pMap = removeSlash(pMap);
		
		//Map<String, String> _map = new HashMap<String, String>();
		String _rowidx = nvl(pMap.get("curPage"),"1");  //현재가 몇번째 페이지
		String _onepagerow = nvl(pMap.get("onepagerow"),"10"); //한번에 몇건씩 가져올 것인지
		String _onepage = "0";
		 
		
		//처음 조회 하는 경우
		if(_rowidx==null || _rowidx=="" || "".equals(_rowidx)){ 
			 _rowidx="1";
		} 
		if(_onepagerow==null || _onepagerow == "" || "".equals(_onepagerow)){ 
			_onepage="1";
		} else{
			_onepage= _onepagerow;
		}
		int _startrow = 0;
		int _endrow = 0;
		 
		
		_startrow = (Integer.parseInt(_rowidx)-1) * Integer.parseInt(_onepage)+1;  
		_endrow = _startrow + (Integer.parseInt(_onepage)-1);  
		 
		pMap.put("startrow",String.valueOf(_startrow));
		pMap.put("endrow",String.valueOf(_endrow));

		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		return pMap;
	}

	
	/**
	 * LIST 에서 0번 MAP의 KEY 를 이용하여 값을 리턴받는다.
	 * @param list 쿼라결과
	 * @param key 쿼리결과의 0번 MAP의 KEY
	 * @param df 없을시 default 값 : 없을경우 ""
	 * @return
	 */
	public static String getListKeyValue( List<Map<String,String>> list ,String key,String df) { 
		String _value = "";
		if (list == null){			
			_value = df; // 없을경우 넘어온 기본값으로
		}else{
			Map<String, String> _Map = list.get(0); 
			_value = String.valueOf(_Map.get(key));
		}
		return _value;
		
	}

	/**
	 * LIST 에서 null 값을 공백으로 변환
	 * @param list 쿼리결과
	 * @param key 쿼리결과의 0번 MAP의 KEY
	 * @param df 없을시 default 값 : 없을경우 ""
	 * @return
	 */
	public static List<Map<String,String>> getListNvl( List<Map<String,String>> list) { 
		
		List<Map<String,String>> rtnList = new ArrayList<Map<String,String>>();
		
		if (list == null){			
			rtnList = list;
		}else{
			int size = list.size();
			Map<String, String> _Map =null;
			Set<String> key =null;
			Iterator<String> iterkey =null;
			Map<String,String> rtnMap =null;
			for(int i=0; i<size; i++){
				_Map = list.get(i);
				//keys
				key = _Map.keySet();
				iterkey = key.iterator();
				//values
				rtnMap = new HashMap<String,String>();
				while(iterkey.hasNext()){
					String mapkey = iterkey.next();
					Object valObj = (Object)_Map.get(mapkey);
					if(valObj == null || "".equals(valObj)){
						rtnMap.put(mapkey, "");
					}else{
						String value = valObj.toString();
						rtnMap.put(mapkey, (!"null".equals(value))?value:"");
					}
				}
				rtnList.add(rtnMap);
			}
		}
		return rtnList;
	}
	/**
	 * Map 에서 null 값을 공백으로 변환
	 * @param map 쿼리결과
	 * @param key 쿼리결과를 MAP의 KEY로 변환
	 * @param df 없을시 default 값 : 없을경우 ""
	 * @return
	 */
	public static Map<String,String> getMapNvl( Map<String,String> _map) { 
		
		Map<String,String> rtnMap = new HashMap<String,String>();
		
		if (_map == null){			
			rtnMap = _map;
		}else{
			Set<String> key =null;
			Iterator<String> iterkey =null;
			//keys
			key = _map.keySet();
			iterkey = key.iterator();
			//values
			while(iterkey.hasNext()){
				String mapkey = iterkey.next();
				Object valObj = (Object)_map.get(mapkey);
				if(valObj == null || "".equals(valObj)){
					rtnMap.put(mapkey, "");
				}else{
					String value = valObj.toString();
					rtnMap.put(mapkey, (!"null".equals(value))?value:"");
				}
			}
		}
		return rtnMap;
	}

	
	/**
	 * value 가 null 일경우 처리한다.
	 * @param value 받을값 
	 * @param df 없을시 default 값 : 없을경우 ""
	 * @return
	 */
	public static String nvl( String value,String df) { 
		
		String _str = "";
		if (value == null){
			_str = "";
		}else if ("null".equals(value.trim())){
			_str = "";
		}else{ 
			_str = value.trim();
		}
		if (df == null){
			df = "";
		}else if ("null".equals(df.trim())){
			df = "";
		}
		if ("".equals(_str)){
			_str = df;
		}

		// 특수문자 치환 추가 2015.09.01
//				_str = _str.replace("#", "&#35;");	셀트리온 품목코드 # 포함으로 인하여 삭제 2016.01.21
				
				_str = _str.replace("<", "&lt;");
				_str = _str.replace(">", "&gt;");
				_str = _str.replace("[(]", "&#40;");
				_str = _str.replace("[)]", "&#41;");
				
		// 2017 웹취약점 크로스사이트스크립팅으로 인한 추가 2017.07.18 - HSJ
				_str = _str.replaceAll("innerHTML", "");
				_str = _str.replaceAll("javascript", "");
				_str = _str.replaceAll("eval", "");
				_str = _str.replaceAll("onmousewheel", "");
				_str = _str.replaceAll("onactive", "");
				_str = _str.replaceAll("onfocusout", "");
				_str = _str.replaceAll("expression", "");
				_str = _str.replaceAll("charset", "");
				_str = _str.replaceAll("ondataavailable", "");
				_str = _str.replaceAll("oncut", "");
				_str = _str.replaceAll("onkeyup", "");
				_str = _str.replaceAll("applet", "");
				_str = _str.replaceAll("document", "");
				_str = _str.replaceAll("onafteripudate", "");
				_str = _str.replaceAll("onclick", "");
				_str = _str.replaceAll("onkeypress", "");
				//_str = _str.replaceAll("meta", "");
				_str = _str.replaceAll("string", "");
				_str = _str.replaceAll("onmousedown", "");
				_str = _str.replaceAll("onchange", "");
				_str = _str.replaceAll("onload", "");
				_str = _str.replaceAll("xml", "");
				_str = _str.replaceAll("create", "");
				_str = _str.replaceAll("onbeforeactivate", "");
				_str = _str.replaceAll("onbeforecut", "");
				_str = _str.replaceAll("onbounce", "");
				_str = _str.replaceAll("blink", "");
				_str = _str.replaceAll("append", "");
				_str = _str.replaceAll("onbeforecopy", "");
				_str = _str.replaceAll("ondbclick", "");
				_str = _str.replaceAll("onmouseenter", "");
				_str = _str.replaceAll("link", "");
				_str = _str.replaceAll("binding", "");
				_str = _str.replaceAll("onbeforedeactivate", "");
				_str = _str.replaceAll("ondeactivate", "");
				_str = _str.replaceAll("onmouseout", "");
				_str = _str.replaceAll("style", "");
				_str = _str.replaceAll("alert", "");
				_str = _str.replaceAll("ondatasetchaged", "");
				_str = _str.replaceAll("ondrag", "");
				_str = _str.replaceAll("onmouseover", "");
				_str = _str.replaceAll("script", "");
				_str = _str.replaceAll("msgbox", "");
				_str = _str.replaceAll("cnbeforeprint", "");
				_str = _str.replaceAll("ondragend", "");
				_str = _str.replaceAll("onsubmit", "");
				_str = _str.replaceAll("embed", "");
				_str = _str.replaceAll("refresh", "");
				_str = _str.replaceAll("cnbeforepaste", "");
				_str = _str.replaceAll("ondragenter", "");
				_str = _str.replaceAll("onmouseend", "");
				_str = _str.replaceAll("object", "");
				_str = _str.replaceAll("void", "");
				_str = _str.replaceAll("onbeforeeditfocus", "");
				_str = _str.replaceAll("ondragleave", "");
				_str = _str.replaceAll("onresizestart", "");
				_str = _str.replaceAll("iframe", "");
				_str = _str.replaceAll("cookie", "");
				_str = _str.replaceAll("onbeforeuload", "");
				_str = _str.replaceAll("ondragover", "");
				_str = _str.replaceAll("onuload", "");
				_str = _str.replaceAll("frame", "");
				_str = _str.replaceAll("Href", "");
				_str = _str.replaceAll("onbeforeupdate", "");
				_str = _str.replaceAll("ondragstart", "");
				_str = _str.replaceAll("onselectstart", "");
				_str = _str.replaceAll("frameset", "");
				_str = _str.replaceAll("onpaste", "");
				_str = _str.replaceAll("onpropertychange", "");
				_str = _str.replaceAll("ondrop", "");
				_str = _str.replaceAll("onreset", "");
				_str = _str.replaceAll("ilayer", "");
				_str = _str.replaceAll("onresize", "");
				_str = _str.replaceAll("ondatasetcomplete", "");
				_str = _str.replaceAll("onerror", "");
				_str = _str.replaceAll("onmove", "");
				_str = _str.replaceAll("layer", "");
				_str = _str.replaceAll("onselect", "");
				_str = _str.replaceAll("oncellchange", "");
				_str = _str.replaceAll("onfinish", "");
				_str = _str.replaceAll("onstop", "");
				_str = _str.replaceAll("bgsound", "");
				_str = _str.replaceAll("base", "");
				_str = _str.replaceAll("onlayoutcomplete", "");
				_str = _str.replaceAll("onfocus", "");
				_str = _str.replaceAll("onrowexit", "");
				_str = _str.replaceAll("title", "");
				_str = _str.replaceAll("onblur", "");
				_str = _str.replaceAll("onselectionchange", "");
				_str = _str.replaceAll("vbscript", "");
				_str = _str.replaceAll("onerrorupdate", "");
				_str = _str.replaceAll("onbefore", "");
				_str = _str.replaceAll("onstart", "");
				_str = _str.replaceAll("onrowsinserted", "");
				_str = _str.replaceAll("onkeydown", "");
				_str = _str.replaceAll("onfilterchage", "");
				_str = _str.replaceAll("onmouseup", "");
				_str = _str.replaceAll("onfocusin", "");
				_str = _str.replaceAll("oncontrolselected", "");
				_str = _str.replaceAll("onrowsdelete", "");
				_str = _str.replaceAll("onlosecapture", "");
				_str = _str.replaceAll("onrowenter", "");
				_str = _str.replaceAll("onhelp", "");
				_str = _str.replaceAll("onreadystatechange", "");
				_str = _str.replaceAll("onmouseleave", "");
				_str = _str.replaceAll("onmousemove", "");
				_str = _str.replaceAll("oncontextmenu", "");

		return _str;
		
	}
	/**
	 * nvl과 같은 양식(특수문자 치환 부분 제외)
	 * value 가 null 일경우 처리한다.
	 * @param value 받을값 
	 * @param df 없을시 default 값 : 없을경우 ""
	 * @return
	 */
	public static String nvl3( String value,String df) { 
		
		String _str = "";
		if (value == null){
			_str = "";
		}else if ("null".equals(value.trim())){
			_str = "";
		}else{ 
			_str = value.trim();
		}
		if (df == null){
			df = "";
		}else if ("null".equals(df.trim())){
			df = "";
		}
		if ("".equals(_str)){
			_str = df;
		}

		// 특수문자 치환 추가 2015.09.01
		
//				_str = _str.replace("#", "&#35;"); 셀트리온 품목코드 # 포함으로 인하여 삭제 2016.01.21 
				
				_str = _str.replace("<", "〈");
				_str = _str.replace(">", "〉");
				_str = _str.replace("[(]", "（");
				_str = _str.replace("[)]", "）");		
		return _str;
	}
	
	/**
	 * nvl과 같은 양식(특수문자 치환 부분 제외)
	 * value 가 null 일경우 처리한다.
	 * @param value 받을값 
	 * @param df 없을시 default 값 : 없을경우 ""
	 * @return
	 */
	public static String nvl2( String value,String df) { 
		
		String _str = "";
		if (value == null){
			_str = "";
		}else if ("null".equals(value.trim())){
			_str = "";
		}else{ 
			_str = value.trim();
		}
		if ("".equals(_str)){
			_str = df;
		}
		
		return _str;
	}
	
	/**
	 * Object 타입 - NVL
	 * @param (Object)value
	 * @param (String)df
	 * @return (String)_str
	 */
	public static String onvl( Object value,String df) { 
		
		String _str = "";
		if (value == null){
			_str = df ;
		} else if ("".equals(value.toString().trim()) || "null".equals(value.toString().toLowerCase().trim())){
			_str = df ;
		} else{
			_str = value.toString() ;
		}
		
		return _str;
	}
	
	public static Map<String,String> nvlMap( Map<String,String> _Map) { 
		
		Map<String,String> rtnMap = new HashMap<String,String>();;
		if (_Map != null){
			Set<String> key =null;
			Iterator<String> iterkey =null;
			key = _Map.keySet();
			iterkey = key.iterator();
			
			while(iterkey.hasNext()){
				String mapkey = iterkey.next();
				Object valObj = (Object)_Map.get(mapkey);
				if(valObj == null || "".equals(valObj)){
					rtnMap.put(mapkey, "");
				}else{
					String value = String.valueOf(valObj);
					rtnMap.put(mapkey, (!"null".equals(value))?value:"");
				}
			}

		}
		
		return rtnMap;
	}

	public static Map<String,String> nvlRadio( Map<String,String> form , String key) { 
		String existKey = form.get(key);
		if( existKey == null || existKey == "undefined") form.put(key, "");
		return form;
	}
	
	public static String nvlObj( List<Map<String,String>> _gridList,String df) { 
		String _str = "";
		if(_gridList != null && _gridList.size() > 0){
			_str = CommonUtil.nvl(String.valueOf(_gridList.get(0).get("TOTNUM")),"0"); // 총 조회수 (필수)
		}else{
			_str = df;
		}
		return _str;
	}

	public static Integer nvlInt( List<Map<String,String>> _gridList, String df) { 
		Integer _rtn = 0;
		if(_gridList != null && _gridList.size() > 0){
			_rtn = Integer.valueOf(CommonUtil.nvl(String.valueOf(_gridList.get(0).get("TOTNUM")),"0")); // 총 조회수 (필수)
		}else{
			_rtn = Integer.valueOf(df);
		}
		return _rtn;
	}

	
	/**
	 * 이미지가 null 일경우 디폴트 이미지로 처리한다.
	 * @param value 받을값 
	 * @param df 없을시 default 값 : 없을경우 ""
	 * @return
	 */
	public static String nvlImg( String value) { 
		
//		<%="/attfiles/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>
//		/resources/images/icon_emptyimg.gif
//		String osName = System.getProperty("os.name");
//		String _path = (osName.indexOf("Win") > -1)?CommonUtil.ImgRootlocal : CommonUtil.ImgRootServer;	
		
		String _str = "";
		if (value == null || "".equals(value) ){
			_str = "";
		}
		return _str;
	}
	
	/**
	 * jsp 에서 페이징처리를 위한 함수
	 * 페이징번호 10으로 고정되어 있음
	 * @param searchMethod 호출할 조회 method
	 * @param tp 전체 게시물 수
	 * @param cp 현재 페이지 번호
	 * @param lm 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	 * @return
	 */
	public static String getPageView( String pSearchMethod ,int pTp, String pCp, String pLm) {
		return getPageView( pSearchMethod ,String.valueOf(pTp), pCp, pLm);
	}
	public static String getPageView( String pSearchMethod ,String pTp, String pCp, String pLm) { 
		
		
		StringBuilder _sb = new StringBuilder();	
		
		String _tp ="";
		String _cp ="";
		String _lm ="";
		/*
		System.out.println("pTp " +pTp);
		System.out.println("pCp " +pCp);
		System.out.println("pLm" +pLm);
		*/
		
		int _pageLimit = 10;
		if (pTp == null || "".equals(pTp) )  { _tp = "0"; } else {  _tp = pTp;  }
		if (pCp == null || "".equals(pCp) ) { _cp = "1"; } else {  _cp = pCp;  }
		if (pLm == null || "".equals(pLm) ) {			
			_lm = "";
		}else{
			_lm = pLm;
			
			int _totalpage = Integer.parseInt(_tp);
			int _curPage = Integer.parseInt(_cp);
			int _limit = Integer.parseInt(_lm);
			
			if((_totalpage%_limit) == 0){
				_totalpage = _totalpage / _limit;
			}else{
				_totalpage = (_totalpage / _limit) + 1;
			} 
			
			int _startPage   = 0;
			int _endPage     = 0;
			  
			if((_curPage%_pageLimit) == 0)
				_startPage = (_curPage/_pageLimit)*_pageLimit -9; 
			else
				_startPage = (_curPage/_pageLimit)*_pageLimit +1;
			 
		
			_endPage = _startPage+9;
		
		
			if(_endPage > _totalpage)
				_endPage = _totalpage;
			 
			if (_totalpage>0){
		//		_sb.append("<a href='javascript:"+searchMethod+"(1)';><<</a>");
				if (_startPage>1){
					_sb.append("&nbsp;&nbsp;<a href='javascript:"+pSearchMethod+"("+(_startPage-1)+")'; class='mr10'><img src='/resources/images/btn_pageprev.gif' alt='이전으로 이동' /></a>");
				}
			} 
			 
	
			for(int i = _startPage; i<=_endPage; i++)
			{
				_sb.append("<font style='font-size:11'>");
			    if(_curPage == i)
			    {
			    	_sb.append("<b>"+i+"</b>");
			    }
			    else
			    {
			    	_sb.append("<a href='javascript:"+pSearchMethod+"("+i+")'>"+i+"</a>");
			    }
			    _sb.append("</font>");
		
		
			    if(i != _endPage)
			    {
			    	_sb.append("<font style='font-size:11'>&nbsp;|&nbsp;</font>");
			    }
			}
			
			if(_curPage < _totalpage){ 
				if(_endPage < _totalpage){  
					_sb.append("&nbsp;&nbsp;<a href='javascript:"+pSearchMethod+"("+(_endPage+1)+")'; class='ml10'><img src='/resources/images/btn_pagenext.gif' alt='다음으로 이동' /></a>");
				}
				//_sb.append("&nbsp;&nbsp;<a href='javascript:"+searchMethod+"("+_totalpage+")';>>></a>");
			}
		}


		return _sb.toString();
		
	}
	
	/**
	 * 판촉물 전용마켓 jsp 에서 페이징처리를 위한 함수
	 * 페이징번호 10으로 고정되어 있음
	 * @param searchMethod 호출할 조회 method
	 * @param tp 전체 게시물 수
	 * @param cp 현재 페이지 번호
	 * @param lm 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	 * @return
	 */
	public static String getPromotePageView( String pSearchMethod ,int pTp, String pCp, String pLm) {
		return getPromotePageView( pSearchMethod ,String.valueOf(pTp), pCp, pLm);
	}
	public static String getPromotePageView( String pSearchMethod ,String pTp, String pCp, String pLm) { 
		
		
		StringBuilder _sb = new StringBuilder();	
		
		String _tp ="";
		String _cp ="";
		String _lm ="";
		
		int _pageLimit = 10;
		if (pTp == null || "".equals(pTp) )  { _tp = "0"; } else {  _tp = pTp;  }
		if (pCp == null || "".equals(pCp) ) { _cp = "1"; } else {  _cp = pCp;  }
		if (pLm == null || "".equals(pLm) ) {			
			_lm = "";
		}else{
			_lm = pLm;
			
			int _totalpage = Integer.parseInt(_tp);
			int _curPage = Integer.parseInt(_cp);
			int _limit = Integer.parseInt(_lm);
			
			if((_totalpage%_limit) == 0){
				_totalpage = _totalpage / _limit;
			}else{
				_totalpage = (_totalpage / _limit) + 1;
			} 
			
			int _startPage   = 0;
			int _endPage     = 0;
			  
			if((_curPage%_pageLimit) == 0)
				_startPage = (_curPage/_pageLimit)*_pageLimit -9; 
			else
				_startPage = (_curPage/_pageLimit)*_pageLimit +1;
			 
		
			_endPage = _startPage+9;
		
		
			if(_endPage > _totalpage)
				_endPage = _totalpage;
			 
			if (_totalpage>0){
				if (_startPage>1){
					_sb.append("<a href='javascript:"+pSearchMethod+"("+(_startPage-1)+")';>< 이전&nbsp;&nbsp;</a>");
				}
			} 
			 
	
			for(int i = _startPage; i<=_endPage; i++)
			{
				_sb.append("<font>");
			    if(_curPage == i)
			    {
			    	_sb.append("<b>"+i+"</b>");
			    }
			    else
			    {
			    	_sb.append("<a href='javascript:"+pSearchMethod+"("+i+")'>"+i+"</a>");
			    }
			    _sb.append("</font>");
		
		
			    if(i != _endPage)
			    {
			    	_sb.append("<font>&nbsp;|&nbsp;</font>");
			    }
			}
			
			if(_curPage < _totalpage){ 
				if(_endPage < _totalpage){  
					_sb.append("<a href='javascript:"+pSearchMethod+"("+(_endPage+1)+")';>&nbsp;&nbsp;다음 ></a>");
				}
			}
		}


		return _sb.toString();
		
	}
	
	/**
	 * Main jsp 에서 페이징처리를 위한 함수
	 * 페이징번호 10으로 고정되어 있음
	 * @param searchMethod 호출할 조회 method
	 * @param tp 전체 게시물 수
	 * @param cp 현재 페이지 번호
	 * @param lm 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	 * @return
	 */
	public static String getMainPageView( String pSearchMethod ,int pTp, String pCp, String pLm) {
		return getMainPageView( pSearchMethod ,String.valueOf(pTp), pCp, pLm);
	}
	public static String getMainPageView( String pSearchMethod ,String pTp, String pCp, String pLm) { 
		
		
		StringBuilder _sb = new StringBuilder();	
		
		String _tp ="";
		String _cp ="";
		String _lm ="";
		
		int _pageLimit = 10;
		if (pTp == null || "".equals(pTp) )  { _tp = "0"; } else {  _tp = pTp;  }
		if (pCp == null || "".equals(pCp) ) { _cp = "1"; } else {  _cp = pCp;  }
		if (pLm == null || "".equals(pLm) ) {			
			_lm = "";
		}else{
			_lm = pLm;
			
			int _totalpage = Integer.parseInt(_tp);
			int _curPage = Integer.parseInt(_cp);
			int _limit = Integer.parseInt(_lm);
			
			if((_totalpage%_limit) == 0){
				_totalpage = _totalpage / _limit;
			}else{
				_totalpage = (_totalpage / _limit) + 1;
			} 
			
			int _startPage   = 0;
			int _endPage     = 0;
			  
			if((_curPage%_pageLimit) == 0)
				_startPage = (_curPage/_pageLimit)*_pageLimit -9; 
			else
				_startPage = (_curPage/_pageLimit)*_pageLimit +1;
			 
		
			_endPage = _startPage+9;
		
		
			if(_endPage > _totalpage)
				_endPage = _totalpage;
			 
			if (_totalpage>0){
				if (_startPage>1){
					_sb.append("<a class='direction' href='javascript:"+pSearchMethod+"("+(_startPage-1)+")';><span><</span> 이전</a>");
				}
			} 
			 
	
			for(int i = _startPage; i<=_endPage; i++)
			{
				_sb.append("<font>");
			    if(_curPage == i)
			    {
			    	_sb.append("<b>"+i+"</b>");
			    }
			    else
			    {
			    	_sb.append("<a href='javascript:"+pSearchMethod+"("+i+")'>"+i+"</a>");
			    }
			    _sb.append("</font>");
		
		
			    if(i != _endPage)
			    {
			    	_sb.append("<font>&nbsp;|&nbsp;</font>");
			    }
			}
			
			if(_curPage < _totalpage){ 
				if(_endPage < _totalpage){  
					_sb.append("<a class='direction' href='javascript:"+pSearchMethod+"("+(_endPage+1)+")';>다음 <span>></span></a>");
				}
			}
		}


		return _sb.toString();
		
	}
	
	/**
	 * MultiValueMap 을 list로 리턴한다.
	 * 그리드인것
	 * @param pMap1 받을 MultiValueMap  
	 * @return
	 */
	public static List<Object> getMultiValueMapList(MultiValueMap<String, String> pMap,String pArrayName) { 
		
 
		List<Object> _list = new ArrayList<Object>();
		int _size = 0;
		List<String> _valuesG = pMap.get(pArrayName);		// 그리드구분
		String _GRID_VALUE_NAME = _valuesG.get(0);
		String _gridValueName[] = _GRID_VALUE_NAME.split("\\|");
		//System.out.println("GRID_VALUE_NAME	" + GRID_VALUE_NAME);
		Iterator<String> _keySet0 = pMap.keySet().iterator();
		while(_keySet0.hasNext()){
			_keySet0.next();			 
			//System.out.println("gridValueName[0]	" + gridValueName[0]);
					List<String> _values0 = pMap.get(_gridValueName[0]);		
					_size =_values0.size();    
		}		
		//System.out.println("_size_size_size: {}" + _size);
		
		for(int i = 0 ; i < _size ; i++){
			Map<String,String>_valueMap = new HashMap<String,String>();
			Iterator<String> _keySet1 = pMap.keySet().iterator();
			while(_keySet1.hasNext()){
				String _key1 = _keySet1.next();
				_key1 = (_key1==null) ? "" : _key1; 
				
				 for (int j=0; j<_gridValueName.length; j++){
					 	if (_gridValueName[j].equals(_key1)){ // GRID_VALUE_NAME 그리드인것만
					 		//System.out.println("gridValueName[j]	" +gridValueName[j] + " "+j+"  j=_key1==>"+_key1);
							List<String> _values1 = pMap.get(_key1); 
							//System.out.println("_key1		" +_key1 + " " + _values1.get(i));
//							_valueMap.put(_key1,(String) ((_values1!=null && _values1.size()>1)?_values1.get(i):_values1));
							_valueMap.put(_key1, _values1.get(i));
					 	}
				 }

				 
			} 
			//System.out.println("_valueMap_valueMap		" +_valueMap.values());
			_list.add(removeSlash(_valueMap));
		}
		return _list;
	}
	
	/**
	 * MultiValueMap 을 list로 리턴한다.
	 * 그리드인것
	 * @param pMap 받을 MultiValueMap  
	 * @return
	 */
	public static List<Object> getMultiValueMapList(MultiValueMap<String, String> pMap) {
		return getMultiValueMapList(pMap,"s_SAVENAME");
	}
	
	/**
	 * MultiValueMap 을 Map로 리턴한다.
	 * 그리드 아닌것
	 * @param pMap1 받을 MultiValueMap  
	 * @return
	 */
	public static Map<String, String> getMultiValueMapMap(MultiValueMap<String, String> pMap
			,String pArrayName) { 
		
		@SuppressWarnings("unused")
		boolean flag = true;
		Map<String, String> _retMap = new HashMap<String, String>(); 
		List<String> _valuesG = pMap.get(pArrayName);		// 그리드구분
		String _GRID_VALUE_NAME = "";
		String _gridValueName[] = {};
		if(_valuesG != null && _valuesG.size()>0){
			_GRID_VALUE_NAME = _valuesG.get(0);
			_gridValueName = _GRID_VALUE_NAME.split("\\|");
		}
		//System.out.println("GRID_VALUE_NAME	" + GRID_VALUE_NAME);
		Iterator<String> _keySet0 = pMap.keySet().iterator();
		while(_keySet0.hasNext()){
			String _key0 = _keySet0.next();			  	
			 for (int j=0; j<_gridValueName.length; j++){
				 	if (_gridValueName[j].equals(_key0)){ // GRID_VALUE_NAME 
				 		flag = false;
				 	}else{
				 		//System.out.println("gridValueName[j]	" +gridValueName[j] + " "+j+"  j=_key1==>"+_key1);
						List<String> _values1 = pMap.get(_key0); 
						//System.out.println("_key1		" +_key1 + " " + _values1.get(i));
						_retMap.put(_key0,_values1.get(0));
				 	}
			 }
		}		 
		//System.out.println("_retMap_retMap		" +_retMap.values());
		return removeSlash(_retMap);
	}
	
	/**
	 * 세션데이터를 추가한 MultiValueMap 을 Map로 리턴한다
	 * 그리드 아닌것
	 * @param pMap1 받을 MultiValueMap  
	 * @return
	 */
	public static Map<String, String> getMultiValueMapMap(HttpServletRequest req, MultiValueMap<String, String> pMap
			,String pArrayName) { 
		
		@SuppressWarnings("unused")
		boolean flag = true;		
		Map<String, String> _retMap = new HashMap<String, String>(); 
		List<String> _valuesG = pMap.get(pArrayName);		// 그리드구분
		String _GRID_VALUE_NAME = _valuesG.get(0);
		String _gridValueName[] = _GRID_VALUE_NAME.split("\\|");
		//System.out.println("GRID_VALUE_NAME	" + GRID_VALUE_NAME);
		Iterator<String> _keySet0 = pMap.keySet().iterator();
		while(_keySet0.hasNext()){
			String _key0 = _keySet0.next();			  	
			 for (int j=0; j<_gridValueName.length; j++){
				 	if (_gridValueName[j].equals(_key0)){ // GRID_VALUE_NAME 
				 		flag = false;
				 	}else{
				 		//System.out.println("gridValueName[j]	" +gridValueName[j] + " "+j+"  j=_key1==>"+_key1);
						List<String> _values1 = pMap.get(_key0); 
						//System.out.println("_key1		" +_key1 + " " + _values1.get(i));
						_retMap.put(_key0,_values1.get(0));
				 	}
			 }
		}		 
		//System.out.println("_retMap_retMap		" +_retMap.values());
		return IBSheetUtil.getCommonSesFrmData(req, _retMap);
	}

	
	/**
	 * MultiValueMap 을 list로 리턴한다.
	 * 그리드인것
	 * @param pMap 받을 MultiValueMap  
	 * @return
	 */
	public static Map<String, String> getMultiValueMapMap(MultiValueMap<String, String> pMap) {
		return getMultiValueMapMap(pMap,"s_SAVENAME");
	}
		
	/**
	 * MultiValueMap 을 list로 리턴한다.(세션추가)
	 * 그리드인것
	 * @param pMap 받을 MultiValueMap  
	 * @return
	 */
	public static Map<String, String> getMultiValueMapMap(HttpServletRequest req, MultiValueMap<String, String> pMap) {
		return getMultiValueMapMap(req, pMap,"s_SAVENAME");
	}
	
	/*
	public static Map<String, Object> makeRequestMap(HttpServletRequest request)
	 {
		List list = new ArrayList();
		Map parameterMap = new HashMap(); 
		Enumeration enums = request.getParameterNames(); 		
		Enumeration enums1 = request.getParameterNames(); 		
 
		while(enums.hasMoreElements()){ 
		String paramName = (String)enums.nextElement(); 
		String[] parameters = request.getParameterValues(paramName); 
		
		System.out.println("paramName	"+paramName);
		System.out.println("parameters	"+parameters);
		System.out.println("parameters	"+parameters.length);
		
			// Parameter가 배열일 경우 
			for (int i=0; i<parameters.length; i++){ 
				String[] parameters1 = request.getParameterValues(paramName); 
				parameterMap.put(paramName, parameters1[i]); 	 
				
				System.out.println(i +"	paramName1	"+paramName);
				System.out.println("parameters1	"+parameters1[i]); 
			}
			
			
		} 
	  
	  return parameterMap;
	 }
	 */

	
	/**
	 * 최대 길이 수보다 큰 문자열인 경우에 뒷부분을 "..."로 변환한다.<br><br>
	 *
	 * @param text  주어진 문자열
	 * @param maxLength  최대 문자열 길이
	 * @return String 처리된 문자열
	 */
	public static String textMore(String text, int maxLength) {
	    String _value = "";
	    if( text ==  null) return null;
	    if( text.length() <= (maxLength+3) ) return text;
	    _value = text.substring(0,maxLength) + "...";
	    return _value;
	}
	
	/**
	 * string형식으로 들어오는 문자열에서 특정 값을 제거한 문자열을 리턴한다.
	 *
	 * @param str     문자열
	 * @param delim   제거할 문자
	 * @return String 특정값이 제거된 문자열
	 */
	public static String remove(String str, String delim) {
	    StringBuffer    _sb = new StringBuffer();              // 리턴할 문자열 버퍼
	    StringTokenizer _st = new StringTokenizer(str, delim); // 지정된 값으로 문자열을 자른다.
	    while (_st.hasMoreTokens()) {
	    	_sb.append(_st.nextToken());
	     }
	    return _sb.toString();
	}
	
	
	/**
	 * 2014/04/15 형식으로 들어오는 날짜 문자열에서 .을 제거한 문자열을 리턴한다.<br><br>
	 *
	 * @param date  날짜 문자열
	 * @return String .이 제거된 문자열
	 */
	public static String removeDot(String temp_date) {
	   String _date = temp_date.trim();
	    if( _date == null ) return null;
	    // "2014.04.15" 인 경우 문자열의 길이는 10자리임,
	    // "2014.04" 인 경우에는 7자리임.
	    if( !(_date.length() == 10 || _date.length() == 7) )
	    	return _date;
	    return remove(_date, dateGubun);
	}
	/**
	* 2014.04.15 형식으로 들어오는 날짜 문자열에서 .을 제거한 문자열을 리턴한다.<br><br>
	*
	* @param date  날짜 문자열
	* @return String -이 제거된 문자열
	*/
	public static String removeDash(String temp_date) {
	   String _date = temp_date.trim();
	   if( _date == null ) return null;
	   // "2014.04.15" 인 경우 문자열의 길이는 10자리임,
	   // "2014.04" 인 경우에는 7자리임.
	   if( !(_date.length() == 10 || _date.length() == 7) )
	           return _date;
	   return remove(_date, "-");
	}
	
	
	/**
	 * 12,345 형식으로 들어오는 숫자 문자열에 ,를 제거한 문자열을 리턴한다.<br><br>
	 *
	 * @param price 숫자문자열
	 * @return String ,이 제거된 문자열
	 */
	public static String removeComma(String price) {
	    if( price == null ) return null;
	    return remove(price, ",");
	}
	
	
	/**
	 * 문자열로 넘어온 날짜를 각 디폴트 포맷(YYYY.MM.DD)으로 변환한다.<br>
	     * 포맷하기에 길이가 부족하면 원래 문자열을 그대로 리턴한다.<br><br>
	     *
	 * @param date   날짜 문자열
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyy.mm.dd )
	 */
	public static String formatDate(String date) {
	        return formatDate(date,YYYYMMDD);
	}
	
	/**
	 * 문자열로 넘어온 날짜를 각각의 포맷에 따라서
	     * 재구성하여 반환한다.<br>
	     * 포맷하기에 길이가 부족하면 원래 문자열을 그대로 리턴한다.<br><br>
	     *
	 * @param date   날짜 문자열
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyy/mm )
	 * @return String 변환된 문자열  ( yyyy/mm/dd )
	 * @return String 변환된 문자열  ( yyyy/mm/dd hh:mi )
	 * @return String 변환된 문자열  ( yyyy/mm/dd hh:mi:ss )
	 */
	public static String formatDate(String date,int format) {
	    StringBuffer _rDate = new StringBuffer();
	
	    if( date == null || date.equals(""))
	            return "";
	
	    if( !(format == YYYYMM || format == YYYYMMDD || format == YYYYMMDDHHMI || format == YYYYMMDDHHMISS) )
	            return date;
	
	    if( format==YYYYMM && date.length() < 6)
	            return date;
	    if( format==YYYYMMDD && date.length() < 8)
	            return date;
	    if( format==YYYYMMDDHHMI && date.length() < 12)
	            return date;
	    if( format==YYYYMMDDHHMISS  && date.length() < 14)
	            return date;
	
	    _rDate.append(date.substring(0,4));
	    _rDate.append(dateGubun);
	    _rDate.append(date.substring(4,6));
	
	            if( format >= YYYYMMDD ) {
	            	_rDate.append(dateGubun);
	            	_rDate.append(date.substring(6,8));
	
	                    if(format >= YYYYMMDDHHMI ) {
	                    	_rDate.append(" ");
	                    	_rDate.append(date.substring(8,10));
	                    	_rDate.append(":");
	                    	_rDate.append(date.substring(10,12));
	
	                             if(format==YYYYMMDDHHMISS) {
	                            	 _rDate.append(":");
	                            	 _rDate.append(date.substring(12,14));
	                    }
	                     }
	             }
	            return _rDate.toString();
	}
	
	 /**
	 * Date type으로 넘어온 날짜를 디폴트 포맷(YYYY/MM/DD)으로 변환한다.<br><br>
	     *
	 * @param date   날짜
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyy.mm.dd )
	 */
	public static String formatDate(Date date) {
		return formatDate(date, YYYYMMDD);
	}
	
	public static String formatDate2(Date date) {
		SimpleDateFormat _sdf=null;
	    if (date == null) return "";
	    _sdf = new SimpleDateFormat("yyyy/MM/dd");
	    return ( _sdf.format(date));
	 }
	
	
	 /**
	 * Date type으로 넘어온 날짜를 각각의 포맷에 따라서
	     * 재구성하여 반환한다.<br><br>
	     *
	 * @param date   날짜
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyy-mm )
	 * @return String 변환된 문자열  ( yyyy-mm-dd )
	 * @return String 변환된 문자열  ( yyyy-mm-dd hh:mi )
	 * @return String 변환된 문자열  ( yyyy-mm-dd hh:mi:ss )
	 */
	public static String formatDate(Date date,int format) {
	    SimpleDateFormat _sdf=null;
	            if (date == null) return "";
	            if( format==YYYYMM)
	            	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM");
	            else if( format==YYYYMMDD)
	            	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM"+dateGubun+"dd");
	            else if( format==YYYYMMDDHHMI)
	            	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM"+dateGubun+"dd HH:mm");
	            else if( format==YYYYMMDDHHMISS)
	            	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM"+dateGubun+"dd HH:mm:ss");
	    return ( _sdf.format(date));
	}
	
	public static String formatDate(Date date,int format,String dg) {
	    SimpleDateFormat _sdf=null;
	            if (date == null) return "";
	            if( format==YYYYMM)
	            	_sdf = new SimpleDateFormat("yyyy"+dg+"MM");
	            else if( format==YYYYMMDD)
	            	_sdf = new SimpleDateFormat("yyyy"+dg+"MM"+dg+"dd");
	            else if( format==YYYYMMDDHHMI)
	            	_sdf = new SimpleDateFormat("yyyy"+dg+"MM"+dg+"dd HH:mm");
	            else if( format==YYYYMMDDHHMISS)
	            	_sdf = new SimpleDateFormat("yyyy"+dg+"MM"+dg+"dd HH:mm:ss");
	    return ( _sdf.format(date));
	}
	
	public static String formatDateKor(Date date) {
	    SimpleDateFormat _sdf=null;
	            if (date == null) return ""; 
	            	_sdf = new SimpleDateFormat("yyyy"+"년 "+"MM"+"월 "+"dd"+"일"); 
	    return ( _sdf.format(date));
	}
	
	
	 /**
	 * Date type으로 넘어온 날짜를 각각의 포맷에 따라서
	     * 재구성하여 반환한다.<br><br>
	     *
	 * @param date   날짜
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyymm )
	 * @return String 변환된 문자열  ( yyyymmdd )
	 * @return String 변환된 문자열  ( yyyymmdd hh:mi )
	 * @return String 변환된 문자열  ( yyyymmdd hh:mi:ss )
	 */
	public static String formatDateNoDateGubun(Date date,int format) {
	    SimpleDateFormat _sdf=null;
        if (date == null) return "";
        if( format==YYYYMM)
        	_sdf = new SimpleDateFormat("yyyy"+"MM");
        else if( format==YYYYMMDD)
        	_sdf = new SimpleDateFormat("yyyy"+"MM"+"dd");
        else if( format==YYYYMMDDHHMI)
        	_sdf = new SimpleDateFormat("yyyy"+"MM"+"dd HH:mm");
        else if( format==YYYYMMDDHHMISS)
        	_sdf = new SimpleDateFormat("yyyy"+"MM"+"dd HH:mm:ss");
        return ( _sdf.format(date));
	}
	
	 /**
	 *현재일 보다 계산된 날짜 리턴
	     *
	 * @param date   날짜
	 * @param aa Y,M,D
	 * @param dd 날짜계산 대상
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyymm )
	 * @return String 변환된 문자열  ( yyyymmdd )
	 * @return String 변환된 문자열  ( yyyymmdd hh:mi )
	 * @return String 변환된 문자열  ( yyyymmdd hh:mi:ss )
	 */
    public static String addDate(Date date ,String aa,  int dd,int format)   {

    	SimpleDateFormat _sdf = null;
    	if( format==YYYYMM)
        	_sdf = new SimpleDateFormat("yyyy"+"MM");
        else if( format==YYYYMMDD)
        	_sdf = new SimpleDateFormat("yyyy"+"MM"+"dd");
        else if( format==YYYYMMDDHHMI)
        	_sdf = new SimpleDateFormat("yyyy"+"MM"+"dd HH:mm");
        else if( format==YYYYMMDDHHMISS)
        	_sdf = new SimpleDateFormat("yyyy"+"MM"+"dd HH:mm:ss");
    	   

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);

        if (aa.equals("Y")) {
            calendar.add(Calendar.YEAR, dd);
        } else if (aa.equals("M")) {
            calendar.add(Calendar.MONTH, dd);
        } else if (aa.equals("D")) {
            calendar.add(Calendar.DATE, dd);
        }
        return _sdf.format(calendar.getTime());

    }


	
	
	 /**
	 * Date type으로 넘어온 날짜를 각각의 포맷에 따라서
	     * 재구성하여 반환한다.<br><br>
	     *
	 * @param date   날짜
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyy-mm ) 
	 */
	public static String formatStrinigDate(Object date) { 
	    
		String _tmp = "";
		String _result = "";
		if (date == null) return "";
		_tmp = String.valueOf(date); 
		if (_tmp.length()==8){
			_result = _tmp.substring(0,4) + dateGubun + _tmp.substring(4,6) + dateGubun + _tmp.substring(6,8) ;
		}
		
	    return _result;
	}
	
	
	 /**
	 * Date type으로 넘어온 날짜를 각각의 포맷에 따라서
	     * 재구성하여 반환한다.<br><br>
	     *
	 * @param date   날짜
	 * @param format 변환할 타입
	 * @return String 변환된 문자열  ( yyyymm )
	 * @return String 변환된 문자열  ( yyyymmdd )
	 * @return String 변환된 문자열  ( yyyymmdd hh:mi )
	 * @return String 변환된 문자열  ( yyyymmdd hh:mi:ss )
	 */
	public static String formatStrinigDate(Object date , int format) { 
	    
		
	    SimpleDateFormat _sdf=null;
        if (date == null) return "";
        if( format==YYYYMM)
        	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM");
        else if( format==YYYYMMDD)
        	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM"+dateGubun+"dd");
        else if( format==YYYYMMDDHHMI)
        	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM"+dateGubun+"dd HH:mm");
        else if( format==YYYYMMDDHHMISS)
        	_sdf = new SimpleDateFormat("yyyy"+dateGubun+"MM"+dateGubun+"dd HH:mm:ss");
        return ( _sdf.format(date));
          
	}
	
	
	
	 /**
	 * 문자열이 null인지 판별하여 null이면 defaultValue를 리턴하고
	 * 아니면 원 문자열을 그대로 리턴한다.<br><br>
	     *
	 * @param  str 문자열
	 * @param  defaultValue 디폴트값
	 * @return String 치환된 문자열
	 */
	public static String envl(String str, String defaultValue) {
	            if( str == null ) {
	                    return defaultValue;
	            } else if (str.equals(""))     {
	                    return defaultValue;
	            } else {
	                    return str;
	            }
	}
	
	public static String snvl(String str) {
	             if( str == null ) {
	                     return "0";
	             } else if (str.equals(""))     {
	                     return "0";
	             } else {
	                     return str;
	             }
	 }
	
	 /**
	 * 문자열이 null인지 판별하여 null이면 ""를 리턴하고
	 * 아니면 원 문자열을 그대로 리턴한다.<br><br>
	     *
	 * @param  str 문자열
	 * @param  defaultValue 디폴트값
	 * @return String 치환된 문자열
	 */
	public static String bnvl(Object str) {		 
			return nvl(String.valueOf(str),""); 	            
	}
	
	 /**
	 * 문자열이 null인지 판별하여 null이면 ""를 리턴하고
	 * 아니면 원 문자열을 그대로 리턴한다.<br><br>
	     *
	 * @param  str 문자열
	 * @param  defaultValue 디폴트값
	 * @return String 치환된 문자열
	 */
	public static String nvl(String str) {		 
			return nvl(str,""); 	            
	}
	
	 /**
	 * 문자열이 empty_value_string 인지 판별하여 empty_value_string 이면 defaultValue를 리턴하고
	 * 아니면 원 문자열을 그대로 리턴한다.<br><br>
	     *
	 * @param  str 문자열
	 * @param  defaultValue 디폴트값
	 * @return String 치환된 문자열
	 */
	public static String evl(String str, String defaultValue) {
		
		String tmp = str;		
		if (tmp == null) {
			 return "";
		}else{
			tmp = tmp.trim();
            if( tmp.length() == 0 ){
                    return defaultValue;
            }
            else {
                    return str;
            }
		}
	}
	
	 /**
	 * 문자열이 empty_value_string 인지 판별하여 empty_value_string 이면 ""를 리턴하고
	 * 아니면 원 문자열을 그대로 리턴한다.<br><br>
	     *
	 * @param  str 문자열
	 * @return String 치환된 문자열
	 */
	public static String evl(String str) {
	            return evl(str,"");
	}
	
	
	 /**
	 * 문자열 받아서 HTML 코드로 변환하는 메소드 <br><br>
	     * <xmp>
	     * <  : &lt;
	     * >  : &gt;
	     * &  : &amp;
	     * '  : '
	     * "  : "
	     * white space : &nbsp;
	     * \r\n : <br>
	     * </xmp>
	 * @param  text 문자열
	 * @return String 치환된 문자열
	 */
	public static String formatHTMLCode(String text) {
	        if( text == null || text.equals("") )
	                return "";

	        StringBuffer _sb = new StringBuffer(text);
	            char _ch;
	
	            for (int i = 0; i < _sb.length(); i++) {
	            	_ch = _sb.charAt(i);
	                if (_ch == '<') {
	                	_sb.replace(i,i+1,"&lt;");
	                	i += 3;
	                } else if (_ch == '>') {
	                	_sb.replace(i,i+1,"&gt;");
	                	i += 3;
	                } else if (_ch == '&') {
	                	_sb.replace(i,i+1,"&amp;");
	                	i += 4;
	                } else if (_ch == '\'') {
	                	_sb.replace(i,i+1,"\\\'");
	                	i += 1;
	                } else if (_ch == '"') {
	                	_sb.replace(i,i+1,"\\\"");
	                	i += 1;
	                } else if (_ch == '\r' && _sb.charAt(i+1) == '\n' ){
	                	_sb.replace(i,i+2,"<br>");
	                	i += 3;
	                }
	            }
	            return _sb.toString();
	}
	 
	  /**
	 * 문자열을 원하는 숫자포맷으로 변환하는 메소드<br><br>
	     *
	 * @param  number  문자열
	 * @param  group_b 세자리마다 ,를 찍을지 여부
	 * @param  pre     소수점 앞자리 길이
	 * @param  post    소수점 뒷자리 길이
	 * @param  percent 백분율(%)로 표시할지 여부
	 * @return String 치환된 문자열
	 */
	public static String formatNumber(Object pNumber, boolean group_b, int pre, int post){
		return formatNumber( pNumber,  group_b,  pre,  post,false);
	}
	public static String formatNumber(Object pNumber, boolean group_b, int pre, int post, boolean percent) {
		
			 String number = bnvl(pNumber);
		
	           DecimalFormat _df = new DecimalFormat("#,###.#####");
	           StringBuffer  _pattern = new StringBuffer();
	           
	           if (number == null){
	        	   return "0";
	           }else if ("".equals(number)){
	        	   return "0";
	           }else if ("0".equals(number)){
		        	   return "0";
	           }
		        	   
	               // pattern 결정
	            if( pre == 0 ){ //길이가 정해져 있지 않을 경우
	                    _pattern.append("####");
	            } else {
	                    for(int i=0; i<pre; i++)
	                            _pattern.append("#");
	            }
	
	            if( group_b )
	                    _pattern.insert(_pattern.length()-3,",");
	
	            if (number.indexOf(".")>0){	            	
	            	_pattern.append(".");
	            }
	            if( post == 0 ){
	            	_pattern.append("#####"); //소수점 아래자리 최대 5자리까지
	            } else {
	                    for(int i=0; i<post; i++)
	                    	 if (number.indexOf(".")>0){	_pattern.append("#");}
	            }
	            

	
	            if( percent )
	            	_pattern.append("%");
	
	            // 숫자 패턴으로 변환
	            _df.applyLocalizedPattern(_pattern.toString()); 
	            
	            try {
	                    if( number == null || number.equals("") ) {
	                            return "";
	                       } else {
	                               return _df.format(Long.parseLong(number));
	                       }
	            } catch (NumberFormatException e){
	                            try {
	                                return _df.format(Double.parseDouble(number));
	                        } catch (NumberFormatException e1){
	                                 return number.toString();
	                        }
	            }
	    }
	  
	
	/****************************************
	* \n 을 <br>로 바꾼다.
	* @param Auth
	* @return String 치환된 문자열
	*****************************************/
	public static String repl(String text)
	{
	    if( text == null || text.equals("") )
	    return "";
	
	    StringBuffer _sb = new StringBuffer(text);
	    char _ch;
	
	    for (int i = 0; i < _sb.length(); i++) {
	    	_ch = _sb.charAt(i);
	        if (_ch == '\r' && _sb.charAt(i+1) == '\n' )
	        {
	        	_sb.replace(i,i+2,"<br>");
	                //System.out.print(i);
	        	i += 3;
	        }
	    }
	    return _sb.toString();
	}
	
	/**
	 * 0을 공백으로 바꾼다.
	 *
	 * @param int
	 * @return String 치환된 문자열
	 */
	public static String nonZero(int ss) {
	  if (ss == 0) {
	    return "";
	  } else {
	    return String.valueOf(ss);
	  }
	}
	
	/**
	 * 0을 공백으로 바꾼다.
	 *
	 * @param double
	 * @return String 치환된 문자열
	 */
	public static String nonZero(double ss) {
	  if (ss == 0) {
	    return "";
	  } else {
	    return String.valueOf(ss);
	  }
	}
	
	/**
	 * 0을 공백으로 바꾼다.
	 * @param double
	 * @return String 치환된 문자열
	 */
	public static String nonZero(BigDecimal ss) {
	  if (ss.compareTo(new BigDecimal("0")) == 0) {
	    return "";
	  } else {
	    return ss.toString();
	  }
	}

    /**
     * 0을 공백으로 바꾼다.
     *
     * @param Auth
     * @return String 치환된 문자열
     */
    public static String nonZero(String ss) {
      if (ss == null) {
        return "";
      }
      if (ss.equals("0")) {
        return "";
      }
      if (ss.trim().equals("0")) {
        return "";
      }
      return ss;
    }
 
    /**
     * 3자리의 문자열 타입으로 변환한다.
     *
     * @param String
     * @return String 치환된 문자열
     */
    public static String addZero(String ss) {
    	
    	int len = ss.length();
    	String zero="";
    	for(int i=len; i<3; i++){
    		zero += "0";
    	}
      return zero+ss;
    }

    /**
     * yyyyMMdd또는 HHmm형태로 문자열을 리턴하는 메소드<br><br>
     *
     * @param  number  yyyyMMdd 또는 HHmm
     * @return String 치환된 문자열
     */
    public static String getCurrentDay_Time(String a) {
      SimpleDateFormat _sdf = new SimpleDateFormat("yyyyMMddHHmmss");
      String _current_date = _sdf.format( new Date());
      if(a.equals("yyMMdd")){
    	  _current_date = _current_date.substring(0,4) + dateGubun + _current_date.substring(4,6) + dateGubun + _current_date.substring(6,8) ;
      } else if(a.equals("YYYYMM")){
    	  _current_date = _current_date.substring(0,4) + _current_date.substring(4,6);
      } else if(a.equals("YYYYMMDDHH")){
    	  _current_date = _current_date.substring(0, 10);
      }else if(a.equals("HHmm")){
    	  _current_date = _current_date.substring(8, 10) + ":" + _current_date.substring(10, 12);
      }else{
    	  _current_date = "";
      }
      return _current_date;
    } 

    public static final char DOT = '.';
    public static final char COMMA = ',';

    public static final int YYYYMM=0;
    public static final int YYYYMMDD=1;
    public static final int YYYYMMDDHHMI=2;
    public static final int YYYYMMDDHHMISS=3;
    
    /**
     * 태그를 공백으로 바꾸기
     * @param str
     * @return
     */
    public static String kepReplaceBrAll(String str) { 
    	String tmp = String.valueOf(str); 
    	
    	tmp = tmp.replaceAll(  ">","&gt;");
    	tmp = tmp.replaceAll(  "<","&lt;");
    	tmp = tmp.replaceAll(  "&nbsp;", "&amp;nbsp;");
    	tmp = tmp.replaceAll(  "\"\"","&quot;");
    	tmp = tmp.replaceAll(  "'","&#39;");
		tmp = tmp.replaceAll(  "\"", "&#34;");
		
    	return tmp;
    }
    
    /**
     * Str 을 gubun 으로 split 후 list 에 담아 리턴한다.
     * @param str
     * @param gubun
     * @return
     */
    public static List<String> getStringArrary(String str,String gubun){
    	 List<String>_list = new ArrayList<String>();
    	 
    	 if(str !=null && !"".equals(str)){
    		 if(str.indexOf(gubun) != -1){	//복수건
 		    	String tmp[] = str.split(gubun);
 		    	for (int i=0; i<tmp.length; i++){
 		    		//System.out.println("tmp["+i+"] "+ tmp[i]);
 		    		_list.add(tmp[i]);
 		    	}
    		 }else{	//1건
    			 _list.add(str);
	    	}
    	 }
    	return _list;
    }
    
    /**
     * Str 을 gubun 으로 split 후 list 에 담아 리턴한다.
     * @param str
     * @param gubun
     * @return
     */
    public static String getStringInStr(String str,String gubun){
    	 StringBuffer sb = new StringBuffer();
    	String tmp[] = str.split(gubun);
    	sb.append("(");
    	if(tmp.length <= 1){
    		sb.append("'"+tmp[0]+"'");
    	}else{
        	for (int i=0; i<tmp.length; i++){
        		sb.append("'"+tmp[i]+"'");
        		if(i != tmp.length-1) sb.append(","); 
        	}
    	}
    	sb.append(")");
    	return sb.toString();
    }
    



public static String getMonthAgoDate(int month) {
    Calendar cal = Calendar.getInstance(new SimpleTimeZone(0x1ee6280, "KST"));
   cal.add(Calendar.MONTH ,month); // month 날짜 가져오기
      java.util.Date monthago = cal.getTime();
      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());
      return formatter.format(monthago);
  }

	public static String replace_string( String src , int len ){
	    int interval =  len - src.length();
	    for(int k =0 ; k < interval ; k++){
	        src += " ";
	    }       
	    return src;
	}

	@SuppressWarnings("unchecked")
	public static String getObjectListKeyValue(List<Object> pSelectList, String pKey, String pDf) {
		String _value = "";
		if (pSelectList == null){			
			_value = pDf; // 없을경우 넘어온 기본값으로
		}else{
			
			List<Object> _list = (List<Object>) pSelectList.get(0); 
			if (_list == null){			 
				_value = "";
			}else{
				Map<String, String> _Map = (Map<String, String> )_list.get(0); 
				_value = String.valueOf(_Map.get(pKey));
			}
		}
		return _value;
	}
	
	/**
	 * 이미지 리사이즈
	 * @param og_file 원래의파일
	 * @param new_file 새로운파일 (리사이즈될대상)
	 * @param w 리사이즈 가로길이
	 * @param h 리사이즈 세로길이
	 * @throws IOException 
	 * 
	 * http://blog.naver.com/jw43834?Redirect=Log&logNo=120178953378
	 */
	public static MultipartFile makeThumbnail(MultipartFile _multipartFile,int w,int h) {
		
		MultipartFile multi = null;
		try {

			File imgfile = new File(_multipartFile.getOriginalFilename());
			_multipartFile.transferTo(imgfile);
			Image originimg = ImageIO.read(imgfile);
						
			Image resizeimg = originimg.getScaledInstance(w, h, Image.SCALE_SMOOTH);
			BufferedImage thumbimg = new BufferedImage (w,h,BufferedImage.TYPE_INT_BGR);
			Graphics2D g = thumbimg.createGraphics();
			g.drawImage(resizeimg, 0, 0, w, h, null);
			ImageIO.write(thumbimg,"jpg",imgfile);
			
			DiskFileItem fileitem = new DiskFileItem("file", Files.probeContentType(imgfile.toPath()), false, imgfile.getName(), (int)imgfile.length(), imgfile.getParentFile());
			InputStream input = new FileInputStream(imgfile);
			OutputStream os = fileitem.getOutputStream();
			IOUtils.copy(input, os);
			multi = new CommonsMultipartFile(fileitem);
			
			return multi;
						
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new RuntimeException("이미지 등록에 실패했습니다.");
		}
	}

	/**
	 * 업로드 파일명 뒤에 밀리초 단위 시각을 붙여 매 업로드마다 다른 이름을 만든다.
	 * @param pDocNo 기준 이름(상품정보코드 등)
	 * @return pDocNo + "_" + yyyyMMddHHmmssSSS
	 */
	public static String makeUniqueFileName(String pDocNo) {
		return nvl(pDocNo) + "_" + new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	}

	/**
	 * 이미지 레터박스 리사이즈
	 * 원본 비율을 유지한 채 w x h 안에 들어가도록 축소하고, 흰색 w x h 캔버스 가운데에 배치한다.
	 * 원본이 w x h 보다 작으면 확대하지 않고 여백만 채운다.
	 * makeThumbnail 과 달리 비율을 무시한 강제 확대/축소를 하지 않는다.
	 * @param _multipartFile 원본 파일
	 * @param w 캔버스 가로길이
	 * @param h 캔버스 세로길이
	 * @return 리사이즈된 MultipartFile
	 */
	public static MultipartFile makeLetterboxImage(MultipartFile _multipartFile, int w, int h) {

		try {
			String _fileName = nvl(_multipartFile.getOriginalFilename());
			String _fmt = "jpg";
			int _dot = _fileName.lastIndexOf(".");
			if(_dot > -1){ _fmt = _fileName.substring(_dot + 1).toLowerCase(); }
			if("jpeg".equals(_fmt)){ _fmt = "jpg"; }

			String _contentType = "image/jpeg";
			if("png".equals(_fmt)){ _contentType = "image/png"; }
			if("gif".equals(_fmt)){ _contentType = "image/gif"; }

			BufferedImage originimg = ImageIO.read(_multipartFile.getInputStream());
			if(originimg == null){
				throw new RuntimeException("이미지 등록에 실패했습니다.");
			}

			int _ow = originimg.getWidth();
			int _oh = originimg.getHeight();
			double _scale = Math.min((double) w / _ow, (double) h / _oh);
			if(_scale > 1.0d){ _scale = 1.0d; }

			int _nw = (int) Math.round(_ow * _scale);
			int _nh = (int) Math.round(_oh * _scale);
			if(_nw < 1){ _nw = 1; }
			if(_nh < 1){ _nh = 1; }

			BufferedImage canvas = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
			Graphics2D g = canvas.createGraphics();
			g.setColor(Color.WHITE);
			g.fillRect(0, 0, w, h);
			g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
			g.setRenderingHint(RenderingHints.KEY_RENDERING,     RenderingHints.VALUE_RENDER_QUALITY);
			g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,  RenderingHints.VALUE_ANTIALIAS_ON);
			g.drawImage(originimg, (w - _nw) / 2, (h - _nh) / 2, _nw, _nh, null);
			g.dispose();

			ByteArrayOutputStream _bos = new ByteArrayOutputStream();
			if(!ImageIO.write(canvas, _fmt, _bos)){
				_bos.reset();
				ImageIO.write(canvas, "jpg", _bos);
			}
			byte[] _bytes = _bos.toByteArray();

			DiskFileItem fileitem = new DiskFileItem("file", _contentType, false, _fileName, _bytes.length, new File(System.getProperty("java.io.tmpdir")));
			OutputStream os = fileitem.getOutputStream();
			os.write(_bytes);
			os.close();

			return new CommonsMultipartFile(fileitem);

		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("이미지 등록에 실패했습니다.");
		}
	}

	public static void resize(String source, String destination, float scale) {
		try {
			File newFile = new File(destination);
			RenderedOp renderedOp = JAI.create("fileload", source);
	
			BufferedImage bufferedImage = renderedOp.getAsBufferedImage();
			int width = (int)(bufferedImage.getWidth() * scale);
			int height = (int)(bufferedImage.getHeight() * scale);
	
			BufferedImage bufferIm = new BufferedImage(width, height,
			BufferedImage.TYPE_INT_RGB);
			Graphics2D graphics2D = bufferIm.createGraphics();
			graphics2D.drawImage(bufferedImage, 0, 0, width, height, null);
			ImageIO.write(bufferIm, "jpg", newFile);
		} catch (Exception e){
			e.printStackTrace();
		}
	}

	
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param code 공통코드의 키 (공통테이블 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)  
	 * @param commonTableGubun (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getCodeCheckBoxList(String code,String commonTableGubun,String optionCode,String optionValue) throws Exception {

		if ("".equals(commonTableGubun)){
			commonTableGubun = "ICOMCOD1";
		}
		if ("".equals(optionCode)){
			optionCode = "CODE";
		}
		if ("".equals(optionValue)){
			optionValue = "TEXT1";
		}
		
		//System.out.println("commonTableGubun 	" +commonTableGubun);
		//System.out.println("optionCode " +optionCode);
		//System.out.println("optionValue 	" +optionValue);
		//System.out.println("code 	" +code);
		//System.out.println("dataValue 	" +dataValue);
		
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", commonTableGubun);
		_pMap.put("TYPE", code);
		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder(); 
		//System.out.println("_data 	" +_data);
		if (_data !=null){
			//System.out.println("_data.size() 	" +_data.size());
			for (int i=0; i<_data.size(); i++){				
				returnCode = nvl(_data.get(i).get(optionCode),"").trim();
				returnValue = nvl(_data.get(i).get(optionValue),"").trim();				 
				_sb.append("<input type='checkbox'  name='"+code+(i)+"' id='"+code+(i)+ "'  value='"+returnCode+ "'>"+ returnValue+"&nbsp;");			 
			}
		}
		 
		return _sb.toString();
	}
	
	
	/**
	 * 주소를 알아낸다.
	 * @param request
	 * @return String 치환된 문자열
	 */
	public static String getURL(HttpServletRequest request) {
		//System.out.println(request.getRequestURI());
		String tmp =  request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() ;
		return tmp ;
	}
	
	
	/**
	 * 링크를 걸기위한 준비
	 * @param request
	 * @return String 치환된 문자열
	 */
	public static String getSslURL(HttpServletRequest request , String flagUrl) {
		//System.out.println(request.getRequestURI());
		String flag = getDevRealLocalFlag(request);
		
		LOGGER.debug(" getSslURL 0 로컬 1 개발 2 운영 : {}", flag);
		String url = "";
		
		if ("2".equals(flag)){
			url =  "https";
		}else if ("1".equals(flag)){
			url =  "https";
		} else{
			url =  "http";
		} 
		
		if ("http".equals(flagUrl)){ // http 일경우에는 무조건 http
			url =  "http";
		}
		
		String tmp =  url + "://" + request.getServerName() ;
		/* 운영시 이걸로 대체 상대경로로 작업*/		  
		/*
		 * if ("1".equals(flag) || "0".equals(flag)){ tmp = ""; }
		 */
		tmp = "";
		LOGGER.debug(" getSslURL tmp : {}", tmp);
		
		
		return tmp ;
	}
	
	/**
	 * dev , next , localhost 인지 구분하여 리턴한다.
	 * 도메인변경되면 고쳐야합니다.
	 * 도메인 변경이 만약 있다면...
	 * @param request
	 * @return String 치환된 문자열(dev:1, local:0, real:2)
	 */
	public static String getDevRealLocalFlag(HttpServletRequest request) {
		StringBuffer url = (StringBuffer)request.getRequestURL();
		String urlStr = url.toString();
		String tmp = "";
		if (urlStr.indexOf("dev")>0){
			tmp = "1"; // 개발
		}else if (urlStr.indexOf("local")>0){
			tmp = "0"; // 로컬
		} else if (urlStr.indexOf("next")>0){
			tmp = "2"; // 운영
		} else if (urlStr.indexOf("www")>0){
			tmp = "2"; // 운영
		} else if (urlStr.indexOf("//koreab2b.com")>0){//http://koreab2b.com, koeab2b.com
			tmp = "2"; // 운영
		} else if (urlStr.indexOf("154")>0){
			tmp = "2"; // 운영
		} else if (urlStr.indexOf("156")>0){
			tmp = "2"; // 운영
		} else if (urlStr.indexOf("39")>0){ //로그인 용도 임시 로컬셋팅 2>0
			tmp = "0"; // 운영
		} else if (urlStr.indexOf("40")>0){ //로그인 용도 임시 로컬셋팅 2>0
			tmp = "0"; // 운영
		} else {
			tmp = "0"; // 로컬
		}

		return tmp ;
	}
	
	
	
    /**
     * 조회일 Convert( 슬래시'/' 제거)
     */
	public static Map<String, String> removeSlash(Map<String, String> params) {

		if (params != null){
			Set<String> key =null;
			Iterator<String> iterkey =null;
			key = params.keySet();
			iterkey = key.iterator();
			
			while(iterkey.hasNext()){
				String mapkey = iterkey.next();
				
				if(mapkey.indexOf("_date") > -1){
					String dateVal = (String)params.get(mapkey);
					if (dateVal.indexOf("/") > -1) {
						params.put(mapkey, dateVal.replace("/",""));
					}
				}
				
				if(mapkey.indexOf("_qty") > -1){
					String dateVal = (String)params.get(mapkey);
					if (dateVal.indexOf(",") > -1) {
						params.put(mapkey, dateVal.replace(",",""));
					}
				}
				
			}
		}
		
		return params;

	}
	
	// XSS 필터 2021.04.28 HSJ (공통 부분 삽입은 다른 화면에서 영향이 있어 조회구분에서 별도로 필요 시 사용)
	public static Map<String, String> xss_kep_filter(Map<String, String> params) {

		if (params != null){
			Set<String> key =null;
			Iterator<String> iterkey =null;
			key = params.keySet();
			iterkey = key.iterator();
			
			while(iterkey.hasNext()){
				String mapkey = iterkey.next();
				
				String _str = (String)params.get(mapkey);
				
				if (_str == null){
					_str = "";
				}else if ("null".equals(_str.trim())){
					_str = "";
				}else{ 
					_str = _str.trim();
				}

				// 특수문자 치환 추가 2021.04.27 HSJ
						
				_str = _str.replace("<", "&lt;");
				_str = _str.replace(">", "&gt;");
				_str = _str.replace("[(]", "&#40;");
				_str = _str.replace("[)]", "&#41;");
						
				params.put(mapkey, _str);
			}
		}
		
		return params;
	}
	public static Map<String, Object> xss_kep_filter_v2(Map<String, Object> params) {

		if (params != null){
			Set<String> key =null;
			Iterator<String> iterkey =null;
			key = params.keySet();
			iterkey = key.iterator();
			
			while(iterkey.hasNext()){
				String mapkey = iterkey.next();
				
				String _str = (String)params.get(mapkey);
				
				if (_str == null){
					_str = "";
				}else if ("null".equals(_str.trim())){
					_str = "";
				}else{ 
					_str = _str.trim();
				}

				// 특수문자 치환 추가 2021.04.27 HSJ
						
				_str = _str.replace("<", "&lt;");
				_str = _str.replace(">", "&gt;");
				_str = _str.replace("[(]", "&#40;");
				_str = _str.replace("[)]", "&#41;");
						
				params.put(mapkey, _str);
			}
		}
		
		return params;
	}
	
	/**
	 * 필드명/코드 취득
	 * 
	 * @param pMap
	 * @return
	 */
	public static Map<String, String> getFieldNames() {
		Map<String,String> _response =  new HashMap<String, String>();
//		List<Map<String, String>> _fieldNameList = commonInfoService.getFieldNames();
		List<Map<String,String>> _fieldNameList = StaticContextAccessor.getBean(CommonInfoDao.class).selectFieldNames();
		
		
		for(int i=0; i<_fieldNameList.size(); i++){
			Map<String,String> row = _fieldNameList.get(i);
			_response.put(row.get("COLUMN_ID"), row.get("COLUMN_NAME"));
		}
		// System.out.println("_response " +_response);
		return _response;
	}    	

	
	public static void downloadExcel(List<Map<String, String>> _data, HttpServletResponse response, OutputStream outputStream, String headers ) {
		downloadExcel( _data,  response,  outputStream,  headers , "file.xls");
	}
	/**
	 * 엑셀생성(JSP화면)
	 * 
	 * @param pMap
	 * @return
	 */
	public static void downloadExcel(List<Map<String, String>> _data, HttpServletResponse response, OutputStream outputStream, String headers ,String fileName) {
		FileOutputStream fos = null;
		 
		if(_data != null && _data.size()>0){
			
			try {
			response.setHeader("Content-Disposition", "attachment; filename="+java.net.URLEncoder.encode(fileName, "UTF-8"));
	        response.setHeader("Content-Description", "JSP Generated Data");
	        response.setContentType("application/vnd.ms-excel;charset=utf-8");
			  
	        HSSFWorkbook workbook = new HSSFWorkbook();
	        
			//Font 설정.
			HSSFFont font = workbook.createFont();
			font.setFontName(HSSFFont.FONT_ARIAL);
	
			//제목의 스타일 지정
			HSSFCellStyle titlestyle = workbook.createCellStyle();
			titlestyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
			titlestyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			titlestyle.setFont(font);

	        HSSFSheet sheet  = workbook.createSheet("FIRST SHEET"); 

			//내용 스타일 지정
			HSSFCellStyle style = workbook.createCellStyle();
			style.setFont(font);
	
			Map<String,String> fieldNames = CommonUtil.getFieldNames();
			
			//내용중 가운데 정렬 추가
			HSSFCellStyle styleCenter = workbook.createCellStyle();
			styleCenter.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleCenter.setFont(font);
			Map<String,String> _rowData = null;
			HSSFCell cell = null;
			String[] headerName = null;
			if (headers == null || "".equals(headers)){
				headerName = null;
			}else{
				headerName = headers.split("@@");
			}
			
			String []title = null;
			String []column = null;
			
			if (headerName != null && headerName.length == 2) {
				column =	headerName[1].split("\\|"); // 헤더컬럼 물리명
				title = 	headerName[0].split("\\|"); // 헤더 한글명
			}else if (headerName != null && headerName.length == 1) {
				title = null;
				column = 	headerName[0].split("\\|"); //  헤더컬럼 물리명
			}
			
			if (_data != null)
			{
				/*
				 * 해더 세팅 
				 */ 
				_rowData = _data.get(0);
				HSSFRow row = sheet.createRow((0));
				Set<String> keys = _rowData.keySet();				
				Iterator<String> iter = keys.iterator();
				int cellCnt = 0;
				if(headers != null && !"".equals(headers) && title !=null && column !=null ){ // 선택된 항목만 표시				-> 타이틀한글명@@타이틀테이블물리명
					
					for (int i=0; i<title.length; i++){  
						
					//	System.out.println("1-------------->"+headerName[i]);
								cell = row.createCell(cellCnt++);								 
								//헤더 셋팅
								cell.setCellValue(title[i]);
								cell.setCellStyle(titlestyle); 
					} 					
					
				}else if(headers != null && !"".equals(headers) && title ==null &&column !=null){ // 선택된 항목만 표시					->  타이틀테이블물리명
					
					for (int i=0; i<column.length; i++){  
						
					//	System.out.println("1-------------->"+headerName[i]);
								cell = row.createCell(cellCnt++);								 
								//헤더 셋팅
								cell.setCellValue(fieldNames.get(column[i]));
								cell.setCellStyle(titlestyle); 
					} 					
					
				}else{ // 항목 미존재
	 
					for(int j=0; j<keys.size(); j++){
						
						String searchName = iter.next();  
						//System.out.println("2-------------->"+searchName);
							cell = row.createCell(cellCnt++);
							 
								//헤더 셋팅
								cell.setCellValue(fieldNames.get(searchName));
								cell.setCellStyle(titlestyle);
							 
						}
					}
				
		 
					/*
					 * 실제 결과 세팅
					 */
					for (int i=0; i<_data.size();i++){
								_rowData = _data.get(i);
								HSSFRow dataRow = sheet.createRow((i+1));
								Set<String> dataKeys = _rowData.keySet();
								Iterator<String> dataIter = dataKeys.iterator();
								int dataCellCnt = 0;
								
								
								if(headers != null && !"".equals(headers) && column !=null){ // 선택된 항목만 표시					->  타이틀테이블물리명					
														
										for (int k=0; k<column.length; k++){ 			
											
											//System.out.println("3-------------->"+headerName[k]);
											cell = dataRow.createCell(dataCellCnt++);		
													//데이터 셋팅
													try{
														cell.setCellValue(CommonUtil.nvl2( _rowData.get(column[k]), ""));
													}catch (java.lang.ClassCastException e){
														cell.setCellValue(CommonUtil.bnvl( _rowData.get(column[k])));
													}catch (Exception e){
														cell.setCellValue("");
													}
													cell.setCellStyle(styleCenter);	  
											}
									 						
									
								}else{								
							
									for(int j=0; j<dataKeys.size(); j++){
									
										String searchName = dataIter.next();  
										
										//System.out.println("4-------------->"+searchName);
										
											cell = dataRow.createCell(dataCellCnt++);						 
											//데이터 셋팅
											try{
												cell.setCellValue(CommonUtil.nvl2( _rowData.get(searchName), ""));
											}catch (java.lang.ClassCastException e){
												cell.setCellValue(CommonUtil.bnvl( _rowData.get(searchName)));
											}catch (Exception e){
												cell.setCellValue("");
											}
											cell.setCellStyle(styleCenter);	 
									}
							}
					}
				}
			
	       
	       
 
	         workbook.write(outputStream);
	         outputStream.flush();
	           // fos = new FileOutputStream(new File("c:/CreateExcelDemo.xls"));
	            //workbook.write(fos);
	        } catch (Exception e) {
	            LOGGER.error("파일 쓰기 실패 : ",e);
	        } finally {
	            if (fos != null) {
	                try {
	                    fos.flush();
	                    fos.close();
	                } catch (IOException e) {
	                    LOGGER.error("파일 닫기 실패 : ",e);
	                }
	            }
	        }			
		} else {
			downloadExcelHeader(response, outputStream, headers ,fileName);
		}
	}    	
	
	/**
	 * 엑셀생성(JSP화면) 헤더 2줄 사용
	 * 
	 * @param pMap
	 * @return
	 */
	public static void downloadExcel2Headers(List<Map<String, String>> _data, HttpServletResponse response, OutputStream outputStream, String headers ,String fileName) {
		FileOutputStream fos = null;
		 
		if(_data != null && _data.size()>0){
			
			try {
			response.setHeader("Content-Disposition", "attachment; filename="+java.net.URLEncoder.encode(fileName, "UTF-8"));
	        response.setHeader("Content-Description", "JSP Generated Data");
	        response.setContentType("application/vnd.ms-excel;charset=utf-8");
			  
	        HSSFWorkbook workbook = new HSSFWorkbook();
	        
			//Font 설정.
			HSSFFont font = workbook.createFont();
			font.setFontName(HSSFFont.FONT_ARIAL);
	
			//제목의 스타일 지정
			HSSFCellStyle titlestyle = workbook.createCellStyle();
			titlestyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
			titlestyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			titlestyle.setFont(font);

	        HSSFSheet sheet  = workbook.createSheet("FIRST SHEET"); 

			//내용 스타일 지정
			HSSFCellStyle style = workbook.createCellStyle();
			style.setFont(font);
	
			Map<String,String> fieldNames = CommonUtil.getFieldNames();
			
			//내용중 가운데 정렬 추가
			HSSFCellStyle styleCenter = workbook.createCellStyle();
			styleCenter.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleCenter.setFont(font);
			Map<String,String> _rowData = null;
			HSSFCell cell = null;
			String[] headerName = null;
			if (headers == null || "".equals(headers)){
				headerName = null;
			}else{
				headerName = headers.split("@@");
			}
			
			String []title = null;
			String []title2 = null;
			String []column = null;
			
			if (headerName != null && headerName.length == 3) {
				title = 	headerName[0].split("\\|"); // 헤더 한글명
				title2 = 	headerName[1].split("\\|"); // 헤더 한글명 2번째 줄
				column =	headerName[2].split("\\|"); // 헤더컬럼 물리명
			}
			
			if (_data != null)
			{
				/*
				 * 해더 세팅 
				 */ 
				_rowData = _data.get(0);
				HSSFRow row = sheet.createRow((0));
				HSSFRow row2 = sheet.createRow((1));
				Set<String> keys = _rowData.keySet();				
				Iterator<String> iter = keys.iterator();
				int cellCnt = 0;
				if(headers != null && !"".equals(headers) && title !=null && column !=null ){ // 선택된 항목만 표시				-> 타이틀한글명@@타이틀테이블물리명
					
					for (int i=0; i<title.length; i++){  
						
								cell = row.createCell(cellCnt++);								 
								//헤더 셋팅
								cell.setCellValue(title[i]);
								cell.setCellStyle(titlestyle); 
					}
					
					cellCnt = 0; // 개행 후 첫 셀부터 생성
					
					for (int i=0; i<title2.length; i++){  
					
								cell = row2.createCell(cellCnt++);								 
								//헤더 셋팅
								cell.setCellValue(title2[i]);
								cell.setCellStyle(titlestyle); 
					}
				}else{ // 항목 미존재
	 
					for(int j=0; j<keys.size(); j++){
						
						String searchName = iter.next();  
							cell = row.createCell(cellCnt++);
							 
								//헤더 셋팅
								cell.setCellValue(fieldNames.get(searchName));
								cell.setCellStyle(titlestyle);
							 
						}
					}
				
		 
					/*
					 * 실제 결과 세팅
					 */
					for (int i=0; i<_data.size();i++){
								_rowData = _data.get(i);
								HSSFRow dataRow = sheet.createRow((i+2));
								Set<String> dataKeys = _rowData.keySet();
								Iterator<String> dataIter = dataKeys.iterator();
								int dataCellCnt = 0;
								
								
								if(headers != null && !"".equals(headers) && column !=null){ // 선택된 항목만 표시					->  타이틀테이블물리명					
														
										for (int k=0; k<column.length; k++){ 			
											
											cell = dataRow.createCell(dataCellCnt++);		
													//데이터 셋팅
													try{
														cell.setCellValue(CommonUtil.nvl2( _rowData.get(column[k]), ""));
													}catch (java.lang.ClassCastException e){
														cell.setCellValue(CommonUtil.bnvl( _rowData.get(column[k])));
													}catch (Exception e){
														cell.setCellValue("");
													}
													cell.setCellStyle(styleCenter);	  
											}
									 						
									
								}else{								
							
									for(int j=0; j<dataKeys.size(); j++){
									
										String searchName = dataIter.next();  
										
											cell = dataRow.createCell(dataCellCnt++);						 
											//데이터 셋팅
											try{
												cell.setCellValue(CommonUtil.nvl2( _rowData.get(searchName), ""));
											}catch (java.lang.ClassCastException e){
												cell.setCellValue(CommonUtil.bnvl( _rowData.get(searchName)));
											}catch (Exception e){
												cell.setCellValue("");
											}
											cell.setCellStyle(styleCenter);	 
									}
							}
					}
				}
			
	       
	       
 
	         workbook.write(outputStream);
	         outputStream.flush();
	           // fos = new FileOutputStream(new File("c:/CreateExcelDemo.xls"));
	            //workbook.write(fos);
	        } catch (Exception e) {
	            LOGGER.error("파일 쓰기 실패 : ",e);
	        } finally {
	            if (fos != null) {
	                try {
	                    fos.flush();
	                    fos.close();
	                } catch (IOException e) {
	                    LOGGER.error("파일 닫기 실패 : ",e);
	                }
	            }
	        }			
		} else {
			downloadExcelHeader(response, outputStream, headers ,fileName);
		}
	}
	
	public static void downloadExcelHeader(HttpServletResponse response, OutputStream outputStream, String headers ,String fileName) {
		 FileOutputStream fos = null;
			
		try {
			response.setHeader("Content-Disposition", "attachment; filename="+java.net.URLEncoder.encode(fileName, "UTF-8"));
	        response.setHeader("Content-Description", "JSP Generated Data");
	        response.setContentType("application/vnd.ms-excel;charset=utf-8");
			  
	        HSSFWorkbook workbook = new HSSFWorkbook();
	        
			//Font 설정.
			HSSFFont font = workbook.createFont();
			font.setFontName(HSSFFont.FONT_ARIAL);
	
			//제목의 스타일 지정
			HSSFCellStyle titlestyle = workbook.createCellStyle();
			titlestyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
			titlestyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			titlestyle.setFont(font);

	        HSSFSheet sheet  = workbook.createSheet("FIRST SHEET"); 

			//내용 스타일 지정
			HSSFCellStyle style = workbook.createCellStyle();
			style.setFont(font);
	
			Map<String,String> fieldNames = CommonUtil.getFieldNames();
			
			//내용중 가운데 정렬 추가
			HSSFCellStyle styleCenter = workbook.createCellStyle();
			styleCenter.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleCenter.setFont(font);
			HSSFCell cell = null;
			String[] headerName = null;
			if (headers == null || "".equals(headers)){
				headerName = null;
			}else{
				headerName = headers.split("@@");
			}
			
			String []title = null;
			String []column = null;
			
			if (headerName != null && headerName.length == 2) {
				column =	headerName[1].split("\\|"); // 헤더컬럼 물리명
				title = 	headerName[0].split("\\|"); // 헤더 한글명
			}else if (headerName != null && headerName.length == 1) {
				title = null;
				column = 	headerName[0].split("\\|"); //  헤더컬럼 물리명
			}
			
			HSSFRow row = sheet.createRow((0));
			int cellCnt = 0;
			if(headers != null && !"".equals(headers) && title !=null && column !=null ){ // 선택된 항목만 표시				-> 타이틀한글명@@타이틀테이블물리명
				
				for (int i=0; i<title.length; i++){  
					
				//	System.out.println("1-------------->"+headerName[i]);
							cell = row.createCell(cellCnt++);								 
							//헤더 셋팅
							cell.setCellValue(title[i]);
							cell.setCellStyle(titlestyle); 
				} 					
				
			}else if(headers != null && !"".equals(headers) && title == null &&column !=null){ // 선택된 항목만 표시					->  타이틀테이블물리명
				
				for (int i=0; i<column.length; i++){  
					
				//	System.out.println("1-------------->"+headerName[i]);
							cell = row.createCell(cellCnt++);								 
							//헤더 셋팅
							cell.setCellValue(fieldNames.get(column[i]));
							cell.setCellStyle(titlestyle); 
				}
			}
			workbook.write(outputStream);
			outputStream.flush();
			// fos = new FileOutputStream(new File("c:/CreateExcelDemo.xls"));
			//workbook.write(fos);
        } catch (Exception e) {
            LOGGER.error("파일 쓰기 실패 : ",e);
        } finally {
            if (fos != null) {
                try {
                    fos.flush();
                    fos.close();
                } catch (IOException e) {
                    LOGGER.error("파일 닫기 실패 : ",e);
                }
            }
        }		
	}    	
	
/*	@SuppressWarnings("unchecked")
	public static String  requestSetting(HttpServletRequest req){
		
		StringBuilder sb = new StringBuilder();
		Enumeration<String> en = req.getAttributeNames();
		String key = "";
		String value = "";
		while (en.hasMoreElements()) {
			key = en.nextElement();
			value = req.getParameter(key);
			
			//sb.append("$(#"+key+").val("+value+")\n");
			
			
			sb.append("xxxxxx("+key+","+value+")\n");
		}
		
		
		//System.out.println(sb.toString());
		
		return sb.toString();
	}*/
	

	@SuppressWarnings("unchecked")
	public static Map<String, String> getRequestMapDatas(HttpServletRequest req) throws Exception {

		Map<String, String> mp = new HashMap<String,String>();
		try {

			String[] savename = null;
			if (req.getParameter("s_SAVENAME") != null) {
				savename = req.getParameter("s_SAVENAME").split("\\|");
			}

			Enumeration<String> e = req.getParameterNames();
			while (e.hasMoreElements()) {
				String name = e.nextElement();
				String value = "";
				if (savename == null) {
					value = req.getParameter(name);
					mp.put(name, value);
					//System.out.println(name + " = " + value);
				} else {
					int count = 0;
					for (int i = 0; i < savename.length; i++) {
						if (name.equals(savename[i])) {
							count = 1;
						}
					}
					if (count == 0) {
						value = req.getParameter(name);
						mp.put(name, value);
						//System.out.println(name + " = " + value);
					}
				}
			}
		} catch (Exception e) {
			LOGGER.error("폼 데이터 수집 중 에러 발생!", e);
			throw new RuntimeException(e);
		}
		return mp;
	}	
	
	
	
	
	
	/**
	 * jsp 특수로직 결과 리턴
	 * @param comCode comCode
	 * @param slgId 특수로직ID
	 * @param returnColumnName 리턴할 컬럼명 -- 쿼리참조
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getSpecialCheckReturn(String comCode,String slgId, String returnColumnName)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		_map.put("slgId", slgId);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturn(_map); 
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 if(_rmap.get(returnColumnName) != null) {
					 _ret = _rmap.get(returnColumnName).toString();	 
				 }
			 }
		}
		 
		return _ret;
		  
	} 
	
	/**
	 * jsp 특수로직 결과 리턴
	 * @param comCode comCode
	 * @param slgId 특수로직ID
	 * @param req 세션정보
	 * @param returnColumnName 리턴할 컬럼명 -- 쿼리참조
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getSpecialCheckReturn(String comCode,String slgId, String returnColumnName, HttpServletRequest req) {
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		_map.put("slgId", slgId);		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturn(_map); 
		SessionInfo _h_sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String h_userType = "U";//일반, 관리자 A 
		if (_h_sessionInfo != null)
			h_userType =  CommonUtil.nvl((String)_h_sessionInfo.getUserType());// 사용자구분(M,A,U)
		boolean clcsUseBuyerFlag = false;
		boolean adminUserFlag = false;
		boolean clcsFlag = false;
		if("KRCOWA0002".equals(comCode) || "KRCOWA0003".equals(comCode) || "KRCOWA0007".equals(comCode) || "KRCOWA0008".equals(comCode))
			clcsUseBuyerFlag = true;
		if("A".equals(h_userType))
			adminUserFlag = true;
		clcsFlag = clcsUseBuyerFlag && !adminUserFlag;//clcs이면서 관리자이면 clcs전용 장바구니 사용
		if(clcsFlag && ("COL01_DATA".equals(returnColumnName) || "COL02_DATA".equals(returnColumnName) || "COL04_DATA".equals(returnColumnName)))
			returnColumnName = "COL05_DATA";
		if (_data != null){
			if (_data.size() > 0){
				_rmap = _data.get(0);
				_ret = _rmap.get(returnColumnName).toString();
			}
		}
		
		return _ret;
		
	} 
	
	
	
	/**
	 * jsp 특수로직 존재여부 리턴
	 * @param comCode comCode
	 * @param slgId 특수로직ID 
	 * @return boolean - true 해당 특수로직존재 , false 해당특수로직 미존재
	 * @throws Exception
	 */
	public static boolean getSpecialCheckReturn(String comCode,String slgId)   {
		 
		boolean _ret = true;
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		_map.put("slgId", slgId);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturn(_map); 
		
		if (_data == null){
			_ret = false;
		}else if (_data.size() == 0){
			_ret = false;
		}
		return _ret;
		  
	} 
	/**
	 * jsp 특수로직 존재여부 리턴
	 * @param comCode comCode
	 * @param slgId 특수로직ID 
	 * @return boolean - true 해당 특수로직존재 , false 해당특수로직 미존재
	 * @throws Exception
	 */
	public static boolean getCodeCheckReturn(String codeType,String codCode)   {
		 
		boolean _ret = true;
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("codeType", codeType);
		_map.put("codCode", codCode);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCodeCheckReturn(_map); 
		
		if (_data == null){
			_ret = false;
		}else if (_data.size() == 0){
			_ret = false;
		}
		return _ret;
		  
	} 
	/**
	 * jsp 특수로직 존재여부 리턴
	 * @param comCode comCode
	 * @param slgId 특수로직ID 
	 * @return boolean - true 해당 특수로직존재 , false 해당특수로직 미존재
	 * @throws Exception
	 */
	public static boolean getCode2CheckReturn(String codeType,String codCode,String comCode)   {
		 
		boolean _ret = true;
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("codeType", codeType);
		_map.put("codCode", codCode);
		_map.put("comCode", comCode);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCode2CheckReturn(_map); 
		
		if (_data == null){
			_ret = false;
		}else if (_data.size() == 0){
			_ret = false;
		}
		return _ret;
		  
	}
	/**
	 * jsp 공통코드 존재여부 리턴
	 * @param codeType, codCode, comCode 
	 * @return boolean - true 해당 데이터 존재 , false 해당 데이터 미존재
	 * @throws Exception
	 */
	public static boolean getCode3CheckReturn(String codeType,String codCode,String comCode)   {
		 
		boolean _ret = true;
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("codeType", codeType);
		_map.put("codCode", codCode);
		_map.put("comCode", comCode);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCode3CheckReturn(_map); 
		
		if (_data == null){
			_ret = false;
		}else if (_data.size() == 0){
			_ret = false;
		}
		return _ret;
		  
	}
	
	/**
	 * jsp 공통코드 존재여부 리턴
	 * @param codeType, codCode1, codCode2, comCode, text1, text2, text3, text4 모든 조건 이용 가능 
	 * @return boolean - true 해당 데이터 존재 , false 해당 데이터 미존재
	 * @throws Exception
	 */
	public static boolean getCode3CheckReturnCodeAllParam(String codeType,String codCode1,String codCode2,String comCode,String text1,String text2,String text3,String text4)   {
		 
		boolean _ret = true;
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("codeType", codeType);
		_map.put("codCode1", codCode1);
		_map.put("codCode2", codCode2);
		_map.put("comCode", comCode);
		_map.put("text1", text1);
		_map.put("text2", text2);
		_map.put("text3", text3);
		_map.put("text4", text4);
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCode3CheckReturnCodeAllParam(_map); 
		
		if (_data == null){
			_ret = false;
		}else if (_data.size() == 0){
			_ret = false;
		}
		return _ret;
		  
	}
	
	/**
	 * jsp 특수로직 결과 리턴
	 * @param comCode getCode2TextReturn
	 * @param slgId 특수로직ID
	 * @param returnColumnName 리턴할 컬럼명 -- 쿼리참조
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getCode2TextReturn(String codeType,String codCode,String comCode, String returnColumnName)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("codeType", codeType);
		_map.put("codCode", codCode);
		_map.put("comCode", comCode);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCode2CheckReturn(_map); 
		
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 if( _rmap.get(returnColumnName) != null){
					 _ret = _rmap.get(returnColumnName).toString();
				 }
			 }
		}
		return _ret;
		  
	} 
	/**
	 * jsp 특수로직 존재시 해당 쿼리 결과 리스트로 리턴
	 * @param comCode comCode
	 * @param slgId  
	 * @return List
	 * @throws Exception
	 */
	public static List<Map<String,String>>  getSpecialCheckReturnList(String comCode,String slgId)   {
		  
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		_map.put("slgId", slgId);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturn(_map); 
		 
		return _data;
		  
	} 
	
	/**
	 * jsp 특수로직 존재시 해당 쿼리 결과 리스트로 리턴
	 * @param comCode comCode
	 * @param slgId  
	 * @return List
	 * @throws Exception
	 */ 
	public static Map<String, String> getSpecialCheckReturnMap(String comCode,String slgId)   {
		  
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = null;
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		_map.put("slgId", slgId);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturn(_map); 
		LOGGER.debug("_data_data {} ",_data);
		if (_data != null) {
			if (_data.size()>0){
				_rmap = _data.get(0);
			}
		} 
		
		return _rmap;
		  
	} 
	
	/**
	 * 해당 고객사가 거래명세표의 특수로직 대상 고객사인지 조회 
	 * @param comCode
	 * @return slgId
	 * @throws Exception
	 */ 
	public static Map<String, String> getSpecialCheckReturnSheetMap(String st_buyer)   {
		  
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = null;
		List<Map<String,String>> _data = null;
		_map.put("st_buyer", st_buyer);
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturnSheetMap(_map); 
		LOGGER.debug("_data_data {} ",_data);
		if (_data != null) {
			if (_data.size()>0){
				_rmap = _data.get(0);
			}
		} 
		
		return _rmap;
		  
	} 	
	
	
	
	/**
	 * 화승 네트웍스의 부서 조회 
	 * @param comCode
	 * @return slgId
	 * @throws Exception
	 */ 
	public static String getSpecialCheckReturnSheetMapByDept(Map<String, String>  _map)   {
		  
		String _data = "";
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturnSheetMapByDept(_map); 

		
		return _data;
		  
	} 
	
	/**
	  * 주어진 길이(iLength)만큼 주어진 문자(cPadder)를 strSource의 왼쪽에 붙혀서 보내준다.
	  * ex) lpad("abc", 5, '^') ==> "^^abc"
	  *     lpad("abcdefghi", 5, '^') ==> "abcde"
	  *     lpad(null, 5, '^') ==> "^^^^^"
	  *
	  * @param strSource
	  * @param iLength
	  * @param cPadder
	  */
	 public static String lpad(String strSource, int iLength, char cPadder){
	  StringBuffer sbBuffer = null;

	  if (strSource != null){
	   int iByteSize = getByteSize(strSource);
	   if (iByteSize > iLength){
	    return strSource.substring(0, iLength);
	   }else if (iByteSize == iLength){
	    return strSource;
	   }else{
	    int iPadLength = iLength - iByteSize;
	    sbBuffer = new StringBuffer();
	    for (int j = 0; j < iPadLength; j++){
	     sbBuffer.append(cPadder);
	    }
	    sbBuffer.append(strSource);
	    return sbBuffer.toString();
	   }
	  }

	  //int iPadLength = iLength;
	  sbBuffer = new StringBuffer();
	  for (int j = 0; j < iLength; j++){
	   sbBuffer.append(cPadder);
	  }
	  return sbBuffer.toString();
	 }

	 /**
	  * 주어진 길이(iLength)만큼 주어진 문자(cPadder)를 strSource의 오른쪽에 붙혀서 보내준다.
	  * ex) rpad("abc", 5, '^') ==> "abc^^"
	  *     rpad("abcdefghi", 5, '^') ==> "abcde"
	  *     rpad(null, 5, '^') ==> "^^^^^"
	  *
	  * @param strSource
	  * @param iLength
	  * @param cPadder
	  */
	 public static String rpad(String strSource, int iLength, char cPadder){
	  StringBuffer sbBuffer = null;
	  if (strSource != null){
	   int iByteSize = getByteSize(strSource);
	   if (iByteSize > iLength){
	    return strSource.substring(0, iLength);
	   }else if (iByteSize == iLength){
	    return strSource;
	   }else{
	    int iPadLength = iLength - iByteSize;
	    sbBuffer = new StringBuffer(strSource);
	    for (int j = 0; j < iPadLength; j++){
	     sbBuffer.append(cPadder);
	    }
	    return sbBuffer.toString();
	   }
	  }
	  sbBuffer = new StringBuffer();
	  for (int j = 0; j < iLength; j++){
	   sbBuffer.append(cPadder);
	  }
	  return sbBuffer.toString();
	 }

	 /**
	  *  byte size를 가져온다.
	  *
	  * @param str String target
	  * @return int bytelength
	  */
	 public static int getByteSize(String str){
	  if (str == null || str.length() == 0)
	   return 0;
	  byte[] byteArray = null;
	   try{
	   byteArray = str.getBytes("UTF-8");
	  }catch (Exception ex){}
	  if (byteArray == null) return 0;
	  return byteArray.length;
	 }

	public static boolean NumberChk(String str){
	    char c = ' ';	 
	    if(str.equals("")) return false;	 
	    for(int i = 0 ; i < str.length() ; i++){
	    	c = str.charAt(i);
	        if(c < 48 || c > 59){
	            return false;
	        }
	    }
	    return true;
	}		
	

	/**
	 * str1을 str2의 문자로 자른후 배열로 return해준다.
	 * 
	 * @param str1
	 * @param str2
	 * @return
	 */
	public static String[] StrToArray(String str1, String str2) {
		StringTokenizer localStringTokenizer = new StringTokenizer(str1, str2, false);
		int i = localStringTokenizer.countTokens();
		String[] arrayOfString = new String[i];
		for (int j = 0; j < i; j++){
			arrayOfString[j] = localStringTokenizer.nextToken().trim();
			if (arrayOfString[j].length() == 0) {
				arrayOfString[j] = " ";
			}
		}
		return arrayOfString;
	}	
	
	/**
	 * action id 조회 - 현재 작업중인지 확인
	 * @param comCode comCode
	 * @param slgId  
	 * @return List
	 * @throws Exception
	 */
	public static String  getActionIdList(String actionId)   {
		
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		String actionFlag = "N";
		
		_map.put("actionId", actionId);	
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getActionId(_map); 
		
		if(_data.size() > 0){
			actionFlag = "Y";
		}
		
		return actionFlag;
		  
	} 

	public static String getCartCnt(HttpServletRequest req) throws Exception {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		String cartCnt = "";
		
		_map.put("BUYER", _sessionInfo.getComCode());
		_map.put("USER_ID", _sessionInfo.getUserId());
		_map.put("DEPT", _sessionInfo.getDepartment());
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCartCnt(_map); 
		Map<String,String> _statusCountData = null;
		if(_data.size() > 0){
			_statusCountData = _data.get(0);
			cartCnt = CommonUtil.bnvl(_statusCountData.get("CART_CNT")); // 장바구니 갯수를 알아내기 위한처리
		}
		return cartCnt;

	}
	public static String getCartCnt_v2(HttpServletRequest req) throws Exception {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		String cartCnt = "";
		
		_map.put("BUYER", _sessionInfo.getComCode());
		_map.put("USER_ID", _sessionInfo.getUserId());
		_map.put("DEPT", _sessionInfo.getDepartment());
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCartCnt_v2(_map); 
		Map<String,String> _statusCountData = null;
		if(_data.size() > 0){
			_statusCountData = _data.get(0);
			cartCnt = CommonUtil.bnvl(_statusCountData.get("CART_CNT")); // 장바구니 갯수를 알아내기 위한처리
		}
		return cartCnt;

	}
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method 
	 * @param code 공통코드의 키 (공통테이블 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * @param gubun ALL,SEL 
	 * @param dataValue data 실제의값 selected 를 위한
	 * @param commonTableGubun (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getCode3ComboList(String code,String gubun,String dataValue,String dataValue1,String commonTableGubun,String optionCode,String optionValue) throws Exception {


		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", "_"+commonTableGubun);
		if(commonTableGubun.equals("ICOMCOD3")){
			_pMap.put("BUYER", code);
			_pMap.put("TYPE", dataValue);
			_pMap.put("CODE1", dataValue1);
		}else if(commonTableGubun.equals("ICOMCOD1")){
			_pMap.put("TYPE", dataValue);
		}

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){
				if(commonTableGubun.equals("ICOMCOD3")){
					returnCode = nvl(_data.get(i).get("CODE2"),"").trim();
					returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();
				}else if(commonTableGubun.equals("ICOMCOD1")){
					returnCode = nvl(_data.get(i).get("CODE"),"").trim();
					returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();
				}
				
				if (returnCode.equals(optionCode)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	}
	/*jsp 에서 호출하여 select처리 말고 직접 list로 받기 위함*/
	public static List<Map<String,String>> getCode3List(String code,String gubun,String dataValue,String dataValue1,String commonTableGubun,String optionCode,String optionValue) throws Exception {


		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", "_"+commonTableGubun);
		if(commonTableGubun.equals("ICOMCOD3") || commonTableGubun.equals("ICOMCOD3_v2")){
			_pMap.put("BUYER", code);
			_pMap.put("TYPE", dataValue);
			_pMap.put("CODE1", dataValue1);
		}else if(commonTableGubun.equals("ICOMCOD1")){
			_pMap.put("TYPE", dataValue);
		}

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		 
		return _data;
	}
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method - ID 암호화 정보 포함(통합 사용자ID 전용) 
	 * @param code 공통코드의 키 (공통테이블 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * ICOMCOD1(TYPE),ICOMCOD2(COMPANY_CODE),ICOMCOD3(BUYER),ICOMCOD4(BUYER),ICOMCOD1(COMPANY_CODE)
	 * @param gubun ALL,SEL 
	 * @param dataValue data 실제의값 selected 를 위한
	 * @param commonTableGubun (공통테이블구분 ICOMCOD1,ICOMCOD2,ICOMCOD3,ICOMCOD4,ICOMCOD5)
	 * @param optionCode 화면에 뿌릴 option code
	 * @param optionValue 화면에 뿌릴 option value  
	 * @return
	 * @throws Exception
	 */
	public static String getUnionUserIdList(String code,String gubun,String dataValue,String dataValue1,String commonTableGubun,String optionCode,String optionValue) throws Exception {

		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("COMMONTABLEGUBUN", "_"+commonTableGubun);
		_pMap.put("BUYER", code);
		_pMap.put("TYPE", dataValue);
		_pMap.put("CODE1", dataValue1);

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getBCombo(_pMap);
		String returnCode = "";
		String returnValue = "";
		
		StringBuilder _sb = new StringBuilder();
		
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		
		if (_data !=null){
			for (int i=0; i<_data.size(); i++){
				returnCode = nvl(_data.get(i).get("CODE2"),"").trim();
				returnValue = nvl(_data.get(i).get("TEXT1"),"").trim();
				
				String st_o_user_id = returnCode;
				byte[] plainText = st_o_user_id.getBytes();
				byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
				returnCode = SeedCbcAlgorithmUtil.getString(bszDigest);
				
				if (dataValue1.equals(st_o_user_id)){
					_sb.append("<option value='"+returnCode+ "' selected>"+returnValue+"</option>");
				}else{ 
					_sb.append("<option value='"+returnCode+ "'>"+ returnValue+"</option>");
				}
			}
		}
		 
		return _sb.toString();
	}
	
    public static String printStackTraceToString(Throwable e) {
        StringBuffer sb = new StringBuffer();
        try {
            sb.append(e.toString());
            sb.append("\n");
            StackTraceElement element[] = e.getStackTrace();
            for (int idx = 0; idx < element.length; idx++) {
                sb.append("\tat ");
                sb.append(element[idx].toString());
                sb.append("\n");
            }
        } catch (Exception ex) {
            return e.toString();
        }
        return sb.toString();
    }
    
    /**
	 * jsp KEP_BUYER_FLAG 테이블 특정 컬럼값 리턴
	 * @param comCode 
	 * @param columnName
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getKepBuyerFlagColumnReturn(String comCode, String returnColumnName)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getKepBuyerFlagColumnReturn(_map); 
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 _ret = _rmap.get(returnColumnName).toString();
			 }
		}
		 
		return _ret;
		  
	}
	
	/**
	 * jsp 특수로직 결과 리턴
	 * @param comCode getCode3RoleReturn
	 * @param slgId 특수로직ID
	 * @param returnColumnName 리턴할 컬럼명 -- 쿼리참조
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getCode3RoleReturn(String codeType,String codCode,String comCode, String returnColumnName)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("codeType", codeType);
		_map.put("codCode", codCode);
		_map.put("comCode", comCode);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCode3RoleReturn(_map); 
		
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 if( _rmap.get(returnColumnName) != null){
					 _ret = _rmap.get(returnColumnName).toString();
				 }
			 }
		}
		return _ret;
		  
	} 
	/**
	 * 사용자 카테고리지정별 고객사 상품검색
	 * @return List
	 * @throws Exception
	 */
	public static List<Map<String,String>>  getSpecialCategUserList(String comCode,String userId,String type)   {
		  
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("_st_SessionComCode", comCode);
		_map.put("_st_session_user_id", userId);
		_map.put("_st_type", type);
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCategUserList(_map); 
		return _data;
		  
	} 
	/**
	 * 카테고리지정별 고객사 상품검색
	 * @return List
	 * @throws Exception
	 */
	public static boolean getSpecialCategUserBoolean(String comCode,String userId,String type)   {
		boolean _ret = true;
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("_st_SessionComCode", comCode);
		_map.put("_st_session_user_id", userId);
		_map.put("_st_type", type);		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCategUserBoolean(_map); 
		if (_data == null){
			_ret = false;
		}else if (_data.size() == 0){
			_ret = false;
		}
		return _ret;
	}
	/**
	 * 개인정보 동의 FLAG
	 * @param comCode comCode
	 * @param slgId 특수로직ID
	 * @param returnColumnName 리턴할 컬럼명 -- 쿼리참조
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getInfoAgreeReturn(String userId, String returnColumnName)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("userId", userId);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getInfoAgreeReturn(_map); 
		
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 _ret = _rmap.get(returnColumnName).toString();
			 }
		}
		 
		return _ret;
		  
	} 
	/**
	 * ICOMCOD3 DATA TRUE/FALSE 
	 * @return List
	 * @throws Exception
	 */
	public static boolean getIcomcod3Boolean(String comCode,String userId,String type)   {
		boolean _ret = true;
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("_st_SessionComCode", comCode);
		_map.put("_st_session_user_id", userId);
		_map.put("_st_type", type);		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getIcomcod3Boolean(_map); 
		if (_data == null){
			_ret = false;
		}else if (_data.size() == 0){
			_ret = false;
		}
		return _ret;
	}
	/**
	 * getMD5Encrypt 암호화 
	 * @return String
	 * 
	 */
	public static String getMD5Encrypt(String str){
		String type = "MD5";
        String resCode = null;
        try{
                  //MessageDigest 인스턴스 생성
                  MessageDigest md = MessageDigest.getInstance(type);
                  //출력: 해쉬값업데이트 후에 16진수 문자로 변환 
                  md.update(str.getBytes(), 0, str.length());
                  resCode = new BigInteger(1, md.digest()).toString(16);
        }catch(Exception e){}
        return resCode;

	}
	/**
	 * jsp ICOMCOD2 텍스트 가져오는 함수
	 * @param comCode 고객사코드
	 * @param type icomcod2.type
	 * @param code icomcod2.code  
	 * @return List
	 * @throws Exception
	 */ 
	public static Map<String, String> getIcomCode2ReturnMap(String comCode,String type,String code)   {
		  
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = null;
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		_map.put("type", type);
		_map.put("code", code);
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getIcomCode2ReturnMap(_map); 
		LOGGER.debug("_data_data {} ",_data);
		if (_data != null) {
			if (_data.size()>0){
				_rmap = _data.get(0);
			}
		} 
		
		return _rmap;
		  
	} 
	/**
	 * jsp 결재타입 여부
	 * @param comCode docuType
	 * @param slgId 특수로직ID
	 * @param returnColumnName 타입여부 Y/N
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getDocuTypeCheckReturn(String comCode,String docuType)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("comCode", comCode);
		_map.put("docuType", docuType);		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getDocuTypeCheckReturn(_map); 
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 _ret = _rmap.get("DOCU_YN").toString();
			 }
		}
		 
		return _ret;
		  
	} 
	/**
	 * jsp 에서 직접 호출 가능하게 만든 method  rowCnt만큼 동적생성
	 * @param optionCode 화면에 뿌릴 option code
	 * @return
	 * @throws Exception
	 */
	public static String getDynamicComboList(String gubun, String rowCnt, String optionValue) throws Exception {

		int cnt =Integer.parseInt(rowCnt);
		StringBuilder _sb = new StringBuilder();
		if ("SEL".equals(gubun)){
			_sb.append("<option value=''>선택</option>");
		}else if ("ALL".equals(gubun)){
			_sb.append("<option value=''>전체</option>");
		} else if ("NO".equals(gubun)){			
			_sb.append("");
		}
		for (int i=1; i<=cnt ; i++){
			String chkData = Integer.toString(i);
			if (chkData.equals(optionValue)){
				_sb.append("<option value='"+chkData+ "' selected>"+chkData+"</option>");
			}else{ 
				_sb.append("<option value='"+chkData+ "'>"+ chkData+"</option>");
			}
		}
		 
		return _sb.toString();
	} 
	/**
	 * 회사_개인정보 수정 FLAG
	 */
	public static String getInfoUpdateReturn(String userId, String returnColumnName)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("userId", userId);		
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getInfoUpdateReturn(_map); 
		
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 _ret = _rmap.get(returnColumnName).toString();
			 }
		}
		 
		return _ret;
		  
	}
	
	public static Integer getCharCount(String str, char c){
		Integer count = 0;
		for(int i=0; i<str.length();i++){
			if(str.charAt(i) == c){
				count++;
			}
		}
		return count;
	} 
	/**
	 * 상품검색 페이징처리
	 */
	public static String getPageSearchView( String pSearchMethod ,String pTp, String pCp, String pLm) { 
		

		StringBuilder _sb = new StringBuilder();	
		
		String _tp ="";
		String _cp ="";
		String _lm ="";

		int _pageLimit = 10;
		if (pTp == null || "".equals(pTp) )  { _tp = "0"; } else {  _tp = pTp;  }
		if (pCp == null || "".equals(pCp) ) { _cp = "1"; } else {  _cp = pCp;  }
		if (pLm == null || "".equals(pLm) ) {			
			_lm = "";
		}else{
			_lm = pLm;
			
			int _totalpage = Integer.parseInt(_tp);
			int _curPage = Integer.parseInt(_cp);
			int _limit = Integer.parseInt(_lm);
			
			if((_totalpage%_limit) == 0){
				_totalpage = _totalpage / _limit;
			}else{
				_totalpage = (_totalpage / _limit) + 1;
			} 
			
			int _startPage   = 0;
			int _endPage     = 0;
			  
			if((_curPage%_pageLimit) == 0)
				_startPage = (_curPage/_pageLimit)*_pageLimit -9; 
			else
				_startPage = (_curPage/_pageLimit)*_pageLimit +1;
			 
		
			_endPage = _startPage+9;
		
		
			if(_endPage > _totalpage)
				_endPage = _totalpage;
			 
			if (_totalpage>0){
				if (_startPage>1){
					_sb.append("&nbsp;&nbsp;<a href='javascript:"+pSearchMethod+"("+(_startPage-1)+")';><p class='Previous'>이전</p></a>");
				}
			} 
			 
	
			for(int i = _startPage; i<=_endPage; i++)
			{
			    if(_curPage == i)
			    {
			    	_sb.append("<p  style='color:#e8340c;'>"+i+"</p>");
			    }
			    else
			    {
			    	_sb.append("<a href='javascript:"+pSearchMethod+"("+i+")'><p>"+i+"</p></a>");
			    }
		
		
			    if(i != _endPage)
			    {
			    	_sb.append("&nbsp;|&nbsp;");
			    }
			}
			
			if(_curPage < _totalpage){ 
				if(_endPage < _totalpage){  
					_sb.append("&nbsp;&nbsp;<a href='javascript:"+pSearchMethod+"("+(_endPage+1)+")'; ><p class='next'>다음</p></a>");
				}
			}
		}


		return _sb.toString();
		
	}
	//IP 가져오는 함수
	public static String getRemoteAddr(HttpServletRequest request) {
        String ip = null;
        ip = request.getHeader("X-Forwarded-For");
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getHeader("Proxy-Client-IP"); 
        } 
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getHeader("WL-Proxy-Client-IP"); 
        } 
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getHeader("HTTP_CLIENT_IP"); 
        } 
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getHeader("HTTP_X_FORWARDED_FOR"); 
        }
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getHeader("X-Real-IP"); 
        }
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getHeader("X-RealIP"); 
        }
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getHeader("REMOTE_ADDR");
        }
        if (ip ==  null || ip.length() == 0|| "unknown".equalsIgnoreCase(ip)){ 
            ip = request.getRemoteAddr(); 
        }
        return ip;
    }
	/**
	 * jsp 특수로직 결과 리턴
	 * @param comCode getCodeTextReturn
	 * @param slgId 특수로직ID
	 * @param returnColumnName 리턴할 컬럼명 -- 쿼리참조
	 * @return 컬럼값
	 * @throws Exception
	 */
	public static String getCodeTextReturn(String codeType,String codCode,String comCode, String returnColumnName)  {
		 
		String _ret = "";
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, String> _rmap = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("codeType", codeType);
		_map.put("codCode", codCode);
		
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getCodeTextReturn(_map); 
		
		
		if (_data != null){
			 if (_data.size() > 0){
				 _rmap = _data.get(0);
				 if( _rmap.get(returnColumnName) != null){
					 _ret = _rmap.get(returnColumnName).toString();
				 }
			 }
		}
		return _ret;
		  
	}
	
	// 이름, 아이디 마스킹
	public static String nameMasking(String name) throws Exception {
		int name_length = name.length();
		String name_first_word = "";
		String name_last_word = "";
		String dot = "";
		
		if(name_length == 0) {
			// 그대로 반환
		}else {
			if(name_length == 1) { // 홍 -> *
				dot = "*";
			}else if(name_length == 2) { // 김구 -> 김*
				name_first_word = name.substring(0, 1);
				dot = "*";
			}else if(name_length > 2) { // 홍길동 -> 홍*동, 산다라박 -> 산**박 
				name_first_word = name.substring(0, 1);
				name_last_word = name.substring(name_length-1, name_length);
			}else {
				// 그대로 반환
			}
			
			for(int i=1; i<name_length-1; i++) {
				dot += "*";
			}
			
			name = name_first_word + dot + name_last_word;
		}

		return name;
	}
	
	// 이메일 마스킹(앞3자리 이후 '@'전까지 마스킹)
	public static String emailMasking(String email) throws Exception {
		email = email.replaceAll("(?<=.{2}).(?=.*@)", "*");
		return email;
	}
	
	// 전화번호 마스킹(가운데 숫자 4자리 마스킹)
	public static String phoneMasking(String phoneNo) throws Exception {
		int phoneNo_length = phoneNo.length();
		String check_first_word = "";
		String phoneNo_first_word = "";
		String phoneNo_last_word = "";
		String dot = "";

		if(phoneNo_length < 4) {
			// 그대로 반환
		}else {
			check_first_word = phoneNo.substring(0, 3);

			// 휴대폰인 경우
			if(check_first_word == "010" || check_first_word == "011" || check_first_word == "016" || check_first_word == "017" || check_first_word == "018" || check_first_word == "019") {
				// 풀 자리수 체크
				if(phoneNo_length < 8) { // 맨앞, 맨뒤만 유지하고 * 표시
					phoneNo_first_word = phoneNo.substring(0, 1);
					phoneNo_last_word = phoneNo.substring(phoneNo_length-1, phoneNo_length);
					for(int i=1; i<phoneNo_length-1; i++) { // 0*1
						dot += "*";
					}
				}else if(phoneNo_length > 7 && phoneNo_length < 12) { // - 없이 번호로만 구성, 가운데 자리수 3자리 가능성 있음
					phoneNo_first_word = phoneNo.substring(0, 3);
					phoneNo_last_word = phoneNo.substring(phoneNo_length-4, phoneNo_length);
					for(int i=3; i<phoneNo_length-4; i++) { // 010****5678
						dot += "*";
					}
				}else if(phoneNo_length == 12) { // 011-123-4567 기대값
					phoneNo_first_word = phoneNo.substring(0, 3);
					phoneNo_last_word = phoneNo.substring(phoneNo_length-4, phoneNo_length);
					for(int i=4; i<phoneNo_length-5; i++) { // 011-***-4567
						dot += "*";
					}
				}else if(phoneNo_length == 13) { // 010-1234-5678 기대값
					phoneNo_first_word = phoneNo.substring(0, 3);
					phoneNo_last_word = phoneNo.substring(phoneNo_length-4, phoneNo_length);
					for(int i=4; i<phoneNo_length-5; i++) { // 010-****-5678
						dot += "*";
					}
				}else { // 자리수 맞지 않음. 일괄로 앞에 3자리, 뒤에 4자리 제외한 * 표시
					phoneNo_first_word = phoneNo.substring(0, 3);
					phoneNo_last_word = phoneNo.substring(phoneNo_length-4, phoneNo_length);
					for(int i=3; i<phoneNo_length-4; i++) { // 010*******4567
						dot += "*";
					}
				}
			}else{ // 일반전화, 인터넷전화, 국제전화 경우
				// 풀 자리수 체크
				if(phoneNo_length < 10) { // 10자리도 안되면 이름과 같이 맨앞/맨뒤만 빼고 나머지 * 표시
					phoneNo_first_word = phoneNo.substring(0, 1); // 012
					phoneNo_last_word = phoneNo.substring(phoneNo_length-1, phoneNo_length); //1234
					for(int i=1; i<phoneNo_length-1; i++) { // 0**3, 0***4, 0****5, 0*****6
						dot += "*";
					}
				}else { // 앞에 3자리, 뒤에 4자리 제외한 * 표시 
					phoneNo_first_word = phoneNo.substring(0, 3);
					phoneNo_last_word = phoneNo.substring(phoneNo_length-4, phoneNo_length);
					for(int i=3; i<phoneNo_length-4; i++) { // 029*****4567, 070*****1234, 82-*****1234
						dot += "*";
					}
				}
			}
			
			phoneNo = phoneNo_first_word + dot + phoneNo_last_word;
		}
		
		return phoneNo;
	}
	
	public static void setJID(String id) {
		JID= id;
	}
	
	public static String getJID(){
		return JID;
	}
	
	public static void setSESSION_PASS_FLAG(String str) {
		SESSION_PASS_FLAG = str;
	}
	
	public static String getSESSION_PASS_FLAG(){
		return SESSION_PASS_FLAG;
	}

	/**
	 * 로컬 파일 저장 (개발 환경용)
	 * @param file 업로드할 MultipartFile 객체
	 * @param path 저장할 디렉토리 경로 (예: "C:/kepFileUplad/ITEM_IMAGE/MSDS/2025-01-20")
	 * @param fileName 저장할 파일명 (예: "COMPANY_1737362735123_00000001")
	 * @throws IOException 파일 저장 실패 시
	 */
	public static void saveToLocal(MultipartFile file, String path, String fileName) throws IOException {
		// 디렉토리 생성 (없으면 자동 생성)
		File directory = new File(path);
		if (!directory.exists()) {
			directory.mkdirs();
		}

		// 파일 저장
		File destFile = new File(path + File.separator + fileName);
		file.transferTo(destFile);
	}
	/**
	 * 검색엔진쪽 데이터의 나의등록상품 여부 확인용 
	 * @return List
	 * @throws Exception
	 */
	public static String getMyItemYn_v2(Map<String, String> pMap)   {
		HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId());
		
		String myItemYn = StaticContextAccessor.getBean(CommonCodeDao.class).getMyItemYn_v2(pMap); 
		return myItemYn;
		  
	}
	/**
	 * 해당 메뉴의 tab정보들 가져오기
	 * @return List
	 * @throws Exception
	 */
	public static List<Map<String,String>>  getMenuTabInfo_v2(String menuId,String userId)   {
		  
		Map<String, String> _map = new HashMap<String, String>();
		List<Map<String,String>> _data = null;
		_map.put("st_upper_menu_id", menuId);
		_map.put("st_user_id", userId);
		_data = StaticContextAccessor.getBean(CommonCodeDao.class).getMenuTabInfo_v2(_map); 
		return _data;
		  
	}
}
    

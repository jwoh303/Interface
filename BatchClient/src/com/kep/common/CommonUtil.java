package com.kep.common;

import java.lang.reflect.Field;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;

public class CommonUtil {
	
	private static Logger log	= Logger.getLogger( CommonUtil.class.getName() );
	public static final String localUploadPath = "C:/kepFileUplad"; // 로컬 파일업로드 대상
	public static final String realUploadPath = "attfiles"; // 개발,리얼 파일업로드 대상 
	public static final String realImgUploadPath = "/item_image"; // 개발,리얼 상품이미지 대상
	public static final String realImgUploadRegisterPath = "/data/item_image"; // 개발,리얼 상품이미지 대상
	public static final String realCbcPath = "/data/attfiles/kep"; // 개발,리얼 파일업로드 대상
	
	public static final String dateGubun = "/";
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
    
    public static HashMap<String, Object> convertVoToMap(Object obj, String type) {
    	HashMap<String, Object> rtnMap	= new HashMap<String, Object>();
    	
    	Field[] fList = obj.getClass().getDeclaredFields(); 
    	
    	for(Field fItem : fList) {
    		String fId	= fItem.getName();
    		Object fData	=	null;
			String funcName	= "";
    		try {
    			/**
    			 * T01 : 필드id를 함수에 그대로 사용할 경우 (예:COMPANY_CODE, CompanyCode)
    			 * T02 : 필드id를 함수에 그대로 사용하지 않고 첫자리를 대문자로 치환할 경우 (예:companyCode, sCompanyCode)
    			 */
    			
    			if ("T01".equals(type)) {
    				funcName = "get"+fId;	
    			} else if ("T02".equals(type)) {
    				funcName = "get"+ fId.substring(0, 1).toUpperCase() + fId.substring(1);
    			}
    			fData	= obj.getClass().getDeclaredMethod( funcName ).invoke(obj);	
			} catch (Exception e) {
			}
    		log.debug("["+type+" / " + funcName + "] : " + fId + " = " + fData);
    		
    		rtnMap.put(fId, fData);
    	}
    	
    	return rtnMap;
    }


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
				folder = "/data/attfile_sr" +"/"+"SR";  //  /myserver/kep/newdoc/attfile_sr/SR // 추가디렉토리
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
				folder = realImgUploadRegisterPath +"/"+"ITEM_IMAGE/MSDS";// /myserver/kep/newdoc/attfiles/ITEM_IMAGE/MSDS
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
			} else {
				folder = realUploadPath +"/"+"TEMP";  // /myserver/kep/newdoc/attfiles/TEMP
			} 
		}
		
		return folder;
	}
}

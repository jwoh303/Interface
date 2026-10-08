package com.koreab2b.mro.seller.mpcl.dao;

import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.util.CommonAwsS3;
import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpClCatalogDao")
@Transactional
public class SellerMpClCatalogDaoImpl implements SellerMpClCatalogDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpClCatalogDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		//고객사코드
		List<String> list = CommonUtil.getStringArrary((String) formData.get("st_buyer_code"), "@");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.putAll(formData);
		param.put("st_buyer_code", list);
		
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCatalogList", param);
	}
	
	// 조회
	public List<Map<String,String>> selectExcelList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCatalogExcelList", formData);
	}
	
	// 재고등록
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상등록되었습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.insert("seller.mpcl.updateSellerMpClCatalog", formData);
				sqlSessionTemplate.update("seller.mpcl.insertSellerMpClCatalogStockReg",formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재고품목으로 등록 실패하였습니다. \n\n담당자에게 연락바랍니다.");
		}
	return _rtnMsg;
		
	}
	/**
	 * saveSellerMpClCatalogImg
	 */
	public String saveSellerMpClCatalogImg(FileUploadForm uploadForm,Map<String, String> formData) {
		
		String _st_update = formData.get("st_query2").toString();
		String _user_id = formData.get("agentUserid").toString();
		String _agentComCode = formData.get("agentComCode").toString();
		
		Map<String,String> _data = null;
		String _rtnMsg = "이미지등록 요청되었습니다.";

		try {

			//이미지 저장
			 String  _IMGLIST[] = _st_update.split("\\|"); 
			 if (_IMGLIST == null){
				 logger.debug("_IMGLIST 미존재 ");
			 }else{
				 
				 
				 logger.debug(" _IMGLIST.length  " + _IMGLIST.length );
				 if (_IMGLIST.length >0){
					 for( int i=0 ; i < _IMGLIST.length; i++){ 
				        String str[] =  _IMGLIST[i].split("@@",-1);  
						for( int k=0; k < str.length; k++){
							logger.debug("str["+k+"]==>" + str[k] );
	                   } 
				        if (str != null){
							//상품이미지 저장
				        	String  sIM = getOrderNo(_agentComCode, "IM");
				        	_data = new HashMap<String,String>() ;
					        _data.put("_agentComCode", _agentComCode);
					        _data.put("_user_id", _user_id);
					        _data.put("IMG_REQ_NO", sIM); 
					        _data.put("BUYER", str[0]);
					        _data.put("BUYER_ITEM_NO", str[1]);
					        _data.put("IMGFILE_NAME",  str[2]);
					        _data.put("IMGFILE_DIR",   str[3]);
					        _data.put("DETAIL_IMGFILE_NAME", str[4]);
					        _data.put("DETAILIMGFILE_DIR",   str[5]);

					        sqlSessionTemplate.update("seller.mpcl.insertSellerMpClCatalogKEPREQIMGReg", _data);  
					        
						 }				         
					 }					  
				 }				  
			 } 
	
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("이미지 등록요청에 실패하였습니다.");
		}

		return null;
	}
	/** 이미지등록
	 * saveSellerMpClCatalogImgFile
	 */
	public String saveSellerMpClCatalogImgFile(FileUploadForm uploadForm,Map<String, String> formData) {

		String _path = "";
		String _exc = "";
		String UniqFileName = "";
		String _newDir = "";
		try {
			List<MultipartFile> _files = uploadForm.getFiles();

			String osName = System.getProperty("os.name");
			_newDir = CommonUtil.formatDate(new Date(),0,"")+"TEMP";
			_path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
			String _agentComCode = formData.get("agentComCode");
			String docNo = _agentComCode+String.valueOf(System.currentTimeMillis());
			String passFlag = "Y";
			logger.debug("docNo  {} " ,docNo);
			 File f = new File(_path);
				if(!f.isDirectory()) {
					f.mkdirs();
					logger.debug("폴더생성 {} " ,f);
				}else{
					logger.debug("폴더이미존재 {} " ,f);
				}
			if (null != _files && _files.size() > 0) {
				logger.debug("_files.size()  {} " ,_files.size());
				for (MultipartFile _multipartFile : _files) {
					if(passFlag.equals("Y")){
					String _fileName = _multipartFile.getOriginalFilename();
					_exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
					if(_fileName.isEmpty()) continue;

					UniqFileName = docNo;
					logger.debug("UniqFileName+_exc {} " ,UniqFileName+_exc);
					File _destFile = new File(_path + "/" + UniqFileName+_exc);

					if ("".equals(_fileName)) {
						logger.debug("_fileName null ");
					} else {
						try {
							//파일이 존재하면 삭제함.
							if (_destFile.exists()){
								_destFile.delete();
							}
							CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc);
							passFlag  = "N";
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}

					/*
					 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
					 * 예제임니다...추후 사용하세요.
					 * CommonUtil.makeThumbnail
					 */
					//CommonUtil.makeThumbnail(_path + "/" + UniqFileName+ "r"+_exc, _path + "/" + UniqFileName+_exc, 500, 500);
					}
				}//end of for
			}


		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("이미지 등록요청에 실패하였습니다.");
		}

		return "ITEM_IMAGE/" +_newDir+"@@"+UniqFileName+_exc;
	}
	/** 상세이미지등록
	 * saveSellerMpClCatalogDetailImgFile
	 */
	public String saveSellerMpClCatalogDetailImgFile(FileUploadForm uploadForm,Map<String, String> formData) {

		String _path = "";
		String _exc = "";
		String UniqFileName = "";
		String _newDir = "";
		try {
			List<MultipartFile> _files = uploadForm.getFiles2();

			String osName = System.getProperty("os.name");
			_newDir = CommonUtil.formatDate(new Date(),0,"")+"TEMP_DESC";
			_path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
			String _agentComCode = formData.get("agentComCode");
			String docNo = _agentComCode+String.valueOf(System.currentTimeMillis());
			String passFlag = "Y";
			logger.debug("docNo  {} " ,docNo);
			 File f = new File(_path);
				if(!f.isDirectory()) {
					f.mkdirs();
					logger.debug("폴더생성 {} " ,f);
				}else{
					logger.debug("폴더이미존재 {} " ,f);
				}
			if (null != _files && _files.size() > 0) {
				logger.debug("_files.size()  {} " ,_files.size());
				for (MultipartFile _multipartFile : _files) {
					if(passFlag.equals("Y")){
					String _fileName = _multipartFile.getOriginalFilename();
					_exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
					if(_fileName.isEmpty()) continue;

					UniqFileName = docNo;
					logger.debug("UniqFileName+_exc {} " ,UniqFileName+_exc);
					File _destFile = new File(_path + "/" + UniqFileName+_exc);

					if ("".equals(_fileName)) {
						logger.debug("_fileName null ");
					} else {
						try {
							//파일이 존재하면 삭제함.
							if (_destFile.exists()){
								_destFile.delete();
							}
							CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc);
							passFlag  = "N";
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}

					/*
					 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
					 * 예제임니다...추후 사용하세요.
					 * CommonUtil.makeThumbnail
					 */
					//CommonUtil.makeThumbnail(_path + "/" + UniqFileName+ "r"+_exc, _path + "/" + UniqFileName+_exc, 500, 500);
					}
				}//end of for
			}


		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("이미지 등록요청에 실패하였습니다.");
		}

		return "ITEM_IMAGE/" +_newDir+"@@"+UniqFileName+_exc;
	}
	/** 이미지등록 (v2 - 나노초 포함, AWS S3)
	 * saveSellerMpClCatalogImgFile_v2
	 */
	public String saveSellerMpClCatalogImgFile_v2(FileUploadForm uploadForm,Map<String, String> formData) {

		String _path = "";
		String _exc = "";
		String UniqFileName = "";
		String _newDir = "";
		try {
			List<MultipartFile> _files = uploadForm.getFiles();

			String osName = System.getProperty("os.name");
			_newDir = CommonUtil.formatDate(new Date(),0,"")+"TEMP";
			_path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
			String _agentComCode = formData.get("agentComCode");
			// 타임스탬프 + 나노초로 고유성 보장 (중복 파일명 방지)
			String docNo = _agentComCode+String.valueOf(System.currentTimeMillis())+String.valueOf(System.nanoTime() % 100000);
			String passFlag = "Y";
			logger.debug("docNo  {} " ,docNo);
			 File f = new File(_path);
				if(!f.isDirectory()) {
		            f.mkdirs();
		            logger.debug("폴더생성 {} " ,f);
		        }else{
		        	logger.debug("폴더이미존재 {} " ,f);
		        }
			if (null != _files && _files.size() > 0) {
				logger.debug("_files.size()  {} " ,_files.size());
				for (MultipartFile _multipartFile : _files) {
					if(passFlag.equals("Y")){
					String _fileName = _multipartFile.getOriginalFilename();
					_exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
					if(_fileName.isEmpty()) continue;

					UniqFileName = docNo;
					logger.debug("UniqFileName+_exc {} " ,UniqFileName+_exc);
					File _destFile = new File(_path + "/" + UniqFileName+_exc);

					if ("".equals(_fileName)) {
						logger.debug("_fileName null ");
					} else {
						try {
							//파일이 존재하면 삭제함.
							if (_destFile.exists()){
								_destFile.delete();
							}
							CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc);
							passFlag  = "N";
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}

					/*
					 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
					 * 예제임니다...추후 사용하세요.
					 * CommonUtil.makeThumbnail
					 */
					//CommonUtil.makeThumbnail(_path + "/" + UniqFileName+ "r"+_exc, _path + "/" + UniqFileName+_exc, 500, 500);
					}
				}//end of for
			}


		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("이미지 등록요청에 실패하였습니다.");
		}

		return "ITEM_IMAGE/" +_newDir+"@@"+UniqFileName+_exc;
	}
	/** 상세이미지등록 (v2 - 나노초 포함, AWS S3)
	 * saveSellerMpClCatalogDetailImgFile_v2
	 */
	public String saveSellerMpClCatalogDetailImgFile_v2(FileUploadForm uploadForm,Map<String, String> formData) {

		String _path = "";
		String _exc = "";
		String UniqFileName = "";
		String _newDir = "";
		try {
			List<MultipartFile> _files = uploadForm.getFiles2();

			String osName = System.getProperty("os.name");
			_newDir = CommonUtil.formatDate(new Date(),0,"")+"TEMP_DESC";
			_path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
			String _agentComCode = formData.get("agentComCode");
			// 타임스탬프 + 나노초로 고유성 보장 (중복 파일명 방지)
			String docNo = _agentComCode+String.valueOf(System.currentTimeMillis())+String.valueOf(System.nanoTime() % 100000);
			String passFlag = "Y";
			logger.debug("docNo  {} " ,docNo);
			 File f = new File(_path);
				if(!f.isDirectory()) {
		            f.mkdirs();
		            logger.debug("폴더생성 {} " ,f);
		        }else{
		        	logger.debug("폴더이미존재 {} " ,f);
		        }
			if (null != _files && _files.size() > 0) {
				logger.debug("_files.size()  {} " ,_files.size());
				for (MultipartFile _multipartFile : _files) {
					if(passFlag.equals("Y")){
					String _fileName = _multipartFile.getOriginalFilename();
					_exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
					if(_fileName.isEmpty()) continue;

					UniqFileName = docNo;
					logger.debug("UniqFileName+_exc {} " ,UniqFileName+_exc);
					File _destFile = new File(_path + "/" + UniqFileName+_exc);

					if ("".equals(_fileName)) {
						logger.debug("_fileName null ");
					} else {
						try {
							//파일이 존재하면 삭제함.
							if (_destFile.exists()){
								_destFile.delete();
							}
							CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc);
							passFlag  = "N";
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}

					/*
					 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
					 * 예제임니다...추후 사용하세요.
					 * CommonUtil.makeThumbnail
					 */
					//CommonUtil.makeThumbnail(_path + "/" + UniqFileName+ "r"+_exc, _path + "/" + UniqFileName+_exc, 500, 500);
					}
				}//end of for
			}


		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("이미지 등록요청에 실패하였습니다.");
		}

		return "ITEM_IMAGE/" +_newDir+"@@"+UniqFileName+_exc;
	}
	// 채번
	public String getOrderNo(String cmpyId, String docType) throws Exception {
		String returnValue = null;
		Map<String, String> pMap = new HashMap<String, String>();

		pMap.put("COM_CODE", cmpyId);
		pMap.put("DOC_TYPE", docType);
		try {
			returnValue = sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
			logger.debug("채번 - returnValue : {}  ", returnValue);

			if (returnValue == null || "".equals(returnValue) || returnValue.isEmpty()) {
				sqlSessionTemplate.insert("common.insertDocuNo", pMap);

				String year = "" + Calendar.getInstance().get(Calendar.YEAR);
				returnValue = docType + year.substring(2, 4) + "000001";
			} else {
				sqlSessionTemplate.update("common.updateDocuNo", pMap);
			}
			logger.debug("채번 - returnValue :  {}  ", returnValue);

		} catch (Exception e) {
			logger.debug("채번 Exception : ", e);
			throw new RuntimeException("채번 취득에 실패하였습니다.");
		} finally {
			logger.debug("채번 - returnValue :  {}  ", returnValue);
		}
		return returnValue;
	}
	// 이미지등록요청 상세
	public List<Map<String,String>> getSellerMpClCatalogImgPopList(Map<String,String> formData){

		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCatalogImgPopList", formData);

	}

	/**
	 * 거래품목 조회 (리뉴얼 - v2)
	 * - 페이징 없음
	 * - 새로운 검색 조건 적용
	 * - 고객사 다중 선택 지원 (콤마 구분 문자열 → 배열 변환)
	 *
	 * @param formData 검색 파라미터 (buyerCode, imageStatus, origin, manufacturer, itemName, specification, st_com_code)
	 * @return 조회된 거래품목 리스트
	 */
	public List<Map<String,String>> selectListV2(Map<String,String> formData) {
		// 고객사코드 다중 선택 처리 (콤마로 구분된 문자열 → 리스트 변환)
		String buyerCode = formData.get("buyerCode");
		List<String> buyerCodeList = CommonUtil.getStringArrary(buyerCode, ",");

		Map<String, Object> param = new HashMap<String, Object>();
		param.putAll(formData);
		param.put("buyerCodeList", buyerCodeList);

		// MyBatis selectList 호출 (리뉴얼 - v2 쿼리 ID)
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCatalogListV2", param);
	}

	/**
	 * 거래품목 조회 (리뉴얼 - v2) - 페이징
	 * - 무한 스크롤용 페이징 처리
	 * - 고객사 다중 선택 지원 (콤마 구분 문자열 → 배열 변환)
	 *
	 * @param formData 검색 파라미터 (startRow, endRow 포함)
	 * @return 조회된 거래품목 리스트
	 */
	public List<Map<String,String>> selectListV2Paging(Map<String,String> formData) {
		// 고객사코드 다중 선택 처리 (콤마로 구분된 문자열 → 리스트 변환)
		String buyerCode = formData.get("buyerCode");
		List<String> buyerCodeList = CommonUtil.getStringArrary(buyerCode, ",");

		Map<String, Object> param = new HashMap<String, Object>();
		param.putAll(formData);
		param.put("buyerCodeList", buyerCodeList);

		// 페이징 파라미터를 Integer로 변환 (Oracle ROWNUM 비교용)
		String startRowStr = formData.get("startRow");
		String endRowStr = formData.get("endRow");
		if (startRowStr != null && !startRowStr.isEmpty()) {
			param.put("startRow", Integer.parseInt(startRowStr));
		}
		if (endRowStr != null && !endRowStr.isEmpty()) {
			param.put("endRow", Integer.parseInt(endRowStr));
		}

		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCatalogListV2Paging", param);
	}

	/**
	 * 거래품목 총 건수 조회 (리뉴얼 - v2)
	 * - 무한 스크롤용 총 건수
	 * - 고객사 다중 선택 지원 (콤마 구분 문자열 → 배열 변환)
	 *
	 * @param formData 검색 파라미터
	 * @return 총 건수
	 */
	public int selectListV2Count(Map<String,String> formData) {
		// 고객사코드 다중 선택 처리 (콤마로 구분된 문자열 → 리스트 변환)
		String buyerCode = formData.get("buyerCode");
		List<String> buyerCodeList = CommonUtil.getStringArrary(buyerCode, ",");

		Map<String, Object> param = new HashMap<String, Object>();
		param.putAll(formData);
		param.put("buyerCodeList", buyerCodeList);

		return sqlSessionTemplate.selectOne("seller.mpcl.selectSellerMpClCatalogListV2Count", param);
	}
}

package com.koreab2b.mro.common.mdcm.dao;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.commons.io.FileUtils;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.util.CommonAwsS3;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmStndrdCatalogDetailPopDao")
@Transactional
public class MasterMdCmStndrdCatalogDetailPopDaoImpl implements MasterMdCmStndrdCatalogDetailPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndrdCatalogDetailPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcm.selectMasterMdCmStndrdCatalogDetailPopList", formData);
	}
	
	//저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "정상적으로 처리 수정 완료 되었습니다.";
		try {
			
			sqlSessionTemplate.update("common.mdcm.updateMasterMdCmStndrdCatalogDetailPop", formData);
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "처리하던중 오류가 발생하였습니다.\n\n담당자에게 문의 바랍니다.";
			throw new RuntimeException("처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 하세요");
		}
		
		return _rtnMsg; 
	}


	// 이미지등록
	public String addMasterMdCmStndCatalogAlterPop(FileUploadForm uploadForm, Map<String,String> pMap) {
		
		List<MultipartFile> _files = uploadForm.getFiles();
		
		String osName = System.getProperty("os.name");
		String _newDate = CommonUtil.formatDate(new Date(),0,"");
		String _newDir = "CMS_IMAGE/"+_newDate.substring(0, 4);
		String _path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
		 //DB에 저장할 상대경로
		 String _relativePath = "ITEM_IMAGE/"+_newDir;
		
		 String docNo = pMap.get("st_cms_catlg_id");

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

				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = CommonUtil.makeUniqueFileName(docNo);
				
				File _destFile = new File(_path + "/" + UniqFileName+ "r"+_exc);		
				logger.debug("_path :  "+_path);
				if ("".equals(_fileName)) {
					logger.debug("_fileName null ");
				} else {
					try {
						//파일이 존재하면 삭제함.
						if (_destFile.exists()){
							_destFile.delete();
						}
						//MultipartFile multi = CommonUtil.makeThumbnail(_multipartFile, 500, 500); //리사이징 기능 S3로 인해 주석 처리 2023.01.27 현명환
						//리사이징 재적용 2026-08-25 홍준우 : 비율유지 축소 + 흰 여백 500x500 (resize.exe 와 동일 동작)
						MultipartFile multi = _multipartFile;
						if ("Y".equals(pMap.get("st_img_resize_yn"))) { // 표준DB(상품정보 상세 팝업 내 파라미터)
							multi = CommonUtil.makeLetterboxImage(_multipartFile, 500, 500);
						}
						CommonAwsS3.upload(multi, _path+ "/" , UniqFileName+_exc);
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
				try{
					pMap.put("st_imgfile_dir", _relativePath);
					pMap.put("st_imgfile_name", UniqFileName+_exc);
					sqlSessionTemplate.update("common.mdcm.updateCmscatlgImage",pMap);
				}catch(Exception e){
					logger.error("ERROR : ", e);
					docNo ="ERROR";
				}

			}//end of for
		}
		
		return docNo;
	};
	

	// 이미지 상세등록
	public String addMasterMdCmStndCatalogAlterDetailPop(FileUploadForm uploadForm, Map<String,String> pMap) {
		
		List<MultipartFile> _files = uploadForm.getFiles2();
		
		String osName = System.getProperty("os.name");
//		String _newDir = CommonUtil.formatDate(new Date(),0,"");
		String _newDir = "CMS_IMAGE_DESC";
		String _path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
		 //DB에 저장할 상대경로
		 String _relativePath = "ITEM_IMAGE/"+_newDir;
		
		 String docNo = pMap.get("st_cms_catlg_id")+"_DESC";

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

				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = CommonUtil.makeUniqueFileName(docNo);
				
				File _destFile = new File(_path + "/" + UniqFileName+_exc);		
				logger.debug("_path : "+_path);
				if ("".equals(_fileName)) {
					logger.debug("_fileName null ");
				} else {
					try {
						//파일이 존재하면 삭제함.
						if (_destFile.exists()){
							_destFile.delete();
						}
						CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc);
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
				
				pMap.put("st_imgfile_dir", _relativePath);
				pMap.put("st_imgfile_name", UniqFileName+_exc);
				sqlSessionTemplate.update("common.mdcm.updateCmscatlgDetailImage",pMap);
			}//end of for
		}
		
		return docNo;
	};
}

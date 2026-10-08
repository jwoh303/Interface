package com.koreab2b.mro.common.mdct.dao;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.util.CommonAwsS3;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCtBuyerProfilePopDao")
@Transactional
public class MasterMdCtBuyerProfilePopDaoImpl implements MasterMdCtBuyerProfilePopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtBuyerProfilePopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 팝업 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerProfilePopList", formData);
	}
	
	// 팝업 매핑 조회
	public List<Map<String,String>> selectMappingList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerProfileMappingList", param);
	}
	
	// 팝업 방문일지 조회
	public List<Map<String,String>> selectCardList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtBuyerProfileCardList", param);
	}
	
	// 팝업 등록
	public String regSelectedData(Map<String,String> formData) {
		
		String org_code = "";
		String _rtnMsg = "";
		
		try {
			org_code = sqlSessionTemplate.selectOne("master.mdct.getMasterMdCtBuyerProfileOrgCode", formData);
			formData.put("ORG_CODE", org_code);
			
			sqlSessionTemplate.update("master.mdct.insertMasterMdCtBuyerProfilePop", formData);

			_rtnMsg = "OK";
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "ERR";
			throw new RuntimeException("등록에 실패하였습니다.");
		}
		
		return _rtnMsg; 
	}
	
	// 팝업 + 매핑 등록
	@SuppressWarnings("unchecked")
	public String regAllSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String org_code = "";
		_rtnMsg = "등록 완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(i==0) {
					org_code = sqlSessionTemplate.selectOne("master.mdct.getMasterMdCtBuyerProfileOrgCode", formData);
					formData.put("ORG_CODE", org_code);
					
					sqlSessionTemplate.update("master.mdct.insertMasterMdCtBuyerProfilePop", formData);
					sqlSessionTemplate.update("master.mdct.clearMasterMdCtBuyerProfileMapping", formData);
				}
				sqlSessionTemplate.update("master.mdct.insertMasterMdCtBuyerProfileMapping", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("등록에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 영업Map 이미지등록
	public String addSalesImagePop(FileUploadForm uploadForm, Map<String,String> pMap) {

		List<MultipartFile> _files = uploadForm.getFiles1();
		
		String osName = System.getProperty("os.name");
		String _newDir = CommonUtil.formatDate(new Date(),0,"");
		String _path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath + "/" +_newDir :  CommonUtil.realImgUploadProfilePath + "/" +_newDir;
		String _newFile = CommonUtil.formatDate(new Date(),3,"");
		_newFile = _newFile.replaceAll(":", "");
		_newFile = _newFile.replaceAll(" ", "");
		
		//DB에 저장할 상대경로
		String _relativePath = "BUYER_PROFILE/"+_newDir;
		
		String docNo = _newFile;

		File f = new File(_path); 
		
		if(!f.isDirectory()) {
			f.mkdirs();
			logger.debug("폴더생성 {} " ,f);
		}else{
			logger.debug("폴더이미존재 {} " ,f);
		}
		 
		logger.debug("_files.size()  {} " ,_files.size());
		if (null != _files && _files.size() > 0) {
			for (MultipartFile _multipartFile : _files) {
				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = docNo;
				
				File _destFile = new File(_path + "/" + UniqFileName+ "r"+_exc);		
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
						e.printStackTrace();
					}
				}
				
				/*
				 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
				 * 예제임니다...추후 사용하세요.
				 * CommonUtil.makeThumbnail
				 */
				
				pMap.put("st_imgfile_dir", _relativePath);
				pMap.put("st_imgfile_name", UniqFileName+_exc);
				
				docNo = _relativePath + "/" + UniqFileName+_exc;
			}//end of for
		}
		
		return docNo;
	};
	
	// 조직도 이미지등록
	public String addOrgImagePop(FileUploadForm uploadForm, Map<String,String> pMap) {

		List<MultipartFile> _files = uploadForm.getFiles2();
		
		String osName = System.getProperty("os.name");
		String _newDir = CommonUtil.formatDate(new Date(),0,"");
		String _path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath + "/" +_newDir :  CommonUtil.realImgUploadProfilePath + "/" +_newDir;
		String _newFile = CommonUtil.formatDate(new Date(),3,"");
		_newFile = _newFile.replaceAll(":", "");
		_newFile = _newFile.replaceAll(" ", "");
		
		//DB에 저장할 상대경로
		String _relativePath = "BUYER_PROFILE/"+_newDir;
		
		String docNo = _newFile;

		File f = new File(_path); 
		
		if(!f.isDirectory()) {
			f.mkdirs();
			logger.debug("폴더생성 {} " ,f);
		}else{
			logger.debug("폴더이미존재 {} " ,f);
		}
		 
		logger.debug("_files.size()  {} " ,_files.size());
		if (null != _files && _files.size() > 0) {
			for (MultipartFile _multipartFile : _files) {
				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = docNo;
				
				File _destFile = new File(_path + "/" + UniqFileName+ "r"+_exc);		
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
						e.printStackTrace();
					}
				}
				
				/*
				 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
				 * 예제임니다...추후 사용하세요.
				 * CommonUtil.makeThumbnail
				 */
				
				pMap.put("st_imgfile_dir", _relativePath);
				pMap.put("st_imgfile_name", UniqFileName+_exc);
				
				docNo = _relativePath + "/" + UniqFileName+_exc;
			}//end of for
		}
		
		return docNo;
	};
	
	// 시스템프로세스 이미지등록
	public String addSysImagePop(FileUploadForm uploadForm, Map<String,String> pMap) {

		List<MultipartFile> _files = uploadForm.getFiles3();
		
		String osName = System.getProperty("os.name");
		String _newDir = CommonUtil.formatDate(new Date(),0,"");
		String _path = (osName.indexOf("Win") > -1)?CommonUtil.localUploadPath + "/" +_newDir :  CommonUtil.realImgUploadProfilePath + "/" +_newDir;
		String _newFile = CommonUtil.formatDate(new Date(),3,"");
		_newFile = _newFile.replaceAll(":", "");
		_newFile = _newFile.replaceAll(" ", "");
		
		//DB에 저장할 상대경로
		String _relativePath = "BUYER_PROFILE/"+_newDir;
		
		String docNo = _newFile;

		File f = new File(_path); 
		
		if(!f.isDirectory()) {
			f.mkdirs();
			logger.debug("폴더생성 {} " ,f);
		}else{
			logger.debug("폴더이미존재 {} " ,f);
		}
		 
		logger.debug("_files.size()  {} " ,_files.size());
		if (null != _files && _files.size() > 0) {
			for (MultipartFile _multipartFile : _files) {
				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = docNo;
				
				File _destFile = new File(_path + "/" + UniqFileName+ "r"+_exc);		
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
						e.printStackTrace();
					}
				}
				
				/*
				 * 기존 이미지를 가로,세로길이에 맞게 변경한다.
				 * 예제임니다...추후 사용하세요.
				 * CommonUtil.makeThumbnail
				 */
				
				pMap.put("st_imgfile_dir", _relativePath);
				pMap.put("st_imgfile_name", UniqFileName+_exc);
				
				docNo = _relativePath + "/" + UniqFileName+_exc;
			}//end of for
		}
		
		return docNo;
	};
	
	// 팝업 저장
	public String saveSelectedData(Map<String,String> formData) {
		
		String _rtnMsg = "";
		
		try {
			sqlSessionTemplate.update("master.mdct.saveMasterMdCtBuyerProfilePop", formData);

			_rtnMsg = "OK";
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "ERR";
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		
		return _rtnMsg; 
	}
	
	// 팝업 + 매핑 저장
	@SuppressWarnings("unchecked")
	public String saveAllSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String org_code = "";
		_rtnMsg = "저장 완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(i==0) {
					org_code = formData.get("st_org_code");
					formData.put("ORG_CODE", org_code);
					sqlSessionTemplate.update("master.mdct.saveMasterMdCtBuyerProfilePop", formData);
					sqlSessionTemplate.update("master.mdct.clearMasterMdCtBuyerProfileMapping", formData);
				}
				sqlSessionTemplate.update("master.mdct.insertMasterMdCtBuyerProfileMapping", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("고객사 매핑 저장에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 팝업 매핑 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String delMappingData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "고객사 매핑 삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdct.deleteMasterMdCtBuyerProfileMapping", formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
	}
	
	// 팝업 재계약 등록
	public String regReContractData(Map<String,String> formData) {
		
		String _rtnMsg = "";
		
		try {
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtBuyerProfileReContract", formData);
			sqlSessionTemplate.update("master.mdct.insertMasterMdCtBuyerReContract", formData);

			_rtnMsg = "OK";
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "ERR";
			throw new RuntimeException("재계약 등록에 실패 했습니다.");
		}
		
		return _rtnMsg; 
	}
}

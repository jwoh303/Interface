package com.koreab2b.mro.common.mprq.dao;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
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

@Repository("masterMpRqDbStndrdProgressPopDao")
@Transactional
public class MasterMpRqDbStndrdProgressPopDaoImpl implements MasterMpRqDbStndrdProgressPopDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDbStndrdProgressPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqDbStndrdProgressPopList", formData);
	}
	
	// 이미지등록
	public String addDbStndrdPop(FileUploadForm uploadForm, Map<String,String> pMap) {
		
		List<MultipartFile> _files = uploadForm.getFiles();
		
		String osName = System.getProperty("os.name");
		
		String _newDir = CommonUtil.formatDate(new Date(),0,"");
		String _path = CommonUtil.realImgUploadRegisterPath+"/" +_newDir;
		String _relativePath = "ITEM_IMAGE/"+_newDir;
		String docNo = pMap.get("USER_ID") + "_" + String.valueOf(System.currentTimeMillis());
		
		
		File f = new File(_path); 
		if(!f.isDirectory()) {
            f.mkdirs();
            LOGGER.debug("폴더생성 {} " ,f);
        }else{
        	 LOGGER.debug("폴더이미존재 {} " ,f);
        }

		if (null != _files && _files.size() > 0) {
			for (MultipartFile _multipartFile : _files) {

				String _fileName = _multipartFile.getOriginalFilename();
				String _exc = "." + _fileName.substring(_fileName.lastIndexOf(".")+1, _fileName.length());
				if(_fileName.isEmpty()) continue;
				
				String UniqFileName = docNo;
				
				File _destFile = new File(f + "/" + UniqFileName+_exc);		
				LOGGER.debug("_path : "+_path);
				if ("".equals(_fileName)) {
					LOGGER.debug("_fileName null ");
				} else {
					try {
						//MultipartFile multi = CommonUtil.makeThumbnail(_multipartFile, 500, 500); //리사이징 기능 S3로 인해 주석 처리 2023.01.27 현명환
						CommonAwsS3.upload(_multipartFile, _path+ "/" , UniqFileName+_exc);//multi -> _multipartFile  2023.01.27 현명환
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
//					CommonUtil.makeThumbnail(_path + "/" + UniqFileName+_exc, _path + "/resize_" + UniqFileName+_exc,50,50);
				// 카탈로그 기준으로 500으로 변경
				pMap.put("st_imgfile_dir", _relativePath);
				pMap.put("st_imgfile_name", UniqFileName+_exc);
				sqlSessionTemplate.update("common.mprq.updateKeprqdtAddImage",pMap);
				docNo =  _relativePath+"^"+docNo+_exc;
			}//end of for
		}
		
		return docNo;
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqCmsRecvDate(Map<String,String>  formData) {
		_rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("common.mprq.updateMasterMpRqCmsRecvDate", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
}

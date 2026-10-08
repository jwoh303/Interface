package com.koreab2b.mro.seller.mpcl.dao;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
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
import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpClCmsCmplReqDao")
@Transactional
public class SellerMpClCmsCmplReqDaoImpl implements SellerMpClCmsCmplReqDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpClCmsCmplReqDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpcl.selectSellerMpClCmsCmplReqList", formData);
	}
	
	/**
	 * saveSellerMpClCmsCmplReqItem 품목보완요청
	 */
	public String saveSellerMpClCmsCmplReqItem(FileUploadForm uploadForm,Map<String, String> formData) {
		
		String _st_update = formData.get("st_query2").toString();
		String _user_id = formData.get("st_user_id").toString();
		Map<String,String> _data = null;
		String _rtnMsg = "품목보완 요청되었습니다.";
		try {
			//품목보완요청
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
							//품목정비 보완요청
				        	_data = new HashMap<String,String>() ;
					        _data.put("_user_id", _user_id);
					        _data.put("BUYER", str[0]);
					        _data.put("REQ_NO", str[1]);
					        _data.put("REVISION",  str[2]);
					        _data.put("DESCRIPTION_LOC",   str[3]);
					        _data.put("SPECIFICATION", str[4]);
					        _data.put("MAKER_CODE",   str[5]);
					        _data.put("MAKER_NAME",   str[6]);
					        _data.put("ORIGIN_CODE",   str[7]);
					        _data.put("UNIT_MEASURE",   str[8]);
					        _data.put("IMGFILE_DIR",   str[9]);
					        _data.put("IMGFILE_NAME",   str[10]);
					        _data.put("STOA_REMARK",   str[11]);
					        _data.put("MSDS_YN",   str[12]);
					        _data.put("IMAGE_KEY",   str[13]);
					        _data.put("MAKER_PART_NO",   str[14]);
					        sqlSessionTemplate.update("seller.mpcl.updateSellerMpClCmsCmplReqItem", _data);
					        sqlSessionTemplate.update("seller.mpcl.updateSellerMpClCmsCmplReqHdItem", _data);
						 }				         
					 }					  
				 }				  
			 } 
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품목 보완요청에 실패하였습니다.");
		}
		return _rtnMsg;
	}

}

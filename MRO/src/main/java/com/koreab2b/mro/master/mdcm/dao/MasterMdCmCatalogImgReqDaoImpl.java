package com.koreab2b.mro.master.mdcm.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMdCmCatalogImgReqDao")
@Transactional
public class MasterMdCmCatalogImgReqDaoImpl implements MasterMdCmCatalogImgReqDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogImgReqDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList =  sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogImgList", param);
		
		return resultList;
	}
	/*승인*/
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqConfirmStndCatlg(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "승인처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String reqImg = formData.get("REQ_IMG");
				String reqImgDt = formData.get("REQ_IMG_DT");
				//이미지업데이트
				if(!reqImg.equals("/resources/images/icon_emptyimg.gif")){
					sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogImg", formData);
				}
				//이미지상세 업데이트
				if(!reqImgDt.equals("/resources/images/icon_emptyimg.gif")){
					sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogImgDec", formData);
				}
				//승인처리
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogImgInfo", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*반려*/
	@SuppressWarnings("unchecked")
	public String rejectMasterMpRqConfirmStndCatlg(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "반려처리가 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//반려처리
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogImgInfo", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
}

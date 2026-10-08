package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmCmsMapppingDao")
@Transactional
public class MasterMdCmCmsMapppingDaoImpl implements MasterMdCmCmsMapppingDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsMapppingDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsMapppingList", param);
	}

	// CMS매핑
	public String updateSelectedData(Map<String,String>  formData) {
		
		_rtnMsg = "CMS 매핑 완료되었습니다.";
		String strSite = "";
		
		try{
			strSite = formData.get("st_site").toString();
			
			//사이트에 따른 update 분기
			if("KA".equals(strSite)){
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsMapppingKA", formData);
			}else if("KM".equals(strSite)){
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsMapppingKM", formData);
			}else if("SA".equals(strSite)){
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsMapppingSA", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("CMS 매핑에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 삭제되었습니다";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmCmsMappping", formData);
				logger.error("deleteMasterMdCmCmsMappping 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}
	
	// 파일업로드
	@SuppressWarnings("unchecked")
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "File Upload 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdcm.batchMasterMdCmCmsMappping", formData);
				logger.error("batchSelectedData 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("File Upload에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}

		return _rtnMsg;		
		
	}	

}

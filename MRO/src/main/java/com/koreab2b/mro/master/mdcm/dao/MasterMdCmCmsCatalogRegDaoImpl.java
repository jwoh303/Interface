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

@Repository("masterMdCmCmsCatalogRegDao")
@Transactional
public class MasterMdCmCmsCatalogRegDaoImpl implements MasterMdCmCmsCatalogRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsCatalogRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsCatalogRegList", param);
	}

	// 생성
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "CMS 카탈로그 등록 완료되었습니다.";
		
		try{
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				//변경 내역 저장.
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsCatalogReg", formData);
				//표준카탈로그 등록
				sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmCmsCatalogReg", formData);
				//CMSCATLG_ADD 업데이트
				sqlSessionTemplate.insert("master.mdcm.updateMasterMdCmCmsCatalogRegAdd", formData);
				
				
				logger.error("updateSelectedData 실행 완료");

			}			
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("CMS 카탈로그 등록에 실패 했습니다.\n\n관리자에게 문의 하세요");
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
				
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmCmsCatalogReg", formData);
				logger.error("deleteMasterMdCmCmsCatalogReg 실행 완료");

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
				
				sqlSessionTemplate.insert("master.mdcm.batchMasterMdCmCmsCatalogReg", formData);
				logger.error("batchSelectedData 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("File Upload에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}

		return _rtnMsg;		
		
	}	

}

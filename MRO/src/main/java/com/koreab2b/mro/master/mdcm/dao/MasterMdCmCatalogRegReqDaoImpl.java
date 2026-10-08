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


@Repository("masterMdCmCatalogRegReqDao")
@Transactional
public class MasterMdCmCatalogRegReqDaoImpl implements MasterMdCmCatalogRegReqDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogRegReqDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogRegReqList", param);
	}

	// 등록 요청
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "등록 요청이 정상적으로 이루어 졌습니다.";
		
		try{
			// SELECT-INSERT
			sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmCatalogRegReq", formData);
			
			// 등록 후 삭제
			sqlSessionTemplate.update("master.mdcm.deleteBatchMasterMdCmCatalogRegAfter", formData);
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("등록에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 삭제되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmCatalogRegReq", formData);
				logger.error("deleteMasterMdCmCatalogRegReq 실행 완료");
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
	}
	
	// 신규 업로드
	@SuppressWarnings("unchecked")
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "신규 업로드 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				if(i==0) { // 처음 한번만 실행
					// delete
					sqlSessionTemplate.update("master.mdcm.deleteBatchMasterMdCmCatalogRegReq", formData);
				}
				
				//insert
				sqlSessionTemplate.insert("master.mdcm.batchMasterMdCmCatalogRegReq", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("신규 업로드에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}
		return _rtnMsg;
	}
	
	// 기등록 업로드
	@SuppressWarnings("unchecked")
	public String batchRenewSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "기등록 업로드 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				if(i==0) { // 처음 한번만 실행
					// delete
					sqlSessionTemplate.update("master.mdcm.deleteBatchMasterMdCmCatalogRegReNew", formData);
				}
				
				//insert
				sqlSessionTemplate.insert("master.mdcm.batchMasterMdCmCatalogRegReNew", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("기등록 업로드에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}
		return _rtnMsg;
	}
}

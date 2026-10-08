package com.koreab2b.mro.master.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpDsOrderManageDao")
@Transactional
public class MasterMpDsOrderManageDaoImpl implements MasterMpDsOrderManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsOrderManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	private String _errorMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpds.selectMasterMpDsOrderManageList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "수량 변경 완료.";
		_errorMsg = "수량변경에 실패하였습니다.";
		int result = 1;
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(formData.get("STATUS").equals("PR")) {
					result = sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect_IV_DS", formData);
					if(result !=1) {
						_errorMsg = "IV"+_errorMsg;
					}
					result = sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect_PO_PR", formData);
					if(result !=1) {
						_errorMsg = "PO"+_errorMsg;
					}

				}else if(formData.get("STATUS").equals("PO")) {
					result = sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect_IV_DS_PO", formData);
					if(result !=1) {
						_errorMsg = "IV"+_errorMsg;
					}
					result = sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect_PO_PR_PO", formData);
					if(result !=1) {
						_errorMsg = "PO"+_errorMsg;
					}

				}else if(formData.get("STATUS").equals("DS")) {
					result = sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect_IV_DS_PO", formData);
					if(result !=1) {
						_errorMsg = "IV"+_errorMsg;
					}
					result = sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect_PO_PR_PO_DO", formData);
					if(result !=1) {
						_errorMsg = "PO"+_errorMsg;
					}

				}
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_errorMsg);
		}
		return _rtnMsg;
	}
	
	
	// 맵핑
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String mappingSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "맵핑 완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mpds.mappingMasterMpDsOrderManage", formData);
				logger.error("mappingMasterMpDsOrderManage 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("맵핑에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}

package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterCmClClosingTotalDao")
@Transactional
public class MasterCmClClosingTotalDaoImpl implements MasterCmClClosingTotalDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClClosingTotalDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClClosingTotalList", param);
	}

	// 저장
	public String updateSelectedData(Map<String,String>  formData) {
		
		_rtnMsg = "OK";
		
		try {
			// 수불조정 merge
			sqlSessionTemplate.update("master.cmcl.insertMasterCmClClosingTotal", formData);
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 저장 실패 ]\n\n담당자에게 연락 바랍니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
//	@SuppressWarnings("unchecked")
//	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
//	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		
//		_rtnMsg = "삭제완료";
//		
//		try{
//			for(int i=0; i < gridData.size(); i++){
//				formData.putAll((Map<String, String>)gridData.get(i));		
//				
//				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClClosingTotal", formData);
//				logger.error("deleteMasterCmClClosingTotal 실행 완료");
//
//			}
//		}catch(Exception e){
//			logger.error("SQL ERROR : ", e);
//			throw new RuntimeException("견적 요청에 실패하였습니다.");
//		}
//
//		return _rtnMsg;		
//	}	

}

package com.koreab2b.mro.master.wmgi.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmGiReleaseDirectionsTranDao")
@Transactional
public class MasterWmGiReleaseDirectionsTranDaoImpl implements MasterWmGiReleaseDirectionsTranDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiReleaseDirectionsTranDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmgi.selectMasterWmGiReleaseDirectionsTranList", param);
	}
	// 리스트 조회
	public List<Map<String,String>> selectBpList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmgi.selectMasterWmGiBpReleaseDirectionsTranList", param);
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.wmgi.insertMasterWmGiReleaseDirectionsTran", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.wmgi.deleteMasterWmGiReleaseDirectionsTran", formData);
				logger.error("deleteMasterWmGiReleaseDirectionsTran 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

	//엑셀 리스트 조회
	public List<Map<String,String>> selecExceltList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmgi.selectMasterBuyerReleaseList", param);
	}
	
	// 일양, 한진택배 여부 조회
	public String getDeliCompany(Map<String, String> param) {		
		_rtnMsg = "N"; // 일양, 한진 아닐때
		_rtnMsg = sqlSessionTemplate.selectOne("master.wmgi.selectMasterWmGiReleaseDirectionsTranDeliCompany", param);
		return _rtnMsg;
	}
}

package com.koreab2b.mro.master.mpif.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@SuppressWarnings("unchecked")
@Repository("masterMpIfCowayDoctorDao")
@Transactional
public class MasterMpIfCowayDoctorDaoImpl implements MasterMpIfCowayDoctorDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfCowayDoctorDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, String>> selectCowayDoctorAsList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfCowayDoctorAsList", pMap);
	}

	@Override
	public String deleteMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		String rtnMsg	= "삭제되었습니다.";
		int rtnCnt	= 0;
		
		try {
			for( int i = 0 ; i < pGridData.size() ; i++) {
				
				HashMap<String, String> tMap	= (HashMap<String, String>) pGridData.get(i);
				
				rtnCnt = sqlSessionTemplate.update("master.mpif.deleteMasterMpIfCowayDoctorAsList", tMap);
				
				if (rtnCnt == 0)
					throw new Exception("삭제중 오류가 발생했습니다.");
			}
			
			rtnMsg	= "삭제되었습니다.";
			
		} catch (Exception e) {
			rtnMsg	= e.getMessage();
		}
		
		return rtnMsg;
	}

	@Override
	public String insertMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		String rtnMsg	= "저장되었습니다.";
		int rtnCnt	= 0;
		
		try {
			for( int i = 0 ; i < pGridData.size() ; i++) {
				
				HashMap<String, String> tMap	= (HashMap<String, String>) pGridData.get(i);
				
				rtnCnt = sqlSessionTemplate.update("master.mpif.insertMasterMpIfCowayDoctorAsList", tMap);
				
				if(rtnCnt == 0)
					throw new Exception("저장중 오류가 발생했습니다.");
			}
			
			rtnMsg	= "저장되었습니다.";
			
		} catch (Exception e) {
			rtnMsg	= e.getMessage();
		}
		
		return rtnMsg;
	}

	@Override
	public String sendMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		String rtnMsg	= "등록되었습니다.";
		int rtnCnt	= 0;
		
		try {
			for( int i = 0 ; i < pGridData.size() ; i++) {
				
				HashMap<String, String> tMap	= (HashMap<String, String>) pGridData.get(i);
				
				rtnCnt = sqlSessionTemplate.update("master.mpif.sendMasterMpIfCowayDoctorAsList", tMap);
				
				if (rtnCnt == 0)
					throw new Exception("변경중 오류가 발생했습니다.");
			}
			
			rtnMsg	= "등록되었습니다.";
			
		} catch (Exception e) {
			rtnMsg	= e.getMessage();
		}
		
		return rtnMsg;
	}

	@Override
	public String saveMasterMpIfCowayDoctorAsList(List<Object> pGridData) {
		String rtnMsg	= "저장되었습니다.";
		int rtnCnt	= 0;
		
		try {
			for( int i = 0 ; i < pGridData.size() ; i++) {
				
				HashMap<String, String> tMap	= (HashMap<String, String>) pGridData.get(i);
				
				rtnCnt = sqlSessionTemplate.update("master.mpif.saveMasterMpIfCowayDoctorAsList", tMap);
				
				if (rtnCnt == 0)
					throw new Exception("변경중 오류가 발생했습니다.");
			}
			
			rtnMsg	= "저장되었습니다.";
			
		} catch (Exception e) {
			rtnMsg	= e.getMessage();
		}
		
		return rtnMsg;
	}
	
	
}

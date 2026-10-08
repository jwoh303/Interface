package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCmCatalogByitDao")
@Transactional
public class MasterMdCmCatalogByitDaoImpl implements MasterMdCmCatalogByitDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmCatalogByitPopList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	// 견적카탈로그 품목코드 매핑하기
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public int saveMasterItemNoMapping(Map<String, String> formData, List<Object> gridData) {
		try{
			for (int i = 0; i < gridData.size(); i++) {
					formData.putAll((Map<String, String>) gridData.get(i));
					sqlSessionTemplate.insert("master.mdcm.saveMasterItemNoMapping", formData);
			}	
		}catch(Exception e){
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		
		return 0;
	}
}

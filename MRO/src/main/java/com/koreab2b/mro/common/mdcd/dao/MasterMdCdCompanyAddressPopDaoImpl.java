package com.koreab2b.mro.common.mdcd.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCdCompanyAddressPopDao")
@Transactional
public class MasterMdCdCompanyAddressPopDaoImpl implements MasterMdCdCompanyAddressPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdCompanyAddressPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcd.selectMasterMdCdCompanyAddressPopList", formData);
	}

	// 삭제
	@SuppressWarnings("unchecked")
	public Map<String,String> deleteData(Map<String, String> formData) {
		
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		try {
			String check_cnt = formData.get("check_cnt");
			String[] code1 = formData.get("code1").split(",");
			for(int i=0; i < Integer.valueOf(check_cnt); i++){			
				formData.put("code1",code1[i]);
				sqlSessionTemplate.update("common.mdcd.deleteMasterMdCdCompanyAddressPop", formData);
			}	
		}catch(Exception e){
			_rtnMsg = "삭제에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		_rtnMsg = "삭제하였습니다.";
		_pReturnMap.put("MSG", _rtnMsg);	
		
		return _pReturnMap;
	}

	// 저장
	public Map<String,String> saveData(Map<String, String> formData) {
		
		
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		try {
			String cnt = formData.get("address_cnt");
			String[] code1 = formData.get("code1").split(",");
			String[] text1 = formData.get("text1").split("@@,");
			
			for(int i=0; i < Integer.valueOf(cnt); i++){			
				formData.put("code1",code1[i]);
				formData.put("text1",text1[i]);
				sqlSessionTemplate.update("common.mdcd.saveMasterMdCdCompanyAddressPop", formData);
			}	
		}catch(Exception e){
			_rtnMsg = "저장에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		_rtnMsg = "저장하였습니다.";
		_pReturnMap.put("MSG", _rtnMsg);	
		
		return _pReturnMap;
	}

	// 추가
	public Map<String,String> addData(Map<String, String> formData) {
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		try {	
			
				String nextCodeVal = sqlSessionTemplate.selectOne("common.mdcd.selectMasterMdCdCompanyAddressNextcodeVal", formData);
				formData.put("nextCodeVal", nextCodeVal);
				sqlSessionTemplate.insert("common.mdcd.addMasterMdCdCompanyAddressPop", formData);
				
		}catch(Exception e){
			_rtnMsg = "소재지 추가에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		_rtnMsg = "추가하였습니다.";
		_pReturnMap.put("MSG", _rtnMsg);	
		
		return _pReturnMap;
	}
	
	
}

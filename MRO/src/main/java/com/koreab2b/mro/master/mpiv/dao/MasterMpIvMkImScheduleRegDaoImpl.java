package com.koreab2b.mro.master.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIvMkImScheduleRegDao")
@Transactional
public class MasterMpIvMkImScheduleRegDaoImpl implements MasterMpIvMkImScheduleRegDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectList(Map<String, Object> pMap) {
		List<String> list = CommonUtil.getStringArrary((String) pMap.get("st_buyer_code"), "@");
		pMap.put("st_buyer_code", list);
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpiv.selectMasterMpIvMkImScheduleRegList", pMap, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
//		return sqlSessionTemplate.selectList("master.mpiv.selectMasterMpIvMkImScheduleRegList", pMap);
	}

	@Override
	public List<Map<String, String>> selectPopupList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("master.mpiv.selectMasterMpIvMkImScheduleRegDetailPop", pMap);
	}

	@Override
	public int saveMkImScheduleReg(List<Map<String, String>> list) {
		int cnt = 0;
		for (Map<String, String> map : list) {
			cnt += sqlSessionTemplate.update("master.mpiv.saveMkImScheduleReg", map);
		}
		return cnt;
	}

	@Override
	public int saveMkImScheduleUpdate(Map<String, String> formData) {
		return sqlSessionTemplate.update("master.mpiv.saveMkImScheduleReg", formData);
	}

}

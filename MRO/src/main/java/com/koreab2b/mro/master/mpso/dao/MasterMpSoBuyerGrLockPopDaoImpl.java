package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoBuyerGrLockPopDao")
@Transactional
public class MasterMpSoBuyerGrLockPopDaoImpl implements MasterMpSoBuyerGrLockPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoBuyerGrLockPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		//고객사
		List<String> st_buyer_codeList = CommonUtil.getStringArrary((String) formData.get("st_buyer_code"), "@");
		
		List<String> st_p_close_month = CommonUtil.getStringArrary((String) formData.get("st_p_close_month"), "@");
		
		formData.put("st_p_close_month", st_p_close_month);
		formData.put("st_buyer_codeList", st_buyer_codeList);
		
		//LOGGER.debug("selectMasterMpSoBuyerGrLockPopList 요청 파라미터 : formData === {}", formData);
		
		ResultRowHandler _resultHander = new ResultRowHandler(); 
		sqlSessionTemplate.select("master.mpso.selectMasterMpSoBuyerGrLockPopList", formData, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	
	// 입고잠금
	public String updateGrLock(Map<String, String> formData) {
		String _rtnMsg = "";

		try {
			//LOGGER.debug("updateGrLock 요청 파라미터 : formData === {}", formData);
			String st_buyer_code = formData.get("st_buyer_code");
			String st_buyer_array[] = st_buyer_code.split("\\@");
			
			//LOGGER.debug("updateGrLock 요청 파라미터 : st_buyer_array legnth=== {}", st_buyer_array.length);
			
			for(int i=0; i<st_buyer_array.length; i++) {
				//LOGGER.debug("updateGrLock 요청 파라미터 : st_buyer_code=== {}", st_buyer_array[i]);	
				formData.put("st_buyer_single", st_buyer_array[i]);
				
				// 고객사 정합성 체크(회원사구분, 승인, 그룹코드 등)
				String buyer_check = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerGrLockCheck", formData);
				
				if (Integer.parseInt(buyer_check) > 0) { // 고객사코드 정확할 때
					String grLockCnt = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerGrLockCnt", formData);
					
					if (Integer.parseInt(grLockCnt) > 0) {
						sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerGrLock", formData);
					} else {
						sqlSessionTemplate.insert("master.mpso.insertMasterMpSoBuyerGrLock", formData);
					}
				}else {
					// SKIP
				}
			}
		}catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			_rtnMsg = "입고 잠금/해제에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
}
package com.koreab2b.mro.common.mpif.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpIfDivsnPopDao")
@Transactional
public class MasterMpIfDivsnPopDaoImpl implements MasterMpIfDivsnPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpif.selectMasterMpIfDivsnPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectDivsnList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpif.selectMasterMpIfDivsnPop", formData);
	}
	
	// 저장
		@SuppressWarnings("unchecked")
		public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
			String _rtnMsg = "저장이 정상적으로 이루어 졌습니다.";
			
			try {
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					String agentCnt = sqlSessionTemplate.selectOne("common.mpif.getMasterMpIfDivsnPopAgentCheck", formData);

					if (Integer.parseInt(agentCnt) > 0 ) {
						sqlSessionTemplate.update("common.mpif.updateMasterMpIfDivsnPopList", formData);
					} else {
						sqlSessionTemplate.insert("common.mpif.insertMasterMpIfDivsnPopList", formData);
					}
				}
			} catch (Exception e) {
				_rtnMsg = "저장이 실패하였습니다.\n\n관리자에게 문의 하시기 바랍니다.";
				throw new RuntimeException("저장이 실패하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
			}
			
			return _rtnMsg;
		}
		
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제가 정상적으로 이루어 졌습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.delete("common.mpif.deleteMasterMpIfDivsnPopList", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "삭제 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			throw new RuntimeException("삭제 실패 하였습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
}

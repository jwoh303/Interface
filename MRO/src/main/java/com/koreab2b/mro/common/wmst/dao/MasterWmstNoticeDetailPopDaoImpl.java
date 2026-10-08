package com.koreab2b.mro.common.wmst.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmstNoticeDetailPopDao")
@Transactional
public class MasterWmstNoticeDetailPopDaoImpl implements MasterWmstNoticeDetailPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 상세
	public Map<String,String> selectDetail(Map<String,String> formData) {
		
		Map<String,String> pMap = new HashMap<String, String>();
		pMap.put("BTYPE", "WM");
		pMap.put("BID", formData.get("st_bid"));
		
		// 카운트 증가
		//sqlSessionTemplate.update("board.updateBoardLCount",pMap);

		// 상세 정보 조회 
		return sqlSessionTemplate.selectOne("common.wmst.selectMasterWmstNoticeDetailPop", formData);
	}
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		String _userCheck = "";
		try {
			if (!"".equals(formData.get("st_bid"))) {
				_userCheck = sqlSessionTemplate.selectOne("common.wmst.getMasterWmstNoticeDetailPopRegUserCheck", formData);
				
				if (Integer.parseInt(_userCheck) > 0) {
					sqlSessionTemplate.delete("common.wmst.deleteMasterWmstNoticeDetailPop", formData);
				} else {
					_rtnMsg = "NO";
				}
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			throw new RuntimeException("공지사항 삭제에 실패 하였습니다.\\n다시 확인하여 주십시요!");
		}
		
		return _rtnMsg;
	}

}

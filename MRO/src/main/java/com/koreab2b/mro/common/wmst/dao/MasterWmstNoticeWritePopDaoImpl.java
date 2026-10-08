package com.koreab2b.mro.common.wmst.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmstNoticeWritePopDao")
@Transactional
public class MasterWmstNoticeWritePopDaoImpl implements MasterWmstNoticeWritePopDao {

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
		return sqlSessionTemplate.selectOne("common.wmst.selectMasterWmstNoticeWritePop", formData);
	}
	
	// 물류센터코드
	public Map<String,String> selectWarehouseCode(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.wmst.getMasterWmstNoticeWritePopWarehouseCode", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		String _bid = "";
		Integer _vid = 0;
		
		formData.put("st_btype", "WM");

		try {
			if (!"".equals(formData.get("st_bid"))) {
				sqlSessionTemplate.update("common.wmst.updateMasterWmstNoticeWritePop", formData);
			}  else {
				_bid = sqlSessionTemplate.selectOne("common.wmst.getMasterWmstNoticeWritePopBid", formData);
				_vid = Integer.parseInt(_bid) * 10;
				
				formData.put("st_bid", _bid);
				formData.put("st_vid", String.valueOf(_vid));
				
				sqlSessionTemplate.insert("common.wmst.insertMasterWmstNoticeWritePop", formData);
			}	
		} catch(Exception e) {
			_rtnMsg = "ERR";
			throw new RuntimeException("공지사항 저장에 실패 하였습니다.\\n다시 확인하여 주십시요!");
		}
		
		return _rtnMsg;
	}

}

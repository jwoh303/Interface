package com.koreab2b.mro.master.wmgi.dao;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmGiOrderDeletePopDao")
@Transactional
public class MasterWmGiOrderDeletePopDaoImpl implements MasterWmGiOrderDeletePopDao {
	private String _rtnMsg = "";
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmgi.selectMasterWmGiOrderDeletePopList", param);
	}

	// 리스트 조회
	public List<Map<String,String>> selectListPop(Map<String, String> pMap) {
	
		return sqlSessionTemplate.selectList("master.wmgi.selectMasterWmGiOrderDeletePopSelect", pMap);
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "OK";
		int res_cnt = 0;
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));

				// STEP1
				sqlSessionTemplate.update("master.wmgi.insertMasterWmGiOrderDeletePop1", formData);

				res_cnt = sqlSessionTemplate.update("master.wmgi.insertMasterWmGiOrderDeletePop6", formData);
				if(res_cnt == 0){
					_rtnMsg = "센터삭제 에러(UPDATE ICOMIVDT) ";
					throw new RuntimeException("센터삭제 에러(UPDATE ICOMIVDT) ");
				}
				
				if("1".equals(formData.get("PROCESS_TYPE"))&&"출고".equals(formData.get("STATUS_TEXT"))){ //재고 출고
				
					sqlSessionTemplate.update("master.wmgi.insertMasterWmGiOrderDeletePop2", formData);
					
				}else if("1".equals(formData.get("PROCESS_TYPE"))&&"배송확정".equals(formData.get("STATUS_TEXT"))){ //재고 배송확정
					
					sqlSessionTemplate.update("master.wmgi.insertMasterWmGiOrderDeletePop3", formData);
					
				}else if("3".equals(formData.get("PROCESS_TYPE"))&&"출고".equals(formData.get("STATUS_TEXT"))){  // VMI 출고
					
					sqlSessionTemplate.update("master.wmgi.insertMasterWmGiOrderDeletePop4", formData);
					
				}else if("3".equals(formData.get("PROCESS_TYPE"))&&"배송확정".equals(formData.get("STATUS_TEXT"))){  // VMI 배송확정
					
					res_cnt = sqlSessionTemplate.update("master.wmgi.insertMasterWmGiOrderDeletePop5", formData);
				}
				if(res_cnt != 1) {
					_rtnMsg = "센터삭제 에러(UPDATE WMSSTCK) ";
					throw new RuntimeException("센터삭제 에러(UPDATE WMSSTCK) ");
				}
			}
			
		} catch (Exception e){
			_rtnMsg = "NO";
			throw new RuntimeException("센터삭제 에러");
		}
		return _rtnMsg;
	}
	
}

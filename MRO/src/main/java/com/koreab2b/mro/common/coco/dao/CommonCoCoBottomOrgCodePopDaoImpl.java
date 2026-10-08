package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoBottomOrgCodePopDao")
public class CommonCoCoBottomOrgCodePopDaoImpl implements CommonCoCoBottomOrgCodePopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<Map<String,String>> getCommonCoCoBottomOrgCodePop(Map<String,String> pMap) {
		String _flag = null;
//		String _aboveFlag = null;
		List<Map<String,String>> resultList = null;
		if (!pMap.get("st_gubun").equals("N")){
			
//			_aboveFlag = sqlSessionTemplate.selectOne("common.coco.selectAboveFlag", pMap);
//			if (_aboveFlag.equals("0")){ // 
//				resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodePop_self", pMap);
//			} else { // ABOVE
			_flag = sqlSessionTemplate.selectOne("common.coco.selectRqdtFlag", pMap);
			if (_flag.equals("0")){ // 신규
				resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodePop", pMap);
				if (resultList.size() == 1){
					resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodePop_self", pMap);
				}
			} else { // 기등록
				resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodePop_self", pMap);
			}
//			}
			
		} else {
			resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodePop", pMap);
			
			if(resultList.size() == 1){
				resultList = sqlSessionTemplate.selectList("common.coco.selectCommonCoCoBottomOrgCodePop_self", pMap);
			}
		}
		return resultList;
	}
}

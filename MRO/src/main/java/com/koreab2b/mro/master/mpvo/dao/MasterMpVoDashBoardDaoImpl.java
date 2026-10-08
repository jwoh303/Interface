package com.koreab2b.mro.master.mpvo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

@Repository("masterMpVoDashBoardDao")
@Transactional
public class MasterMpVoDashBoardDaoImpl implements MasterMpVoDashBoardDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpvo.selectMasterMpVoDashBoardList", param);
	}
	
	// 리스트 조회
	public String getCountBuyerOwn(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mpvo.selectCountBuyerOwn", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getDashBoardList1(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpvo.getDashBoardList1", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getDashBoardList2(Map<String,Object> param) {
		
		String st_from_date = CommonUtil.nvl((String) param.get("st_from_date"),"");
		String st_to_date = DateTimeUtil.getFormatString("yyyyMMdd");
		
		if("".equals(st_from_date)){
	    	try {
	    		st_from_date    = DateTimeUtil.addDays(st_to_date, -14);
			} catch (Exception e) {
				e.printStackTrace();
			}	
	    }
		
		param.put("st_from_date", st_from_date);
		param.put("st_to_date", st_to_date);
		
		return sqlSessionTemplate.selectList("master.mpvo.getDashBoardList2", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getDashBoardList3(Map<String,Object> param) {
		
		String st_from_date = CommonUtil.nvl((String) param.get("st_from_date"),"");
		String st_to_date = DateTimeUtil.getFormatString("yyyyMMdd");
		
		if("".equals(st_from_date)){
	    	try {
	    		st_from_date    = DateTimeUtil.addDays(st_to_date, -14);
			} catch (Exception e) {
				e.printStackTrace();
			}	
	    }
		
		param.put("st_from_date", st_from_date);
		param.put("st_to_date", st_to_date);
		
		return sqlSessionTemplate.selectList("master.mpvo.getDashBoardList3", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getDashBoardList4(Map<String,Object> param) {
		
		String st_from_date = CommonUtil.nvl((String) param.get("st_from_date"),"");
		String st_to_date = DateTimeUtil.getFormatString("yyyyMMdd");
		
		if("".equals(st_from_date)){
	    	try {
	    		st_from_date    = DateTimeUtil.addDays(st_to_date, -14);
			} catch (Exception e) {
				e.printStackTrace();
			}	
	    }
		
		param.put("st_from_date", st_from_date);
		param.put("st_to_date", st_to_date);
		
		return sqlSessionTemplate.selectList("master.mpvo.getDashBoardList4", param);
	}

}

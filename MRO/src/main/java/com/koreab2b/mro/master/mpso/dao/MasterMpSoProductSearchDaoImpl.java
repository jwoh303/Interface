package com.koreab2b.mro.master.mpso.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoProductSearchDaoImpl")
@Transactional
public class MasterMpSoProductSearchDaoImpl implements MasterMpSoProductSearchDao {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoProductSearchDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoProductSearchList", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectRootTreeList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoProductSearchRootTreeList", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectChildTreeList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoProductSearchChildTreeList", param);
	}
	
	@SuppressWarnings("unchecked")
	public String insertWmsCart(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "OK";
		
		try{
			
			String st_wms_code = formData.get("st_wms_code");
			String st_user_id = formData.get("st_user_id");
			String st_contract = "";

			Map<String,Object> tMap = new HashMap<String, Object>();
						
			for(int i=gridData.size()-1; i >= 0 ; i--){
				tMap.putAll((Map<String, String>)gridData.get(i));
				st_contract+= "('" + tMap.get("CONTRACT_NO") + "', '" + tMap.get("CONTRACT_SEQ") + "')@";
			}
			
			tMap.put("st_wms_code", st_wms_code);
			tMap.put("st_user_id", st_user_id);
			tMap.put("arry_contract", CommonUtil.StrToArray(st_contract, "@"));
			
			int cartCnt = (Integer)sqlSessionTemplate.selectOne("selectMasterMpSoProductSearch_cartCount", tMap);
			
			if(cartCnt == 0){
				for(int i=gridData.size()-1; i >= 0 ; i--){
					formData.putAll((Map<String, String>)gridData.get(i));
					formData.put("st_wms_code", st_wms_code);
					formData.put("st_user_id", st_user_id);
					
					sqlSessionTemplate.update("master.mpso.insertMasterMpSoProductSearch_cart", formData);
				}
			}else{
				_rtnMsg = "EXIST";
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

}

package com.koreab2b.mro.common.mpiv.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;


@Repository("masterMpIvDivsnDeliveryPlanAlterPopDao")
@Transactional
public class MasterMpIvDivsnDeliveryPlanAlterPopDaoImpl implements MasterMpIvDivsnDeliveryPlanAlterPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> _pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectMasterMpIvDivsnDeliveryPlanAlterPopList", _pMap);
	}
	
	public String updateMasterMpIvDivsnDeliveryPlanAlterPop(Map<String,String> _pMap){
		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		int res_cnt = 0;
		try{
			String query_str	= CommonUtil.nvl(_pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			String admin_flag1 = "Y";
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 		str[0]);
				_map.put("po_no", 		str[1]);
				_map.put("po_seq", 		str[2]);
				_map.put("po_qty", 		str[3]);
				_map.put("cd_date", 	str[4]);
				_map.put("cd_qty", 		str[5]);
				_map.put("ds_flag", 	str[6]);
				_map.put("seller", 		str[7]);
				_map.put("user_id", 	str[8]);
				_map.put("delay_reason",str[9]);
				_map.put("max_cd_date",	str[10]);
				_map.put("rd_date",		str[11]);
				_map.put("inv_qty",		str[12]);
				
				// 납기요청일이 납품예정일보다 이전이면 admin_flag1값을 N으로 입력
				if(Integer.parseInt(str[11]) < Integer.parseInt(str[4])){
					admin_flag1 = "N";
				}
				
				_map.put("admin_flag1", admin_flag1);
				
				_list.add(_map);
			}

			// 1. ICOMIVDT UPDATE
			res_cnt = sqlSessionTemplate.update("common.mpiv.updateDivsnDeliveryPlanAlterPors", (Map<String, String>)_list.get(0));

			for(int i=0; i < _list.size(); i++){

				// 2. ICOMPODT UPDATE
				res_cnt = sqlSessionTemplate.update("common.mpiv.insertDivsnDeliveryPlanAlterPors", (Map<String, String>)_list.get(i));
				
			}
			
			res_cnt = sqlSessionTemplate.update("common.mpiv.updateDivsnDeliveryPlanAlterPodt", (Map<String, String>)_list.get(0));
			
		}catch(Exception e){
			throw new RuntimeException("납품계획 변경이 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
}

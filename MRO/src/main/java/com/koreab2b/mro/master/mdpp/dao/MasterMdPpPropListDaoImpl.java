package com.koreab2b.mro.master.mdpp.dao;

import java.util.ArrayList;
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

@Repository("masterMdPpPropListDao")
@Transactional
public class MasterMdPpPropListDaoImpl implements MasterMdPpPropListDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdPpPropListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdpp.selectMasterMdPpPropList", param);
	}

	// 상세 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropDetailPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mdpp.selectMasterMdPpPropDetailPop", formData);
	}
	
	// 제안평가 조회
	public List<Map<String,String>> getMasterMdPpPropArpsPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mdpp.selectMasterMdPpPropArpsPop", formData);
	}
	
	// 평가
	public String saveMasterMdPpPropArps(Map<String,String> pMap) {

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				_map = new HashMap<String, String>();
				
				_map.put("pp_no",		str[0]);
				_map.put("pp_seq",		str[1]);
				_map.put("pp_attb1",	str[2]);
				_map.put("pp_attb_p1",	str[3]);
				_map.put("pp_attb2",	str[4]);
				_map.put("pp_attb_p2",	str[5]);
				_map.put("pp_attb3",	str[6]);
				_map.put("pp_attb_p3",	str[7]);
				_map.put("exec_team",	str[8]);
				_map.put("user_id",		str[9]);
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				sqlSessionTemplate.update("master.mdpp.saveMasterMdPpPropArps", (Map<String, String>)_list.get(i));
				sqlSessionTemplate.update("master.mdpp.updateMasterMdPpPropArpsStatus", (Map<String, String>)_list.get(i));
			}
		}catch(Exception e){
			throw new RuntimeException("평가처리 중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 불채택
	public String rejectMasterMdPpPropArps(Map<String,String> pMap) {

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				_map = new HashMap<String, String>();
				
				_map.put("pp_no",		str[0]);
				_map.put("pp_seq",		str[1]);
				_map.put("reason",		str[2]);
				_map.put("user_id",		str[3]);
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				sqlSessionTemplate.update("master.mdpp.rejectMasterMdPpPropArps", (Map<String, String>)_list.get(i));
				sqlSessionTemplate.update("master.mdpp.updateMasterMdPpPropArpsStatus", (Map<String, String>)_list.get(i));
			}
		}catch(Exception e){
			throw new RuntimeException("평가처리 중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	// 불채택 사유 팝업 조회
	public List<Map<String,String>> getMasterMdPpPropRejectPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mdpp.selectMasterMdPpPropRejectPop", formData);
	}
}

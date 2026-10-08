package com.koreab2b.mro.common.none.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("commonNoNeMyMenuPopDaoImpl")
@Transactional
public class CommonNoNeMyMenuPopDaoImpl implements CommonNoNeMyMenuPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getCommonNoNeMyMenuAllList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.none.getCommonNoNeMyMenuAllList", formData);
	}
	
	// 조회
	public List<Map<String,String>> getCommonNoNeMyMenuList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.none.getCommonNoNeMyMenuList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveCommonNoNeMyMenu(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "INSERT_OK";
		
		try{
			formData.put("st_prty_key", "MYMENU_LIST");
			sqlSessionTemplate.update("common.none.deleteMyMenu_all", formData);
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				formData.put("st_prty_seq",formData.get("SEQ"));
				formData.put("st_prty_value", formData.get("MENU_ID"));
				formData.put("st_use_flag", "Y");
				
				sqlSessionTemplate.update("common.none.insertMyMenu", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("나의 메뉴 저장에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveCommonNoNeMyMenuAjax(Map<String,String> formData) {
		
		String _rtnMsg = "INSERT_OK";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		try{
			String query_str	= CommonUtil.nvl(formData.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			formData.put("st_prty_key", "MYMENU_LIST");
			sqlSessionTemplate.update("common.none.deleteMyMenu_all", formData);

			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("st_prty_key", "MYMENU_LIST");
				_map.put("st_prty_seq", 				str[2]);
				_map.put("st_prty_value", 				str[1]);
				_map.put("st_user_id",	formData.get("st_user_id"));
				_map.put("st_use_flag", "Y");
				_list.add(_map);
			}
			for(int i=0; i < _list.size(); i++){
				Map<String,String> mp = (Map<String,String>)_list.get(i);
				sqlSessionTemplate.update("common.none.insertMyMenu", mp);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("나의 메뉴 저장에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	//저장
	public Map<String, Object> addCommonNoNeMyMenu(Map<String,String>  param){
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String _rtnMsg = "나의 메뉴에 등록되었습니다.";
		int chk = 0;
		try {
			List<Map<String,String>> tmpList = sqlSessionTemplate.selectList("common.none.getCommonNoNeMyMenuList", param);
			if(tmpList.size() == 6){
				throw new Exception("나의 메뉴는 최대 6개까지 등록 가능합니다.");
			}else{
				for(int i = 0; i<tmpList.size(); i++){
					if(param.get("st_prty_value").equals(tmpList.get(i).get("MENU_ID"))){
						throw new Exception("이미 나의 메뉴에 등록되어 있습니다.");
					}
				}
			}
			param.put("st_prty_key", "MYMENU_LIST");
			param.put("st_use_flag", "Y");
			chk = sqlSessionTemplate.update("common.none.insertMyMenu", param);
			if(chk == 0){
				throw new Exception("추가에 실패하였습니다.\n관리자에게 문의하여 주시기 바랍니다.");
			}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnMap.put("msg", e.getMessage());
			rtnMap.put("code", "NO");
			return rtnMap;
		}
		rtnMap.put("msg", _rtnMsg);
		rtnMap.put("code", "OK");
		return rtnMap;
	}
	

}

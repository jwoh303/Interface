package com.koreab2b.mro.master.mdcp.dao;

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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCpUserViewDao")
@Transactional
public class MasterMdCpUserViewDaoImpl implements MasterMdCpUserViewDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpUserViewDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		/*로그 기록*/
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdcp.selectMasterMdCpUserViewList").getBoundSql(param).getSql();
		String attr_01 = "";
		for(Map.Entry<String, Object>entry: param.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(param);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "사용자조회");
		data.put("LOG_TYPE", "사용자조회");
		data.put("ATTR_01", strSql+"/"+attr_01);
		// ATTR_02 = 검색한 사용자 아이디 / 이름 / 회원사명
		data.put("ATTR_02", CommonUtil.nvl3((String)param.get("st_search_user_id"),"") + " / "
			+ CommonUtil.nvl3((String)param.get("st_search_user_name"),"") + " / " 
			+ CommonUtil.nvl3((String)param.get("st_search_com_name"),""));
		// ATTR_03 = 검색한 부서명 / 사용자구분 / 회원사구분
				data.put("ATTR_03", CommonUtil.nvl3((String)param.get("st_dept_name"),"") + " / "
					+ CommonUtil.nvl3((String)param.get("st_search_user_type"),"") + " / " 
					+ CommonUtil.nvl3((String)param.get("st_business_cond"),""));
		
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);

		return sqlSessionTemplate.selectList("master.mdcp.selectMasterMdCpUserViewList", param);

	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mdcp.insertMasterMdCpUserView", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("st_user_id", formData.get("USER_ID"));

				sqlSessionTemplate.update("master.mdcp.deleteMasterMdCpUserView", formData);
				
				sqlSessionTemplate.update("master.mdcp.deleteMasterMdCpUserInfo", formData);
				
				logger.error("deleteMasterMdCpUserView 실행 완료");

			}
		} catch(Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}

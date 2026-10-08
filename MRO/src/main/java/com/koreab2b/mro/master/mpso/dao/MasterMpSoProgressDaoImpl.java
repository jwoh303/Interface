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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoProgressDao")
@Transactional
public class MasterMpSoProgressDaoImpl implements MasterMpSoProgressDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoProgressDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectList(Map<String, Object> formData) {
		//고객사코드
		List<String> list = CommonUtil.getStringArrary((String) formData.get("st_buyer_code"), "@");
		formData.put("st_buyer_code", list);
		//진행상태코드
//		String status = (String) formData.get("st_status");
//		if( "PO10,PO20,PO30,PO40,PO50,PO60,PO70,PO99".equals(status) ){
//			formData.put("st_status", "");
//		}
		formData.put("st_status_all", CommonUtil.getStringArrary( (String) formData.get("st_status") , ","));
		formData.put("statusDel", ( formData.get("st_status_all").toString().indexOf("PO10") > -1 )? "1" : "0" ); 
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		
		sqlSessionTemplate.select("master.mp.so.selectMasterMpSoProgressList", formData, _resultHander);
		/*로그 기록*/
		//String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mp.so.selectMasterMpSoProgressDownLoadList").getBoundSql(formData).getSql();
		String attr_01 = "";
		for(Map.Entry<String, Object>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "주문진행상세");
		data.put("LOG_TYPE", "조회");
		data.put("ATTR_01", attr_01);
		data.put("ATTR_02","");
		data.put("ATTR_03","");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		return (List<Map<String, String>>) _resultHander.getList();

	}

	// 저장(FeedBack)
	@SuppressWarnings("unchecked")
	public int updateSelectedData(Map<String, String> formData, List<Object> gridData) {

		try{
			for (int i = 0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>) gridData.get(i));

				if (formData.get("KEP_RAV_SEQ").equals("1")) {
					// 운영사 FeedBack insert
					sqlSessionTemplate.update("master.mp.so.insertMasterMpSoProgress", formData);
					// 고객사 요청내역 완료 update
					sqlSessionTemplate.update("master.mp.so.updateMasterMpSoProgress1", formData);
				} else {
					// 운영사 FeedBack update
					sqlSessionTemplate.update("master.mp.so.updateMasterMpSoProgress2", formData);
					// 고객사 요청내역 완료 update
					sqlSessionTemplate.update("master.mp.so.updateMasterMpSoProgress1", formData);
				}
			}
			/* 메일링 로직 있음 */			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장(FeedBack)에 실패하였습니다.");
		}

		return 0;
	}
	// 저장(FeedBack)
	@SuppressWarnings("unchecked")
	public int updateFileData(Map<String, String> formData, List<Object> gridData) {

		try{
			for (int i = 0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>) gridData.get(i));

				if (formData.get("SELECTED").equals("1")) {
					// 첨부파일업데이트
					sqlSessionTemplate.update("master.mp.so.updateFileMasterMpSoProgress", formData);
				}
			}			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장(FeedBack)에 실패하였습니다.");
		}

		return 0;
	}
	// IKEN결재
	@SuppressWarnings("unchecked")
	public int saveIKENSelectedData(Map<String, String> formData, List<Object> gridData) {
		
		try{
			for (int i = 0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>) gridData.get(i));
				
					sqlSessionTemplate.insert("master.mp.so.saveIKENMasterMpSoProgress", formData);

			}	
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("IKEN결재에 실패하였습니다.");
		}
		
		return 0;
	}
	
	public String selectMasterMpSoMyColManagePopList(Map<String,Object> formData){
		return sqlSessionTemplate.selectOne("master.mp.so.selectMasterMpSoMyColManagePopList", formData);
	}
	
	public String insertMasterMpSoMyColManagePop(Map<String,String> pMap) {
		
		//선택된 디폴트결재선외 초기화
		pMap.put("st_prty_key", "MYCOL_LIST");
		sqlSessionTemplate.update("common.none.deleteBuyerMyMenu_all", pMap);
		
		Map<String,String> param = null;
		
		String user_id = (String) pMap.get("st_user_id");
		String st_my_col = (String) pMap.get("st_my_col");
		
		param = new HashMap<String, String>();
		param.put("st_user_id", user_id);
		param.put("st_prty_key", "MYCOL_LIST");
		param.put("st_prty_seq", "1");
		param.put("st_prty_value", st_my_col);
		param.put("st_use_flag", "Y");
		sqlSessionTemplate.update("common.none.insertBuyerMyMenu", param);
		
		return "INSERT_OK";
	}
	
	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectDownLoadList(Map<String, Object> formData) {
		//고객사코드
		List<String> list = CommonUtil.getStringArrary((String) formData.get("st_buyer_code"), "@");
		formData.put("st_buyer_code", list);
		
		// 품목코드
		if(!formData.get("st_buyer_item_no_multi").equals("")){
			List<String> item_list = CommonUtil.getStringArrary((String) formData.get("st_buyer_item_no_multi"), "@");
			formData.put("st_buyer_item_no_multi", item_list);	
		}
		
		//진행상태코드
//		String status = (String) formData.get("st_status");
//		if( "PO10,PO20,PO30,PO40,PO50,PO60,PO70,PO99".equals(status) ){
//			formData.put("st_status", "");
//		}
		formData.put("st_status_all", CommonUtil.getStringArrary( (String) formData.get("st_status") , ","));
		formData.put("statusDel", ( formData.get("st_status_all").toString().indexOf("PO10") > -1 )? "1" : "0" ); 
		
		formData.put("st_issue_all", CommonUtil.getStringArrary( (String) formData.get("st_issue_type") , ","));
		
		String my_col_info = (String) formData.get("my_col_info");
		String[] myColInfo = CommonUtil.StrToArray(my_col_info, ",");
		
		if(myColInfo != null && myColInfo.length > 0){
			for( int inx = 0 ; inx < myColInfo.length ; inx++){
				formData.put("myCol"+(inx+1), myColInfo[inx]);
			}
		}
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mp.so.selectMasterMpSoProgressDownLoadList", formData, _resultHander);
		/*로그 기록*/
		//String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mp.so.selectMasterMpSoProgressDownLoadList").getBoundSql(formData).getSql();
		String attr_01 = "";
		for(Map.Entry<String, Object>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "주문진행");
		data.put("LOG_TYPE", "조회");
		data.put("ATTR_01", attr_01);
		data.put("ATTR_02","");
		data.put("ATTR_03","");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		return (List<Map<String, String>>) _resultHander.getList();
		
	}
	
}

package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerMpIvTranStatementWriteDao")
@Transactional
public class SellerMpIvTranStatementWriteDaoImpl implements SellerMpIvTranStatementWriteDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> param) {
		String pageflag = (String) param.get("paging");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("seller.mpiv.selectSellerMpIvTranStatementWriteList", param, _resultHander);
			 
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvTranStatementWriteList", param);
		}
		return resultList;
	}
	
	// 조회
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListPO_v2(Map<String,Object> param){
		List<String> list = CommonUtil.getStringArrary((String)param.get("st_po_no"), ",");
		if(list.size() != 0){
			param.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvTranStatementWriteListPO_v2", param);
	}
	// 조회
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItem_v2(Map<String,Object> param){
		List<String> list = CommonUtil.getStringArrary((String)param.get("st_po_no"), ",");
		if(list.size() != 0){
			param.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvTranStatementWriteListItem_v2", param);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWritePrintList_v2(Map<String,Object> param){
		List<String> list = CommonUtil.getStringArrary((String)param.get("st_po_no"), ",");
		if(list.size() != 0){
			param.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvTranStatementWritePrintList_v2", param);
	}
	
	// 조회
	public Map<String,String> getSellerMpIvTranStatementWriteQryForReport_v2(Map<String,String> param){
		return sqlSessionTemplate.selectOne("seller.mpiv.getSellerMpIvTranStatementWriteQryForReport_v2", param);
	}
	
}

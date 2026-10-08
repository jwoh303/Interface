package com.koreab2b.mro.master.mprq.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpRqDssSellerSelDao")
@Transactional
public class MasterMpRqDssSellerSelDaoImpl implements MasterMpRqDssSellerSelDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		String _st_sheet = (String) param.get("st_sheet");

		if (!_st_sheet.equals("5")&&!_st_sheet.equals("13")&&!_st_sheet.equals("14")){
			List< String > _list = new ArrayList< String >( );
			List< String > _agent_list	= new ArrayList<String>();
			_list = CommonUtil.getStringArrary((String) param.get("st_maker_code"),"@");
			_agent_list = CommonUtil.getStringArrary((String) param.get("st_multi_agent"),",");

			String misumi_qt_str	= "KRMISU0004";
			if(_agent_list.size() > 0) {
				for ( int i = 0 ; i < _agent_list.size() ; i++) {
					if ( "KRMISU0004".equals(_agent_list.get(i)) ) {
						misumi_qt_str = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqDssMisumiCheckoutResult", param);
					}
				}
			}
			
			if(_list.size() > 0){
				param.put("st_maker_code", _list);
			}
			if (_st_sheet.equals("10")){
				List< String > _list2 = new ArrayList< String >( );
				_list2 = CommonUtil.getStringArrary((String) param.get("st_multi_agent_dss"),",");
				
				if(_list2.size() > 0){
				
					String sub_query = "";
					sub_query += "		, (SELECT	\n";
					sub_query += "			DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", SUBSTR(COL"+i+",0,10)	\n";
					}
					sub_query += "		) AGENT_ROW	\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", F_SPLIT(COL"+i+",'^',2)	\n";
					}
					sub_query += "		) GPL_LIST_PRICE\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", F_SPLIT(COL"+i+",'^',3)	\n";
					}
					sub_query += "		) GPL_DLVRY_LT\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", F_SPLIT(COL"+i+",'^',4)	\n";
					}
					sub_query += "		) GPL_TAX_TYPE\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", F_SPLIT(COL"+i+",'^',5)	\n";
					}
					sub_query += "		) GPL_MIN_ORDER_QTY\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", F_SPLIT(COL"+i+",'^',6)	\n";
					}
					sub_query += "		) GPL_PUR_UNIT_QTY\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", F_SPLIT(COL"+i+",'^',7)	\n";
					}
					sub_query += "		) GPL_SELLER_AREA\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", F_SPLIT(COL"+i+",'^',8)	\n";
					}
					sub_query += "		) GPL_SELLER_ITEM_NO\n";
					sub_query += "		,DECODE(ROWNUM	\n";
					for(int i = 1; i <= _list2.size(); i++){
						sub_query += "			, "+i+", SUBSTR(COL"+i+",11,1)	\n";
					}
					sub_query += "		) DSS_CHOICE	\n";
					sub_query += "	FROM	\n";
					sub_query += "		(SELECT	\n";
					for(int i = 1; i <= _list2.size(); i++){
						if ( "KRMISU0004".equals(_list2.get(i-1).substring(0, 10))) {
							sub_query += "			'"+misumi_qt_str+"' COL"+i+", 	\n";
						} else {
							sub_query += "			'"+_list2.get(i-1)+"' COL"+i+", 	\n";
						}
					}
					sub_query += "		'' FROM DUAL)	\n";
					sub_query += "		, (SELECT ROWNUM FROM DICT WHERE ROWNUM <= 1000)	\n";
					sub_query += "	) A_LIS	\n";

					param.put("st_multi_agent_dss", sub_query);
				}
			}
		}
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqDssSellerSelList"+_st_sheet, param);
	}

	public List<Map<String, String>> getDssAgent(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqDssSellerSelList11", pMap);
	}
}

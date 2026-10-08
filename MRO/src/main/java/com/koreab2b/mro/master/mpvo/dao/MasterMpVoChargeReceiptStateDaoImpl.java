package com.koreab2b.mro.master.mpvo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

@Repository("masterMpVoChargeReceiptStateDao")
@Transactional
public class MasterMpVoChargeReceiptStateDaoImpl implements MasterMpVoChargeReceiptStateDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		String st_date_type = CommonUtil.nvl((String) param.get("st_date_type"),"WEEK");
		String st_date_flag = CommonUtil.nvl((String) param.get("st_date_flag"),"-14");
		String st_fromDate = CommonUtil.nvl((String) param.get("st_fromDate"),"");
		String st_toDate = DateTimeUtil.getFormatString("yyyyMMdd");
		
		if(st_date_type.equals("WEEK")){
			try {
				st_fromDate    = DateTimeUtil.addDays(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}	
		}else{
			try {
				st_fromDate    = DateTimeUtil.addMonths(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		param.put("st_fromDate", st_fromDate);
		param.put("st_toDate", st_toDate);
		
		return sqlSessionTemplate.selectList("master.mpvo.selectMasterMpVoChargeReceiptStateList", param);
	}

}

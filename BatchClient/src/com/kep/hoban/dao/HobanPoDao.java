/**
 * 
 */
package com.kep.hoban.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HobanPoDao {	
	// 발주 데이터 추가
	public void mergeHobanPoData(Map<String,Object> obj) throws Exception;
//	public void callProcHobanErr(Map<String,Object>  resultMap) throws Exception;
}

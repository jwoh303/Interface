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
public interface HobanRqDao {
	// 견적 데이터 추가
	public List<Map<String, Object>> selectHobanRqData() throws Exception;
	public void insertRqResultData(Map<String,Object> result) throws Exception;
//	public void callProcHobanErr(Map<String,Object>  resultMap) throws Exception;
}

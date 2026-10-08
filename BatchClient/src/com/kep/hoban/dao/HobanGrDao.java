/**
 * 
 */
package com.kep.hoban.dao;

import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HobanGrDao {
	// PO 데이터 추가
	public void mergeHobanGrData(Map<String,Object> obj) throws Exception;
//	public void callProcHobanErr(Map<String,Object>  resultMap) throws Exception;
}

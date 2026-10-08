/**
 * 
 */
package com.kep.amorepacific.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface AmorepacificDao {
	public List<Map<String,String>> selectAmorepacificCheckParam() throws Exception;
	public List<Map<String,String>> selectAmorepacificPrList() throws Exception;		
	public List<Map<String,String>> selectAmorepacificOrderParam(Map<String,String> pr) throws Exception;		
	public void updateAmorepacificOrderParam(List<Map<String,String>> reqTmp, Map<String,Object> result) throws Exception;
	public void insertAmorepacificOrderProgress(List<Map<String,String>> reqTmp) throws Exception;
	public void updateAmorepacificOrderPrdt(List<Map<String,String>> reqTmp, Map<String, Object> result) throws Exception;
	public void updateAmorepacificError(Map<String,Object> result) throws Exception;
	
}

/**
 * 
 */
package com.kep.skmw.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface SkMwDao {
	public List<Map<String,Object>> selectSkMwToken() throws Exception;
	public List<Map<String,Object>> selectSkMwItemList() throws Exception;
	public void updateSkMwItem(Map<String,Object> item) throws Exception;
	public void updateSkMwErr() throws Exception;
}

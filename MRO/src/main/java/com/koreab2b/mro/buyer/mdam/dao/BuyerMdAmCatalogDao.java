package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmCatalogDao {

	public List<Map<String,String>> selectList(Map<String,String> formData);
}

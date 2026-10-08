package com.koreab2b.mro.util;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

public class JsonHpack {

	protected static List<List<List<Object>>> _cache;

	public static Map<String, Object> unpackCreateRow(List<String> keys, List<Object> values) {
		Map<String, Object> result = new LinkedHashMap<String, Object>();
		for (int i = 0, len = keys.size(); i < len; i++)
			result.put(keys.get(i), values.get(i));
		return result;
	}

	public static int best(List<Map<String, Object>> collection) {
		Gson json = new Gson();
		int j = 0;
		_cache = new ArrayList<List<List<Object>>>();
		for (int i = 0, len = 0, length = 0; i < 4; i++) {
			_cache.add(pack(collection, i));
			len = json.toJson(_cache.get(i)).length();
			if (length == 0)
				length = len;
			else if (len < length) {
				length = len;
				j = i;
			}
		}
		return j;
	}

	public static List<List<Object>> pack(List<Map<String, Object>> collection) {
		return pack(collection, 0);
	}
	
	@SuppressWarnings("unchecked")
	public static List<List<Object>> pack(Object object, int compression) {
		return pack((List<Map<String, Object>>)object, compression);
	}

	@SuppressWarnings("unchecked")
	public static List<List<Object>> pack(List<Map<String, Object>> collection, int compression) {
		List<List<Object>> result = new ArrayList<List<Object>>();
		if (3 < compression) {
			int i = best(collection);
			result = _cache.get(i);
			_cache.clear();
		} else {
			List<Object> header = new ArrayList<Object>();
			Map<String, Object> first = collection.get(0);
			int length = collection.size();
			int len = first.keySet().size();
			int index;
			result.add(header);
			for (String key : first.keySet())
				header.add(key);
			for (int i = 0; i < length; ++i) {
				Map<String, Object> item = collection.get(i);
				List<Object> row = new ArrayList<Object>();
				for (int j = 0; j < len; ++j)
					row.add(item.get((String) header.get(j)));
				result.add(row);
			}
			index = result.size();
			if (0 < compression) {
				List<Object> row = result.get(1);
				for (int j = 0; j < len; ++j) {
					if (!(row.get(j) instanceof Integer) && !(row.get(j) instanceof Float) && !(row.get(j) instanceof Double)) {
						List<Object> cache = new ArrayList<Object>();
						List<Object> current = new ArrayList<Object>();
						current.add(header.get(j));
						current.add(cache);
						header.remove(j);
						header.add(j, current);
						for (int i = 1, k = 0; i < index; ++i) {
							Object value = result.get(i).get(j);
							int l = cache.indexOf(value);
							if (l < 0) {
								cache.add(value);
								result.get(i).set(j, k++);
							} else
								result.get(i).set(j, l);
						}
					}
				}
			}
			if (2 < compression) {
				for (int j = 0; j < len; ++j) {
					if (header.get(j) instanceof List) {
						Gson json = new Gson();
						List<Object> values = new ArrayList<Object>();
						List<Object> indexes = new ArrayList<Object>();
						List<Object> cache = (List<Object>) header.get(j);
						String key = (String) cache.get(0);
						cache = (List<Object>) cache.get(1);
						for (int i = 1; i < index; ++i) {
							Object value = result.get(i).get(j);
							indexes.add(value);
							values.add(cache.get((Integer) value));
						}
						indexes.addAll(cache);
						if (json.toJson(values).length() < json.toJson(indexes).length()) {
							for (int k = 0, i = 1; i < index; ++i) {
								result.get(i).set(j, values.get(k));
								++k;
							}
							header.set(j, key);
						}
					}
				}
			} else if (1 < compression) {
				length -= (int) Math.floor((double) (length / 2));
				for (int j = 0; j < len; ++j) {
					if (header.get(j) instanceof List) {
						List<Object> cache = (List<Object>) header.get(j);
						String key = (String) cache.get(0);
						cache = (List<Object>) cache.get(1);
						if (length < cache.size()) {
							for (int i = 1; i < index; ++i) {
								Object value = result.get(i).get(j);
								result.get(i).set(j, cache.get((Integer) value));
							}
							header.set(j, key);
						}
					}
				}
			}
			if (0 < compression) {
				for (int j = 0; j < len; ++j) {
					if (header.get(j) instanceof List) {
						List<Object> cache = (List<Object>) header.get(j);
						String key = (String) cache.get(0);
						header.set(j, key);
						header.add(j + 1, cache.get(1));
						++len;
						++j;
					}
				}
			}

		}
		return result;
	}

	public static List<Map<String, Object>> unpack(List<List<Object>> collection) {
		int length = collection.size();
		List<Object> header = collection.get(0);
		List<String> keys = new ArrayList<String>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		for (int i = 0, k = 0, l = 0, len = header.size(); i < len; ++i) {
			keys.add((String) header.get(i));
			k = i + 1;
			if (k < len && header.get(k) instanceof Object[]) {
				++i;
				for (int j = 1; j < length; ++j) {
					List<Object> row = collection.get(j);
					Object[] head = (Object[]) header.get(k);
					row.set(l, head[(Integer) row.get(l)]);
				}
			}
			++l;
		}
		for (int j = 1; j < length; ++j)
			result.add(unpackCreateRow(keys, collection.get(j)));
		return result;
	}
}

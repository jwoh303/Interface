package com.koreab2b.mro.manager.security.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.MultiValueMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.stereotype.Component;

import com.koreab2b.mro.manager.menu.dao.MenuDao;
import com.koreab2b.mro.manager.menu.domain.Menu;

@Component("securityURLdataSource")
public class SecurityURLdataSource implements FilterInvocationSecurityMetadataSource {

	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityURLdataSource.class);

	@Autowired
	private MenuDao menuDao;

	@SuppressWarnings("unchecked")
	public Map<RequestMatcher, Collection<ConfigAttribute>> loadResourceMap() {
		Map<RequestMatcher, Collection<ConfigAttribute>> _resourceMap = new LinkedHashMap<RequestMatcher, Collection<ConfigAttribute>>();
		
		List<Menu> _menus =menuDao.selectMenusForSecurity();		
		MultiValueMap _multiMap = new MultiValueMap();
		
		for(Menu _tmp: _menus){
			_multiMap.put(_tmp.getUrl(), _tmp.getAuthId());
		}
		
		Iterator<String> _urls = _multiMap.keySet().iterator();
		String _url = null;
		AntPathRequestMatcher _urlMatcher = null;
		ArrayList<String> _authNameArray = null;
		String[] _auths = null;
		List<ConfigAttribute> _authListConfig = null;
		
		while(_urls.hasNext()){
			 _url =_urls.next();
			 _urlMatcher = new AntPathRequestMatcher(_url);
			 _authNameArray = (ArrayList<String>)_multiMap.get(_url);
			 _auths = new String[_authNameArray.size()];
			 _authNameArray.toArray(_auths );
			 _authListConfig = SecurityConfig.createList(_auths);
			 _resourceMap.put(_urlMatcher, _authListConfig);
		 }
		
		return _resourceMap;
	}

	public Collection<ConfigAttribute> getAllConfigAttributes() {
		Map<RequestMatcher, Collection<ConfigAttribute>> resourceMap = loadResourceMap();

		Set<ConfigAttribute> allAttributes = new HashSet<ConfigAttribute>();

		for (Map.Entry<RequestMatcher, Collection<ConfigAttribute>> entry : resourceMap.entrySet()) {
			allAttributes.addAll(entry.getValue());
		}

		return allAttributes;
	}

	public Collection<ConfigAttribute> getAttributes(Object object) {
		Map<RequestMatcher, Collection<ConfigAttribute>> resourceMap = loadResourceMap();

		final HttpServletRequest request = ((FilterInvocation) object).getRequest();

		LOGGER.debug("요청 URL 은 {} 입니다.", request.getServletPath());

		for (Map.Entry<RequestMatcher, Collection<ConfigAttribute>> entry : resourceMap.entrySet()) {
			if (entry.getKey().matches(request)) {
				return entry.getValue();
			}
		}
		return null;
	}

	public boolean supports(Class<?> clazz) {
		return FilterInvocation.class.isAssignableFrom(clazz);
	}

}

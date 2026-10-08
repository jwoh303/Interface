package com.koreab2b.mro.manager.security.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import com.koreab2b.mro.manager.auth.dao.AuthDao;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

@Component("securityAuthenticationProvider")
public class SecurityAuthenticationProvider implements AuthenticationProvider {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityAuthenticationProvider.class);

	@Autowired
	private AuthDao authDao;
	
	@Override
	public Authentication authenticate(Authentication pAuthentication) throws AuthenticationException {
		
		String _password = "";
	  //SeedCbcAlgorithmUtil 복호화
		String pszUserid = pAuthentication.getName();
	    byte[] decrUser_id =  SeedCbcAlgorithmUtil.getBytes(pszUserid);    
	    byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrUser_id,0,decrUser_id.length);

	    String  _userId =  new String(cbcAlgorithm);
		List<String> _roleList = authDao.selectAuthIdsByUserId(_userId);		
		return new UsernamePasswordAuthenticationToken(_userId, _password,getAuthorities(_userId, _roleList));
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}
	
	private Collection<? extends GrantedAuthority> getAuthorities(String pUserName, List<String> pRoleList ) {
		List<GrantedAuthority> _grantedAuths = new ArrayList<GrantedAuthority>();

		for (String _tmpRole : pRoleList) {
			LOGGER.debug(" {} 는 {} 권한이 있습니다.", pUserName, _tmpRole);
			_grantedAuths.add(new SimpleGrantedAuthority(_tmpRole));
		}

		return _grantedAuths;
	}

}

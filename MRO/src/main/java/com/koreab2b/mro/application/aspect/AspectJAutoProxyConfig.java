package com.koreab2b.mro.application.aspect;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile("development")
@EnableAspectJAutoProxy
public class AspectJAutoProxyConfig {

	@Bean(name = "methodBeforeLog")
	public MethodBeforeLog methodBeforeLog() {
		return new MethodBeforeLog();
	}
	
	@Bean(name = "methodAfterLog")
	public MethodAfterLog methodAfterLog() {
		return new MethodAfterLog();
	}
	
	@Bean(name = "methodPerformace")
	public MethodPerformace methodPerformace() {
		return new MethodPerformace();
	}
}

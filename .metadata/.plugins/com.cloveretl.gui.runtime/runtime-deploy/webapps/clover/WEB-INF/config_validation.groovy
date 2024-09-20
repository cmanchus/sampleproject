/*
 * This script is used for verification of various relations between the config properties.
 * It's executed just after merge of all config sources and modification script, before any of config properties is used 
 * (also placeholders in the applicationContext.xml are evaluated later)
 *
 * "p" variable is instance of Map<String,String> containing merged properties
 */

import com.cloveretl.server.facade.api.exceptions.ConfigurationException;

if ("true".equals(p.get("cluster.enabled")) && "true".equals(p.get("startup.validation.cluster.derby.enabled")) ) {
	String dialect = p.get("jdbc.dialect");
	if (dialect.indexOf("Derby") > -1) {
		throw new ConfigurationException("Derby DB cannot be used in cluster mode. Configure to use other database or disable clustering."); 
	}
}
	     
return p;   
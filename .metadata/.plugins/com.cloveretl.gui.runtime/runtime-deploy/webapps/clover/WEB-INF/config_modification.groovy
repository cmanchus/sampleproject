/*
 * This script is used for correct setting of various relations between the config properties.
 * It's executed just after merge of all config sources, before any of config properties is used 
 * (also placeholders in the applicationContext.xml are evaluated later)
 *
 * "p" variable is instance of Map<String,String> containing merged properties
 */

//import
 import com.cloveretl.server.facade.api.exceptions.ConfigurationException;
//
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
// some properties may be obsolete (clover uses some replacement) 
// but customer has the old one. So the old one may override the new one here ... 
//
	      		
if (p.containsKey("engine.plugins.src")) 
	p.put("engine.plugins.additional.src", p.get("engine.plugins.src"));
	      		
//if (p.containsKey("jdbc.dialect")) 
//	p.put("datasource.main.dialect", p.get("jdbc.dialect"));


//
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
// some properties values are related, so they may be derived one from the other 
// e.g. hibernate dialect, quartz dialect and DB patch dialect. So user configures just Hibernate dialect, the others are derived... 
//

def dialect = p.get("jdbc.dialect");
if (dialect.equals("org.hibernate.dialect.SQLServerDialect")) {
	p.put("jdbc.dialect", "com.cloveretl.server.dbschema.MSSQLServer2008Dialect");
} else if(dialect.equals("org.hibernate.dialect.SQLServer2005Dialect")) {
	p.put("jdbc.dialect", "com.cloveretl.server.dbschema.MSSQLServer2005Dialect");
} else if(dialect.equals("org.hibernate.dialect.SQLServer2008Dialect")) {
	p.put("jdbc.dialect", "com.cloveretl.server.dbschema.MSSQLServer2008Dialect");
} else if(dialect.equals("org.hibernate.dialect.DB2400Dialect")) {
	p.put("jdbc.dialect", "com.cloveretl.server.dbschema.CloverDB2400Dialect");
} else if(dialect.equals("org.hibernate.dialect.DB2Dialect")) {
	p.put("jdbc.dialect", "com.cloveretl.server.dbschema.CloverDB2Dialect");
}

dialect = p.get("jdbc.dialect");

// key is hibernate dialect, value is Quartz dialect
def quartzDialectDictionary = [
	        		"com.cloveretl.server.dbschema.CloverDB2400Dialect"	:"org.quartz.impl.jdbcjobstore.DB2v6Delegate",
	        		"com.cloveretl.server.dbschema.CloverDB2Dialect"	:"org.quartz.impl.jdbcjobstore.DB2v6Delegate",
	        		"org.hibernate.dialect.DerbyDialect"		:"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"org.hibernate.dialect.DerbyTenFiveDialect" :"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"org.hibernate.dialect.DerbyTenSixDialect"	:"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"org.hibernate.dialect.DerbyTenSevenDialect":"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"com.cloveretl.server.dbschema.DerbyTableIdDialect":"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"org.hibernate.dialect.MySQLDialect"		:"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"org.hibernate.dialect.MySQL5Dialect"		:"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"org.hibernate.dialect.MySQLInnoDBDialect"	:"org.quartz.impl.jdbcjobstore.StdJDBCDelegate",
	        		"org.hibernate.dialect.Oracle12cDialect"	:"org.quartz.impl.jdbcjobstore.oracle.OracleDelegate",
	        		"org.hibernate.dialect.Oracle10gDialect"	:"org.quartz.impl.jdbcjobstore.oracle.OracleDelegate",
	        		"org.hibernate.dialect.Oracle9Dialect"		:"org.quartz.impl.jdbcjobstore.oracle.OracleDelegate",
	        		"org.hibernate.dialect.Oracle9iDialect"		:"org.quartz.impl.jdbcjobstore.oracle.OracleDelegate",
	        		"org.hibernate.dialect.PostgreSQLDialect"	:"org.quartz.impl.jdbcjobstore.PostgreSQLDelegate",
	        		"com.cloveretl.server.dbschema.MSSQLServerDialect"	:"org.quartz.impl.jdbcjobstore.MSSQLDelegate",
	        		"com.cloveretl.server.dbschema.MSSQLServer2005Dialect":"org.quartz.impl.jdbcjobstore.MSSQLDelegate",
	        		"com.cloveretl.server.dbschema.MSSQLServer2008Dialect":"org.quartz.impl.jdbcjobstore.MSSQLDelegate"
	];

if (!p.containsKey("quartz.driverDelegateClass") || "".equals(p.get("quartz.driverDelegateClass"))) {
	def quartzDialect = quartzDialectDictionary.get(dialect);
	if(quartzDialect!=null) {
		p.put("quartz.driverDelegateClass", quartzDialect);
	} else {
		throw new ConfigurationException("Unsupported jdbc.dialect for the quartz dialect dictionary: "+dialect);
	}
	//p.put("quartz.driverDelegateClass", quartzDialectDictionary.get(p.get("jdbc.dialect")));
}

// key is hibernate dialect, value is Db Patch dialect (directory name)
def dbPatchDialectDictionary = [
	        		"com.cloveretl.server.dbschema.CloverDB2400Dialect"	:"DB2400Dialect",
	        		"com.cloveretl.server.dbschema.CloverDB2Dialect"	:"DB2Dialect",
	        		"org.hibernate.dialect.DerbyDialect"		:"DerbyDialect",
	        		"org.hibernate.dialect.DerbyTenFiveDialect"	:"DerbyDialect",
	        		"org.hibernate.dialect.DerbyTenSixDialect"	:"DerbyDialect",
	        		"org.hibernate.dialect.DerbyTenSevenDialect":"DerbyDialect",
	        		"com.cloveretl.server.dbschema.DerbyTableIdDialect":"DerbyDialect",
	        		"org.hibernate.dialect.MySQLDialect"		:"MySQLDialect",
	        		"org.hibernate.dialect.MySQL5Dialect"		:"MySQLDialect",
	        		"org.hibernate.dialect.MySQLInnoDBDialect"	:"MySQLDialect",
	        		"org.hibernate.dialect.Oracle12cDialect"	:"Oracle9Dialect",
	        		"org.hibernate.dialect.Oracle10gDialect"	:"Oracle9Dialect",
	        		"org.hibernate.dialect.Oracle9Dialect"		:"Oracle9Dialect",
	        		"org.hibernate.dialect.Oracle9iDialect"		:"Oracle9Dialect",
	        		"org.hibernate.dialect.PostgreSQLDialect"	:"PostgreSQLDialect",
	        		"com.cloveretl.server.dbschema.MSSQLServerDialect"	:"SqlServerDialect",
	        		"com.cloveretl.server.dbschema.MSSQLServer2005Dialect":"SqlServerDialect",
	        		"com.cloveretl.server.dbschema.MSSQLServer2008Dialect":"SqlServerDialect"
	];

if (!p.containsKey("jdbc.schema.update.dialect") || "".equals(p.get("jdbc.schema.update.dialect"))) {
	def dbPatchDialect = dbPatchDialectDictionary.get(dialect);
	if(dbPatchDialect!=null) {
		p.put("jdbc.schema.update.dialect", dbPatchDialect);
	} else {
		throw new ConfigurationException("Unsupported jdbc.dialect for the DB patch dictionary: "+dialect);
	}
	//p.put("jdbc.schema.update.dialect", dbPatchDialectDictionary.get(p.get("jdbc.dialect")));
}

if ("JNDI".equals(p.get("datasource.type"))) {
	p.put("jdbc.driverClassName", "");
	p.put("jdbc.url", "");
	p.put("jdbc.username", "");
	p.put("jdbc.password", "");
}

if ("JDBC".equals(p.get("datasource.type"))) {
	//p.put("datasource.jndiName", "");
}

// for backward compatibility; when the digest_authentication.features_list is configured, storing of A1 digest is automatically enabled 
if ( 
	( "false".equals(p.get("security.digest_authentication.storeA1.enabled"))
		&& p.get("security.digest_authentication.features_list") != null) 
		&& p.get("security.digest_authentication.features_list").trim().length()>0
		) {
	p.put("security.digest_authentication.storeA1.enabled", "true");
}
		
if (p.containsKey("security.secure_passwd.provider"))
	p.put("security.job_parameters.encryptor.providerClassName", p.get("security.secure_passwd.provider"));

if (p.containsKey("security.secure_passwd.algorithm"))
	p.put("security.job_parameters.encryptor.algorithm", p.get("security.secure_passwd.algorithm"));
		
if (p.containsKey("security.secure_passwd.table.secure_passwd"))
	p.put("security.job_parameters.encryptor.master_password_encryption.password", p.get("security.secure_passwd.table.secure_passwd"));

if (p.containsKey("security.config.algorithm"))
	p.put("security.config_properties.encryptor.algorithm", p.get("security.config.algorithm"));
	
if (p.containsKey("security.config.provider.class"))
	p.put("security.config_properties.encryptor.providerClassName", p.get("security.config.provider.class"));

// for backward compatibility; 
if (p.containsKey("properties_resolver.additional_server_props_list"))
	p.put("properties_resolver.placeholders.server_props_list_default", p.get("properties_resolver.additional_server_props_list"));

	     
return p;   
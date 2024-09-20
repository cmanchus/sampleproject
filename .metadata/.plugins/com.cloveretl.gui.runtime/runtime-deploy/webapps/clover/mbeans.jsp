<%@page import="javax.servlet.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="javax.naming.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.management.*"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.management.*" %>

<%!
// Computation parameters
protected long now = 0l;
protected long lastSampleTime = 0l;

/**
 * Converts a String to a boolean
 */
private boolean getBoolean( String str )
{
 if( str != null && str.equalsIgnoreCase( "true" ) )
 {
  return true;
 }
 return false;
}

public MBeanServer getMBeanServer(){
	MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
	return 	mBeanServer;
}

/**
 * This is the main focus point of the Application Server specific Servlet classes;
 * though the getPerformanceRoot() method you will build an XML document that you
 * want to return to the caller
 */
//public abstract Element getPerformanceRoot( MBeanServer server, Map objectNames );


/**
 * Returns a specific ObjectName with the mbean name for the specified mbean type
 * in the specified domain
 */
protected ObjectName getObjectName( Map objectNames, String domain, String type, String name )
{
 // Get the Vector of domain names
 Vector ons = getObjectNames(objectNames,domain,type);

 // Find the requested bean
 for( Iterator i=ons.iterator(); i.hasNext(); )
 {
  ObjectName on = ( ObjectName )i.next();
  String objectName = on.getKeyProperty( "name" );
  if( objectName != null && objectName.equalsIgnoreCase( name ) )
  {
   // Found it
   return on;
  }
 }

 // Didn't find it
 return null;
}

/**
 * Returns a Vector of ObjectNames in the specified domain for the specified
 * type of mbeans
 */
protected Vector getObjectNames( Map objectNames, String domain, String type )
{
 // Get the domain map
 Map domainMap = getDomainMap(objectNames,domain);
 if( domainMap == null )
 {
  return null;
 }

 // Get the Vector of ObjectNames
 Vector v = ( Vector )domainMap.get( type );
 return v;
}

/**
 * Returns the domain map for the specified doamin name from the map of 
 * object names; map of object names must be passed instead of stored as a
 * member variable to support multithreading
 */
protected Map getDomainMap( Map objectNames, String domain )
{
 // Get the domain Map
 Map domainMap = ( Map )objectNames.get( domain );
 return domainMap;
}


/**
 * Returns all of the domain names found in the MBeanServer
 */
protected Set getDomainNames( Map objectNames )
{
 return objectNames.keySet();
}

/**
 * Preloads the ObjectName instances and sorts them into a Map indexed by
 * domain; e.g. jboss.web is a domain and Jetty=0,SocketListener=0 is the 
 * ObjectName.
 * 
 * For WebSphere, further categorizes by "type":
 * Map of domain names to a vector of maps of type names to object names
 */
protected Map preloadObjectNames( MBeanServer server )
{
 Map objectNames = new TreeMap();
 try
 {
  Set ons = server.queryNames( null, null );
  for( Iterator i=ons.iterator(); i.hasNext(); )
  {
   ObjectName name = ( ObjectName )i.next();
   String domain = name.getDomain();
   Map typeNames = null;
   if( objectNames.containsKey( domain ) )
   {
    // Load this domain's Vector from our map and 
    // add this ObjectName to it
    typeNames = ( Map )objectNames.get( domain );
   }
   else
   {
    // This is a domain that we don't have yet, add it
    // to our map
    typeNames = new TreeMap();
    objectNames.put( domain, typeNames );
   }

   // Search the typeNames map to match the type of this object
   String typeName = name.getKeyProperty( "type" );
   if( typeName == null ) typeName = "none";

   if( typeNames.containsKey( typeName ) )
   {
    Vector v = ( Vector )typeNames.get( typeName );
    v.add( name );
   }
   else
   {
    Vector v = new Vector();
    v.add( name );
    typeNames.put( typeName, v );
   }
  }
 }
 catch( Exception e )
 {
  e.printStackTrace();
 }
 return objectNames;
}

%> 

<%
response.reset(); // it is necessary to reset the response?
response.setContentType("text/html");
response.setHeader("Cache-Control", "no-cache; no-store; must-revalidate");
response.setHeader("Strict-Transport-Security", "max-age=63072000; includeSubDomains");
response.setHeader("X-XSS-Protection", "1; mode=block");
response.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'none'; object-src 'none'; base-uri 'none'; img-src 'self'; style-src 'none'");
response.setHeader("X-Content-Type-Options", "nosniff");
response.setHeader("X-Frame-Options", "DENY");
try
  {
   // Load our MBeanServer from the ServletContext
   MBeanServer server = ( MBeanServer )application.getAttribute( "mbean-server" );
   server = this.getMBeanServer();

    //response.setContentType("text/plain");   
   out.println("server:"+server+"\n");
   
   Map objectNames = null;
    objectNames = this.preloadObjectNames( server );
    //out.println( "Refresh object map:"+objectNames +"\n");
   this.now = System.currentTimeMillis();

    for( Iterator i=objectNames.keySet().iterator(); i.hasNext(); )
    {
     String domain = ( String )i.next();
     //out.println("domain:"+ key);
     Map typeNames = ( Map )objectNames.get( domain );
     for( Iterator j=typeNames.keySet().iterator(); j.hasNext(); )
     {
      String typeName = ( String )j.next();
      //out.println("type:" + typeName);
      Vector beans = ( Vector )typeNames.get( typeName );
      for( Iterator k=beans.iterator(); k.hasNext(); )
      {
       ObjectName on = ( ObjectName )k.next();
       out.println("<h2>mbean:" + on.getCanonicalName()+"</h2>");
       out.println("domain:" + domain+", type:"+typeName);
	out.println("<table border=\"1\">");
	 	out.println("<tr><th>attribute</th><th>value</th></tr>");
	
        try
        {
         MBeanInfo info = server.getMBeanInfo( on );
         MBeanAttributeInfo[] attributeArray = info.getAttributes();
         for( int x=0; x < attributeArray.length; x++ ) {
	 	out.println("<tr>");

          String attributeName = attributeArray[ x ].getName();
          out.print("<td>"+ attributeName+"</td>" );
          try
          {
           Object objectValue = server.getAttribute( on, attributeName );
           if( objectValue != null )
           {
        	   out.println(" <td>"+ objectValue.toString()+"</td>");
           }
          }
          catch( Exception exx )
          {
        	  out.println("<td>value error</td>" );
          }
	  	out.println("</tr>");

         }// for
        }
        catch( Exception ex )
        {
        	out.println("error "+ ex.getMessage());
        }

	out.println("</table>");
       
       out.println("");
       
      }
     }
    }

   // Save our last sample time
   this.lastSampleTime = this.now; 

  }
  catch( Exception e )
  {
   e.printStackTrace();
   throw new ServletException( e );
  }
  
  %>
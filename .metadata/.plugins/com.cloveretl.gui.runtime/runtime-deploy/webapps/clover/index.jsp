<%
String queryString = request.getQueryString();
String guiPage = "gui/login.jsf";
if (queryString != null) {
	guiPage = guiPage + "?" + queryString;
}
// CLO-17330: HttpServletResponse.sendRedirect() uses unwrapped Request with a wrong context path
// It would be better to wrap it in ReverseProxyFilter, but it would have to handle relative paths correctly, which is not easy.
String absolutePath = request.getContextPath() + "/" + guiPage;
response.sendRedirect(absolutePath);
%>

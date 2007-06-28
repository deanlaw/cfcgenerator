<cfoutput>
<%?xml version="1.0" encoding="UTF-8"?%>

<%beans%>
	<%bean id="#root.bean.xmlAttributes.name#DAO" class="#root.bean.xmlAttributes.path#DAO"%>
		<%constructor-arg name="dsn"%><%value%>${dsn}<%/value%><%/constructor-arg%>
	<%/bean%>
	<%bean id="#root.bean.xmlAttributes.name#Gateway" class="#root.bean.xmlAttributes.path#Gateway"%>
		<%constructor-arg name="dsn"%><%value%>${dsn}<%/value%><%/constructor-arg%>
	<%/bean%>
	<%bean id="#root.bean.xmlAttributes.name#Service" class="#root.bean.xmlAttributes.path#Service"%>
		<%constructor-arg name="#root.bean.xmlAttributes.name#DAO"%>
			<%ref bean="#root.bean.xmlAttributes.name#DAO"/%>
		<%/constructor-arg%>
		<%constructor-arg name="#root.bean.xmlAttributes.name#Gateway"%>
			<%ref bean="#root.bean.xmlAttributes.name#Gateway"/%>
		<%/constructor-arg%>
	<%/bean%>
<%/beans%>
</cfoutput>
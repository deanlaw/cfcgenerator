<cfoutput>
package #root.bean.xmlAttributes.path#
{
	[RemoteClass(alias="#root.bean.xmlAttributes.path#")]

	[Bindable]
	public class #root.bean.xmlAttributes.name#VO
	{
		<cfloop from="1" to="#arrayLen(root.bean.dbtable.xmlChildren)#" index="i">public var #root.bean.dbtable.xmlChildren[i].xmlAttributes.name#:<cfswitch expression="#root.bean.dbtable.xmlChildren[i].xmlAttributes.type#"><cfcase value="numeric">Number</cfcase><cfcase value="date">Date</cfcase><cfcase value="boolean">Boolean</cfcase><cfdefaultcase>String</cfdefaultcase></cfswitch> = <cfif root.bean.dbtable.xmlChildren[i].xmlAttributes.type eq "string">""<cfelse>Null</cfif>;
		</cfloop>
		public function #root.bean.xmlAttributes.name#VO()
		{
		}

	}
}
</cfoutput>
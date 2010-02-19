<cfcomponent displayName="configBeanStore" hint="This component provides an interface for persistent storage of configBeans data">

	<cfset variables.storeVarName = "_hpModuleConfigBeans">

	<!---------------------------------------->
	<!--- init		                       --->
	<!---------------------------------------->		
	<cffunction name="init" access="public" returntype="configBeanStore">
		<cfreturn this>
	</cffunction>

	<!---------------------------------------->
	<!--- load		                       --->
	<!---------------------------------------->		
	<cffunction name="load" access="public" returnType="configBean"
				hint="Retrieves a configBean from the persisten storage">
		<cfargument name="href" required="true" hint="The page HREF associated to the config bean">
		<cfargument name="key" required="true" hint="Key used to identify the config bean">
		<cfargument name="configBean" required="true" type="configBean" hint="Empty configBean that will be populated with the loaded data">
	
		<cfset var tmpData = "">
		<cfset var st = getStore()>
		
		<cfif structKeyExists(st, arguments.href) and structKeyExists(st[arguments.href], arguments.key)>
			<cfset tmpData = st[arguments.href][arguments.key]>
			<cfset arguments.configBean.deserialize(tmpData)>
		</cfif>
		
		<cfreturn arguments.configBean>
	</cffunction>

	<!---------------------------------------->
	<!--- save		                       --->
	<!---------------------------------------->		
	<cffunction name="save" access="public"
				hint="Stores a configBean into the persistent storage">
		<cfargument name="href" required="true" hint="The page HREF associated to the config bean">
		<cfargument name="key" required="true" hint="Key used to identify the config bean">
		<cfargument name="configBean" required="true" type="configBean" hint="Empty configBean that will be populated with the loaded data">
		<cfset var tmpData = "">
		<cfset var st = getStore()>
		
		<!--- get config bean --->
		<cfset tmpData = arguments.configBean.serialize()>
		
		<!--- check that there is a storage area for the href --->
		<cfif not structKeyExists(st, arguments.href)>
			<cfset st[arguments.href] = structNew()>
		</cfif>
		
		<!--- store config bean --->
		<cfset st[arguments.href][arguments.key] = tmpData>
	</cffunction>

	<!---------------------------------------->
	<!--- exists	                       --->
	<!---------------------------------------->		
	<cffunction name="exists" access="public" returntype="boolean" hint="Checks if given configBean exists on the persistent storage">
		<cfargument name="href" required="true" hint="The page HREF associated to the config bean">
		<cfargument name="key" required="true" hint="Key used to identify the config bean">
		<cfset var st = getStore()>
		<cfreturn structKeyExists(st, arguments.href) and structKeyExists(st[arguments.href], arguments.key)>
	</cffunction>

	<!---------------------------------------->
	<!--- flush		                       --->
	<!---------------------------------------->		
	<cffunction name="flush" access="public" returntype="void" hint="Flushs a configBean from the persistent storage">
		<cfargument name="href" required="true" hint="The page HREF associated to the config bean">
		<cfargument name="key" required="true" hint="Key used to identify the config bean">
		<cfset var st = getStore()>
		<cfif structKeyExists(st, arguments.href)>
			<cfset structDelete(st[arguments.href], arguments.key, false)>
		</cfif>
	</cffunction>

	<!---------------------------------------->
	<!--- flushAll	                       --->
	<!---------------------------------------->		
	<cffunction name="flushAll" access="public"
				hint="Flushes all configBeans from the persistent storage">
		<cfset structDelete(application, variables.storeVarName, false)>
	</cffunction>

	<!---------------------------------------->
	<!--- flushByPageHREF                  --->
	<!---------------------------------------->		
	<cffunction name="flushByPageHREF" access="public"
				hint="Flushes all configBeans associated with the given page HREF from the persistent storage">
		<cfargument name="href" required="true" hint="The page href associated to the config bean">
		<cfset var st = getStore()>
		<cfset structDelete(st, arguments.href, false)>
	</cffunction>
	
	
	<!---- private vars ---->
	<cffunction name="getStore" access="private" returntype="struct" hint="returns the structure used to store the config beans">

		<cfif Not StructKeyExists(application, variables.storeVarName)>
			<cfset application[variables.storeVarName] = structNew()>
		</cfif>

		<cfreturn application[variables.storeVarName]>
	</cffunction>
	
</cfcomponent>
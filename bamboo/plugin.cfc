<cfcomponent extends="homePortals.components.plugin" hint="This plugin loads the jquery and jquery-ui JavaScript frameworks.">
	
	<cffunction name="onConfigLoad" access="public" returntype="homePortalsConfigBean" hint="this method is executed when the HomePortals configuration is being loaded and before the engine is fully initialized. This method should only be used to modify the current configBean.">
		<cfargument name="eventArg" type="homePortalsConfigBean" required="true" hint="the application-provided config bean">	
		<cfset loadConfigFile( getDirectoryFromPath(getcurrentTemplatePath()) & "plugin-config.xml.cfm" ) />
		<cfreturn arguments.eventArg />
	</cffunction>

</cfcomponent>
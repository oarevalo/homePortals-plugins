<cfprocessingdirective pageencoding="utf-8">
<cfparam name="searchTerm" default="">
<cfparam name="resourceID" default="">

<cfscript>
	// get module path
	cfg = this.controller.getModuleConfigBean();
	tmpModulePath = cfg.getModuleRoot();	
	imgRoot = tmpModulePath & "/Images";
	allowExternalContent = true;
	
	stUser = this.controller.getUserInfo();
	siteOwner = stUser.username;
	qryResources = getResourcesForAccount(siteOwner);
	
	// get the moduleID
	moduleID = this.controller.getModuleID();	
</cfscript>

<cfif searchTerm neq "">
	<cfquery name="qryResources" dbtype="query">
		SELECT *
			FROM qryResources
			WHERE ( upper(id) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(searchTerm)#%">
					OR upper(package) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(searchTerm)#%">  
					)
			ORDER BY package, id
	</cfquery>
</cfif>


<div style="background-color:#f5f5f5;">
<div style="padding:0px;width:490px;">

	<div style="margin:5px;background-color:#333;border:1px solid silver;color:#fff;">
		<div style="margin:5px;">
			<cfoutput><strong>#getResourceType()#Box:</strong> Search Directory </cfoutput>
		</div>
	</div>

<cfoutput>
	<div style="margin:5px;text-align:right;background-color:##ebebeb;border:1px solid silver;">
		<div style="margin:5px;"> 
			<b>Search content:</b>
			<input type="text" name="txtSearch" id="h_txtSearchFeed" value="#searchTerm#">
			<input type="button" name="btnSearch" value="Search" onclick="#moduleID#.getPopupView('directory',{searchTerm:$('h_txtSearchFeed').value})">
		</div>
	</div>
</cfoutput>

<div style="width:490px;margin-top:5px;">
	<div style="width:150px;height:400px;border:1px solid silver;float:left;margin-left:5px;background-color:#fff;">

		<div style="margin:3px;line-height:16px;font-size:11px;">
			<cfoutput query="qryResources" group="package">
				<div class="rd_packageTitle">
					<a href="##" onclick="Element.toggle('cp_feedGroup#qryResources.currentRow#');return false;" style="color:##333;font-weight:bold;">&raquo; #qryResources.package#</a>
				</div>
				<div style="display:none;margin-left:10px;margin-bottom:8px;" id="cp_feedGroup#qryResources.currentRow#"> 
					<cfoutput>
						<cfset tmpName = qryResources.id>
						<a href="##" 
							onclick="#moduleID#.getView('contentInfo','cb_moduleInfo',{resourceID:'#jsstringFormat(qryResources.id)#'})" 
							style="color:##333;">#tmpName#</a><br>
					</cfoutput>
				</div>
			</cfoutput>
		</div>

	</div>
	<div style="width:320px;height:400px;border:1px solid silver;margin-left:160px;background-color:#fff;">
		<div id="cb_moduleInfo_BodyRegion" style="margin:10px;line-height:18px;font-size:12px;">	
			<br>
			Select from the directory on the left the content element you wish to add to your page.
		</div>
	</div>
</div>
<br style="clear:both;" />

</div>
</div>

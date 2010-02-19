<cfparam name="resourceID" default="">

<cfscript>
	contentLocation = "";
	bContentFound = true;
	txtDoc = "";
	resourceType = getResourceType();
	contentTitle = resourceType & "Box";
	
	// get module path
	cfg = this.controller.getModuleConfigBean();
	tmpModulePath = cfg.getModuleRoot();	
	imgRoot = tmpModulePath & "/images";
	allowExternalContent = true;
	
	// get current user info
	stUser = this.controller.getUserInfo();
		
	// get the moduleID
	moduleID = this.controller.getModuleID();
	
	// get settings
	if(resourceID eq "") resourceID = cfg.getPageSetting("resourceID","");	
	
	// get the content entry from the catalog
	try {
		oResourceBean = this.controller.getHomePortals().getCatalog().getResourceNode(getResourceType(),resourceID);
		
	} catch(homePortals.catalog.resourceNotFound e) {
		bContentFound = false;
	} catch(homePortals.catalog.resourceTypeNotFound e) {
		bContentFound = false;
	}

	// check if current user is owner
	bIsContentOwner = (stUser.isOwner and not bContentFound)
						or
					 	(bContentFound and stUser.isOwner);
	
	// get resource library root
	hpConfigBean = this.controller.getHomePortalsConfigBean();
	resourcesRoot = hpConfigBean.getResourceLibraryPath();
	
</cfscript>

<!--- If no content found, then exit --->
<cfif Not bContentFound>

	<cfif resourceID eq "">
		<cfif stUser.isOwner>
			<em>Select a content entry to display</em>
		<cfelse>
			<em>No content selected</em>
		</cfif>
	<cfelse>
		<em>Content entry not found!</em>
	</cfif>

<cfelse>

	<!--- get the content location --->
	<cfset contentLocation = oResourceBean.getHref()>

	<!--- Check if there is a title for this entry --->
	<cfset contentTitle = resourceID>

	<!--- Check if this is an external content or local content --->
	<cfif left(contentLocation, 4) eq "http">
		<cfif allowExternalContent>
			<cfhttp url="#contentLocation#" method="get" timeout="20" resolveURL="yes" />
			<cfset txtDoc = cfhttp.fileContent> 
		<cfelse>
			<b>External content is not allowed!</b>
		</cfif>
	<cfelse>
		<cfset contentLocation = oResourceBean.getFullHref()>
		<cfif fileExists(expandPath(contentLocation))>
			<cffile action="read" file="#expandPath(contentLocation)#" variable="txtDoc">
		<cfelse>
			<b>Content not found!</b>
			<cfset resourceID = "">
		</cfif>
	</cfif>
</cfif>

<cfoutput>
	<!--- output content --->
	#txtDoc#
	
	<!--- change module title --->
	<script>
		h_setModuleContainerTitle("#moduleID#", "#jsstringformat(contentTitle)#");
	</script>	
	
	<cfif stUser.isOwner>
		<div class="SectionToolbar">
			<a href="javascript:#moduleID#.getPopupView('edit');"><img src="#imgRoot#/add-page-orange.gif" border="0" align="absmiddle"></a>
			<a href="javascript:#moduleID#.getPopupView('edit');">New</a>
			&nbsp;&nbsp;
			<cfif bIsContentOwner and resourceID neq "">
				<a href="javascript:#moduleID#.getPopupView('edit',{resourceID:'#resourceID#'});"><img src="#imgRoot#/edit-page-yellow.gif" border="0" align="absmiddle"></a>
				<a href="javascript:#moduleID#.getPopupView('edit',{resourceID:'#resourceID#'});">Edit</a>
				&nbsp;&nbsp;
			</cfif>
			<a href="javascript:#moduleID#.getPopupView('directory');"><img src="#imgRoot#/page_white_text.png" border="0" align="absmiddle"></a>
			<a href="javascript:#moduleID#.getPopupView('directory');">Content Directory</a>&nbsp;&nbsp;
		</div>
	</cfif>
</cfoutput>

